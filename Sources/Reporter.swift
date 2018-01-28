import Foundation
import Dispatch
#if os(OSX) || os(tvOS) || os(watchOS) || os(iOS)
  import Darwin.libc
#else
  import Glibc
#endif

private let outputQueue: DispatchQueue = {
    let queue = DispatchQueue(
        label: "jp.toshi0383.reporter.outputQueue",
        qos: .default,
        target: .global(qos: .default)
    )

    #if !os(Linux)
    atexit_b {
        queue.sync(flags: .barrier) {}
    }
    #endif

    return queue
}()

/**
 A thread-safe version of Swift's standard print().

 - parameter object: Object to print.
 */
public func queuedPrintln<T>(_ object: T, color: ANSI? = nil) {
    let color = color?.description ?? ""
    #if !os(Linux)
    outputQueue.sync {
        fputs("\(color)\(object)\(ANSI.reset)\n", stdout)
        fflush(stdout)
    }
    #else
        fputs("\(color)\(object)\(ANSI.reset)\n", stdout)
        fflush(stdout)
    #endif
}

/// fflush at last
public func queuedPrint<T>(_ object: T, color: ANSI? = nil) {
    let color = color?.description ?? ""
    #if !os(Linux)
    outputQueue.sync {
        fputs("\(color)\(object)\(ANSI.reset)", stdout)
        fflush(stdout)
    }
    #else
        fputs("\(color)\(object)\(ANSI.reset)", stdout)
        fflush(stdout)
    #endif
}

public func queuedPrintWarning<T>(_ message: T) {
    queuedPrint(message, color: .yellow)
}

public func queuedPrintlnWarning<T>(_ message: T) {
    queuedPrintln(message, color: .yellow)
}

public func queuedPrintError<T>(_ object: T) {
    #if !os(Linux)
    outputQueue.sync {
        fputs("\(ANSI.red)\(object)\(ANSI.reset)", stderr)
        fflush(stderr)
    }
    #else
        fputs("\(ANSI.red)\(object)\(ANSI.reset)", stderr)
        fflush(stderr)
    #endif
}

public func queuedPrintlnError<T>(_ object: T) {
    #if !os(Linux)
    outputQueue.sync {
        fputs("\(ANSI.red)\(object)\(ANSI.reset)\n", stderr)
        fflush(stderr)
    }
    #else
        fputs("\(ANSI.red)\(object)\(ANSI.reset)\n", stderr)
        fflush(stderr)
    #endif
}

public enum ANSI: String, CustomStringConvertible {
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"

    case bold = "\u{001B}[0;1m"
    case reset = "\u{001B}[0;0m"

    public var description:String {
        if isatty(STDOUT_FILENO) > 0 {
            return rawValue
        }
        return ""
    }
}

