\name{plot_biomarker_by_prs}
\alias{plot_biomarker_by_prs}
\alias{plot_forest}
\alias{plot_roc}
\title{Plotting utilities}
\usage{
plot_biomarker_by_prs(data)
plot_forest(tidy_tbl, drop_intercept = TRUE,
            title = "Effect estimates (95\% CI)",
            x_lab = "Estimate", vline = 0)
plot_roc(fit, data)
}
\arguments{
\item{data}{Cohort data.frame.}
\item{tidy_tbl}{Output of \code{tidy_effects}.}
\item{drop_intercept}{Logical; remove the intercept row.}
\item{title}{Plot title.}
\item{x_lab}{x-axis label.}
\item{vline}{Reference vertical line (0 for betas, 1 for ORs).}
\item{fit}{A binomial \code{glm}.}
}
\value{ggplot objects.}
\description{Visualization helpers for the report.}
