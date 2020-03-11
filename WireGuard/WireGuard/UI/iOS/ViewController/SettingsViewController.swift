// SPDX-License-Identifier: MIT
// Copyright © 2018-2019 WireGuard LLC. All Rights Reserved.

import UIKit
import NetworkExtension
import MKProgress
import HCSStarRatingView
import Alamofire
import SwiftyJSON
import FirebaseAuth
class SettingsViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var darkthemeupperview: UIView!

    @IBOutlet weak var shareappupperview: UIView!

    @IBOutlet weak var countrylistupperview: UIView!

    @IBOutlet weak var countryarrowimg: UIImageView!

    @IBOutlet weak var themebtn: SevenSwitch!

 @IBOutlet var sv: UIView!
    @IBOutlet weak var sharearrowimg: UIImageView!
    @IBOutlet var mainview: UIView!

    var tunnelsManager: TunnelsManager?
    @IBOutlet var durationlbl: UILabel!

    @IBOutlet var datareceivelbl: UILabel!

    @IBOutlet var datasentlbl: UILabel!

    @IBOutlet var statuslbl: UILabel!

    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var checklbl: UILabel!
    var myreloadtimer: Timer?

    var nowr : UInt64?
    var nows : UInt64?
    var connectiontype = ""

    @IBOutlet weak var versionlbl: UILabel!

    @IBOutlet weak var connectionimg: UIImageView!

    @IBOutlet weak var connectiontitlelbl: UILabel!
    fileprivate var submittoptextview: NSLayoutConstraint?
    fileprivate var submittoprateview: NSLayoutConstraint?

    @IBOutlet weak var submitbtntopconstaint: NSLayoutConstraint!


    @IBOutlet weak var reviewimg: UIImageView!

    @IBOutlet weak var reviewlbl: UILabel!


    @IBOutlet weak var datareceivedtitlelbl: UILabel!
    @IBOutlet weak var datasenttitlelbl: UILabel!

