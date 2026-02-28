Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FD4344D80;
	Sat, 28 Feb 2026 18:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301674; cv=none; b=uGDHUz8qibPqO2WxFFz/u7M99HJdH8iXdWeGMcamUt4NbrLaXtNOyxBPPWX7QlWpJQca9+oag7sYg4dL3rN6CzCTUEXQFbAlhUXo0qw9DZUFI/pRKwSwnbjW4mhBghn8zfLDqGhMuG1cq0jK/LVcCvBpckVI1zpuVcmUc5/FcdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301674; c=relaxed/simple;
	bh=Gy0bbGzv2uhRHKa3qW/+9ASxYDVwNsth3g5FthU70es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/3YFwsq2wWp/JS5WWWJT28sO3xNkOQjgFmNQbNfvRKk4lOw/gcbnCRLo6L2bc6V/TyFnqSsiztv1UxYhXKXIcLMlrC3pKDzJF/TmJCbrL6Q6gTFtd/76Q7VsAEd1JHNrImYaqMmMLpAJYMvNhTdgWwNsXmTJIH9MiLAfBm6ZOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EnY5F55F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EnY5F55F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2025BC19425;
	Sat, 28 Feb 2026 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301674;
	bh=Gy0bbGzv2uhRHKa3qW/+9ASxYDVwNsth3g5FthU70es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnY5F55FM6eywVsg4q4tbcDet0uVOJZ7344Uits79IZPIuuOGTt35F184mVlyoz8y
	 XV++YxbA/bG7XNa0ONuL80DldD363C/MHoYlTEGNHw4Qw02kfmQBwpW6c1KWizdTWP
	 t6ihbePVDLa0TbAMhi2hUYGwkYQ6cgN8xm+qNnqMgA1SAOmzxnON9hax7LmW4reGV7
	 +rWoO+PeToHv7kW3TL9KjL8Ry/GZvXINAcxWQ8ww+DjAY0Rizy/BOtJGO4mftUP/0a
	 AYuauAC/+eYOfC991zpxSgm2mBHu2e8fc3l2Uj5h6QgMKom3QPD/MN51oMd6xlwEHq
	 KUFuuhzatzv3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Florent Revest <revest@chromium.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf <bpf@vger.kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/385] ftrace: Rename ftrace_regs_return_value to ftrace_regs_get_return_value
Date: Sat, 28 Feb 2026 12:54:50 -0500
Message-ID: <20260228180011.1568201-68-sashal@kernel.org>
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

[ Upstream commit 2d17932da44fdc1ba835ad05110ab996d2912dbf ]

Rename ftrace_regs_return_value to ftrace_regs_get_return_value as same as
other ftrace_regs_get/set_* APIs. arm64 and riscv are already using this
new name.

Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: bpf <bpf@vger.kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/172895573350.107311.7564634260652361511.stgit@devnote2
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: aea251799998 ("x86/fgraph,bpf: Switch kprobe_multi program stack unwind to hw_regs path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ftrace_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ftrace_regs.h b/include/linux/ftrace_regs.h
index b78a0a60515b2..be1ed0c891d07 100644
--- a/include/linux/ftrace_regs.h
+++ b/include/linux/ftrace_regs.h
@@ -22,7 +22,7 @@ struct ftrace_regs;
 	regs_get_kernel_argument(&arch_ftrace_regs(fregs)->regs, n)
 #define ftrace_regs_get_stack_pointer(fregs) \
 	kernel_stack_pointer(&arch_ftrace_regs(fregs)->regs)
-#define ftrace_regs_return_value(fregs) \
+#define ftrace_regs_get_return_value(fregs) \
 	regs_return_value(&arch_ftrace_regs(fregs)->regs)
 #define ftrace_regs_set_return_value(fregs, ret) \
 	regs_set_return_value(&arch_ftrace_regs(fregs)->regs, ret)
-- 
2.51.0

