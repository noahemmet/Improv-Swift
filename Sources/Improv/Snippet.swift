public struct Snippet: Hashable, Codable {
	public var name: String
	public var bind: Bool
	public var groups: [Group]

	public init(name: String,
				bind: Bool = false,
				groups: [Group]) {
		self.name = name
		self.bind = bind
		self.groups = groups
	}
}
