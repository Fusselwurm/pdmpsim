% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/msCsv.R
\name{multSimCsv}
\alias{multSimCsv}
\alias{multsimcsv}
\title{Multiple simulations of a pdmp model}
\usage{
multSimCsv(obj, seeds, prefix = format(obj, end = "__"), append = FALSE,
  uniqueSeeds = TRUE, digits = NULL)
}
\arguments{
\item{obj}{object of class pdmpModel or one of its subclasses}

\item{seeds}{integer vector with seeds that shall be simulated
(different seeds lead to different simulated trajectories)}

\item{prefix}{string which determines the begin of all filenames that are 
created by the method, e.g. "NameOfModel". You can also specify a path where 
to save the result, e.g. "home/path/to/simulations/NameofModel".}

\item{append}{logical. If there already exists a file with the same filename 
and \code{append = TRUE}, the simulated results will be appended at the end 
of the file. Otherwise an error will be thrown.}

\item{uniqueSeeds}{logical. If some numbers in \code{seeds} appear multiple 
times, shall the corresponding simulations be saved only once? If 
append = TRUE, \code{seeds} and already simulated seeds will both be checked 
for repeated seed numbers.}

\item{digits}{integer indicating how many significant digits are to be saved 
in the csv files. Restricting digits can lead to smaller csv files. The 
default, NULL, uses \code{\link{getOption}("digits")}.}
}
\value{
object of class \code{multSimCsv} providing the filenames of all 
files that contain the simulated results with corresponding \pkg{LaF} objects 
stored in element \code{lafList}.
}
\description{
Perform simulations of a pdmp model and save 
the results in multiple csv files.
}
\details{
This method performs a simulation of the pdmpModel \code{obj} for every seed 
that appears in vector \code{seeds}. The result is stored in different csv 
files in the working directory (or any other directory if specified in 
\code{prefix}). Saving the results as csv files is important for large 
simulations where the files become bigger than the working memory of the 
computer. Saving as .rda object (as can be done with method 
\code{\link{multSim}}) then becomes useless because rda objects are loaded 
completely into R and therefore have to be smaller than the working memory.
If the simulations are stored as csv files, they can be accessed with methods
from package \pkg{LaF}.

Every csv file created by \code{multSimCsv} contains the simulated values of 
one of the variables of the model \code{obj}.
If e.g. the \code{init} slot of \code{obj} is given as 
\code{c(f = 1, g = 2, h = 3)} and \code{prefix = "exampleModel"}, 
method \code{multSimCsv} will create three csv files named 
\code{exampleModel_Simulations_f.csv}, \code{exampleModel_Simulations_g.csv},
and \code{exampleModel_Simulations_h.csv} where the first contains all 
simulated values of variable \code{f}, the second of \code{g} and the third 
of \code{h}.

The csv files are constructed as follows:
\itemize{
\item The first row contains the names of the columns. The first column is 
named "Seed", all other column names come from the time values, e. g. "time0" 
"time0.1" "time0.2" and so on.
\item All other rows contain the seed (first column) and the corresponding 
simulation for one of the variables.
}

Slot \code{obj@out} is not affected by \code{multSim}.
In case of a break or an error, already simulated seeds will still be saved 
in the csv files.

Method \code{multSimCsv} also saves and returnes an object of s3 class 
\code{multSimCsv} which contains all important informations about the 
simulation and can be loaded into the working memory. In our example, 
this object would be saved as "exampleModel_MultSimCsv.rda". 
The class has 6 elements:
\itemize{
\item \code{model} containing the pdmpModel \code{obj},
\item \code{seeds} containing the integer vector \code{seeds},
\item \code{csvList}: a character vector containing the filenames of 
stored simulated results,
\item \code{datamodel} containing all the information package \pkg{LaF} needs 
for opening the csv files,
\item \code{lafList}: a list for the corresponding LaF objects,
\item \code{timeList}: a list containing the time needed for every simulation
}
Element \code{lafList} has to be created during run-time, therefore it is 
saved as null. The returned \code{multSimCsv} object however has a valid 
\code{lafList}. If you want to load a \code{multSimCsv} object from a rda
file, use \code{\link{loadMultSimCsv}} to create \code{lafList} automatically.
}
\section{Working with the simulations}{


If you stored your simulations in csv files with \code{multSimCsv}, you
can access the results by loading the corresponding \code{rda} object
with \code{\link{loadMultSimCsv}} and store them in a variable, i.e. 
\code{msCsv}. Then you can read out i.e. the simulated values of 
the second variable (referring to the order of your variables in 
slot \code{init}) with the third seed via \code{msCsv$lafList[[2]][3, ]}.\cr

There are also a lot of plot methods available. To use them, you first
have to choose some seed numbers and time values and use method
\code{\link{getMultSimData}} to store them in a \code{data.frame}. 
This method may need some time for calculation and the result needs to
fit into the working memory. Afterwards, you can apply methods
\code{\link{plot}}, \code{\link{plotTimes}}, \code{\link{plotStats}},
\code{\link{summarize_at}}, \code{\link{hist}}, \code{\link{density}} 
and \code{\link{plotSeeds}} on the data.frame created with 
\code{getMultSimData}. You can also use \code{\link{plotTimes}} to find 
the seed numbers of interesting outliers by setting an appropriate threshold.

\code{}
}

\seealso{
\code{\link{loadMultSimCsv}} to load a stored \code{multSimCsv} 
object, \code{multSim} to perform multiple simulations that need not
too much memory, \code{\link{multSim2multSimCsv}} to convert an object
created with method \code{multSim} into a \code{multSimCsv} object.
}
