//
//  Module.swift
//  coordinator
//
//  Created by 林翰 on 2020/5/28.
//

import Foundation
import Stem

public protocol Module: class {

//    static func link(by string: String) -> Self
    
}


public enum UIModuleShowType {
    case push
    case present
}

public protocol UIModule: Module {
    var viewControllers: [WeakBox<UIViewController>] { get set }
    var rootController: UIViewController { get }
    var showType: UIModuleShowType { get }
}

public extension UIModule {

    var showType: UIModuleShowType {
        .push
    }

    var currentViewController: WeakBox<UIViewController> {
        guard let vc = viewControllers.last(where: { $0.value != nil }) else {
            return .init(rootController)
        }
        return vc
    }

    func set(rootController vc: UIViewController) {
        viewControllers.append(.init(vc))
        vc.module = self
    }

    func push(vc: UIViewController) {
        vc.module = self

        switch currentViewController.value {
        case let controller as UINavigationController:
            controller.pushViewController(vc, animated: true)
        default:
            currentViewController.value?.navigationController?.pushViewController(vc, animated: true)
        }

        viewControllers.append(.init(vc))
    }

    func present(vc: UIViewController) {

        switch vc {
        case let controller as UINavigationController:
            controller.topViewController?.module = self
            vc.module = self
        default:
            vc.module = self
        }

        currentViewController.value?.present(vc, animated: true, completion: nil)
        viewControllers.append(.init(vc))
    }

}

public extension UIViewController {

    static let moduleKey = UnsafeRawPointer(bitPattern: "module.key.c".hashValue)!

    weak var module: UIModule? {
        get {
            self.st.getAssociated(associatedKey: UIViewController.moduleKey)
        }

        set {
            self.st.setAssociated(value: newValue,
                                  associatedKey: UIViewController.moduleKey)
        }
    }

}
