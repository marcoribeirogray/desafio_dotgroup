#!/bin/bash
# Script para adicionar, commitar e enviar alterações para a branch homologacao

# Solicita a mensagem de commit ao usuário
read -p "Digite a mensagem do commit: " commit_message

# Se a mensagem estiver vazia, aborta
if [ -z "$commit_message" ]; then
  echo "❌ Mensagem de commit não pode ser vazia."
  exit 1
fi

# Executa os passos do Git
git add .
git commit -m "$commit_message"
git push origin homologacao
