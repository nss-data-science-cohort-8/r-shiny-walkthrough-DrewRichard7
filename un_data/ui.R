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
        
        # Conditional panel for 'GDP vs Life Expectancy'
        conditionalPanel(
            condition = "input.gdp_vs_le > input.change_over_time",
            # Inputs for this view
            selectInput(
                'country',
                "Select Country",
                unique(gdp_le$Country)
            ),
            selectInput(
                'year',
                "Select Year",
                unique(gdp_le$Year)
            )
        ),
        
        # Conditional panel for 'Change Over Time'
        conditionalPanel(
            condition = "input.change_over_time > input.gdp_vs_le",
            # Inputs for this view
            selectInput(
                'country',
                "Select Country",
                unique(gdp_le$Country)
            ),
            sliderInput(
                "slider_range",
                "Year Range",
                min = min(unique(gdp_le$Year)),
                max = max(unique(gdp_le$Year)),
                value = c(2000, 2010)
            ),
            radioButtons(
                "var_choice",
                "Choose your Variable(s):",
                c("GDP_Per_Capita", "Life_Expectancy", "Both")
            )
        )
    ),
    
    # Main panel for displaying outputs ----
    navset_card_underline(
        
        title = "Visualizations",
        
        # Panel with scatter plot ----
        nav_panel("Scatter", plotOutput("scatter")),
        
        # Panel with line plot ----
        nav_panel("Line Plot", plotOutput("line")),
        
        # Panel with table ----
        nav_panel("Table", tableOutput("table"))
    )
)
