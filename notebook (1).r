
# Load the readr, ggplot2, and dplyr packages
library(readr)
library(ggplot2)
library(dplyr)

# Read datasets/confirmed_cases_worldwide.csv into confirmed_cases_worldwide
confirmed_cases_worldwide <- read_csv("datasets/confirmed_cases_worldwide.csv",
                                     col_types = cols(
                                     date = col_date(format = ""),
                                     cum_cases = col_double()))

# See the result
confirmed_cases_worldwide

library(testthat) 
library(IRkernel.testthat)

soln_confirmed_cases_worldwide <- read_csv("datasets/confirmed_cases_worldwide.csv")

run_tests({
    test_that("readr is loaded", {
        expect_true(
            "readr" %in% .packages(), 
            info = "Did you load the `readr` package?"
        )
    })
    test_that("ggplot2 is loaded", {
        expect_true(
            "ggplot2" %in% .packages(), 
            info = "Did you load the `ggplot2` package?"
        )
    })
    test_that("dplyr is loaded", {
        expect_true(
            "dplyr" %in% .packages(), 
            info = "Did you load the `dplyr` package?"
        )
    })
    
    test_that("confirmed_cases_worldwide is a data.frame", {
        expect_s3_class(
            confirmed_cases_worldwide,
            "data.frame",
        )
    })
    test_that("confirmed_cases_worldwide has the correct column", {
        expect_identical(
            colnames(confirmed_cases_worldwide),
            colnames(soln_confirmed_cases_worldwide), 
            info = "The column names of the `confirmed_cases_worldwide` data frame do not correspond with the ones in the CSV file: `\"datasets/confirmed_cases_worldwide.csv\"`."
        ) 
    })
    test_that("has the correct data", {
        expect_equal(
            confirmed_cases_worldwide,
            soln_confirmed_cases_worldwide, 
            info = "The data of the `confirmed_cases_worldwide` data frame do not correspond with data in the CSV file: \"datasets/confirmed_cases_worldwide.csv\"."
        )
    })
})

# Draw a line plot of cumulative cases vs. date
# Label the y-axis

ggplot(confirmed_cases_worldwide, aes(x = date, y = cum_cases)) +
 geom_line() +
  labs(y = "Cumulative Cases")


run_tests({
    plot <- last_plot()
    test_that("the plot is created", {
        expect_false(
            is.null(plot),
            info = "Could not find a plot created with `ggplot()`."
        )
    })
    test_that("the plot uses the correct data", {
        expect_equal(
            plot$data,
            confirmed_cases_worldwide,
            info = "The dataset used in the last plot is not `confirmed_cases_worldwide`."
        )
    })
    test_that("the plot uses the correct x aesthetic", {
        expect_equal(
            quo_name(plot$mapping$x),
            "date",
            info = "The x aesthetic used in the last plot is not `date`."
        )
    })
    test_that("the plot uses the correct y aesthetic", {
        expect_equal(
            quo_name(plot$mapping$y),
            "cum_cases",
            info = "The y aesthetic used in the last plot is not `cum_cases`."
        )
    })
    test_that("the plot uses the correct geom", {
        expect_true(
            "GeomLine" %in% class(plot$layers[[1]]$geom),
            info = "The geom used in the last plot is not `geom_line()`."
        )
    })
    test_that("the plot uses the correct y label", {
        expect_true(
            grepl("[Cc]umulative\\s+[Cc]onfirmed\\s+[Cc]ases", plot$labels$y),
            info = "The y label used in the last plot is not `\"Cumulative confirmed cases\"`."
        )
    })
})

# Read in datasets/confirmed_cases_china_vs_world.csv
confirmed_cases_china_vs_world <- read_csv("datasets/confirmed_cases_china_vs_world.csv",
                                          col_types = cols(
                                          is_china = col_character(),
                                          date = col_date(format = "%Y-%m-%d"),
                                          cases = col_double(),
                                          cum_cases = col_double()
                                           ))

# See the result
confirmed_cases_china_vs_world

