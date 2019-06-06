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
	public var bindings: [String: String]

	public init(
		name: String,
		tags: [String: String],
		bindings: [String: String] = [:]
		) {
		self.name = name
		self.tags = tags
		self.bindings = bindings
	}
}
