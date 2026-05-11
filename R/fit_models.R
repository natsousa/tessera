#' Fit linear regression of log(CEA) on PRS and clinical covariates
#'
#' Primary analysis model for the continuous biomarker endpoint. The outcome
#' is `log(cea_ngml)` and the exposure of interest is the standardized
#' colorectal-cancer polygenic risk score `prs_crc`. Covariates: age (centred),
#' sex, BMI (centred), smoking status.
#'
#' @param data A data.frame produced by [simulate_crc_cohort()].
#' @return An object of class `lm`.
#' @export
fit_biomarker_lm <- function(data) {
  d <- transform(
    data,
    log_cea  = log(data$cea_ngml),
    age_c    = data$age - mean(data$age),
    bmi_c    = data$bmi - mean(data$bmi)
  )
  stats::lm(log_cea ~ prs_crc + age_c + sex + bmi_c + smoking, data = d)
}

#' Fit logistic regression of CRC case status on PRS and covariates
#'
#' @param data A data.frame produced by [simulate_crc_cohort()].
#' @return An object of class `glm`.
#' @export
fit_case_control_glm <- function(data) {
  d <- transform(
    data,
    age_c = data$age - mean(data$age),
    bmi_c = data$bmi - mean(data$bmi)
  )
  stats::glm(
    crc_case ~ prs_crc + age_c + sex + bmi_c + smoking,
    data = d, family = stats::binomial()
  )
}

#' Likelihood-ratio test of PRS x sex interaction on log(CEA)
#'
#' @param data Cohort data.
#' @return A data.frame with the LRT result.
#' @export
test_prs_sex_interaction <- function(data) {
  d <- transform(
    data,
    log_cea = log(data$cea_ngml),
    age_c   = data$age - mean(data$age),
    bmi_c   = data$bmi - mean(data$bmi)
  )
  m0 <- stats::lm(log_cea ~ prs_crc + age_c + sex + bmi_c + smoking, data = d)
  m1 <- stats::lm(log_cea ~ prs_crc * sex + age_c + bmi_c + smoking, data = d)
  a  <- stats::anova(m0, m1)
  data.frame(
    test    = "PRS x sex interaction (log CEA)",
    df      = a$Df[2],
    F_stat  = a$F[2],
    p_value = a$`Pr(>F)`[2]
  )
}

#' Tidy a fitted model into a coefficient table with 95% CIs
#'
#' @param fit An `lm` or `glm` object.
#' @param exponentiate Logical. If TRUE, exponentiate estimates (use for `glm` logit).
#' @return A tibble.
#' @export
tidy_effects <- function(fit, exponentiate = FALSE) {
  broom::tidy(fit, conf.int = TRUE, exponentiate = exponentiate)
}