# Draw a line plot of cumulative cases vs. date, colored by is_china
# Define aesthetics within the line geom
plt_cum_confirmed_cases_china_vs_world <- ggplot(confirmed_cases_china_vs_world, aes(x = date, y = cum_cases)) +
  geom_line(aes(color = is_china)) +
  ylab("Cumulative confirmed cases")

# See the plot
plt_cum_confirmed_cases_china_vs_world


soln_confirmed_cases_china_vs_world <- read_csv("datasets/confirmed_cases_china_vs_world.csv")

run_tests({
    test_that("confirmed_cases_china_vs_world is a data.frame", {
        expect_s3_class(
            confirmed_cases_china_vs_world,
            "data.frame"
        )
    })
    test_that("confirmed_cases_china_vs_world has the correct column names", {
        expect_identical(
            colnames(confirmed_cases_china_vs_world),
            colnames(soln_confirmed_cases_china_vs_world), 
            info = "The column names of the `confirmed_cases_china_vs_world` data frame do not correspond with the ones in the CSV file: `\"datasets/confirmed_cases_china_vs_world.csv\"`."
        ) 
    })
    test_that("confirmed_cases_china_vs_world has the correct data", {
        expect_equal(
            confirmed_cases_china_vs_world,
            soln_confirmed_cases_china_vs_world, 
            info = "The data of the `confirmed_cases_china_vs_world` data frame do not correspond with data in the CSV file: \"datasets/confirmed_cases_china_vs_world.csv\"."
        )
    })
    # NOTE: glimpse is not tested. Can this be done?
    test_that("plt_cum_confirmed_cases_china_vs_world is not NULL", {
        expect_false(
            is.null(plt_cum_confirmed_cases_china_vs_world),
            info = "`plt_cum_confirmed_cases_china_vs_world` is NULL."
        )
    })
    test_that("plt_cum_confirmed_cases_china_vs_world is a plot", {
        expect_true(
            "ggplot" %in% class(plt_cum_confirmed_cases_china_vs_world),
            info = "`plt_cum_confirmed_cases_china_vs_world` is not a `ggplot()` object."
        )
    })
    test_that("plt_cum_confirmed_cases_china_vs_world uses the correct data", {
        expect_equal(
            plt_cum_confirmed_cases_china_vs_world$data,
            confirmed_cases_china_vs_world,
            info = "The dataset used in `plt_cum_confirmed_cases_china_vs_world` is not `confirmed_cases_china_vs_world`."
        )
    })
    layer <- plt_cum_confirmed_cases_china_vs_world$layers[[1]]
    test_that("plt_cum_confirmed_cases_china_vs_world uses uses the correct geom", {
        expect_false(
            is.null(layer),
            info = "The geom used in `plt_cum_confirmed_cases_china_vs_world` is not `geom_line()`."
        )
    })
    test_that("plt_cum_confirmed_cases_china_vs_world uses uses the correct geom", {
        expect_true(
            "GeomLine" %in% class(layer$geom),
            info = "The geom used in `plt_cum_confirmed_cases_china_vs_world` is not `geom_line()`."
        )
    })
    test_that("plt_cum_confirmed_cases_china_vs_world uses uses the correct x aesthetic", {
        expect_equal(
            quo_name(layer$mapping$x),
            "date",
            info = "The x aesthetic used in `plt_cum_confirmed_cases_china_vs_world` is not `date`."
        )
    })
    test_that("plt_cum_confirmed_cases_china_vs_world uses uses the correct y aesthetic", {
        expect_equal(
            quo_name(layer$mapping$y),
            "cum_cases",
            info = "The y aesthetic used in `plt_cum_confirmed_cases_china_vs_world` is not `cum_cases`."
        )
    })
    test_that("plt_cum_confirmed_cases_china_vs_world uses uses the correct color aesthetic", {
        expect_equal(
            quo_name(layer$mapping$colour),
            "is_china",
            info = "The color aesthetic used in `plt_cum_confirmed_cases_china_vs_world` is not `is_china`."
        )
    })
})

library(magrittr)
library(dplyr)

who_events <- tribble(
  ~ date, ~ event,
  "2020-01-30", "Global health\nemergency declared",
  "2020-03-11", "Pandemic\ndeclared",
  "2020-02-13", "China reporting\nchange"
) %>%
  mutate(date = as.Date(date))

