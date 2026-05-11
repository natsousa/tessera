#' Simulate a UK-Biobank-like clinical cohort for CRC biomarker analysis
#'
#' Generates a synthetic clinical cohort suitable for in-silico validation of
#' a colorectal-cancer polygenic risk score (CRC-PRS) against the circulating
#' biomarker carcinoembryonic antigen (CEA). The data-generating process is
#' deliberately simple and statistically transparent: PRS is standard normal,
#' covariates follow population-plausible distributions, and CEA / CRC status
#' are simulated from a generalised linear model with known coefficients so
#' that downstream estimators can be benchmarked.
#'
#' @param n Integer. Cohort size. Default 5000.
#' @param prs_beta_cea Numeric. True effect of standardized PRS on log(CEA).
#' @param prs_beta_crc Numeric. True log-odds of CRC per 1-SD PRS.
#' @param seed Integer or NULL. Random seed for reproducibility.
#'
#' @return A tibble with one row per participant.
#' @export
simulate_crc_cohort <- function(n = 5000,
                                prs_beta_cea = 0.18,
                                prs_beta_crc = 0.35,
                                seed = 42) {
  if (!is.null(seed)) set.seed(seed)

  age   <- round(stats::rnorm(n, mean = 58, sd = 8))
  age   <- pmin(pmax(age, 40), 75)
  sex   <- factor(stats::rbinom(n, 1, 0.52), levels = 0:1, labels = c("Female", "Male"))
  bmi   <- stats::rnorm(n, mean = 27, sd = 4.5)
  smoke <- factor(
    sample(c("Never", "Former", "Current"), n, TRUE, prob = c(0.55, 0.32, 0.13)),
    levels = c("Never", "Former", "Current")
  )

  prs <- stats::rnorm(n) # standardized polygenic risk score

  # log(CEA) generative model (ng/mL on log scale)
  log_cea <- 0.6 +
    prs_beta_cea * prs +
    0.012 * (age - 58) +
    0.05  * (as.integer(sex) - 1) +
    0.018 * (bmi - 27) +
    0.10  * (smoke == "Former") +
    0.28  * (smoke == "Current") +
    stats::rnorm(n, sd = 0.55)
  cea <- exp(log_cea)

  # CRC case/control generative model
  lp <- -4.2 +
    prs_beta_crc * prs +
    0.045 * (age - 58) +
    0.20  * (as.integer(sex) - 1) +
    0.025 * (bmi - 27) +
    0.30  * (smoke == "Former") +
    0.65  * (smoke == "Current")
  crc <- stats::rbinom(n, 1, stats::plogis(lp))

  tibble::tibble(
    eid       = sprintf("P%06d", seq_len(n)),
    age       = age,
    sex       = sex,
    bmi       = round(bmi, 2),
    smoking   = smoke,
    prs_crc   = round(prs, 4),
    cea_ngml  = round(cea, 3),
    crc_case  = as.integer(crc)
  )
}
