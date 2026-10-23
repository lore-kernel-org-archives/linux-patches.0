Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774018;
	b=O1YWqn4QsdwYcsP8iNKfYV3PE9Lh1tE3FRdu0HMm4FmROBqCh4quAE9T7Drr8QdrvuR+
	 sI+VCR3EE7n+aOAqHImPwWRWieva+ia+xiK2xtnWJpf43ifclR5+J66xrcC2S/2GbW/Sh
	 6+yRTGVtxITQ6rG4Hrvo0nxn8J4lU91/i0zIXLBDGx8b+k7fefBkjZCeQI+4uFpkd+4Uj
	 ZTcTZXy3ya/0P8wz2rG2Ssej/evWUaenrLiLaqssbaD6T2KgFckXTieFetZueCs0534wX
	 7tZlJzoGRyAfzPzDs6aSdK0fcLYS+QjDNZVdAR43flR71hBHf6tGnOKm8BNek74E46Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bj4pYSj1+zGWoNRcXSrBKHQNbl1scj4EohejDLh6avY=;
	b=0EYoCnF8Lkv11COoTQ22EQN6WF0qblymWKq3Zxjzg4d66FCH8/Po3/MeAHtOhC+8zraJ
	 qJ1xuDyNzsrEtdToUJlRuYzIdf7pOzZIyQbkespl/WGL7gB2sTdk+daWYNwxMD1NRMOUX
	 W7G7sFNNZKWfuERIB13u3MfxT+8lcGQeIl4+a0L74QaiDouQL+9eQcZv3qg0wEt1fm9Qi
	 aXXup+2ttp+UgvUPf/oWAS37KrgyD6n+uyj6QJoqMhfbWEQ8bYa1yxVOpJTy14c/IW4nL
	 2I5p9WtTLFx0BaVUmb00/9dy1E7/bWSwCnEQGfQew8yoHbaWSI8AtwZUl4Bbz6/cxkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rxMBpDz8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B38606A31A;
	Fri, 23 Oct 2026 16:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rxMBpDz8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBA11F01825;
	Fri, 23 Oct 2026 16:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774017;
	bh=bj4pYSj1+zGWoNRcXSrBKHQNbl1scj4EohejDLh6avY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxMBpDz81vIFoXWifAV288Uc+1r6uBKBB4/WofL0OYXGJ8og4Wd3uPNqHwc9so2wq
	 EH+X3F5Q5p7F17kZCMZTkrwWJgPgF40EmRk7rcHPvMYWGHm1C8vas+sbt+hzpgWkS0
	 AvGwNJiBD5OYVYluwJR8jXPWnppaKw3njwbVp2wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/193] tracing: probes: error if BTF is required but unavailable
Date: Fri, 23 Oct 2026 18:35:33 +0200
Message-ID: <20261023163715.530456667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a0fe68cff4d33..7202fb4aced1a 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1847,7 +1847,6 @@ const char **traceprobe_expand_meta_args(int argc, const char *argv[],
 					 int *new_argc, char *buf, int bufsize,
 					 struct traceprobe_parse_context *ctx)
 {
-	const struct btf_param *params = NULL;
 	int i, j, n, used, ret, args_idx = -1;
 	const char **new_argv __free(kfree) = NULL;
 
@@ -1865,7 +1864,7 @@ const char **traceprobe_expand_meta_args(int argc, const char *argv[],
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



