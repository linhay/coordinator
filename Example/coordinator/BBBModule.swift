//
//  BBBModule.swift
//  coordinator_Example
//
//  Created by 林翰 on 2020/5/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Stem
import coordinator

class BBBModule: UIModule {

    var viewControllers: [WeakBox<UIViewController>] = []
    var rootController: UIViewController { BBB1ViewController() }

}

class BBB1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = #file
        view.backgroundColor = UIColor.st.random
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        router?.link(AAAModule())
    }

}
