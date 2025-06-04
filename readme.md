# Feature Selection Experiment Results

This document summarizes the results of various feature selection experiments using Conformal Quantile Regression (CQR).

## Dataset: `train.csv` (Mobile Price Prediction)

**Target Variable**: `price_range` (column index -1)

### Experiment 1.1: Initial Single Objective (Strict Coverage First Logic)
- **Description**: GA prioritizes PICP >= 0.90, then minimizes MPIW. This was before formal `loss_type` argument.
- **Loss Logic**: `if picp < 0.90: fitness = -1e6 else: fitness = -mpiw`
- **Parameters**:
    - `picp_threshold`: 0.90
    - `num_gen`: 10 (argparse default at the time)
    - `pop_size`: 20 (argparse default at the time)
    - `cx_pb`: 0.6 (argparse default at the time)
    - `mut_pb`: 0.3 (argparse default at the time)
    - `cqr_alpha`: 0.1 (argparse default at the time)
- **Results Before FS**:
    - PICP: 0.993
    - MPIW: 2.440
- **Results After FS**:
    - PICP: 1.000
    - MPIW: 3.000
    - Number of Selected Features: 12 (out of 20)
    - Selected Features (by index): `[1, 2, 3, 5, 6, 10, 12, 13, 14, 16, 17, 19]`
    - Best CQR Loss (GA internal objective value for MPIW): 2.4150

### Experiment 1.2: Single Objective - `coverage_penalty`
- **Loss Function**: `coverage_penalty` (`loss = mpiw + lambda_param * max(0, picp_threshold - picp)`)
- **Parameters**:
    - `picp_threshold`: 0.90
    - `lambda_param`: 1.0
    - `num_gen`: 10
    - `pop_size`: 20
    - `cqr_alpha`: 0.1
- **Results After FS**:
    - PICP: 1.000
    - MPIW: 3.000
    - Number of Selected Features: 6
    - Selected Features: `['feature_1', 'feature_3', 'feature_9', 'feature_12', 'feature_13', 'feature_18']`
    - Best CQR Loss (GA internal): 2.4150

### Experiment 1.3: Single Objective - `strict_coverage_first`
- **Loss Function**: `strict_coverage_first` (`if picp < threshold: fitness = -very_large_penalty else: fitness = -mpiw`)
- **Parameters**:
    - `picp_threshold`: 0.90
    - `num_gen`: 10
    - `pop_size`: 20
    - `cqr_alpha`: 0.1
- **Results After FS**:
    - PICP: 1.000
    - MPIW: 3.000
    - Number of Selected Features: 9
    - Selected Features: `['feature_1', 'feature_3', 'feature_7', 'feature_9', 'feature_12', 'feature_13', 'feature_14', 'feature_17', 'feature_19']`
    - Best CQR Loss (GA internal, target MPIW): 2.4150

### Experiment 1.4: Single Objective - `strict_coverage_first` (Increased GA Resources)
- **Loss Function**: `strict_coverage_first`
- **Parameters**:
    - `picp_threshold`: 0.90
    - `num_gen`: 20
    - `pop_size`: 40
    - `cqr_alpha`: 0.1
- **Results After FS**:
    - PICP: 1.000
    - MPIW: 3.000
    - Number of Selected Features: 7
    - Selected Features: `['feature_2', 'feature_3', 'feature_10', 'feature_12', 'feature_13', 'feature_14', 'feature_19']`
    - Best CQR Loss (GA internal, target MPIW): 2.4150

### Experiment 1.5: Single Objective - `strict_coverage_first` (Adjusted CQR Alpha)
- **Loss Function**: `strict_coverage_first`
- **Parameters**:
    - `picp_threshold`: 0.90
    - `num_gen`: 20
    - `pop_size`: 40
    - `cqr_alpha`: 0.15 (changed from 0.1)
- **Results After FS**:
    - PICP: 1.000
    - MPIW: 3.000
    - Number of Selected Features: 11
    - Selected Features: (List not explicitly provided, noted as "A different, larger set")
    - Best CQR Loss (GA internal, target MPIW): 2.4150

### Experiment 1.6: Single Objective - `quadratic_coverage_penalty`
- **Loss Function**: `quadratic_coverage_penalty` (`loss = mpiw + lambda_param * (max(0, picp_threshold - picp))**2`)
- **Note**: This run was attempted for `train.csv`, but results were not clearly captured due to issues with script edits at the time.

## Dataset: `STAR.csv` (Student Teacher Achievement Ratio)

**Target Variable**: `read3` (3rd Grade Reading Score)

### Experiment 2.1: Single Objective (Quadratic Penalty - Hardcoded Script Version)
- **Description**: Used an older version of the script with a hardcoded quadratic penalty.
- **Loss Logic**: `loss = mpiw + lambda_param * (max(0, picp_threshold - picp))**2`
- **Parameters (Defaults from that script version)**:
    - `picp_threshold`: 0.90
    - `lambda_param`: 1.0
    - `num_gen`: 10
    - `pop_size`: 20
    - `cqr_alpha`: 0.1
