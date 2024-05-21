# CVE Checker for Windows - PowerShell Script

This PowerShell script allows you to check information about given CVE IDs from two websites: [MITRE](https://cve.mitre.org/) and [Tenable](https://www.tenable.com/). The script retrieves details such as descriptions, assigning CNA, name, and product, and outputs the information into a neatly formatted HTML file.

## Prerequisites

- Windows Operating System
- PowerShell installed

## Input File

The input file should be located at "C:\CVE.txt". This file should contain a list of CVE IDs separated by commas.

### Example of "CVE.txt"

"""
CVE-2024-30050,
CVE-2024-4331,
CVE-2024-30009,
CVE-2024-30008,
CVE-2024-30007
"""

## Script Functionality

The script performs the following tasks:

1. Reads the list of CVE IDs from the input file ("C:\CVE.txt").
2. Fetches details about each CVE from the MITRE and TENABLE websites.
3. Extracts relevant information such as the description, assigning CNA, name, and product.
4. Outputs the information into an HTML file named "CVE_OUTPUT.html" in the same directory as the input file.

## Usage Instructions

1. **Prepare the Input File**: Create a text file named "CVE.txt" in the "C:\" directory. List the CVE IDs separated by commas, as shown in the example above.
2. **Run the Script**: Execute the PowerShell script. Ensure that you have the necessary permissions to run scripts on your system as this script requires Administrator permissions to run due to files being stored in "C:\"
3. **View the Output**: After the script completes execution, an HTML file named "CVE_OUTPUT.html" will be generated in the "C:\" directory. Open this file in a web browser to view the CVE details.

## Additional Notes

- Ensure you have the necessary permissions to run PowerShell scripts on your system. You might need to adjust your execution policy settings to allow script execution.
- If the script encounters any errors while fetching data from the websites, it will note the error in the output HTML file.

With this setup, you can easily fetch and compile detailed CVE information from two authoritative sources and present it in a user-friendly format.
