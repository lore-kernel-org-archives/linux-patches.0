Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8F418E04F;
	Mon, 28 Oct 2024 06:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097781; cv=none; b=UyBLb0C+vuf66Gi/2l8iSopf9BcGTqH2vjV6mvYL8WwFdZeyp4TgOM22ISrZLxppRk7SMZqqDvVkRGMbGH5cIGCptvEWRDUektLCX880IiH2QLyn3JviMgH1CFftLR9GkQBOABxoIxu6FC0pZXSq8FWbilasLwosLRqf2VZRIBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097781; c=relaxed/simple;
	bh=sH8tocoYj5s+GhKgTEqkcVa3Sr202oORXNPPvs9C0y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJTXtlMXQ+fLUDFECGoavrDNh3XfIMDzRecdsfLEx5t0l35BdMHXo0guFeqwTweu3VPgU6FENVVSLPtnUOTR+BIx9Bov58S8IBiU0SoNNZ86hKAbXG/9uYyI8yrXi9LZzjFraWK1HJo9/LkA9qtejeYziGpUcTxrL+lOMP6MA+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJ6nz0yH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJ6nz0yH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DC2C4CEC3;
	Mon, 28 Oct 2024 06:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097781;
	bh=sH8tocoYj5s+GhKgTEqkcVa3Sr202oORXNPPvs9C0y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJ6nz0yHnbbok5qWQu8hxaY6K7yoPREEhjY9fdL6iPU0sYqlxMAjgpdssTCmO3Ql9
	 WAw3yii30+7ey9cLmpvLKRIqScimvkMfX8xtiuoDLD11mqe03dZQIJkRDdK+V0v6r+
	 /ePa2nx1wsQ5saeRWYk5jIFdNpNRbrAXhIwIMlFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/208] tracing/fprobe-event: cleanup: Fix a wrong comment in fprobe event
Date: Mon, 28 Oct 2024 07:24:47 +0100
Message-ID: <20241028062309.294184859@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 7e37b6bc3cc096e24709908076807bb9c3cf0d38 ]

Despite the fprobe event,  "Kretprobe" was commented. So fix it.

Link: https://lore.kernel.org/all/170952361630.229804.10832200172327797860.stgit@devnote2/

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 373b9338c972 ("uprobe: avoid out-of-bounds memory access of fetching args")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_fprobe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_fprobe.c b/kernel/trace/trace_fprobe.c
index 7d2ddbcfa377c..3ccef4d822358 100644
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -210,7 +210,7 @@ fentry_trace_func(struct trace_fprobe *tf, unsigned long entry_ip,
 }
 NOKPROBE_SYMBOL(fentry_trace_func);
 
-/* Kretprobe handler */
+/* function exit handler */
 static nokprobe_inline void
 __fexit_trace_func(struct trace_fprobe *tf, unsigned long entry_ip,
 		   unsigned long ret_ip, struct pt_regs *regs,
-- 
2.43.0



