//
//  AAAModule.swift
//  coordinator_Example
//
//  Created by 林翰 on 2020/5/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Stem
import coordinator

class AAAModule: UIModule {

    var viewControllers: [WeakBox<UIViewController>] = []
    var rootController: UIViewController { AAA1ViewController() }

}

class AAA1ViewController: UIViewController {

    lazy var button1: UIButton = {
        let item = UIButton()
        item.backgroundColor = UIColor.st.random
        item.setTitle("push module", for: .normal)
        item.st.add(for: .touchUpInside) { _ in
            router?.link(BBBModule())
        }
        return item
    }()

    lazy var button2: UIButton = {
        let item = UIButton()
        item.backgroundColor = UIColor.st.random
        item.setTitle("push Self", for: .normal)
        item.st.add(for: .touchUpInside) { [weak self] _ in
            self?.module?.push(vc: AAA1ViewController())
        }
        return item
    }()

    lazy var button3: UIButton = {
        let item = UIButton()
        item.backgroundColor = UIColor.st.random
        item.setTitle("present Self", for: .normal)
        item.st.add(for: .touchUpInside) { [weak self] _ in
            self?.module?.present(vc: UINavigationController(rootViewController: AAA1ViewController()))
        }
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(describing: Self.self)
        view.backgroundColor = UIColor.st.random
        view.st.addSubviews(button1, button2, button3)
        button1.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 60)
        button2.frame = CGRect(x: 0, y: button1.frame.maxY + 10, width: view.bounds.width, height: 60)
        button3.frame = CGRect(x: 0, y: button2.frame.maxY + 10, width: view.bounds.width, height: 60)
    }

}
