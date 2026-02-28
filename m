Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F29C344D80
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301665; cv=none; b=GHtxnPYPhZ5IvVVqTP6HSfzq3s28HBk0SNM9zgI8iubyOaoLRYmbKGtzUUE4TBREAUaMi6Mv7MiuvtpaQGeNul3uG3UTyYYROThkGbA9MpEMUnnLFHkORfEITsbXvtnVIaLhfYTOx8Us704Irp8uLXLcbNmheuGWAsZHwNuUjS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301665; c=relaxed/simple;
	bh=tLQxGHqscrZHktAzIm4KNQVzSM0m+LyNWst4oHn5O/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXSv+vuxWdNYfRhPcgxSmB49yCuC9N6hBqwyNX0MlXWstvwUGzoKlT60IDiRxi8zR2n1+reWdEpO1RBpH0hB81yEq44Lkz0+N2779SsTlVOCA6k7cFPCe2L4lVPrkAUHWK8omeUrlSHhyGfh0LqxHkOW0pDBfpHJQ9MqzAI6Vcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qA+OlDgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qA+OlDgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F6CC19425;
	Sat, 28 Feb 2026 18:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301665;
	bh=tLQxGHqscrZHktAzIm4KNQVzSM0m+LyNWst4oHn5O/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qA+OlDgS+B6k4bsaPobXUjlvrIjKl9Pb8GBuU8MHUx6D40Bh7IsN/ZfnN+elE9OXT
	 5ILlqtal6f6uVLUJY+Cm8K3HjlcUZT9gyggA+qnvRfj15LxXxm7SjxXJUv9O45ETRv
	 3oUVR0F1sjc5HNAKjhDwm4pEblFOO42tAf9m+w2ijpzAAQU3K7lqOSNfzSKCh+QJwE
	 Va+g1NHAcjgaLkGXybWkkZVKWjSMqg6hCbHaua0q9zdwbBXBTDrxhA35IwMNONpzii
	 7dLbcA6Z7tiABDC78v9o61yxfLZsGcdOt5YHeB99DWjj6IEW1bURcmwYE2Zfo/Qqj1
	 JP2HDbkbUy49Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/385] tracing: Add a comment about ftrace_regs definition
Date: Sat, 28 Feb 2026 12:54:46 -0500
Message-ID: <20260228180011.1568201-64-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit a370b72ec7165ebe1230d0225cbe66f6526e68ef ]

To clarify what will be expected on ftrace_regs, add a comment to the
architecture independent definition of the ftrace_regs.

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: aea251799998 ("x86/fgraph,bpf: Switch kprobe_multi program stack unwind to hw_regs path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ftrace.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index fd5e84d0ec478..42106b3de3961 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -117,6 +117,32 @@ extern int ftrace_enabled;
 
 #ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
 
+/**
+ * ftrace_regs - ftrace partial/optimal register set
+ *
+ * ftrace_regs represents a group of registers which is used at the
+ * function entry and exit. There are three types of registers.
+ *
+ * - Registers for passing the parameters to callee, including the stack
+ *   pointer. (e.g. rcx, rdx, rdi, rsi, r8, r9 and rsp on x86_64)
+ * - Registers for passing the return values to caller.
+ *   (e.g. rax and rdx on x86_64)
+ * - Registers for hooking the function call and return including the
+ *   frame pointer (the frame pointer is architecture/config dependent)
+ *   (e.g. rip, rbp and rsp for x86_64)
+ *
+ * Also, architecture dependent fields can be used for internal process.
+ * (e.g. orig_ax on x86_64)
+ *
+ * On the function entry, those registers will be restored except for
+ * the stack pointer, so that user can change the function parameters
+ * and instruction pointer (e.g. live patching.)
+ * On the function exit, only registers which is used for return values
+ * are restored.
+ *
+ * NOTE: user *must not* access regs directly, only do it via APIs, because
+ * the member can be changed according to the architecture.
+ */
 struct ftrace_regs {
 	struct pt_regs		regs;
 };
-- 
2.51.0

