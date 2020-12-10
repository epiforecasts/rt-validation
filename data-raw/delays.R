library(data.table)
library(EpiNow2)

# define delay scenarios
delays <- data.table(
  length = c("short", "medium", "long"),
  mean = c(3, 6, 18),
  sd = list(c(1, 3, 9))
)
delays <- delays[, .(sd = unlist(sd)), by = c("length", "mean")]
# convert to logmean and logsd for log normal
delays <- delays[, `:=`(meanlog = convert_to_logmean(mean, sd),
                        sdlog = convert_to_logsd(mean, sd))]
delays <- delays[, lapply(.SD, round, 2), .SDcols = is.numeric, by = "length"]

# define uncertainty
delays <- delays[, `:=`(mean_sd_list = list(c(0.1, 1, 2)),
                        sd_sd_list = list(c(0.1, 1, 2)))]
delays <- delays[, .(as.data.table(.SD), mean_sd = unlist(mean_sd_list)), by = .N]
delays <- delays[, .(as.data.table(.SD), sd_sd = unlist(sd_sd_list)), by = .N]
delays <- delays[, c("mean_sd_list", "sd_sd_list") := NULL]

# add no delay scenario
delays <- rbindlist(list(data.table(length = "none"), delays),
                    use.names = TRUE, fill = TRUE)

# add max delay allowed (based on mean and 3 * sd)
delays <- delays [, max := mean + 3 * sd]

# set up id and add as data
delays <- delays[, id := 1:.N]
setcolorder(delays, c("id", "length"))
usethis::use_data(delays, overwrite = TRUE)
