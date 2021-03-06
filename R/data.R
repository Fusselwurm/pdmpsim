#======== todo =================================================================

#t1 toggleSwitch: references
#t2: SIRstoch: implement

#######################################################################

#' A simple PDMP
#'
#' This is a simple example for a piecewise deterministic markov process
#' defined as \code{\link{pdmpModel}}. It is included to the package for 
#' demonstration purposes and is used in some unit tests and function 
#' examples.
#' @slot parms There are no parameters for this model.
#' @slot init  There is one continous variable \code{f} with initial value 0
#' and one discrete variable \code{d} initial value 0.
#' @slot discStates The discrete variable \code{d} has codomain \{-1, 0, 1\}.
#' @slot dynfunc The continous variable \code{f} evolves as linear function
#' \eqn{f(t) = t} if \code{d = 1},
#' as \eqn{f(t) = -t} if \code{d = -1} and is constant zero if \code{d = 0}. 
#' Its dynamic can therefore be described as \eqn{\frac{df}{dt} = d}{df/dt = d}.
#' @slot jumpfunc There are two jumptypes. The first jumps from \code{d} to 
#' \code{d - 1}, the second from \code{d} to \code{d + 1}. Both reset \code{f} 
#' to zero.
#' @slot ratefunc A vector of length two determining the probability of a jump 
#' being of type 1 or 2. If \code{d = -1}, it has value \code{(0, 2)} forcing 
#' the jumptype to be of type 2. The same takes place for \code{d = 1}: 
#' \code{ratefunc} returnes \code{(2, 0)} and the jumptype is therefore always 
#' of type 1. In case \code{d = 0}, \code{ratefunc} returnes \code{(1, 1)} which
#' leads to a probability of \eqn{\frac{1}{2}}{½} to have a jumptype of type 
#' 1 or 2.
#' @slot times The simulations will start at time \code{t = 0} and end at 
#' \code{t = 10} with step length 0.01.
#' @format An object of class \code{\link{pdmpModel}}.
#' @seealso \code{\link{toggleSwitch}} for a more sophisticated example of a 
#' \code{pdmpModel} and \code{\link{pdmpModel}}
#' for the formal description of the S4 class.
#' @example inst/models/simplePdmp.R
"simplePdmp"

#######################################################################

