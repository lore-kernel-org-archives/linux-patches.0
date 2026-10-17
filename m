Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA3838F950;
	Sat, 17 Oct 2026 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259439; cv=none; b=mPXx7so0jHzBKKqKZcVPfOnoxpLcwDzaXxcis3gVtrh3bim4xf8+ln+/fATWdSb0r2xr4+iytwEHe8QuJ8kV4qk/ivCBaLBdJSeAL7zU5ilk844aNMNoYCQHdY0NqveJfFNAzdFT2VaYGs7UwXRXyQPwRc5CdECcztoAhG0Mho4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259439; c=relaxed/simple;
	bh=1dB+KrQ9JIjgG4dE7MKUHmZ6EXnLWHvr43yMqwrrBuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TusWQ+xsRifbR7SsrNGYgRcQMMRvO0X1Lg5eOYZlfSVsY/XFCxsPhn/eu+Vt6++FJAyy0uguswTir/X/xa0fp/P/wLGpBmIQGK+YMM0YxacGW2aIfyOdR6G81UOBSuT3c92ja1J6ZcnS/Ub8LfzVal8vowRxWTtSJd0NtgWEOuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzGCUNAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzGCUNAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF511F000C4;
	Sat, 17 Oct 2026 17:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259437;
	bh=fq84v+zVvkolJwfZujLRanTDDQi3/zuAGTy00Cititc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MzGCUNAZ1kniNA+Rr2anB6oAzO/QyUVn8tDgtQKP610EX7x6FxofqfUa4n92Vo/rn
	 cTVyvGMd5w4RQFNE2Ew7fnzkQLjoUPMtRjSdnHWoYCxq+CGiHhVB3CdgmY4ZwiqXPi
	 YHNCGJ1AS9x+G8KswSkOYLNjIl6pnRVJzPk228IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1214/1674] tracing/probes: Remove WARN_ON_ONCE from parse_btf_arg
Date: Sat, 17 Oct 2026 17:58:06 +0200
Message-ID: <20261017160502.303722002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 251a8fe1b9aedccd298b77bc28426d564c5a923f ]

Sashiko found that user can cause this WARN_ON_ONCE() easily
with adding a kprobe event based on a raw address with BTF
parameter.

Since this is not an unexpected condition, remove the
WARN_ON_ONCE().

Link: https://lore.kernel.org/all/178177265367.2059927.13789953014706792126.stgit@mhiramat.tok.corp.google.com/

Link: https://sashiko.dev/#/patchset/178165816303.269421.7302603996990753309.stgit%40devnote2

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: b576e09701c7 ("tracing/probes: Support function parameters if BTF is available")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index afae842009d12..a43d974fbccc7 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -620,7 +620,7 @@ static int parse_btf_arg(char *varname,
 	int i, is_ptr, ret;
 	u32 tid;
 
-	if (WARN_ON_ONCE(!ctx->funcname))
+	if (!ctx->funcname)
 		return -EINVAL;
 
 	is_ptr = split_next_field(varname, &field, ctx);
-- 
2.53.0



