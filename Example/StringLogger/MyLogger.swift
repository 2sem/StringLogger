//
//  MyLogger.swift
//  StringLogger_Example
//
//  Created by 영준 이 on 2021/05/17.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import StringLogger

class MyLogger : String.Logger{
    override init() {
        super.init();
        
        self.level = .debug;
    }
    
    override func log(msg: String, level: String.Logger.LogLevel, option: String.Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line) {
        print("MY LV\(level.rawValue) \(FUNCTION) \(msg)");
    }
}

