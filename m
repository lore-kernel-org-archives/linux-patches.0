Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056207;
	b=piTJFHcxu7pmEph4IyalPd/JUuUUAHPT8FGa1k8ocGio9bADkmh19deY1DWqZIRUbeNj
	 K/vN0SknrEEN/2HTVaitbfFMwl/NGuJp6g5Bx0bFaupopHCLZkpwt0iZCWpDtJcCG68bE
	 6mhzF4Wztui11aiFuOmrZP14X8RvyxL2wlPu4G6Q3r4NrVw87noF7Ggh0tDtByOyT1Uie
	 mPgv9tHdwZjhcomF3N26P42RNmbborYV2IJU4VSUKp6B4NJOMB2XOnQw0qtKxEAzdJO0A
	 BCNSriWhhhqClxwIkDq/9Hh1cj/Ml3O+5268xtE9K3YMLcqdoi1rtqZtDQc1JqgEkzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AQDoqo0NdXweQR11eyRZyobZjCk/v/u8qDIkQ+NosEg=;
	b=5UrLTzT+qsCw/XQGOHDlarvyk2Cuw6x88nlSuU+Y4cq0N0WW/cDtBM8eY/QsrkiHrBAq
	 +N8C7ooNvexnOGRspUtZWG6sn7u44dn0VQ7KPCFHPOnFTZXv4wLcHo2zCRKUjwikQDrsW
	 DZ3ukhfTURTS7M4nhrRcQJER8MZdQH5V2lpyk/5aXDa2XAlhYjLCGe0CuEeq+7IUWyLPL
	 Up5FlBGVSGp/+UzNf7ytU1xwX97xSFc2KCEqpaGXANdIxANmQ+hAAozTxRL8MiszNLXHI
	 Y5gafJ03S7uM1rAxXboWkL3oQdydrJMdDbsy63J4BjiyxcEXnPbyCB92c98HSlW96ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bLEKUwbU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEDC606A31C;
	Thu, 19 Nov 2026 02:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bLEKUwbU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56101F000C4;
	Thu, 19 Nov 2026 02:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056207;
	bh=AQDoqo0NdXweQR11eyRZyobZjCk/v/u8qDIkQ+NosEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLEKUwbUF+5uexRrQ6S5835s/HC6/uKpTPCknJLOf7Z0Azme2zFSqc8p0TmWAXv+i
	 0knydT7qn9nQ992K/wNDTORUgZKGr6DDtWIVmKYVqD8VexmYV/AmMdjp74ujREtT/8
	 Xlr+v4ukvmxZlcmXeskdwkVwSSym/b1EboEnVJ2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haitam Lazaar <haitam@lazaarsec.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1865/2214] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read responses
Date: Wed, 18 Nov 2026 15:59:01 +0100
Message-ID: <20261118150125.923280466@linuxfoundation.org>
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
index d7bf73c2530e6..ab25bc1e77f7c 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -813,17 +813,21 @@ static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
 
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



