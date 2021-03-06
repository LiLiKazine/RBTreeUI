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
    @IBOutlet weak var descLbl: UILabel!
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Redraw when view size changed.
        if let view = treeView {
            view.setNeedsLayout()
            view.layoutIfNeeded()
            view.setNeedsDisplay()
        }
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
            descLbl.text = "Addtion"
            descLbl.textColor = Colors.blue
        } else {
            popView.layer.setValue("deletion", forKey: "handle")
            descLbl.text = "Deletion"
            descLbl.textColor = Colors.red

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
                treeView!.backgroundColor = .red
                treeView!.translatesAutoresizingMaskIntoConstraints = false
                let top = NSLayoutConstraint(item: treeView!, attribute: .top, relatedBy: .equal, toItem: treeContentView, attribute: .top, multiplier: 1.0, constant: 0.0)
                let left = NSLayoutConstraint(item: treeView!, attribute: .left, relatedBy: .equal, toItem: treeContentView, attribute: .left, multiplier: 1.0, constant: 0.0)
                let bottom = NSLayoutConstraint(item: treeView!, attribute: .bottom, relatedBy: .equal, toItem: treeContentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                let right = NSLayoutConstraint(item: treeView!, attribute: .right, relatedBy: .equal, toItem: treeContentView, attribute: .right, multiplier: 1.0, constant: 0.0)
                let centerX = NSLayoutConstraint(item: treeView!, attribute: .centerX, relatedBy: .equal, toItem: treeContentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
                let centerY = NSLayoutConstraint(item: treeView!, attribute: .centerY, relatedBy: .equal, toItem: treeContentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
                treeContentView.addConstraints([top, left, bottom, right, centerX, centerY])
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