# Using who_events, add vertical dashed lines with an xintercept at date
# and text at date, labeled by event, and at 100000 on the y-axis
plt_cum_confirmed_cases_china_vs_world +
  geom_vline(data = who_events, aes(xintercept = date), linetype = 'dashed') +
  geom_text(data = who_events, aes(x = date, y = 100000, label = event),vjust = -0.5, hjust = -0.5, size = 3, color = 'black')


run_tests({
    plot <- last_plot()
    test_that("the plot got created", {
        expect_false(
            is.null(plot),
            info = "Could not find a plot created with `ggplot()`."
        )
    })
    layer1 <- plot$layers[[2]]
    layer2 <- plot$layers[[3]]
    test_that("the plot has both geoms", {
        expect_false(
            is.null(layer1) || is.null(layer2),
            info = "Could not fin `geom_vline()` and `geom_text()` in your last plot."
        )
    })
    test_that("the plot has both geoms", {
        expect_true(
            "GeomVline" %in% class(layer1$geom) && "GeomText" %in% class(layer2$geom) ||
            "GeomText" %in% class(layer1$geom) && "GeomVline" %in% class(layer2$geom),
            info = "Could not fin `geom_vline()` and `geom_text()` in your last plot."
        )
    })
    if ("GeomVline" %in% class(layer1$geom)) {
        vline <- layer1
        text <- layer2
    } else {
        vline <- layer2
        text <- layer1
    }
    test_that("the plot uses the correct data", {
        expect_equal(
            vline$data,
            who_events,
            info = "The dataset used in the `geom_vline()` is not `who_events`."
        )
    })
    test_that("the geom uses the correct xintercept aesthetic", {
        expect_equal(
            quo_name(vline$mapping$xintercept),
            "date",
            info = "The xintercept aesthetic used in the `geom_vline()` is not `date`."
        )
    })
    test_that("the geom uses the correct lintype parameter", {
        expect_equal(
            vline$aes_params$linetype,
            "dashed",
            info = "The linetype parameter used in the `geom_vline()` is not `\"dashed\"`."
        )
    })
    test_that("the geom uses the correct data", {
        expect_equal(
            text$data,
            who_events,
            info = "The dataset used in the `geom_text()` is not `who_events`."
        )
    })
    test_that("the geom uses the correct x aesthetic", {
        expect_equal(
            quo_name(text$mapping$x),
            "date",
            info = "The x aesthetic used in the `geom_text()` is not `date`."
        )
    })
    test_that("the geom uses the correct label aesthetic", {
        expect_equal(
            quo_name(text$mapping$label),
            "event",
            info = "The label aesthetic used in the `geom_text()` is not `event`."
        )
    })
    if(!is.null(text$aes_params$y)) {
        test_that("the geom uses the correct y parameter", {
            expect_equal(
                text$aes_params$y,
                100000
            )
        })
    } else if (!is.null(quo_name(text$mapping$y))) {
        test_that("the geom uses the correct y parameter", {
            expect_equal(
                quo_name(text$mapping$y),
                '1e+05'
            )
        })
    }
})

# Filter for China, from Feb 15
china_after_feb15 <- confirmed_cases_china_vs_world %>%
  filter(is_china == "China", date >= "2020-02-15")

# Using china_after_feb15, draw a line plot cum_cases vs. date
# Add a smooth trend line using linear regression, no error bars
ggplot(china_after_feb15, aes(x = date, y = cum_cases)) +
  geom_line() +
  geom_smooth(method = "lm",formula = y ~ x, se = FALSE, color = "red")+
  ylab("Cumulative confirmed cases")


