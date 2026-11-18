Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049566;
	b=WX5OsHaeDwZHawLfV3tArQzeFwsFTWYhDC6EdB1U6iYR3igfa6S1vI+WAEI9tIGxQz+Z
	 MaObGVdPEuxHZbwvZcGTZMk3t6ltmDEnpnVX3izv50ua4BvY2aVnJAGhKiVAi/zTJnBEI
	 2URCQw265PpL7pjFzECjisFAwfmy2BuTNTKnEUGU6lqxH72C/bKzEY5PcgWPEwbyGZB4G
	 Y7ndT22YE7Xv7oCY89eFgdbPFFO8yewzuo5RTUmSYQB4XeWCgootdMBpqcHohhQM+55i5
	 ngT8acSwVTbw2pF3j1/RhTfsMoLxMS44ub5pHmjjN41IQFs9Btoo/vcxQ1OuzKNXZOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TcFX9C679+DPQXiYu+kBgFh7A74M25Mq/zhEn3jppyk=;
	b=TYkoVMBdiQH/TEOC/E+efUaf7FFrdRHCaO2PoFMoCHrGmc+idQpg01uSjgMv+CONjJHJ
	 Lcvv52qFpGWJ2kYYCe9OcQ5i62ckr/MtkMcNCWk3ZuDgfBunWCw41Ez1bGugN4tnd2laj
	 HGGh/f1HcfbkvLQgaSsJ4fmY6MRGDcT2ZIlsBrTnbmCzgwLYNSwrfk6phFlnhArcvU3Lb
	 9ZEDRVrtNpUdEHLZZPswD7ZTbRE3jDcZJnjGPyzFlqCFn8gQM46pXr16CdvgycvQsik0I
	 SqShkGvMUrLtbsck72iYT3c+yKfMCDF59cWeqhsXK10asAPqyrKfySl8O25F69CHi4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Eq/ONQkT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412C8606A32A;
	Thu, 19 Nov 2026 00:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eq/ONQkT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1B71F000C4;
	Thu, 19 Nov 2026 00:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049566;
	bh=TcFX9C679+DPQXiYu+kBgFh7A74M25Mq/zhEn3jppyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eq/ONQkTinuqcErqAWb8rDzHP+7M6o4ebqZheqUKlcg1DezKdfTgNL5h1eA5k9cIG
	 QX6bBjwRtu22rno5NbVWYbVcUDzzE42PpcL/y+OiXP+qa5w2vnNhNbVXsEOs2RLXy4
	 GlhE3lO71GByIPLi3MNxanxL5dBAA7WSGqfhO9hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haitam Lazaar <haitam@lazaarsec.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2396/2857] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read responses
Date: Wed, 18 Nov 2026 15:57:10 +0100
Message-ID: <20261118150327.790675436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index bb81558246ae6..701d730c19629 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -820,17 +820,21 @@ static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
 
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



