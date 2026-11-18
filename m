Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041727;
	b=M9NuqjO5hdWvN2h4tqIP8GB8twVRtgTirz+2tY1tmt9BIqttDDPddVcFA+e5eEKDgzWy
	 8zdllsuc/Z+UthpmAA098KsB727kIa2Nf0zplaWzlNsrI8eaNYRH8gXegDJdzbkh3cF+m
	 UCvSzUn5tG7LQe4m07rcEXa658cD5Moxvmiixn3alzfkoDZWEk/tgft0UV/84mCJBAwbL
	 fNTibWdHwZh56zMhcM2Qf182GVxehRv4VaB6KQ9stkBXCeOsLctr5jcLCrnp3u2jBwJSA
	 LVTqDn2VzKLXIh4gAilwJiaWq2X993hRzlqTgQPYGrHo7Hfw2n9bAQyRxMsV/JvJ+7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dYGokgqc7xxc+AYLtVBJbXzQHwjaCl9xtnpwmajHv3A=;
	b=pVyOurW7y31BZX2YgQ/hcg0Vh3aYpfN4TDuypP5Clk76iJZHRi8FfW0TugVWj5BfIaqK
	 BaHZwpLCKnRHosjK/07edq7dWeXG2xGaiAn6qQx+ur3sHGIhbc3yOEvHE+vuYdyqKrTCB
	 HgG/zGeHHfLhIql+asYfJx6MJpL0SxD/oN+iLYAw5xJ9zdVDNDJyGYrGkXZM2zJZATthp
	 mB8oduRhJUbRUARKTKQpLyze99v/iKG1RzQ41cU7UPF6YX8UZ5sicAOjYi1FHwDvTnjvG
	 gBzd0mWCk8gIznQV8folm6fuTwMHKvTlBYJrr1CmaDAN4D53n6lLOpVVsbaPyPlPK5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wk9Ek/L5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F43F606A334;
	Wed, 18 Nov 2026 22:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wk9Ek/L5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D0D1F000C7;
	Wed, 18 Nov 2026 22:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041727;
	bh=dYGokgqc7xxc+AYLtVBJbXzQHwjaCl9xtnpwmajHv3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wk9Ek/L5bfl+2DZeQLhVCpYtdBYOyXo+rpTdBSNjvyJ+mUo9Mxy0nVJ13IBEHVjWC
	 +3vcC7OMF5p0Eo8JBK2o7BfVa6HWgD072LeD47/eV0t/JAlPzFWFMG5Y2iCjBl8ScR
	 M+npIf2wX9pNhi5ktDSmI7dAJlpXdnl56A+UKFl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2917/3318] RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
Date: Wed, 18 Nov 2026 15:58:59 +0100
Message-ID: <20261118150447.940333858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
index e5ab09a6ccf03..26d70dde8ea5d 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -781,6 +781,10 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	u32 key = wqe->wr.wr.reg.key;
 	u32 access = wqe->wr.wr.reg.access;
 
+	/* IB_WR_REG_MR is a kernel-only op; a user QP must not reach here. */
+	if (qp->is_user)
+		return -EOPNOTSUPP;
+
 	/* user can only register MR in free state */
 	if (unlikely(mr->state != RXE_MR_STATE_FREE)) {
 		rxe_dbg_mr(mr, "mr->lkey = 0x%x not free\n", mr->lkey);
-- 
2.53.0



