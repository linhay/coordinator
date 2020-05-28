//
//  ViewController.swift
//  coordinator
//
//  Created by 林翰 on 05/28/2020.
//  Copyright (c) 2020 林翰. All rights reserved.
//

import UIKit
import Stem
import coordinator

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = UINavigationController()
        router = Router(rootModule: AAAModule(), by: nav)
        present(nav, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

