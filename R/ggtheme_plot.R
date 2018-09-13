ggtheme_plot <- function(base_size = 9) {
  theme(axis.ticks = element_blank(),
        text       = element_text(#family = "Helvetica",
          color = "gray30", size = base_size),
        plot.title = element_text(size = rel(1.25), hjust = 0, face = "bold"),
        panel.background = element_blank(),
        strip.background = element_rect(fill = "transparent"),
        strip.text       = element_text(size = base_size, face = "italic"),
        legend.position  = "right",
        panel.border     = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(colour = "grey90", size = .25),
        panel.grid.major = element_blank(),
        legend.key       = element_rect(colour = NA, fill = NA),
        axis.line        = element_blank() # element_line(colour = "grey30", size = .5)
  )}
