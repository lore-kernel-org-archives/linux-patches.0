Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214394;
	b=oIyxHpQ4Xla14AnbHDqtum8ZgB4VlJJ5ez0Oc6X4YKz2B2Z6gLIZl/b06ewB3peMj7To
	 Izz6HhOMgN9Q9YuyOtNnTvKTgXGjTRaM3axNZmd33CQqj6hO7Z618GGy8frT2e2rn9Ok/
	 YrWuk6MpoK4P5b3I/jXWZXaVqX3g2KYAuDa4p7dEyVMqXjj6x/J2SVWCYKuNXfnZ/MA9h
	 Cz7lc3xBmfiZGE6UXBJ02g1w6mSFz5TQVkQh2baM+p/CpXbUvIBxk6CZRmNf3OQY2RDnG
	 XyRW1I1p07JQIUsNYD9BvQXb4F2oMrQYrh7SHl0dtlet+eT6I8CK4HpcwzUsWZiBwWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mJzTsvlLTZodSEh3etcyJ9dtilUy092iux/LBph9oKA=;
	b=lT8Odw2HxF229qrc4X6rFvX9XDMyyBPozqAk+45eMjHDJgvGuZziJ1l5aouu6CjTeUN0
	 HZElV5QdUKKtXVAF7P50tVxz6E79Iwsl22ZjuU93d8el/U5Zll9dVj8IgGwma1Yl4Y894
	 QqJpii1xcpuiNrj1Yc393d17Z7nhIApR3/o5da+gM/U9sftWNfXNwsCpA6KX/6W36OEyw
	 pG2/d49iWswX0EbJWxJN4GyimLIAxvvt81S1RmOLnWXGKEWH2xDVzkYuMomxPxMa52PCV
	 g+OeFfbJupibOG66bFkhGxi9KnJb0PX3U1hLP7ltR09nfH83pvNCgE7xapvLbwYyxnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMow7efZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB76606A323;
	Wed, 28 Oct 2026 19:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMow7efZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9021F01825;
	Wed, 28 Oct 2026 19:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214393;
	bh=mJzTsvlLTZodSEh3etcyJ9dtilUy092iux/LBph9oKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMow7efZC5vVXjioIxmc0+r19Vj3ShMzspbd67bf/Cjmwpi7F/7g/5xRQMPcrC8ew
	 JJ66c7nDsAIAM6X3sPSS4Cw92/GElwPUuwxsZhr6Md6u5C2OYZZXmuBYOg6HeQ2o5Z
	 UqMMEFyUIANfLgmOg3owRcBf2ccwwM2mDTRhp008=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ye Weihua <yeweihua4@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0842/1887] trace/fgraph: Fix the warning caused by missing unregister notifier
Date: Wed, 28 Oct 2026 17:48:58 +0100
Message-ID: <20261028170518.587632278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Weihua <yeweihua4@huawei.com>

[ Upstream commit edede7a6dcd7435395cf757d053974aaab6ab1c2 ]

This warning was triggered during testing on v6.16:

notifier callback ftrace_suspend_notifier_call already registered
WARNING: CPU: 2 PID: 86 at kernel/notifier.c:23 notifier_chain_register+0x44/0xb0
...
Call Trace:
 <TASK>
 blocking_notifier_chain_register+0x34/0x60
 register_ftrace_graph+0x330/0x410
 ftrace_profile_write+0x1e9/0x340
 vfs_write+0xf8/0x420
 ? filp_flush+0x8a/0xa0
 ? filp_close+0x1f/0x30
 ? do_dup2+0xaf/0x160
 ksys_write+0x65/0xe0
 do_syscall_64+0xa4/0x260
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

When writing to the function_profile_enabled interface, the notifier was
not unregistered after start_graph_tracing failed, causing a warning the
next time function_profile_enabled was written.

Fixed by adding unregister_pm_notifier in the exception path.

Link: https://lore.kernel.org/20250818073332.3890629-1-yeweihua4@huawei.com
Fixes: 4a2b8dda3f870 ("tracing/function-graph-tracer: fix a regression while suspend to disk")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Ye Weihua <yeweihua4@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fgraph.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 218cd95bf8e48..383c8c7f11311 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -623,6 +623,7 @@ int register_ftrace_graph(struct fgraph_ops *gops)
 	ret = start_graph_tracing();
 	if (ret) {
 		ftrace_graph_active--;
+		unregister_pm_notifier(&ftrace_suspend_notifier);
 		goto out;
 	}
 
-- 
2.53.0



