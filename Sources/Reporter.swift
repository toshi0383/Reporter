#if os(OSX) || os(tvOS) || os(watchOS) || os(iOS)
  import Foundation
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
    outputQueue.async {
        let color = color?.description ?? ""
        print("\(color)\(object)\(ANSI.reset)")
    }
}
public func queuedPrint<T>(_ object: T, color: ANSI? = nil) {
    outputQueue.async {
        let color = color?.description ?? ""
        print("\(color)\(object)\(ANSI.reset)", terminator: "")
    }
}

public func queuedPrintWarning<T>(_ message: T) {
    queuedPrint(message, color: .yellow)
}

public func queuedPrintlnWarning<T>(_ message: T) {
    queuedPrintln(message, color: .yellow)
}

public func queuedPrintError<T>(_ object: T) {
    outputQueue.async {
        fflush(stdout)
        fputs("\(ANSI.red)\(object)\(ANSI.reset)", stderr)
    }
}

public func queuedPrintlnError<T>(_ object: T) {
    outputQueue.async {
        fflush(stdout)
        fputs("\(ANSI.red)\(object)\(ANSI.reset)\n", stderr)
    }
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

