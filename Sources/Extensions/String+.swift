//
//  String+.swift
//  StringLogger_Example
//
//  Created by 영준 이 on 2021/05/17.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

extension String{
    open class Logger : NSObject{
        
        /// Log Level from fatal to trace
        public enum LogLevel : Int{
            case fatal = 0
            case critical
            case error
            case warning
            case notice
            case info
            case debug
            case trace
            static let max : LogLevel = .fatal;
        }
        
        /** Logging Prefix Option
                - file: Source File Name
                - line: Source File Line
                - function: Method Name
                - date: Date
         
                - default: file & line & function & date
        */
        public struct LogOption : OptionSet {
            public let rawValue: UInt;
            
            public init(rawValue: UInt) {
                self.rawValue = rawValue;
            }
            
            public static let file : LogOption = .init(rawValue: 1 << 1);
            public static let line : LogOption = .init(rawValue: 1 << 2);
            public static let function : LogOption = .init(rawValue: 1 << 3);
            public static let date : LogOption = .init(rawValue: 1 << 4);
            
            public static var `default` : LogOption = [.file, .function, .line, .date];
        }
        
        public var level : LogLevel = .info;
        public var icons : [LogLevel : Character] = [.info: "ℹ️",
                                                     .notice: "💡",
                                                     .trace: "🔦",
                                                     .warning: "⚠️",
                                                     .error: "❗️",
                                                     .critical: "☹️",
                                                     .fatal: "👿",
                                                     .debug: "🔍"];
        
        static let defaultDateFormat = "yyyy-MM-dd HH:mm:ss.SSS";
        /// Date Prefix Format
        public var dateFormat : String = defaultDateFormat{
            didSet{
                self.formatter.dateFormat = self.dateFormat;
            }
        }
        fileprivate lazy var formatter : DateFormatter = createFormatter();
        fileprivate func createFormatter() -> DateFormatter{
            let value : DateFormatter = .init();
            
            value.dateFormat = self.dateFormat;
            
            return value;
        }
        
        private(set) static var loggers : [Logger] = [Logger.console];
        /// Register New Logger
        /// - Parameter logger: Logger to register
        static func register(_ logger: Logger){
            self.loggers.append(logger);
        }
        
        /// Register this logger
        /// - Returns: this logger
        @discardableResult public func register() -> Logger{
            Logger.register(self);
            return self;
        }
        
        public static let console = ConsolLogger();
        public class ConsolLogger : Logger{
            fileprivate override init() {
                super.init();
            }
        }
        
        /// Logging will be filtered if you return false
        /// - Returns: Whether can log
        func canLog(level: Logger.LogLevel, FILE: String = #file, FUNCTION: String = #function) -> Bool{
            return level.rawValue <= self.level.rawValue;
        }
        
        open func log(msg: String, level: Logger.LogLevel, option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){
            guard self.canLog(level: level, FILE: FILE, FUNCTION: FUNCTION) else{
                return;
            }
            
            let file = FILE.components(separatedBy: "/").last ?? FILE;
            let fileline = [option.contains(.file) ? file : nil,
                            option.contains(.line) ? LINE.description : nil].compactMap{ $0 }
                           .joined(separator: ":");
            let function = FUNCTION; //Logger.Configuration.shortFunctions[FUNCTION] ??
            let prefix : [String] = [fileline,
                                     option.contains(.function) ? function : nil,
                                     ]
                                        .compactMap{ $0 };
            
            let icon : Character = self.icons[level] ?? .empty;
            
            let date : String? = option.contains(.date) ? self.formatter.string(from: Date()) : nil;
            let newPrefix = ([date] + prefix.map{ $0 }).compactMap{ $0 };
            let formattedMsg = "\(newPrefix.any ? "[\(newPrefix.joined(separator: " "))] \(msg)" : "\(msg)" )"; //\(icon)
            
            if level.rawValue >= Logger.LogLevel.debug.rawValue{
                debugPrint("\(icon) " + formattedMsg);
            }else{
                print("\(icon) " + formattedMsg);
            }
        }
        
        fileprivate static func log(msg: String, level: Logger.LogLevel, option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){
            let loggers = self.loggers.filter{ $0.canLog(level: level, FILE: FILE, FUNCTION: FUNCTION) };
            
            guard loggers.any else{
                return;
            }
            
            loggers.forEach { (logger) in
                logger.log(msg: msg, level: level, option: option, FILE: FILE, FUNCTION: FUNCTION, LINE: LINE);
            }
        }
    }
}

