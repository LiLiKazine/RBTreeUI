//
//  ViewController.swift
//  RBTreeUI
//
//  Created by LiLi Kazine on 2019/3/5.
//  Copyright © 2019 LiLi Kazine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var valueInput: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var treeContentView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var bottomPaddingConstrant: NSLayoutConstraint!
    
    var treeView: TreeView<Int>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.grey
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        deleteBtn.setTitleColor(.white, for: .normal)
        deleteBtn.backgroundColor = Colors.red_light
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = Colors.blue
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.keyboardNotification(notification:)),
//                                               name: UIResponder.keyboardWillChangeFrameNotification,
//                                               object: nil)
    }
    
//    @objc func keyboardNotification(notification: NSNotification) {
//        let info = notification.userInfo!
//        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let y = keyboardFrame.origin.y
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
//            self.bottomPaddingConstrant.constant = self.view.frame.height - y + 20
//        }, completion: nil)
//    }

    @IBAction func action(_ sender: UIButton) {
        hideKeyboard()
        switch sender {
        case deleteBtn:
            deleteNode()
        case addBtn:
            addNode()
        default:
            break
        }
        valueInput.text = nil
    }
    
    @objc func hideKeyboard() {
        valueInput.resignFirstResponder()
    }

    func addNode() {
        if let text = valueInput.text, let val = Int(text) {
            if let view = treeView {
                do {
                    _ = try view.tree.add(val: val)
                } catch let err {
                    print(err)
                }
            } else {
                treeView = TreeView(tree: RBTree(initial: val), frame: treeContentView.bounds)
                treeContentView.addSubview(treeView!)
            }
            UIView.transition(with: treeView!, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.treeView!.setNeedsDisplay()
            })
        }
    }
    
    func deleteNode() {
        if let text = valueInput.text, let val = Int(text) {
            if let view = treeView {
                do {
                    if treeView!.tree.size == 1 && treeView!.tree.root.val == val {
                        treeView?.removeFromSuperview()
                        treeView = nil
                        treeContentView.setNeedsLayout()
                        return
                    } else {
                        _ = try view.tree.delete(val: val, in: view.tree.root)
                    }
                } catch let err {
                    print(err)
                }
            }
        }
        UIView.transition(with: treeView!, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.treeView!.setNeedsDisplay()
        })
    }

    deinit {
//        NotificationCenter.default.removeObserver(self)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}
