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
	
	func tapOnMenu(_ name: String, atIndex index: Int)
	
}



class iMenu: UIScrollView {
	
	fileprivate var items:[UIButton] // Number of Cell in Menu
	fileprivate var blur: UIView?  // Background make blur
	fileprivate var superView:UIView? // the super view that hold the menu
	fileprivate var myFrame:CGRect
	fileprivate var isHide = true
	
	var iDelegate: iMenuDelegate?
	
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
		blur?.isUserInteractionEnabled = true
		blur?.backgroundColor = UIColor.black
		blur?.layer.opacity = 0.4
	}
	
	func tapOnBackGround(_ tap: UITapGestureRecognizer){
		self.hide()
	}
	
	/**
	Remove the previous items and added the new set of items
	*/
	func setItems(_ items:[String]){
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
	func addItem(_ name: String){
		self.items.append(newItem(name))
		reload()
	}
	
	/**
	Add multiple items to the menu list.
   - parameters:
   - items: The array of string.
	*/
	func addItems(_ items:[String]){
		for name in items{
			
			self.items.append(newItem(name))
		}
		reload()
	}
	
	/**
	- parameteres:
	- index: The array of index of the item which becomes enable
	*/
	
	func enableItemAtIndexes(_ indexes: [Int]){
		
		for index in indexes{
			
			if index < items.count {
				
				self.items[index].isEnabled  = true
				self.items[index].setTitleColor(UIColor.white, for: UIControlState())
				
			}else{
				print("index out of range")
			}
			
		}
		
	}
	
	/**
	
	- parameters:
	- indexes: The array of index of the item which becomes disable
	
	*/
	
	func disableItemAtIndexes(_ indexes:[Int]){
		
		for index in indexes{
			
			if index < items.count {
				
				self.items[index].isEnabled  = false
				self.items[index].setTitleColor(Color.placeHoderColor, for: UIControlState())
				
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
	
	fileprivate func newItem(_ name: String)->UIButton{
		let newItem = UIButton()
		newItem.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: k_item_height)
		newItem.setTitle(name, for: UIControlState())
		newItem.titleLabel?.font = UIFont.systemFont(ofSize: 20)
		newItem.backgroundColor = Color.themecolor
		newItem.setTitleColor(UIColor.white, for: UIControlState())
		newItem.layer.borderWidth = 0.5
		newItem.layer.borderColor = UIColor.black.cgColor
		return newItem
	}
	
	/**
	Re arrange the subviews after made any change
	*/
	
	func reload(){
		
		for view in self.subviews{
			view.removeFromSuperview()
		}
		
		self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: CGFloat(self.items.count) * k_item_height)
		myFrame = self.frame
		
		guard !self.items.isEmpty else{
			return
		}
		
		var yPos:CGFloat = 0
		
		
		for i in 0..<self.items.count{
			items[i].frame.origin.y = yPos
			items[i].tag = i
			items[i].addTarget(self, action: #selector(iMenu.tapOnCell(_:)), for: UIControlEvents.touchUpInside)
			self.addSubview(items[i])
			yPos = yPos + k_item_height
		}
		
		if let blur = self.blur{
			blur.frame = CGRect(x: blur.frame.minX, y: self.myFrame.height, width: blur.frame.width, height: blur.frame.height - self.myFrame.height)
		}
		
	}
	
	/**
	Super view of the menu item in which the subviews are added
	
	- parameters:
	- view: The main view or container view under which the list become visiable.
	*/
	
	func addToView(_ view: UIView){
		
		self.superView = view
		blur?.frame = self.superView!.bounds
		
	}
	
	/**
	The item which is tapped
	- parameters:
	- sender: UIButton in which is tapped
	*/
	func tapOnCell(_ sender: UIButton){
		
		self.hide()
		
		if let del = self.iDelegate{
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
		if !blur!.isDescendant(of: mainView){
			mainView.addSubview(blur!)
			
		}
		
		// if the menu container view does not added tha super view
		if !self.isDescendant(of: mainView){
			mainView.addSubview(self)
		}
		
		self.frame = CGRect(x: self.myFrame.minX, y: self.myFrame.minY-self.myFrame.height, width: self.myFrame.width, height: self.myFrame.height)
		
		// menu make animated
    
		UIView.animate(withDuration: 0.2, animations: {
			self.frame = self.myFrame
			}, completion: { (bool) -> Void in
				self.isHide = false
				self.shake()
		})
		
		
	}
	
	/**
	Hide the menu view
	*/
	
	func hide(){
		
		// already hidden
		if isHide{
			return
		}
		
    
    
		UIView.animate(withDuration: 0.2, animations: {
			self.frame = CGRect(x: self.myFrame.minX, y: self.myFrame.minY-self.myFrame.height, width: self.myFrame.width, height: self.myFrame.height)
			}, completion: { (bool) -> Void in
				self.isHide = true
				self.blur?.removeFromSuperview()
				self.removeFromSuperview()
		})
		
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
		animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x , y: self.center.y + 10))
		animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x , y: self.center.y))
		self.layer.add(animation, forKey: "position")
	}
}

