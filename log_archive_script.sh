#!/bin/bash

################################################################################
# Script Name: log_archive.sh
# Description: Collects application logs and archives them with compression
# Author: System Administrator
# Version: 1.0
# Usage: ./log_archive.sh [options]
################################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default Configuration
LOG_SOURCE_DIR="/var/log"
ARCHIVE_DIR="/var/log_archives"
RETENTION_DAYS=30
DATE_FORMAT=$(date +"%Y%m%d_%H%M%S")
HOSTNAME=$(hostname -s)
COMPRESSION_TYPE="gzip"  # Options: gzip, bzip2, xz

# Application-specific log patterns (customize as needed)
declare -a LOG_PATTERNS=(
    "apache2/*.log"
    "nginx/*.log"
    "mysql/*.log"
    "postgresql/*.log"
    "application/*.log"
    "syslog"
    "messages"
    "auth.log"
)

################################################################################
# Function: print_message
# Description: Print colored messages
################################################################################
print_message() {
    local type=$1
    local message=$2
    case $type in
        "info")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "success")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        "warning")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        "error")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
    esac
}

################################################################################
# Function: check_requirements
# Description: Check if required commands are available
################################################################################
check_requirements() {
    print_message "info" "Checking system requirements..."
    
    local required_commands=("tar" "gzip" "find" "date")
    local missing_commands=()
    
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_commands+=("$cmd")
        fi
    done
    
    if [ ${#missing_commands[@]} -gt 0 ]; then
        print_message "error" "Missing required commands: ${missing_commands[*]}"
        exit 1
    fi
    
    print_message "success" "All requirements satisfied"
}

################################################################################
# Function: create_archive_directory
# Description: Create archive directory if it doesn't exist
################################################################################
create_archive_directory() {
    if [ ! -d "$ARCHIVE_DIR" ]; then
        print_message "info" "Creating archive directory: $ARCHIVE_DIR"
        mkdir -p "$ARCHIVE_DIR"
        
        if [ $? -eq 0 ]; then
            chmod 750 "$ARCHIVE_DIR"
            print_message "success" "Archive directory created"
        else
            print_message "error" "Failed to create archive directory"
            exit 1
        fi
    else
        print_message "info" "Archive directory already exists: $ARCHIVE_DIR"
    fi
}

################################################################################
# Function: collect_logs
# Description: Collect logs based on patterns
################################################################################
collect_logs() {
    local temp_dir="$ARCHIVE_DIR/temp_$DATE_FORMAT"
    mkdir -p "$temp_dir"
    
    print_message "info" "Collecting logs from $LOG_SOURCE_DIR..."
    
    local collected_count=0
    local total_size=0
    
    # Create subdirectories to maintain structure
    for pattern in "${LOG_PATTERNS[@]}"; do
        local source_path="$LOG_SOURCE_DIR/$pattern"
        
        # Find matching files
        while IFS= read -r log_file; do
            if [ -f "$log_file" ]; then
                # Get relative path
                local rel_path="${log_file#$LOG_SOURCE_DIR/}"
                local dest_dir="$temp_dir/$(dirname "$rel_path")"
                
                mkdir -p "$dest_dir"
                
                # Copy log file
                cp -p "$log_file" "$dest_dir/" 2>/dev/null
                
                if [ $? -eq 0 ]; then
                    collected_count=$((collected_count + 1))
                    local file_size=$(stat -f%z "$log_file" 2>/dev/null || stat -c%s "$log_file" 2>/dev/null)
                    total_size=$((total_size + file_size))
                    print_message "info" "  ✓ Collected: $log_file"
                fi
            fi
        done < <(find $source_path -type f 2>/dev/null)
    done
    
    print_message "success" "Collected $collected_count log files (Total size: $(numfmt --to=iec $total_size 2>/dev/null || echo "$total_size bytes"))"
    
    echo "$temp_dir"
}

################################################################################
# Function: create_archive
# Description: Create compressed archive from collected logs
################################################################################
create_archive() {
    local temp_dir=$1
    local archive_name="${HOSTNAME}_logs_${DATE_FORMAT}"
    
    print_message "info" "Creating archive: $archive_name"
    
    # Change to temp directory
    cd "$temp_dir" || exit 1
    
    case $COMPRESSION_TYPE in
        "gzip")
            local archive_file="$ARCHIVE_DIR/${archive_name}.tar.gz"
            tar -czf "$archive_file" . 2>/dev/null
            ;;
        "bzip2")
            local archive_file="$ARCHIVE_DIR/${archive_name}.tar.bz2"
            tar -cjf "$archive_file" . 2>/dev/null
            ;;
        "xz")
            local archive_file="$ARCHIVE_DIR/${archive_name}.tar.xz"
            tar -cJf "$archive_file" . 2>/dev/null
            ;;
        *)
            local archive_file="$ARCHIVE_DIR/${archive_name}.tar.gz"
            tar -czf "$archive_file" . 2>/dev/null
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        local archive_size=$(stat -f%z "$archive_file" 2>/dev/null || stat -c%s "$archive_file" 2>/dev/null)
        print_message "success" "Archive created: $archive_file"
        print_message "info" "Archive size: $(numfmt --to=iec $archive_size 2>/dev/null || echo "$archive_size bytes")"
        
        # Generate checksum
        local checksum=$(md5sum "$archive_file" 2>/dev/null || md5 "$archive_file" 2>/dev/null)
        echo "$checksum" > "${archive_file}.md5"
        print_message "success" "Checksum saved: ${archive_file}.md5"
    else
        print_message "error" "Failed to create archive"
        exit 1
    fi
    
    # Cleanup temp directory
    cd - > /dev/null
    rm -rf "$temp_dir"
    print_message "info" "Temporary files cleaned up"
}

