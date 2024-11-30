class_name RandomUtils

# Ensure RNG is initialized
static func randomize_seed():
	randomize()

# Random integer in range [a, b]
static func randint(a: int, b: int) -> int:
	return int(randf_range(a, b + 1))

# Random float in range [a, b)
static func uniform(a: float, b: float) -> float:
	return randf_range(a, b)

# Random choice from list
static func choice(list: Array) -> Variant:
	if list.size() == 0:
		return null
	return list[int(randf_range(0, list.size()))]
