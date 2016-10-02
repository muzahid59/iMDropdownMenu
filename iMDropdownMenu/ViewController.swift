//
//  ViewController.swift
//  iMDropdownMenu
//
//  Created by Muzahidul Islam on 3/22/16.
//  Copyright © 2016 iMuzahid. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

	@IBOutlet var selectedCellLabel: UILabel!
	var menu: iMenu!
	override func viewDidLoad() {
		super.viewDidLoad()
    
		self.title = "iMenu"
		
		menu = iMenu(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 200))
		menu.addItems(["Leicester City","Tottenham","Arsenal","Man City","West Ham"])
		menu.iDelegate = self
		menu.addToView(self.view)
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	@IBAction func menuButtonAction(_ sender: AnyObject) {
		
		menu.show()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

extension ViewController: iMenuDelegate{
	func tapOnMenu(_ name: String, atIndex index: Int){
		selectedCellLabel.text = name
	}
}

