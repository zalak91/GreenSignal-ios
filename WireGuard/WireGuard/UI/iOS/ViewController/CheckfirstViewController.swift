// SPDX-License-Identifier: MIT
// Copyright © 2018-2019 WireGuard LLC. All Rights Reserved.

import UIKit
import ReachabilitySwift
import UserNotifications
import Alamofire
import SwiftyJSON
import Firebase
import NetworkExtension
import Crashlytics
import Loaf
import MKProgress
class CheckfirstViewController: UIViewController {

private var statusObservationToken: AnyObject?
    var tunnelsManager: TunnelsManager?
    var tunnel : TunnelContainer?
    var onTunnelsManagerReady: ((TunnelsManager) -> Void)?
    var tunnelsListVC: TunnelsListTableViewController?
    var countryvc : CountrySelectionViewController?

    @IBOutlet weak var settingimg: UIImageView!
    @IBOutlet var sv: UIView!
    @IBOutlet var mainview: UIView!

    @IBOutlet var statuslbl: UILabel!
    @IBOutlet var lockimageview: UIImageView!

    @IBOutlet var statusbtn: UISwitch!

    @IBOutlet var optionmenuview: SpringView!
    @IBOutlet var switchButton: SevenSwitch!

    @IBOutlet weak var bottomview: UIView!


    @IBOutlet weak var locationview: UIView!

    @IBOutlet var statusview: UIView!

    @IBOutlet var shareview: UIView!

    @IBOutlet var settingview: UIView!

    @IBOutlet weak var bottomstatuslbl: UILabel!

    @IBOutlet weak var locationlbl: UILabel!

    @IBOutlet weak var locationpinimg: UIImageView!


    @IBOutlet weak var optionbtn: UIButton!
    @IBOutlet weak var dropmenuimg: UIImageView!


    var myActivityIndicator : UIActivityIndicatorView?
    var devicetoken = ""
    var vpnkey = ""
    var pvkey = ""
    var pubkey = ""
    var dns = ""
    var myaddress = ""
    var endpoint = ""
    var presharekey = ""
    var defaultlocationId = "0"
    var selectedlocationid = ""
    var isExists = ""
    var mydate : Date?
    var receivedata:UInt64?
    var sentdata:UInt64?
    var connectiontype = ""
    var fromswitchbtn = ""
    var modifytunnel = ""

     //#MARK: view methods

    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside checkfirstvc viewDidLoad")
        //      optionmenudesign()
        //        countryviewdesign()

        switchLoader()
        addObservers()

        ThemeManager.applyTheme(theme: ThemeManager.currentTheme())

