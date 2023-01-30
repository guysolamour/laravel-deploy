#!/bin/bash
#------------------------------------------------------------------------------------------------------------------------------>
#---------------------------------------------------- SCAFFOLD ---------------------------------------------------------------->
#------------------------------------------------------------------------------------------------------------------------------>
#------------------------------------------------------------------------------------------------------------------------------>

# ./vendor/bin/deploy scaffold --host 161.97.172.55 --domain aswebagency.com --application aswebagency

#------------------------------------------------------------------------------------------------------------------------------>
#  VERIFIER SI LINSTALLATION NA PAS DEJA ETE FAIT VIA LE FICHIER DEPLOY.SH
#------------------------------------------------------------------------------------------------------------------------------>
if test -f "$STUB_DEPLOY_FILE_PATH"; then
    echoError "Scripts has already been generated. You can start deploying"
    exit 1
fi

#------------------------------------------------------------------------------------------------------------------------------>
#  ON RECUPERE LES OPTIONS POUR LES ASSIGNER DANS DES VARIABLES
#------------------------------------------------------------------------------------------------------------------------------>
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--host)
      OPTION_HOST="$2"
      shift # past argument
      shift # past value
      ;;
    -a|--application)
      OPTION_APPLICATION="$2"
      shift # past argument
      shift # past value
      ;;
    -d|--domain)
      OPTION_DOMAIN="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echoError "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters


#------------------------------------------------------------------------------------------------------------------------------>
#  ON VERIFIE SI L'OPTION --HOST N'EST PAS VIDE CAR OBLIGATOIRE
#------------------------------------------------------------------------------------------------------------------------------>
if [ -z "$OPTION_HOST" ]
then
    echoError "The host option can not be empty. Ex: --host=000.001.002.003"
    exit 1
fi

#------------------------------------------------------------------------------------------------------------------------------>
#  ON VERIFIE SI L'OPTION --APPLICATION N'EST PAS VIDE CAR OBLIGATOIRE
#------------------------------------------------------------------------------------------------------------------------------>
if [ -z "$OPTION_APPLICATION" ]
then
    echoError "The application option can not be empty. Ex: --application=name"
    exit 1
fi

#------------------------------------------------------------------------------------------------------------------------------>
#  ON VERIFIE SI L'OPTION --DOMAIN N'EST PAS VIDE CAR OBLIGATOIRE
#------------------------------------------------------------------------------------------------------------------------------>
if [ -z "$OPTION_DOMAIN" ]
then
    echoError "The domain option can not be empty. Ex: --domain=domain.com"
    exit 1
fi

#------------------------------------------------------------------------------------------------------------------------------>
#  RECUPERER LE MOT DE PASSE A INSERER .VAULTPASS
#------------------------------------------------------------------------------------------------------------------------------>
echo "Give vault code for decrypting password file ?"
read -sp 'Password: ' VAULT_PASSWORD


#------------------------------------------------------------------------------------------------------------------------------>
#  VERIFIER SI LA CHAINE EST VIDE ET THROW UNE ERREUR
#------------------------------------------------------------------------------------------------------------------------------>
if [ -z "$VAULT_PASSWORD" ]
then
    echoError "vault password is required"
    exit 1
fi


#------------------------------------------------------------------------------------------------------------------------------>
#  CREATE TEMPORARY DIRECTORY
#------------------------------------------------------------------------------------------------------------------------------>
echoDefault "Create temporary directory"
mkdir -p $TEMP_DIR

#------------------------------------------------------------------------------------------------------------------------------>
#  COPY DEPLOY.SH AND .VAULTPASS FILES TO CURRENT DIRECTORY
#------------------------------------------------------------------------------------------------------------------------------>
for stub in ${STUBS[@]}; do
  if [ -f "$STUBS_DIR/$stub" ];then
    echo "Copy $(echoSuccess ${stub}) to project directory"
    cp $STUBS_DIR/$stub $PROJECT_DIR/$stub
  fi
done

#------------------------------------------------------------------------------------------------------------------------------>
#  APPEND STUB FILES IN .GITIGNORE FILE
#------------------------------------------------------------------------------------------------------------------------------>
for stub in ${STUBS[@]}; do
  echo "Add $(echoSuccess $stub) to .gitignore file"
  echo $stub >> $PROJECT_DIR/.gitignore
done


#------------------------------------------------------------------------------------------------------------------------------>
#  APPEND PASSWORD TO VAULT FILE
#------------------------------------------------------------------------------------------------------------------------------>
echo $VAULT_PASSWORD > "$PROJECT_DIR/${STUBS[0]}"


#------------------------------------------------------------------------------------------------------------------------------>
#  SEARCH AND REPLACE IN DEPLOY.SH FILE
#------------------------------------------------------------------------------------------------------------------------------>
str_replace "@host" $OPTION_HOST
str_replace "@application" $OPTION_APPLICATION
str_replace "@domain" $OPTION_DOMAIN
str_replace "@whoami" "$(whoami)"
str_replace "@pwd" $PROJECT_DIR


echoMessage "Deploy scripts generated successfuly."
