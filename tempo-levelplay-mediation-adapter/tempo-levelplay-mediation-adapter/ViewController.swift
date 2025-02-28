import UIKit
import IronSource
import TempoSDK
import tempo_ios_levelplay_mediation
import CoreLocation

let prodKey = "1fd0acc6d"
let devKey = "1fd0a92e5"
let interstitial_dev = "g4jobam1trpa6w7u"
let rewarded_dev = "kwunc0khisl2tzo9"
let interstitial_prod = "2k6obh94cjawofzt"
let rewarded_prod = "lhnxg1houy7g5ub6"

let kAPPKEY = Constants.environment == Constants.Environment.DEV ? devKey: prodKey
let kAPPID_INT = Constants.environment == Constants.Environment.DEV ? interstitial_dev: interstitial_prod
let kAPPID_REW = Constants.environment == Constants.Environment.DEV ? rewarded_dev: rewarded_prod

class ViewController: UIViewController, LPMInterstitialAdDelegate, LPMRewardedAdDelegate, ISInitializationDelegate, ISImpressionDataDelegate {
    
    var locationManager: CLLocationManager?
    var interstitialAd: LPMInterstitialAd?
    var rewardedAd: LPMRewardedAd?
    
    /// Button outlet
    @IBOutlet weak var rewardedLoadBtn: UIButton!
    @IBOutlet weak var rewardedShowBtn: UIButton!
    @IBOutlet weak var interstitialLoadBtn: UIButton!
    @IBOutlet weak var interstitialShowBtn: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    /// Button actions
    @IBAction func rewardedLoadBtnAction(_ sender: Any) {
        rewardedAd?.loadAd()
    }
    @IBAction func rewardedShowBtnAction(_ sender: Any) {
        // Check that ad is ready
        if ((self.rewardedAd?.isAdReady()) != nil) {
            self.rewardedAd?.showAd(viewController: self, placementName: "")
        }
    }
    @IBAction func interstitialLoadBtnAction(_ sender: Any) {
        interstitialAd?.loadAd()
    }
    @IBAction func interstitialPlayBtnAction(_ sender: Any) {
        if ((self.interstitialAd?.isAdReady()) != nil) {
            // Show without placement
            self.interstitialAd?.showAd(viewController: self, placementName: nil)
        }
    }
    @IBAction func LocationConsent(_ sender: Any) {
        //TempoUtils.requestLocation()
        print("🤷‍♂️ requestWhenInUseAuthorization (button)")
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
    }
    
    /// Initial actions on when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialise ironSource listeners and SDK
        self.setupIronSourceSdk()
        self.interstitialAd = LPMInterstitialAd(adUnitId: kAPPID_INT)
        self.interstitialAd?.setDelegate(self)
        self.rewardedAd = LPMRewardedAd(adUnitId: kAPPID_REW)
        self.rewardedAd?.setDelegate(self)
        
        // Set up UI Buttons etc
        initUIElements()
    }
    
    /// Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupIronSourceSdk() {
        
        // Create a request builder with app key. Add User ID if available
        let requestBuilder = LPMInitRequestBuilder(appKey: kAPPKEY)
            .withUserId("UserId")
        
        // Build the initial request
        let initRequest = requestBuilder.build()
        
        // Initialize LevelPlay with the prepared request
        TempoUtils.say(msg: "👀 Initialising...")
        LevelPlay.initWith(initRequest)
        { config, error in
            if let error = error {
                // There was an error on initialization. Take necessary actions or retry
                TempoUtils.say(msg: "❌ Init error: \(error)")
            } else {
                // Initialization was successful. You can now load ad or perform other tasks
                TempoUtils.say(msg: "⭐️ Init success")
            }
        }
    }
    
    /// Initialisation functions
    func initializationDidComplete() {
        TempoUtils.say(msg: "⭐️ initializationDidComplete")
    }
    
    /// Initialize the UI elements of the activity
    func initUIElements() {
        // Update version label
        self.versionLabel.text =  String(format: "%@%@", "IronSource SDK: ", IronSource.sdkVersion());
    }
    
    
    func didLoadAd(with adInfo: LPMAdInfo) {
        TempoUtils.say(msg: ISTempoUtils.adUnitStringerLP(adInfo: adInfo));
    }
    
    func didFailToLoadAd(withAdUnitId adUnitId: String, error: any Error) {
        TempoUtils.say(msg: String(describing: error.self));
    }
    
    func didDisplayAd(with adInfo: LPMAdInfo) {
        TempoUtils.say(msg: ISTempoUtils.adUnitStringerLP(adInfo: adInfo));
    }
    
    @objc(didLoadWithAdInfo:) func didLoad(with adInfo: ISAdInfo!) {
        TempoUtils.say(msg: ISTempoUtils.adUnitStringerIS(adInfo: adInfo));
    }
    
    @objc func didFailToLoadWithError(_ error: (any Error)!) {
        TempoUtils.say(msg: "Failed to load: " + String(describing: error.self));
    }
    
    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!, with adInfo: ISAdInfo!) {
        // NEVER GETS CALLED BY OUR ADAPTER
        TempoUtils.say(msg: "\(placementInfo.placementName ?? "NO_PLACEMENT") | \(ISTempoUtils.adUnitStringerIS(adInfo: adInfo))")
    }
    
    @objc func didFailToShowWithError(_ error: (any Error)!, andAdInfo adInfo: ISAdInfo!) {
        TempoUtils.say(msg: "\(String(describing: error.self)) |  \(ISTempoUtils.adUnitStringerIS(adInfo: adInfo))");
    }
    
    @objc(didOpenWithAdInfo:) func didOpen(with adInfo: ISAdInfo!) {
        TempoUtils.say(msg: ISTempoUtils.adUnitStringerIS(adInfo: adInfo));
    }
    
    func didClick(_ placementInfo: ISPlacementInfo!, with adInfo: ISAdInfo!) { // NEVER GETS CALLED BY OUR ADAPTER
        TempoUtils.say(msg: ISTempoUtils.adUnitStringerIS(adInfo: adInfo));
    }
    
    @objc(didCloseWithAdInfo:) private func didClose(with adInfo: ISAdInfo!) {
        TempoUtils.say(msg: ISTempoUtils.adUnitStringerIS(adInfo: adInfo));
    }
    
    func didRewardAd(with adInfo: LPMAdInfo, reward: LPMReward) {
        TempoUtils.say(msg: ISTempoUtils.adUnitStringerLP(adInfo: adInfo));
    }
    
    
    
    
    
    
