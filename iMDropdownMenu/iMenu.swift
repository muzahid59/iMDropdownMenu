//
//  iMenu.swift
//  FlowGame
//
//  Created by Muzahidul Islam on 2/16/16.
//  Copyright © 2016 iMuzahid. All rights reserved.
//

import UIKit


class Color {
	static let textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
	static let placeHoderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
	static let themecolor = UIColor(red: 39/255, green: 175/255, blue: 15/255, alpha: 1)
}



protocol iMenuDelegate{
	
	func tapOnMenu(name: String, atIndex index: Int)
	
}

class iMenu: UIView {
	
	private var items:[UIButton] // Number of Cell in Menu
	private var blur: UIView?  // Background make blur
	private var superView:UIView? // the super view that hold the menu
	private var myFrame:CGRect
	private var isHide = true
	
	var delegate: iMenuDelegate?
	
	let k_item_height:CGFloat = 44.0 // Menu Cell height
	
	override init(frame: CGRect) {
		self.items = [UIButton]()
		myFrame = frame
		
		super.init(frame: frame)
		
		self.blurViewSetUp()
	}
	
	// Background blur view
	
	func blurViewSetUp(){
		blur = UIView()
		let tap = UITapGestureRecognizer(target: self, action: #selector(iMenu.tapOnBackGround(_:)))
		blur?.addGestureRecognizer(tap)
		blur?.userInteractionEnabled = true
		blur!.backgroundColor = UIColor.blackColor()
		blur!.layer.opacity = 0.4
	}
	
	func tapOnBackGround(tap: UITapGestureRecognizer){
		self.hide()
	}
	
	/**
	Remove the previous items and added the new set of items
	*/
	func setItems(items:[String]){
		self.items = []
		for name in items{
			self.items.append(newItem(name))
		}
		reload()
	}
	
	/**
	Add single item to the menu list
	- parameters:
	- name: Name to the new item to add
	*/
	func addItem(name: String){
		self.items.append(newItem(name))
		reload()
	}
	
	/**
	Add multiple items to the menu list.
	- parameters:
	- items: The array of string.
	*/
	func addItems(items:[String]){
		for name in items{
			
			self.items.append(newItem(name))
		}
		reload()
	}
	
	/**
	- parameteres:
	- index: The array of index of the item which becomes enable
	*/
	
	func enableItemAtIndexes(indexes: [Int]){
		
		for index in indexes{
			
			if index < items.count {
				
				self.items[index].enabled  = true
				self.items[index].setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
				
			}else{
				print("index out of range")
			}
			
		}
		
	}
	
	/**
	
	- parameters:
	- indexes: The array of index of the item which becomes disable
	
	*/
	
	func disableItemAtIndexes(indexes:[Int]){
		
		for index in indexes{
			
			if index < items.count {
				
				self.items[index].enabled  = false
				self.items[index].setTitleColor(Color.placeHoderColor, forState: UIControlState.Normal)
				
			}else{
				print("index out of range")
			}
			
		}
		
	}
	
	
	/**
	Create new item for the menu.
	- parameters:
	- name: Name of the new item for the menu.
	*/
	
	private func newItem(name: String)->UIButton{
		let newItem = UIButton()
		newItem.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), k_item_height)
		newItem.setTitle(name, forState: .Normal)
		newItem.titleLabel?.font = UIFont.systemFontOfSize(20)
		newItem.backgroundColor = Color.themecolor
		newItem.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		newItem.layer.borderWidth = 0.5
		newItem.layer.borderColor = UIColor.blackColor().CGColor
		return newItem
	}
	
	/**
	Re arrange the subviews after made any change
	*/
	
	func reload(){
		
		for view in self.subviews{
			view.removeFromSuperview()
		}
		
		self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGFloat(self.items.count) * k_item_height)
		myFrame = self.frame
		
		guard !self.items.isEmpty else{
			return
		}
		
		var yPos:CGFloat = 0
		
		
		for i in 0..<self.items.count{
			items[i].frame.origin.y = yPos
			items[i].tag = i
			items[i].addTarget(self, action: #selector(iMenu.tapOnCell(_:)), forControlEvents: UIControlEvents.TouchUpInside)
			self.addSubview(items[i])
			yPos = yPos + k_item_height
		}
		
		if let blur = self.blur{
			blur.frame = CGRectMake(CGRectGetMinX(blur.frame), CGRectGetHeight(self.myFrame), CGRectGetWidth(blur.frame), CGRectGetHeight(blur.frame) - CGRectGetHeight(self.myFrame))
		}
		
	}
	
	/**
	Super view of the menu item in which the subviews are added
	
	- parameters:
	- view: The main view or container view under which the list become visiable.
	*/
	
	func addToView(view: UIView){
		
		self.superView = view
		blur?.frame = self.superView!.bounds
		
	}
	
	/**
	The item which is tapped
	- parameters:
	- sender: UIButton in which is tapped
	*/
	func tapOnCell(sender: UIButton){
		
		self.hide()
		
		if let del = self.delegate{
			if let title = sender.currentTitle{
				del.tapOnMenu(title, atIndex: sender.tag)
			}else{
				del.tapOnMenu("cell name not found", atIndex: sender.tag)
			}
			
		}
		
	}
	
	/**
	Make visible the menu
	*/
	func show(){
		
		guard let mainView = self.superView else{
			print("Super view did not set")
			return
		}
		
		// already visible
		if !isHide{
			return
		}
		
		// if blur view does not added the main view
		if !blur!.isDescendantOfView(mainView){
			mainView.addSubview(blur!)
			
		}
		
		// if the menu container view does not added tha super view
		if !self.isDescendantOfView(mainView){
			mainView.addSubview(self)
		}
		
		self.frame = CGRectMake(CGRectGetMinX(self.myFrame), CGRectGetMinY(self.myFrame)-CGRectGetHeight(self.myFrame), CGRectGetWidth(self.myFrame), CGRectGetHeight(self.myFrame))
		
		// menu make animated
		[UIView .animateWithDuration(0.2, animations: { () -> Void in
			self.frame = self.myFrame
			}, completion: { (bool) -> Void in
				self.isHide = false
				self.shake()
		})]
		
		
	}
	
	/**
	Hide the menu view
	*/
	
	func hide(){
		
		// already hidden
		if isHide{
			return
		}
		
		[UIView .animateWithDuration(0.2, animations: { () -> Void in
			self.frame = CGRectMake(CGRectGetMinX(self.myFrame), CGRectGetMinY(self.myFrame)-CGRectGetHeight(self.myFrame), CGRectGetWidth(self.myFrame), CGRectGetHeight(self.myFrame))
			}, completion: { (bool) -> Void in
				self.isHide = true
				self.blur?.removeFromSuperview()
				self.removeFromSuperview()
		})]
		
	}
	required init?(coder aDecoder: NSCoder) {
		//	super.init(coder: aDecoder)
		fatalError("init(coder:) has not been implemented")
	}
	
}

/**
View extension for shake animation
*/
extension UIView{
	func shake(){
		let animation = CABasicAnimation(keyPath: "position")
		animation.duration = 0.1
		animation.repeatCount = 0
		animation.autoreverses = false
		animation.fromValue = NSValue(CGPoint: CGPointMake(self.center.x , self.center.y + 10))
		animation.toValue = NSValue(CGPoint: CGPointMake(self.center.x , self.center.y))
		self.layer.addAnimation(animation, forKey: "position")
	}
}

