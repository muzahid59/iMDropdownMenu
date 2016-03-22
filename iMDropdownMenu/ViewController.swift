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
		
		menu = iMenu(frame: CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 200))
		menu.addItems(["Leicester City","Tottenham","Arsenal","Man City","West Ham"])
		menu.delegate = self
		menu.addToView(self.view)
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	@IBAction func menuButtonAction(sender: AnyObject) {
		
		menu.show()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

extension ViewController: iMenuDelegate{
	func tapOnMenu(name: String, atIndex index: Int){
		selectedCellLabel.text = name
	}
}

