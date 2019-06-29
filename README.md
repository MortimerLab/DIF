# DIF
## Drosophila Interactome Finder program files

This repository contains files for the Drosophila Interactome Finder (DIF) program. DIF is designed to leverage publically available data on https://flybase.org/ to help investigate and visualize interactions among a list of *Drosophila melanogaster* candidate genes, for instance from a genome-wide association study or different gene expression study. The manuscript describing the use of this tool is currently in preparation.

The included files are:
- **DIF.app**: A version for use on MacOS
- **DIF.exe**: A Windows compatible version
- **DIF4.pl**: Perl script for the DIF.app version
- **DIF5.pl**: Perl script for the DIF.exe version
- **genetic.tsv** and **physical.tsv**: FlyBase data defining the set of genetic and physical interactions among *Drosophila* genes. These files are required for running Perl scripts but come packaged with the DIF.app and DIF.exe applications.
- **Example data** and **output** files: If you want to test DIF, you can run it with the provided example data, and compare your results with the provided output files.


### To Use DIF

**On a Mac:** Download DIF.app and the example input data (if desired). When you open DIF.app, dragging and dropping an input text file containing your gene list (or the example data) into the app window will run the software. The output files will be written into the same folder as the input file. Output files are described below.

**On Windows:** Download DIF.exe and the example input data (if desired). Open a command prompt (i.e. by entering **cmd** in the Start menu search box). Navigate to the directory containing DIF.exe and your input data and type the following command:
```
C:\Folder_containing_DIF\DIF.exe Example_data.txt
```
This will run DIF and save the output files into the current directory.

**To run DIF from the Perl script:** Download the DIF5.pl file along with the genetic and physical interaction data files and the example input data (if desired). The script will automatically call the genetic and physical interaction data files (please don't rename the files). The input data file is the only input necessary to run DIF. The output files will be saved into the current directory.

### Output files

This program returns four output files that can be found in the same directory as the input file:
- The **Direct Network** file which is suitable for use as an input for a network visualization program such as Cytoscape (https://cytoscape.org/). This network will only contain genes from your input list that directly interact.
- The **Total Network** file which is suitable for use as an input for a network visualization program such as Cytoscape (https://cytoscape.org/). This network will contain genes from your input list along with genes that interact with a shared third partner to allow you to visualize the network of direct and shared interactions.
- The **Attributes** file that will identify direct and shared interactors within the total network when visualized in Cytoscape.
- The tab-delineated **Interactors** file that separately lists the direct and shared interactions. This file can be opened in a spreadsheet program such as Excel or Numbers.
