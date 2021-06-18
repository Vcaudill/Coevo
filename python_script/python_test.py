import numpy as np
import statistics


eff_results = []
for _ in range(100):
    efficiency_score = np.random.exponential(0.01)
    eff_results.append(efficiency_score)

print("mean is :", statistics.mean(eff_results))

eff_results_nor = []
for _ in range(100000):
    efficiency_score = np.random.normal(loc=0.0, scale=0.5)
    eff_results_nor.append(abs(efficiency_score))

print("abs mean is :", statistics.mean(eff_results_nor))

eff_results_nor_2 = []
for _ in range(100):
    efficiency_score = np.random.normal(loc=0.0, scale=0.01)
    eff_results_nor_2.append(efficiency_score)

print("mean is :", statistics.mean(eff_results_nor_2))
print("values are is :", eff_results_nor_2)
