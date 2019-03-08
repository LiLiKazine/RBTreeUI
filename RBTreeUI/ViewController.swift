//
//  ViewController.swift
//  RBTreeUI
//
//  Created by LiLi Kazine on 2019/3/5.
//  Copyright © 2019 LiLi Kazine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var valueInput: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var treeContentView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var bottomPaddingConstrant: NSLayoutConstraint!
    @IBOutlet weak var popViewBottomConstraint: NSLayoutConstraint!
    
    var treeView: TreeView<Int>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.grey
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        deleteBtn.layer.cornerRadius = deleteBtn.bounds.width / 2
        deleteBtn.setTitleColor(.white, for: .normal)
        deleteBtn.backgroundColor = Colors.red_light
        addBtn.layer.cornerRadius = addBtn.bounds.width / 2
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = Colors.blue
        popView.layer.cornerRadius = 8.0
        popView.alpha = 0.9
        confirmBtn.setTitleColor(Colors.blue, for: .normal)
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
            popup(forAddtion: false)
        case addBtn:
            popup(forAddtion: true)
        case confirmBtn:
            act()
        default:
            break
        }
        valueInput.text = nil
    }
    
    @objc func hideKeyboard() {
        valueInput.resignFirstResponder()
    }
    
    func popup(forAddtion addtion: Bool)  {
        if addtion {
            popView.layer.setValue("addtion", forKey: "handle")
        } else {
            popView.layer.setValue("deletion", forKey: "handle")
        }
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.popViewBottomConstraint.constant = self.view.bounds.height / 2
            self.view.layoutIfNeeded()
            self.valueInput.becomeFirstResponder()

        })
    }

    func act() {
        if let handle = popView.layer.value(forKey: "handle") as? String, handle == "addtion" {
            addNode()
        }
        if let handle = popView.layer.value(forKey: "handle") as? String, handle == "deletion" {
            deleteNode()
        }
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.popViewBottomConstraint.constant = -120
            self.view.layoutIfNeeded()
        }, completion: nil)
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
                    UIView.transition(with: treeView!, duration: 0.4, options: .transitionCrossDissolve, animations: {
                        self.treeView!.setNeedsDisplay()
                    })
                } catch let err {
                    print(err)
                }
            }
        }

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

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return treeContentView
    }
}
