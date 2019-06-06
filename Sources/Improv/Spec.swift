public struct Spec: Hashable, Codable {
	public var snippets: [Snippet]
	
	public init(_ snippets: [Snippet]) {
		self.snippets = snippets
	}
	
	public init(_ snippetDict: [String: [Group]]) {
		self.snippets = snippetDict.map { element in
			return .init(name: element.0, groups: element.1)
		}
	}
}

public let spec = Spec([
	"animal": [
		Group(tags: ["class": "mammal"],
					 phrases: ["dog", "cat"]),
		Group(tags: ["class": "bird"],
					 phrases: ["parrot", "eagle"])],
	"item": [
		Group(tags: ["pickup": "false"],
					 phrases: ["wall torch", "cat"]),
		Group(tags: ["class": "bird"],
					 phrases: ["parrot", "eagle"])],
	]
)
