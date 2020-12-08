# `startR` package for workflow management and standardization

## Installation

```
# install.packages("remotes")                   # Run if required
remotes::install_github("emlab-ucsb/startR")    # Install from GitHub repo
```

## Usage

### `create_*` family

This family of functions is here to `create` a bunch of things that we always need, like standard directories (folders), repository structure, and data paths. The family contains the following:

- `create_emlab_dirs` Given a project code name, it goes into the emLab Google Filestream and creates a folder for the project, along with subfolders for raw, processed, and output data
- `create_local_dirs` Creates local direcotires withing your RStudio project and associated git repo. It creates folders for scripts, results (tables and figures).
- `create_readme` Once all files and folers are in place, it inspects the repository strucutre to generate a map (se bottom of README)
- `create_setup_script` Creates a standardized setup script, which will be automatically run every time you open the RStudio project (or restart R session). It contains default filepaths, which will be created as environmental variables in your environment.
- `create_all` wrapper around all of the above.
- `create_metadata` Generates a metadata file that matches the emLab SOP and asks you a series of questions to fill in (currently only works for .csv and .xlsx)


### `ggplot`-related things

There are two standard themes: `ggtheme_plot` and `ggtheme_map`. And a `lazzy_ggsave` function, which will export your plots as both pdf and tiff, directly into the `results/img` flder created by `create_local_dirs`.

### `normalize_*` family

Adapting from GFW's python script used to normalize shipnames and callsign, this is a non-vectorized R implementation of the same process.

```
normalize_shipname("海达705")
"HAIDA705"
```