#' The toggle switch model
#'
#' This is an example for a piecewise deterministic markov process defined as 
#' \code{\link{pdmpModel}}. It models a gene regulation mechanism that is called 
#' toggle switch. This mechanism describes two genes A and B whose gene products
#' are repressors to the other gene, i. e. the gene product of A blocks the gene 
#' expression of gene B and vice versa. This model is an example for a PDMP with 
#' two discrete and two continous variables. It is included to the package for 
#' demonstration purposes and is used in some unit tests and function examples.
#'
#' @slot init  There are two continous variables \eqn{f_A}{fA} and \eqn{f_B}{fB}
#' which describe the concentration of gene products from gene A and gene B, 
#' respectivly. Both have initial value 0.5. The two discrete variables 
#' \eqn{d_A}{dA} and \eqn{d_B}{dB} describe the expression state of gene A and 
#' gene B and have initial value 1, which means that both genes are not blocked.
#' @slot discStates The discrete variables \eqn{d_A}{dA} and \eqn{d_B}{dB} both
#' have codomain \{0, 1\} where 0 stands for "Gene A/B is blocked" and 1 
#' stands for "Gene A/B is unblocked".
#' @slot dynfunc The dynamic of the continous variable \eqn{f_A}{fA} depends on 
#' the state of discrete variable \eqn{d_A}{dA}. In case \eqn{d_A = 0}{dA = 0} 
#' it is given by \eqn{\frac{df_A}{dt} = -b_A \cdot f_A}{dfA/dt = -bA⋅fA} 
#' describing an exponential decay of the concentration of gene product \code{A}. 
#' If \eqn{d_A = 1}{dA = 1}, there is an additional term of linear growth leading 
#' to the ODE \eqn{\frac{df_A}{dt} = -b_A \cdot f_A + a_A}{dfA/dt = -bA⋅fA + aA}.
#' Both formulas can be combined to \eqn{\frac{df_A}{dt} = -b_A \cdot f_A + a_A 
#' \cdot d_A}{dfA/dt = -bA⋅fA + aA⋅dA}. Accordingly, the dynamic of dB is given 
#' as \eqn{\frac{df_B}{dt} = -b_B \cdot f_B + a_B \cdot d_B}{dfB/dt = -bB⋅fB + 
#' aB⋅dB}.
#' @slot jumpfunc There are two jumptypes. If the jump is of type 1, only the 
#' value of \eqn{d_B}{dB} is changed (from 0 to 1 or 1 to 0, respectivly). 
#' All other variables remain unchanged. The second jumptype changes only the 
#' value of \eqn{d_A}{dA}.
#' @slot ratefunc A vector of length two determining the probability of a jump 
#' being of type 1 or 2. In this model, a molecule of gene product A can act as 
#' repressor and impede the gene expression of gene B. The rates for the first 
#' jumptype (which describes a change in the gene expression of gene B) are 
#' therefore \eqn{k_{10A} \cdot fA}{k10A⋅fA} for the change from the unblocked 
#' (\eqn{d_B = 1}{dB = 1}) to the blocked (\eqn{d_B = 0}{dB = 0}) state and 
#' \eqn{k_{01A}}{k01A} for the change from the blocked to the unblocked state 
#' of gene B. The rates for the second jumptype are generated in an analogous 
#' way because gene A is repressed by a molecule of gene product B and the 
#' second jumptype describes a change in the gene expression of gene A.
#' @slot parms There are are a number of parameters that appear in the dynamics 
#' and rates of the process, namely \eqn{b_A, b_B, a_A, a_B, k_{01A}, k_{10A},
#' k_{01B}}{bA, bB, aA, aB, k01A, k10A, k01B} and \eqn{k_{10B}}{k10B}. 
#' The values of the parameters in this example are artificial and are not based
#' on real data.
#' @slot times The simulations will start at time \code{t = 0} and end at 
#' \code{t = 10} with step length 0.01.
#' @format An object of class \code{\link{pdmpModel}}.
#' @seealso \code{\link{simplePdmp}} for an easier example of a \code{pdmpModel}
#' and \code{\link{pdmpModel}}
#' for the formal description of the S4 class.
#' @example inst/models/toggleSwitch.R
"toggleSwitch"


#######################################################################

#' Kendalls birth-and-death process
#'
#' This is a simple example for a markov jump process
#' defined as \code{\link{mjpModel}}. It is included to the package for 
#' demonstration purposes.
#' @slot parms birth and death rate.
#' @slot init  There is one integer  variable \code{N} with initial value 1.
#' @slot jumpfunc There are two jumptypes. Births  jump from \code{N} to 
#' \code{N + 1}, deaths from \code{N} to \code{N - 1}. 
#' @slot ratefunc A vector of length two determining the probability of a jump 
#' being a birth or a death. 
#' @slot times The simulations will start at time \code{t = 0} and end at 
#' \code{t = 10} with step length 0.01.
#' @format An object of class \code{\link{mjpModel}}.
#' @seealso \code{\link{SIRstoch}} for a more sophisticated example of a 
#' \code{mjpModel} and \code{\link{mjpModel-class}}
#' for the formal description of the S4 class.
#' @example inst/models/KendallBD.R
"KendallBD"


#######################################################################

#' Stochastic SIR dynamics
#'
#' This is a mor complicated example for a markov jump process
#' defined as \code{\link{mjpModel}}. It is included to the package for 
#' demonstration purposes.
#' @slot parms infection (\code{beta}) and recovery  rate (\code{gamma}).
#' @slot init  There are three integer  variables \code{S,I,R} with initial value (10,1,0).
#' @slot jumpfunc There are two jumptypes. infections  jump from \code{(S,I,R)} to 
#' \code{(S-1,I+1,R)}, recoveries from \code{(S,I,R)} to \code{(S,I-1,R+1)}. 
#' @slot ratefunc A vector of length two determining the probability of a jump 
#' being a recovery or infection. 
#' @slot times The simulations will start at time \code{t = 0} and end at 
#' \code{t = 10} with step length 0.01.
#' @format An object of class \code{\link{mjpModel}}.
#' @seealso \code{\link{KendallBD}} for a  simpler example of a 
#' \code{mjpModel} and \code{\link{mjpModel-class}}
#' for the formal description of the S4 class.
#' @example inst/models/SIRstoch.R
"SIRstoch"
