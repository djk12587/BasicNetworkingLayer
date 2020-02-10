//
//  ViewController.swift
//  NetworkingExample
//
//  Created by Daniel Koza on 2/10/20.
//  Copyright © 2020 Daniel Koza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        API.SomeAPISource.GetAccessTokenExample().request { (result) in
            switch result {
                case .success(let token):
                    print(token.token)
                case .failure(let error):
                    print(error)
            }
        }

        API.SomeAPISource.RequestVerificationUrl(aRequestParameter: "someParam", accessToken: "yourToken").requestCollection { (result) in
            switch result {
                case .success(let verificationUrls):
                    print(verificationUrls)
                case .failure(let error):
                    print(error)
            }
        }
    }
}

