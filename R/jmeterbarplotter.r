#' read csv files exported from jmeter.
#' @param files file path and alias name of csv file.
#' @param file_encoding file encoding type. default value is "UTF-8". not required.
#' @param elapsed column name for "elapsed time". default value is "elapsed". not required.
#' @param kabek column name for "label". default value is "label". not required.
#' @return The dataframe generated from csv.
#' @examples
#' \dontrun{
#' files <- c(result1="examples/path1/result.csv", result2="examples/path2/result.csv")
#' logs <- rtl_read(files)
#' }
#' @export
jbp_read <- function(files = c(), file_encoding = "UTF-8",
    elapsed = "elapsed", label = "label") {
  aliases <- names(files)
  cols <- c("alias", "elapsed", "label", "success")
  rtn <- data.frame()
  for (i in 1:length(aliases)) {
    alias <- as.character(aliases[[i]])
    file <- files[[alias]]
    tmp <- utils::read.table(file, sep = ",", fileEncoding = file_encoding,
      head = T)
    tmp <- transform(tmp, alias = alias)
    tmp <- tmp[, cols]
    tmp$alias <- factor(tmp$alias)
    tmp$label <- tmp[[label]]
    tmp$elapsed <- tmp[[elapsed]]
    if (length(rtn) == 0) {
      rtn <- tmp
    } else {
      rtn <- merge(rtn, tmp, all = T)
    }
  }
  return(rtn)
}

#' aggregate dataframe of csv files.
#' @param data dataframe returned from jbp_read
#' @importFrom dplyr distinct
#' @return DescTools MeanCI.
jbp_aggr <- function(data = data.frame()) {
  aggr <- aggregate(list(elapsed = data[["elapsed"]]),
    FUN = function(x) c(sd = sd(x), ci = DescTools::MeanCI(x)),
    by = list(alias = data$alias, label = data$label))
  aggr <- aggr[order(aggr$label, aggr$alias), ]
  rownames(aggr) <- NULL
  return(aggr)
}

#' plot barplot for dataframe exported from jmeter.
#' @param data dataframe exported from jmeter
#' @param errorbar_type errorbar type, "sd" means Standard Deviation, "ci" means 95% Confidence Interval. not required.
#' @param pagesize number of labels in one graph. default value is "10". not required.
#' @param pic_prefix prefix for graph image file(png). default value is "result_". not required.
#' @param pic_width width of graph image file (cm). default value = 20. not required.
#' @param pic_height height of graph image file (cm). default value = 20. not required.
#' @param pic_dpi dpi of graph image file. default value = 300. not required.
#' @param title title of graph. default value is "Jmeter Result". not required.
#' @param xlab graph label of x-axis. default value is "elapsed time (ms)". not required.
#' @param ylab graph label of y-axis. default value is "labels". not required.
#' @importFrom dplyr distinct
#' @importFrom ggplot2 ggplot geom_errorbar aes position_dodge geom_bar labs xlab ylab ggsave theme element_text geom_text coord_flip
#' @examples
#' \dontrun{
#' files <- c(result1="examples/path1/result.csv", result2="examples/path2/result.csv")
#' logs <- rtl_read(files)
#' }
#' @export
jbp_plot <- function(data = data.frame(),
  horizonal = F,
  errorbar_type = "",
  pagesize = 10, pic_prefix = "result_", pic_width = 20,
  pic_height = 20, pic_dpi = 300,
  title = "Result", xlab = "labels", ylab = "elapsed time (ms)") {

  data <- data[order(data$label), ]
  labeles <- dplyr::distinct(data, data[["label"]])[[1]]
  aliases <- dplyr::distinct(data, data[["alias"]])[[1]]

  aggr <- BarplotterForJmeter::jbp_aggr(data)

  i <- 1
  while ( (i - 1) * pagesize * length(aliases) <=
    length(labeles) * length(aliases)) {
    ss <- subset(aggr, as.numeric(rownames(aggr)) >=
      (i - 1) * pagesize * length(aliases) + 1)
    rownames(ss) <- NULL
    ss <- subset(ss, as.numeric(rownames(ss)) <= pagesize * length(aliases))
    if (errorbar_type == "sd") {
      ymax <- ss[["elapsed"]][, "ci.mean"] + ss[["elapsed"]][, "sd"]
      ymin <- ss[["elapsed"]][, "ci.mean"] - ss[["elapsed"]][, "sd"]
      errorbar <- ggplot2::geom_errorbar(ggplot2::aes(
        ymax = ymax,
        ymin = ymin),
        color = "black",
        width = 0.2, position = ggplot2::position_dodge(width = 1))
        errorbar_type_text <- "errorbar: Standard Deviation"
    } else if (errorbar_type == "ci" ) {
      errorbar <- ggplot2::geom_errorbar(ggplot2::aes(
        ymax = ss[["elapsed"]][, "ci.upr.ci"],
        ymin = ss[["elapsed"]][, "ci.lwr.ci"]),
        color = "black",
        width = 0.2, position = ggplot2::position_dodge(width = 1))
      errorbar_type_text <- "Errorbar: 95% Confidence Interval"
    } else {
      errorbar <- NULL
      errorbar_type_text <- ""
    }

    alias <- ss[["alias"]]
    meanval <- ss[["elapsed"]][, "ci.mean"]

    if (horizonal) {
      text <- ggplot2::geom_text(
        ggplot2::aes(label = round(meanval)),
          position = position_dodge(width = 0.9),
          hjust = -0.3, size = 3)
    } else {
      text <- ggplot2::geom_text(
        ggplot2::aes(label = round(meanval)),
          position = position_dodge(width = 0.9),
          vjust = -0.3, size = 3)
    }

    plt <- ggplot2::ggplot(ss,
      ggplot2::aes(y = meanval, x = ss$label,
        color = alias, fill = alias)) +
      ggplot2::geom_bar(stat = "identity", position = "dodge") +
      text +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
        hjust = 1)) +
      errorbar +
      ggplot2::labs(title = title, subtitle = errorbar_type_text) +
      ggplot2::xlab(xlab) +
      ggplot2::ylab(ylab)
    if (horizonal) {
      plt <- plt + ggplot2::coord_flip()
    }
    ggplot2::ggsave(filename = paste(pic_prefix, as.character(i), ".png",
      sep = ""),
      plt, width = pic_width, height = pic_height, dpi = pic_dpi, units = "cm")
    i <- i + 1
  }
}
