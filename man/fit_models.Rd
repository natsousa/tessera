\name{fit_biomarker_lm}
\alias{fit_biomarker_lm}
\alias{fit_case_control_glm}
\alias{test_prs_sex_interaction}
\alias{tidy_effects}
\title{Model-fitting utilities}
\usage{
fit_biomarker_lm(data)
fit_case_control_glm(data)
test_prs_sex_interaction(data)
tidy_effects(fit, exponentiate = FALSE)
}
\arguments{
\item{data}{A cohort data.frame produced by \code{simulate_crc_cohort}.}
\item{fit}{An \code{lm} or \code{glm} object.}
\item{exponentiate}{Logical; exponentiate estimates (use for logistic ORs).}
}
\value{Fitted model objects or, for \code{tidy_effects}, a tibble of estimates.}
\description{Fit primary biomarker (linear), secondary case/control (logistic),
  and a likelihood-ratio test for PRS x sex interaction.}
