
echo "[*] Actualizando el fichero .zshrc..."
cp ~/.zshrc_hack ./
cp ~/.tmux.conf.local ./
# Comprobamos el código de salida del último comando ejecutado
if [ $? -eq 0 ]; then
   echo
   echo "Todo fue correcto."
   echo
else
    echo
    echo "Hubo errores."
    echo
fi
echo
echo "[*] Generando comandos para copiar los nuevos archivos..."
#Obtenemos los ficheros .sh definidos en el ficheros y los copiamos de ~/.lcoal/bin a la carpeta de tools
cat .zshrc_hack| grep "\.sh" | awk '{print $NF}' FS="/" | tr --d '"' | sed 's/^/cp ~\/\.local\/bin\//g' | sed 's/$/ \.\/tools/g'

echo
echo
echo "[!] Copia los comandos de cp y pegalos que el script todavia no lo hace automático!!"