- **Results Before FS**:
    - PICP: 0.900
    - MPIW: 88.456
- **Results After FS**:
    - PICP: 0.901
    - MPIW: 124.139
    - Number of Selected Features: 63 (out of 129)
    - Selected Features: (List not explicitly provided)
    - Best CQR Loss (GA internal): 85.9560

## Dataset: `student-mat.csv` (Student Performance)

**Target Variable**: `G3` (Final Grade)

### Experiment 3.1: Multi-Objective NSGA-II
- **Description**: GA (NSGA-II) simultaneously maximizes PICP and minimizes MPIW.
- **Optimization Objectives**: (Maximize PICP, Minimize MPIW)
- **Parameters (Defaults from `argparse` in the NSGA-II script version)**:
    - `num_gen`: 50
    - `pop_size`: 100
    - `cx_pb`: 0.7
    - `mut_pb`: 0.2
    - `cqr_alpha`: 0.1
    - `test_size` (for calibration): 0.25
- **Results Before FS (Full Feature Set)**:
    - PICP: 0.9091
    - MPIW: 15.9134
- **Pareto Front Solutions (5 solutions found)**:
    | Solution # | PICP   | MPIW    | Num Features | Selected Features (Sample or Indices)          |
    |------------|--------|---------|--------------|------------------------------------------------|
    | 1          | 0.9192 | 15.8677 | 21           | `['school_MS', 'sex_M', 'address_U', ...]`   |
    | 2          | 0.9293 | 16.0589 | 13           | `['school_MS', 'sex_M', 'Mjob_health', ...]` |
    | 3          | 0.9091 | 15.7830 | 27           | `['school_MS', 'sex_M', 'address_U', ...]`   |
    | 4          | 0.8990 | 15.6959 | 32           | Indices: `[1, 2, 3, 4, 5, 7, 8, 9, 10, 11]...` |
    | 5          | 0.8788 | 15.2122 | 42           | Indices: `[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]...`  |

*Note: Feature lists for Pareto front solutions are truncated for brevity in this summary.* 

### CQR Before Feature Selection (Full Feature Set)

Before applying feature selection, CQR was performed using all 56 features:

*   **PICP (full features):** 0.9091
*   **MPIW (full features):** 15.9134

### NSGA-II Multi-Objective Feature Selection

The NSGA-II algorithm ran for 50 generations to find a Pareto front of solutions that balance maximizing PICP and minimizing MPIW.

```
gen     nevals
0       100   
1       92    
2       92    
3       97    
4       89    
5       86    
6       92    
7       92    
8       88    
9       89    
10      88    
11      92    
12      91    
13      92    
14      93    
15      91    
16      89    
17      89    
18      88    
19      92    
20      91    
21      88    
22      91    
23      85    
24      85    
25      90    
26      99    
27      87    
28      87    
29      93    
30      92    
31      90    
32      86    
33      93    
34      95    
35      92    
36      92    
37      92    
38      90    
39      92    
40      92    
41      91    
42      93    
43      90    
44      92    
45      93    
46      92    
47      92    
48      90    
49      88    
50      86    
```

### Pareto Front Results

The algorithm identified 5 non-dominated solutions on the Pareto front:

| Solution | PICP   | MPIW    | Num Features |
|----------|--------|---------|--------------|
| 1        | 0.9596 | 15.8009 | 32           |
| 2        | 0.9495 | 15.4898 | 20           |
| 3        | 0.9394 | 15.1990 | 25           |
| 4        | 0.9293 | 15.0090 | 26           |
| 5        | 0.9091 | 14.9342 | 25           |

**Details for top solutions (features shown are examples from the one-hot encoded set):**

*   **Solution 1 (32 features):** PICP: 0.9596, MPIW: 15.8009
    *   Example Features: ['sex_M', 'address_R', 'famsize_GT3', 'Pstatus_A', 'Mjob_at_home', 'Mjob_health', ...]
*   **Solution 2 (20 features):** PICP: 0.9495, MPIW: 15.4898
    *   Example Features: ['sex_F', 'address_U', 'famsize_GT3', 'Mjob_health', 'Mjob_other', 'Mjob_services', ...]
*   **Solution 3 (25 features):** PICP: 0.9394, MPIW: 15.1990
    *   Example Features: ['sex_F', 'address_U', 'famsize_GT3', 'famsize_LE3', 'Pstatus_T', 'Mjob_health', ...]

**Note:** PICP/MPIW reported for Pareto front solutions are re-evaluated on the calibration set. The GA optimizes by maximizing PICP and minimizing MPIW. 
