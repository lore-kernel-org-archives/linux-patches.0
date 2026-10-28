Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207525;
	b=fCBBHReRP8J/RRoz5XlMkkebS+eDNIgp1HkkEfc+tEIBM88t8ZKbxA28BkZOw5LlL8wT
	 swUNZYOKuJfcWppt+pvcIr/J7FnWjt1gHkI7Jmhz76bxLaV2eI5OFlVzmGTrJPdwrQe5d
	 Weir/P1FXeG1EVhJNUq8qrvgJXwrdrALmgV9uCscOmZKAbcRDA8nNAFUvxYj4UM/sK5Te
	 NjwL/VePoMLHsahccHe1S5mf05+FE2OXFXr+52bdJWDVKeDrikMsPclJybM4pVnIJI8f3
	 e8RnUPMCZsmkFFCldm5ODvDjfVAsYPyKsDTCEgbJUCe3Ql3R7e07tA/qf21O+Atinbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UKpELNxXl769q/3UTM5LNKYbevv6uWY/9ouCLSODehA=;
	b=4tOsQtbILaxFr+uRjN/vQOqJiJXyXrha7NXRJ6bRFaMYOb4VOfTXgjTvrueOBfNLsoF1
	 uPI+CsJVvAy4efzv7xbrG4UcRq6cwQGW4FQ3ZjOejOuj0nFgpWx6SlGVCaYAkk6f53t1J
	 hGsbNShy/aPuSNj0aJeMA+W8aPy+pzJBCqzGzFVuP+JJP1DOCrGNvtxPCk01u7y05fjdQ
	 TOQqsAnpG/efaOzlb63bUKB+KZiKo5cGVeWYiZ3pn8lHmLakmyDLW5oMZ1eg3gOam1Dqb
	 Qhf5/iOzGsSbbzYrz2Y4bEGurKvWqOdWszMzIK6uqjuaQpQ622PHXWO7b9X7DgrsXYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CEr0qyR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745E5606A31C;
	Wed, 28 Oct 2026 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CEr0qyR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62D01F01825;
	Wed, 28 Oct 2026 17:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207525;
	bh=UKpELNxXl769q/3UTM5LNKYbevv6uWY/9ouCLSODehA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CEr0qyR0Jm81oaPihUHOS30LwJiFlXhpCvZoVrXCYKaVMQCGecPbEN/f8yWw5JyKj
	 sGvd8y9UOC66DC8PHrLHEEf+3kzBo1944d5EhQPY/iZSVdBnCiAtrWHc7XF2eTA7Fc
	 q6OzpZOrML5hhnCRRnEgcTqI0KL/zafpK+9RK5EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/247] tracing: probes: error if BTF is required but unavailable
Date: Wed, 28 Oct 2026 17:57:31 +0100
Message-ID: <20261028165948.513619648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 95201c0daa8f0..c7e4758505f26 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1709,7 +1709,6 @@ const char **traceprobe_expand_meta_args(int argc, const char *argv[],
 					 int *new_argc, char *buf, int bufsize,
 					 struct traceprobe_parse_context *ctx)
 {
-	const struct btf_param *params = NULL;
 	int i, j, n, used, ret, args_idx = -1;
 	const char **new_argv = NULL;
 
@@ -1727,7 +1726,7 @@ const char **traceprobe_expand_meta_args(int argc, const char *argv[],
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



