# Model Comparison Summary Report

## Overview
This report compares the performance of two models on the NO2 dataset:
1. **Support Vector Regression (SVR)** - implemented in testandvalidation.py
2. **Conformalized Quantile Regression (CQR)** - implemented in cqr.py

## Dataset Information
- Total data points: 500
- Dimensions: 8
- Target variable (NO2 concentration) range: 1.22 to 6.40
- Window size used: 3
- Data split: 60% training, 20% validation, 20% test

## Results Summary

### SVR Model
- PICP (Prediction Interval Coverage Probability): 0.9500
- MPIW (Mean Prediction Interval Width): 4.5819
- Execution time: 16.15 seconds
- Parameters used:
  - Kernel: RBF
  - Gamma: 2^(-5) = 0.03125
  - C_lower: 0.03125 (ec1 = -5)
  - C_upper: 0.25 (ec3 = -2)
  - Lower quantile: 0.025
  - Upper quantile: 0.975
- Consistency: 10 runs all showed identical PICP (0.9500) and MPIW (4.5819)
- Sparsity: Near 0 for lower bound, 0.0033 for upper bound

### CQR Model
- Mean PICP: 0.9640 ± 0.0310
- Mean MPIW: 2.3832 ± 0.1828
- Mean Lower Bound Coverage: 0.0210
- Mean Upper Bound Coverage: 0.9850
- Mean Training Time: 3.03 seconds

The CQR model was run 10 times with different random splits, with individual run results:

| Run | PICP | MPIW | Training Time (s) |
|-----|------|------|-------------------|
| 1 | 0.9200 | 2.0859 | 3.63 |
| 2 | 0.9700 | 2.4074 | 2.75 |
| 3 | 0.9800 | 2.6137 | 2.76 |
| 4 | 0.9100 | 2.2081 | 2.85 |
| 5 | 1.0000 | 2.3507 | 3.29 |
| 6 | 0.9900 | 2.6063 | 2.93 |
| 7 | 0.9300 | 2.1828 | 3.01 |
| 8 | 0.9700 | 2.6336 | 2.94 |
| 9 | 0.9700 | 2.3108 | 2.98 |
| 10 | 1.0000 | 2.4330 | 3.17 |

## Conclusion

Both the SVR and CQR models provide effective prediction intervals, but with different characteristics:

1. **Coverage Accuracy**: The SVR model consistently achieves 95% coverage, while the CQR model achieves slightly higher coverage of ~96.4% on average, with some variability (±3.1%).

2. **Interval Width**: The CQR model provides narrower prediction intervals (MPIW: ~2.38 vs 4.58), making it more precise while maintaining slightly better coverage than SVR.

3. **Efficiency**: The CQR model is more than 5 times faster (3.03s vs 16.15s) than the SVR model.

4. **Reliability**: The SVR model shows perfect consistency across runs, while the CQR model exhibits some variability in both coverage (range: 91% to 100%) and interval width.

5. **Sparsity**: The SVR model solution has very low sparsity, indicating it's using most of the training points as support vectors.

## Recommendations

1. **For Precise Intervals**: Choose CQR when narrower prediction intervals are more important than exact 95% coverage.

2. **For 95% Coverage**: Use SVR when strict adherence to 95% coverage probability is required, but be aware that the intervals will be significantly wider.

3. **For Faster Computation**: CQR is significantly faster, making it more suitable for larger datasets or when computational resources are limited.

4. **For Consistent Results**: SVR provides more consistent results across multiple runs, which could be valuable in some applications.

5. **Further Analysis**: Consider examining why SVR produces much wider intervals and whether its parameters could be tuned to reduce interval width while maintaining coverage.

_Report generated on: Run date: 20250429_144947_ 