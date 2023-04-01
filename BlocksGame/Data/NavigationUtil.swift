//
//  NavigationUtil.swift
//  Bataille Navale
//
//  Created by Amine Arous on 05/03/2023.
//

import UIKit

struct NavigationUtil {

  static func getRootViewController() -> UIViewController? {
    findNavigationController(viewController: UIApplication.shared.keyWindow?.rootViewController)?.visibleViewController
  }

  static func popToRootView(animated: Bool = true, completion: (() -> Void)? = nil) {
    getRootViewController()?.navigationController?.popToRootViewController(animated: animated, completion: completion)
  }


  static func present(view: UIViewController) {
    getRootViewController()?.present(view, animated: true)
  }

  static func popViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
    getRootViewController()?.navigationController?.popViewController(animated: animated, completion: completion)
  }

  static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
    guard let viewController = viewController else {
      return nil
    }

    if let navigationController = viewController as? UINavigationController {
      return navigationController
    }

    for childViewController in viewController.children {
      return findNavigationController(viewController: childViewController)
    }

    return nil
  }
}

extension UINavigationController {

  func popToRootViewController(animated: Bool = true, completion:(() -> Void)? = nil) {
    popToRootViewController(animated: animated)

    if animated, let coordinator = transitionCoordinator {
      coordinator.animate(alongsideTransition: nil) { _ in
        completion?()
      }
    } else {
      completion?()
    }
  }


  func pushViewController(viewController: UIViewController, animated: Bool, completion:(() -> Void)? = nil) {
    pushViewController(viewController, animated: animated)

    if animated, let coordinator = transitionCoordinator {
      coordinator.animate(alongsideTransition: nil) { _ in
        completion?()
      }
    } else {
      completion?()
    }
  }

  func popViewController(animated: Bool, completion: (() -> Void)? = nil) {
    popViewController(animated: animated)

    if animated, let coordinator = transitionCoordinator {
      coordinator.animate(alongsideTransition: nil) { _ in
        completion?()
      }
    } else {
      completion?()
    }
  }
}
