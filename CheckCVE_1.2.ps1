cls; 

if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) 
{
 Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
 Exit
}

echo "Current Policy Type:"
Get-ExecutionPolicy -Verbose

echo ""
echo "Setting Policy Type To RemoteSigned"
Set-ExecutionPolicy RemoteSigned -Force -Verbose

echo ""
echo "Updated Policy Type:"
Get-ExecutionPolicy -Verbose

echo ""


# Define the input file and output file paths
$cveFilePath = "C:\CVE.txt"
$outputFilePath = "C:\CVE_OUTPUT.html"

# Read the CVE list from the file
$cveList = Get-Content -Path $cveFilePath -Raw
$cveArray = $cveList -split ",\s*"

# Initialize an array to hold the HTML rows
$htmlRows = @()

# Loop through each CVE in the list
foreach ($cve in $cveArray) {
    # Trim any leading/trailing whitespace
    $cve = $cve.Trim()

    # Construct the URL for the CVE
    $url_mitre = "https://cve.mitre.org/cgi-bin/cvename.cgi?name=$cve"
    $url_tenable = "https://www.tenable.com/cve/$cve/plugins"

    # Fetch the web page content from MITRE
    echo "Fetching data for $cve"
    try {
        $response = Invoke-WebRequest -Uri $url_mitre -UseBasicParsing
        $content = $response.Content

        # Extract the description using a regular expression
        if ($content -match '<th colspan="2">Description<\/th>\s*<\/tr>\s*<tr>\s*<td colspan="2">\s*(.*?)\s*<\/td>') {
            $description = $matches[1].Trim()
            $description = $description -replace '\s+', ' ' # Normalize whitespace
        } else {
            $description = "Description not found on MITRE"
        }

        # Extract the AssigningCNA using a regular expression
        if ($content -match '<th colspan="2">Assigning CNA<\/th>\s*<\/tr>\s*<tr>\s*<td colspan="2">\s*(.*?)\s*<\/td>') {
            $cna = $matches[1].Trim()
            $cna = $cna -replace '\s+', ' ' # Normalize whitespace
        } else {
            $cna = "Assigning CNA not found on MITRE"
        }
    } catch {
        $description = "WEB REQUEST ERROR (MITRE)"
        $cna = "WEB REQUEST ERROR (MITRE)"
    }

    # Fetch the web page content from TENABLE
    try {
        $response = Invoke-WebRequest -Uri $url_tenable -UseBasicParsing
        $content = $response.Content

        # Extract the Name and Product values using a regular expression
        if ($content -match '<tbody><tr><td><a class="no-break" href=".*?">.*?<\/a><\/td><td>(.*?)<\/td><td>(.*?)<\/td>') {
            $name = $matches[1].Trim()
            $product = $matches[2].Trim()
        } else {
            $name = "Name not found on TENABLE"
            $product = "Product not found on TENABLE"
        }
    } catch {
        $name = "WEB REQUEST ERROR (TENABLE)"
        $product = "WEB REQUEST ERROR (TENABLE)"
    }

    # Add the CVE, description, CNA, Name, and Product to the HTML rows
    $htmlRows += "<tr><td>$cve</td><td>$description</td><td>$cna</td><td>$name</td><td>$product</td></tr>"
}

# Construct the HTML content
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CVE Descriptions v1.2</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <table>
        <thead>
            <tr>
                <th>"CVE"</th>
                <th>"Description - MITRE</th>
                <th>"Manufacturer - MITRE</th>
                <th>"Name - TENABLE</th>
                <th>Product - TENABLE</th>
            </tr>
        </thead>
        <tbody>
            $($htmlRows -join "`n")
        </tbody>
    </table>
</body>
</html>
"@

# Write the HTML content to the output file
$htmlContent | Set-Content -Path $outputFilePath
