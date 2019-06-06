public struct Improv {
	public var spec: Spec
	public var filters: [Filter]
	public var reincorporate: Bool
	public var isPersistent: Bool
	public var audit: Bool
	public var rng: RandomNumberGenerator
	
	public init(spec: Spec,
				filters: [Filter] = [],
				reincorporate: Bool = false,
				isPersistent: Bool = true,
				audit: Bool = false,
				rng: RandomNumberGenerator = SystemRandomNumberGenerator()) {
		self.spec = spec
		self.filters = filters
		self.reincorporate = reincorporate
		self.isPersistent = isPersistent
		self.audit = audit
		self.rng = rng
	}
}