run_tests({
    test_that("the data is filtered correctly", {
        soln_china_after_feb15 <- confirmed_cases_china_vs_world %>%
          filter(is_china == "China", date >= "2020-02-15")
        expect_equivalent(
            soln_china_after_feb15,
            china_after_feb15,
            info = "`china_after_feb15` has not been filtered correctly."
        )
    })
    plot <- last_plot()
    test_that("the plot is created", {
        expect_false(
            is.null(plot),
            info = "Could not find a plot created with `ggplot()`."
        )
    })
    test_that("the plot uses the correct data", {
        expect_equal(
            plot$data,
            china_after_feb15,
            info = "The dataset used in the last plot is not `soln_china_after_feb15`."
        )
    })
    test_that("the plot uses the correct x aesthetic", {
        expect_equal(
            quo_name(plot$mapping$x),
            "date",
            info = "The x aesthetic used in the last plot is not `date`."
        )
    })
    test_that("the plot uses the correct y aesthetic", {
        expect_equal(
            quo_name(plot$mapping$y),
            "cum_cases",
            info = "The y aesthetic used in the last plot is not `cum_cases`."
        )
    })
    layer1 <- plot$layers[[1]]
    layer2 <- plot$layers[[2]]
    test_that("the plot has the correct geoms", {
        expect_false(
            is.null(layer1) || is.null(layer2),
            info = "Could not fin `geom_line()` and `geom_smooth()` in your last plot."
        )
    })
    test_that("the plot has the correct geoms", {
        expect_true(
            "GeomLine" %in% class(layer1$geom) && "GeomSmooth" %in% class(layer2$geom) ||
            "GeomSmooth" %in% class(layer1$geom) && "GeomLine" %in% class(layer2$geom),
            info = "Could not fin `geom_line()` and `geom_smooth()` in your last plot."
        )
    })
    if ("GeomLine" %in% class(layer1$geom)) {
        line <- layer1
        smooth <- layer2
    } else {
        line <- layer2
        smooth <- layer1
    }
    test_that("the geom has the correct method parameter", {
        expect_equal(
            smooth$stat_params$method,
            "lm",
            info = "The method parameter used in the `geom_smooth()` is not `\"lm\"`."

        )
    })
    test_that("the geom has the correct se parameter", {
        expect_equal(
            smooth$stat_params$se,
            FALSE,
            info = "The se parameter used in the `geom_smooth()` is not `\"FALSE\"`."
        )
    })
})

# Filter confirmed_cases_china_vs_world for not China
not_china <- confirmed_cases_china_vs_world %>%
filter (is_china != 'China')

# Using not_china, draw a line plot cum_cases vs. date
# Add a smooth trend line using linear regression, no error bars
plt_not_china_trend_lin <- ggplot(not_china, aes(x = date, y= cum_cases)) +
  geom_line() +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = "blue") +
  ylab("Cumulative confirmed cases")

# See the result
plt_not_china_trend_lin 


run_tests({
    test_that("the data is filtered correctly", {
        soln_not_china <- confirmed_cases_china_vs_world %>%
          filter(is_china == "Not China")
        expect_equal(
            soln_not_china,
            not_china,
            info = "`not_china` has not been filtered correctly."
        )
    })
    plot <- last_plot()
    test_that("the plot is created", {
        expect_false(
            is.null(plot),
            info = "Could not find a plot created with `ggplot()`."
        )
    })
    test_that("the plot uses the correct data", {
        expect_equal(
            plot$data,
            not_china,
            info = "The dataset used in the last plot is not `not_china`."
        )
    })
    test_that("the plot uses the correct x aesthetic", {
        expect_equal(
            quo_name(plot$mapping$x),
            "date",
            info = "The x aesthetic used in the last plot is not `date`."
        )
    })
    test_that("the plot uses the correct y aesthetic", {
        expect_equal(
            quo_name(plot$mapping$y),
            "cum_cases",
            info = "The y aesthetic used in the last plot is not `cum_cases`."
        )
    })
    layer1 <- plot$layers[[1]]
    layer2 <- plot$layers[[2]]
    test_that("the plot uses the correct geoms", {
        expect_false(
            is.null(layer1) || is.null(layer2),
            info = "Could not fin `geom_line()` and `geom_smooth()` in your last plot."
        )
    })
    test_that("the plot uses the correct geoms", {
        expect_true(
            "GeomLine" %in% class(layer1$geom) && "GeomSmooth" %in% class(layer2$geom) ||
            "GeomSmooth" %in% class(layer1$geom) && "GeomLine" %in% class(layer2$geom),
            info = "Could not fin `geom_line()` and `geom_smooth()` in your last plot."
        )
    })
    if ("GeomLine" %in% class(layer1$geom)) {
        line <- layer1
        smooth <- layer2
    } else {
        line <- layer2
        smooth <- layer1
    }
    test_that("the geom uses the correct method parameter", {
        expect_equal(
            smooth$stat_params$method,
            "lm",
            info = "The method parameter used in the `geom_smooth()` is not `\"lm\"`."
        )
    })
    test_that("the geom uses the correct se parameter", {
        expect_equal(
            smooth$stat_params$se,
            FALSE,
            info = "The se parameter used in the `geom_smooth()` is not `\"FALSE\"`."
        )
    })
})

