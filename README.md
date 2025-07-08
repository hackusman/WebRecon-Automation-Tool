````markdown
# 🔎 WebRecon-Automation-Tool

### Description

WebRecon-Automation-Tool est un script Bash conçu pour automatiser les tâches courantes de reconnaissance offensive lors des phases de pentest ou de bug bounty. Il combine plusieurs outils puissants pour cartographier et analyser une cible (URL ou domaine) de manière rapide et efficace.


## 🧰 Fonctionnalités principales

- 🔍 Découverte de sous-domaines (`subfinder`, `assetfinder`, `findomain`, `httpx`)
- 🧭 Crawling de sites web (`katana`)
- 🌐 Récupération d'URLs historiques (`waybackurls`)
- 🚨 Scan de vulnérabilités (`nuclei`)
- 📡 Scan de ports et services (`nmap`)
- 🛡️ Scan applicatif (`nikto`)
- 📸 Capture d’écrans automatiques
- 📬 Scan des domaines de messagerie (SMTP, POP3, IMAP)
- ⚙️ Mode **full automation** : exécute toutes les étapes en une seule commande

---

## 📦 Prérequis

Avant d'exécuter le script, installe les outils suivants :

sudo apt install -y nmap nikto python3
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/OWASP/Amass/v3/...@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest


Et assure-toi d’avoir un fichier `screeenshot.py` valide dans le répertoire `/home/kali/CUBeeSEC/`.

---

## 🚀 Utilisation

1. Cloner le dépôt :


git clone https://github.com/hackusman/WebRecon-Automation-Tool.git
cd WebRecon-Automation-Tool


2. Rendre le script exécutable :

chmod +x recon.sh


3. Lancer le script :

./recon.sh

---

## ⚠️ Avertissement légal

> Ce script est destiné exclusivement à des fins éducatives et de test sur des cibles dont vous avez l’autorisation explicite. L’utilisation sur des systèmes non autorisés est illégale et répréhensible.
