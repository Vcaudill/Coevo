import numpy as np
import statistics


eff_results = []
for _ in range(100000000):
    efficiency_score = np.random.exponential(0.01)
    eff_results.append(efficiency_score)

print("mean is :", statistics.mean(eff_results))
