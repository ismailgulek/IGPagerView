//
//  IGPagerView.swift
//
//  Created by Ismail GULEK
//  Copyright © 2017 Ismail Gulek. All rights reserved.
//

import UIKit

public protocol IGPagerViewDataSource: NSObjectProtocol {
	func pagerViewNumberOfPages(_ pager: IGPagerView) -> Int
	func pagerView(_ pager: IGPagerView, viewAt index: Int) -> UIView
}

public protocol IGPagerViewDelegate: NSObjectProtocol {
	func pagerView(_ pager: IGPagerView, didScrollToPageAt index: Int) -> Void
}

open class IGPagerView: UIView {

	weak var dataSource: IGPagerViewDataSource? {
		didSet {
			self.reloadData()
		}
	}
	weak var delegate: IGPagerViewDelegate?
	
	fileprivate lazy var scrollView: UIScrollView = {
		let scr = UIScrollView()
		scr.isPagingEnabled = true
		scr.showsVerticalScrollIndicator = false
		scr.showsHorizontalScrollIndicator = false
		scr.delegate = self
		return scr
	}()
	fileprivate(set) var currentPage: Int = 0
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
		self.reloadData()
	}
	
	fileprivate func setup() {
		self.addSubview(self.scrollView)
	}
	
	public func reloadData() {
		for subview in self.scrollView.subviews {
			subview.removeFromSuperview()
		}
		
		if let ds = self.dataSource {
			let numberOfPages = ds.pagerViewNumberOfPages(self)
			for i in 0 ..< numberOfPages {
				let view = ds.pagerView(self, viewAt: i)
				self.scrollView.addSubview(view)
			}
			self.setNeedsLayout()
		}
	}
	public func goToPage(_ page: Int, animated: Bool = true) {
		let point = CGPoint(x: CGFloat(page) * self.scrollView.frame.width, y: 0)
		self.scrollView.setContentOffset(point, animated: animated)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		self.scrollView.frame = self.bounds
		let scrollWidth = self.scrollView.frame.width
		let scrollHeight = scrollView.frame.height
		for i in 0 ..< scrollView.subviews.count {
			let subview = scrollView.subviews[i]
			
			subview.frame = CGRect(x: CGFloat(i)*scrollWidth, y: 0, width: scrollWidth, height: scrollHeight)
		}
		self.scrollView.contentSize = CGSize(width: CGFloat(self.scrollView.subviews.count) * scrollWidth, height: scrollHeight)
		self.goToPage(currentPage, animated: false)
	}
	
	fileprivate func changePage() {
		let page = scrollView.contentOffset.x / scrollView.frame.width
		let newValue = Int(floor(Double(page)))
		let notify = currentPage != newValue
		currentPage = newValue
		if notify {
			self.delegate?.pagerView(self, didScrollToPageAt: currentPage)
		}
	}

}

extension IGPagerView: UIScrollViewDelegate {
	
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		changePage()
	}
	
}
