extension String {
	/// https://stackoverflow.com/a/31727051
	func slice(from: String, to: String) -> String? {
		return (range(of: from)?.upperBound).flatMap { substringFrom in
			(range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
				String(self[substringFrom..<substringTo])
			}
		}
	}
	
	func drop(before: String) -> String {
		let components = self.components(separatedBy: before)
		guard let first = components.first else {
			return self
		}
		return first
	}
	
	func drop(after: String) -> String {
		let components = self.components(separatedBy: after)
		let last = components.dropFirst()
		return last.joined()
	}
}
