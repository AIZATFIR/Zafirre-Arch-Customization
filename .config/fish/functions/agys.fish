function agys --description "Interactive session picker for Antigravity AGY CLI (CLI/IDE/Desktop)"
    set -l selected (python3 ~/.local/bin/agy-history.py | fzf --reverse --header="[Antigravity Unified History] Pilih Percakapan (CLI/IDE/Desktop):")
    if test -n "$selected"
        set -l conv_id (string match -r '\[\K[^\]]+' "$selected")
        set -l sync_out (python3 ~/.local/bin/agy-history.py --sync "$conv_id")
        set -l tag (echo "$sync_out" | cut -d'|' -f1)
        set -l target_cwd (echo "$sync_out" | cut -d'|' -f2)
        
        if test -n "$target_cwd" -a -d "$target_cwd"
            echo "--> Otomatis pindah (cd) ke folder proyek: $target_cwd"
            cd "$target_cwd"
        end

        if test "$tag" = "CLI"
            echo "--> Melanjutkan sesi CLI ID: $conv_id (Full Chat Resume)"
            agy --conversation "$conv_id"
        else
            echo "--> Membuka AGY CLI untuk Proyek $tag: $conv_id"
            agy
        end
    end
end
