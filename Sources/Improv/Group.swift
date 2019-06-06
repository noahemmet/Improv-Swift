public struct Group: Hashable, Codable {
	public var tags: [String: String]
	public var phrases: [String]
	
	public init(tags: [String: String] = [:], phrases: [String]) {
		self.tags = tags
		self.phrases = phrases
	}
}
