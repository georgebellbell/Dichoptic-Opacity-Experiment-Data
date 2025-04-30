This repository contains the data associated with the paper "Dichoptic Opacity: Managing Occlusion in Stereoscopic Displays via
Dichoptic Presentation".

## Data
`RawData` contains JSON files corresponding to the individiual responses recorded during the experiment.

`ProcessedData.xlsx` is all data from `RawData` compiled into an excel format using Excel's query functionality.

`ProcessedData.csv` is the same as `ProcessedData.xlsx` but in .CSV format for accessibility.

### JSON Metadata
Data collected is split into three sections, based on task being completed.

- `dichopticOpacityActive` is a logical variable referring to whether or not the opacity of an occluder differs between left and right eye.
- `leftEyeOccluderTransparency` is a numerical float variable for the opacity of the occluder presented to the left eye.
- `rightEyeOccluderTransparency` is a numerical float variable for the opacity of the occluder presented to the right eye.
- `occluderTransparency` is a numerical float variable for the opacity of the occluder presented to both eyes, with no deviations.
- `preferredDichopticTechnique`is a logical variable for if the participant expressed a preference for dichoptic opacity over traditional opacity.

## Analysis
The analysis carried out on the experiment results, and subsequently discussed in the paper, are also included.

For a direct analysis: `/Code/Analysis/scripts/Analysis.R` .
For a documented walthrough: `/Code/Analysis/scripts/Documented Analysis.Rmd`.