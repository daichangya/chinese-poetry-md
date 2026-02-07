#!/bin/bash

# 默认值：要添加的最大文件数量
MAX_FILES_TO_ADD=${1:-100}

echo "--- Running git-add-n.sh ---"
echo "Configured to add a maximum of $MAX_FILES_TO_ADD files."

# 初始化数组
UNSTAGED_FILES=()
FILE_STATUSES=()
FILES_TO_ADD=()
CURRENT_ADD_COUNT=0

# --- 步骤 1: 获取所有未暂存的文件 ---
# git status --porcelain 输出格式示例:
# M file_modified.txt
# ?? file_untracked.txt
# A  file_added_but_not_committed.txt (这已经被暂存了，我们不想要)
# D  file_deleted.txt (已删除的文件)
# ' D' file_deleted_unstaged.txt (未暂存的删除)

echo "Executing: git status --porcelain"
# 使用 process substitution 和 while read 确保正确处理文件名，即使包含空格或特殊字符
while IFS= read -r line; do
    # 调试：显示每一行
    # echo "  RAW LINE: '$line'"

    # 检查行是否以 " M " (已修改但未暂存)、"??" (未跟踪) 或 " D " (已删除但未暂存) 开头
    if [[ "$line" =~ ^' M ' ]]; then # 注意 ' M '，确保是修改状态
        # 提取文件名 (从第4个字符开始，移除前缀)
        filename="${line:3}"
        UNSTAGED_FILES+=("$filename")
        FILE_STATUSES+=("MODIFY")
        # echo "  Found MODIFIED file: '$filename'"
    elif [[ "$line" == ??* ]]; then
        # 提取路径：去掉前 3 个字符 "?? "
        filename="${line:3}"
        UNSTAGED_FILES+=("$filename")
        FILE_STATUSES+=("ADD")
        # echo "  Found UNTRACKED file: '$filename'"
    elif [[ "$line" =~ ^' D ' ]]; then # 注意 ' D '，未暂存的删除
        # 提取文件名 (从第4个字符开始，移除前缀)
        filename="${line:3}"
        UNSTAGED_FILES+=("$filename")
        FILE_STATUSES+=("DELETE")
        # echo "  Found DELETED file: '$filename'"
    fi
done < <(git status --porcelain)

echo "Detected ${#UNSTAGED_FILES[@]} unstaged files in total."

# --- 步骤 2: 从未暂存文件中选择前 MAX_FILES_TO_ADD 个 ---
for i in "${!UNSTAGED_FILES[@]}"; do
    if (( CURRENT_ADD_COUNT < MAX_FILES_TO_ADD )); then
        # 对于删除的文件，不需要检查文件是否存在
        # 只要在 git status 中出现，就可以添加
        FILES_TO_ADD+=("$i")
        CURRENT_ADD_COUNT=$((CURRENT_ADD_COUNT + 1))
    else
        break # 达到文件数量限制
    fi
done

# --- 步骤 3: 执行 git add 命令 ---
if (( ${#FILES_TO_ADD[@]} > 0 )); then
    echo "Attempting to add $CURRENT_ADD_COUNT files to staging area:"
    # 打印即将添加的文件列表，带状态
    actual_files=()
    for idx in "${FILES_TO_ADD[@]}"; do
        status="${FILE_STATUSES[$idx]}"
        file="${UNSTAGED_FILES[$idx]}"
        echo "  $status - $file"
        actual_files+=("$file")
    done
    
    # 执行 git add 命令。使用数组来处理可能包含空格的文件名
    git add "${actual_files[@]}"
    echo "✅ Successfully added $CURRENT_ADD_COUNT files."
    
    # --- 步骤 4: 执行 git commit ---
    echo ""
    echo "Executing: git commit -m 'poems'"
    if git commit -m "poems"; then
        echo "✅ Successfully committed changes."
        
        # --- 步骤 5: 执行 git push ---
        echo ""
        echo "Executing: git push"
        if git push; then
            echo "✅ Successfully pushed to remote repository."
        else
            echo "❌ Push failed. Please check the error message above."
            echo "You may need to pull changes first or check your network connection."
        fi
    else
        echo "❌ Commit failed. Please check the error message above."
        echo "Skipping git push."
    fi
else
    echo "❌ No unstaged files found that match the criteria to add."
    echo "Please ensure you have modified existing files or created new files that are not yet staged."
    echo "Run 'git status' to see current repository state."
fi

echo "--- git-add-n.sh finished ---"