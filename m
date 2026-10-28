Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209971;
	b=dN6OG5rKChM46XhPC9drkAssUhCN+7PUZWeAtxbRN/ySeb1wlS4ZxeYKIAPc7dMG0ZeH
	 S3V6DXTUzekcb1s/poFwrFUAFdGelxkQB1cnr+/HKLVGSWQ22DBfwJ48wzV6u+UmlB1rm
	 k0C+bbOiM0qOZjVnKy8y+iawOZ0Yrd8K9kLpVqz5kx8xCa8XmRm9Qx1uhe/c8lyPjFHN8
	 /gjujboVzFu7OaK4iY9tnH+R8IqeqqCPduC3cE4x+j2SnbvTXiruvZR/bdf0mjVpQtE8M
	 VwQmqP3zjyu1VYS/AczGKxorQIwcgtt70zhwe9TmuEMVhVQ5lafP9hfVVC4OotvxqnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s7KqYBq6ViNjN4UMPG8wxJcPExw8apscKktYyPyG5eM=;
	b=KXe2lj+Eyk7PyX1S78cW06uBS0Csf+LmWXs6c75AiNXEtseeSWeJaqIr1/VmxZaLsBpJ
	 mw/LWngDbDKhSCgWS/XITlyillZH5eBIXT1G9iS18F/4QuhERWyqODqzpG3ZahD+3v3n5
	 F2esY2X4BQRQXDecgYh1kfv5WMhYV9juiv5TN1Mb6VLpnAJzfqGvDXyg4D+JdTa2f7ld3
	 EDfk78bAPEH8C+HPeUXEkrAc7D2r20tw3f19SAvABT+1j/6e9RS8qGcVFwduAxBt01VRH
	 AN+TFlCKXL5uNFJ7JpiYu8Ggfu3VxNoZgCN/BDrGbCSA45TN70YLZrkbNGvHAnwyolA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmcGm4gG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB8E606A31A;
	Wed, 28 Oct 2026 17:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmcGm4gG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF731F01825;
	Wed, 28 Oct 2026 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209970;
	bh=s7KqYBq6ViNjN4UMPG8wxJcPExw8apscKktYyPyG5eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmcGm4gGLrsQV8pVqQoTtux1dtwyQ1s/b+0i+BXD+8KdUTuRiC9VK54Ft+F9Wg8w9
	 FFasyxGHmbY6Ph0tub3OIfX/PFiMaQGd4xda2YVWBm04E3QvKJ9VhzJdrSIOu6AxD4
	 lP39tEgjUrtwwsvnobGXi+m8AGw5LYmaPmpdrcUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/168] tracing: probes: error if BTF is required but unavailable
Date: Wed, 28 Oct 2026 17:59:26 +0100
Message-ID: <20261028165943.810607088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a43d974fbccc7..d6bde7a03b57a 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1663,7 +1663,6 @@ const char **traceprobe_expand_meta_args(int argc, const char *argv[],
 					 int *new_argc, char *buf, int bufsize,
 					 struct traceprobe_parse_context *ctx)
 {
-	const struct btf_param *params = NULL;
 	int i, j, n, used, ret, args_idx = -1;
 	const char **new_argv = NULL;
 
@@ -1681,7 +1680,7 @@ const char **traceprobe_expand_meta_args(int argc, const char *argv[],
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



