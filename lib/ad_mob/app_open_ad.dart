import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hasanat/ad_manger.dart';

class AppOpenAdManager {


  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;


  void loadAd() {
    AppOpenAd.load(
      adUnitId: AdManger.appOpenAd,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
         if(_appOpenAd != null){
           _appOpenLoadTime = DateTime.now();
           _appOpenAd!.show();
         }
         ad.fullScreenContentCallback = FullScreenContentCallback(
           onAdDismissedFullScreenContent: (ad) {
             ad.dispose();
           },
           onAdFailedToShowFullScreenContent: (ad, error) {
             ad.dispose();
           },
         );
        },
        onAdFailedToLoad: (error) {

          // Handle the error.
        },
      ),
    );
  }
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {

      loadAd();
      return;
    }
    if (_isShowingAd) {

      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {

      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;

      },
      onAdFailedToShowFullScreenContent: (ad, error) {

        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {

        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
  }

}



class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    // Try to show an app open ad if the app is being resumed and
    // we're not already showing an app open ad.
    if (appState == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}