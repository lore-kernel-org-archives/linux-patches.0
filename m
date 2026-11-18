Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032065;
	b=mV1/1bFow0R5u5BOi75gr34duj/XLt1fyE0L+2BdShg+54zPmWgx7lNTkclMFXoUiYPu
	 AWXG/0PvpV5ZJUSbv+2yZe3QMUNqKgrJzU5vjdTadmiJBf46s7bR77XJNAkE2hFSwaidu
	 lJ7w2vBPQ7XU2hXBEXYdkKSXSjdXvGhG/2D0mycLndXzRaN+hDyKd9rQwxsW05CiS8MTB
	 ljhrj++ND1JRInFsgYmDmXRyl/+gfcrnucAyuprfGwqA0TMpxw22hQQl8RIRbNW9A1aLn
	 D2q8WIuTa2ZUsEydimK5uQ7HzOTviiMP2gb75rFk6bsfdLUxSa9iEeLOujSZYGZIslA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ENEtoMKzoeIP8IetAD808uC1MRPZAM1q7iFgCfIu9Jo=;
	b=g+UTUa6yQqIj4IrtkmSSxhVXybcJ0qr0PPMg+LJ2qCn68y6wGL3BV6I19CYDsgz4ZAGd
	 G8nccMRhQGXbD4vfeWh+0TRVXUOQcjscnGIwd/l0iQzFvVobsGQN/84Uu5cyVDb+E5Rkm
	 nAAMkMfdtPliiWO+HQSFuWjNWloxwE/GoxFDjD/E+V2XiVojpnehMhtWB3i/2wNWUu73p
	 lDrMiFTDRch8+BLK0CmEGjKzZNDK7g8z2qHn/tB43IDDOOL2kWobvuMb7myPSVGW3qbbn
	 lSCCt87+0Bz1iUfjdmOqdpEVCkmuuyB8hfdZmbQQBR91SgcMvapKxnpUMfLJM1qpfkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eh7jUXJN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD462606A32F;
	Wed, 18 Nov 2026 20:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eh7jUXJN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C351F000C4;
	Wed, 18 Nov 2026 20:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032065;
	bh=ENEtoMKzoeIP8IetAD808uC1MRPZAM1q7iFgCfIu9Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eh7jUXJNq2AAKe9OsPTo7LReeWsVFKI4HdHArk5k9Hyw32Jt9LdmyIhYApw+IRHgG
	 qRKo40XKSKthroJYqjrpH2JNA7OyrOeJpDjyMCMcFPIypTr/wJA0W6Dkb/ZJI3tgu9
	 7hwp2cEPsu5IWRlEMMervnqcPGG9G3R31vI7V/hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1278/1756] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
Date: Wed, 18 Nov 2026 15:56:45 +0100
Message-ID: <20261118150100.460909575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit c887e53e1c852b88bd5442d1bf4717ee3e7aadda ]

wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with
a caller-supplied opcode and no bounds check. For a user QP the WQE
comes from an mmap'd SQ ring, so wqe->wr.opcode is an
attacker-controlled __u32 read back by the requester
(req_next_wqe() -> rxe_requester()); rxe_post_send() takes the
qp->is_user branch and never runs validate_send_wr(), whose only
opcode check is itself !wr_opcode_mask() (it indexes before it
checks). rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR,
so an out-of-range opcode reads out of bounds and the result is used
as a mask and dereferenced; observed as a KASAN global-out-of-bounds
"Read of size 4" and a wild-pointer oops.

Return a zero mask for an out-of-range opcode, matching how
validate_send_wr() already treats a zero mask (an invalid WR), so no
path indexes the array out of bounds.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261002164552.294749-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index adc30bfb974ec..d6470cd6bf81c 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -180,6 +180,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
 
 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
+	if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
+		return 0;
+
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }
 
-- 
2.53.0



