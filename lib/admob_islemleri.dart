import 'package:firebase_admob/firebase_admob.dart';

class AdmobIslemleri{
  static final String appIdCanli = "ca-app-pub-6476986718575468~6423836450";
  static final String appIdTest = FirebaseAdMob.testAppId;
  static int kacKereGosterildi = 0;
  static final String banner1Canli = "ca-app-pub-6476986718575468/4442355152";
  static final String odulluReklamTest = RewardedVideoAd.testAdUnitId;

  static admobInitialize(){
    FirebaseAdMob.instance.initialize(appId: appIdTest);
  }

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutter', 'chat apps'],
    contentUrl: 'https://fatihtutar.com',
    childDirected: false,// or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>['E479ED0F23221F6566964E0C531BF039'], // Android emulators are considered test devices
  );

  static BannerAd buildBannerAd(){
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if(event == MobileAdEvent.loaded){
          print("Banner yüklendi");
        }
      },
    );
  }

  static InterstitialAd buildInterstitialAd (){
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }
}