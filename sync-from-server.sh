#!/bin/bash
# sync-from-server.sh
# 将服务器情报系统产出同步到本地 Obsidian vault
# 用法：bash sync-from-server.sh
# 建议：手动触发，或加入 crontab

set -e

SSH_KEY="$HOME/.ssh/openclaw_tunnel"
SSH_PORT="9022"
SERVER="root@66.94.112.174"
SSH_OPTS="-i $SSH_KEY -p $SSH_PORT"

VAULT="$HOME/knowledge-base/personal/qingbao/情报收集"
SERVER_BASE="/root/.openclaw"

INTEL_REPORTS="${SERVER_BASE}/workspace-media-intel/work/output/reports"
COMPETITOR="${SERVER_BASE}/workspace-media-intel/work/output/competitor-monitor"
XHS_CONTENT="${SERVER_BASE}/workspace-media-xhs/work/output/content"
MP_CONTENT="${SERVER_BASE}/workspace-media-mp/work/output/content"

log() { echo "[$(date '+%H:%M:%S')] $1"; }

# ── 创建目标目录 ───────────────────────────────────────────────────────────
mkdir -p "${VAULT}/深度报告/Reddit"
mkdir -p "${VAULT}/深度报告/Reddit拆招"
mkdir -p "${VAULT}/深度报告/竞品"
mkdir -p "${VAULT}/深度报告/竞品拆招"
mkdir -p "${VAULT}/深度报告/历史情报"
mkdir -p "${VAULT}/产出/公众号"
mkdir -p "${VAULT}/产出/小红书"

# ── 1. Reddit 深度研究报告 ─────────────────────────────────────────────────
log "同步 Reddit 深度报告..."
rsync -avz --update \
    -e "ssh $SSH_OPTS" \
    --include="*/" \
    --include="reddit-*.md" \
    --include="Reddit调研-*.md" \
    --exclude="*" \
    "${SERVER}:${INTEL_REPORTS}/" \
    "${VAULT}/深度报告/Reddit/"

# ── 2. 竞品监控报告 ────────────────────────────────────────────────────────
log "同步竞品监控报告..."
rsync -avz --update \
    -e "ssh $SSH_OPTS" \
    --include="*/" \
    --include="monitor-*.md" \
    --include="竞品*分析-*.md" \
    --exclude="*" \
    "${SERVER}:${COMPETITOR}/reports/" \
    "${VAULT}/深度报告/竞品/"

# ── 3. 竞品拆招（新 chai-zhao 目录 + 旧 analyses 根目录文件）─────────────
log "同步竞品拆招..."
# chai-zhao 目录（竞品监控跑过才会有）
if ssh $SSH_OPTS "${SERVER}" "test -d ${COMPETITOR}/analyses/chai-zhao"; then
    rsync -avz --update \
        -e "ssh $SSH_OPTS" \
        --include="*.md" \
        --exclude="*" \
        "${SERVER}:${COMPETITOR}/analyses/chai-zhao/" \
        "${VAULT}/深度报告/竞品拆招/"
else
    log "  chai-zhao 目录不存在，跳过（竞品监控尚未产出拆招）"
fi
# 旧格式（直接在 analyses/ 根目录的 .md）
rsync -avz --update \
    -e "ssh $SSH_OPTS" \
    --include="*.md" \
    --exclude="*/" \
    --exclude="*" \
    "${SERVER}:${COMPETITOR}/analyses/" \
    "${VAULT}/深度报告/竞品拆招/"

# ── 4. Reddit 拆招 ────────────────────────────────────────────────────────
log "同步 Reddit 拆招..."
rsync -avz --update \
    -e "ssh $SSH_OPTS" \
    --include="*.md" \
    --exclude="*" \
    "${SERVER}:${COMPETITOR}/analyses/reddit-chai-zhao/" \
    "${VAULT}/深度报告/Reddit拆招/"

# ── 5. 历史情报（晨报/晚报/快报，已停更）─────────────────────────────────
log "同步历史情报..."
rsync -avz --update \
    -e "ssh $SSH_OPTS" \
    --include="*/" \
    --include="intel-morning-*.md" \
    --include="intel-evening-*.md" \
    --include="intel-evening-brief-*.md" \
    --include="intel-daily-*.md" \
    --include="intel-weekly-*.md" \
    --include="*-evening-report.md" \
    --include="*-daily-intel.md" \
    --exclude="*" \
    "${SERVER}:${INTEL_REPORTS}/" \
    "${VAULT}/深度报告/历史情报/"

# ── 6 & 7. 成稿同步（每文件夹只取最新 article*.md + 图片）────────────────
GEN_SCRIPT="/tmp/gen_content_files.py"

sync_content() {
    local server_dir="$1"
    local local_dir="$2"
    local label="$3"
    log "同步${label}成稿..."
    # 在服务器上生成文件列表
    ssh $SSH_OPTS "${SERVER}" "python3 ${GEN_SCRIPT} '${server_dir}'" > /tmp/sync_files_$$.txt
    if [ -s /tmp/sync_files_$$.txt ]; then
        rsync -avz --update \
            --files-from=/tmp/sync_files_$$.txt \
            -e "ssh $SSH_OPTS" \
            "${SERVER}:${server_dir}/" \
            "${local_dir}/"
    else
        log "  无文件需要同步"
    fi
    rm -f /tmp/sync_files_$$.txt
}

sync_content "${MP_CONTENT}"  "${VAULT}/产出/公众号" "公众号"
sync_content "${XHS_CONTENT}" "${VAULT}/产出/小红书" "小红书"

log "✓ 同步完成"
