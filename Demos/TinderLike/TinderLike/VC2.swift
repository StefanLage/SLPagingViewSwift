//
//  VC2.swift
//  TinderLike
//
//  Created by Bari Levi on 28/11/2016.
//  Copyright © 2016 Stefan Lage. All rights reserved.
//

import Foundation
import UIKit

class VC2: UIViewController {
    
    override func viewDidLoad() {
        NSLog("viewDidLoad       - 2")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("viewWillAppear    - 2")
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("viewDidAppear     - 2")
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("viewWillDisappear - 2")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSLog("viewDidDisappear  - 2")
    }
    
}
