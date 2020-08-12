#!/bin/bash

function muestraayuda() {
  echo -e "\e[1mNOMBRE\e[0m"
  echo -e "\t wpcli_instala - Instala o actualiza wp-cli."
  echo ""
  echo -e "\e[1mSINOPSIS\e[0m"
  echo -e "\t wpcli_instala"
  echo ""
  echo -e "\e[1mDESCRIPCIÓN\e[0m"
  echo -e "\t \e[1mwpcli_instala\e[0m Comprueba los requisitos de wp-cli y la configuración del sistema para facilitar su instalación automatizada."
  echo ""
  echo -e "\e[1mMÁS INFORMACIÓN\e[0m"
  echo -e "\t Para ver más información sobre wp-cli, visite https://wp-cli.org/es/."
  echo -e "\t Documentación más detallada (en inglés): https://developer.wordpress.org/cli/commands/."
  echo ""
}

if [[ $1 == "-h"]] || [[ $1 == "ayuda" ]]
then 
  muestraayuda
else

  if [[ $(wp --info | grep "WP-CLI") ]]
  then
    echo "wp-cli ya se encuentra instalado en este sistema."
    echo "¿Desea actualizarlo? [S/n]"
    read actualizacion
    if [[ $actualizacion == "" ]] || [[ $actualizacion == "s" ]] || [[ $actualizacion == "S" ]]
    then
      sudo wp cli update
    fi
    exit 0
  else

    versionphp=$(php -version | head -n 1 | cut -f 2 -d " ")
    numeroversion=${versionphp:0:1}
    numeroversion1=${versionphp:2:1}


    if ([[ $numeroversion =~ ^[0-9]+$ ]] && [[ $numeroversion -gt 5 ]]) || ([[ $numeroversion =~ ^[0-9]+$ ]] && [[ $numeroversion -eq 5 ]] && [[ $numeroversion1 -ge 6 ]])
    then

      if [ $(which curl) ]
      then
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
      else
        wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
      fi

      if [[ $(php wp-cli.phar --info | grep "WP-CLI") ]]
      then
        versionwpcliphar=$(php wp-cli.phar --version | cut -f 2 -d " ")
        echo "El fichero wp-cli.phar se ha descargado con éxito en su versión "$versionwpcliphar
        exit 0
      else
        echo "El fichero wp-cli.phar no se ha podido descargar. Por favor, revise su conexión o pruebe a descargar manualmente el fichero desde:"
        echo -e "\t https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"
        exit -1
      fi

      
      chmod +x wp-cli.phar
      sudo mv wp-cli.phar /usr/local/bin/wp

      if [[ $(wp --info | grep "WP-CLI") ]]
      then
        versionwpcli=$(wp --version | cut -f 2 -d " ")
        echo "wp-cli instalado con éxito en su versión "$versionwpcli
        exit 0
      else
        echo "Algo ha fallado en la instalación. Por favor, revise el proceso."
        exit -1
      fi
    else
      echo "Necesita una versión igual o superior a PHP 5.6 para poder ejecutar wp-cli."
      echo "Por favor, instale o actualice PHP antes de instalar wp-cli."
      exit -1
    fi
  fi
fi
