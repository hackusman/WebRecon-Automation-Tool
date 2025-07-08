#!/bin/bash

# Define colors
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"
RESET="\e[0m"

# Function to display the banner
display_banner() {
    echo -e "${GREEN}"
    echo "=========================================="
    echo "        🔎 RECON AUTOMATION SCRIPT        "
    echo "=========================================="
    echo -e "${RESET}"
}

# Function to take user input
get_user_input() {
    echo "1. URL"
    echo "2. Domain"
    read -p "Enter the choice of thing to be scanned: " tar_ch
    read -p "🔗 Enter the target to be scanned: " url

    # If URL, just write it directly to Active_Subdomains.txt
    if [[ "$tar_ch" -eq 1 ]]; then
        echo "$url" > Active_Subdomains.txt
    fi
}

# Function to show the menu
show_menu() {
    echo -e "${YELLOW}"
    if [[ "$tar_ch" -eq 2 ]]; then
        echo "1  Find Active Subdomains"
    fi
    echo "2  Find Wayback URLs"
    echo "3  Web Crawl using Katana"
    echo "4  Run Nuclei Scan"
    echo "5  Run Nmap Port Scan"
    echo "6  Run Nikto Scan"
    echo "7  Take Screenshots"
    echo "8  Run All Recon Tasks"
    echo "9  Mail Domain Scanning"
    echo "10 Exit"
    echo -e "${RESET}"
    read -p "📌 Enter your choice: " ch
}

# Function to find active subdomains
find_subdomains() {
    echo -e "${BLUE}[➕] Finding Active Subdomains...${RESET}"
    subfinder -d "$url" -all -recursive > collect_subdomain.txt 2>/dev/null
    curl -s "https://crt.sh/?q=%25.$url" | grep -oP "([a-zA-Z0-9_-]+\.)+$url" | sort -u >> collect_subdomain.txt
    assetfinder --subs-only "$url" >> collect_subdomain.txt 2>/dev/null
    findomain -t "$url" -q >> collect_subdomain.txt 2>/dev/null
    sort -u collect_subdomain.txt > subdomain.txt
    echo "$url" > Active_Subdomains.txt 2>/dev/null
    cat subdomain.txt | httpx-toolkit -ports 80,443,8080,8000,8888 -threads 200 >> Active_Subdomains.txt 2>/dev/null
    echo -e "${GREEN}[✔] Subdomain scan completed!${RESET}"
}

# Function to scan mail domains
scan_mail_domains() {
    echo -e "${BLUE}[➕] Starting mail domain scanning...${RESET}"

    # Check if subdomain.txt exists
    if [[ ! -f "subdomain.txt" ]]; then
        echo -e "${RED}[✘] subdomain.txt not found! Run subdomain scan first.${RESET}"
        return
    fi

    # Extract mail-related subdomains
    grep -iE 'mail|smtp' subdomain.txt > mail_subdomains.txt

    if [[ ! -s mail_subdomains.txt ]]; then
        echo -e "${YELLOW}[⚠] No mail-related subdomains found in subdomain.txt.${RESET}"
        return
    fi

    # Remove previous results file
    rm -f mail_open_result.txt

    # Define common mail ports to check
    mail_ports="25,110,143,465,587,993,995"

    while IFS= read -r mail_domain || [[ -n "$mail_domain" ]]; do
        echo -e "${YELLOW}[🌐] Scanning $mail_domain on mail ports (${mail_ports//,/ })...${RESET}"

        # Scan mail ports and get open ones
        open_ports=$(nmap -p $mail_ports --open -oG - "$mail_domain" 2>/dev/null | grep -oP '\d+/open' | cut -d/ -f1 | tr '\n' ',' | sed 's/,$//')

        if [[ -n "$open_ports" ]]; then
            echo -e "${GREEN}[✔] $mail_domain has mail ports open: $open_ports${RESET}"
            echo "$mail_domain: Open mail ports - $open_ports" >> mail_open_result.txt
        else
            echo -e "${RED}[✘] No mail ports open on $mail_domain.${RESET}"
        fi
    done < mail_subdomains.txt

    echo -e "${GREEN}[✔] Mail domain scanning finished. Results saved to mail_open_result.txt${RESET}"
}

