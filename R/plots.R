#' Scatter of log(CEA) versus PRS coloured by CRC status
#'
#' @param data A cohort data.frame.
#' @return A ggplot object.
#' @export
plot_biomarker_by_prs <- function(data) {
  ggplot2::ggplot(
    data,
    ggplot2::aes(x = .data$prs_crc, y = log(.data$cea_ngml),
                 colour = factor(.data$crc_case, labels = c("Control", "CRC case")))
  ) +
    ggplot2::geom_point(alpha = 0.25, size = 0.7) +
    ggplot2::geom_smooth(method = "lm", se = TRUE, formula = y ~ x) +
    ggplot2::scale_colour_manual(values = c("Control" = "#4C78A8", "CRC case" = "#E45756")) +
    ggplot2::labs(
      x = "CRC polygenic risk score (SD units)",
      y = "log(CEA), ng/mL",
      colour = NULL,
      title = "PRS vs circulating CEA",
      subtitle = "Linear fit per CRC status"
    ) +
    ggplot2::theme_minimal(base_size = 12)
}

#' Forest plot of model coefficients
#'
#' @param tidy_tbl Output of [tidy_effects()].
#' @param drop_intercept Logical, drop the intercept row.
#' @param title Plot title.
#' @param x_lab x-axis label.
#' @param vline x-intercept reference line (0 for betas, 1 for ORs).
#' @return A ggplot object.
#' @export
plot_forest <- function(tidy_tbl,
                        drop_intercept = TRUE,
                        title = "Effect estimates (95% CI)",
                        x_lab = "Estimate",
                        vline = 0) {
  d <- tidy_tbl
  if (drop_intercept) d <- d[d$term != "(Intercept)", ]
  d$term <- factor(d$term, levels = rev(d$term))
  ggplot2::ggplot(d, ggplot2::aes(x = .data$estimate, y = .data$term)) +
    ggplot2::geom_vline(xintercept = vline, linetype = 2, colour = "grey50") +
    ggplot2::geom_errorbarh(
      ggplot2::aes(xmin = .data$conf.low, xmax = .data$conf.high),
      height = 0.2
    ) +
    ggplot2::geom_point(size = 2.4, colour = "#1f77b4") +
    ggplot2::labs(x = x_lab, y = NULL, title = title) +
    ggplot2::theme_minimal(base_size = 12)
}

#' Empirical ROC curve for a logistic-regression case/control model
#'
#' @param fit A `glm` (binomial) fit.
#' @param data The data used to fit `fit` (must contain `crc_case`).
#' @return A ggplot object.
#' @export
plot_roc <- function(fit, data) {
  d <- transform(
    data,
    age_c = data$age - mean(data$age),
    bmi_c = data$bmi - mean(data$bmi)
  )
  pr <- stats::predict(fit, newdata = d, type = "response")
  ord <- order(pr, decreasing = TRUE)
  y <- data$crc_case[ord]
  tpr <- cumsum(y) / sum(y)
  fpr <- cumsum(1 - y) / sum(1 - y)
  # AUC by trapezoidal rule
  auc <- sum(diff(c(0, fpr)) * (c(0, tpr)[-length(c(0, tpr))] + tpr) / 2)
  roc_df <- data.frame(fpr = c(0, fpr), tpr = c(0, tpr))
  ggplot2::ggplot(roc_df, ggplot2::aes(.data$fpr, .data$tpr)) +
    ggplot2::geom_abline(slope = 1, intercept = 0, linetype = 2, colour = "grey60") +
    ggplot2::geom_line(linewidth = 0.9, colour = "#E45756") +
    ggplot2::annotate("text", x = 0.6, y = 0.1,
                      label = sprintf("AUC = %.3f", auc), hjust = 0) +
    ggplot2::labs(
      x = "False positive rate", y = "True positive rate",
      title = "Discrimination of CRC case status",
      subtitle = "Logistic regression: PRS + clinical covariates"
    ) +
    ggplot2::coord_equal() +
    ggplot2::theme_minimal(base_size = 12)
}
