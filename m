Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061512;
	b=DX6eVuGDQ77bsF8O7DmX53YZklGCwxcKwCrIaUUJEzzxpSLjeZorK3yoxy5oKQhkzkmE
	 svxownwQXlFrhY9Etp89Couf07hZdvwefAhBbjjFT3yRHaxVRy3KWRXW85kIyO3telTPP
	 0hKX2aoFC+EizOq1IAljhf0aHCdvqWJqbX90ksF+2fB2fXYdtEB7KIzdaZL2PPI/OvpqG
	 wMyi3F0qy9OfT7X+log4oVDt10x+wVqyDx6mocmx8ZpJWi0e4ATAU6o24qTLDV+75IAYv
	 IGcZWziPZMCZP8sMzDqrRncYF40bAgS4k0TfbR4xR/3a9cw+DV5SJn9u8E1yLW72xIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SfC+18DXtwJ/tg0fa97tjV3CmVRy9KS5TAXq5V20eFU=;
	b=fL1JcSOeVKa1KBDSh0xWvJzp6hDWhUDJ7WYgu/FyG7JEctVHbl+/asyNXSxd2l9oczgP
	 fQlBnSMDiugXLTO7KpcRS0coq/HE/572JS+VMEesgX5kr23B50IIW0pQUHaSd2mymtS6l
	 4+hjUThYi+IJC5CmMP2XmgUJNCW4t1i6vkT2aZmOP6fRwWG8ttkLu96uTUhW1wUyiWdk0
	 hKp/+3Wn9Odigk+SmnTavOEx4/zWiwkFUMI5gVRa9uairZRzM6S0UGJadTYa3TQjVkCDk
	 PjqW5fcnOQOpJeVrkz2y/8lVoNRxRtdTSdJOFO8D9Hl3wRF5why2oX8jbGV45gOd4Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="at05/HYL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C10460A2605;
	Thu, 19 Nov 2026 04:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=at05/HYL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812031F000C4;
	Thu, 19 Nov 2026 04:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061512;
	bh=SfC+18DXtwJ/tg0fa97tjV3CmVRy9KS5TAXq5V20eFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=at05/HYLZ+FKqwawhAJLh1GcItY+WwoNGK6jmca9m3rl3G9QQUPrCcxFKaAJmNmH4
	 MNb3EQDaq4bwhSolXdgis5S53jaYL6EH2gAy0Cq3CQo8VY0BhkbAlXO2YjbzLeCx8o
	 ywFwiGxK/xStIhZc4lV0laRvuB+yrS228RDRkSPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haitam Lazaar <haitam@lazaarsec.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1579/1848] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read responses
Date: Wed, 18 Nov 2026 16:00:17 +0100
Message-ID: <20261118150025.678234579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8704b8db3c0ac..2cfe08295a7c8 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -803,17 +803,21 @@ static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
 
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



