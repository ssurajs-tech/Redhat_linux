<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bash Test Operators</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;600;700&family=Syne:wght@400;600;700;800&display=swap');

  :root {
    --bg: #0d1117;
    --surface: #161b22;
    --border: #30363d;
    --accent: #58a6ff;
    --green: #3fb950;
    --orange: #d29922;
    --purple: #bc8cff;
    --red: #f85149;
    --text: #e6edf3;
    --muted: #8b949e;
    --code-bg: #1f2937;
  }

  * { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    background: var(--bg);
    color: var(--text);
    font-family: 'JetBrains Mono', monospace;
    line-height: 1.7;
    min-height: 100vh;
  }

  header {
    background: var(--surface);
    border-bottom: 1px solid var(--border);
    padding: 16px 32px;
    display: flex;
    align-items: center;
    gap: 16px;
    position: sticky;
    top: 0;
    z-index: 100;
  }

  .gh-logo {
    display: flex;
    align-items: center;
    gap: 10px;
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: 18px;
    color: var(--text);
  }

  .gh-logo svg { width: 32px; height: 32px; fill: var(--text); }

  .repo-path {
    color: var(--muted);
    font-size: 14px;
  }
  .repo-path span { color: var(--accent); }

  .badge {
    background: rgba(88,166,255,0.1);
    border: 1px solid rgba(88,166,255,0.3);
    color: var(--accent);
    font-size: 11px;
    padding: 2px 8px;
    border-radius: 20px;
    margin-left: auto;
  }

  main {
    max-width: 960px;
    margin: 0 auto;
    padding: 40px 24px 80px;
  }

  .page-title {
    font-family: 'Syne', sans-serif;
    font-size: 36px;
    font-weight: 800;
    background: linear-gradient(135deg, var(--accent), var(--purple));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 8px;
  }

  .subtitle {
    color: var(--muted);
    font-size: 14px;
    margin-bottom: 40px;
    border-bottom: 1px solid var(--border);
    padding-bottom: 24px;
  }

  .toc {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 20px 24px;
    margin-bottom: 40px;
  }
  .toc h3 {
    font-family: 'Syne', sans-serif;
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: var(--muted);
    margin-bottom: 12px;
  }
  .toc a {
    display: block;
    color: var(--accent);
    text-decoration: none;
    font-size: 13px;
    padding: 3px 0;
  }
  .toc a:hover { text-decoration: underline; }

  section { margin-bottom: 56px; }

  .section-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
    padding-bottom: 12px;
    border-bottom: 1px solid var(--border);
  }

  .section-icon {
    width: 36px;
    height: 36px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
  }

  .icon-num { background: rgba(63,185,80,0.15); border: 1px solid rgba(63,185,80,0.3); }
  .icon-str { background: rgba(210,153,34,0.15); border: 1px solid rgba(210,153,34,0.3); }
  .icon-file { background: rgba(188,140,255,0.15); border: 1px solid rgba(188,140,255,0.3); }

  h2 {
    font-family: 'Syne', sans-serif;
    font-size: 22px;
    font-weight: 700;
  }

  .operator-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 24px;
    background: var(--surface);
    border-radius: 8px;
    overflow: hidden;
    border: 1px solid var(--border);
  }

  .operator-table th {
    background: rgba(48,54,61,0.5);
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: var(--muted);
    padding: 10px 16px;
    text-align: left;
    border-bottom: 1px solid var(--border);
  }

  .operator-table td {
    padding: 12px 16px;
    font-size: 13px;
    border-bottom: 1px solid var(--border);
    vertical-align: top;
  }

  .operator-table tr:last-child td { border-bottom: none; }
  .operator-table tr:hover td { background: rgba(88,166,255,0.04); }

  .op {
    font-family: 'JetBrains Mono', monospace;
    font-weight: 700;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 13px;
  }

  .op-num { color: var(--green); background: rgba(63,185,80,0.1); }
  .op-str { color: var(--orange); background: rgba(210,153,34,0.1); }
  .op-file { color: var(--purple); background: rgba(188,140,255,0.1); }

  .code-block {
    background: var(--code-bg);
    border: 1px solid var(--border);
    border-radius: 8px;
    overflow: hidden;
    margin: 20px 0;
  }

  .code-header {
    background: rgba(48,54,61,0.6);
    padding: 8px 16px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 1px solid var(--border);
  }

  .code-lang {
    font-size: 12px;
    color: var(--muted);
  }

  .code-dots {
    display: flex;
    gap: 6px;
  }
  .dot { width: 10px; height: 10px; border-radius: 50%; }
  .dot-r { background: #ff5f56; }
  .dot-y { background: #ffbd2e; }
  .dot-g { background: #27c93f; }

  pre {
    padding: 20px;
    overflow-x: auto;
    font-family: 'JetBrains Mono', monospace;
    font-size: 13px;
    line-height: 1.8;
  }

  .kw { color: #ff7b72; }
  .str { color: #a5d6ff; }
  .num { color: #f2cc60; }
  .op-color { color: var(--green); font-weight: 600; }
  .op-str-color { color: var(--orange); font-weight: 600; }
  .op-file-color { color: var(--purple); font-weight: 600; }
  .cm { color: #8b949e; font-style: italic; }
  .var { color: #e6edf3; }
  .out { color: #3fb950; }

  .callout {
    background: rgba(88,166,255,0.08);
    border-left: 3px solid var(--accent);
    border-radius: 0 6px 6px 0;
    padding: 14px 18px;
    font-size: 13px;
    color: var(--muted);
    margin: 16px 0;
  }

  .callout strong { color: var(--accent); }

  .result-box {
    background: rgba(63,185,80,0.06);
    border: 1px solid rgba(63,185,80,0.2);
    border-radius: 6px;
    padding: 12px 16px;
    font-size: 13px;
    margin-top: -4px;
  }

  .result-box .label {
    color: var(--muted);
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 6px;
  }

  footer {
    text-align: center;
    padding: 32px;
    border-top: 1px solid var(--border);
    color: var(--muted);
    font-size: 12px;
  }

  footer a { color: var(--accent); text-decoration: none; }
</style>
</head>
<body>

<header>
  <div class="gh-logo">
    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
      <path d="M12 0C5.374 0 0 5.373 0 12c0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0 1 12 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z"/>
    </svg>
    bash-guide
  </div>
  <span class="repo-path">docs / <span>test-operators.md</span></span>
  <span class="badge">Shell Scripting</span>
</header>

<main>
  <div class="page-title">Bash Test Operators</div>
  <p class="subtitle">A complete reference for numeric, string, and file test operators used in conditional structures.</p>

  <div class="toc">
    <h3>📋 Contents</h3>
    <a href="#numeric">1. Numeric Operators (-eq, -ne, -gt, -lt, -ge, -le)</a>
    <a href="#string">2. String Operators (=, !=, -z, -n)</a>
    <a href="#file">3. File Operators (-f, -d, -r, -w, -x, -s)</a>
    <a href="#combined">4. Combined Example Script</a>
  </div>

  <!-- NUMERIC -->
  <section id="numeric">
    <div class="section-header">
      <div class="section-icon icon-num">🔢</div>
      <h2>Numeric Operators</h2>
    </div>

    <table class="operator-table">
      <thead>
        <tr>
          <th>Operator</th>
          <th>Meaning</th>
          <th>Example</th>
        </tr>
      </thead>
      <tbody>
        <tr><td><span class="op op-num">-eq</span></td><td>Equal to</td><td><code>[ 5 -eq 5 ]</code> → true</td></tr>
        <tr><td><span class="op op-num">-ne</span></td><td>Not equal to</td><td><code>[ 5 -ne 3 ]</code> → true</td></tr>
        <tr><td><span class="op op-num">-gt</span></td><td>Greater than</td><td><code>[ 7 -gt 4 ]</code> → true</td></tr>
        <tr><td><span class="op op-num">-lt</span></td><td>Less than</td><td><code>[ 2 -lt 9 ]</code> → true</td></tr>
        <tr><td><span class="op op-num">-ge</span></td><td>Greater than or equal</td><td><code>[ 5 -ge 5 ]</code> → true</td></tr>
        <tr><td><span class="op op-num">-le</span></td><td>Less than or equal</td><td><code>[ 3 -le 5 ]</code> → true</td></tr>
      </tbody>
    </table>

    <div class="code-block">
      <div class="code-header">
        <div class="code-dots"><div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div></div>
        <span class="code-lang">bash — numeric_operators.sh</span>
      </div>
      <pre><span class="cm">#!/bin/bash</span>
<span class="cm"># Numeric operator examples</span>

<span class="var">score</span>=85
<span class="var">passing</span>=60
<span class="var">perfect</span>=100

<span class="kw">if</span> [ <span class="var">$score</span> <span class="op-color">-ge</span> <span class="var">$passing</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"✅ You passed the exam!"</span>
<span class="kw">fi</span>

<span class="kw">if</span> [ <span class="var">$score</span> <span class="op-color">-eq</span> <span class="var">$perfect</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"🏆 Perfect score!"</span>
<span class="kw">elif</span> [ <span class="var">$score</span> <span class="op-color">-gt</span> <span class="num">80</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"🎯 Great score: $score"</span>
<span class="kw">elif</span> [ <span class="var">$score</span> <span class="op-color">-lt</span> <span class="var">$passing</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"❌ Failed. Need at least $passing"</span>
<span class="kw">fi</span>

<span class="cm"># Check if two values are NOT equal</span>
<span class="kw">if</span> [ <span class="var">$score</span> <span class="op-color">-ne</span> <span class="var">$perfect</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"Score is not perfect (off by $((perfect - score)) points)"</span>
<span class="kw">fi</span></pre>
    </div>

    <div class="result-box">
      <div class="label">Output</div>
      <span class="out">✅ You passed the exam!<br>🎯 Great score: 85<br>Score is not perfect (off by 15 points)</span>
    </div>
  </section>

  <!-- STRING -->
  <section id="string">
    <div class="section-header">
      <div class="section-icon icon-str">🔤</div>
      <h2>String Operators</h2>
    </div>

    <table class="operator-table">
      <thead>
        <tr>
          <th>Operator</th>
          <th>Meaning</th>
          <th>Example</th>
        </tr>
      </thead>
      <tbody>
        <tr><td><span class="op op-str">=</span></td><td>Strings are equal</td><td><code>[ "$a" = "$b" ]</code></td></tr>
        <tr><td><span class="op op-str">!=</span></td><td>Strings are NOT equal</td><td><code>[ "$a" != "$b" ]</code></td></tr>
        <tr><td><span class="op op-str">-z</span></td><td>String is empty (zero length)</td><td><code>[ -z "$a" ]</code></td></tr>
        <tr><td><span class="op op-str">-n</span></td><td>String is NOT empty (non-zero)</td><td><code>[ -n "$a" ]</code></td></tr>
      </tbody>
    </table>

    <div class="callout">
      <strong>💡 Tip:</strong> Always quote string variables (<code>"$var"</code>) to avoid errors when the variable is empty or contains spaces.
    </div>

    <div class="code-block">
      <div class="code-header">
        <div class="code-dots"><div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div></div>
        <span class="code-lang">bash — string_operators.sh</span>
      </div>
      <pre><span class="cm">#!/bin/bash</span>
<span class="cm"># String operator examples</span>

<span class="var">username</span>=<span class="str">"alice"</span>
<span class="var">role</span>=<span class="str">"admin"</span>
<span class="var">input</span>=<span class="str">""</span>   <span class="cm"># empty string</span>

<span class="cm"># -z: check if string is EMPTY</span>
<span class="kw">if</span> [ <span class="op-str-color">-z</span> <span class="str">"$input"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"⚠️  No input provided!"</span>
<span class="kw">fi</span>

<span class="cm"># -n: check if string is NOT empty</span>
<span class="kw">if</span> [ <span class="op-str-color">-n</span> <span class="str">"$username"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"👤 User: $username"</span>
<span class="kw">fi</span>

<span class="cm"># = : check if strings are EQUAL</span>
<span class="kw">if</span> [ <span class="str">"$role"</span> <span class="op-str-color">=</span> <span class="str">"admin"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"🔑 Admin access granted to $username"</span>
<span class="kw">fi</span>

<span class="cm"># != : check if strings are NOT EQUAL</span>
<span class="kw">if</span> [ <span class="str">"$username"</span> <span class="op-str-color">!=</span> <span class="str">"root"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"🚫 Not running as root — good practice!"</span>
<span class="kw">fi</span></pre>
    </div>

    <div class="result-box">
      <div class="label">Output</div>
      <span class="out">⚠️  No input provided!<br>👤 User: alice<br>🔑 Admin access granted to alice<br>🚫 Not running as root — good practice!</span>
    </div>
  </section>

  <!-- FILE -->
  <section id="file">
    <div class="section-header">
      <div class="section-icon icon-file">📁</div>
      <h2>File Operators</h2>
    </div>

    <table class="operator-table">
      <thead>
        <tr>
          <th>Operator</th>
          <th>Meaning</th>
          <th>Example</th>
        </tr>
      </thead>
      <tbody>
        <tr><td><span class="op op-file">-f</span></td><td>Is a regular file</td><td><code>[ -f "/etc/hosts" ]</code></td></tr>
        <tr><td><span class="op op-file">-d</span></td><td>Is a directory</td><td><code>[ -d "/tmp" ]</code></td></tr>
        <tr><td><span class="op op-file">-r</span></td><td>File is readable</td><td><code>[ -r "config.txt" ]</code></td></tr>
        <tr><td><span class="op op-file">-w</span></td><td>File is writable</td><td><code>[ -w "log.txt" ]</code></td></tr>
        <tr><td><span class="op op-file">-x</span></td><td>File is executable</td><td><code>[ -x "script.sh" ]</code></td></tr>
        <tr><td><span class="op op-file">-s</span></td><td>File exists and is NOT empty</td><td><code>[ -s "output.log" ]</code></td></tr>
      </tbody>
    </table>

    <div class="code-block">
      <div class="code-header">
        <div class="code-dots"><div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div></div>
        <span class="code-lang">bash — file_operators.sh</span>
      </div>
      <pre><span class="cm">#!/bin/bash</span>
<span class="cm"># File operator examples</span>

<span class="var">config</span>=<span class="str">"app.conf"</span>
<span class="var">logfile</span>=<span class="str">"app.log"</span>
<span class="var">script</span>=<span class="str">"deploy.sh"</span>
<span class="var">backups_dir</span>=<span class="str">"./backups"</span>

<span class="cm"># -f: is it a regular file?</span>
<span class="kw">if</span> [ <span class="op-file-color">-f</span> <span class="str">"$config"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"📄 Config file found"</span>
<span class="kw">else</span>
    <span class="kw">echo</span> <span class="str">"❌ Config missing! Aborting."</span>
    <span class="kw">exit</span> <span class="num">1</span>
<span class="kw">fi</span>

<span class="cm"># -d: is it a directory?</span>
<span class="kw">if</span> [ <span class="op-file-color">-d</span> <span class="str">"$backups_dir"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"📂 Backup directory exists"</span>
<span class="kw">else</span>
    mkdir -p <span class="str">"$backups_dir"</span>
    <span class="kw">echo</span> <span class="str">"📂 Created backup directory"</span>
<span class="kw">fi</span>

<span class="cm"># -r -w: read and write permissions</span>
<span class="kw">if</span> [ <span class="op-file-color">-r</span> <span class="str">"$config"</span> ] && [ <span class="op-file-color">-w</span> <span class="str">"$logfile"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"✅ Permissions OK: can read config, write log"</span>
<span class="kw">fi</span>

<span class="cm"># -x: is the script executable?</span>
<span class="kw">if</span> [ <span class="op-file-color">-x</span> <span class="str">"$script"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"🚀 Running deploy script..."</span>
    ./<span class="var">$script</span>
<span class="kw">else</span>
    <span class="kw">echo</span> <span class="str">"⚠️  deploy.sh not executable. Run: chmod +x $script"</span>
<span class="kw">fi</span>

<span class="cm"># -s: does the log have content?</span>
<span class="kw">if</span> [ <span class="op-file-color">-s</span> <span class="str">"$logfile"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"📝 Log file has content — checking for errors..."</span>
    grep -i <span class="str">"error"</span> <span class="str">"$logfile"</span>
<span class="kw">fi</span></pre>
    </div>
  </section>

  <!-- COMBINED -->
  <section id="combined">
    <div class="section-header">
      <div class="section-icon icon-num">⚡</div>
      <h2>Combined Example Script</h2>
    </div>

    <p style="color:var(--muted);font-size:13px;margin-bottom:16px;">A real-world script that combines all three operator types to validate a deployment environment before running.</p>

    <div class="code-block">
      <div class="code-header">
        <div class="code-dots"><div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div></div>
        <span class="code-lang">bash — preflight_check.sh</span>
      </div>
      <pre><span class="cm">#!/bin/bash</span>
<span class="cm"># preflight_check.sh — validates environment before deployment</span>

<span class="var">APP_NAME</span>=<span class="str">"myapp"</span>
<span class="var">MIN_DISK_MB</span>=<span class="num">500</span>
<span class="var">CONFIG_FILE</span>=<span class="str">"./config/app.conf"</span>
<span class="var">DEPLOY_DIR</span>=<span class="str">"./deploy"</span>
<span class="var">LOG_FILE</span>=<span class="str">"./logs/deploy.log"</span>
<span class="var">errors</span>=<span class="num">0</span>

<span class="kw">echo</span> <span class="str">"🔍 Running preflight checks for $APP_NAME..."</span>
<span class="kw">echo</span> <span class="str">"=================================="</span>

<span class="cm"># ── STRING CHECK ──────────────────────</span>
<span class="kw">if</span> [ <span class="op-str-color">-z</span> <span class="str">"$APP_NAME"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"❌ APP_NAME is not set!"</span>
    (( errors++ ))
<span class="kw">else</span>
    <span class="kw">echo</span> <span class="str">"✅ App name: $APP_NAME"</span>
<span class="kw">fi</span>

<span class="cm"># ── FILE CHECKS ───────────────────────</span>
<span class="kw">if</span> [ <span class="op-file-color">-f</span> <span class="str">"$CONFIG_FILE"</span> ] && [ <span class="op-file-color">-r</span> <span class="str">"$CONFIG_FILE"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"✅ Config file exists and is readable"</span>
<span class="kw">else</span>
    <span class="kw">echo</span> <span class="str">"❌ Config file missing or unreadable: $CONFIG_FILE"</span>
    (( errors++ ))
<span class="kw">fi</span>

<span class="kw">if</span> [ <span class="op-file-color">-d</span> <span class="str">"$DEPLOY_DIR"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"✅ Deploy directory exists"</span>
<span class="kw">else</span>
    <span class="kw">echo</span> <span class="str">"⚠️  Deploy dir missing — creating it..."</span>
    mkdir -p <span class="str">"$DEPLOY_DIR"</span>
<span class="kw">fi</span>

<span class="kw">if</span> [ <span class="op-file-color">-s</span> <span class="str">"$LOG_FILE"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"📋 Previous log found — archiving..."</span>
    mv <span class="str">"$LOG_FILE"</span> <span class="str">"$LOG_FILE.bak"</span>
<span class="kw">fi</span>

<span class="cm"># ── NUMERIC CHECK ─────────────────────</span>
<span class="var">free_mb</span>=$(df -m . | awk <span class="str">'NR==2{print $4}'</span>)
<span class="kw">if</span> [ <span class="str">"$free_mb"</span> <span class="op-color">-ge</span> <span class="str">"$MIN_DISK_MB"</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"✅ Disk space OK: ${free_mb}MB free"</span>
<span class="kw">else</span>
    <span class="kw">echo</span> <span class="str">"❌ Low disk! Need ${MIN_DISK_MB}MB, have ${free_mb}MB"</span>
    (( errors++ ))
<span class="kw">fi</span>

<span class="cm"># ── RESULT ────────────────────────────</span>
<span class="kw">echo</span> <span class="str">"=================================="</span>
<span class="kw">if</span> [ <span class="str">"$errors"</span> <span class="op-color">-eq</span> <span class="num">0</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"🚀 All checks passed! Deploying..."</span>
<span class="kw">elif</span> [ <span class="str">"$errors"</span> <span class="op-color">-gt</span> <span class="num">2</span> ]; <span class="kw">then</span>
    <span class="kw">echo</span> <span class="str">"🛑 $errors critical errors. Deployment aborted."</span>
    <span class="kw">exit</span> <span class="num">1</span>
<span class="kw">else</span>
    <span class="kw">echo</span> <span class="str">"⚠️  $errors warning(s). Proceeding with caution..."</span>
<span class="kw">fi</span></pre>
    </div>

    <div class="callout">
      <strong>📌 Key takeaway:</strong> Use <code>[ ]</code> (POSIX) or <code>[[ ]]</code> (Bash-extended) for tests. Double brackets support regex matching and are safer for string comparisons. Always quote variables to prevent word-splitting issues.
    </div>
  </section>
</main>

<footer>
  <p>bash-guide / test-operators.md &nbsp;·&nbsp; <a href="#">Shell Scripting Reference</a> &nbsp;·&nbsp; Built with ❤️ for the terminal</p>
</footer>

</body>
</html>