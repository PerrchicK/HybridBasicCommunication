//
//  ViewController.swift
//  HybridBasicCommunication
//
//  Created by Perry on 16/02/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import UIKit
import WebKit

// This project demonstrates how Codrvova plugins work, native and web communication can be achieved by simply passing messages through the web view delegate.
class ViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var statusLabel: UILabel!
    
    lazy var jsReporterPrefix: String = {
        return "perrchick://js-reporter/?"
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

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

    // This is the main reason why this "magic" works, the web page (using JS) communicates through a navigation it "tries" to make, by design it delivers a message
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let urlString = request.url?.absoluteString else { return false }
        
        let urlStringComponents = urlString.components(separatedBy: jsReporterPrefix)
        // extract report from if exists
        if urlStringComponents.count > 1, let reportFromJs = urlStringComponents.last, let cleanReportFromJs = reportFromJs.removingPercentEncoding {
            // Recognized a report from the JS code, comsume the report and do not navigate
            let reportString = "injected JS says: \"\(cleanReportFromJs)\""
            statusLabel.text = reportString
            print(reportString)
            return false
        }
        
        return true
    }

    // Having fun and injecting a JS listeners
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let jsPath = Bundle.main.path(forResource: "injected-js-file", ofType: "js") else { return }
        
        // Nowadays Apple recommends using WebKit to embed web views and inject JS but this example should work in both UIWebView & WKWebView
        if let javascript = try? String(contentsOfFile: jsPath, encoding: String.Encoding.utf8),
            let injectionResult = webView.stringByEvaluatingJavaScript(from: javascript) {
            
            print(injectionResult)
            statusLabel.text = "(JS injected and observes)"
        }
    }
}
