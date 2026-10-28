Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214162;
	b=Jfp9niI2Stp6lTJE7+KSW5+7/6x0LoBullt4Oe2AJxGCSINdoPDayn1qcUGQhFaZ6g5F
	 saUfKSFwyomFX2AB60iHQETXzp6HvTklyIEw4PKBcK/d2mZqrW5V8IM/sjLU2JFtjrOJN
	 /Wo1XNP2bHrMnph983k/KpUWctST3LQGSy+S0cWWalOe21c2x0+jKdnEggiaFjd7SPsGd
	 lYBdQBxE/oCmZKQqtrtB/m8otoBZQKYjdY/Thx1KctKvKYFxnP9R2mLtV5lYIk7whLb6g
	 95z9egYn4RSt0J2Ot89sLgtMjIpNUfgUCJ+DHPPcv4UbM0LEobQP1oR5VfWXys5NwHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MH8iRzh0x0o/a1Ld8dN22pm2M2emJEsOJb2abTBHmAg=;
	b=2VbDij2jUHMu4itTxiHpUw+PadQG63J1QQDY9BP0w00aLp/KiocsAEwFIwhZ2LIHejlg
	 srJQl1udCRzCwMq8gWRaNITv1slWhfmj+qEseZWepKh0HtoxqWNwoLjZzE/Tw6bZgpMyG
	 QC3EJ+IvjXY8mpbRJL+dqREvOZBnyWM7zWrDngMlImNcjDmUfaErR6JBdhdpS5EPTXE55
	 QXPMwFWGlKIUfJHtYaCZUtyLTC+bqf/kBRkXzyeOHvkaZD16VF+H1AEBsPYluseLFjEjN
	 n8r9weoePkPgQlxXaXLkUiZ0mDOOTcQ2HsRR2d12CYOUAraWGQv0UZSLzHOosDLMkwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHJ41M8v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF118606A31C;
	Wed, 28 Oct 2026 19:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHJ41M8v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E13E1F031E2;
	Wed, 28 Oct 2026 19:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214161;
	bh=MH8iRzh0x0o/a1Ld8dN22pm2M2emJEsOJb2abTBHmAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHJ41M8voxp7rHb8T/vi66jaUideJYGtixtRfHKapQD0uIo3QTCvFqVC+AB+YCnPP
	 vpojKir6ZPJGa6yWLSvFulSk+L6yaz05zHch1BMJVY/Q8kA409lNsx6XasIR5b6622
	 uPi5YBBhpgYWTtvho+qKWonJmX7Ws8d45nzWUUA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0759/1887] LoongArch: BPF: Dont override subprogs return value
Date: Wed, 28 Oct 2026 17:47:35 +0100
Message-ID: <20261028170516.716951957@linuxfoundation.org>
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

From: Hengqi Chen <hengqi.chen@gmail.com>

[ Upstream commit 60f3caff1492e5b8616b9578c4bedb5c0a88ed14 ]

The verifier test `calls: div by 0 in subprog` triggers a panic at the
ld.bu instruction. The ld.bu insn is trying to load byte from memory
address returned by the subprog. The subprog actually set the correct
address at the a5 register (dedicated register for BPF return values).
But at commit 73c359d1d356 ("LoongArch: BPF: Sign-extend return values")
we also sign extended a5 to the a0 register (return value in LoongArch).
For function call insn, we later propagate the a0 register back to a5
register. This is right for native calls but wrong for bpf2bpf calls
which expect zero-extended return value in a5 register. So only move a0
to a5 for native calls (i.e. non-BPF_PSEUDO_CALL).

Cc: stable@vger.kernel.org
Fixes: 73c359d1d356 ("LoongArch: BPF: Sign-extend return values")
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index bd601c269a944..88772302f952c 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -775,7 +775,10 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 
 		move_addr(ctx, t1, func_addr);
 		emit_insn(ctx, jirl, t1, LOONGARCH_GPR_RA, 0);
-		move_reg(ctx, regmap[BPF_REG_0], LOONGARCH_GPR_A0);
+
+		if (insn->src_reg != BPF_PSEUDO_CALL)
+			move_reg(ctx, regmap[BPF_REG_0], LOONGARCH_GPR_A0);
+
 		break;
 
 	/* tail call */
-- 
2.53.0