# Modify the plot to use a logarithmic scale on the y-axis
plt_not_china_trend_lin + 
  scale_y_log10()

run_tests({
    plot <- last_plot()
    test_that("the plot is created", {
        expect_false(
            is.null(plot),
            info = "Could not find a plot created with `ggplot()`."
        )
    })
    scale <- plot$scales$get_scales(aes("y"))
    test_that("the plot has a scale", {
        expect_false(
            is.null(scale),
            info = "Could not find a scale in your last plot."
        )
    })
    test_that("the plot uses the correct scale", {
        expect_equal(
            scale$trans$name,
            "log-10",
            info = "Could not find a logarithmic y scale: `scale_y_log10()`."
        )
    })
})

# Run this to get the data for each country
confirmed_cases_by_country <- read_csv("datasets/confirmed_cases_by_country.csv",
                                      col_type= cols(
  country = col_character(),
  province = col_character(),
  date = col_date(format = ""),
  cases = col_double(),
  cum_cases = col_double()
))
#glimpse(confirmed_cases_by_country)

# Group by country, summarize to calculate total cases, find the top 7
top_countries_by_total_cases <- confirmed_cases_by_country %>%
  filter(!is.na(province) & country != 'China') %>%
  group_by(country) %>%
  summarize(total_cases = sum(cases, na.rm = TRUE)) %>% top_n(7, total_cases)

# See the result
top_countries_by_total_cases


run_tests({
    test_that("the data is manipulated correctly", {
        soln_top_countries_by_total_cases <- confirmed_cases_by_country %>%
          group_by(country) %>%
          summarize(total_cases = max(cum_cases)) %>%
          top_n(7, total_cases)
        expect_equivalent(
            soln_top_countries_by_total_cases,
            top_countries_by_total_cases,
            info = "`top_countries_by_total_cases` has not been filtered correctly."
        )
    })
})

# Read in the dataset from datasets/confirmed_cases_top7_outside_china.csv
confirmed_cases_top7_outside_china <- read_csv("datasets/confirmed_cases_top7_outside_china.csv",
                                               col_types = cols(
                                                 country = col_character(),
                                                 date = col_date(format = ""),
                                                 cum_cases = col_double()
                                               ))

# Glimpse at the contents of confirmed_cases_top7_outside_china
glimpse(confirmed_cases_top7_outside_china)

# Using confirmed_cases_top7_outside_china, draw a line plot of
# cum_cases vs. date, colored by country
plt <- ggplot(confirmed_cases_top7_outside_china, aes(x = date, y = cum_cases, color = country)) +
  geom_line() +
  labs(x = "Date", y = "Cumulative confirmed cases", title = "Cumulative Confirmed Cases Over Time (Top 7 Countries outside China)") +
  theme_minimal()

# Display the plot
print(plt)

#library(dplyr)
#library(ggplot2)

# Calculate daily increase in cases for each country
confirmed_cases_top7_outside_china <- confirmed_cases_top7_outside_china %>%
  arrange(country, date) %>%
  group_by(country) %>%
  mutate(daily_increase = cum_cases - lag(cum_cases, default = first(cum_cases))) %>%
  ungroup()

# Plot daily increase in cases for each country
ggplot(confirmed_cases_top7_outside_china, aes(x = date, y = daily_increase, color = country)) +
  geom_line() +
  labs(title = "Daily Increase in COVID-19 Cases Outside China",
       x = "Date",
       y = "Daily Increase in Cases",
       color = "Country") +
  theme_minimal()



