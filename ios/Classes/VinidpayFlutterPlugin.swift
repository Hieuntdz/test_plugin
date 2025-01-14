import Flutter
import UIKit
import VinidPayApp2App

public class VinidpayFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "vinpay_plugin", binaryMessenger: registrar.messenger())
    let instance = VinidpayFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "proceedPayment":
      
        guard let args = call.arguments else {
            return
        }
        
        if let myArgs = args as? [String: Any],
            let id = myArgs["id"] as? String,
            let signature = myArgs["sign"] as? String,
           
            let sandboxMode = myArgs["sandboxMode"] as? Bool {
            
           
            VinIDPay.sharedInstance.sandboxMode = sandboxMode
            
            let hasInstalled = VinIDPay.sharedInstance.hasVinIDAppInstalled
                        if (hasInstalled) {
                            VinIDPay.sharedInstance.pay(withOrderId: id, signature: signature, extraData: nil) { (extraData, status) in
                                var message = ""
                                
                                switch status {
                                case .success:
                                    message = "payment successful!"
                                case .aborted:
                                    message = "user aborted payment"
                                case .failure:
                                    message = "payment failed"
                                default:
                                    message = "unknow status"
                                }
                                
                                result(message)
                            }
                        }else {
                            VinIDPay.sharedInstance.navigateToAppStore()
                            result("App not installed")
                        }
            
            
        } else {
            result("unknow status")
        }
        
    case "isVinIdAppInstalled":
        guard let args = call.arguments else {
                        return
                    }
                    
                    if let myArgs = args as? [String: Any],
                        let sandboxMode = myArgs["sandboxMode"] as? Bool {
                        
                        VinIDPay.sharedInstance.sandboxMode = sandboxMode
                        
                        let hasInstalled = VinIDPay.sharedInstance.hasVinIDAppInstalled
                        if (hasInstalled) {
                            result(true)
                        }else {
                            result(false)
                        }
                        
                    } else {
                        result("unknow status")
                    }
    case "openVinIDInstallPage":
        guard let args = call.arguments else {
                        return
                    }
                    
                    if let myArgs = args as? [String: Any],
                        let sandboxMode = myArgs["sandboxMode"] as? Bool {
                        
                        VinIDPay.sharedInstance.sandboxMode = sandboxMode
                        
                        VinIDPay.sharedInstance.navigateToAppStore()

                    } else {
                        result("unknow status")
                    }
        
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
