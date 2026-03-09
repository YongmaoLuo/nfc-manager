#!/bin/bash

# HarmonyOS 适配验证脚本
# 用于检查当前迭代是否完成

TASKS_FILE=".ohos_adaptation_tasks.md"

if [ ! -f "$TASKS_FILE" ]; then
    echo "❌ 任务跟踪文件不存在: $TASKS_FILE"
    echo "创建初始任务跟踪文件..."
    exit 1
fi

# 提取未解决问题部分
UNSOVED_START=$(grep -n "### 未解决问题" "$TASKS_FILE" | cut -d: -f1)
UNSOVED_END=$(grep -n "### 本次迭代已解决" "$TASKS_FILE" | cut -d: -f1)

if [ -z "$UNSOVED_START" ] || [ -z "$UNSOVED_END" ]; then
    echo "❌ 无法解析任务文件结构"
    exit 1
fi

# 提取未解决问题内容
UNSOVED_CONTENT=$(sed -n "$((UNSOVED_START+1)),$((UNSOVED_END-1))p" "$TASKS_FILE")

# 检查是否有实际的未解决问题
PROBLEM_COUNT=$(echo "$UNSOVED_CONTENT" | grep -c "^\s*[0-9]\+\." || true)

if [ "$PROBLEM_COUNT" -eq 0 ] || [ -z "$(echo "$UNSOVED_CONTENT" | grep -v '^\s*$' | grep -v '(\*当前无问题\*)' | head -1)" ]; then
    echo "✅ 所有功能已实现，适配完成！"
    echo ""
    echo "生成最终报告..."
    exit 0
else
    echo "⚠ 发现 $PROBLEM_COUNT 个未解决问题"
    echo ""
    echo "未解决问题列表:"
    echo "$UNSOVED_CONTENT" | grep "^\s*[0-9]\+\." | head -10
    echo ""
    echo "继续下一轮迭代..."
    exit 1
fi
