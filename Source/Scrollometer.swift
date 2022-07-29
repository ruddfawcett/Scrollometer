//
//  Scrollometer.swift
//
//  Copyright (c) 2022 Rudd Fawcett (http://ruddfawcett.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

/// A simple way to track how far users are scrolling.
public final class Scrollometer {
    
    // MARK: - Typealiases
    
    /// A closure exposing the total distance a scroll view has travelled along both the x and y axes (in points).
    typealias ScrollometerClosure = (_ distanceTravelledX: CGFloat, _ distanceTravelledX: CGFloat) -> Void
    
    // MARK: - Structs
    
    /// Represents an instance of a tracking applied to a scroll view.
    private struct ScrollometerInstance {
        /// The previous `contentOffset` of the scroll view (to calculate delta).
        var previousContentOffset: CGPoint = .zero
        /// The total "distance" in points that the scroll view has travelled on the x axis.
        var currentXValue: CGFloat = 0.0
        /// The total "distance" in points that the scroll view has travelled on the y axis.
        var currentYValue: CGFloat = 0.0
        /// The KVO token for tracking changes in `contentOffset`.
        var token: NSKeyValueObservation?
    }
    
    // MARK: - Static Properties
    
    /// A private singleton to be used by this class.
    private static let shared = Scrollometer()
    
    // MARK: - Properties
    
    /// The `UIScrollView`s that `Scrollometer` is tracking. You may only track one at a time.
    private var instances: [UIScrollView : ScrollometerInstance] = [:]
    
    // MARK: - API
    
    /// Tracks the `contentOffset` of any `UIScrollView` subclass, calculating and storing
    /// the total `x` and `y` distance traveled (in points) in the `scrollView`'s lifecycle.
    ///
    /// - Note: Every iOS device has a different pixel density (PPI—pixels in an inch). As such, there
    ///   is no standard way as of yet to convert these points into any meaningful unit of measurement in
    ///   the real world (e.g. inches or centimeters). Future updates to Scrollometer will include built
    ///   in unit conversion.
    ///
    /// - Important: Side effects include setting `scrollView.contentInsetAdjustmentBehavior = .never` unless
    ///   overridden in the function call.
    ///
    /// - Parameters:
    ///   - scrollView: The `scrollView` with which to track offset.
    ///   - respectContentInsetAdjustmentBehavior: Whether or not to respect the `contentInsetAdjustmentBehavior` of the
    ///                                            `scrollView`. **Defaults to `false`**.
    ///   - closure: A closure called anytime the `contentOffset` of the `scrollView` changes.
    static func track(_ scrollView: UIScrollView,
                      respectContentInsetAdjustmentBehavior: Bool = false,
                      _ closure: @escaping Scrollometer.ScrollometerClosure) {
        guard Scrollometer.shared.instances[scrollView] == nil else { return }
        
        /// - Note: This may have unintended consequences (but guarantees the most accurate calculation).
        if !respectContentInsetAdjustmentBehavior {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        let token: NSKeyValueObservation = scrollView.observe(\.contentOffset, options: .new, changeHandler: { (scrollView, change) in
            guard let currentContentOffset = change.newValue,
                  var currentInstance = Scrollometer.shared.instances[scrollView],
                  currentContentOffset.x >= 0,
                  currentContentOffset.y >= 0,
                  currentContentOffset.x <= scrollView.contentSize.width,
                  currentContentOffset.y <= scrollView.contentSize.height else {
                return
            }
            
            let xDelta = abs(currentContentOffset.x - currentInstance.previousContentOffset.x)
            currentInstance.currentXValue += xDelta
            let yDelta = abs(currentContentOffset.y - currentInstance.previousContentOffset.y)
            currentInstance.currentYValue += yDelta
            
            closure(currentInstance.currentXValue, currentInstance.currentYValue)
            
            currentInstance.previousContentOffset = currentContentOffset
            Scrollometer.shared.instances[scrollView] = currentInstance
        })
        
        Scrollometer.shared.instances[scrollView] = Scrollometer.ScrollometerInstance(token: token)
    }
    
    deinit {
        self.instances.values.forEach { $0.token?.invalidate() }
        self.instances.removeAll()
    }
}