public extension String{
    //String.logger.console.logLevel =
//    static var logLevel: Logger.LogLevel{
//        get{
//            return Logger.Configuration.logLevel;
//        }
//
//        set{
//            Logger.Configuration.logLevel = newValue;
//        }
//    }
//
//    static var logDateFormat: String{
//        get{
//            return Logger.Configuration.dateFormat;
//        }
//
//        set{
//            Logger.Configuration.dateFormat = newValue;
//        }
//    }
//
//    static var defaultLogOption: Logger.LogOption{
//        get{
//            return Logger.LogOption.default;
//        }
//
//        set{
//            Logger.LogOption.default = newValue;
//        }
//    }
    
    fileprivate func log(level: Logger.LogLevel, option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){ //args: Any...
//        let level = level ?? self.level;
//
//        guard level.rawValue <= Logger.Configuration.logLevel.rawValue else{
//            return;
//        }
        
        //option == [];
        
        Logger.log(msg: self, level: level, option: option, FILE: FILE, FUNCTION: FUNCTION, LINE: LINE);
//        if level.rawValue >= Logger.LogLevel.debug.rawValue{
//            debugPrint("\(icon) \(prefix.any ? "[\(prefix.joined(separator: ":"))] \(self)" : "\(self)" )");
//        }else{
//            print("\(icon) \(prefix.any ? "[\(prefix.joined(separator: ":"))] \(self)" : "\(self)" )");
//        }
        //print("<\(FILE):(\(FUNCTION),\(LINE))> \(format)", args);
    }
    
    /// Write fatal log
    /// - Parameters:
    ///   - option: Log Option for Log Prefixes
    ///   - FILE: Source File Name calling this logging method
    ///   - FUNCTION: Function Name calling this logging method
    ///   - LINE: Line Position in the Source File.
    func fatal(option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){
        self.log(level: .fatal, option: option, FILE: FILE, FUNCTION: FUNCTION, LINE: LINE);
    }
    
    /// Write critical log
    /// - Parameters:
    ///   - option: Log Option for Log Prefixes
    ///   - FILE: Source File Name calling this logging method
    ///   - FUNCTION: Function Name calling this logging method
    ///   - LINE: Line Position in the Source File.
    func critical(option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){
        self.log(level: .critical, option: option, FILE: FILE, FUNCTION: FUNCTION, LINE: LINE);
    }
    
    /// Write error log
    /// - Parameters:
    ///   - option: Log Option for Log Prefixes
    ///   - FILE: Source File Name calling this logging method
    ///   - FUNCTION: Function Name calling this logging method
    ///   - LINE: Line Position in the Source File.
    func error(option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){
        self.log(level: .error, option: option, FILE: FILE, FUNCTION: FUNCTION, LINE: LINE);
    }
    
    /// Write warning log
    /// - Parameters:
    ///   - option: Log Option for Log Prefixes
    ///   - FILE: Source File Name calling this logging method
    ///   - FUNCTION: Function Name calling this logging method
    ///   - LINE: Line Position in the Source File.
    func warning(option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){
        self.log(level: .warning, option: option, FILE: FILE, FUNCTION: FUNCTION, LINE: LINE);
    }
    
    /// Write notice log
    /// - Parameters:
    ///   - option: Log Option for Log Prefixes
    ///   - FILE: Source File Name calling this logging method
    ///   - FUNCTION: Function Name calling this logging method
    ///   - LINE: Line Position in the Source File.
    func notice(option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){
        self.log(level: .notice, option: option, FILE: FILE, FUNCTION: FUNCTION, LINE: LINE);
    }
    
    /// Write information log
    /// - Parameters:
    ///   - option: Log Option for Log Prefixes
    ///   - FILE: Source File Name calling this logging method
    ///   - FUNCTION: Function Name calling this logging method
    ///   - LINE: Line Position in the Source File.
    func info(option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){
        self.log(level: .info, option: option, FILE: FILE, FUNCTION: FUNCTION, LINE: LINE);
    }
    
    /// Write the debugging log
    /// - Parameters:
    ///   - option: Log Option for Log Prefixes
    ///   - FILE: Source File Name calling this logging method
    ///   - FUNCTION: Function Name calling this logging method
    ///   - LINE: Line Position in the Source File.
    func debug(option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){
        self.log(level: .debug, option: option, FILE: FILE, FUNCTION: FUNCTION, LINE: LINE);
    }
    
    /// Write the tracing log
    /// - Parameters:
    ///   - option: Log Option for Log Prefixes
    ///   - FILE: Source File Name calling this logging method
    ///   - FUNCTION: Function Name calling this logging method
    ///   - LINE: Line Position in the Source File.
    func trace(option: Logger.LogOption = .default, FILE: String = #file, FUNCTION: String = #function, LINE: Int = #line){
        self.log(level: .trace, option: option, FILE: FILE, FUNCTION: FUNCTION, LINE: LINE);
    }
}

fileprivate extension Array{
    var any : Bool { !self.isEmpty }
}

fileprivate extension Character{
    static let empty : Character = .init("");
}
