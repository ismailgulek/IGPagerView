//
//  ViewController.swift
//  IGPagerViewDemo
//
//  Created by Ismail GULEK on 19/03/2017.
//  Copyright © 2017 Ismail Gulek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var pagerView: IGPagerView! {
		didSet {
			pagerView.dataSource = self
			pagerView.delegate = self
		}
	}
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		pagerView.goToPage(sender.selectedSegmentIndex)
	}
	
}

extension ViewController: IGPagerViewDataSource {

	func pagerViewNumberOfPages(_ pager: IGPagerView) -> Int {
		return 3
	}
	func pagerView(_ pager: IGPagerView, viewAt index: Int) -> UIView {
		if index == 0 {
			let view = UIView()
			view.backgroundColor = UIColor.red
			return view
		} else if index == 1 {
			let view = UIView()
			view.backgroundColor = UIColor.green
			return view
		} else {
			let view = UIView()
			view.backgroundColor = UIColor.blue
			return view
		}
	}
	
}

extension ViewController: IGPagerViewDelegate {
	
	func pagerView(_ pager: IGPagerView, didScrollToPageAt index: Int) {
		print("Index: \(index)")
		segmentedControl.selectedSegmentIndex = index
	}
	
}