@IBOutlet weak var durationtitlelbl: UILabel!

    @IBOutlet weak var reviewarrowimg: UIImageView!

    @IBOutlet weak var themeimg: UIImageView!

 @IBOutlet weak var darkthemetitlelbl: UILabel!

    @IBOutlet weak var reviewupperview: UIView!

    @IBOutlet weak var reviewmainview: UIView!


    @IBOutlet weak var reviewpopupview: UIView!

    @IBOutlet weak var ratingbarview: HCSStarRatingView!


    @IBOutlet weak var feedbacktextview: UITextView!


    @IBOutlet weak var shareimg: UIImageView!


    @IBOutlet weak var sharetitlelbl: UILabel!


    @IBOutlet weak var countrytitlelbl: UILabel!
 @IBOutlet weak var countryimg: UIImageView!





    override func viewDidLoad() {



        super.viewDidLoad()

        print("viewdidload called")
        print("already installed")
        print("tunnel is set")
        addObservers()
        ThemeManager.applyTheme(theme: ThemeManager.currentTheme())
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            print("version is : \(version)")
            versionlbl.text = "GreenSignal VPN. Version " + "\(version)"
        }
        self.navigationItem.title = "Settings"

        let backButton = UIBarButtonItem()
        backButton.title = nil
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.isNavigationBarHidden = false



        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.addDoneButtonOnKeyboard()

        feedbacktextview.text = "Give Feedback..."
        feedbacktextview.textColor = UIColor.lightGray
        feedbacktextview.selectedTextRange = feedbacktextview.textRange(from: feedbacktextview.beginningOfDocument, to: feedbacktextview.beginningOfDocument)
        submitbtn.backgroundColor = UIColor(hexString: "#D3D3D3")
        submitbtn.isUserInteractionEnabled = false
        optionmenudesign()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.reviewmainview.addGestureRecognizer(tap)


        themechanged()

        customLoaderUI()
    }

        func optionmenudesign(){

            reviewpopupview.backgroundColor = UIColor.white
            reviewpopupview.layer.cornerRadius = 10.0
            //optionmenuview.layer.borderColor = UIColor.lightGray.cgColor
           // optionmenuview.layer.borderWidth = 0.1
            reviewpopupview.layer.shadowOpacity = 1
            reviewpopupview.layer.shadowRadius = 5.0
            reviewpopupview.layer.shadowOffset = CGSize(width: 0, height: 0)
            reviewpopupview.layer.shadowColor = UIColor.lightGray.cgColor
           // optionmenuview.layer.masksToBounds = true

          //  optionmenuview.roundCorners([.topLeft, .bottomLeft ,. topRight , .bottomRight], radius: 5.0)
        }


    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.reviewmainview.isHidden = true
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
    fileprivate func checktunnelstatus() {
        if(UserDefaults.standard.isLoggedIn() == true) {

            let tunnel = self.tunnelsManager!.tunnel(named: Constants.tunnelName)!
            // print("tunnel name", tunnel.name)
            //    print("tunnel status in settunnelmanager method", tunnel.status)
            if tunnel.status == .active {
                checkmanager()
                checklbl.text = "Connected!"
                checklbl.textColor = UIColor(hexString: "#22CC77")

            } else {
                removeConnectedDate()
                stopTimer()
                checklbl.text = "Not Connected!"
                checklbl.textColor = UIColor(hexString: "#FF0033")
                durationlbl.text = "-"
                datasentlbl.text = "-"
                datareceivelbl.text = "-"

            }

            // print("peers count", "\(tunnel.tunnelConfiguration?.peers.count)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        print("inside settingvc viewwillappear")

        adddidbecomeactiveobserver()
        checktunnelstatus()
   }

    override func viewDidDisappear(_ animated: Bool) {
        print("inside settingvc viewDidDisappear")
        removedidbecomeactiveobserver()

        stopTimer()
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

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        feedbacktextview.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        feedbacktextview.resignFirstResponder()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= 150
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {


        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += 150
        }
    }

    @IBAction func ratingbarbtn(_ sender: HCSStarRatingView) {
        print("rate value is ",sender.value)
       // submittoprateview = submitbtn.topAnchor.constraint(equalToSystemSpacingBelow: ratingbarview.bottomAnchor, multiplier: 0)
       // submittoptextview = submitbtn.topAnchor.constraint(equalToSystemSpacingBelow: feedbacktextview.bottomAnchor, multiplier: 0)
        if sender.value <= 0 {
            submitbtn.backgroundColor = UIColor(hexString: "#D3D3D3")
            submitbtn.isUserInteractionEnabled = false
            feedbacktextview.isHidden = true
            submitbtntopconstaint.constant = -34
        }else{
            submitbtn.isUserInteractionEnabled = true
            submitbtn.backgroundColor = UIColor(hexString: "#22CC77")
        if sender.value <= 2 {
            feedbacktextview.isHidden = false

            submitbtntopconstaint.constant = 8



        }else{
            feedbacktextview.isHidden = true
            submitbtntopconstaint.constant = -34

        }
        reviewpopupview.layoutIfNeeded()
        }

    }

    @IBAction func logoutbtn(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
//            if let bid = Bundle.main.bundleIdentifier {
//                UserDefaults.standard.removePersistentDomain(forName: bid)
//
//            }

            UserDefaults.standard.setSocialLoggedIn(value: false)

            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {

                if aViewController is SocialLoginViewController {
                    self.navigationController!.popToViewController(aViewController, animated: true)

                    print("inside swreveal if")
                    break
                }else{
                    print("inside swreveal else")

                    let vc = UIStoryboard.init(name: "MainStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "loginVC") as? SocialLoginViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    break
                }

            }



//           let vc = UIStoryboard.init(name: "MainStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "loginVC") as? SocialLoginViewController
//
//            self.navigationController?.popToViewController(vc!, animated: true)


        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }

    @IBAction func feedbacksubmitbtn(_ sender: Any) {

       if !feedbacktextview.text.trimmingCharacters(in: .whitespaces).isEmpty{

        if NetworkReachabilityManager()?.isReachable == true {

            DispatchQueue.main.async {
                MKProgress.show(true)
            }
            sendFeedback(feedback: feedbacktextview.text)
        }
        else{
            //  UIViewController.removeSpinner(spinner: self.sv)
            let alert = UIAlertController(title: "GreenSignal",
                                          message: "Please check your Internet Connection",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            // print("Please check ur connection !!!!")
        }

       }else{

        }

    }
    func sendFeedback(feedback : String) {


        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 360

        let params = [Constants.Apikeys.FeedbackType:"Feedback",
                      Constants.Apikeys.FeedbackSource:"greensignal-iOS",
                      Constants.Apikeys.Version : "",
                      Constants.Apikeys.FeedbackMessage : feedback,
                      Constants.Apikeys.Noredirect : true] as [String : Any]

        manager.request(Constants.APIURLS.globalapiUrl+Constants.MethodName.feedback, method: .post, parameters: params, encoding:URLEncoding.default).responseJSON { response in
            //  print("Request: \(String(describing: response.request))")   // original url request
            //   print("Response: \(String(describing: response.response))") // http url response
            //   print("Result: \(response.result)")                         // response serialization result

            if response.result.isFailure == true {
                return
            }

            let json = JSON(response.result.value!)


            if json["code"].intValue == 200{
                self.reviewmainview.isHidden = true
                 MKProgress.hide(true)
                let response = json["response"]
                let alert = UIAlertController(title: "GreenSignal",
                                              message: "Thanks for valuable time, we take this point to imporve our service",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

            }
            else{
                self.reviewmainview.isHidden = true
                MKProgress.hide(true)
                //                    LoaderController.sharedInstance.removeLoader()
                //                     UIViewController.removeSpinner(spinner: self.sv)
                let alert = UIAlertController(title: "GreenSignal",
                                              message: "Something went wrong please try later!",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }

            //                LoaderController.sharedInstance.removeLoader()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {

            }

        }

        // do some tasks..


    }

    func textViewDidChange(_ textView: UITextView) {
        print("did change")
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)

    }

    func textViewDidEndEditing(_ textView: UITextView) {
        print("did end")
//
//        if textView.text.isEmpty {
//            textView.text = "Give Feedback..."
//            textView.textColor = UIColor.lightGray
//        }
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Give Feedback..."
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
        print("begin editing")
    }

    @objc func applicationDidBecomeActive() {
        // handle event

        print("setting page observer fire")
         checktunnelstatus()
        internetConnectionCheck()
    }

    fileprivate func internetConnectionCheck() {


        apicall { (networkstatus) in
            let tunnel = self.tunnelsManager!.tunnel(named: Constants.tunnelName)!
            if networkstatus == false{
                print("network off")
                 if tunnel.status == .active {
                    DispatchQueue.main.async {

                        self.checklbl.text = "No Internet Connection"

                            let alert = UIAlertController(title: "GreenSignal",
                                                          message: "Please check your Internet Connection",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)


                    }

                }


//                LoaderController.sharedInstance.removeLoader()
            }
            else{
                print("network on")
                if tunnel.status == .active {
                    DispatchQueue.main.async {

                        self.checklbl.text = "Connected"
                    }
                }

                // LoaderController.sharedInstance.removeLoader()
            }
        }
    }


    func apicall(completion: @escaping (Bool) -> Void) {
        let url = URL(string: "http://www.google.com/")!
        MKProgress.show(true)
//        LoaderController.sharedInstance.showLoader(view: self.view)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(5)
        configuration.timeoutIntervalForResource = TimeInterval(5)
        let session = URLSession(configuration: configuration)

        let task = session.dataTask(with: url) {(data, response, error) in
            //  guard let data = data else { return }
            print("api get called")
            DispatchQueue.main.async {
                 MKProgress.hide(true)
            }

            if let responseerror = error {
                print("error in api called",responseerror.localizedUIString)
                completion(false)
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                completion(true)
            }

        }

        task.resume()
    }


    func removeConnectedDate()
    {
        UserDefaults.standard.removeObject(forKey: "startdate")
        UserDefaults.standard.synchronize()
    }

    func checkmanager(){
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            guard error == nil else {
                NSLog("Unexpected error: \(error).");
                return
            }
            if (managers?.count != 0)
            {
                do
                {
                    if let list = managers {
                        print("Provider manager count",managers?.count)
                        for i in 0..<list.count {


                            if let tunnelname = (managers?[i].tunnelConfiguration?.name!){
                                if tunnelname == Constants.tunnelName{

                                    if let connecteddate = managers?[i].connection.connectedDate{
                                        print("manager tunnel time",self.prettyTimeAgo(timestamp: (managers?[i].connection.connectedDate)!))
                                        print("connected date",connecteddate)
                                        UserDefaults.standard.set(connecteddate, forKey: "startdate")
                                        UserDefaults.standard.synchronize()
                                    }

                                    print("manager tunnel name",managers?[i].tunnelConfiguration?.name)
                                    NSLog("Found VPN with target \(managers?[i].localizedDescription)")
                                }
                            }

                        }
                        self.starttimer()
                    }

                }
                catch
                {
                    NSLog("Unexpected error: \(error).");
                }
            }
            else
            {
                NSLog("Not found, creating new");

            }
        }
    }



    func starttimer()
    {
        if myreloadtimer == nil {
            myreloadtimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SettingsViewController.timeCount), userInfo: nil, repeats: true)
        }
    }

    func stopTimer()
    {
        if myreloadtimer != nil {
            myreloadtimer!.invalidate()
            myreloadtimer = nil
        }
    }


    func changeCountry(countryname: String, locationId: String) {
        print("get the country name form country VC", countryname)
        print("get the country name form country VC", countryname)
    }


    // MARK: Theme change methods
    @objc func darkthemechanged(_ sender: Any) {
        if self.themebtn.isOn(){
            let theme = Theme.Dark
            ThemeManager.applyTheme(theme: theme)
        }
        else{
            let theme = Theme.Default
            ThemeManager.applyTheme(theme: theme)
        }

    }

    func themechanged() {
         themebtn.addTarget(self, action: #selector(darkthemechanged(_:)), for: UIControl.Event.touchUpInside)

        print("p",ThemeManager.currentTheme().rawValue)
        let p = ThemeManager.currentTheme().rawValue
        if p == 1
        {
            themebtn.inactiveColor = ThemeManager.currentTheme().ConnectSwitchColor
            themebtn.setOn(true, animated: true)
        }
        else{
             themebtn.inactiveColor = ThemeManager.currentTheme().DisconnectSwitchColor
            themebtn.setOn(false, animated: true)
        }

    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeUpdated, object: nil)
    }

    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeTheme), name: .themeUpdated, object: nil)
    }



    @objc fileprivate func changeTheme() {
//        view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
        self.view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
        self.navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().NavigationBarBackgroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ThemeManager.currentTheme().TitleColor]

        self.navigationController?.navigationBar.tintColor = ThemeManager.currentTheme().backbuttonColor


        self.themebtn.inactiveColor = ThemeManager.currentTheme().DisconnectSwitchColor
        self.themebtn.activeColor = ThemeManager.currentTheme().ConnectSwitchColor

        self.connectiontitlelbl.textColor = ThemeManager.currentTheme().TitleColor
        self.durationlbl.textColor = ThemeManager.currentTheme().DetailTextColor
        self.durationtitlelbl.textColor = ThemeManager.currentTheme().DetailTextColor
        self.datareceivedtitlelbl.textColor = ThemeManager.currentTheme().DetailTextColor
        self.datasenttitlelbl.textColor = ThemeManager.currentTheme().DetailTextColor
        self.datasentlbl.textColor = ThemeManager.currentTheme().DetailTextColor
        self.datareceivelbl.textColor = ThemeManager.currentTheme().DetailTextColor
        self.sharetitlelbl.textColor = ThemeManager.currentTheme().TitleColor
        self.reviewlbl.textColor = ThemeManager.currentTheme().TitleColor
        self.darkthemetitlelbl.textColor = ThemeManager.currentTheme().TitleColor
        self.countrytitlelbl.textColor = ThemeManager.currentTheme().TitleColor
        self.versionlbl.textColor =  ThemeManager.currentTheme().TitleColor
        self.connectionimg.image = ThemeManager.currentTheme().statusimg
        self.shareimg.image = ThemeManager.currentTheme().shareimg
        self.themeimg.image = ThemeManager.currentTheme().themeimg
        self.countryimg.image = ThemeManager.currentTheme().countrypinsettingimg
        self.sharearrowimg.image = ThemeManager.currentTheme().dropmenusettingimg
        self.countryarrowimg.image = ThemeManager.currentTheme().dropmenusettingimg
        self.reviewarrowimg.image = ThemeManager.currentTheme().dropmenusettingimg
        self.reviewimg.image = ThemeManager.currentTheme().reviewsettingimg

        self.darkthemeupperview.backgroundColor = ThemeManager.currentTheme().SepratedViewColor
        self.shareappupperview.backgroundColor = ThemeManager.currentTheme().SepratedViewColor
        self.countrylistupperview.backgroundColor = ThemeManager.currentTheme().SepratedViewColor
        self.reviewupperview.backgroundColor = ThemeManager.currentTheme().SepratedViewColor
    }


    @objc func timeCount()
    {
//        if let connecteddate = UserDefaults.standard.object(forKey: "ConnectedDate"){
//            print("date is present in prefrences ")
//            self.connectedtimelbl.stringValue = self!.prettyTimeAgo(timestamp: connecteddate as! Date)
//        }

        if let connectedDate = UserDefaults.standard.value(forKey: "startdate"){
            durationlbl.text = prettyTimeAgo(timestamp: connectedDate as! Date)
        }
//        let yourDate = UserDefaults.standard.value(forKey: "startdate") as! Date


        //        print("start time",yourDate)
        //        print("start time from now",prettyTimeAgo(timestamp: yourDate))

//        let newr = UserDefaults.standard.value(forKey: "receivedata") as! UInt64
//        let news = UserDefaults.standard.value(forKey: "sentdata") as! UInt64
//
//        if self.connectiontype == "WiFi"
//        {
//            nowr = SystemDataUsage.wifireceive
//            nows = SystemDataUsage.wifisent
//        } else if self.connectiontype == "Cellular"
//        {
//            nowr = SystemDataUsage.wwanreceive
//            nows = SystemDataUsage.wwansent
//        }
//        datasentlbl.text = prettyBytes(nows! - news)
//        datareceivelbl.text = prettyBytes(nowr! - newr)
//
//        print("receive data ",nowr! - newr)
//        print("sent data ",nows! - news)



        let tunnel = self.tunnelsManager!.tunnel(named: Constants.tunnelName)!
        tunnel.getRuntimeTunnelConfiguration { [weak self] tunnelConfiguration in
            guard let tunnelConfiguration = tunnelConfiguration else { return }

            if let sentdata = tunnelConfiguration.peers[0].txBytes{
                self!.datasentlbl.text = self?.prettyBytes(sentdata)
                 print("send data from configuration",self?.prettyBytes(sentdata))
            }


            if let recievedata = tunnelConfiguration.peers[0].rxBytes{
                self!.datareceivelbl.text = self?.prettyBytes(recievedata)
                 print("recievedata from configuration ",self?.prettyBytes(recievedata))
            }

        }



    }

    func setTunnelsManager(tunnelsManager: TunnelsManager) {
        print("inside setting setTunnelsManager")
        if(UserDefaults.standard.isLoggedIn() == false) {
            self.tunnelsManager = tunnelsManager

        } else {

            self.tunnelsManager = tunnelsManager
        }
    }

    @IBAction func sharebtn(_ sender: Any) {


        let bodytext = "Make your Internet Connection Safe and Super Fast. Use GreenSignal VPN Mobile App. Get it FREE now."
        let myWebsite = NSURL(string:"https://testflight.apple.com/join/efOG5xOP")
        let itemsToShare:[Any] = [ bodytext, myWebsite ]

        let controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        controller.setValue("Share GreenSignal", forKey: "subject")
        controller.popoverPresentationController?.sourceView = self.view
        self.present(controller, animated: true, completion: nil)

    }



    @IBAction func countrylistbtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "countrylistVC") as? CountrySelectionViewController
                       vc?.barbuttontitle = "Settings"

                       self.navigationController?.pushViewController(vc!, animated: true)


    }


    @IBAction func reviewbtn(_ sender: Any) {
        self.reviewmainview.isHidden = false
    }



    private func prettyBytes(_ bytes: UInt64) -> String {
        switch bytes {
        case 0..<1024:
            return "\(bytes) B"
        case 1024 ..< (1024 * 1024):
            return String(format: "%.2f", Double(bytes) / 1024) + " KB"
        case 1024 ..< (1024 * 1024 * 1024):
            return String(format: "%.2f", Double(bytes) / (1024 * 1024)) + " MB"
        case 1024 ..< (1024 * 1024 * 1024 * 1024):
            return String(format: "%.2f", Double(bytes) / (1024 * 1024 * 1024)) + " GB"
        default:
            return String(format: "%.2f", Double(bytes) / (1024 * 1024 * 1024 * 1024)) + " TB"
        }
    }



    private func prettyTimeAgo(timestamp: Date) -> String {
        let now = Date()
        let timeInterval = Int64(now.timeIntervalSince(timestamp))
        switch timeInterval {
        case ..<0: return tr("tunnelHandshakeTimestampSystemClockBackward")
        case 0: return tr("tunnelHandshakeTimestampNow")
        default:
            return prettyTime(secondsLeft: timeInterval)
        }
    }

    private func prettyTime(secondsLeft: Int64) -> String {
        var left = secondsLeft
        var timeStrings = [String]()
        let years = left / (365 * 24 * 60 * 60)
        left = left % (365 * 24 * 60 * 60)
        let days = left / (24 * 60 * 60)
        left = left % (24 * 60 * 60)
        let hours = left / (60 * 60)
        left = left % (60 * 60)
        let minutes = left / 60
        let seconds = left % 60

        #if os(iOS)
        if years > 0 {
            return years == 1 ? tr(format: "tunnelHandshakeTimestampYear (%d)", years) : tr(format: "tunnelHandshakeTimestampYears (%d)", years)
        }
        if days > 0 {
            return days == 1 ? tr(format: "tunnelHandshakeTimestampDay (%d)", days) : tr(format: "tunnelHandshakeTimestampDays (%d)", days)
        }
        if hours > 0 {
            let hhmmss = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            //return tr(format: "tunnelHandshakeTimestampHours hh:mm:ss (%@)", hhmmss)
            return hhmmss
        }
        if minutes > 0 {
            let mmss = String(format: "00:%02d:%02d", minutes, seconds)
//            return tr(format: "tunnelHandshakeTimestampMinutes mm:ss (%@)", mmss)
            return  mmss
        }
//        return seconds == 1 ? tr(format: "tunnelHandshakeTimestampSecond (%d)", seconds) : tr(format: "tunnelHandshakeTimestampSeconds (%d)", seconds)
        return String(format: "00:00:%02d", seconds)

        #elseif os(macOS)
        if years > 0 {
            timeStrings.append(years == 1 ? tr(format: "tunnelHandshakeTimestampYear (%d)", years) : tr(format: "tunnelHandshakeTimestampYears (%d)", years))
        }
        if days > 0 {
            timeStrings.append(days == 1 ? tr(format: "tunnelHandshakeTimestampDay (%d)", days) : tr(format: "tunnelHandshakeTimestampDays (%d)", days))
        }
        if hours > 0 {
            timeStrings.append(hours == 1 ? tr(format: "tunnelHandshakeTimestampHour (%d)", hours) : tr(format: "tunnelHandshakeTimestampHours (%d)", hours))
        }
        if minutes > 0 {
            timeStrings.append(minutes == 1 ? tr(format: "tunnelHandshakeTimestampMinute (%d)", minutes) : tr(format: "tunnelHandshakeTimestampMinutes (%d)", minutes))
        }
        if seconds > 0 {
            timeStrings.append(seconds == 1 ? tr(format: "tunnelHandshakeTimestampSecond (%d)", seconds) : tr(format: "tunnelHandshakeTimestampSeconds (%d)", seconds))
        }
        return timeStrings.joined(separator: ", ")
        #endif
    }


}


