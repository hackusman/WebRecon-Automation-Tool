#!/bin/bash

# Define colors
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"
PURPLE="\e[35m"
CYAN="\e[36m"
MAGENTA="\e[95m"
RESET="\e[0m"

# ASCII Art Banner
display_banner() {
    clear
    echo -e "${PURPLE}"
    echo " ██╗    ██╗███████╗██████╗ ██████╗ ██████╗ ███████╗ ██████╗"
    echo " ██║    ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝"
    echo " ██║ █╗ ██║█████╗  ██████╔╝██████╔╝██████╔╝█████╗  ██║     "
    echo " ██║███╗██║██╔══╝  ██╔══██╗██╔══██╗██╔══██╗██╔══╝  ██║     "
    echo " ╚███╔███╔╝███████╗██████╔╝██║  ██║██║  ██║███████╗╚██████╗"
    echo "  ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝"
    echo -e "${CYAN}"
    echo "============================================================"
    echo "           Automated Web Reconnaissance Tool                "
    echo "                  ${MAGENTA}By hackus_man${CYAN}                         "
    echo "============================================================"
    echo -e "${RESET}"
    echo -e "${YELLOW}🌐 Web Security | 🔍 Reconnaissance | 🛡️ Pentesting${RESET}"
    echo ""
}

# Function to display status messages
status_msg() {
    local color="$1"
    local emoji="$2"
    local message="$3"
    echo -e "${color}[$(date +'%H:%M:%S')] ${emoji} ${message}${RESET}"
}

# Function to take user input
get_user_input() {
    echo -e "${CYAN}"
    echo -e "╔════════════════════════════════════════════╗"
    echo -e "║            ${YELLOW}TARGET SELECTION${CYAN}              ║"
    echo -e "╠════════════════════════════════════════════╣"
    echo -e "║ 1. Single URL                              ║"
    echo -e "║ 2. Domain (Full Recon)                     ║"
    echo -e "╚════════════════════════════════════════════╝"
    echo -e "${RESET}"
    
    read -p "➡ Select target type (1-2): " tar_ch
    read -p "🔗 Enter target to scan: " url

    if [[ "$tar_ch" -eq 1 ]]; then
        echo "$url" > Active_Subdomains.txt
        status_msg $GREEN "✔" "Single URL target set: $url"
    else
        status_msg $BLUE "🔍" "Domain target set: $url"
    fi
}

# Function to show the menu
show_menu() {
    echo -e "${CYAN}"
    echo -e "╔════════════════════════════════════════════╗"
    echo -e "║            ${YELLOW}MAIN MENU${CYAN}                     ║"
    echo -e "╠════════════════════════════════════════════╣"
    
    if [[ "$tar_ch" -eq 2 ]]; then
        echo -e "║ 1  Find Active Subdomains                ║"
    fi
    echo -e "║ 2  Find Wayback URLs                      ║"
    echo -e "║ 3  Web Crawl using Katana                 ║"
    echo -e "║ 4  Run Nuclei Scan                        ║"
    echo -e "║ 5  Run Nmap Port Scan                     ║"
    echo -e "║ 6  Run Nikto Scan                         ║"
    echo -e "║ 7  Take Screenshots                       ║"
    echo -e "║ 8  Run All Recon Tasks                    ║"
    echo -e "║ 9  Mail Domain Scanning                   ║"
    echo -e "║ 10 Exit                                   ║"
    echo -e "╚════════════════════════════════════════════╝"
    echo -e "${RESET}"
    
    read -p "📌 Enter your choice (1-10): " ch
}

# Function to find active subdomains
find_subdomains() {
    status_msg $BLUE "🔍" "Finding Active Subdomains..."
    
    # Create subdomains directory if not exists
    mkdir -p subdomains
    
    subfinder -d "$url" -all -recursive > subdomains/collect_subdomain.txt 2>/dev/null
    curl -s "https://crt.sh/?q=%25.$url" | grep -oP "([a-zA-Z0-9_-]+\.)+$url" | sort -u >> subdomains/collect_subdomain.txt
    assetfinder --subs-only "$url" >> subdomains/collect_subdomain.txt 2>/dev/null
    findomain -t "$url" -q >> subdomains/collect_subdomain.txt 2>/dev/null
    
    sort -u subdomains/collect_subdomain.txt > subdomains/subdomain.txt
    echo "$url" > Active_Subdomains.txt 2>/dev/null
    cat subdomains/subdomain.txt | httpx-toolkit -ports 80,443,8080,8000,8888 -threads 200 >> Active_Subdomains.txt 2>/dev/null
    
    status_msg $GREEN "✔" "Subdomain scan completed! Results saved in subdomains/"
}

# [Rest of your functions remain the same, just replace echo commands with status_msg]

# Main script execution
display_banner
get_user_input

while true; do
    show_menu

    # If domain is selected and Active_Subdomains.txt missing, auto-run subdomain scan
    if [[ "$tar_ch" -eq 2 && ! -f "Active_Subdomains.txt" && "$ch" -ne 1 ]]; then
        status_msg $YELLOW "⚠" "Active_Subdomains.txt not found! Running subdomain scan first..."
        find_subdomains
    fi

    case "$ch" in
        1)
            if [[ "$tar_ch" -eq 2 ]]; then
                find_subdomains
            else
                status_msg $RED "✘" "Option 1 is only for domain targets!"
            fi
            ;;
        2) find_wayback_urls ;;
        3) web_crawl ;;
        4) run_nuclei_scan ;;
        5) run_nmap_scan ;;
        6) run_nikto_scan ;;
        7) take_screenshots ;;
        8)
            if [[ "$tar_ch" -eq 2 ]]; then
                find_subdomains
            fi
            find_wayback_urls
            web_crawl
            run_nuclei_scan
            run_nmap_scan
            run_nikto_scan
            take_screenshots
            ;;
        9) scan_mail_domains ;;
        10)
            status_msg $BLUE "ℹ" "Exiting WebRecon. Thank you for using!"
            echo -e "${PURPLE}"
            echo " ██████╗  ██████╗  ██████╗ ██████╗ ██████╗ ██╗   ██╗███████╗"
            echo "██╔════╝ ██╔═══██╗██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔════╝"
            echo "██║  ███╗██║   ██║██║   ██║██║  ██║██████╔╝ ╚████╔╝ █████╗  "
            echo "██║   ██║██║   ██║██║   ██║██║  ██║██╔══██╗  ╚██╔╝  ██╔══╝  "
            echo "╚██████╔╝╚██████╔╝╚██████╔╝██████╔╝██████╔╝   ██║   ███████╗"
            echo " ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚══════╝"
            echo -e "${RESET}"
            exit 0
            ;;
        *)
            status_msg $RED "✘" "Invalid option, please try again."
            ;;
    esac
done
