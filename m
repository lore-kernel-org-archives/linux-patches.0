Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029156;
	b=4YZENzCDju+1MpdKRcAMk1og63sxlUMnN3tG8TwOde5Cays+hdRredtIf+m0aza8RWDg
	 MoknpLOaZi77gKaJKtlxzT1USZZDr4yHKAfvZWtT655hARWpkviUTC1eCK9S/loO/eHpJ
	 JhJLstO6fhmx/6cPiF8WlUWZfYCrQm0rgpfzuMTnPiSxYceJFY09LzozwwZ+2meX4wJs2
	 rxnRKqMDZXukRinVzuMUxjnnZ4KJ/Cj2xoRWYwRZ0Stmx3oUYIOE5TXJNYcxX2OQG6Zjg
	 xKW9Xv9Ex7DtYpkf0YIXtiAuykfssEI6WNfeNvazx7C23KMDxg2GxLZxSwZCfyaHlLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PpScJOBOtZlPaITRz860JnjRpnqpdJGLsT0pG0SjUnA=;
	b=rIyUF3HIScWpTsjzF9j+WGHTR3RlLFd1Qtc2rCgbLzqlplUQYDSoPEDEcfWWED9RpGh7
	 WnitPQIBTGgW9vdUTaVx6Bj+LwnzZU4C0lrgWkL4QWIm03b51pauuLqG848Z1QOuXGiP3
	 GmN2ru+j+nHwWvfC7gKll3agJf998+j18D7Tn5+XrlDRiBOP5qFY2E/14WPbdjf4it7EM
	 NReCqoIwmr5KVLFl7pNxXWFEw6FE+KFFegz89udMuG9B/QE8MsY3CIPrhncHzFpnwBAU8
	 /HSBXHYhVu9Wgg2iUiGNIlmAHN49PX5P3n5X4xrS1G25FQP7zeIPW3Y+JqSP+f/kagQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCmsc5u+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DB6606A331;
	Wed, 18 Nov 2026 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCmsc5u+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA2A1F000C6;
	Wed, 18 Nov 2026 19:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029156;
	bh=PpScJOBOtZlPaITRz860JnjRpnqpdJGLsT0pG0SjUnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCmsc5u+knn6v8yBnDHH7VpBJPVdGQChbCGC8zdXdIkI2CQd+tqLm3WQlPDoLmShU
	 cp0zKzJfn3n5nUdyTDMovMz/HGxBb38ciW+/+ZnlaT3PjScycpjvirLtRxkvz3e5TH
	 NIwXue3Oyvhnu5Ih+EvExPQjA/fcI8S89Tz2G7Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0249/1756] RDMA/irdma: Preserve fast-registration IOVA on 32-bit
Date: Wed, 18 Nov 2026 15:39:36 +0100
Message-ID: <20261118150018.298537305@linuxfoundation.org>
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
index de1bd2b57414a..16dbb1d350425 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1320,9 +1320,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 		  info->wr_id, wqe_idx,
 		  &qp->qp_uk.sq_wrtrk_array[wqe_idx].wrid);
 
-	temp = (info->addr_type == IRDMA_ADDR_TYPE_VA_BASED) ?
-		(uintptr_t)info->va : info->fbo;
-	set_64bit_val(wqe, 0, temp);
+	set_64bit_val(wqe, 0, info->va);
 
 	temp = FIELD_GET(IRDMAQPSQ_FIRSTPMPBLIDXHI,
 			 info->first_pm_pbl_index >> 16);
@@ -1339,7 +1337,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 	      FIELD_PREP(IRDMAQPSQ_LPBLSIZE, info->chunk_size) |
 	      FIELD_PREP(IRDMAQPSQ_HPAGESIZE, page_size) |
 	      FIELD_PREP(IRDMAQPSQ_STAGRIGHTS, info->access_rights) |
-	      FIELD_PREP(IRDMAQPSQ_VABASEDTO, info->addr_type) |
+	      IRDMAQPSQ_VABASEDTO |
 	      FIELD_PREP(IRDMAQPSQ_READFENCE, info->read_fence) |
 	      FIELD_PREP(IRDMAQPSQ_LOCALFENCE, info->local_fence) |
 	      FIELD_PREP(IRDMAQPSQ_SIGCOMPL, info->signaled) |
diff --git a/drivers/infiniband/hw/irdma/type.h b/drivers/infiniband/hw/irdma/type.h
index 59b34afa867bd..45f5d6c211cf5 100644
--- a/drivers/infiniband/hw/irdma/type.h
+++ b/drivers/infiniband/hw/irdma/type.h
@@ -1005,13 +1005,11 @@ struct irdma_reg_ns_stag_info {
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
index f86249226b60e..8a3c08679953d 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3566,8 +3566,7 @@ static int irdma_post_send(struct ib_qp *ibqp,
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



