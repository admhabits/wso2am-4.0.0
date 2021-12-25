declare passwd="pass"
declare port="8181"
declare cert="true"
read -p "Go to https://github.com/cdr/code-server/releases and copy the name of the version (ex.1.9xx-vscx.xx.x): " link
read -p "Specify password for login page (pass):" passwd
if [ "$passwd" == "" ]
then
	passwd="pass"
fi
echo "Password set to: $passwd"
read -p "Specify port(80):" port
if [ "$port" == "" ]
then
	port="80"
fi
echo "Port set to: $port"
read -p "Do you want to create a certificate using openssl?(Y/n) " yn
if [[ $yn =~ ^[Yy]$ ]]
then
        cert="true" 
else
	cert="false"
fi
# sudo apt-get update && sudo apt-get upgrade
# sudo apt-get install openssl wget -y

mkdir "$HOME"/code-server
mkdir "$HOME"/code-server/certs
mkdir "$HOME"/Projects
wget -qO- "https://github.com/cdr/code-server/releases/download/$link/code-server$link-linux-x64.tar.gz" | tar xvz -C ~/code-server
if [ "$cert" == "true" ]
then
	mkdir ~/code-server/certs
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/code-server/certs/key.key -out ~/code-server/certs/cert.crt
	echo "PASSWORD=$passwd $HOME/code-server/code-server Projects -p $port --allow-http --disable-telemetry --cert=$HOME/code-server/certs/cert.crt --cert-key=$HOME/code-server/certs/key.key" >> ~/code-server/run.sh
else
	echo "PASSWORD=$passwd $HOME/code-server/code-server Projects -p $port --allow-http --disable-telemetry " >> ~/code-server/run.sh
fi
mv "$HOME"/code-server/code-server"$link"-linux-x64/code-server "$HOME"/code-server/code-server
rm "$HOME"/code-server/code-server"$link"-linux-x64 -r
chmod +x "$HOME"/code-server/run.sh
export PASSWORD="$passwd"
ln "$HOME"/code-server/run.sh /bin/code-server
echo "Installed successfully, use command code-server to run "