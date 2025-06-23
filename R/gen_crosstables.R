#' @title Generate Crosstables, Barplots, and Chi-squared Tests
#'
#' @description
#' This function automates the process of creating cross-tabulation tables,
#' generating bar plots, and performing chi-squared tests for a target variable
#' against multiple explanatory variables.
#'
#' @param data A data frame containing the variables.
#' @param target_var The target variable (e.g., life satisfaction), specified as a column from the data frame (e.g., `data$life_satis`).
#' @param ...other_variables Multiple explanatory variables, each specified as a column from the data frame (e.g., `data$gender`, `data$age_c`).
#' @param color_palette A character vector of colors or a function created by `colorRampPalette` for the barplot.
#'                      If a vector, colors will be recycled if fewer than needed.
#'                      If a function (e.g., `colorRampPalette(c("lightblue", "darkblue"))`),
#'                      it will be called with the number of columns in the crosstable.
#'                      Defaults to `colorRampPalette(c("lightblue", "darkblue"))`.
#' @param main_text Character string to be appended to the main title. The full title will be "[Explanatory Var]別[Target Var][main_text]". Defaults to "".
#' @param xlab_text Character string for the x-axis label. Defaults to "割合".
#' @param ylab_text Character string to be appended to the y-axis label. The full label will be "[Explanatory Var][ylab_text]". Defaults to "".
#' @param var_labels A named list of character strings for variable display names (e.g., `list(life_satis = "生活満足度", gender = "性別")`).
#'                   If a variable's original name is found in this list, its corresponding label will be used for display.
#'
#' @return No value is returned. Results (cross-tables, plots, and chi-squared test results)
#'         are printed to the console and plots are generated as side effects.
#' @examples
#' \dontrun{
#' # Assuming 'df' is your data frame with 'life_satis' and other columns
#' # For R Markdown:
#' # Place par(family = "YourFontName") and knitr::opts_chunk$set(...) in your setup chunk.
#' # par(family = "HiraKakuProN-W3") # Example for macOS
#' # knitr::opts_chunk$set(echo = FALSE, warning = FALSE, message = FALSE, fig.align = "center")
#'
#' # Example data (replace with your actual data loading)
#' df_example <- data.frame(
#'   life_satis = sample(c("非常に不満", "不満", "普通", "満足", "非常に満足"), 100, replace = TRUE),
#'   gender = sample(c("男性", "女性"), 100, replace = TRUE),
#'   age_c = sample(c("20代", "30代", "40代"), 100, replace = TRUE)
#' )
#' df_example$life_satis <- factor(df_example$life_satis,
#'                                 levels = c("非常に不満", "不満", "普通", "満足", "非常に満足"))
#'
#' # Define variable labels
#' my_var_labels <- list(
#'   life_satis = "生活満足度",
#'   gender = "性別",
#'   age_c = "年齢"
#' )
#'
#' # Default usage (title will be "性別別生活満足度" or "年齢別生活満足度")
#' gen_crosstables(df_example, df_example$life_satis, df_example$gender, var_labels = my_var_labels)
#' gen_crosstables(df_example, df_example$life_satis, df_example$age_c, var_labels = my_var_labels)
#'
#' # Custom title text if needed
#' gen_crosstables(df_example, df_example$life_satis, df_example$gender,
#'                 var_labels = my_var_labels,
#'                 main_text = "に関する意識調査", # Title will be "性別別生活満足度に関する意識調査"
#'                 xlab_text = "回答者の割合 (%)",
#'                 ylab_text = "区分")
#' }
#' @importFrom stats chisq.test
#' @importFrom graphics barplot
#' @importFrom grDevices colorRampPalette
#' @importFrom knitr kable
#' @export
gen_crosstables <- function(data, target_var, ...,
                            color_palette = colorRampPalette(c("lightblue", "darkblue")),
                            main_text = "", # デフォルト値を "" に変更
                            xlab_text = "割合",
                            ylab_text = "",
                            var_labels = NULL) {

  cl <- match.call(expand.dots = FALSE)
  other_variable_expressions <- cl[["..."]]

  if (!is.data.frame(data)) {
    stop("The 'data' argument must be a data frame.")
  }

  # --- Helper function to extract variable name and apply label mapping ---
  get_var_name <- function(var_expression, labels_list = NULL) {
    original_name <- NULL
    if (is.call(var_expression) && var_expression[[1]] == quote(`$`)) {
      original_name <- as.character(var_expression[[3]])
    } else if (is.name(var_expression)) {
      original_name <- as.character(var_expression)
    } else {
      original_name <- deparse(var_expression)
    }

    if (!is.null(labels_list) && original_name %in% names(labels_list)) {
      return(labels_list[[original_name]])
    } else {
      return(original_name)
    }
  }

  target_var_actual <- target_var
  target_var_label <- get_var_name(cl$target_var, labels_list = var_labels)

  other_vars_actual_list <- list(...)

  if (length(other_variable_expressions) == 0) {
    stop("No other variables provided for analysis. Please specify at least one.")
  }

  for (i in seq_along(other_variable_expressions)) {
    current_var_actual <- other_vars_actual_list[[i]]
    current_var_label <- get_var_name(other_variable_expressions[[i]], labels_list = var_labels)

    cat("\n### ", toupper(current_var_label), " ###\n", sep="")

    ct_table <- round(prop.table(table(current_var_actual, target_var_actual, useNA = "no"), margin = 1) * 100, 1)

    if (nrow(ct_table) == 0 || ncol(ct_table) == 0) {
      warning(paste0("Skipping analysis for '", current_var_label, "' due to no non-NA data for crosstabulation."))
      cat("Warning: No valid non-NA data for crosstabulation for this variable pair.\n\n---\n")
      next
    }

    if (is.function(color_palette)) {
      plot_colors <- color_palette(ncol(ct_table))
    } else if (is.character(color_palette)) {
      plot_colors <- color_palette
    } else {
      stop("Invalid 'color_palette' argument. Must be a character vector of colors or a colorRampPalette function.")
    }

    cat("\n#### クロス集計表 (", current_var_label, " vs. ", target_var_label, ")\n", sep="")
    print(knitr::kable(ct_table, caption = paste0(current_var_label, "と", target_var_label, "のクロス集計表")))

    # Generate plot title using new parameters: "[Explanatory Var]別[Target Var][main_text]"
    # main_textのデフォルトが""になったため、例えば"性別別生活満足度"となる
    plot_title <- paste0(current_var_label, "別", target_var_label, main_text)

    # Generate Y-axis label using new parameters: "[Explanatory Var][ylab_text]"
    plot_ylab <- paste0(current_var_label, ylab_text)

    barplot(t(ct_table[nrow(ct_table):1, ]),
            main = plot_title,
            xlab = xlab_text,
            ylab = plot_ylab,
            legend = TRUE,
            col = plot_colors,
            horiz = TRUE)

    cat("\n#### カイ二乗検定結果 (", current_var_label, " vs. ", target_var_label, ")\n", sep="")
    tryCatch({
      chi_test_result <- stats::chisq.test(current_var_actual, target_var_actual)
      print(chi_test_result)
    }, error = function(e) {
      cat("Error running Chi-squared test: ", e$message, "\n")
      cat("This might be due to insufficient non-NA data or other data issues.\n")
    })

    cat("\n---\n")
  }
}
