Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015699;
	b=apPVnDRLLxNIDGN+hTkIcFxUZiyB0pBBh2t7HJsx4zWvtBSRUQSz879gptPsdmqKY2QX
	 rBDOR7He/USTW0K7jkudOvcv0n1juDA/CSenUMr3FL4DpNY1/+zv54CPzGwgkSdUIekP9
	 aQ+GT5QTgAVAmBeRdaVMA070F3lOj9bD7dhHWviaXmlbGL4dGmMSds9DRefMuF4se9Xi3
	 iJTI3M6dckP1G3KK9hbPlFSehS3ysr/T7nXpWE9N8zcCSUcmbkiqtgoIAm2qD3aacTTby
	 nB31X5Gd5fOO0hU7oBTb5OLscjX2rcmlmg4Q+bRctJUsTJ/xjwKT+HEub/WjtrTAQfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GNp0PYqTsXQyCNN78vZdGxLKREm4npCKT+uBVFPSyHQ=;
	b=wTN2/pwrsFiVvHEMGttV96i0puBJiPERqUvcnfmHtJIlM37cr+q2Ldikagt+H8gSWfTp
	 MDUWw2jI0JCWWto/nigeMH7Q/FYVAVFOngUmzm9GTJ357UHAaa7Tl+gO8HFNTU0/LPvhW
	 Gklaap6FoWwteAeX2JBZ/qxXTq/nXuf4coTV1bL+w2gbbM1vTDrb7Vr8NIoKw95Qb3oFB
	 m4w0t0FBI7LpkZ5dRvcf/EVprvTSRMOqBw5b/z5wfRtm57C0RPrLDV5k2vkcRh2ORfAVv
	 UvrKyNqWY/2qtjFhLuziutIorge0YKgWT14Xgy374icLl3VhEZ4xq7Ueh0JS1VL5b9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l8GbFaUe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03524606A33F;
	Wed, 18 Nov 2026 15:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l8GbFaUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174681F000CC;
	Wed, 18 Nov 2026 15:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015698;
	bh=GNp0PYqTsXQyCNN78vZdGxLKREm4npCKT+uBVFPSyHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8GbFaUeeDtRMJm76Ufq7umwSO6SRycQojaJzICLo/SuZNRnKvYCH03db/0fNhkmF
	 6U1Nt1/dhxTsupc2gwSLQL7AK6Ex95mg+yU0F+T1DHXgYjNHXy50xX32qIh6wmb7s9
	 IA/gBzvkopQWD2PVgpLOQR8zdEcdMkkstHyT1m5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0249/2651] RDMA/irdma: Preserve fast-registration IOVA on 32-bit
Date: Wed, 18 Nov 2026 15:24:49 +0100
Message-ID: <20261118150256.825094742@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit c470050f2a7a7748ce35367e828885a8e658d712 ]

ib_mr::iova is u64, but the fast-registration path passes it through
void * and uintptr_t. These conversions truncate the upper 32 bits on
32-bit kernels before the WQE is built.

Store the IOVA as u64 and write it directly to the WQE. The sole caller
always uses VA-based addressing, so remove the unused FBO selection and
set the VA-based bit unconditionally.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://patch.msgid.link/20260903-64-bit-iova-is-silently-truncated-to-v1-1-96e878ea6873@nvidia.com
Reviewed-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ctrl.c  | 6 ++----
 drivers/infiniband/hw/irdma/type.h  | 4 +---
 drivers/infiniband/hw/irdma/verbs.c | 3 +--
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 335ae3c82e173..7af1c68b2fb26 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1723,9 +1723,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 		  info->wr_id, wqe_idx,
 		  &qp->qp_uk.sq_wrtrk_array[wqe_idx].wrid);
 
-	temp = (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED) ?
-		(uintptr_t)info->va : info->fbo;
-	set_64bit_val(wqe, 0, temp);
+	set_64bit_val(wqe, 0, info->va);
 
 	temp = FIELD_GET(IRDMAQPSQ_FIRSTPMPBLIDXHI,
 			 info->first_pm_pbl_index >> 16);
@@ -1742,7 +1740,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 	      FIELD_PREP(IRDMAQPSQ_LPBLSIZE, info->chunk_size) |
 	      FIELD_PREP(IRDMAQPSQ_HPAGESIZE, page_size) |
 	      FIELD_PREP(IRDMAQPSQ_STAGRIGHTS, info->access_rights) |
-	      FIELD_PREP(IRDMAQPSQ_VABASEDTO, info->addr_type) |
+	      IRDMAQPSQ_VABASEDTO |
 	      FIELD_PREP(IRDMAQPSQ_READFENCE, info->read_fence) |
 	      FIELD_PREP(IRDMAQPSQ_LOCALFENCE, info->local_fence) |
 	      FIELD_PREP(IRDMAQPSQ_SIGCOMPL, info->signaled) |
diff --git a/drivers/infiniband/hw/irdma/type.h b/drivers/infiniband/hw/irdma/type.h
index 5557d9338796f..81c5c5da1988f 100644
--- a/drivers/infiniband/hw/irdma/type.h
+++ b/drivers/infiniband/hw/irdma/type.h
@@ -1173,13 +1173,11 @@ struct irdma_reg_ns_stag_info {
 struct irdma_fast_reg_stag_info {
 	u64 wr_id;
 	u64 reg_addr_pa;
-	u64 fbo;
-	void *va;
+	u64 va;
 	u64 total_len;
 	u32 page_size;
 	u32 chunk_size;
 	u32 first_pm_pbl_index;
-	enum irdma_addressing_type addr_type;
 	irdma_stag_index stag_idx;
 	u16 access_rights;
 	u32 pd_id;
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 5d71300da0ff2..55237b20a052d 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4276,8 +4276,7 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.stag_idx = reg_wr(ib_wr)->key >> 8;
 			stag_info.page_size = reg_wr(ib_wr)->mr->page_size;
 			stag_info.wr_id = ib_wr->wr_id;
-			stag_info.addr_type = IRDMA_ADDR_TYPE_VA_BASED;
-			stag_info.va = (void *)(uintptr_t)iwmr->ibmr.iova;
+			stag_info.va = iwmr->ibmr.iova;
 			stag_info.total_len = iwmr->ibmr.length;
 			stag_info.reg_addr_pa = *palloc->level1.addr;
 			stag_info.first_pm_pbl_index = palloc->level1.idx;
-- 
2.53.0



