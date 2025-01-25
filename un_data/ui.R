#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


# Define UI for UN Data Exploration app ----
# Sidebar layout with input and output definitions ----
# Define UI for UN Data Exploration app ----
page_sidebar(
    
    # App title ----
    title = "GDP Per Capita and Life Expectancy Exploration",
    
    # Sidebar panel for inputs ----
    sidebar = sidebar(
        
        # Input: Action Buttons to toggle the sidebar content ----
        actionButton(
            'gdp_vs_le',
            "GDP Per Capita vs. Life Expectancy"
        ),
        actionButton(
            'change_over_time',
            "Change Over Time"
        ),
        
        # Dynamic UI content that will change based on the button clicked
        uiOutput("dynamic_sidebar")
        
    ),
    
    # Main panel for displaying outputs ----
    navset_card_underline(
        
        title = "Visualizations",
        
        # Panel with scatter plot ----
        #nav_panel("Scatter", plotOutput("scatter")),
        
        # Panel with line plot ----
        nav_panel("Plot", plotOutput("line")),
        
        # Panel with table ----
        nav_panel("Table", dataTableOutput("table"))
    )
)
