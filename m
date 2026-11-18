Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056363;
	b=BNXIFA7P7rDlUerUzH93mcIxlREpupViGwt0wf2C2mLh0xJa4yKy1i4DfS+0lgYgkXmp
	 lC2+ovWiBU7KXtEcjXrHoidjJ9IkIqnywVrGO0unTSfHOi72GHqPOtHOQQ2N965iJHEEH
	 KckwTApKlAWJhq0tTdkm28DbOnnybvMI4c/4neBBLluPlCNYYfquQt2f/9lIEjumqYyYm
	 99fshcgthi3fXOyh/OIrH3ZjYA4t+cK1tNqAF9PgGBT10QpU5fjHdLMm3zI7Z4atYWwJQ
	 M38wNauV7tD2J2YsQtSqBPLZ9bUCVqtdrk4lWkU6n3QzXKDffBbu2xv4rlcUZLE/zAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IfYxlQpLjGlJArMbFgiU0i/YhXNEVL+mlVG3RfdCG70=;
	b=GyI5X4D155NTr5eFEJjcTsIWb4B0AB+df1cwIPcmh3zdwB4CF4JakBqVAPIotzZHjrwD
	 PSAjZbBFrb375wi0Xl31hkOQzpJrA7/HqEZ9+FrWEjWwG6N8RAzJJY3yguOHPdZ5VD2yI
	 phgxBSZ9S4QvuClnftVZj7bQ4jFJPkDFuVu1BZ7723QKhiePLLjYFimfnZjAyXYAvV6i/
	 19EeUUD65aST9pQ8jQkMbp8WMtCUja9tJsQ0ZdTDQNZCXShJgYLXfeIK+73oXoj8m0D1B
	 E292kw0BjsbpFsZ+w8TMmdZbE/gvf0NCr7Kvmti5IMv+3Id7A1LfGESibJL3/DXjesQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLlrpMUM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC8C606A320;
	Thu, 19 Nov 2026 02:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLlrpMUM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748541F000C5;
	Thu, 19 Nov 2026 02:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056363;
	bh=IfYxlQpLjGlJArMbFgiU0i/YhXNEVL+mlVG3RfdCG70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLlrpMUMkWyUBOzrtawEZZ1FZkvE69BG1q9XZnf+FlMUBB5iyd+hcEar5pAkkxLuM
	 X6uuHmfI2i2CNK6mXXpAOpVKloFBA0mQHqAOm/bGC+XyIe2Q1PIPgTrfkSs4joRvo3
	 esH/0P42XQJtn6S/lbf3pGu0ztlGAFNb3AUsDZ6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1962/2214] RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
Date: Wed, 18 Nov 2026 16:00:38 +0100
Message-ID: <20261118150129.435493225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit 33afe9909f213d8bb8e80f0b93382dde0f56e2c7 ]

IB_WR_REG_MR is documented as kernel-only ("can not be issued by
userspace"), but nothing enforces it.
rxe_wr_opcode_info[IB_WR_REG_MR] sets WR_LOCAL_OP_MASK for IB_QPT_RC,
a QP type userspace can create, so a user QP that writes
opcode = IB_WR_REG_MR into its mmap'd SQ ring reaches
rxe_do_local_ops() -> rxe_reg_fast_mr(). That function then trusts
the ring-supplied fields:

	struct rxe_mr *mr = to_rmr(wqe->wr.wr.reg.mr);
	...
	if (unlikely(mr->state != RXE_MR_STATE_FREE))    /* deref */
	...
	mr->access = access;                             /* write */

For a user QP wqe->wr.wr.reg.mr is a fully attacker-chosen pointer,
so this is an arbitrary-kernel-address dereference (arbitrary read
confirmed, oops). No existing check distinguishes a user QP on this
path.

Reject IB_WR_REG_MR for user QPs before dereferencing the supplied
pointer.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261001152426.3259522-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 7c2e7b291b653..a16e2d24c3249 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -571,6 +571,10 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	u32 key = wqe->wr.wr.reg.key;
 	u32 access = wqe->wr.wr.reg.access;
 
+	/* IB_WR_REG_MR is a kernel-only op; a user QP must not reach here. */
+	if (qp->is_user)
+		return -EOPNOTSUPP;
+
 	/* user can only register MR in free state */
 	if (unlikely(mr->state != RXE_MR_STATE_FREE)) {
 		pr_warn("%s: mr->lkey = 0x%x not free\n",
-- 
2.53.0



