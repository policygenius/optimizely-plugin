import Flutter
import Optimizely

public class SwiftOptimizelyPlugin: NSObject, FlutterPlugin {
    
    typealias GetFeatureItems = (featureKey: String, userId: String, attributes: OptimizelyAttributes?)
    var client: OptimizelyClient?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "optimizely_plugin",
            binaryMessenger: registrar.messenger()
        )
        let instance = SwiftOptimizelyPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any] else {
            result(FlutterError(
                code: "arguments",
                message: "Missing or invalid arguments",
                details: nil
            ))
            return
        }
        
        switch call.method {
        case "initOptimizelyManager":
            do {
                let sdkKey: String = try arguments.argument(for: "sdk_key")
                let dataFile: String? = try arguments.optionalArgument(for: "datafile")
                let client = OptimizelyClient(
                    sdkKey: sdkKey,
                    periodicDownloadInterval: 60
                )
                try startClient(client, dataFile: dataFile)
                self.client = client
                result(nil)
            } catch {
                result(error)
            }
        case "isFeatureEnabled":
            do {
                let client = try ensureClient()
                let items = try getFeatureItems(from: arguments)
                let enabled = client.isFeatureEnabled(
                    featureKey: items.featureKey,
                    userId: items.userId,
                    attributes: items.attributes
                )
                result(enabled)
            } catch {
                result(error)
            }
        case "getAllFeatureVariables":
            do {
                let client = try ensureClient()
                let items = try getFeatureItems(from: arguments)
                let json: OptimizelyJSON = try client.getAllFeatureVariables(
                    featureKey: items.featureKey,
                    userId: items.userId,
                    attributes: items.attributes
                )
                result(json.toMap())
            } catch {
                result(error)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func ensureClient() throws -> OptimizelyClient {
        guard let client = self.client else {
            throw FlutterError(
                code: "client",
                message: "Optimizely client not initialized",
                details: nil
            )
        }
        return client
    }

    func startClient(_ client: OptimizelyClient, dataFile: String?) throws {
        if let dataFile = dataFile {
            try client.start(datafile: dataFile)
        } else {
            client.start()
        }
    }
    
    func getFeatureItems(from arguments: [String: Any]) throws -> GetFeatureItems {
        let featureKey: String = try arguments.argument(for: "feature_key")
        let userId: String = try arguments.argument(for: "user_id")
        let attributes: OptimizelyAttributes? = try arguments.optionalArgument(for: "attributes")
        return (featureKey, userId, attributes)
    }
}

// MARK: - Arguments

fileprivate extension Dictionary where Key == String, Value == Any {
    func argument<T>(for key: String) throws -> T {
        if self[key] == nil {
            throw FlutterError.missingArgument(for: key)
        }
        if let argument = self[key] as? T {
            return argument
        } else {
            throw FlutterError.invalidType(for: key)
        }
    }
    
    func optionalArgument<T>(for key: String) throws -> T? {
        if self[key] == nil {
            return nil
        }
        if let argument = self[key] as? T {
            return argument
        } else {
            throw FlutterError.invalidType(for: key)
        }
    }
}

// MARK: - Flutter Error

extension FlutterError: Error { }

fileprivate extension FlutterError {
    static func missingArgument(for key: String) -> FlutterError {
        return FlutterError(
            code: "argument",
            message: "Missing argument for key: \(key)",
            details: nil
        )
    }
    
    static func invalidType(for key: String) -> FlutterError {
        return FlutterError(
            code: "argument",
            message: "Invalid type for argument with key: \(key)",
            details: nil
        )
    }
}
