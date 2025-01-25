#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Define server logic for GDP and Life Expectancy Exploration App
function(input, output, session) {
    
    # Reactive value for filtered data
    plot_data <- reactive({
        req(input$country) # Ensure inputs are available
        gdp_le %>%
            filter(Country == input$country)
    })
    
    # Reactive value to track the active button
    active_view <- reactiveVal("gdp_vs_le")  # Default view
    
    # Update the active view when either button is clicked
    observeEvent(input$gdp_vs_le, {
        active_view("gdp_vs_le")
    })
    observeEvent(input$change_over_time, {
        active_view("change_over_time")
    })
    
    # Render the dynamic sidebar UI based on the active view
    output$dynamic_sidebar <- renderUI({
        if (active_view() == "gdp_vs_le") {
            tagList(
                selectInput('country', "Select Country", unique(gdp_le$Country))
            )
        } else if (active_view() == "change_over_time") {
            tagList(
                selectInput('country', "Select Country", unique(gdp_le$Country)),
                radioButtons(
                    "var_choice", "Choose your Variable(s):",
                    c("GDP_Per_Capita", "Life_Expectancy", "Both")
                )
            )
        }
    })
    
    # Reactive scatter plot
    output$line <- renderPlot({
        req(plot_data())  # Ensure plot_data is available
        if (active_view() == "gdp_vs_le") {
            ggplot(data = plot_data(), aes(x = GDP_Per_Capita, y = Life_Expectancy)) +
                geom_point() +
                labs(title = "GDP vs Life Expectancy",
                     x = 'GDP Per Capita',
                     y = 'Life Expectancy')+
                theme_minimal()
        } else {
            country_data <- gdp_le %>%
                filter(Country == input$country)
            
            if (input$var_choice == "Both") {
                # Normalize Life_Expectancy for shared scale
                max_gdp <- max(country_data$GDP_Per_Capita, na.rm = TRUE)
                min_gdp <- min(country_data$GDP_Per_Capita, na.rm = TRUE)
                country_data <- country_data %>%
                    mutate(Life_Expectancy_Scaled = scale(Life_Expectancy, center = min(Life_Expectancy), 
                                                          scale = max(Life_Expectancy) - min(Life_Expectancy)) * (max_gdp - min_gdp) + min_gdp)
                
                ggplot(data = country_data, aes(x = Year)) +
                    geom_line(aes(y = GDP_Per_Capita, color = "GDP Per Capita")) +
                    geom_line(aes(y = Life_Expectancy_Scaled, color = "Life Expectancy")) +
                    scale_y_continuous(
                        name = "GDP Per Capita",
                        sec.axis = sec_axis(~ ., name = "Life Expectancy", labels = function(x) (x - min_gdp) / (max_gdp - min_gdp) * (max(country_data$Life_Expectancy, na.rm = TRUE) - min(country_data$Life_Expectancy, na.rm = TRUE)) + min(country_data$Life_Expectancy, na.rm = TRUE))
                    ) +
                    labs(title = "Change Over Time (Both Variables)", x = "Year") +
                    theme_minimal() +
                    scale_color_manual(values = c("GDP Per Capita" = "blue", "Life Expectancy" = "red")) +
                    theme(legend.title = element_blank())
            } else {
                ggplot(data = country_data, aes(x = Year, y = get(input$var_choice))) +
                    geom_line() +
                    labs(title = "Change Over Time",
                         x = 'Year',
                         y = glue('{input$var_choice}')) +
                    theme_minimal()
            }
        }
    })
    
    output$table <- renderDataTable({
        plot_data()
    })
}
