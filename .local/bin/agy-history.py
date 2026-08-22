#!/usr/bin/env python3
import os
import sys
import glob
import json
import re
import datetime
import shutil

SEARCH_DIRS = [
    ("CLI", os.path.expanduser("~/.gemini/antigravity-cli/brain")),
    ("IDE", os.path.expanduser("~/.gemini/antigravity-ide/brain")),
    ("DESKTOP", os.path.expanduser("~/.gemini/antigravity/brain")),
]

CLI_BRAIN_DIR = os.path.expanduser("~/.gemini/antigravity-cli/brain")

def clean_text(text):
    if not text:
        return ""
    text = re.sub(r'<USER_REQUEST>', '', text)
    text = re.sub(r'</USER_REQUEST>', '', text)
    text = re.sub(r'<ADDITIONAL_METADATA>.*?</ADDITIONAL_METADATA>', '', text, flags=re.DOTALL)
    text = re.sub(r'<[^>]+>', '', text)
    return text.strip().replace("\n", " ")

def get_conversation_info(conv_dir):
    pattern1 = os.path.join(conv_dir, ".system_generated", "logs", "transcript_full.jsonl")
    pattern2 = os.path.join(conv_dir, ".system_generated", "logs", "transcript.jsonl")
    filepath = pattern1 if os.path.exists(pattern1) else pattern2
    
    if not os.path.exists(filepath):
        return None, None
        
    cwd = None
    first_prompt = "(Sesi Kosong)"
    
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            for line in f:
                data = json.loads(line)
                content = data.get("content", "")
                
                if first_prompt == "(Sesi Kosong)" and data.get("type") == "USER_INPUT" and content:
                    cleaned = clean_text(content)
                    if cleaned:
                        first_prompt = cleaned[:75]
                        
                if not cwd:
                    match = re.search(r"Other open documents:\s*\n-\s*(/[^\s\(\)]+)", content)
                    if match:
                        doc_path = match.group(1)
                        possible_dir = os.path.dirname(doc_path)
                        if os.path.exists(possible_dir):
                            cwd = possible_dir
                            
                    tool_calls = data.get("tool_calls", [])
                    for tc in tool_calls:
                        args = tc.get("args", {})
                        for k in ["DirectoryPath", "Cwd", "SearchPath", "TargetFile"]:
                            if k in args:
                                val = str(args[k]).strip("\"'")
                                if os.path.exists(val):
                                    cwd = val if os.path.isdir(val) else os.path.dirname(val)
                                    break
                        if cwd:
                            break
    except Exception:
        pass
        
    return first_prompt, cwd

def list_conversations():
    results = []
    for tag, base_dir in SEARCH_DIRS:
        if not os.path.exists(base_dir):
            continue
        pattern1 = os.path.join(base_dir, "*", ".system_generated", "logs", "transcript_full.jsonl")
        pattern2 = os.path.join(base_dir, "*", ".system_generated", "logs", "transcript.jsonl")
        
        log_files = glob.glob(pattern1)
        existing_ids = {f.split(os.sep)[-4] for f in log_files}
        
        for f2 in glob.glob(pattern2):
            cid = f2.split(os.sep)[-4]
            if cid not in existing_ids:
                log_files.append(f2)
                existing_ids.add(cid)
                
        for filepath in log_files:
            conv_id = filepath.split(os.sep)[-4]
            mtime = os.path.getmtime(filepath)
            dt = datetime.datetime.fromtimestamp(mtime).strftime("%Y-%m-%d %H:%M")
            conv_dir = os.path.dirname(os.path.dirname(os.path.dirname(filepath)))
            
            prompt, cwd = get_conversation_info(conv_dir)
            
            results.append({
                "source": tag,
                "id": conv_id,
                "datetime": dt,
                "mtime": mtime,
                "title": prompt or "(Sesi Kosong)",
                "cwd": cwd or ""
            })
            
    results.sort(key=lambda x: x["mtime"], reverse=True)
    return results

def sync_conversation(conv_id):
    target_cli_dir = os.path.join(CLI_BRAIN_DIR, conv_id)
    found_source = None
    found_tag = "CLI"
    
    for tag, base_dir in SEARCH_DIRS:
        src_path = os.path.join(base_dir, conv_id)
        if os.path.exists(src_path):
            found_source = src_path
            found_tag = tag
            break

    if not found_source:
        print("NO_SOURCE|")
        return
        
    if found_source != target_cli_dir:
        shutil.copytree(found_source, target_cli_dir, dirs_exist_ok=True)
        
    logs_dir = os.path.join(target_cli_dir, ".system_generated", "logs")
    transcript_full = os.path.join(logs_dir, "transcript_full.jsonl")
    transcript_compact = os.path.join(logs_dir, "transcript.jsonl")
    
    if not os.path.exists(transcript_full) and os.path.exists(transcript_compact):
        shutil.copyfile(transcript_compact, transcript_full)
        
    prompt, cwd = get_conversation_info(target_cli_dir)
    print(f"{found_tag}|{cwd or ''}")

if __name__ == "__main__":
    if len(sys.argv) > 2 and sys.argv[1] == "--sync":
        conv_id = sys.argv[2]
        sync_conversation(conv_id)
    else:
        for c in list_conversations():
            print(f"{c['datetime']} | {c['source']:<7} | [{c['id']}] | {c['title']}")
