//
//  Router.swift
//  coordinator
//
//  Created by 林翰 on 2020/5/28.
//

import UIKit
import Stem

class DeinitHook {
    
    let callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    deinit {
        callback()
    }
}

public class Router {
    
    var modules = [UIModule]()
    
    weak var rootNavigationController: UINavigationController?
    
    public init(rootModule: UIModule, by navigationController: UINavigationController) {
        self.rootNavigationController = navigationController
        link(rootModule)
    }
    
    public func link(_ module: UIModule) {
        guard modules.contains(where: { $0 === module }) == false else {
            return
        }
        
        let vc = module.rootController
        let associatedKey = UnsafeRawPointer(bitPattern: "qqrqrq.vsdfsf".hashValue)!
        let hook = DeinitHook { [weak self] in
            self?.unlink(module)
        }
        vc.st.setAssociated(value: hook, associatedKey: associatedKey)
        module.set(rootController: vc)
        print("link: ", module.rootController.description)

        guard let lastModule = lastModule() else {
            switch module.showType {
            case .present:
                rootNavigationController?.present(vc, animated: true, completion: nil)
            case .push:
                guard let nav = rootNavigationController else {
                    return
                }
                if nav.viewControllers.isEmpty {
                    nav.setViewControllers([vc], animated: false)
                } else {
                    nav.pushViewController(vc, animated: true)
                }
            }
            modules.append(module)
            return
        }
        
        switch module.showType {
        case .present:
            lastModule.currentViewController.value?.present(vc, animated: true, completion: nil)
        case .push:
            let controller = lastModule.currentViewController.value
            switch controller {
            case let controller as UINavigationController:
                controller.pushViewController(vc, animated: true)
            default:
                controller?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        modules.append(module)
    }

    func lastModule() -> UIModule? {
        return modules.last(where: { $0.currentViewController.value != nil })
    }
    
    func unlink(_ module: UIModule) {

        var modules = [UIModule]()

        for item in self.modules {
            if item === module {
                print("unlink: module ", module)
                break
            } else if item.viewControllers.contains(where: { $0.value != nil }) {
                modules.append(item)
            }
        }

        self.modules = modules
        print(modules.count)
    }
    
}
