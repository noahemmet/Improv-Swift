// Taken from https://github.com/tensorflow/swift-apis/blob/1d484e1826c7d4efff6d9eb66d6eb6722ce84f12/Sources/TensorFlow/Random.swift

//===------------------------------------------------------------------------------------------===//
// Random Number Generators
//===------------------------------------------------------------------------------------------===//
/// A type that provides seedable deterministic pseudo-random data.
///
/// A SeedableRandomNumberGenerator can be used anywhere where a
/// RandomNumberGenerator would be used. It is useful when the pseudo-random
/// data needs to be reproducible across runs.
///
/// Conforming to the SeedableRandomNumberGenerator Protocol
/// ========================================================
///
/// To make a custom type conform to the `SeedableRandomNumberGenerator`
/// protocol, implement the `init(seed: [UInt8])` initializer, as well as the
/// requirements for `RandomNumberGenerator`. The values returned by `next()`
/// must form a deterministic sequence that depends only on the seed provided
/// upon initialization.
//public protocol SeedableRandomNumberGenerator: RandomNumberGenerator {
//	init(seed: [UInt8])
//	init<T: BinaryInteger>(seed: T)
//}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin
#else
import Glibc
#endif

public struct SeededRandomNumberGenerator: RandomNumberGenerator {
	public static var global = SeededRandomNumberGenerator(seed: UInt32(time(nil)))
	var state: [UInt8] = Array(0...255)
	var iPos: UInt8 = 0
	var jPos: UInt8 = 0
	
	/// Initialize ARC4RandomNumberGenerator using an array of UInt8. The array
	/// must have length between 1 and 256 inclusive.
	public init(seed: [UInt8]) {
		precondition(seed.count > 0, "Length of seed must be positive")
		precondition(seed.count <= 256, "Length of seed must be at most 256")
		var j: UInt8 = 0
		for i: UInt8 in 0...255 {
			j &+= S(i) &+ seed[Int(i) % seed.count]
			swapAt(i, j)
		}
	}
	
	private init<T: BinaryInteger>(seed: T) {
		var newSeed: [UInt8] = []
		for i in 0..<seed.bitWidth / UInt8.bitWidth {
			newSeed.append(UInt8(truncatingIfNeeded: seed >> (UInt8.bitWidth * i)))
		}
		self.init(seed: newSeed)
	}
	
	/// Produce the next random UInt64 from the stream, and advance the internal
	/// state.
	public mutating func next() -> UInt64 {
		var result: UInt64 = 0
		for _ in 0..<UInt64.bitWidth / UInt8.bitWidth {
			result <<= UInt8.bitWidth
			result += UInt64(nextByte())
		}
		return result
	}
	
	/// Helper to access the state.
	private func S(_ index: UInt8) -> UInt8 {
		return state[Int(index)]
	}
	
	/// Helper to swap elements of the state.
	private mutating func swapAt(_ i: UInt8, _ j: UInt8) {
		state.swapAt(Int(i), Int(j))
	}
	
	/// Generates the next byte in the keystream.
	private mutating func nextByte() -> UInt8 {
		iPos &+= 1
		jPos &+= S(iPos)
		swapAt(iPos, jPos)
		return S(S(iPos) &+ S(jPos))
	}
}
