//
//  Model.swift
//  Improv
//
//  Created by Noah Emmet on 6/5/19.
//

import Foundation

/// Template
public struct Model {
	public var name: String
	public var tags: [String: String]
	internal var phrasesBoundBySnippet: [String: String]

	public init(
		name: String,
		tags: [String: String] = [:],
		boundPhrases: [String: String] = [:]
		) {
		self.name = name
		self.tags = tags
		self.phrasesBoundBySnippet = boundPhrases
	}
}