extension SystemDataUsage {

    public static var wifiCompelete: UInt64 {
        return SystemDataUsage.getDataUsage().wifiSent + SystemDataUsage.getDataUsage().wifiReceived
    }

    public static var wwanCompelete: UInt64 {
        return SystemDataUsage.getDataUsage().wirelessWanDataSent + SystemDataUsage.getDataUsage().wirelessWanDataReceived
    }
    public static var wwansent: UInt64 {
        return SystemDataUsage.getDataUsage().wirelessWanDataSent
    }
    public static var wwanreceive: UInt64 {
        return  SystemDataUsage.getDataUsage().wirelessWanDataReceived
    }
    public static var wifisent: UInt64 {
        return SystemDataUsage.getDataUsage().wifiSent
    }
    public static var wifireceive: UInt64 {
        return  SystemDataUsage.getDataUsage().wifiReceived
    }


}

class SystemDataUsage {

    private static let wwanInterfacePrefix = "pdp_ip"
    private static let wifiInterfacePrefix = "en"

    class func getDataUsage() -> DataUsageInfo {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        var dataUsageInfo = DataUsageInfo()

        guard getifaddrs(&ifaddr) == 0 else { return dataUsageInfo }
        while let addr = ifaddr {
            guard let info = getDataUsageInfo(from: addr) else {
                ifaddr = addr.pointee.ifa_next
                continue
            }
            dataUsageInfo.updateInfoByAdding(info)
            ifaddr = addr.pointee.ifa_next
        }

