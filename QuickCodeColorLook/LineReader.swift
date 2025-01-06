import Foundation

class LineReader {
    let encoding: String.Encoding
    let chunkSize: Int
    var fileHandle: FileHandle!
    var buffer: Data
    var atEof: Bool = false
    
    init?(url: URL, encoding: String.Encoding = .utf8, chunkSize: Int = 4096) {
        guard let fileHandle = try? FileHandle(forReadingFrom: url) else { return nil }
        self.fileHandle = fileHandle
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.buffer = Data(capacity: chunkSize)
    }
    
    func nextLine() -> String? {
        while !atEof {
            if let range = buffer.range(of: Data([0x0A])) { // Newline character
                let subData = buffer.subdata(in: 0..<range.lowerBound)
                let line = String(data: subData, encoding: encoding)
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                atEof = true
                if buffer.count > 0 {
                    let line = String(data: buffer, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }
    
    func close() {
        try? fileHandle.close()
    }
}
//
//  Copyright Almahdi Morris Quet 2024-2025
//
