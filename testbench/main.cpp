#include <iostream>
#include <complex>

#include "sliding_dft.hpp"
#include "testbench/test1_data.h"

using std::complex;

template<class T>
void test(const char *name)
{
	static SlidingDFT<T, test1_FFT_LENGTH> dft;
	double error_sum = 0;
	size_t num_comparisons = 0;

	for (size_t i = 0; i < test1_TIME_LENGTH; i++) {
		dft.update((T)test1_time_domain[i]);
		if (dft.is_data_valid()) {
			for (size_t j = 0; j < test1_FFT_LENGTH; j++) {
				complex<double> calculated = dft.dft[j];
				complex<double> exact(test1_dft_real[i - test1_FFT_LENGTH + 1][j], test1_dft_imag[i - test1_FFT_LENGTH + 1][j]);
				double error = abs(calculated - exact);
				/*printf("[%2i,%2i] Calculated (%10.3e,%10.3e); expected (%10.3e,%10.3e), error=%11.6e\n", i, j,
					   calculated.real(), calculated.imag(),
					   exact.real(), exact.imag(),
					   error);*/
				error_sum += error;
				num_comparisons++;
			}
		}
	}
	double mean_error = error_sum / num_comparisons;
	printf("%s: compared %zu complex numbers with an average error of %e\n", name, num_comparisons, mean_error);
}


int main(int argc, const char* argv[])
{
	test<float>("Single precision");
	test<double>("Double precision");

	return 0;
}
