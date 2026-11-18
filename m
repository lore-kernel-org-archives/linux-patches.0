Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018327;
	b=LCk2Vi8yk2rpEKdGwOQsNPn3p+6vDj8wdGdoJnfmERb6NFAB7o0g2SQG2DtAUTvW/slD
	 KiQlOsualnvIOCTJLGrg7SLsDbzQUkkRo0FTW+eA5h5Xta7SkbdOMqWIGQ3qw0QLDCcd2
	 YfjQDhQ5FcPIq3f1xdyquHCPhzlqJ0dm20VR7efX1EuDL19Ii0OMdglNOC/RSVpIhdUxC
	 o9Jpu4vfLwJry2oPiMs2x33HZddg6sj8siCZsltLuNbsHyheLVxrqa1kdG8V8xVyJcFOF
	 qnTHe95Xr9AjBB0yUGD81PwZY4oi7XcTUpLYvsq1RbE5WlVYLxj2sDbFF3DGrUrEj+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M6y7EcvVQX40B1BAU/uQPFLafDnkKx7CPFYs9STGJB8=;
	b=ST6R7psSPaExJx1vCfnWM2seo+kbNMd2Ab6EOT/vdn7diRrlBn0OENDx74PL/ei1XkWL
	 8XfPSOSrW/qrcXZaLVgWQ0i5Z6mDY+su1wuK2HLrEs4jUHpBOfzP7ZC6hc09LcffoWq/M
	 STGUKd39Vww9n5Ve4aI3TKMae6zKrc+QYN1cb7evaMkjenuOFeVRI2Ko7fkySWvfSMWBv
	 cBEY/JM3P80P/g4f2sOhuByvMWOSinRdn3drFVLNw1Zx1mszdhT6qz7Ml6oEWFw8oefHh
	 6qjlXfHq8LmnVzFUnDsy3s/02XR7DXOtg+YU1PEsYEsV4CJvVUR2qB/a5OALo9ghjrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNWHEn4O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E91606A330;
	Wed, 18 Nov 2026 16:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNWHEn4O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C853C1F000C8;
	Wed, 18 Nov 2026 16:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018327;
	bh=M6y7EcvVQX40B1BAU/uQPFLafDnkKx7CPFYs9STGJB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNWHEn4Ow4ShE2cPLOtdEdu02tbEZj3fqM+qamlxqzjRJl0R8/Ibx6D2Xxnb7Vkip
	 1VBMbaZ97s1YDdKCd8xsgBCaRrkH1dUXmcVU5UZq/PArwBdmTsy2a0nzMOBqBQvV1I
	 29I3chRcD/6iC2Dd9WuyrLroGhOGOyhxhlWui4J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Yuan Chen <chenyuan@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1201/2651] bpf: Roll back freplace link state when bpf_arch_text_poke() fails
Date: Wed, 18 Nov 2026 15:40:41 +0100
Message-ID: <20261118150331.232597024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 5ec398d9ec8fe13f8058af9a2e5f5e8f46e0a35a ]

A freplace attach claims the target prog by bumping
tgt_prog->aux->freplace_link_cnt and setting tr->extension_prog.
bpf_arch_text_poke() then makes the extension take effect.  If the
poke fails, the claims are never released: the attach unwinds
through bpf_link_cleanup(), which clears link->prog, so
bpf_trampoline_unlink_prog() never runs.

Drop the link count under ext_mutex on the error path, and set
tr->extension_prog only after the poke succeeded.  The count is
still bumped before the poke: it blocks prog_array updates while
the entry is patched.

Fixes: d6083f040d5d ("bpf: Prevent tailcall infinite loop caused by freplace")
Fixes: be8704ff07d2 ("bpf: Introduce dynamic program extensions")
Suggested-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://patch.msgid.link/20260928091121.219333-1-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index d880ad6913b38..fc94d6062109e 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -1026,10 +1026,17 @@ static int __bpf_trampoline_link_prog(struct bpf_tramp_node *node,
 		err = bpf_freplace_link_tgt_prog(tgt_prog);
 		if (err)
 			return err;
+		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_NOP,
+					 BPF_MOD_JUMP, NULL,
+					 node->link->prog->bpf_func);
+		if (err) {
+			/* Undo the claim from bpf_freplace_link_tgt_prog(). */
+			guard(mutex)(&tgt_prog->aux->ext_mutex);
+			tgt_prog->aux->freplace_link_cnt--;
+			return err;
+		}
 		tr->extension_prog = node->link->prog;
-		return bpf_arch_text_poke(tr->func.addr, BPF_MOD_NOP,
-					  BPF_MOD_JUMP, NULL,
-					  node->link->prog->bpf_func);
+		return 0;
 	}
 	err = bpf_trampoline_add_prog(tr, node, cnt);
 	if (err)
-- 
2.53.0



