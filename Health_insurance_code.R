# Data loading
df <- read.csv("critical_illness.csv")

# ======== QUESTION 1 ========
# ========   PART A   ========
# Split into the chronic and non-chronic conditions
data_yes = df[df$ChronicCondition == "Yes", ]
data_no = df[df$ChronicCondition == "No", ]

# Find mean and variance for chronic and non-chronic
mean_yes = mean(data_yes$ClaimCount)
mean_no = mean(data_no$ClaimCount)

var_yes = var(data_yes$ClaimCount)
var_no = var(data_no$ClaimCount)

# Ratio close to 1 for poisson to hold
ratio_yes = var_yes / mean_yes
ratio_no = var_no / mean_no

cat("Yes Ratio: ", ratio_yes)
cat("No Ratio: ", ratio_no)

# Confidence Levels
confidence_level <- 0.95
alpha <- 1 - confidence_level
z_critical <- qnorm(1 - alpha / 2)

n_yes = nrow(data_yes)
n_no = nrow(data_no)

lambda_yes = mean_yes
lambda_no = mean_no

se_yes = sqrt(lambda_yes / n_yes)
se_no = sqrt(lambda_no / n_no)

margin_yes <- z_critical * se_yes
margin_no <- z_critical * se_no

ci_yes_lower <- lambda_yes - margin_yes
ci_yes_upper <- lambda_yes + margin_yes

ci_no_lower <- lambda_no - margin_no
ci_no_upper <- lambda_no + margin_no

confidence_level_table <- data.frame(
  Chronic_Condition = c("Yes", "No"),
  Lower_Bound = c(ci_yes_lower, ci_no_lower),
  Upper_Bound = c(ci_yes_upper, ci_no_upper)
)

print(confidence_level_table)

# ======== QUESTION 2 ========
# Separate into test groups
sixty_chronic <- df[df$AgeGroup == '60+' & df$ChronicCondition == "Yes", ]
sixty_non_chronic <- df[df$AgeGroup == '60+' & df$ChronicCondition == "No", ]
fifty_chronic <- df[df$AgeGroup == '40-59' & df$ChronicCondition == "Yes", ]
fifty_non_chronic <- df[df$AgeGroup == '40-59' & df$ChronicCondition == "No", ]
twenty_chronic <- df[df$AgeGroup == '20-39' & df$ChronicCondition == "Yes", ]
twenty_non_chronic <- df[df$AgeGroup == '20-39' & df$ChronicCondition == "No", ]

calculate_metrics <- function(data) {
  total_policies <- nrow(data)
  policies_with_claims <- sum(data$AnyClaim)
  claim_rate <- (policies_with_claims / total_policies) * 100
  claim_amt <- data[data$AnyClaim == 1, ]
  
  if (nrow(claim_amt) > 0) {
    avg_amt <- mean(claim_amt$ClaimTotal)
    median_amt <- median(claim_amt$ClaimTotal)
  } else {
    avg_amt <- NA
    median_amt <- NA
  }
  
  return(c(
    N = total_policies,
    N_claims = policies_with_claims,
    Claim_rate = claim_rate,
    Mean_amount = avg_amt,
    Median_amt = median_amt
  ))
}

# Create summary table
summary_table <- data.frame(
  Group = c(
    "20–39 No Chronic", "20–39 Chronic",
    "40–59 No Chronic", "40–59 Chronic",
    "60+ No Chronic", "60+ Chronic"
  ),
  rbind(
    calculate_metrics(twenty_non_chronic),
    calculate_metrics(twenty_chronic),
    calculate_metrics(fifty_non_chronic),
    calculate_metrics(fifty_chronic),
    calculate_metrics(sixty_non_chronic),
    calculate_metrics(sixty_chronic)
  )
)

# Display table
print(summary_table)

