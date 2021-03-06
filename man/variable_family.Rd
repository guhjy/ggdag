% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/relations.R
\name{Assess familial relationships between variables}
\alias{Assess familial relationships between variables}
\alias{node_children}
\alias{node_parents}
\alias{node_ancestors}
\alias{node_descendants}
\alias{ggdag_children}
\alias{ggdag_parents}
\alias{ggdag_ancestors}
\alias{ggdag_descendants}
\title{Familial relationships between variables}
\usage{
node_children(.tdy_dag, .var, as_factor = TRUE)

node_parents(.tdy_dag, .var, as_factor = TRUE)

node_ancestors(.tdy_dag, .var, as_factor = TRUE)

node_descendants(.tdy_dag, .var, as_factor = TRUE)

ggdag_children(.tdy_dag, .var, ..., edge_type = "link_arc", node_size = 16,
  text_size = 3.88, text_col = "white", node = TRUE, text = TRUE,
  use_labels = NULL)

ggdag_parents(.tdy_dag, .var, ..., edge_type = "link_arc", node_size = 16,
  text_size = 3.88, text_col = "white", node = TRUE, text = TRUE,
  use_labels = NULL)

ggdag_ancestors(.tdy_dag, .var, ..., edge_type = "link_arc", node_size = 16,
  text_size = 3.88, text_col = "white", node = TRUE, text = TRUE,
  use_labels = NULL)

ggdag_descendants(.tdy_dag, .var, ..., edge_type = "link_arc",
  node_size = 16, text_size = 3.88, text_col = "white", node = TRUE,
  text = TRUE, use_labels = NULL)
}
\arguments{
\item{.tdy_dag}{input graph, an object of class \code{tidy_dagitty} or
\code{dagitty}}

\item{.var}{a character vector, the variable to be assessed (must by in DAG)}

\item{as_factor}{logical. Should the relationship variable be a factor?}

\item{...}{additional arguments passed to \code{tidy_dagitty()}}

\item{edge_type}{a character vector, the edge geom to use. One of:
"link_arc", which accounts for directed and bidirected edges, "link",
"arc", or "diagonal"}

\item{node_size}{size of DAG node}

\item{text_size}{size of DAG text}

\item{text_col}{color of DAG text}

\item{node}{logical. Should nodes be included in the DAG?}

\item{text}{logical. Should text be included in the DAG?}

\item{use_labels}{a string. Variable to use for
\code{geom_dag_repel_label()}. Default is \code{NULL}.}
}
\value{
a \code{tidy_dagitty} with an column related to the given
  relationship for variable D relationship or a \code{ggplot}
}
\description{
Parents and children are those nodes that either directly cause or are caused
by the variable, respectively. Ancestors and descendants are those nodes that
are on the path to or descend from the variable. The \code{node_*()}
functions label variables depending on their relationship. The
\code{ggdag_*()} functions plot the results. See
\code{dagitty::\link[dagitty]{children}} for details.
}
\examples{
dag <- dagify(y ~ x + z2 + w2 + w1,
  x ~ z1 + w1,
  z1 ~ w1 + v,
  z2 ~ w2 + v,
  w1 ~~ w2)

ggdag_children(dag, "w1")

dag \%>\%
  node_children("w1") \%>\%
  ggplot(aes(x = x, y = y, xend = xend, yend = yend, color = children)) +
  geom_dag_edges() +
  geom_dag_node() +
  geom_dag_text(col = "white") +
  geom_dag_label_repel(aes(label = children, fill = children), col = "white", show.legend = FALSE) +
  theme_dag() + scale_dag(breaks  = c("parent", "child"))

ggdag_parents(dag, "y")

ggdag_ancestors(dag, "x")

ggdag_descendants(dag, "w1")

dag \%>\%
  node_parents("y") \%>\%
  ggplot(aes(x = x, y = y, xend = xend, yend = yend, color = parent)) +
  geom_dag_edges() +
  geom_dag_node() +
  geom_dag_text(col = "white") +
  geom_dag_label_repel(aes(label = parent, fill = parent), col = "white", show.legend = FALSE) +
  theme_dag() + scale_dag(breaks  = c("parent", "child"))

}
