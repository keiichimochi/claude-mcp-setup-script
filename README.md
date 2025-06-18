# 🚀 Claude MCP Setup Script

Claude Code用のModel Context Protocol（MCP）サーバーを自動で設定するシェルスクリプトです！

## 📋 このスクリプトが設定するMCPサーバー

- **🗂️ Filesystem MCP**: デスクトップとダウンロードフォルダへのアクセス
- **🐙 GitHub MCP**: GitHubリポジトリとの連携
- **📝 Notion MCP**: Notionワークスペースとの連携  
- **🔍 Context7 MCP**: Brave Search APIを使った検索機能
- **💻 DesktopCommander MCP**: デスクトップ操作の自動化

## 🎯 対応OS

- ✅ macOS
- ✅ Linux 
- ✅ Windows (Git Bash/WSL)

## ⚡ 使い方

### 1. スクリプトをダウンロード

```bash
# HTTPSでクローン
git clone https://github.com/keiichimochi/claude-mcp-setup-script.git
cd claude-mcp-setup-script

# または直接ダウンロード
wget https://raw.githubusercontent.com/keiichimochi/claude-mcp-setup-script/main/setup_claude_mcp.sh
```

### 2. 実行権限を付与

```bash
chmod +x setup_claude_mcp.sh
```

### 3. スクリプトを実行

```bash
./setup_claude_mcp.sh
```

## 🔑 API トークンの設定

スクリプト実行後、以下のAPIトークンを手動で設定してください：

### GitHub Personal Access Token
1. https://github.com/settings/tokens にアクセス
2. "Generate new token (classic)" をクリック
3. 必要な権限を選択（repo, user など）
4. 生成されたトークンをコピー
5. 設定ファイル内の `YOUR_GITHUB_PERSONAL_ACCESS_TOKEN` を置換

### Notion Integration Token
1. https://www.notion.so/my-integrations にアクセス
2. "New integration" をクリック
3. 統合を作成してシークレットキーを取得
4. 設定ファイル内の `YOUR_NOTION_INTEGRATION_TOKEN` を置換

### Brave API Key（オプション）
1. https://brave.com/search/api/ にアクセス
2. APIキーを取得
3. 設定ファイル内の `YOUR_BRAVE_API_KEY` を置換

## 📁 設定ファイルの場所

- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

## 🔄 Claude Desktopの再起動

設定完了後、Claude Desktopアプリケーションを再起動してください。

## 🛠️ トラブルシューティング

### Node.jsがインストールされていない場合
スクリプトが自動でインストールを試みますが、失敗した場合は以下から手動でインストールしてください：
- https://nodejs.org/

### 設定ファイルが見つからない場合
スクリプトが自動で作成しますが、Claudeアプリが正しくインストールされているか確認してください。

### バックアップからの復元
問題が発生した場合、以下のコマンドでバックアップから復元できます：

```bash
# macOS/Linux
cp "$HOME/Library/Application Support/Claude/claude_desktop_config.json.backup" "$HOME/Library/Application Support/Claude/claude_desktop_config.json"

# Windows
copy "%APPDATA%\Claude\claude_desktop_config.json.backup" "%APPDATA%\Claude\claude_desktop_config.json"
```

## 📝 ライセンス

MIT License

## 🤝 コントリビューション

Pull RequestやIssueはいつでも歓迎です！

---

**注意**: このスクリプトは既存の設定ファイルを上書きします。実行前に重要な設定がある場合は手動でバックアップを取ることをお勧めします。