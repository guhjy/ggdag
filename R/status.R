#' Find variable status
#'
#' Detects variable status given a DAG (exposure, outcome, latent). See
#' \code{dagitty::\link[dagitty]{VariableStatus}} for details.
#'
#' \code{node_collider} tags variable status and \code{ggdag_collider} plots all
#' variable statuses.
#'
#' @param .dag,.tdy_dag input graph, an object of class \code{tidy_dagitty} or
#'   \code{dagitty}
#' @param ... additional arguments passed to \code{tidy_dagitty()}
#' @param edge_type a character vector, the edge geom to use. One of:
#'   "link_arc", which accounts for directed and bidirected edges, "link",
#'   "arc", or "diagonal"
#' @param as_factor treat \code{status} variable as factor
#' @param node_size size of DAG node
#' @param text_size size of DAG text
#' @param text_col color of DAG text
#' @param node logical. Should nodes be included in the DAG?
#' @param text logical. Should text be included in the DAG?
#' @param use_labels a string. Variable to use for
#'   \code{geom_dag_repel_label()}. Default is \code{NULL}.
#'
#' @return a \code{tidy_dagitty} with a \code{status} column for
#'   variable status or a \code{ggplot}
#' @export
#'
#' @examples
#' dag <- dagify(l ~ x + y,
#'   y ~ x,
#'   exposure = "x",
#'   outcome = "y",
#'   latent = "l")
#'
#' node_status(dag)
#' ggdag_status(dag)
#'
#' @rdname status
#' @name Variable Status
node_status <- function(.dag, as_factor = TRUE, ...) {
  .tdy_dag <- if_not_tidy_daggity(.dag, ...)
  .exposures <- dagitty::exposures(.tdy_dag$dag)
  .outcomes <- dagitty::outcomes(.tdy_dag$dag)
  .latents <- dagitty::latents(.tdy_dag$dag)
  .tdy_dag$data <- dplyr::mutate(.tdy_dag$data,
                                 status = ifelse(name %in% .exposures, "exposure",
                                                 ifelse(name %in% .outcomes, "outcome",
                                                        ifelse(name %in% .latents, "latent",
                                                               NA))))
  if (as_factor) .tdy_dag$data$status <- factor(.tdy_dag$data$status, exclude = NA)
  .tdy_dag
}

#' @rdname status
#' @export
ggdag_status <- function(.tdy_dag, ..., edge_type = "link_arc", node_size = 16, text_size = 3.88,
                         text_col = "white", node = TRUE, text = TRUE,
                         use_labels = NULL) {

  edge_function <- edge_type_switch(edge_type)

  p <- if_not_tidy_daggity(.tdy_dag) %>%
    node_status(...) %>%
    ggplot2::ggplot(ggplot2::aes(x = x, y = y, xend = xend, yend = yend, color = status)) +
    edge_function() +
    theme_dag() +
    scale_dag(breaks = c("exposure", "outcome", "latent"))

  if (node) p <- p + geom_dag_node(size = node_size)
  if (text) p <- p + geom_dag_text(col = text_col, size = text_size)
  if (!is.null(use_labels)) p <- p +
      geom_dag_label_repel(ggplot2::aes_string(label = use_labels,
                                               fill = "status"),
                           col = "white", show.legend = FALSE)
  p
}