# ======== STATISTICAL SIGNIFICANCE ========
# Claim rates
test_claim_rates <- function(group1, group2, group1_name, group2_name) {
  # Chi-squares tests
  test_result <- prop.test(
    c(sum(group1$AnyClaim), sum(group2$AnyClaim)),
    c(nrow(group1), nrow(group2))
  )
  
  rate1 <- sum(group1$AnyClaim) / nrow(group1) * 100
  rate2 <- sum(group2$AnyClaim) / nrow(group2) * 100
  
  return(list(
    group1_name = group1_name,
    group2_name = group2_name,
    rate1 = round(rate1, 2),
    rate2 = round(rate2, 2),
    chi_square = round(test_result$statistic, 2),
    p_value = test_result$p.value,
    significant = test_result$p.value < 0.05,
    
  ))
}

# Claim Amounts
test_claim_amounts <- function(group1, group2, group1_name, group2_name) {
  claims1 <- group1[group1$AnyClaim == 1, ]
  claims2 <- group2[group2$AnyCliam == 1, ]
  
  test_results <- t.test(claims1$ClaimTotal, claims2$ClaimTotal)
  
  # Perform t-test
  mean1 <- mean(claims1$ClaimTotal)
  mean2 <- mean(claims2$ClaimTotal)
  
  return(list(
    group1_name = group1_name,
    group2_name = group2_name,
    mean1 = round(mean1, 2),
    mean2 = round(mean2, 2),
    difference = round(mean1- mean2, 2),
    t_statistic = round(test_results$statistic, 2),
    df = round(test_results$parameter, 1),
    p_value = test_results$p.value
  ))
}

# SIGNIFICANCE FUNCTION
print_significance <- function(chi_data) {
  if(chi_data$p.value < 0.05) {
    cat("Significant: ", chi_data$p.value)
  } else {
    cat("Not Significant: ", chi_data$p.value)
  }
}

#### CLAIM RATE TESTS ####
# Age Claim Rates
chi_age_rate <- chisq.test(table(df$AgeGroup, df$AnyClaim))
if (chi_age_rate$p.value < 0.05) {
  cat("Age is significant for claim rates, p: ", chi_age_rate$p.value)
} else {
  cat("Age is not significant for claim rates, p: ", chi_age_rate$p.value)
}
#print_significance(chi_age_rate)

# Chronic Condition Claim Rates
chi_chronic_rate <- chisq.test(table(df$ChronicCondition, df$AnyClaim))
if (chi_chronic_rate$p.value < 0.05) {
  cat("Chronic condition is significant for claim rates, p: ", chi_chronic_rate$p.value)
} else {
  cat("Chronic_condition is not significant for claim rates, p: ", chi_chronic_rate$p.value)
}
#print_significance(chi_chronic_rate)

#### CLAIM AMOUNTS ####
# Age Claim Amounts - Anova test for 3 groups (20-39, 40-59, 60+)
claims_only <- df[df$AnyClaim == 1, ]

anova_age <- aov(ClaimTotal ~ AgeGroup, data = claims_only)
anova_summary <- summary(anova_age)
anova_p_value <- anova_summary[[1]]$`Pr(>F)`[1]
print(anova_p_value)

if(anova_p_value < 0.05) {
  cat("Age is statistically significant for claim amounts using Anova: ", anova_p_value)
} else {
  cat("Age is NOT significant: ", anova_p_value)
}

# Chronic Claim Amounts - T-test for 2 groups
t_chronic <- t.test(ClaimTotal ~ ChronicCondition, data = claims_only)
t_chronic_value <- t_chronic$p.value
if(t_chronic_value < 0.05) {
  cat("Chronic condition is statistically significant for claim amounts: ", t_chronic_value)
} else {
  cat("t_chronic_value: ", t_chronic_value)
}

# ======== QUESTION 3 ========
###### CLAIM FREQUENCY #####
smoker <- df[df$Smoker == 'Yes', ]
non_smoker <- df[df$Smoker == 'No', ]

smoker_rate <- sum(smoker$AnyClaim) / nrow(smoker) * 100
non_smoker_rate <- sum(non_smoker$AnyClaim) / nrow(non_smoker) * 100

cat("Smokers:", round(smoker_rate, 2))
cat("Non-smokers:", round(non_smoker_rate, 2))
cat("Relative Increase:", round((smoker_rate / non_smoker_rate - 1) * 100, 1))

