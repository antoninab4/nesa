#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BLUE='\033[0;34m'
NC='\033[0m' # No color

# Icons
ICON_INSTALL="🛠️"
ICON_LOGS="📄"
ICON_STOP="⏹️"
ICON_RESTART="🔄"
ICON_REMOVE="🗑️"
ICON_NODE_ID="🆔"
ICON_EXIT="❌"
ICON_TELEGRAM="🚀"

# Telegram link
TELEGRAM_LINK="https://t.me/WingsNodeTeam"

# Draw border and display ASCII art and Telegram link

draw_top_border() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}"
}

draw_middle_border() {
    echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
}

draw_bottom_border() {
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
}

print_telegram_icon() {
    echo -e "          ${MAGENTA}${ICON_TELEGRAM} Follow us on Telegram!${NC}"
}

display_ascii() {
    echo -e "    ${RED}    W  I  N  G  S   N  O  D  E   T  E  A  M ${NC}"

}

# Display main menu
show_menu() {
    clear
    draw_top_border
    echo -e "${CYAN}║${NC}"
    display_ascii
    echo -e "${CYAN}║${NC}"
    draw_middle_border
    print_telegram_icon
    echo -e "${CYAN}║${NC}"
    echo -e "    ${BLUE}Subscribe to our channel: ${YELLOW}${TELEGRAM_LINK}${NC}"
    echo -e "${CYAN}║${NC}"
    draw_middle_border
    echo -e "    ${GREEN}Hello friend, you have entered the Nesa node${NC}"
    echo -e "                 ${GREEN}management interface.${NC}"
    echo -e "${CYAN}║${NC}"
    draw_middle_border
    echo -e "    ${YELLOW}Please choose an option:${NC}"
    echo
    
    # Centered menu options
    printf "             ${CYAN}1.${NC} ${ICON_INSTALL} Install Node Nesa\n"
    printf "             ${CYAN}2.${NC} ${ICON_LOGS} View Node Logs\n"
    printf "             ${CYAN}3.${NC} ${ICON_STOP} Stop Node\n"
    printf "             ${CYAN}4.${NC} ${ICON_RESTART} Restart Node\n"
    printf "             ${CYAN}5.${NC} ${ICON_REMOVE} Remove Node\n"
    printf "             ${CYAN}6.${NC} ${ICON_NODE_ID} View Node ID\n"
    printf "             ${CYAN}0.${NC} ${ICON_EXIT} Exit\n"
    
    draw_bottom_border
    echo -ne "${YELLOW}Enter your choice [0-6]: ${NC}"
    read choice
}

# Install node
install_node() {
    echo -e "${YELLOW}Opening port 31333...${NC}"
    sudo ufw allow 31333
    echo -e "${GREEN}Port 31333 is open.${NC}"
    REF_CODE="nesa1tdyvqx63yguzlulwtcc69mghlyqzgke6h06zyn" bash <(curl -s https://raw.githubusercontent.com/nesaorg/bootstrap/master/bootstrap.sh)
    echo -e "${GREEN}✅ Node Nesa installed successfully.${NC}"
    echo
    read -p "Press Enter to return to the main menu..."
}

# View node logs
view_logs() {
    echo -e "${GREEN}📄 Viewing Nesa node logs...${NC}"
    docker logs -f orchestrator
    echo
    read -p "Press Enter to return to the main menu..."
}

# Stop node
stop_node() {
    echo -e "${YELLOW}⏹️  Stopping Nesa node...${NC}"
    docker stop orchestrator mongodb docker-watchtower-1 ipfs_node
    echo -e "${GREEN}✅ Nesa node stopped successfully.${NC}"
    echo
    read -p "Press Enter to return to the main menu..."
}

# Restart node
restart_node() {
    echo -e "${YELLOW}🔄 Restarting Nesa node...${NC}"
    docker restart orchestrator mongodb docker-watchtower-1 ipfs_node
    echo -e "${GREEN}✅ Nesa node restarted successfully.${NC}"
    echo
    read -p "Press Enter to return to the main menu..."
}

# Remove node
remove_node() {
    echo -e "${RED}🗑️ Removing Nesa node...${NC}"
    sudo docker stop orchestrator
    sudo docker stop ipfs_node
    sudo docker rm orchestrator
    sudo docker rm ipfs_node
    sudo docker images
    sudo docker rmi ghcr.io/nesaorg/orchestrator:devnet-latest
    sudo docker rmi ipfs/kubo:latest
    sudo docker image prune -a
    echo -e "${GREEN}✅ Nesa node removed successfully.${NC}"
    echo
    read -p "Press Enter to return to the main menu..."
}

# View Node ID
view_node_id() {
    echo -e "${GREEN}🆔 Viewing Node ID...${NC}"
    cat $HOME/.nesa/identity/node_id.id
    echo
    read -p "Press Enter to return to the main menu..."
}

# Main loop
while true; do
    show_menu
    case $choice in
        1) install_node ;;
        2) view_logs ;;
        3) stop_node ;;
        4) restart_node ;;
        5) remove_node ;;
        6) view_node_id ;;
        0) echo -e "${GREEN}Exiting...${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
    esac
done
