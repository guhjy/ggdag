% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dplyr_methods.R
\name{dplyr}
\alias{dplyr}
\alias{select.tidy_dagitty}
\alias{dplyr}
\alias{filter.tidy_dagitty}
\alias{dplyr}
\alias{mutate.tidy_dagitty}
\alias{dplyr}
\alias{summarise.tidy_dagitty}
\alias{dplyr}
\alias{arrange.tidy_dagitty}
\alias{dplyr}
\alias{group_by.tidy_dagitty}
\alias{dplyr}
\alias{ungroup.tidy_dagitty}
\alias{dplyr}
\alias{transmute.tidy_dagitty}
\alias{dplyr}
\alias{distinct.tidy_dagitty}
\alias{dplyr}
\alias{full_join.tidy_dagitty}
\alias{dplyr}
\alias{inner_join.tidy_dagitty}
\alias{dplyr}
\alias{left_join.tidy_dagitty}
\alias{dplyr}
\alias{right_join.tidy_dagitty}
\alias{dplyr}
\alias{anti_join.tidy_dagitty}
\alias{dplyr}
\alias{semi_join.tidy_dagitty}
\alias{dplyr}
\alias{slice.tidy_dagitty}
\alias{dplyr}
\alias{select_.tidy_dagitty}
\alias{dplyr}
\alias{filter_.tidy_dagitty}
\alias{dplyr}
\alias{mutate_.tidy_dagitty}
\alias{dplyr}
\alias{summarise_.tidy_dagitty}
\alias{dplyr}
\alias{arrange_.tidy_dagitty}
\alias{dplyr}
\alias{slice_.tidy_dagitty}
\title{Dplyr verb methods for \code{tidy_dagitty} objects}
\usage{
\method{select}{tidy_dagitty}(.data, ...)

\method{filter}{tidy_dagitty}(.data, ...)

\method{mutate}{tidy_dagitty}(.data, ...)

\method{summarise}{tidy_dagitty}(.data, ...)

\method{arrange}{tidy_dagitty}(.data, ...)

\method{group_by}{tidy_dagitty}(.data, ...)

\method{ungroup}{tidy_dagitty}(.data, ...)

\method{transmute}{tidy_dagitty}(.data, ...)

\method{distinct}{tidy_dagitty}(.data, ..., .keep_all = FALSE)

\method{full_join}{tidy_dagitty}(x, y, by = NULL, copy = FALSE,
  suffix = c(".x", ".y"), ...)

\method{inner_join}{tidy_dagitty}(x, y, by = NULL, copy = FALSE,
  suffix = c(".x", ".y"), ...)

\method{left_join}{tidy_dagitty}(x, y, by = NULL, copy = FALSE,
  suffix = c(".x", ".y"), ...)

\method{right_join}{tidy_dagitty}(x, y, by = NULL, copy = FALSE,
  suffix = c(".x", ".y"), ...)

\method{anti_join}{tidy_dagitty}(x, y, by = NULL, copy = FALSE, ...)

\method{semi_join}{tidy_dagitty}(x, y, by = NULL, copy = FALSE, ...)

\method{slice}{tidy_dagitty}(.data, ..., .dots = list())

\method{select_}{tidy_dagitty}(.data, ..., .dots = list())

\method{filter_}{tidy_dagitty}(.data, ..., .dots = list())

\method{mutate_}{tidy_dagitty}(.data, ..., .dots = list())

\method{summarise_}{tidy_dagitty}(.data, ..., .dots = list())

\method{arrange_}{tidy_dagitty}(.data, ..., .dots = list())

\method{slice_}{tidy_dagitty}(.data, ..., .dots = list())
}
\arguments{
\item{.data}{data object of class \code{tidy_dagitty}}

\item{...}{other arguments passed to the \code{dplyr} function}

\item{.dots, x, y, by, copy, suffix, .keep_all}{see corresponding function in
package \code{dplyr}}
}
\description{
Dplyr verb methods for \code{tidy_dagitty} objects.
}
\examples{
library(dplyr)
tidy_dagitty(m_bias()) \%>\%
  group_by(name) \%>\%
  summarize(n = n())
}
