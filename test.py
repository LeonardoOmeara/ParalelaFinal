
from heat_main import main as heat_main_py
from heat_main_cyt import main as heat_main_cy_2

from timeit import repeat

niterations = 3

# Pure Python
time_python = repeat("heat_main_py()", number=niterations, repeat=1, globals=locals())
time_python = min(time_python) / niterations


# Cython with optimization
time_cython = repeat("heat_main_cy_2()", number=niterations, repeat=1, globals=locals())
time_cython = min(time_cython) / niterations


print("Pure Python:                                {:5.3f} s".format(time_python))
print("Cython:                                      {:5.3f} s".format(time_cython))

