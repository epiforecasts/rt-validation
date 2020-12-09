## code to prepare `synthetic-rt` dataset goes here


R <- c(rep(2, 20), rep(0.5, 10), rep(1, 10), 1 + 0.04 * 1:10, rep(1.4, 5),
       1.4 - 0.02 * 1:20, rep(1.4, 10), rep(0.8, 5), 0.8 + 0.02 * 1:10)
noisy_R <- R * rnorm(100, 1, 0.05)

usethis::use_data(synthetic-rts, overwrite = TRUE)
