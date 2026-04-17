#!/bin/bash
# 四平台评论采集 → Obsidian
# 用法: ./collect-comments.sh <平台> <目标ID> [保存目录]

set -e

OBSIDIAN="/Users/wenqing/knowledge-base/personal/qingbao/情报收集/采集2区"
COOKIE_FILE="$OBSIDIAN/.bilibili_cookie"

# ── 颜色输出 ──────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log() { echo -e "${GREEN}[+]+${NC} $1"; }
warn() { echo -e "${YELLOW}[!] $1${NC}"; }
err() { echo -e "${RED}[✗] $1${NC}"; exit 1; }

# ── 平台处理 ──────────────────────────────────
case "$1" in
  bilibili|bv)
    BV="$2"
    [[ -z "$BV" ]] && err "用法: $0 bilibili <BV号>"
    # 自动加前缀
    [[ ! "$BV" =~ ^BV ]] && BV="BV$BV"

    DEST="$OBSIDIAN/B站/$BV.md"
    mkdir -p "$OBSIDIAN/B站"

    log "采集 B站评论: $BV"

    DATA=$(curl -s "https://api.bilibili.com/x/v2/reply?type=1&oid=$BV&pn=1&ps=20&sort=2" \
      -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
      -H "Referer: https://www.bilibili.com" \
      -H "Origin: https://www.bilibili.com")

    TOTAL=$(echo "$DATA" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('page',{}).get('count','?'))" 2>/dev/null || echo "?")
    REPLIES=$(echo "$DATA" | python3 -c "
import sys,json,datetime
d=json.load(sys.stdin)
replies=d.get('data',{}).get('replies') or []
now=datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
print(f'# {d[\"data\"][\"page\"][\"count\"]} 条评论')
print(f'> 采集时间: {now}')
print()
print(\"| 点赞 | 用户 | 评论 |\")
print(\"|------|------|------|\")
for r in replies:
    msg=r['content']['message'].replace(chr(10),' ')[:100]
    print(f\"| {r['like']:,} | {r['member']['uname']} | {msg} |\")
" 2>/dev/null)

    echo "# B站视频评论" > "$DEST"
    echo "> 来源: https://www.bilibili.com/video/$BV" >> "$DEST"
    echo "$REPLIES" >> "$DEST"
    echo "" >> "$DEST"
    echo "---" >> "$DEST"
    echo "平台: B站 | 视频: $BV | 自动采集" >> "$DEST"

    log "已保存: $DEST"
    ;;

  xiaohongshu|xhs)
    DEST_DIR="$OBSIDIAN/小红书"
    mkdir -p "$DEST_DIR"
    log "采集小红书笔记评论: $2"
    opencli xiaohongshu user "$2" --limit 20 >> "$DEST_DIR/comments_$(date +%Y%m%d).md" 2>&1 || warn "小红书采集失败，可能需要登录cookie"
    ;;

  douyin|dy)
    DEST_DIR="$OBSIDIAN/抖音"
    mkdir -p "$DEST_DIR"
    log "采集抖音作品评论: $2"
    opencli douyin videos "$2" --limit 20 >> "$DEST_DIR/comments_$(date +%Y%m%d).md" 2>&1 || warn "抖音采集失败"
    ;;

  weixin|wx|公众号)
    DEST_DIR="$OBSIDIAN/公众号"
    mkdir -p "$DEST_DIR"
    log "采集微信公众号文章: $2"
    opencli weixin download --url "$2" >> "$DEST_DIR/$(date +%Y%m%d).md" 2>&1 || warn "公众号采集失败"
    ;;

  all)
    log "全平台采集 (需要手动指定目标)"
    echo "请指定具体平台: bilibili <BV号> | xiaohongshu <笔记ID> | douyin <用户ID> | weixin <文章URL>"
    ;;

  *)
    echo "用法: $0 <平台> <目标> [保存路径]"
    echo ""
    echo "平台选项:"
    echo "  bilibili <BV号>   - B站视频高赞评论"
    echo "  xiaohongshu <ID> - 小红书笔记"
    echo "  douyin <用户ID>   - 抖音作品"
    echo "  weixin <URL>     - 微信公众号文章"
    echo "  all              - 查看所有选项"
    ;;
esac
