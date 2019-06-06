public struct Improv {
	public var spec: Spec
	public var options: Options
	
	private var currentSnippet: Snippet?
	private var phraseHistory: [String] = []
	private var tagHistory: [String] = []

	public init(
		spec: Spec,
		options: Options = .init()
		) {
		self.spec = spec
		self.options = options
	}
	
	/// Original source: [index.js#gen](https://github.com/sequitur/improv/blob/master/lib/index.js#L37-L78)
	public mutating func generate(snippet snippetName: String, model: inout Model) throws -> String {
		guard let snippet = spec[snippetName] else {
			throw Error.missingSnippet(snippetName)
		}
		if let boundPhrase = model.phrasesBoundBySnippet[snippetName] {
			return boundPhrase
		}
		
		let previousSnippet = currentSnippet
		self.currentSnippet = snippet
		
		let scoredGroups = scoreGroups(snippet.groups)
		let chosenPhrase = try choosePhrase(groups: scoredGroups, model: model)
		phraseHistory.append(chosenPhrase)
		
		if options.audit {
			// https://github.com/sequitur/improv/blob/master/lib/index.js#L61-L66
//			const phraseTotal = this.__phraseAudit.get(snippet).get(chosenPhrase);
//			this.__phraseAudit.get(snippet).set(chosenPhrase, phraseTotal + 1);
		}
		
		// `template()` defined here: https://github.com/sequitur/improv/blob/master/lib/template.js#L94-L109
//		const output = template(chosenPhrase, model, this.__gen.bind(this), this);
		
		let output = try Template.applyTemplate(
			phrase: chosenPhrase,
			model: model,
			generator: self,
			callback: { (snippetName, updatedModel) -> String? in
				let snippet = self.spec[snippetName]!
				let filteredGroups = snippet.groups.filter { group in
					guard model.tags.isEmpty == false else {
						return true
					}
					return group.tags.contains(where: { groupTagKey, groupTagValue in
						let matchingTags = model.tags.filter { modelTagKey, modelTagValue in
							return groupTagKey == modelTagKey &&
							groupTagValue == modelTagValue
						}
						return !matchingTags.isEmpty
					})
				}
				let rando = filteredGroups.randomElement()?.phrases.randomElement()
				return rando
		})
		
		if spec[snippetName]?.bind == true {
			model.phrasesBoundBySnippet[snippetName] = output
		}
		
		self.currentSnippet = previousSnippet
		
		return output ?? ""
	}
	
	/// Original source: [index.js#scoreFilter](https://github.com/sequitur/improv/blob/master/lib/index.js#L211-L224)
	private func scoreGroups(_ groups: [Group]) -> [Group] {
		/*
		Starting with the scored list from applyFilters(), return a list that has
		invalid groups scrubbed out and only includes groups with a score past
		the threshold.
		*/
		// Filter out groups emptied out by dryness()
//		const validGroups = groups.filter(g => g.group.phrases.length > 0);
//		const maxScore = validGroups
//			.reduce((currentMax, b) => b.score > currentMax ? b.score : currentMax,
//					Number.NEGATIVE_INFINITY);
//		const scoreThreshold = this.salienceFormula(maxScore);
//		return validGroups.filter(o => o.score >= scoreThreshold);

		let validGroups = groups.filter { !$0.phrases.isEmpty }
		return validGroups
	}
	
	/// Original source: [index.js#selectPhrase](https://github.com/sequitur/improv/blob/master/lib/index.js#L134-L153)
	private mutating func choosePhrase(groups: [Group], model: Model) throws -> String {
		let phrases = groups.flatMap { $0.phrases }
		guard
			phrases.isEmpty == false,
			let chosenPhrase = phrases.randomElement() else {
			if options.audit {
				print(groups)
				print(model)
			}
			throw Error.emptyPhrases(groups: groups, currentSnippet: currentSnippet)
		}
		
		return chosenPhrase
//		if (this.reincorporate) this.mergeTags(model, chosen[1]);
//		if (Array.isArray(chosen[1])) {
//			this.tagHistory = chosen[1].concat(this.tagHistory);
//		}
//		return chosen[0];

	}
	
	/// https://github.com/sequitur/improv/blob/ade1b8d7d2d2bf78cf3a0fd7e02a063d92a9405e/docs/api.rst#methods
	public mutating func clearHistory() {
		phraseHistory = []
	}
	
	/// https://github.com/sequitur/improv/blob/ade1b8d7d2d2bf78cf3a0fd7e02a063d92a9405e/docs/api.rst#methods
	public mutating func clearTagHistory() {
		tagHistory = []
	}
}

