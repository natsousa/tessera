\name{simulate_crc_cohort}
\alias{simulate_crc_cohort}
\title{Simulate a UK-Biobank-like clinical cohort for CRC biomarker analysis}
\usage{
simulate_crc_cohort(n = 5000, prs_beta_cea = 0.18, prs_beta_crc = 0.35, seed = 42)
}
\arguments{
\item{n}{Cohort size.}
\item{prs_beta_cea}{True effect of standardized PRS on log(CEA).}
\item{prs_beta_crc}{True log-odds of CRC per 1-SD PRS.}
\item{seed}{Random seed for reproducibility.}
}
\value{A tibble with one row per participant.}
\description{Generates a synthetic cohort for in-silico validation.}
