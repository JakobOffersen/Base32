//
//  Base32Decoder.swift
//  Base32
//

import Encoding

public struct Base32Decoder: StreamDecoder {
	public typealias Element = Character
	public typealias Partial = [UInt8]
	public typealias Decoded = [UInt8]
	
	private static let EndingCount: ContiguousArray = [0, 0, 1, 0, 2, 3, 0, 4]
	private static let DecodeLookup: [Character : UInt8] = [
		"2": 2,
		"3": 3,
		"4": 4,
		"5": 5,
		"6": 6,
		"7": 7,
		"8": 8,
		"9": 9,
		"A": 10, "a": 10,
		"B": 11, "b": 11,
		"C": 12, "c": 12,
		"D": 13, "d": 13,
		"E": 14, "e": 14,
		"F": 15, "f": 15,
		"G": 16, "g": 16,
		"H": 17, "h": 17,
        "I": 18, "i": 18,
		"J": 19, "j": 19,
		"K": 20, "k": 20,
		"M": 21, "m": 21,
		"N": 22, "n": 22,
		"P": 23, "p": 23,
		"Q": 24, "q": 24,
		"R": 25, "r": 25,
		"S": 26, "s": 26,
		"T": 27, "t": 27,
        "U": 28, "u": 28,
		"V": 29, "v": 29,
		"W": 30, "w": 30,
		"X": 31, "x": 31,
		"Y": 32, "y": 32,
		"Z": 33, "z": 33,
	]
	
	private var inputQueue = [UInt8]()
	private var outputQueue = [UInt8]()
	
	public init() {}
	
	/// Add `data` to the decoding queue and decode as much as possible to the
	/// output queue
	public mutating func decode<T: Sequence>(_ data: T) where T.Element == Element {
		self.inputQueue.append(contentsOf: data
			.compactMap { Base32Decoder.DecodeLookup[$0] })
		self.decodeStep(final: false)
	}
	
	/// Add `data` to the decoding queue and return everything that can be
	/// decoded
	public mutating func decodePartial<T: Sequence>(_ data: T) -> Partial where T.Element == Element {
		self.inputQueue.append(contentsOf: data
			.compactMap { Base32Decoder.DecodeLookup[$0] })
		self.decodeStep(final: false)
		defer { self.outputQueue.removeAll(keepingCapacity: true) }
		return self.outputQueue
	}
	
	/// Stop buffering input data and decode the remaining buffer
	public mutating func finalize() -> Decoded {
		self.decodeStep(final: true)
		defer { self.outputQueue.removeAll(keepingCapacity: true) }
		return self.outputQueue
	}
	
	private mutating func decodeStep(final: Bool) {
		let remaining = self.inputQueue.count % 8
		let decoded: [UInt8] = self.inputQueue
			.dropLast(remaining)
			.asBigEndian(sourceBits: 5)
		self.outputQueue.append(contentsOf: decoded)
		
		if final {
			Base32Decoder.EndingCount.withUnsafeBufferPointer { buffer in
				let decoded: ArraySlice<UInt8> = self.inputQueue
					.suffix(remaining)
					.asBigEndian(sourceBits: 5)
					.prefix(buffer[remaining])
				self.outputQueue.append(contentsOf: decoded)
			}
			self.inputQueue.removeAll(keepingCapacity: true)
		} else {
			self.inputQueue = self.inputQueue.suffix(remaining)
		}
	}
}
