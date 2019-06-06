import XCTest
@testable import Improv

final class ImprovTests: XCTestCase {
    func testImprov() throws {
		let spec = Spec([
			"animal": [
				Group(tags: ["class": "mammal"], phrases: ["dog", "cat"]),
				Group(tags: ["class": "bird"], phrases: ["parrot", "eagle"])
			],
			"root": [
				Group(tags: [:], phrases: ["[name]: I have a [:animal] who is [#2-7] years old."])

			]]
		)
		
		var bob = Model(name: "Bob", tags: [:])
		var alice = Model(name: "Alice", tags: ["class": "mammal"])
		var carol = Model(name: "Carol", tags: ["class": "bird"])
		
		var improv = Improv(spec: spec)
		
		let lines: [String] = [
			try improv.generate(snippet: "root", model: &bob),
			try improv.generate(snippet: "root", model: &alice),
			try improv.generate(snippet: "root", model: &carol),
		]
		print(lines)
		XCTAssertTrue(lines.count == 3)
    }

    static var allTests = [
        ("testImprov", testImprov),
    ]
}
