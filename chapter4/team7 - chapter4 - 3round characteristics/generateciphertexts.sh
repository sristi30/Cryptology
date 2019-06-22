for text in $(head -n 10000 inputtexts.txt | grep "^")
do
curl -H "Content-Type: application/json" --request POST --data '{"teamname":"team7","password":"xxxxxxxxxx", "plaintext":"'"$text"'"}' -k https://172.27.26.163:9000/des
done > ciphertexts.txt
