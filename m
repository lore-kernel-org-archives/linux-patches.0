Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026317;
	b=fo3KtNBv8AtEFWPF3Prtzgj+9KbCDyGUt8M4q7WVh2q/TyoSVa+6FWY30rEQUIzrnfZr
	 U8V6tfN3ZOUGIegCT1r8bdpiI92ZHZs5sMBMN53iUKz5vMWWsR+eYPl//X7YM5rB3cFaR
	 Mf9c2pxU3A79bIaNxv1ZhOhDSVMfxEvmqp3bu8hElhuD9z2TvogjZPR1xX0aO2XmwK3P9
	 cpUP1QiBW184nQFlzpipYvJs1C2k4pWZNrQ7IbaiJb9aKCqY9HOqau7TRNzuBO/lMfg2b
	 T0wGJYZI1xIElzCPhcRKWgv7PDt7wZy9QZ6f9UHQ37jYboHG7krMnsWuppGN4NS6hwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VbZlKbI6d9o3RZTsIBVY32tU0VImjqHzO804nX865O0=;
	b=YaJ2uwhWfjiTDxfo6KuVdGJrHIZwsLAtT4zDRul7xMjnlDJyDa0O+ZAtcVDpzm7E+q/H
	 N6QTZC4op7KaahkErL1js4e5xCXkM3qw3E6V2V71tqucyy5qxafdOYAgGzfrVQ0Ao+fU+
	 2CJdxmBsEb4kTVmPERK4tuugkOvvzWCIONW+xgWEMO37EPSROEBp3qO7QLPlv2pOfgBhM
	 biX4UHP0eAle20Ncw6bvG3R1GUregkrRZCv3LYHnsoQKIVcbWUMCBv1PTauT0hBnccjOt
	 JRA2DEzq6Gj91TnvQyEIbqx4rJ6xYuhV2kfVqOv5NDTivhlg1i9bmIl5yyoaS1y1+Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3dsAy9b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342B5606A320;
	Wed, 18 Nov 2026 18:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3dsAy9b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FD81F000C5;
	Wed, 18 Nov 2026 18:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026317;
	bh=VbZlKbI6d9o3RZTsIBVY32tU0VImjqHzO804nX865O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3dsAy9b1U9F1/EPiAdYTLxviUz6NRei6JTT6aphN7jAz9eUx0j2HZlNoeglW+kjs
	 ZyyHMXdrbf6Tyb1DLwfzL9RjHFASiB/pUq6VRnnm5fJldYEWve9JmvxRWUUoTq+VjY
	 JUsqlvgzmNf7O6i6nivfk5NaTbm+gIOfLyHQjvHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haitam Lazaar <haitam@lazaarsec.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1393/2151] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read responses
Date: Wed, 18 Nov 2026 15:52:08 +0100
Message-ID: <20261118150212.743711599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Haitam Lazaar <haitam@lazaarsec.com>

[ Upstream commit f74eac4fc6c56274fb96c2c44ffad8f01c325f17 ]

When generating an RDMA READ response (SIW_OP_READ_RESPONSE),
siw_check_sgl_tx() unconditionally passes 0 as the required permission
mask:

    /* Reference memory to be tx'd w/o checking access for LOCAL_READ */
    rv = siw_check_sgl_tx(qp->pd, wqe, 0);

Because perms is 0, siw_check_mem()'s authorization test:
    if ((mem->perms & perms) < perms)
evaluates to (mem->perms & 0) < 0, which is always false. Consequently,
an untrusted remote peer can issue an RDMA Read targeting any valid
STag in the Protection Domain, even if the memory was registered strictly
as write-only (IB_ACCESS_REMOTE_WRITE) without IB_ACCESS_REMOTE_READ.

Enforce that the target memory region was granted IB_ACCESS_REMOTE_READ
when answering SIW_OP_READ_RESPONSE work queue entries, while preserving
perms = 0 for standard local sends.

Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Signed-off-by: Haitam Lazaar <haitam@lazaarsec.com>
Link: https://patch.msgid.link/1a12ad1d83f.19cd98924357428.7073029566232810804@lazaarsec.com
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 54c9d97015e8f..c133c20b835d2 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -805,17 +805,21 @@ static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
 
 	if (wqe->wr_status == SIW_WR_QUEUED) {
 		if (!(wqe->sqe.flags & SIW_WQE_INLINE)) {
-			if (tx_type(wqe) == SIW_OP_READ_RESPONSE)
-				wqe->sqe.num_sge = 1;
-
 			if (tx_type(wqe) != SIW_OP_READ &&
 			    tx_type(wqe) != SIW_OP_READ_LOCAL_INV) {
+				enum ib_access_flags perms = 0;
+
 				/*
-				 * Reference memory to be tx'd w/o checking
-				 * access for LOCAL_READ permission, since
-				 * not defined in RDMA core.
+				 * Local READ permission doesn't exist in RDMA core.
+				 * A READ RESPONSE source is read by the remote peer,
+				 * so it must be checked for REMOTE_READ permission.
 				 */
-				rv = siw_check_sgl_tx(qp->pd, wqe, 0);
+				if (tx_type(wqe) == SIW_OP_READ_RESPONSE) {
+					perms = IB_ACCESS_REMOTE_READ;
+					wqe->sqe.num_sge = 1;
+				}
+
+				rv = siw_check_sgl_tx(qp->pd, wqe, perms);
 				if (rv < 0) {
 					if (tx_type(wqe) ==
 					    SIW_OP_READ_RESPONSE)
-- 
2.53.0