# Function to find wayback URLs
find_wayback_urls() {
    echo -e "${BLUE}[➕] Finding Wayback URLs...${RESET}"
    rm -rf waybackurls 2>/dev/null && mkdir waybackurls
    while read -r subdomain; do
        sanitized_name=$(echo "$subdomain" | sed 's/[^a-zA-Z0-9.-]/_/g')
        sub_output="waybackurls/${sanitized_name}.txt"
        echo "$subdomain" | waybackurls | httpx-toolkit -ports 80,443,8080,8000,8888 -threads 200 >> "$sub_output" 2>/dev/null
    done < Active_Subdomains.txt
    echo -e "${GREEN}[✔] Wayback URL scan completed!${RESET}"
}

# Function to perform web crawling
web_crawl() {
    echo -e "${BLUE}[➕] Web Crawling using Katana...${RESET}"
    rm -rf katana 2>/dev/null && mkdir katana
    while read -r subdomain; do
        sanitized_name=$(echo "$subdomain" | sed 's/[^a-zA-Z0-9.-]/_/g')
        sub_output="katana/${sanitized_name}.txt"
        echo "$subdomain" | katana >> "$sub_output" 2>/dev/null
    done < Active_Subdomains.txt
    echo -e "${GREEN}[✔] Web Crawl scan completed!${RESET}"
}

# Function to run Nuclei scan
run_nuclei_scan() {
    echo -e "${BLUE}[➕] Running Nuclei scan...${RESET}"
    rm -rf nuclei 2>/dev/null && mkdir nuclei
    nuclei -l Active_Subdomains.txt -o nuclei/output.txt 
    echo -e "${GREEN}[✔] Nuclei scan completed!${RESET}"
}

# Function to run Nmap scan
run_nmap_scan() {
    echo -e "${BLUE}[➕] Running Nmap scan...${RESET}"
    rm -rf nmap 2>/dev/null && mkdir nmap
    sed -i 's|https\?://||g' subdomain.txt
    sort -u subdomain.txt -o subdomain.txt
    nmap -iL subdomain.txt -sT -sV -oN nmap/results.txt 2>/dev/null
    echo -e "${GREEN}[✔] Port scan completed!${RESET}"
}

# Function to run Nikto scan
run_nikto_scan() {
    echo -e "${BLUE}[➕] Running Nikto Scan...${RESET}"
    rm -rf nikto 2>/dev/null && mkdir nikto
    while read -r subdomain; do
        sanitized_name=$(echo "$subdomain" | sed 's/[^a-zA-Z0-9.-]/_/g')
        sub_output="nikto/${sanitized_name}.txt"
        nikto -h "$subdomain" -o "$sub_output" -Format txt -nointeractive 2>/dev/null
    done < Active_Subdomains.txt
    echo -e "${GREEN}[✔] Nikto scan completed! Results saved in nikto/ directory.${RESET}"
}

# Function to take screenshots
take_screenshots() {
    echo -e "${BLUE}[➕] Taking Screenshots...${RESET}"
    python3 /home/kali/CUBeeSEC/screeenshot.py waybackurls
    python3 /home/kali/CUBeeSEC/screeenshot.py katana
    echo -e "${GREEN}[✔] Screenshots saved!${RESET}"
}

# Main script execution
display_banner
get_user_input

while true; do
    show_menu

    # If domain is selected and Active_Subdomains.txt missing, auto-run subdomain scan
    if [[ "$tar_ch" -eq 2 && ! -f "Active_Subdomains.txt" && "$ch" -ne 1 ]]; then
        echo -e "${YELLOW}[⚠] Active_Subdomains.txt not found! Running subdomain scan first...${RESET}"
        find_subdomains
    fi

    case "$ch" in
        1)
            if [[ "$tar_ch" -eq 2 ]]; then
                find_subdomains
            else
                echo -e "${RED}[⚠] Option 1 is only for domain targets!${RESET}"
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
            echo -e "${BLUE}[ℹ] Exiting. Thanks for using!${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}[⚠] Invalid option, please try again.${RESET}"
            ;;
    esac
done
