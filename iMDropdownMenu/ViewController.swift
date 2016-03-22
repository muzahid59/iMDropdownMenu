//
//  ViewController.swift
//  iMDropdownMenu
//
//  Created by Muzahidul Islam on 3/22/16.
//  Copyright © 2016 iMuzahid. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

	var menu: iMenu!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		menu = iMenu(frame: CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 200))
		menu.addItems(["Item One","Item Two","Item Three"])
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
		
	}
}

