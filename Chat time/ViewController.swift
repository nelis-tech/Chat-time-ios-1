//
//  ViewController.swift
//  Chat time
//
//  Created by Niels Hoekstra on 03/06/2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero,
                                configuration: configuration)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        guard let url = URL(string: "https://www.chat-time.app") else {
            return
        }
        webView.load(URLRequest(url: url))
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.webView.evaluateJavaScript("document.bod.innerHTML") { result, error in
                guard let html = result as? String, error == nil else {
                    return
                }
                print(html)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
            if #available(iOS 11, *) {
                let dataStore = WKWebsiteDataStore.default()
                dataStore.httpCookieStore.getAllCookies({ (cookies) in
                    print(cookies)
                })
            } else {
                guard let cookies = HTTPCookieStorage.shared.cookies else {
                    return
                }
                print(cookies)
            }
            
        }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}

