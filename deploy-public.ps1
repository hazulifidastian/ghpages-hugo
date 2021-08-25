Read-Host -Prompt ("Inisiasi Hugo website" `
	+ ". Tekan tombol apa saja untuk melanjutkan, atau ctrl+c untuk membatalkan")

# Commit and push source code
git add .
git commit -m "Updating site"
git push origin master

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# On public folder, Commit and push
git -C public add .
git -C public commit -m "Rebuilding site"
git -C public push origin master