        switchButton.addTarget(self, action: #selector(switchChanged(_:)), for: UIControl.Event.touchUpInside)

        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name: .refresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tunnelStatus), name: .tunnelStatus, object: nil)

        customLoaderUI()
        checkTunnelStatusByTunnelmanager(tunnelmanager: self.tunnelsManager!)
        refereshView()
        // ArgAppUpdater.getSingleton().showUpdateWithConfirmation()
    }




    override func viewWillAppear(_ animated: Bool) {
        print("inside checkfirstvc viewwillappear")
        adddidbecomeactiveobserver()

        ReachabilityManager.shared.addListener(listener: self)
        self.navigationController?.isNavigationBarHidden = true

        if selectedlocationid.isEmpty{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
            self.internetConnectionCheck()
            }
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        print("inside checkfirstvc viewdiddisappear")
        removedidbecomeactiveobserver()
        super.viewDidDisappear(animated)
        ReachabilityManager.shared.removeListener(listener: self)
    }


    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeUpdated, object: nil)

    }

    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeTheme), name: .themeUpdated, object: nil)
    }

     // MARK: Internetconnection status check method
    fileprivate func internetConnectionCheck() {

        ApiManager.sharedInstance.networkcheckapicall(timeoutinterval: 10) { (networkstatus) in
            if(UserDefaults.standard.isLoggedIn() == true) {
//                let tunnel = self.tunnelsManager!.tunnel(named: Constants.tunnelName)!
                if networkstatus == false{
                    print("network off")
                    if self.tunnel!.status == .active {
                        DispatchQueue.main.async {
//                            self.locationview.isHidden = true
//                            self.statuslbl.text = "No Internet Connection"
                            self.nointernetwhileconnected()
                        }

                    }else if self.tunnel!.status == .inactive{
                        DispatchQueue.main.async {
                            self.nointernetwhiledisconnected()
                        }
                    }

                }
                else{
                    print("network on")

                    if self.tunnel!.status == .active {
                        DispatchQueue.main.async {
                            self.connectedUI()
                        }

                    }
                    if self.tunnel!.status == .inactive {

                        DispatchQueue.main.async {
                            self.disconnectedUI()
                        }

                    }
                }
            }else{
                if networkstatus == false{
                    print("network off")
                    self.nointernetwhiledisconnected()

                }
                else{
                    print("network on")
                    self.callRegisterapi()
                }
            }
        }
    }



    // MARK: TunnelStatus by Noticiation
    @objc func tunnelStatus(_ notification: Notification) {
        if let object = notification.object as? NEVPNStatus {

            print("tunnel notification status",object)
            checkNEStatus(status: object)

        }
    }

    //MARK: checkStatus method
    func checkNEStatus( status: NEVPNStatus) {

        var btnstatus = ""

        switch status {
        case .invalid:
            print("checkNEStatus NEVPNConnection: Invalid")
        case .disconnected:
            print("checkNEStatus NEVPNConnection: Disconnected")
            btnstatus = "Connect"
        case .connecting:
            print("checkNEStatus NEVPNConnection: Connecting")
            btnstatus = "Connecting"
        case .connected:
            print("checkNEStatus NEVPNConnection: Connected")
            btnstatus = "Disconnect"
        case .reasserting:
            print("checkNEStatus NEVPNConnection: Reasserting")
        case .disconnecting:
            btnstatus = "Disconnecting"
            print("checkNEStatus NEVPNConnection: Disconnecting")
        @unknown default:
            print("checkNEStatus NEVPNConnection: no tunnel")
        }


        let tunnel = self.tunnelsManager!.tunnel(named: Constants.tunnelName)!

        print("checkNEStatus",status)


        if("\(status)" == "disconnected") {


            if !self.selectedlocationid.isEmpty
            {
                print("inside the check status new country click")
                self.connectingUI()
                self.startSwitchLoader()
                self.tunnelsManager?.startActivation(of: tunnel)

            }else{
                self.stopSwitchLoader()
                self.disconnectedUI()
            }
        } else if("\(status)" == "connected") {

            if !self.selectedlocationid.isEmpty
            {
                self.selectedlocationid = ""
                self.modifytunnel = ""
            }
            connectedUI()
            self.stopSwitchLoader()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.callEchoAPI()
            }

        }
        else if("\(status)" == "disconnecting")
        {
            disconnectingUI()
        }else if ("\(status)" == "connecting")
        {
            connectingUI()
        }

    }


    fileprivate func customLoaderUI() {
        //  MKProgress.config.hudType = .radial
        MKProgress.config.circleBorderColor = UIColor(hexString: "#22CC77")
        MKProgress.config.logoImage = UIImage(named: "AppLogo")
        MKProgress.config.logoImageSize = CGSize(width: 110, height: 110)
        MKProgress.config.backgroundColor = .gray
        MKProgress.config.circleBorderWidth = 8
        MKProgress.config.height = 180.0
        MKProgress.config.width = 180.0
        MKProgress.config.circleRadius = 80.0
        MKProgress.config.hudColor = .clear
    }

    @objc fileprivate func changeTheme() {
        view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
        self.view.backgroundColor = view.backgroundColor
        //self.statuslbl.textColor = ThemeManager.currentTheme().ConnectedTextColor
        self.bottomstatuslbl.textColor = ThemeManager.currentTheme().locationAndOtherTextColor
        self.bottomview.backgroundColor = ThemeManager.currentTheme().ConnectedBottomView
        self.locationlbl.textColor = ThemeManager.currentTheme().locationAndOtherTextColor
        self.switchButton.inactiveColor = ThemeManager.currentTheme().DisconnectSwitchColor
        self.switchButton.activeColor = ThemeManager.currentTheme().ConnectSwitchColor
        self.settingimg.image = ThemeManager.currentTheme().settingimg
        self.locationpinimg.image = ThemeManager.currentTheme().countrypinmainimg
        self.dropmenuimg.image = ThemeManager.currentTheme().dropmenumainimg

        self.locationview.layer.cornerRadius = locationview.frame.size.height / 2
        self.locationview.layer.borderColor = ThemeManager.currentTheme().LocationViewColor.cgColor
        self.locationview.layer.borderWidth = 1
    }




    fileprivate func removeConnectedDate() {
        UserDefaults.standard.removeObject(forKey: "startdate")
        UserDefaults.standard.synchronize()
    }

    fileprivate func refereshView() {
        if(UserDefaults.standard.isLoggedIn() == true) {


            self.locationlbl.text = UserDefaults.standard.getlocationName()
            if tunnel!.status == .active {
                connectedUI()

            }
            else if tunnel!.status == .inactive
            {

                disconnectedUI()
                callRegisterapi()

            }
        }else{
            disconnectedUI()
            callRegisterapi()
        }

    }





    fileprivate func removedidbecomeactiveobserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    fileprivate func adddidbecomeactiveobserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
            object: nil)
   }



    @objc func applicationDidBecomeActive() {
        // handle event
        print("checkfirstvc page observer fire")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
            self.internetConnectionCheck()
        }

    }


    @IBAction func countryselectionbtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "countrylistVC") as? CountrySelectionViewController
        vc?.barbuttontitle = ""
        self.navigationController?.pushViewController(vc!, animated: true)

        }


    // MARK: Getcountry by Noticiation
    @objc func refreshList(_ notification: Notification) {
        if let object = notification.object as? [String: Any] {
            if let countryId = object["countryId"] as? String {
                self.selectedlocationid = countryId
                print("countryID in notification get method in home VC = ",countryId)

                if tunnel!.status == .active{
                     tunnelsManager!.startDeactivation(of: tunnel!)
                }
                self.connectingUI()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {

                    // your code here
                    self.modifytunnel = "modify"
                    self.callRegisterapi()
                }


            }
            if let countryName = object["countryName"] as? String {
                self.locationlbl.text =  countryName
                print("country Name in notification get method in home VC = ",countryName)
            }
        }
    }

    // MARK: Switchindicatorloader

    func switchLoader() {
         myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

        // Position Activity Indicator in the center of the main view
        myActivityIndicator!.center = self.switchButton.thumbView.center

        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator!.hidesWhenStopped = false
        myActivityIndicator?.isHidden = true
        // Start Activity Indicator

        myActivityIndicator!.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.switchButton.thumbView.addSubview(myActivityIndicator!)


    }

    func startSwitchLoader()   {
        myActivityIndicator?.isHidden = false
        myActivityIndicator!.startAnimating()
    }
    func stopSwitchLoader()   {
        myActivityIndicator?.isHidden = true
        myActivityIndicator!.stopAnimating()
    }

    func callRegisterapi()
    {
        if(UserDefaults.standard.isLoggedIn() == true) {

          //  print("Don't genrate public key and private key")
            //All ready installed in app and genrated keys for same.
            // Use all ready Genrated publickey and private key

            self.registerdevice(pubkey: UserDefaults.standard.ispublickey(), devicetoken:UserDefaults.standard.isdevicetoken())
        }
        else
        {
            if(UserDefaults.standard.isgetapiatatus() == true)
            {

              //  print("Don't genrate public key and private key")
                //All ready installed in app and genrated keys for same.
                // Use all ready Genrated publickey and private key

                self.registerdevice(pubkey: UserDefaults.standard.ispublickey(), devicetoken:UserDefaults.standard.isdevicetoken())
            }
            else{
                //New installation in app and genrated keys for same.
                // print("genrate public key and private key")
                // Genrate publickey and private key

                let privateKey = Curve25519.generatePrivateKey()
                let publicKey = Curve25519.generatePublicKey(fromPrivateKey: privateKey)
                //    print("private key",privateKey.base64Key())
                //   print("public key",publicKey.base64Key())



                UserDefaults.standard.setpublickkey(value: publicKey.base64Key()!)
                UserDefaults.standard.setprivatekkey(value: privateKey.base64Key()!)
                UserDefaults.standard.setstatusapi(value: true)
                UserDefaults.standard.synchronize()

                self.registerdevice(pubkey: UserDefaults.standard.ispublickey(), devicetoken: UserDefaults.standard.isdevicetoken())
            }
        }
    }

    func registerdevice(pubkey : String, devicetoken:String)
    {

        ApiManager.sharedInstance.networkcheckapicall(timeoutinterval: 3) { (networkstatus) in
            if networkstatus == false{
                print("network off in registerdevice")
                DispatchQueue.main.async {
                   // MKProgress.show(false)
                    let alert = UIAlertController(title: Constants.tunnelName,
                                                  message: "No Internet connection",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }

            }
            else
            {
//                DispatchQueue.main.async {
//                     MKProgress.show(true)
//                }

                var countryId = ""
                if !self.selectedlocationid.isEmpty{
                    countryId = self.selectedlocationid

                }else{
                    if(UserDefaults.standard.isLoggedIn() == true)
                    {
                        if(UserDefaults.standard.getlocationId() == ""){
                            countryId = self.defaultlocationId
                        }
                        else{
                            countryId = UserDefaults.standard.getlocationId()
                        }
                    }else{
                        countryId = self.defaultlocationId
                    }
                }

                let params = [Constants.Apikeys.Devicepublickkey:pubkey,
                              Constants.Apikeys.Devicetoken:devicetoken,
                              Constants.Apikeys.Countryid : countryId,
                              Constants.Apikeys.Devicetype : "2"]
                print("params",params)
                ApiManager.sharedInstance.postAPICalls(apiURL: Constants.APIURLS.globalapiUrl+Constants.MethodName.resgitermethod, params: params, onSuccess: {
                    jsondata in

                    do {
                        let json = try JSONSerialization.jsonObject(with: jsondata, options: [])
                        print("Rsponse JSON data",json)


                        if let responseData = json as? [String: Any] { // Parse dictionary


                            if let successcode = responseData["code"] as? Int{
                                if successcode == 200{
                                    if let data = responseData["response"] as? [String: Any] {
                                       //  Parse an array containing dictionaries

                                                if data["clientIp"] != nil{
                                                    self.myaddress =  data["clientIp"]! as! String

                                                    //      print("clientiIp",data!["clientIp"])
                                                }
                                                if data["dnsIp"] != nil{
                                                    self.dns = data["dnsIp"]! as! String
                                                    //     print("dnsIp",data!["dnsIp"])
                                                }
                                                if data["serverIp"] != nil{

                                                    //    print("serverIp",data!["serverIp"])
                                                }
                                                if data["serverPublicKey"] != nil{
                                                    self.pubkey = data["serverPublicKey"]! as! String
                                                    //    print("serverPublicKey",data!["serverPublicKey"])
                                                }
                                                if data["serverEndpoint"] != nil{
                                                    self.endpoint = data["serverEndpoint"]! as! String
                                                    //    print("serverEndpoint",data!["serverEndpoint"])
                                                }
                                                if data["allowedIPs"] != nil{

                                                    //   print("allowedIPs",data!["allowedIPs"])
                                                }
                                                if data["devicePublicKey"] != nil{

                                                    //   print("devicePublicKey",data!["devicePublicKey"])
                                                }

                                                if data["isExists"] != nil{

                                                    self.isExists = data["isExists"]! as! String
                                                }

                                                if data["locationId"] != nil{

                                                    UserDefaults.standard.setselectedLocationId(value: data["locationId"]! as! String)
                                                }

                                                if data["locationName"] != nil{

                                                    UserDefaults.standard.setselectedLocationName(value: data["locationName"]! as! String)
                                                }

                                        let vpnkeystring: String = "[Interface]\nPrivateKey = \(UserDefaults.standard.isprivatekey())\nAddress = \(self.myaddress)\nDNS = \(self.dns)\n\n[Peer]\nPublicKey = \(self.pubkey)\nAllowedIPs = 0.0.0.0/0, ::/0\nEndpoint =\(self.endpoint)\n"

                                        print("vpnketstring in api method",vpnkeystring)

                                        UserDefaults.standard.setvpnkey(value: vpnkeystring)
                                        UserDefaults.standard.synchronize()
                                        //   print("vpnkey userdefault",UserDefaults.standard.isvpnkey())


                                        if self.isExists == "0"{
                                            self.modifytunnel = "modify"
                                        }

                                        if(UserDefaults.standard.isLoggedIn() == true)
                                        {
                                            if !self.selectedlocationid.isEmpty || self.isExists == "0"
                                            {
                                                if self.modifytunnel == "modify"{
                                                    self.modifyTunnel(tunnelsManager: self.tunnelsManager!)

                                                }
                                            }
                                        }
                                        DispatchQueue.main.async {
                                            self.locationlbl.text = (data["locationName"]! as! String)
                                           // MKProgress.hide(true)
                                        }


                                    }
                                }else{
                                    DispatchQueue.main.async {

                                      //  MKProgress.hide(true)
                                        let vc = UIStoryboard.init(name: "MainStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "countrylistVC") as? CountrySelectionViewController
                                        vc?.barbuttontitle = ""
                                        self.navigationController?.pushViewController(vc!, animated: true)
                                    }

                                }
                            }
                        }
                    } catch {
                        print(error)
                    }
                }, onFailure: {
                    error in
                    DispatchQueue.main.async {
                      //  MKProgress.hide(true)
                        let alert = UIAlertController(title: "GreenSignal",
                                                      message: error.localizedDescription,
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    }

                })
            }
        }
    }



    @IBAction func optionmenubtn(_ sender: Any) {
        // optionmenuview.animate()

        //  navigation pushviewcontroller code
        let vc = UIStoryboard.init(name: "MainStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "settingsVC") as? SettingsViewController
        vc?.setTunnelsManager(tunnelsManager: self.tunnelsManager!)
        self.selectedlocationid = ""
        vc?.connectiontype = "\(ReachabilityManager.shared.reachability.currentReachabilityStatus)"
        self.navigationController?.pushViewController(vc!, animated: true)

    }



    //    func optionmenudesign(){
    //
    //        optionmenuview.backgroundColor = UIColor.white
    //        optionmenuview.layer.cornerRadius = 10.0
    //        //optionmenuview.layer.borderColor = UIColor.lightGray.cgColor
    //       // optionmenuview.layer.borderWidth = 0.1
    //        optionmenuview.layer.shadowOpacity = 1
    //        optionmenuview.layer.shadowRadius = 10.0
    //        optionmenuview.layer.shadowOffset = CGSize(width: 0, height: 0)
    //        optionmenuview.layer.shadowColor = UIColor.lightGray.cgColor
    //       // optionmenuview.layer.masksToBounds = true
    //        statusview.layer.borderWidth = 0
    //        shareview.layer.borderWidth = 0
    //        settingview.layer.borderWidth = 0
    //
    //        statusview.backgroundColor = .clear
    //        statusview.layer.borderWidth = 0
    //        statusview.layer.borderColor = UIColor.clear.cgColor
    //        shareview.backgroundColor = .clear
    //        settingview.backgroundColor = .clear
    //      //  optionmenuview.roundCorners([.topLeft, .bottomLeft ,. topRight , .bottomRight], radius: 5.0)
    //
    //
    //
    //
    //
    //    }

//        func countryviewdesign(){
//
//            locationview.backgroundColor = UIColor.white
//            locationview.layer.cornerRadius = locationview.frame.size.height / 2
//            locationview.layer.borderColor = UIColor.gray.cgColor
//            locationview.layer.borderWidth = 1
//            //locationview.layer.shadowOpacity = 1
////            locationview.layer.shadowRadius = 10.0
////            locationview.layer.shadowOffset = CGSize(width: 0, height: 0)
////            locationview.layer.shadowColor = UIColor.lightGray.cgColor
//           // optionmenuview.layer.masksToBounds = true
//
//          //  optionmenuview.roundCorners([.topLeft, .bottomLeft ,. topRight , .bottomRight], radius: 5.0)
//
//
//
//
//
//        }



    fileprivate func connectedUI() {
        self.statuslbl.text = "Connected"
        self.stopSwitchLoader()
        self.bottomstatuslbl.text = "Your search is secure Now!"
        self.lockimageview.image = UIImage(named: "Connectimg")
        self.statuslbl.textColor = ThemeManager.currentTheme().ConnectedTextColor
        self.locationview.isHidden = false
        self.switchButton.setOn(true, animated: true)

    }

    fileprivate func nointernetwhileconnected() {
        self.statuslbl.text = "No Internet Connection"
        self.bottomstatuslbl.text = "Currently not connected to the internet!"
        self.lockimageview.image = UIImage(named: "Connectimg")
        self.statuslbl.textColor = ThemeManager.currentTheme().ConnectedTextColor
        self.locationview.isHidden = true
        self.switchButton.setOn(true, animated: true)

    }

    func connectingUI()  {

        DispatchQueue.main.async() {
            self.startSwitchLoader()
            self.removeConnectedDate()
            self.statuslbl.text = "Connecting"
            self.bottomstatuslbl.text = "Please hold on for a momment"
            self.lockimageview.image = UIImage(named: "Connectimg")
            self.statuslbl.textColor = ThemeManager.currentTheme().ConnectedTextColor
            self.locationview.isHidden = false
            self.switchButton.setOn(true, animated: true)
        }


    }

    fileprivate func disconnectedUI() {
        DispatchQueue.main.async() {
            self.stopSwitchLoader()
            self.removeConnectedDate()
            self.locationview.isHidden = true
            self.statuslbl.text = "Not Connected"
            self.bottomstatuslbl.text = "Switch on the VPN to search everything securely!"
            self.lockimageview.image = UIImage(named: "Disconnectimg")
            self.statuslbl.textColor = ThemeManager.currentTheme().DisConnectedTextColor
            self.switchButton.setOn(false, animated: true)
        }
    }

    fileprivate func nointernetwhiledisconnected() {
         DispatchQueue.main.async() {
            self.stopSwitchLoader()
            self.removeConnectedDate()
        self.locationview.isHidden = true
        self.statuslbl.text = "No Internet Connection"
        self.bottomstatuslbl.text = "Currently not connected to the internet!"
        self.lockimageview.image = UIImage(named: "Disconnectimg")
        self.statuslbl.textColor = ThemeManager.currentTheme().DisConnectedTextColor
        self.switchButton.setOn(false, animated: true)
        }
    }




    fileprivate func disconnectingUI() {
        DispatchQueue.main.async() {
            self.removeConnectedDate()
            self.startSwitchLoader()
            self.locationview.isHidden = true
            self.statuslbl.text = "Disconnecting"
            self.bottomstatuslbl.text = "Switch on the VPN to search everything securely!"
            self.lockimageview.image = UIImage(named: "Disconnectimg")
            self.statuslbl.textColor = ThemeManager.currentTheme().DisConnectedTextColor
            self.switchButton.setOn(false, animated: true)
        }
    }

    func addNewTunnel(tunnelsManager : TunnelsManager) {
        let scannedTunnelConfiguration = try? TunnelConfiguration(fromWgQuickConfig: UserDefaults.standard.isvpnkey(), called: Constants.tunnelName)
        guard let tunnelConfiguration = scannedTunnelConfiguration else {
            //  print("configuration failed")
            return
        }
        // print("configuration pass")
        tunnelsManager.add(tunnelConfiguration: tunnelConfiguration) { result in
            switch result {

            case .failure(let error):
                print("failed", error)

                // print("Errormessage", TunnelsManagerError.systemErrorOnAddTunnel(systemError: error))

                self.switchButton.setOn(false, animated: true)
            case .success:
                // print("Success")
                // print("fresh install")
                UserDefaults.standard.setLoggedIn(value: true)
                UserDefaults.standard.synchronize()

                self.tunnel = tunnelsManager.tunnel(named: Constants.tunnelName)!
                print("new tunnel name", self.tunnel!.name)
                self.startSwitchLoader()
                tunnelsManager.startActivation(of: self.tunnel!)

                //  self.setTimeAndData()



            }
        }
    }



//    func modifyTunnel(tunnelsManager : TunnelsManager) {
//        MKProgress.show(true)
//
//
//            let tunnel = tunnelsManager.tunnel(named: Constants.tunnelName)!
//
////           tunnelsManager.startDeactivation(of: tunnel)
//            let scannedTunnelConfiguration = try? TunnelConfiguration(fromWgQuickConfig: UserDefaults.standard.isvpnkey(), called: Constants.tunnelName)
//            guard let tunnelConfiguration = scannedTunnelConfiguration else {
//                //  print("configuration failed")
//                return
//            }
//            tunnelsManager.modify(tunnel: tunnel, tunnelConfiguration: tunnelConfiguration, onDemandOption: ActivateOnDemandOption.off) { [weak self] error in
//
//                if let error = error {
//                    self?.switchButton.setOn(false, animated: true)
//                    ErrorPresenter.showErrorAlert(error: error, from: self)
//                    return
//                }else
//                {
//
//                }
//            }
//
//
//
//    }

    func modifyTunnel(tunnelsManager : TunnelsManager) {

          print("Inside tunnel modify method")

          let tunnel = tunnelsManager.tunnel(named: Constants.tunnelName)!

          //           tunnelsManager.startDeactivation(of: tunnel)
          let scannedTunnelConfiguration = try? TunnelConfiguration(fromWgQuickConfig: UserDefaults.standard.isvpnkey(), called: Constants.tunnelName)
          guard let tunnelConfiguration = scannedTunnelConfiguration else {
              //  print("configuration failed")
              return
          }

          tunnelsManager.modify(tunnel: tunnel, tunnelConfiguration: tunnelConfiguration, onDemandOption: ActivateOnDemandOption.off) { [weak self] error in

              if let error = error {
                 // self?.switchButton.setOn(false, animated: true)
                  ErrorPresenter.showErrorAlert(error: error, from: self)
                  return
              }else
              {
                if self!.isExists == "0" && !(self?.selectedlocationid.isEmpty)!{
                  print("Success modify")
                  self!.tunnelsManager?.startActivation(of: tunnel)
                }
              }
          }
    }

    fileprivate func callEchoAPI() {

        ApiManager.sharedInstance.networkcheckapicall(timeoutinterval: 5) { (networkstatus) in

            if networkstatus == false{
                print("network off")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "GreenSignal",
                                                  message: "Please check your Internet Connection",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

                }


            }
            else{
                self.getEchoCall()

                print("network on")
            }
        }

    }

    func getEchoCall() {


        ApiManager.sharedInstance.getAPICalls(apiURL:Constants.APIURLS.echoapiUrl, onSuccess: { jsondata in
            print("json value from api",jsondata)

            do {
                let json = try JSONSerialization.jsonObject(with: jsondata, options: [])
                print(json)


                if let responseData = json as? [String: Any] { // Parse dictionary
                    if (responseData["isConnected"] as? Bool) != nil  {
                        let serverstatus = responseData["isConnected"] as? Bool
                        if serverstatus == true{
                             print("server connected from echo api call")
                        }else{
                             print("server notconnected from echo api call")
                        }


                    }
                }
            } catch {
                print(error)
            }

        }, onFailure: { error in

            DispatchQueue.main.async {
                let alert = UIAlertController(title: "GreenSignal",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)


            }
        })




    }



    func setTimeAndData(){

       print("Current status of network",ReachabilityManager.shared.reachability.currentReachabilityStatus)
        self.connectiontype = "\(ReachabilityManager.shared.reachability.currentReachabilityStatus)"
        if self.connectiontype == "WiFi"{
             mydate = Date()
            receivedata = SystemDataUsage.wifireceive
            sentdata = SystemDataUsage.wifisent
        } else if self.connectiontype == "Cellular"
        {
             mydate = Date()
            receivedata  = SystemDataUsage.wwanreceive
             sentdata = SystemDataUsage.wwansent
        }

        UserDefaults.standard.set(receivedata, forKey: "receivedata")
        UserDefaults.standard.set(sentdata, forKey: "sentdata")
        UserDefaults.standard.set(self.mydate, forKey: "startdate")

        UserDefaults.standard.synchronize()

    }


    @objc func switchChanged(_ sender: Any) {

        if NetworkReachabilityManager()?.isReachable == true {
         //   print("Yes! internet is available.")
            if let tunnelsManager = self.tunnelsManager {
                if(UserDefaults.standard.isLoggedIn() == false) {

                    self.addNewTunnel(tunnelsManager: tunnelsManager)

                } else {
                   // print("already installed")

                    let tunnel = tunnelsManager.tunnel(named: Constants.tunnelName)!
                   // print("tunnel name", tunnel.name)
                    if self.switchButton.isOn() {
                        startSwitchLoader()
                        tunnelsManager.startActivation(of: tunnel)
                        self.connectedUI()
                       //  setTimeAndData()

                    } else {
                        startSwitchLoader()
                        tunnelsManager.startDeactivation(of: tunnel)
                       self.disconnectedUI()
                    }

                }
            }
            else {

            }
        }
        else{
            let alert = UIAlertController(title: "GreenSignal",
                                          message: "Please check your Internet Connection",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            self.disconnectedUI()
        }

    }



    //    // MARK: Check user permission on notification allow
    //    // check user has give the permission for notification
    //
    //    func checkNotificationpermission() {
    //        UNUserNotificationCenter.current().getNotificationSettings { settings in
    //            if settings.authorizationStatus == .authorized {
    //                // Already authorized
    //
    //                let privateKey = Curve25519.generatePrivateKey()
    //                let publicKey = Curve25519.generatePublicKey(fromPrivateKey: privateKey)
    //                print("private key",privateKey.base64Key())
    //                print("public key",publicKey.base64Key())
    //
    //
    //                UserDefaults.standard.setpublickkey(value: publicKey.base64Key()!)
    //                UserDefaults.standard.setprivatekkey(value: privateKey.base64Key()!)
    //                UserDefaults.standard.synchronize()
    //
    //                self.registerdevice(pubkey: UserDefaults.standard.ispublickey(), devicetoken: self.devicetoken)
    //
    //
    //            } else {
    //                // Either denied or notDetermined
    //                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
    //                    _, _ in
    //                    // add your own
    //                    UNUserNotificationCenter.current().delegate = self as! UNUserNotificationCenterDelegate
    //                    let alertController = UIAlertController(title: "Notification Alert", message: "Please enable notifications", preferredStyle: .alert)
    //                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ -> Void in
    //                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
    //                            return
    //                        }
    //                        if UIApplication.shared.canOpenURL(settingsUrl) {
    //                            UIApplication.shared.open(settingsUrl, completionHandler: { _ in
    //                            })
    //                        }
    //                    }
    //                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    //                    alertController.addAction(cancelAction)
    //                    alertController.addAction(settingsAction)
    //                    DispatchQueue.main.async {
    //                        self.present(alertController, animated: true, completion: nil)
    //                     //  self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    //
    //                    }
    //                }
    //            }
    //        }
    //    }








    func setTunnelsManager(tunnelsManager: TunnelsManager) {

        print("Inside checkfirstvc setTunnelsManager")
        if(UserDefaults.standard.isLoggedIn() == false) {
            self.tunnelsManager = tunnelsManager

        } else {
            //print("already installed")
         //   print("tunnel is set")
            self.tunnelsManager = tunnelsManager

           // let tunnel = tunnelsManager.tunnel(named: Constants.tunnelName)!
         //   print("tunnel name", tunnel.name)
         //   print("tunnel status in settunnelmanager method", tunnel.status)


           // print("peers count", "\(tunnel.tunnelConfiguration?.peers.count)")
        }

        // print("peers time",tunnel.tunnelConfiguration?.peers[0].lastHandshakeTime)

    }

    func allTunnelNames() -> [String]? {
        guard let tunnelsManager = self.tunnelsManager else { return nil }
        return tunnelsManager.mapTunnels { $0.name }
    }
}

extension CheckfirstViewController: TunnelsManagerActivationDelegate {
    func tunnelActivationAttemptFailed(tunnel: TunnelContainer, error: TunnelsManagerActivationAttemptError) {
        ErrorPresenter.showErrorAlert(error: error, from: self)
    }

    func tunnelActivationAttemptSucceeded(tunnel: TunnelContainer) {
        // Nothing to do
    }

    func tunnelActivationFailed(tunnel: TunnelContainer, error: TunnelsManagerActivationError) {
        ErrorPresenter.showErrorAlert(error: error, from: self)
    }

    func tunnelActivationSucceeded(tunnel: TunnelContainer) {
        // Nothing to do
    }
}

extension CheckfirstViewController {

    func refreshTunnelConnectionStatuses() {
        print("inside tunnel refresh method")
     //   self.loadViewIfNeeded()
        checkTunnelStatusByTunnelmanager(tunnelmanager: self.tunnelsManager!)

    }


    func checkTunnelStatusByTunnelmanager(tunnelmanager : TunnelsManager) {
        if let tunnelsManager = tunnelsManager {
            tunnelsManager.refreshStatuses()
            if(UserDefaults.standard.isLoggedIn() == false) {

            } else {
                // print("tunnel count in Refresh button while app become active", tunnelsManager.numberOfTunnels())

                if(tunnelsManager.numberOfTunnels() > 0 ) {
                    tunnel = tunnelsManager.tunnel(named: Constants.tunnelName)!
                    //     print("tunnel name", tunnel.name)

//                    if tunnel!.status == .active {
//                        self.connectedUI()
//                    } else {
//                        self.disconnectedUI()
//                    }
                }
                else {

                    UserDefaults.standard.setLoggedIn(value: false)
                    UserDefaults.standard.setstatusapi(value: false)
                    UserDefaults.standard.synchronize()
                    self.disconnectedUI()

                }

            }

        }
    }


    func showTunnelDetailForTunnel(named tunnelName: String, animated: Bool, shouldToggleStatus: Bool) {
        let showTunnelDetailBlock: (TunnelsManager) -> Void = { [weak self] tunnelsManager in
            //  guard let self = self else { return }
            // guard let tunnelsListVC = self.tunnelsListVC else { return }
            if let tunnel = tunnelsManager.tunnel(named: tunnelName) {
                //tunnelsListVC.showTunnelDetail(for: tunnel, animated: false)
                if shouldToggleStatus {
                    if tunnel.status == .inactive {
                        tunnelsManager.startActivation(of: tunnel)
                    } else if tunnel.status == .active {
                        tunnelsManager.startDeactivation(of: tunnel)
                    }
                }
            }
        }
        if let tunnelsManager = tunnelsManager {
            showTunnelDetailBlock(tunnelsManager)
        } else {
            onTunnelsManagerReady = showTunnelDetailBlock
        }
    }

}

extension CheckfirstViewController: NetworkStatusListener {

    fileprivate func hasnointernetconnection() {
         DispatchQueue.main.async {
       // Loaf("No Connection", state: .error, location: .top, presentingDirection: .left, dismissingDirection: .right, sender: self).show()

     //   self.optionbtn.isUserInteractionEnabled = false
        self.mainview.isUserInteractionEnabled = false
        }
    }

    fileprivate func hasinternetconnection() {
        DispatchQueue.main.async {
           // Loaf("Back online", state: .success, location: .top, presentingDirection: .left, dismissingDirection: .right, sender: self).show()
            //  self.optionbtn.isUserInteractionEnabled = true
            self.mainview.isUserInteractionEnabled = true
        }

    }

    func networkStatusDidChange(status: Reachability.NetworkStatus) {

        switch status {
        case .notReachable:
            debugPrint("ViewController: Network became unreachable")
        case .reachableViaWiFi:
            self.connectiontype = "WiFi"
            debugPrint("ViewController: Network reachable through WiFi")
        case .reachableViaWWAN:
            self.connectiontype = "Cellular"
            debugPrint("ViewController: Network reachable through Cellular Data")
        }

    }
}

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()

        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }

    func slideInFromLeft(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()

        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate as? CAAnimationDelegate
        }

        // Customize the animation's properties
        slideInFromLeftTransition.type = CATransitionType.fade
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromLeftTransition.fillMode = CAMediaTimingFillMode.both

        // Add the animation to the View's layer
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }

    func fadeIn() {

        //Swift 3, 4, 5
        UIView.animate(withDuration: 1.0, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }

    func fadeOut() {

        //Swift 3, 4, 5
        UIView.animate(withDuration: 1.0, delay: 0.2, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }

    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

}
