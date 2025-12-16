Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1C033DEE1;
	Tue, 16 Dec 2025 11:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884076; cv=none; b=DQf79aL8TShcQfuzaTOYvdnPbxgsC6uKUneQ60rktQcx7YvAsLjCAaYYCp75D0OApusKK2bm5RU6z6o+UajJ9b0tLAxyyXm2xpDaShJgSBuwuxCJWVGyC0I4ag0nfTy51dUGKYI9aQdSUW1MTkUjZhUxoiJ57NSOCB2SffK4oa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884076; c=relaxed/simple;
	bh=x1hLFdk01xDRlsK4K0aMY1KOWQ6wkUjL8RJeEdGyTDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJBhrdO5xUd1yGBRtiV22dhLj1Qi8yUnq1mvbXG7BtMUUFxqhae12blIAHkpyo0URznI/qO5VghBG/DcQ1QQgAsZTOsHpmn97R/kmbHsxQZCFw/zLSA/A2rD5EwQRmvMHEFcWZmxEQ47nxhicWayIvwnzTqdCzjRTw58Zt2Bcqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Su40Wp90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Su40Wp90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70319C4CEF5;
	Tue, 16 Dec 2025 11:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884075;
	bh=x1hLFdk01xDRlsK4K0aMY1KOWQ6wkUjL8RJeEdGyTDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Su40Wp90oxNdrr5l6AFMqXeZkePU9+m7vPpPNylLIW0LhzF8FA7X9fG6xdah1jlK0
	 884IqFVqUULZmsNXYgE3zohQm3RcPCHQcaEkhuFIwUN9BIU9vq+aPKfpxyq9IH4Xni
	 bMsjqVIlSLhaTlF0XOG8KBnIqm4wBWlIT2y+/F4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <Namhyung@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/354] perf: Remove get_perf_callchain() init_nr argument
Date: Tue, 16 Dec 2025 12:10:52 +0100
Message-ID: <20251216111324.002732154@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit e649bcda25b5ae1a30a182cc450f928a0b282c93 ]

The 'init_nr' argument has double duty: it's used to initialize both the
number of contexts and the number of stack entries.  That's confusing
and the callers always pass zero anyway.  Hard code the zero.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Namhyung Kim <Namhyung@kernel.org>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20250820180428.259565081@kernel.org
Stable-dep-of: 23f852daa4ba ("bpf: Fix stackmap overflow check in __bpf_get_stackid()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h |  2 +-
 kernel/bpf/stackmap.c      |  4 ++--
 kernel/events/callchain.c  | 12 ++++++------
 kernel/events/core.c       |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ce64b4b937f06..c2bd4bc45a27b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1602,7 +1602,7 @@ DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
 extern void perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs);
 extern void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs);
 extern struct perf_callchain_entry *
-get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
+get_perf_callchain(struct pt_regs *regs, bool kernel, bool user,
 		   u32 max_stack, bool crosstask, bool add_mark);
 extern int get_callchain_buffers(int max_stack);
 extern void put_callchain_buffers(void);
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 3615c06b7dfa9..ec3a57a5fba1f 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -314,7 +314,7 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 	if (max_depth > sysctl_perf_event_max_stack)
 		max_depth = sysctl_perf_event_max_stack;
 
-	trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
+	trace = get_perf_callchain(regs, kernel, user, max_depth,
 				   false, false);
 
 	if (unlikely(!trace))
@@ -451,7 +451,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	else if (kernel && task)
 		trace = get_callchain_entry_for_task(task, max_depth);
 	else
-		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
+		trace = get_perf_callchain(regs, kernel, user, max_depth,
 					   crosstask, false);
 
 	if (unlikely(!trace) || trace->nr < skip) {
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 49d87e6db553f..677901f456a94 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -216,7 +216,7 @@ static void fixup_uretprobe_trampoline_entries(struct perf_callchain_entry *entr
 }
 
 struct perf_callchain_entry *
-get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
+get_perf_callchain(struct pt_regs *regs, bool kernel, bool user,
 		   u32 max_stack, bool crosstask, bool add_mark)
 {
 	struct perf_callchain_entry *entry;
@@ -231,11 +231,11 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 	if (!entry)
 		return NULL;
 
-	ctx.entry     = entry;
-	ctx.max_stack = max_stack;
-	ctx.nr	      = entry->nr = init_nr;
-	ctx.contexts       = 0;
-	ctx.contexts_maxed = false;
+	ctx.entry		= entry;
+	ctx.max_stack		= max_stack;
+	ctx.nr			= entry->nr = 0;
+	ctx.contexts		= 0;
+	ctx.contexts_maxed	= false;
 
 	if (kernel && !user_mode(regs)) {
 		if (add_mark)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d6a86d8e9e59b..6bc8b84f12156 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7860,7 +7860,7 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 	if (!kernel && !user)
 		return &__empty_callchain;
 
-	callchain = get_perf_callchain(regs, 0, kernel, user,
+	callchain = get_perf_callchain(regs, kernel, user,
 				       max_stack, crosstask, true);
 	return callchain ?: &__empty_callchain;
 }
-- 
2.51.0



