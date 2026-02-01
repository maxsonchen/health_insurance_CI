# Health Insurance Risk Analysis: Statistical Modeling of Claims Frequency and Severity

## 📊 Project Overview
Actuarial analysis of health insurance claims data examining the impact of chronic conditions, smoking status, and age on claim frequency and severity. This project applies statistical modeling techniques to support risk-based pricing and underwriting decisions for critical illness insurance policies.

## 🎯 Objectives
1. Model claim frequency using appropriate statistical distributions
2. Analyze factors driving claim rates and claim amounts
3. Assess interaction effects between risk factors (smoking × chronic conditions)
4. Provide data-driven recommendations for insurance pricing and underwriting
5. Evaluate data limitations and sample size requirements

## 📈 Key Findings

### Claim Frequency Analysis
- **Chronic conditions**: λ = 0.0785 (Poisson parameter)
- **Non-chronic conditions**: λ = 0.0566 (Poisson parameter)
- Mean-variance ratios: 0.95 (chronic), 0.96 (non-chronic) - indicating slight under-dispersion

### Smoking Impact
- **Claim frequency increase**: 56.4% higher for smokers (8.87% vs 5.67%)
- **Claim severity**: 3.4% higher for smokers ($83,623 vs $80,867)
- **Statistical significance**: p = 0.0033 for frequency (significant), p = 0.7636 for severity (not significant)

### Age Effects
- **Claim rates**: Statistically significant across age bands (p = 1.32×10⁻⁹)
- **Claim amounts**: Not significant across age groups (p = 0.55)
- Highest mean claims: Age 40-59 chronic group

### Interaction Analysis
- **Sub-additive interaction** between smoking and chronic conditions
- Marginal effect of chronic conditions smaller among smokers (1.53%) vs non-smokers (2.21%)
- Suggests independent risk factors rather than compounding effects

## 🛠️ Methodology

### Statistical Techniques
| Technique | Application | Key Result |
|-----------|-------------|------------|
| **Poisson Distribution** | Claim frequency modeling | λ = 0.0785 (chronic), λ = 0.0566 (non-chronic) |
| **Chi-Square Test** | Categorical associations | Age (p < 0.001), Chronic status (p = 0.013) significant |
| **ANOVA** | Multi-group comparisons | Age not significant for claim amounts (p = 0.55) |
| **t-Test** | Two-group comparisons | Chronic condition significant (p = 0.021) |
| **Confidence Intervals** | Parameter estimation | 95% CI for claim rates by chronic status |
| **Power Analysis** | Sample size determination | n = 117 required per group (80% power) |

### Data Analysis Approach
1. **Distribution Selection**: Evaluated Poisson vs Negative Binomial vs Binomial based on data characteristics
2. **Variance Testing**: Assessed mean-variance ratios to validate distributional assumptions
3. **Hypothesis Testing**: Multiple tests for factor significance (χ², ANOVA, t-tests)
4. **Interaction Analysis**: Examined compound effects of multiple risk factors
5. **Sample Size Calculation**: Power analysis for adequate statistical inference

## 📊 Dataset Characteristics
- **Total observations**: 5,000 insurance policyholders
- **Claims observed**: 302 (6.04% claim rate)
- **Age bands**: 20-39, 40-59, 60+
- **Risk factors**: Chronic conditions (binary), Smoking status (binary)
- **Policy type**: Critical illness insurance

## 🔍 Business Recommendations

### Underwriting Strategies
1. **Age-based pricing**: Implement tiered premiums based on age bands (claim rates vary significantly)
2. **Chronic condition differentiation**: Apply stronger risk classification for chronic conditions
3. **Smoking status assessment**: Include smoking as core underwriting factor (56.4% frequency increase)
4. **Independent factor pricing**: Treat smoking and chronic conditions as independent risk factors

### Data Enhancement Needs
- Increase granularity of age bands beyond 3 categories
- Capture chronic condition severity, duration, and type
- Include claim timing and complexity characteristics
- Expand sample size to 117+ claimants per chronic condition group

## ⚠️ Limitations Identified

### Statistical Limitations
- **Under-dispersion**: Slight deviation from Poisson equidispersion assumption
- **Low claim rate**: Only 6.04% claim incidence reduces statistical power
- **Sample size**: Only 78 chronic claimants (need 39 more for adequate power)

### Data Limitations
- **Selection bias**: Critical illness policyholders may be higher risk than general population
- **Binary indicators**: Smoking and chronic conditions lack severity/duration detail
- **Coarse age bands**: 3 categories limit detection of fine-grained age effects
- **Missing variables**: No claim timing, complexity, or medical history data

## 💻 Technical Skills Demonstrated
- **Statistical Modeling**: Distribution selection, parameter estimation, goodness-of-fit testing
- **Hypothesis Testing**: χ² tests, ANOVA, t-tests, significance interpretation
- **Actuarial Analysis**: Claim frequency/severity modeling, risk factor assessment
- **Sample Size Calculations**: Power analysis for experimental design
- **R Programming**: Data manipulation, statistical testing, visualization
- **Business Communication**: Translating statistical findings into actionable recommendations

## 📁 Project Structure
