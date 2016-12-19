//
//  VC3.swift
//  TinderLike
//
//  Created by Bari Levi on 28/11/2016.
//  Copyright © 2016 Stefan Lage. All rights reserved.
//

import Foundation
import UIKit

class VC3: UIViewController {
    
    override func viewDidLoad() {
        NSLog("viewDidLoad       - 3")
        let button = UIButton(type: .contactAdd)
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        
        
        self.view.addSubview(button)
    }
    func buttonAction(sender: UIButton!) {
        
        self.navigationController?.pushViewController(VC0(), animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("viewWillAppear    - 3")
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("viewDidAppear     - 3")
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("viewWillDisappear - 3")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSLog("viewDidDisappear  - 3")
    }
    
}
