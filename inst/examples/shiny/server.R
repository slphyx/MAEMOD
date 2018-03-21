library(maemod)

##for plotting the output
RunOde <- function(parms){

  parameters <- c(
    mui=0,
    muo=0,
    R0= 0,
    ps = 0.9,
    pr = 0.1,
    wait_treat = 5,
    omega=1/2,
    nuC=365/10,
    nuA=365/60,
    nuU=365/120,
    t_treat = 2,
    rho = 365/20,
    nu1 = 365/1,
    nu2 = 365/1,
    nu3 = 365/1,
    thetamax = 0.9,
    q=1,
    amp=1,
    phi=0,
    sensC=0.95,
    sensA=0.50,
    sensU=0.00,
    f=1
    ,parms
  )

  init <- c(S = 0,T1 = 1, T2 = 0, T3 = 0, Tp = 0, Tr = 0,IC1 = 0, IA1 = 0, IU1 = 0, P = 0, R = 0)
  outode <- maemod.ode(input.filename = "testmodel.mod", parms = parameters, init.state = init, times = seq(0, 42/365, by = (1/365)), method="vode")

  return(outode)
}



shinyServer(
  function(input, output, session) {

    parms <- reactive(c(
        c1max = input$c1max,
        c2max = input$c2max,
        c3max = input$c3max,
        cpmax = input$cpmax,
        prec = input$prec,
        nuDmin= as.numeric(input$nuDmin)
      )
    )

    outode <- reactive(RunOde(parms()))

    #plotting function
    plotX <- function(){
      sc <- outode()
      parameters <- maemod.parameters

      # data set to compare
      # for 'Early Treatment Failure'
      x_e<- c(1:3,7)
      y_e<-c(0.87,0.47,0.11,0)
      yl_e<-c(0.78,0.39,0.07,0)
      yu_e<-c(0.9,0.56,0.18,0.02)

      days<-sc[,1]*365
      fail<-sc[,"Fail"]

      z<-parameters["sensC"]*sc[,"IC1"]+sc[,"T1"]+sc[,"T2"]+sc[,"T3"]+sc[,"Tp"]+
        parameters["sensA"]*sc[,"IA1"]+ parameters["sensU"]*sc[,"IU1"]

      plot(x_e, y_e,pch=19,xlim=c(0,7),ylim=c(0,1),main='Early Treatment Failure',
           xlab='Days since treatment',ylab='Proportion')
      arrows(x_e, yl_e, x_e, yu_e, length=0.05, angle=90, code=3)
      lines(days,z)

    }


    output$graphs <- renderPlot({
      suppressWarnings(plotX())
      })


})

