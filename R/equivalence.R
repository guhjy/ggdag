#' Generating Equivalent Models
#'
#' Returns a set of complete partially directed acyclic graphs (CPDAGs) given an
#' input DAG. CPDAGs are Markov equivalent to the input graph. See
#' \code{dagitty::\link[dagitty]{equivalentDAGs}} for details.
#' \code{node_equivalent_dags()} returns a set of DAGs, while
#' \code{node_equivalent_class()} tags reversable edges.
#' \code{ggdag_equivalent_dags()} plots all equivalent DAGs, while
#' \code{ggdag_equivalent_class()} plots all reversable edges as undirected.
#'
#' @param .dag input graph, an object of class \code{tidy_dagitty} or
#'   \code{dagitty}
#' @param n maximal number of returned graphs.
#' @param .tdy_dag an object of class \code{tidy_dagitty} or \code{dagitty}
#' @param node_size size of DAG node
#' @param text_size size of DAG text
#' @param text_col color of DAG text
#' @param node logical. Should nodes be included in the DAG?
#' @param text logical. Should text be included in the DAG?
#' @param use_labels a string. Variable to use for
#'   \code{geom_dag_repel_label()}. Default is \code{NULL}.
#' @inheritParams tidy_dagitty
#' @inheritParams scale_dag
#'
#' @return a \code{tidy_dagitty} with at least one DAG, including a \code{dag}
#'   column to identify graph set for equivalent DAGs or a \code{reversable}
#'   column for equivalent classes, or a \code{ggplot}
#' @export
#'
#' @examples
#'
#' library(dagitty)
#' g_ex <- getExample("Shrier")
#'
#' g_ex %>%
#'   node_equivalent_dags() %>%
#'   ggplot(aes(x, y, xend = xend, yend = yend)) +
#'     geom_dag_node(size = 10) +
#'     geom_dag_edges(start_cap = ggraph::circle(5, "mm"),
#'                    end_cap = ggraph::circle(5, "mm")) +
#'     geom_dag_label_repel(aes(label = name), col = "black", size = 2) +
#'     theme_dag() +
#'     scale_dag(expand_x = expand_scale(c(0.25, 0.25)),
#'                           expand_y = expand_scale(c(0.25, 0.25))) +
#'   facet_wrap(~dag)
#'
#' confounder_triangle(x_y_associated = TRUE) %>% ggdag_equivalent_dags()
#'
#' g_ex %>% node_equivalent_class()
#'
#' dagify(y ~ x + z, x ~ z) %>% ggdag_equivalent_dags()
#'
#' @rdname equivalent
#' @name Equivalent DAGs and Classes
#' @export
node_equivalent_dags <- function(.dag, n = 100, layout = "auto", ...) {

  .dag <- if_not_tidy_daggity(.dag, layout = layout, ...)

  layout_coords <- .dag$data %>%
    dplyr::select(name, x, y) %>%
    dplyr::distinct() %>%
    coords2list()

  dagitty::coordinates(.dag$dag) <- layout_coords

  .dag$data <- dagitty::equivalentDAGs(.dag$dag, n = n) %>%
    purrr::map_df(~as.data.frame(tidy_dagitty(.dagitty = .x)), .id = "dag") %>%
    dplyr::as.tbl()
  .dag
}

#' @rdname equivalent
#' @export
ggdag_equivalent_dags <- function(.tdy_dag, ..., node_size = 16, text_size = 3.88,
                                  text_col = "white", node = TRUE, text = TRUE,
                                  use_labels = NULL) {

  .tdy_dag <- if_not_tidy_daggity(.tdy_dag) %>%
    node_equivalent_dags(...)

  p <- ggplot2::ggplot(.tdy_dag, ggplot2::aes(x = x, y = y, xend = xend, yend = yend)) +
    geom_dag_edges() +
    theme_dag()

  if (node) p <- p + geom_dag_node(size = node_size)
  if (text) p <- p + geom_dag_text(col = text_col, size = text_size)
  if (!is.null(use_labels)) p <- p +
    geom_dag_label_repel(ggplot2::aes_string(label = use_labels,
                                             fill = use_labels),
                         col = "white", show.legend = FALSE)

  if (dplyr::n_distinct(.tdy_dag$data$dag) > 1) {
    p <- p +
      ggplot2::facet_wrap(~dag) +
      scale_dag(expand_x = expand_scale(c(0.25, 0.25)))
  } else {
    p <- p + scale_dag()
  }

  p
}

#' @rdname equivalent
#' @export
node_equivalent_class <- function(.dag, layout = "auto") {
  .dag <- if_not_tidy_daggity(.dag, layout = layout)
  .dag$data <- dagitty::equivalenceClass(.dag$dag) %>%
    dagitty::edges(.) %>%
    dplyr::filter(e == "--") %>%
    dplyr::select(name = v, reversable = e) %>%
    dplyr::mutate(name = as.character(name)) %>%
    dplyr::left_join(.dag$data, .,  by = "name") %>%
    dplyr::mutate(reversable = !is.na(reversable))

  .dag
}

#' @rdname equivalent
#' @export
ggdag_equivalent_class <- function(.tdy_dag,
                                   expand_x = expand_scale(c(.10, .10)),
                                   expand_y = expand_scale(c(.10, .10)),
                                   breaks = ggplot2::waiver(), ...,
                                   node_size = 16, text_size = 3.88, text_col = "white",
                                   node = TRUE, text = TRUE, use_labels = NULL) {
  .tdy_dag <- if_not_tidy_daggity(.tdy_dag) %>%
    node_equivalent_class(...)

  reversable_lines <- dplyr::filter(.tdy_dag$data, reversable)
  non_reversable_lines <- dplyr::filter(.tdy_dag$data, !reversable)
  p <- .tdy_dag %>%
    ggplot2::ggplot(ggplot2::aes(x = x, y = y, xend = xend, yend = yend, edge_alpha = reversable)) +
    geom_dag_edges(data_directed = dplyr::filter(non_reversable_lines, direction != "<->"),
                   data_bidirected = dplyr::filter(non_reversable_lines, direction == "<->")) +
    geom_dag_edges_link(data = reversable_lines, arrow = NULL) +
    theme_dag() +
    ggplot2::scale_color_brewer(name = "", drop = FALSE, palette = "Set2", na.value = "grey50", breaks = breaks) +
    ggplot2::scale_fill_brewer(name = "", drop = FALSE, palette = "Set2", na.value = "grey50") +
    ggplot2::scale_x_continuous(expand = expand_x) +
    ggplot2::scale_y_continuous(expand = expand_y) +
    ggraph::scale_edge_alpha_manual(name = "Reversable", drop = FALSE, values = c(.1, 1))

  if (node) p <- p + geom_dag_node(size = node_size)
  if (text) p <- p + geom_dag_text(col = text_col, size = text_size)
  if (!is.null(use_labels)) p <- p +
    geom_dag_label_repel(ggplot2::aes_string(label = use_labels,
                                             fill = "CHANGEME"),
                         col = "white", show.legend = FALSE)
  p
}
