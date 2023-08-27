
$private:rootCALocation = terraform -chdir="$PSScriptRoot" output -raw "root_ca_file_path"
Import-Certificate -FilePath $private:rootCALocation -CertStoreLocation "Cert:\LocalMachine\Root"