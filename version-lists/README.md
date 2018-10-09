# version-lists
This directory contains copies of the package lists for each release of Project Trident. Each "*.list" file is just a plaintext file which contains an alphabetically ordered list of package names and corresponding version.

## generatediff.sh
This is a script that will let you generate a human-readable summary of the changes between two versions.

### Usage
`generatediff.sh [oldversion.list] [newversion.list] [outputfile]`

The output file will contains sections of summaries for packages which are new, removed, and updated between releases (with version info as appropriate).
It also creates a small summary section at the top with top-level numerical statistics.
