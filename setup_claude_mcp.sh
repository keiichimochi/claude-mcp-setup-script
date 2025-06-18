#!/bin/bash

# スクリプトの目的: Claude Code 用の推奨 MCP サーバーを登録
# 対象: DesktopCommanderMCP, GitHub MCP Server, Filesystem MCP Server, Context7 MCP, Notion MCP Server

# エラーハンドリングを有効化
set -e

# 環境変数
CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json" # macOS の場合
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    CONFIG_FILE="$APPDATA\\Claude\\claude_desktop_config.json" # Windows の場合
fi
BACKUP_FILE="${CONFIG_FILE}.backup"
USERNAME=$(whoami)
DESKTOP_PATH="$HOME/Desktop"
DOWNLOADS_PATH="$HOME/Downloads"

# Windows の場合、パスをスラッシュからバックスラッシュに変換
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    DESKTOP_PATH="C:\\Users\\$USERNAME\\Desktop"
    DOWNLOADS_PATH="C:\\Users\\$USERNAME\\Downloads"
fi

# ログ出力関数
log() {
    echo "[INFO] $1"
}

# エラー出力関数
error() {
    echo "[ERROR] $1" >&2
    exit 1
}

# 依存関係のチェックとインストール
check_dependencies() {
    log "依存関係を確認しています..."

    # Node.js のチェック
    if ! command -v node &> /dev/null; then
        log "Node.js が見つかりません。インストールを試みます..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install node || error "Node.js のインストールに失敗しました。https://nodejs.org から手動でインストールしてください。"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get update && sudo apt-get install -y nodejs npm || error "Node.js のインストールに失敗しました。"
        elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
            winget install OpenJS.NodeJS || error "Node.js のインストールに失敗しました。"
        else
            error "サポートされていない OS です。Node.js を手動でインストールしてください。"
        fi
    fi
    log "Node.js がインストールされています。バージョン: $(node -v)"

    # npx のチェック
    if ! command -v npx &> /dev/null; then
        npm install -g npx || error "npx のインストールに失敗しました。"
    fi
}

# 設定ファイルのバックアップ
backup_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        log "設定ファイルをバックアップしています: $BACKUP_FILE"
        cp "$CONFIG_FILE" "$BACKUP_FILE" || error "バックアップの作成に失敗しました。"
    else
        log "設定ファイルが見つかりません。新規作成します。"
        mkdir -p "$(dirname "$CONFIG_FILE")"
        echo "{}" > "$CONFIG_FILE"
    fi
}

# MCP サーバーの登録
register_mcp_servers() {
    log "MCP サーバーを登録しています..."

    # 環境変数（必要に応じて変更）
    GITHUB_TOKEN="YOUR_GITHUB_PERSONAL_ACCESS_TOKEN" # GitHub のトークンを設定
    NOTION_TOKEN="YOUR_NOTION_INTEGRATION_TOKEN"     # Notion のトークンを設定
    BRAVE_API_KEY="YOUR_BRAVE_API_KEY"               # Context7 MCP 用（必要に応じて）

    # 設定ファイルの内容
    CONFIG_CONTENT=$(cat <<EOF
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$DESKTOP_PATH", "$DOWNLOADS_PATH"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_TOKEN"
      }
    },
    "notion": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-notion"],
      "env": {
        "NOTION_TOKEN": "$NOTION_TOKEN"
      }
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "$BRAVE_API_KEY"
      }
    },
    "desktopcommander": {
      "command": "npx",
      "args": ["-y", "desktopcommandermcp"]
    }
  }
}
EOF
)

    # 設定ファイルに書き込み
    echo "$CONFIG_CONTENT" > "$CONFIG_FILE" || error "設定ファイルの更新に失敗しました。"
    log "設定ファイルが更新されました: $CONFIG_FILE"
}

# メイン処理
main() {
    log "Claude Code 用 MCP サーバー登録スクリプトを開始します..."

    check_dependencies
    backup_config
    register_mcp_servers

    log "MCP サーバーの登録が完了しました。Claude Desktop を再起動してください。"
    log "注: GitHub と Notion のトークンは手動で設定する必要があります。"
    log " - GitHub トークン: https://github.com/settings/tokens で生成"
    log " - Notion トークン: https://www.notion.so/my-integrations で生成"
    log " - Brave API キー: https://brave.com/search/api/ で生成（Context7 MCP 用）"
}

main