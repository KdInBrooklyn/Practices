//
//  Theme.swift
//  Pet Finder
//
//  Created by 李森 on 2017/8/10.
//  Copyright © 2017年 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit


enum Theme: Int {
  case `default`, dark, graphical
  
  private enum Keys {
    static let selectedTheme = "SelectedTheme"
  }
  
  static var current: Theme {
    let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
    return Theme(rawValue: storedTheme) ?? .default
  }
  
  var mainColor: UIColor {
    switch self {
    case .default:
      return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    case .dark:
      return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    case .graphical:
      return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
    }
  }
  
  var barStyle: UIBarStyle {
    switch self {
    case .default, .graphical:
      return .default
    case .dark:
      return .black
    }
  }
  
  //导航栏背景图片
  var navigationBackgroundImage: UIImage? {
    return self == .graphical ? UIImage(named: "navBackground") : nil
  }
  
  //底部导航栏背景图片
  var tabBarBackgroundImage: UIImage? {
    return self == .graphical ? UIImage(named: "tabBarBackground") : nil
  }
  
  //UITableViewCell样式修改
  var backgroundColor: UIColor {
    switch self {
    case .default, .graphical:
      return UIColor.white
    case .dark:
      return UIColor(white: 0.4, alpha: 1.0)
    }
  }
  
  var textColor: UIColor {
    switch self {
    case .default, .graphical:
      return UIColor.black
    case .dark:
      return UIColor.white
    }
  }
  
  func apply() {
    UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
    UserDefaults.standard.synchronize()
    
    //修改所有视图的tintColor
    UIApplication.shared.delegate?.window??.tintColor = mainColor
    //修改导航栏样式显示
    UINavigationBar.appearance().barStyle = barStyle
    UINavigationBar.appearance().setBackgroundImage(navigationBackgroundImage, for: .default)
    
    //修改导航栏返回按钮
    UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
    
    //修改底部导航栏样式显示
    UITabBar.appearance().barStyle = barStyle
    UITabBar.appearance().backgroundImage = tabBarBackgroundImage
    
    //修改底部导航栏背景显式
    let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
    let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0))
    UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
    
    //修改Segment样式显示
    let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    .resizableImage(withCapInsets: UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0))
    //修改被选中是背景
    let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0))
    //通过Appearance协议进行修改
    UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
    UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
    
    //修改UIStepper显示样式
    UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
    UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
    UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
    UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
    UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)
    
    //修改UISlider显示样式
    UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
    UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 6.0)), for: .normal)
    UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 0.0, left: 6.0, bottom: 0.0, right: 0.0)), for: .normal)
    
    //修改UISwitch显示样式
    UISwitch.appearance().onTintColor = mainColor.withAlphaComponent(0.3)
    UISwitch.appearance().thumbTintColor = mainColor
    
    //修改UITableViewCell
    UITableViewCell.appearance().backgroundColor = backgroundColor
    UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
  }
  
}

