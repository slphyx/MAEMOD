library(shiny)


fluidPage(
          # Application title
          tags$h2("Test with MAEMOD package"),
          p("This is a test of a dynamics malaria model with ",
            tags$a(href="http://www.githut.com/slphyx/maemod/", "maemod package"),
            "."),
          hr(),

          fluidRow(
            wellPanel(

              fluidRow(
                column(2,NULL),
                column(4,
                  sliderInput("c1max","proprtion who cure on day 1 of treatment", min = 0,max = 1,step = 0.01,value = 0),
                  sliderInput("c2max","proprtion who cure on day 2 of treatment", min = 0,max = 1,step = 0.01,value = 0.5),
                  sliderInput("c3max","proprtio n who cure on day 3 of treatment", min = 0,max = 1,step = 0.01,value = 0.99)

                ),
                column(4,
                  sliderInput("cpmax","proprtion who cure during partner drug treatment", min = 0,max = 1,step = 0.01,value = 0.99),
                  sliderInput("prec","proportion who recrudesce", min = 0,max = 1,step = 0.01,value = 0.99),
                  radioButtons(inputId ="nuDmin", label = "nuDmin", choices = list("365/7"=365/7,"365/28"=365/28)
                ),column(2,NULL)
              )

              )
            ),
          fluidRow(
            plotOutput("graphs")
            )
          )
)