################################################################################
# Function: cleanup_old_archives
# Description: Remove archives older than retention period
################################################################################
cleanup_old_archives() {
    print_message "info" "Cleaning up archives older than $RETENTION_DAYS days..."
    
    local deleted_count=0
    
    # Find and delete old archives
    while IFS= read -r old_archive; do
        rm -f "$old_archive" "${old_archive}.md5"
        print_message "info" "  ✗ Deleted: $old_archive"
        deleted_count=$((deleted_count + 1))
    done < <(find "$ARCHIVE_DIR" -name "*.tar.*" -type f -mtime +$RETENTION_DAYS 2>/dev/null)
    
    if [ $deleted_count -gt 0 ]; then
        print_message "success" "Deleted $deleted_count old archive(s)"
    else
        print_message "info" "No old archives to delete"
    fi
}

################################################################################
# Function: generate_report
# Description: Generate archive report
################################################################################
generate_report() {
    local report_file="$ARCHIVE_DIR/archive_report_${DATE_FORMAT}.txt"
    
    print_message "info" "Generating archive report..."
    
    cat > "$report_file" << EOF
================================================================================
Log Archive Report
================================================================================
Date: $(date)
Hostname: $HOSTNAME
Archive Directory: $ARCHIVE_DIR
Source Directory: $LOG_SOURCE_DIR
Compression Type: $COMPRESSION_TYPE
Retention Period: $RETENTION_DAYS days

================================================================================
Current Archives:
================================================================================
EOF
    
    # List all archives with details
    find "$ARCHIVE_DIR" -name "*.tar.*" -type f -exec ls -lh {} \; >> "$report_file"
    
    cat >> "$report_file" << EOF

================================================================================
Total Archive Statistics:
================================================================================
Total Archives: $(find "$ARCHIVE_DIR" -name "*.tar.*" -type f | wc -l)
Total Size: $(du -sh "$ARCHIVE_DIR" | cut -f1)

================================================================================
EOF
    
    print_message "success" "Report generated: $report_file"
}

################################################################################
# Function: usage
# Description: Display usage information
################################################################################
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    -s, --source DIR        Source directory for logs (default: /var/log)
    -d, --destination DIR   Archive destination directory (default: /var/log_archives)
    -r, --retention DAYS    Retention period in days (default: 30)
    -c, --compression TYPE  Compression type: gzip, bzip2, xz (default: gzip)
    -h, --help              Display this help message

Examples:
    $0                                          # Use default settings
    $0 -s /var/log -d /backup/logs             # Custom source and destination
    $0 -r 60 -c bzip2                          # 60 days retention with bzip2

EOF
    exit 0
}

################################################################################
# Function: parse_arguments
# Description: Parse command line arguments
################################################################################
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -s|--source)
                LOG_SOURCE_DIR="$2"
                shift 2
                ;;
            -d|--destination)
                ARCHIVE_DIR="$2"
                shift 2
                ;;
            -r|--retention)
                RETENTION_DAYS="$2"
                shift 2
                ;;
            -c|--compression)
                COMPRESSION_TYPE="$2"
                shift 2
                ;;
            -h|--help)
                usage
                ;;
            *)
                print_message "error" "Unknown option: $1"
                usage
                ;;
        esac
    done
}

################################################################################
# Main Execution
################################################################################
main() {
    echo ""
    echo "════════════════════════════════════════════════════════════════════"
    echo "           Application Log Archive Script - v1.0"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    
    # Parse command line arguments
    parse_arguments "$@"
    
    # Check if running as root (recommended for system logs)
    if [ "$EUID" -ne 0 ]; then
        print_message "warning" "Not running as root. Some logs may be inaccessible."
    fi
    
    # Execute main workflow
    check_requirements
    create_archive_directory
    
    local temp_dir=$(collect_logs)
    
    if [ -d "$temp_dir" ] && [ "$(ls -A $temp_dir)" ]; then
        create_archive "$temp_dir"
        cleanup_old_archives
        generate_report
        
        echo ""
        print_message "success" "Log archiving completed successfully!"
        echo ""
    else
        print_message "error" "No logs collected. Exiting."
        [ -d "$temp_dir" ] && rm -rf "$temp_dir"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"