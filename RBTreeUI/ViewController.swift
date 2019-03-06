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
    
    var treeView: TreeView<Int>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.grey
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        deleteBtn.setTitleColor(.white, for: .normal)
        deleteBtn.backgroundColor = Colors.red_light
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.backgroundColor = Colors.blue
    }

    @IBAction func action(_ sender: UIButton) {
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
        hideKeyboard()
    }
    
    @objc func hideKeyboard() {
        valueInput.text = nil
        valueInput.resignFirstResponder()
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