        freeifaddrs(ifaddr)

        return dataUsageInfo
    }

    private class func getDataUsageInfo(from infoPointer: UnsafeMutablePointer<ifaddrs>) -> DataUsageInfo? {
        let pointer = infoPointer
        let name: String! = String(cString: pointer.pointee.ifa_name)
        let addr = pointer.pointee.ifa_addr.pointee
        guard addr.sa_family == UInt8(AF_LINK) else { return nil }

        return dataUsageInfo(from: pointer, name: name)
    }

    private class func dataUsageInfo(from pointer: UnsafeMutablePointer<ifaddrs>, name: String) -> DataUsageInfo {
        var networkData: UnsafeMutablePointer<if_data>?
        var dataUsageInfo = DataUsageInfo()

        if name.hasPrefix(wifiInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                dataUsageInfo.wifiSent += UInt64(data.pointee.ifi_obytes)
                dataUsageInfo.wifiReceived += UInt64(data.pointee.ifi_ibytes)
            }

        } else if name.hasPrefix(wwanInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                dataUsageInfo.wirelessWanDataSent += UInt64(data.pointee.ifi_obytes)
                dataUsageInfo.wirelessWanDataReceived += UInt64(data.pointee.ifi_ibytes)
            }
        }
        return dataUsageInfo
    }
}

struct DataUsageInfo {
    var wifiReceived: UInt64 = 0
    var wifiSent: UInt64 = 0
    var wirelessWanDataReceived: UInt64 = 0
    var wirelessWanDataSent: UInt64 = 0

    mutating func updateInfoByAdding(_ info: DataUsageInfo) {
        wifiSent += info.wifiSent
        wifiReceived += info.wifiReceived
        wirelessWanDataSent += info.wirelessWanDataSent
        wirelessWanDataReceived += info.wirelessWanDataReceived
    }
}

