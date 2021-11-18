# ConvertFrom-Vcf
Convert VCF Contact files from source format into Powershell objects

Examples:

# Convert a VCF file to a CSV file:
.\ConvertFrom-Vcf.ps1 -FileName X.vcf | Export-Csv .\output.csv

# View the basic contents of a VCF file:
.\ConvertFrom-Vcf.ps1 -FileName X.vcf | Out-GridView


