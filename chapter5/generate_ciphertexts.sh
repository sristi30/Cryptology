for text in $(cat < inputtexts.txt)
do
curl -H "Content-Type: application/json" --request POST --data '{"teamname":"team7","password":"msdf5vxgoe", "plaintext":"'"$text"'"}' -k https://172.27.26.163:9000/eaeae
done > ciphertexts.txt

