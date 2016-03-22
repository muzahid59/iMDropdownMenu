//
//  iMenu.swift
//  FlowGame
//
//  Created by Muzahidul Islam on 2/16/16.
//  Copyright © 2016 iMuzahid. All rights reserved.
//

import UIKit

protocol iMenuDelegate{
	
	func tapOnMenu(name: String, atIndex index: Int)
	
}


let cell_background_color = UIColor.blueColor()
let cell_text_color = UIColor.whiteColor()

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
		let tap = UITapGestureRecognizer(target: self, action: "tapOnBackGround:")
		blur?.addGestureRecognizer(tap)
		blur?.userInteractionEnabled = true
		blur!.backgroundColor = UIColor.blackColor()
		blur!.layer.opacity = 0.4
	}
	
	func tapOnBackGround(tap: UITapGestureRecognizer){
		
		self.hide()
	}
	
	func addItem(name: String){
		
		
		self.items.append(newItem(name))
		
		
		reload()
	}
	
	func setItems(items:[String]){
		self.items = []
		for name in items{
			self.items.append(newItem(name))
		}
		reload()
	}
	
	func addItems(items:[String]){
		for name in items{
			
				self.items.append(newItem(name))
		}
		reload()
	}
	
	func enableItemAtIndex(index: Int){
		
		if index < items.count {
			
			self.items[index].enabled  = true
			
		}else{
			
			print("index out of range")
			
		}
		
	}
	
	func disableItemAtIndex(index:Int){
		
		if index < items.count {
			
			self.items[index].enabled  = false
			
		}else{
			print("index out of range")
		}

		
	}
	
	private func newItem(name: String)->UIButton{
		let newItem = UIButton()
		newItem.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), k_item_height)
		newItem.setTitle(name, forState: .Normal)
		newItem.titleLabel?.font = UIFont.systemFontOfSize(20)
		newItem.backgroundColor = cell_background_color
		newItem.setTitleColor(cell_text_color, forState: .Normal)
		newItem.layer.borderWidth = 0.5
		newItem.layer.borderColor = UIColor.blackColor().CGColor
		return newItem
	}
	
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
		
		for(var i = 0; i<self.items.count; i++){
			items[i].frame.origin.y = yPos
			items[i].tag = i
			items[i].addTarget(self, action: "tapOnCell:", forControlEvents: UIControlEvents.TouchUpInside)
			self.addSubview(items[i])
			yPos = yPos + k_item_height
		}
	
		if let blur = self.blur{
			blur.frame = CGRectMake(CGRectGetMinX(blur.frame), CGRectGetHeight(self.myFrame), CGRectGetWidth(blur.frame), CGRectGetHeight(blur.frame) - CGRectGetHeight(self.myFrame))
		}
		
	}

	func addToView(view: UIView){
		
		self.superView = view
		blur?.frame = self.superView!.bounds
		
	}
	
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
	
	
	func show(){

		guard let mainView = self.superView else{
			print("Super view did not set")
			return
		}
		
		// already visible
		if !isHide{
		   return
		}
		
		if !blur!.isDescendantOfView(mainView){
			mainView.addSubview(blur!)
			
		}
		if !self.isDescendantOfView(mainView){
			mainView.addSubview(self)
		}
		
		self.frame = CGRectMake(CGRectGetMinX(self.myFrame), CGRectGetMinY(self.myFrame)-CGRectGetHeight(self.myFrame), CGRectGetWidth(self.myFrame), CGRectGetHeight(self.myFrame))
		
		[UIView .animateWithDuration(0.2, animations: { () -> Void in
			self.frame = self.myFrame
			}, completion: { (bool) -> Void in
				self.isHide = false
				self.shake()
		})]
		
		
	}
	
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

