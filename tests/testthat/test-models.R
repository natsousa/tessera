test_that("simulate_crc_cohort returns expected shape and types", {
  d <- simulate_crc_cohort(n = 200, seed = 1)
  expect_s3_class(d, "tbl_df")
  expect_equal(nrow(d), 200)
  expect_setequal(
    names(d),
    c("eid", "age", "sex", "bmi", "smoking", "prs_crc", "cea_ngml", "crc_case")
  )
  expect_true(all(d$cea_ngml > 0))
  expect_true(all(d$crc_case %in% 0:1))
})

test_that("primary linear model recovers PRS effect direction", {
  d <- simulate_crc_cohort(n = 5000, seed = 7)
  fit <- fit_biomarker_lm(d)
  est <- coef(fit)["prs_crc"]
  expect_true(est > 0.05)
})

test_that("logistic model recovers PRS effect direction", {
  d <- simulate_crc_cohort(n = 5000, seed = 8)
  fit <- fit_case_control_glm(d)
  est <- coef(fit)["prs_crc"]
  expect_true(est > 0.1)
})
