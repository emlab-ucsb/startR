# `startR` package for workflow management and standardization

## Installation

```
# install.packages("devtools") #Run if required
devtools::install_github("emlab-ucsb/startR")
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


## Repository structure 

```
-- data
   |__transliterations_all.RData
-- DESCRIPTION
-- inst
   |__rmarkdown
      |__templates
-- LICENSE
-- man
   |__create_all.Rd
   |__create_emlab_dirs.Rd
   |__create_local_dirs.Rd
   |__create_manuscript.Rd
   |__crete_metadata.Rd
   |__create_readme.Rd
   |__create_setup_script.Rd
   |__get_filestream_path.Rd
   |__get_table.Rd
   |__ggtheme_map.Rd
   |__ggtheme_plot.Rd
   |__lazy_ggsave.Rd
   |__normalize.Rd
   |__pipe.Rd
   |__render_doc.Rd
   |__sfc_as_cols.Rd
   |__st_rotate.Rd
   |__transliterations_all.Rd
-- NAMESPACE
-- R
   |__create_all.R
   |__create_emlab_dirs.R
   |__create_local_dirs.R
   |__create_manuscript.R
   |__create_metadata.R
   |__create_readme.R
   |__create_setup_script.R
   |__get_filestream_path.R
   |__get_table.R
   |__ggtheme_map.R
   |__ggtheme_plot.R
   |__lazy_ggsave.R
   |__normalize.R
   |__render_doc.R
   |__sfc_as_cols.R
   |__st_rotate.R
   |__transliterations_all.R
   |__utils-pipe.R
-- README.md
-- renv
-- renv.lock
   |__activate.R
   |__library
      |__R-4.0
   |__settings.dcf
   |__staging
-- startR.Rproj
-- tests
   |__testthat
   |__testthat.R
      |__test_normalize.R
```

---------
