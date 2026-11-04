Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829368;
	b=EWgmDdcCq5A+SIv4NDkPVlLEf1BeTdnbfUuU9lfeIQFybxA/t6kuUvPBLD4MZMGLleVw
	 IHRxwWDAeo4NUhTeSCo2JAZ4TXWAP52uyzFNCpfcE/mpYSnBSc4us7MXgnn9g3SWmKuvk
	 KdkYnXXAUtZxpJ9KZpZ7XL1hSdjV/VN0vupmFp1gvAWDj0JjqHbBZHEWMUeBUt4Ingy5H
	 6xS7mqrXymYc1rk6C1VcOarG7qCHECuLw30Q0dCCVtzh4RNPHuFCIHtbC8wlCVxdYDqbm
	 FU3KsZtXFmST2f853hxzidhqSKDZc1j9cN4i4MLRrIec/n3oBqVt1c4RfMFdSplmtkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JbC7mfLI7DIxeZvidgRxTZJ5NJtAuL6v+jacBBLXruQ=;
	b=aING4Pbx+4Y2lLU8ze8OLtYEgG+oX28JOEQfLPjMHpEapctmh3mQcL2NrL1eA6zuZ6NN
	 t8ALXcWP8dFAtWUmwIdg6CYaUUOSj5f4k92Ba89RYRRSDppxjR62/wQhLAs+zIycz1X9v
	 xRP40rBOJSc13NB/bNDets9dF/geodLORN+M0mZCkQnNwAYhzj0lDMdCCuR+xBd49EU2/
	 oR0qZnexjULIa1MKqCZJSr38kj8xifERlCVpDWVNh3NK+RrxgQioe3/U02XY1vaXdHS1N
	 B7Ra3dgtaNFRRsSL244bSZSr0SG/rva+i2QCHyvP7o5XUJtAlSb2PE2tlqN8dxnYDNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gpj4nM2J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B0160BF2FD;
	Wed,  4 Nov 2026 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gpj4nM2J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97ED1F000C1;
	Wed,  4 Nov 2026 21:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829368;
	bh=JbC7mfLI7DIxeZvidgRxTZJ5NJtAuL6v+jacBBLXruQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gpj4nM2JU2dKHIrKL0ryeMGJZg+8khm84lCmeYM/XBUOmJjfX+N0Vq+rS2tKlSKkl
	 Di0zwxNHuNqnf+q1puNppI6tVxwlvJoCUv5bjzNYWeia2UPdxs2bIviR+u91H/TW78
	 Tv0h35YsnC0A58VGxC9PS9kJktPn8dJywT4+k1Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0081/1005] libbpf: Skip bpf_object__probe_loading() when BPF token is in use
Date: Wed,  4 Nov 2026 15:56:54 -0500
Message-ID: <20261104211045.891240215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit d262a25d8b58b697b2a1a2fe4b0078446cc00e11 ]

bpf_object__probe_loading() tries to load trivial SOCKET_FILTER and
TRACEPOINT programs to verify the BPF environment works.  When a
BPF token is in use with restricted program type permissions, these
probe loads may fail because the token does not allow the specific
program types, even though BPF loading is perfectly functional.

Fix by skipping the probe when a token FD is present: BPF token
creation itself proves the kernel has a working BPF subsystem.
Real BPF issues will be caught during actual program and map loading.

Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260610145059.113412-2-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b21d2f842579f..1aaf2bdf26857 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5070,12 +5070,8 @@ bpf_object__probe_loading(struct bpf_object *obj)
 		BPF_EXIT_INSN(),
 	};
 	int ret, insn_cnt = ARRAY_SIZE(insns);
-	LIBBPF_OPTS(bpf_prog_load_opts, opts,
-		.token_fd = obj->token_fd,
-		.prog_flags = obj->token_fd ? BPF_F_TOKEN_FD : 0,
-	);
 
-	if (obj->gen_loader)
+	if (obj->gen_loader || obj->token_fd)
 		return 0;
 
 	ret = bump_rlimit_memlock();
@@ -5084,9 +5080,9 @@ bpf_object__probe_loading(struct bpf_object *obj)
 			errstr(ret));
 
 	/* make sure basic loading works */
-	ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, NULL, "GPL", insns, insn_cnt, &opts);
+	ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, NULL, "GPL", insns, insn_cnt, NULL);
 	if (ret < 0)
-		ret = bpf_prog_load(BPF_PROG_TYPE_TRACEPOINT, NULL, "GPL", insns, insn_cnt, &opts);
+		ret = bpf_prog_load(BPF_PROG_TYPE_TRACEPOINT, NULL, "GPL", insns, insn_cnt, NULL);
 	if (ret < 0) {
 		ret = errno;
 		pr_warn("Error in %s(): %s. Couldn't load trivial BPF program. Make sure your kernel supports BPF (CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is set to big enough value.\n",
-- 
2.53.0



