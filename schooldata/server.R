#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


# Define server logic required to draw 
function(input, output, session) {
    output$performancePlot <- renderPlot({
        title <- glue("Performance Comparison in {input$district} High Schools")
        
        filtered_data <- school_testing |> 
            filter(
                (system_name == input$district) & 
                    subject == input$subject
            )|> 
            filter(
                !str_detect(pct_below_bsc, "\\*") & 
                    !str_detect(pct_bsc, "\\*") & 
                    !str_detect(pct_prof, "\\*") & 
                    !str_detect(pct_adv, "\\*")
            )
        
        if (nrow(filtered_data) == 0) {
            return(NULL) # Safely handle empty plots
        }
        
        # output$distPlot <- renderPlot({
        #     
        #     validate(
        #         need(input$gourd_type != "", "Please select a gourd.")
        #     )
        
        filtered_data |> 
            select(school_name, subject, grade, pct_below_bsc:pct_adv) |> 
            rowwise() |> 
            mutate_at(vars(pct_below_bsc:pct_adv), as.numeric) |> 
            mutate(total = sum(c_across(pct_below_bsc:pct_adv))) |> 
            pivot_longer(
                cols = c(pct_below_bsc, pct_bsc, pct_prof, pct_adv),
                names_to = "Performance_Level",
                values_to = "Percentage"
            ) |> 
            drop_na('Percentage') |> 
            mutate(
                Performance_Level = factor(
                    Performance_Level, 
                    levels = c("pct_below_bsc", "pct_bsc", "pct_prof", "pct_adv") # Correct order
                )
            ) |> 
            ggplot(aes(x = school_name, y = Percentage, fill = Performance_Level)) +
            geom_bar(stat = "identity", position = "stack") +
            labs(
                title = title,
                x = "High Schools",
                y = "Percentage",
                caption = '*Schools that did not provide data are not represented.\n**Subjects not provided are not represented',
                fill = "Performance Levels"
            ) +
            theme_minimal() +
            theme(axis.text.x = element_text(angle = 45, hjust = 1),
                  plot.caption.position = 'plot')
    })
}

