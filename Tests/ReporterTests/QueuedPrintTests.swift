import Reporter
import XCTest

class QueuedPrintTests: XCTestCase {
    func test001() {
        queuedPrint("[queuedPrint]\n")
        queuedPrintln("[queuedPrintln]")
        queuedPrint("[queuedPrint with color]\n", color: .green)
        queuedPrintln("[queuedPrintln with color]", color: .green)
        queuedPrintWarning("[queuedPrintWarning]\n")
        queuedPrintlnWarning("[queuedPrintlnWarning]")
        queuedPrintError("[queuedPrintError]\n")
        queuedPrintlnError("[queuedPrintlnError]")
    }
}

