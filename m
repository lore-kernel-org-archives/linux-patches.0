Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031677;
	b=H4jTosHxDNRYhTYvm6V2zgFcm6Szl0Qf1hgfp4towF3q3Ueej4kA2ZC+ZXxyskGKNZtM
	 9tzV+6PiE+reGejezw0VL9Y+Axn7ts/cnX2BoQ7Ddzs91ZMVdsaISAYs8bRSUHZd2H1iA
	 mmSVqlECCAfPmL8iAFOdYS0ZBAoExISfTbVNIJewXPa0MLJ96sjfR1cI0USYo6syhBkHk
	 TjkoQb3j/FEDII8lpxb8Q7w2GrwCyIL4oi7p9MjBU44gywBC1pCZYJmCdChfbiwWLj12v
	 8A4PnoVSztQCbosn+/VZnpOHS6gcGxw0/W53d//9HK/jxxjS1ROzNnasDx54RIcDTiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DrrbUk5fAgEROnEq+/tDXCPhm6ZhzPrt4mViXdi0CMU=;
	b=ek+AyL3Ht/rIBtOVAwwW1d9XfxkBXL/KaDeJtPUQFwblXLpwSA/MiPWpaV3TKxaQhNRM
	 zl5L3RyND6M+Avf694Tw8jRu/YI4xLjf0CWJ0fOJ4ddeVBYNdA0biW9pUgaGaIC1lJqIN
	 h6LoLtboK6Xk0lCDCKk+XApDcsgcOpYXwdOya4jyOCfxQhR23kpCCJvKpwHJyzT7cH/fp
	 WFj99NZ5aaL4d0OsVmbWYgHGtXGI15LRKs5SaPlSB91tnqCASFAIr7BWFcqGSX5pwSxZx
	 l2C9dVYukcSVsYiOpzlStqwaQWRuNvqLWBB8jIjtdVIeDzpqZ2flQILxLK9k/+rrEuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Xj635TJ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B88D60A2604;
	Wed, 18 Nov 2026 19:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xj635TJ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50B71F000CE;
	Wed, 18 Nov 2026 19:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031677;
	bh=DrrbUk5fAgEROnEq+/tDXCPhm6ZhzPrt4mViXdi0CMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xj635TJ/3YwfgcrHeN7ZTrVhm4aKNyYOdgzwCJHTyydVyCRR8FWTZZGrhJaV23p0O
	 5oZVhP9TTwdySTKyDHIo+N9O3EIvhDKERPh0KS725OSbFP1fVcBxfaAQ+tfSiRWHVm
	 I+OH8jNs8oSOn5edW7SY6vdGPPgLD5sffRI9K1wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haitam Lazaar <haitam@lazaarsec.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1105/1756] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read responses
Date: Wed, 18 Nov 2026 15:53:52 +0100
Message-ID: <20261118150054.164764749@linuxfoundation.org>
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
index 4abea56ac45d6..bb0c4942f1e39 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -801,17 +801,21 @@ static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
 
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



