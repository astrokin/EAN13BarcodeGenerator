//
//  EAN13ViewControllerSwift.swift
//  EAN13BarcodeGenerator_Example
//
//  Created by Aliaksei Strokin on 10/27/18.
//  Copyright © 2018 Alexey Strokin. All rights reserved.
//

import UIKit
import EAN13BarcodeGenerator

class EAN13ViewControllerSwift: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barCodeView = BarCodeView(frame: CGRect(x: 103.0, y: 155.0, width: 350.0, height: 100.0))
        view.addSubview(barCodeView)
        barCodeView.barCode = GetNewRandomEAN13BarCode()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
