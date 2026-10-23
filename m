Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774532;
	b=STP9PluuGCPyCa1tAFQgvqGf5L22Iegp9z2LaxG2So8sXX11dKSlh0EZ2fOktXNjhzqA
	 J/KdVD1jmfj0gWl/UHyTLvDLp/29MwYyhtV/zrV/n1jCfUG/HGSK0Vr0sVV/olKpxH9Cx
	 HtXF6hEmLDnVujq/yaL2vl7eYb7EGfJYNG+qSxvWlZrh8G6A+fzqb8ww7WiGsJLZ1FU/E
	 kP804PA+xB+YGjFEJz1QZZ64yb9zgkwK58mHJj2psAaslM8OA2tlHHMtJGU/hpU0i1v/G
	 jXFZQEyj0vrzDx7n0/gJ4mdjeUn9HQTrKE16rHyTXUEuEZfX+/QMDu0fiOi7R19Zxiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8v3vf5e+TLOT42QzvG7N4Tr7G3MzDtcF+5szthpfHA0=;
	b=UPNwEGMn6xjsq03tZVsdUdQVvqJVELY/aTwpmUy6iBxh2mseIxnCYUuM5t3uOQaadJXj
	 Ifu/knAwiaZzwgDmVlmZ8EPM/W64ouNIZYeayjAzJ+ZLIPcQmF/zKBBlGbh9AszZ3cRUo
	 qgBR7JneciP9UCcHcqjzRsrAo45cgW4FvU+gUH77hricg1OfjAFKG1YYbr3Puf7HPZmAG
	 28AYqbiKSaAtY8vLdzNdVbzBrQLbtAhBFfEP2xB2kLPI8b+sGO2t8j/kMq/43md8FbU0X
	 853SGWatN/4meYjTOF5OVY0zzf2MdaTu1RMs+w6H5mb/0OrWNwcWzub7qNnlXaVtomw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jqu95eMo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABFF606A31A;
	Fri, 23 Oct 2026 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jqu95eMo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB281F01825;
	Fri, 23 Oct 2026 16:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774532;
	bh=8v3vf5e+TLOT42QzvG7N4Tr7G3MzDtcF+5szthpfHA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jqu95eMoaK7Aj9MKa4U+8EiTAyYuiiHl5O51a1U3jrXq9g2Zbi1kYbzE6VES4yGVy
	 QId953xxBCCNYSbXuurhaoRKYs0MG/4flUNBtYTCgSYAXVjkwxCJVWPVkTcuCl1L8p
	 UG9GTJ82m8yYi0l0Ru41JequGHNaCqGF8udZ1lAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 072/242] tracing: probes: error if BTF is required but unavailable
Date: Fri, 23 Oct 2026 18:38:34 +0200
Message-ID: <20261023163715.483622377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 66c658033d842bb75f81f20aaa4a378fe47be1a1 ]

traceprobe_expand_meta_args expands probe arguments based on BTF info.

Return an error if we have arguments that need expanding but BTF is not
supported.

The params variable is now unused, it can be removed.

Link: https://lore.kernel.org/all/20261014083838.31020-1-martin@kaiser.cx/

Fixes: d157d7694460 ("tracing/probes: Support BTF field access from $retval")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index f3c20a093f5dd..4c929d7d6345a 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1842,7 +1842,6 @@ const char **traceprobe_expand_meta_args(int argc, const char *argv[],
 					 int *new_argc, char *buf, int bufsize,
 					 struct traceprobe_parse_context *ctx)
 {
-	const struct btf_param *params = NULL;
 	int i, j, n, used, ret, args_idx = -1;
 	const char **new_argv __free(kfree) = NULL;
 
@@ -1860,7 +1859,7 @@ const char **traceprobe_expand_meta_args(int argc, const char *argv[],
 		if (args_idx != -1) {
 			/* $arg* requires BTF info */
 			trace_probe_log_err(0, NOSUP_BTFARG);
-			return (const char **)params;
+			return ERR_PTR(-EOPNOTSUPP);
 		}
 		*new_argc = argc;
 		return NULL;
-- 
2.53.0