//    /// LevelPlayInterstitialDelegate functions
//    func didShow(with adInfo: ISAdInfo!) {
//        TempoUtils.say(msg: ISTempoUtils.adUnitStringer(adInfo: adInfo));
//    }
//    func didClick(with adInfo: ISAdInfo!) { // NEVER GETS CALLED BY OUR ADAPTER
//        TempoUtils.say(msg: ISTempoUtils.adUnitStringer(adInfo: adInfo));
//    }
//    
//    /// LevelPlayRewardedVideoDelegate functions
//    func hasAvailableAd(with adInfo: ISAdInfo!) {
//        TempoUtils.say(msg: "****** Has Video: \(IronSource.hasRewardedVideo()) | \(ISTempoUtils.adUnitStringer(adInfo: adInfo))")
//    }
//    func hasNoAvailableAd() {
//    }
//    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!, with adInfo: ISAdInfo!) { // NEVER GETS CALLED BY OUR ADAPTER
//        TempoUtils.say(msg: "\(placementInfo.placementName ?? "NO_PLACEMENT") | \(ISTempoUtils.adUnitStringer(adInfo: adInfo))")
//    }
//    func didClick(_ placementInfo: ISPlacementInfo!, with adInfo: ISAdInfo!) { // NEVER GETS CALLED BY OUR ADAPTER
//        TempoUtils.say(msg: "\(placementInfo.placementName ?? "NO_PLACEMENT") | \(ISTempoUtils.adUnitStringer(adInfo: adInfo))");
//    }
//    
    /// BOTH Reward/Interstitalfunctions
    // MARK: LPMInterstitialAdDelegate methods
//    @objc(didLoadAdWithAdInfo:) func didLoadAd(with adInfo: LPMAdInfo) {
//        TempoUtils.say(msg: ISTempoUtils.adUnitStringer(adInfo: adInfo));
//    }
//    func didFailToLoadWithError(_ error: Error!) {
//        TempoUtils.say(msg: String(describing: error.self));
//    }
//    func didFailToLoadAd(withAdUnitId adUnitId: String, error: any Error) {
//        TempoUtils.say(msg: String(describing: error.self));
//    }
    
    
    
    

    
    
//
//    func didOpen(with adInfo: LPMAdInfo!) {
//        TempoUtils.say(msg: ISTempoUtils.adUnitStringer(adInfo: adInfo));
//    }
//    func didFailToShowWithError(_ error: Error!, andAdInfo adInfo: LPMAdInfo!) { // NEVER GETS CALLED BY OUR ADAPTER
//        TempoUtils.say(msg: "\(String(describing: error.self)) |  \(ISTempoUtils.adUnitStringer(adInfo: adInfo))");
//    }
//    func didClose(with adInfo: ISAdInfo!) {
//        TempoUtils.say(msg: ISTempoUtils.adUnitStringer(adInfo: adInfo));
//    }
    
    // Impressions functions
    func impressionDataDidSucceed(_ impressionData: ISImpressionData!) {
        TempoUtils.say(msg: impressionData.all_data?.debugDescription ?? "NO_ALL_DATA");
    }


}

