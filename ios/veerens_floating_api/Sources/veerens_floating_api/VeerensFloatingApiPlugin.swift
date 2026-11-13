import Flutter
import Foundation
import UIKit

/// Automatic store-install check for the floating API button.
///
/// A genuine App Store download carries a production receipt (its file
/// name is exactly "receipt"). A TestFlight build, an ad-hoc/enterprise
/// "testing IPA", or a debug run from Xcode either has no receipt at
/// all or carries a sandbox receipt instead — both report as "not a
/// store install" so the button still shows for those.
public class VeerensFloatingApiPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "veerens_floating_api", binaryMessenger: registrar.messenger())
    let instance = VeerensFloatingApiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isStoreInstall":
      result(Self.isStoreInstall())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private static func isStoreInstall() -> Bool {
    guard let receiptURL = Bundle.main.appStoreReceiptURL else { return false }
    guard FileManager.default.fileExists(atPath: receiptURL.path) else { return false }
    return receiptURL.lastPathComponent == "receipt"
  }
}
