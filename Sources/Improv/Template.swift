public enum Template {
	
}

extension Template {
	
	
	/// Original source: [template.js#processDirective](https://github.com/sequitur/improv/blob/master/lib/template.js#L41-L92)
	static func processDirective(rawDirective: String, model: Model, generator: Improv, callback: (String, Model) -> String?) throws -> String? {
		
		let directive = rawDirective.trimmingCharacters(in: .whitespacesAndNewlines)
		guard directive.count > 0 else {
			fatalError("directive is too small?")
		}
		
		if directive.hasPrefix(#"\"#) {
			// This is a literal directive.
			return String(directive.dropFirst().dropLast())
		}
		
		if let index = directive.firstIndex(of: " ") {
			// The directive contains a space, which means it's a chained directive.
			fatalError("chained directives not handled")
//			const funcName = directive.split(' ')[0];
//			const rest = directive.slice(directive.indexOf(' ') + 1);
//			// eslint-disable-next-line no-prototype-builtins
//			if (TEMPLATE_BUILTINS.hasOwnProperty(funcName)) {
//				return `${TEMPLATE_BUILTINS[funcName](processDirective(rest, model, cb, generator))}`;
//			}
//			if (generator && generator.builtins && generator.builtins[funcName]) {
//				return `${generator.builtins[funcName](processDirective(rest, model, cb, generator))}`;
//			}
//			if (typeof model[funcName] !== 'function') {
//				throw new Error(`Builtin or model property "${funcName}" is not a function.`);
//			}
//			return `${model[funcName](processDirective(rest, model, cb, generator))}`;
		}
		
		if directive.hasPrefix("|") {
			fatalError("| not handled")
//			const [tagStr, snippet] = directive.split(':');
//			// Disregard the first |
//			const newTag = tagStr.slice(1).split('|');
//			const newModel = Object.create(model);
//
//			newModel.tags = mergeInTag(model.tags, newTag);
//
//			return cb(snippet, newModel);
		}
		
		if directive.hasPrefix(">") {
			fatalError("submodels not handled")
//			const [subModelName, subSnippet] = directive.split(':');
//			if (!subSnippet) throw new Error(`Bad or malformed snippet name in directive ${directive}.`);
//			return cb(subSnippet, model, subModelName);
		}
		
		if directive.hasPrefix(":") {
			let newDirective = String(directive.dropFirst())
			return callback(newDirective, model)
		}
		
		if directive.hasPrefix("#") {
			// Random number generator
			let numbers = directive.dropFirst().split(separator: "–")
			let num1 = Int(numbers[0])!
			let num2 = Int(numbers[1])!
			let number = (num1..<num2).randomElement()!
			return String(number)
		}
		
//		if (directive.indexOf('.') !== -1) {
//			const propChain = directive.split('.');
//			return propChain.reduce((obj, prop) => obj[prop], model);
//		}
		return directive
	}
	
	/// Original source: [template.js#template](https://github.com/sequitur/improv/blob/master/lib/template.js#L94-L109)
	static func applyTemplate(phrase: String, model: Model, generator: Improv, callback: (String, Model) -> String?) throws -> String? {
		// need to loop through all directives
		// before/after:  https://github.com/sequitur/improv/blob/master/lib/template.js#L100
		guard let rawDirective = phrase.slice(from: "[", to: "]") else {
			return phrase
		}
		let before = phrase.drop(before: "[")
		let after = phrase.drop(after: rawDirective + "]")
		let processedDirective = try self.processDirective(rawDirective: rawDirective, model: model, generator: generator, callback: callback) ?? ""
		let nextPhrase: String = before + processedDirective + after
		let directive = try applyTemplate(phrase: nextPhrase, model: model, generator: generator, callback: callback)
		return directive
	}
}