##### CLAIM SEVERITY ######
smoker_claims <- smoker[smoker$AnyClaim == 1, ]
non_smoker_claims <- non_smoker[non_smoker$AnyClaim == 1, ]

smoker_avg <- mean(smoker_claims$ClaimTotal)
non_smoker_avg <- mean(non_smoker_claims$ClaimTotal)

cat("Smokers:", smoker_avg)
cat("Non-Smokers:", non_smoker_avg)
cat("Relative Increase:", round((smoker_avg / non_smoker_avg - 1) * 100, 1))

#### SMOKING VS CHRONIC CONDITION ####
smoker_chronic <- df[df$Smoker == "Yes" & df$ChronicCondition == "Yes", ]
smoker_no_chronic <- df[df$Smoker == "Yes" & df$ChronicCondition == "No", ]
non_smoker_chronic <- df[df$Smoker == "No" & df$ChronicCondition == "Yes", ]
non_smoker_no_chronic <- df[df$Smoker == "No" & df$ChronicCondition == "No", ]

# Calculate claim rates for all 4 groups
rate_ns_nc <- sum(non_smoker_no_chronic$AnyClaim) / nrow(non_smoker_no_chronic) * 100
rate_ns_c <- sum(non_smoker_chronic$AnyClaim) / nrow(non_smoker_chronic) * 100
rate_s_nc <- sum(smoker_no_chronic$AnyClaim) / nrow(smoker_no_chronic) * 100
rate_s_c <- sum(smoker_chronic$AnyClaim) / nrow(smoker_chronic) * 100

cat("  Non-Smoker + No Chronic:", round(rate_ns_nc, 2), "% (BASELINE)\n")
cat("  Non-Smoker + Yes Chronic:", round(rate_ns_c, 2), "% (+", 
    round(rate_ns_c - rate_ns_nc, 2), "pp)\n", sep="")
cat("  Smoker + No Chronic:", round(rate_s_nc, 2), "% (+", 
    round(rate_s_nc - rate_ns_nc, 2), "pp)\n", sep="")
cat("  Smoker + Yes Chronic:", round(rate_s_c, 2), "% (+", 
    round(rate_s_c - rate_ns_nc, 2), "pp)\n\n", sep="")

#### STATISTICAL TESTS #####
# chi-square - Claim Frequency
claim_freq_p <- chisq.test(table(df$Smoker, df$AnyClaim))

if(claim_freq_p$p.value < 0.05) {
  cat("Smoking is significant for claim frequency: ", claim_freq_p$p.value)
} else {
  print("Not significant: ", claim_freq_p$p.value)
}

# t-test - Claim Severity
claims_only_smoke <- df[df$AnyClaim == 1, ]
t_claim_severity <- t.test(ClaimTotal ~ Smoker, data = claims_only_smoke)
t_claim_severity_value <- t_claim_severity$p.value

if(t_claim_severity_value < 0.05) {
  cat("Smoking is significant for claim severity: ", t_claim_severity_value)
} else {
  cat("Not significant: ", t_claim_severity_value)
}

# ======== QUESTION 5 ========
claims_only <- df[df$AnyClaim == 1, ]
chronic_claim <- claims_only[claims_only$ChronicCondition == 'Yes', ]
nc_claim <- claims_only[claims_only$ChronicCondition == 'No', ]

n_chronic <- nrow(chronic_claim)
n_nc <- nrow(nc_claim)

mean_chronic <- mean(chronic_claim$ClaimTotal)
mean_nc <- mean(nc_claim$ClaimTotal)

sd_chronic <- sd(chronic_claim$ClaimTotal)
sd_nc <- sd(nc_claim$ClaimTotal)

pooled_var <- ((n_chronic - 1) * sd_chronic^2 + (n_nc - 1) * sd_nc^2) / (n_chronic + n_nc - 2)

confidence_level <- 0.95
alpha <- 1 - confidence_level
beta <- 0.2 # Assuming 80% power

z_1a <- qnorm(1 - alpha)
z_1b <- qnorm(1 - beta)

num_needed <- (2 * ((z_1a + z_1b)^2 * pooled_var)) / (mean_chronic - mean_nc)^2
cat("Necessary Number: ", num_needed)



