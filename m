Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C045145A06;
	Thu, 13 Jun 2024 12:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281387; cv=none; b=XUX+KOVyHAcLMTrfjMCxaxkpemrXuWECsFcJTJ5dRut6JcknfFQQXoQjcGzZKF3kKMOClnNUiGMUls2lM2ITv25WexrBjn1t5ht4DJNybgliPs6d+8Ibah13uRv65QxovGecVkA1XXrjs6xXS5v9PWYKvk762MVS07Vr6GOANFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281387; c=relaxed/simple;
	bh=XEr7eEYt6RyNdndWP2OlRB+pL1s+noF1369ip09fzxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5wzTaYw4Chx1nmnCwbJIQzV/EXrFfnk8diaP23VqH4ztsNUaKYvg0GxMq1ggNy1FjeVSzkPUyP4GWnjnkLCFVeruBJsxmAu3juFvYY6dTJCqZShFxOPoFaiogdsuQpYeSns8oOiGyqlghpfDwX6j7Q4vZ4982VCHM8DcqYeFiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qmn2HM+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qmn2HM+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523A6C2BBFC;
	Thu, 13 Jun 2024 12:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281386;
	bh=XEr7eEYt6RyNdndWP2OlRB+pL1s+noF1369ip09fzxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qmn2HM+DzGu0DSoFt2K/c7BrRTJGHZIghYV422y8wLCb5JCehTE+zzhPLxfOB+FE0
	 9iG/UbWnHrpgwG0zQ3gL3Y8XCMl6N2DWpoQSRNU4yuYzmEefA6D1l1wnTYgOBmhfFl
	 QlK0Z6/nssujltvMVcbVZ+xzBmkEXuqJsJaDp2Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/317] riscv: Cleanup stacktrace
Date: Thu, 13 Jun 2024 13:34:16 +0200
Message-ID: <20240613113256.755914668@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 99c168fccbfedbc10ce1cb2dcb9eb790c478d833 ]

1. add asm/stacktrace.h for walk_stackframe and struct stackframe
2. remove unnecessary blank lines in stacktrace.c
3. fix warning "no previous prototype for ‘fill_callchain’"

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Stable-dep-of: a2a4d4a6a0bf ("riscv: stacktrace: fixed walk_stackframe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/stacktrace.h | 17 +++++++++++++++++
 arch/riscv/kernel/perf_callchain.c  | 10 ++--------
 arch/riscv/kernel/stacktrace.c      |  9 ++-------
 3 files changed, 21 insertions(+), 15 deletions(-)
 create mode 100644 arch/riscv/include/asm/stacktrace.h

diff --git a/arch/riscv/include/asm/stacktrace.h b/arch/riscv/include/asm/stacktrace.h
new file mode 100644
index 0000000000000..f09c1e31bde9c
--- /dev/null
+++ b/arch/riscv/include/asm/stacktrace.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _ASM_RISCV_STACKTRACE_H
+#define _ASM_RISCV_STACKTRACE_H
+
+#include <linux/sched.h>
+#include <asm/ptrace.h>
+
+struct stackframe {
+	unsigned long fp;
+	unsigned long ra;
+};
+
+extern void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
+				    bool (*fn)(unsigned long, void *), void *arg);
+
+#endif /* _ASM_RISCV_STACKTRACE_H */
diff --git a/arch/riscv/kernel/perf_callchain.c b/arch/riscv/kernel/perf_callchain.c
index fb02811df7143..8b4bd418b3434 100644
--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -4,11 +4,7 @@
 #include <linux/perf_event.h>
 #include <linux/uaccess.h>
 
-/* Kernel callchain */
-struct stackframe {
-	unsigned long fp;
-	unsigned long ra;
-};
+#include <asm/stacktrace.h>
 
 /*
  * Get the return address for a single stackframe and return a pointer to the
@@ -75,13 +71,11 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 		fp = user_backtrace(entry, fp, 0);
 }
 
-bool fill_callchain(unsigned long pc, void *entry)
+static bool fill_callchain(unsigned long pc, void *entry)
 {
 	return perf_callchain_store(entry, pc) == 0;
 }
 
-void notrace walk_stackframe(struct task_struct *task,
-	struct pt_regs *regs, bool (*fn)(unsigned long, void *), void *arg);
 void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 			   struct pt_regs *regs)
 {
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 9c34735c1e771..cd14309fff0d9 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -12,15 +12,12 @@
 #include <linux/stacktrace.h>
 #include <linux/ftrace.h>
 
+#include <asm/stacktrace.h>
+
 register unsigned long sp_in_global __asm__("sp");
 
 #ifdef CONFIG_FRAME_POINTER
 
-struct stackframe {
-	unsigned long fp;
-	unsigned long ra;
-};
-
 void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			     bool (*fn)(unsigned long, void *), void *arg)
 {
@@ -102,7 +99,6 @@ void notrace walk_stackframe(struct task_struct *task,
 
 #endif /* CONFIG_FRAME_POINTER */
 
-
 static bool print_trace_address(unsigned long pc, void *arg)
 {
 	const char *loglvl = arg;
@@ -136,7 +132,6 @@ unsigned long get_wchan(struct task_struct *task)
 	return pc;
 }
 
-
 #ifdef CONFIG_STACKTRACE
 
 static bool __save_trace(unsigned long pc, void *arg, bool nosched)
-- 
2.43.0



