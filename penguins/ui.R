#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


# Define UI for application that draws a histogram
fluidPage(
    
    # Application title
    titlePanel("Penguin Mass Data"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            width = 3,
            
            selectInput('histvariable',
                        label = 'Select a histogram variable',
                        choices = numeric_variables),
            
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            
            selectInput('island',
                        h3('Select Island'),
                        choices = c('All', unique(penguins$island |> sort())),
                        #could also do penguins |> distinct(island) |> pull(island) |> sort()
                        selected=1)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            
            width = 9,
            
            fluidRow( #to make plots in same row
                
                column( # force them to be in the same row
                    width = 6,
                    plotOutput("distPlot", height = '300px'),
                    
                ),
                
                column(
                    width = 6,
                    plotOutput('speciescountPlot', height = '300px') 
                )
                
            ),
            
            fluidRow(
                dataTableOutput("selecteddataTable")
            )
        )
    )
)
