extension Improv {
	enum Error: Swift.Error {
		case missingSnippet(String)
		case emptyPhrases(groups: [Group], currentSnippet: Snippet?)
	}
}
