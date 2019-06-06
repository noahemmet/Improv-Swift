extension Improv {
	public struct Options {
		public var filters: [Filter]
		public var reincorporate: Bool
		public var persist: Bool
		public typealias SalienceFormula = (Float) -> Float
		public var salienceFormula: SalienceFormula
		public typealias Submodeler = () -> Void
		public var submodeler: Submodeler
		public var audit: Bool
		public var rng: RandomNumberGenerator
		
		public init(
			filters: [Filter] = [],
			reincorporate: Bool = false,
			persist: Bool = true,
			salienceFormula: @escaping SalienceFormula = { $0 },
			submodeler: @escaping Submodeler = { },
			audit: Bool = false,
			rng: RandomNumberGenerator = SystemRandomNumberGenerator()
			) {
			self.filters = filters
			self.reincorporate = reincorporate
			self.persist = persist
			self.salienceFormula = salienceFormula
			self.submodeler = submodeler
			self.audit = audit
			self.rng = rng
		}
		
	}
}
