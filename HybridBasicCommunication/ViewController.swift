//
//  ViewController.swift
//  HybridBasicCommunication
//
//  Created by Perry on 16/02/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import UIKit

protocol InjectedJsProtocol {
    func alert(message: String)
    func reportToAnalytics(event: [String:Any])
}

// This project demonstrates how Codrvova plugins work, native and web communication can be achieved by simply passing messages through the web view delegate.
class ViewController: UIViewController, UIWebViewDelegate, InjectedJsProtocol {

    // Nowadays Apple recommends using WebKit to embed web in apps,
    // but this example should work in both UIWebView & WKWebView
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var currentAddressLabel: UILabel!
    
    lazy var jsReporterPrefix: String = {
        return "perrchick://js-reporter/?"
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.sizeToFit()
        webView.backgroundColor = UIColor.clear
        webView.delegate = self
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadInitialPage()
    }
    
    @IBAction func reloadButtonPressed(_ sender: UIButton) {
        loadInitialPage()
    }
    
    func loadInitialPage() {
        guard let htmlPath = Bundle.main.path(forResource: "simple-web-page", ofType: "html"),
            let url = URL(string: htmlPath) else { return }
        let request: URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    //MARK: - UIWebViewDelegate

    // This is the main reason why this "magic" works, the web page (thanks to JS) communicates through a navigation it "tries" to make, by design it delivers a message
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let urlString = request.url?.absoluteString else { return false }
        
        let urlStringComponents = urlString.components(separatedBy: jsReporterPrefix)
        // extract report from if exists
        if urlStringComponents.count > 1, let reportFromJs = urlStringComponents.last, let cleanReportFromJs = reportFromJs.removingPercentEncoding {
            // Recognized a report from the JS code, comsume the report and do not navigate
            let reportString = "injected JS says: \"\(cleanReportFromJs)\""
            statusLabel.text = reportString

            print("\(handleJsReport(invocationFromJs: cleanReportFromJs) ? "handled" : "failed to handle"): \(cleanReportFromJs)")

            return false
        }
        
        return true
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let jsPath = Bundle.main.path(forResource: "js-code-to-inject", ofType: "js") else { return }
        
        // Just for fun, injecting a JS listener. The right way would be to originally include this code from the first place, inside the HTML / embedded JS section.
        if let javascriptTakeOverCode = try? String(contentsOfFile: jsPath, encoding: String.Encoding.utf8),
        // This JS injection not only helps to add methods that the owner never implemented, it also helps to send messages from the native components to the web components.
        let injectionResult = webView.stringByEvaluatingJavaScript(from: javascriptTakeOverCode) {
            print(injectionResult)
        }

        if let currentAddress = webView.request?.url?.absoluteString {
            currentAddressLabel.text = currentAddress
        }
    }

    /// A helper closure to build a selector from a String object
    private let selectorFromString: (String) -> (Selector) = {
        let _selector: Selector = NSSelectorFromString($0)
        return _selector
    }

    private func selector(withName selectorName: String) -> Selector? {
        let selector: Selector = selectorFromString(selectorName)
        // To prevent an NSInvalidArgumentException
        guard responds(to: selector) else { return nil }

        return selector
    }
    
    func handleJsReport(invocationFromJs: String) -> Bool {
        let methodCall = invocationFromJs.components(separatedBy: ":")

        if let arg = methodCall[safe: 1] {
            guard let selectorFromJs = selector(withName: "\(methodCall[0]):") else { return false }
            if arg.hasPrefix("<") && arg.hasSuffix(">") {
                // has list
                var args: [String: Any] = [:]
                let cleanList = arg.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
                let arguments = cleanList.components(separatedBy: ",")
                for argument in arguments {
                    let argumentWithKey = argument.components(separatedBy: ";")
                    args[argumentWithKey[0]] = argumentWithKey[1]
                }
                perform(selectorFromJs, with: args)
            } else {
                perform(selectorFromJs, with: arg)
            }
        } else {
            guard let selectorFromJs = selector(withName: invocationFromJs) else { return false }
            perform(selectorFromJs)
        }

        return true
    }

    //MARK: - InjectedJsProtocol implementation

    internal func reportToAnalytics(event: [String : Any]) {
        print("reporting: \(event)")
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: "Message from JS", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "cool", style: UIAlertActionStyle.cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension Collection where Indices.Iterator.Element == Index {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
