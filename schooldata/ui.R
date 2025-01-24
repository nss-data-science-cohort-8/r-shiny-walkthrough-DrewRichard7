#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


# Define UI for application that draws a 
fluidPage(
    
    # Application title
    titlePanel("2014-2015 High School Performance Data - TN"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput(
                'district',
                h2('Select District'),
                choices = unique(school_testing$system_name |> sort()),
                selected=1
            ),
            radioButtons(
                'subject',
                h2('Select Subject'),
                choices = unique(school_testing$subject |> sort())
            ),
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("performancePlot")
        )
    )
)
