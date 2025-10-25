Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4393054F9;
	Sat, 25 Oct 2025 16:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408874; cv=none; b=L/3t1E9PuXkpHUrdf0NqvddCCpTjh/J8NMgGnhqmD0zrmZY8Qc/E7nnEbNWOfNwRF3EgxQBEDzfsVbbakGm8S0yO65sX2jB5AVMw1aF0QObFSXY6Wmam7YmF2gAgwSPup9/zEYzKBm1vndyzNwP1EPyua2UyAsYdR80oAli4WDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408874; c=relaxed/simple;
	bh=XIUsn205KYvbu+syWynGleYgKDITpx5ud7Vz9H7cH8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0+kT0+h5LKDWHRG43rfwWqM7W3qZwZeg+ZHVPiQV+gALcmBtTPHS6W+jjtM080GPBZMMo1T/ZWhMfmMcJ6sf32s2lt0I/XCcMdZKGDyYHXFHS9uDEiJT71oOTry4c1N9jlEKogUvcnf0Kxw4WaAM9UCpyuN3gb38A2MwBFoiGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r59yxKR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r59yxKR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3EDC113D0;
	Sat, 25 Oct 2025 16:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408874;
	bh=XIUsn205KYvbu+syWynGleYgKDITpx5ud7Vz9H7cH8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r59yxKR+J+SNog6kHNoYey3nNPLx+u63PF/WIdkkxwPGkMPUPgLJgLJtUf96okNv9
	 5nAoG8u/gQkEo77BEWhXXkTguJBzlg1XpjvkmAommuxDkEFU3rukCRJWND3+7kNUt7
	 uqdIQbNoBt3L3u4gDxKHyMSamWBj/hJyXopzod9gGRja+d6JbtvvFJeQ4heGJUzftB
	 PR1xhwFAl0xVrUHNV4kjVFk4pbPkl9yxk9fgJ4XwKOHXRfJrn/y5edIBj4rrEjRSBO
	 +TMAy3K5Qyf7y0hA+RUHRDP4Jvfddc4C6jGPleBv8AsrMcBsqMUCcpLgFCW20hU5tI
	 CL0gQEXprNJKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shruti Parab <shruti.parab@broadcom.com>,
	Hongguang Gao <hongguang.gao@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	pavan.chebbi@broadcom.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] bnxt_en: Add fw log trace support for 5731X/5741X chips
Date: Sat, 25 Oct 2025 11:55:41 -0400
Message-ID: <20251025160905.3857885-110-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shruti Parab <shruti.parab@broadcom.com>

[ Upstream commit ba1aefee2e9835fe6e07b86cb7020bd2550a81ee ]

These older chips now support the fw log traces via backing store
qcaps_v2. No other backing store memory types are supported besides
the fw trace types.

Reviewed-by: Hongguang Gao <hongguang.gao@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Shruti Parab <shruti.parab@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250917040839.1924698-6-michael.chan@broadcom.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this needs to go to stable.
- `drivers/net/ethernet/broadcom/bnxt/bnxt.c:9314-9423` now bails out of
  the RDMA/backing-store setup on non‑P5 hardware; with new firmware,
  5731X/5741X devices advertise backing_store_v2 but still report zero
  `entry_size`/`pg_info`. Without the guard, `bnxt_setup_ctxm_pg_tbls()`
  (drivers/net/ethernet/broadcom/bnxt/bnxt.c:9063-9087) returns
  `-EINVAL`, propagating out of `bnxt_hwrm_func_qcaps()` and preventing
  the NIC from initialising. This change keeps legacy chips working once
  the new firmware is deployed.
- The added `BNXT_CTX_KONG` mappings (`bnxt.c:256-268`,
  `bnxt.h:1960-1976`, `bnxt_coredump.c:18-40`, `bnxt_coredump.h:94-106`)
  let the driver recognise the new AFM KONG firmware trace type exposed
  by that firmware, so the trace buffer and coredump code no longer skip
  it.
These updates are confined to the bnxt driver, correct a firmware-
induced regression, and carry low risk, so they fit stable policy well.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 9 +++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          | 3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c | 3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h | 1 +
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0f3cc21ab0320..60e20b7642174 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -265,6 +265,7 @@ const u16 bnxt_bstore_to_trace[] = {
 	[BNXT_CTX_CA1]		= DBG_LOG_BUFFER_FLUSH_REQ_TYPE_CA1_TRACE,
 	[BNXT_CTX_CA2]		= DBG_LOG_BUFFER_FLUSH_REQ_TYPE_CA2_TRACE,
 	[BNXT_CTX_RIGP1]	= DBG_LOG_BUFFER_FLUSH_REQ_TYPE_RIGP1_TRACE,
+	[BNXT_CTX_KONG]		= DBG_LOG_BUFFER_FLUSH_REQ_TYPE_AFM_KONG_HWRM_TRACE,
 };
 
 static struct workqueue_struct *bnxt_pf_wq;
@@ -9155,7 +9156,7 @@ static int bnxt_backing_store_cfg_v2(struct bnxt *bp, u32 ena)
 	int rc = 0;
 	u16 type;
 
-	for (type = BNXT_CTX_SRT; type <= BNXT_CTX_RIGP1; type++) {
+	for (type = BNXT_CTX_SRT; type <= BNXT_CTX_KONG; type++) {
 		ctxm = &ctx->ctx_arr[type];
 		if (!bnxt_bs_trace_avail(bp, type))
 			continue;
@@ -9305,6 +9306,10 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	if (!ctx || (ctx->flags & BNXT_CTX_FLAG_INITED))
 		return 0;
 
+	ena = 0;
+	if (!(bp->flags & BNXT_FLAG_CHIP_P5_PLUS))
+		goto skip_legacy;
+
 	ctxm = &ctx->ctx_arr[BNXT_CTX_QP];
 	l2_qps = ctxm->qp_l2_entries;
 	qp1_qps = ctxm->qp_qp1_entries;
@@ -9313,7 +9318,6 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	ctxm = &ctx->ctx_arr[BNXT_CTX_SRQ];
 	srqs = ctxm->srq_l2_entries;
 	max_srqs = ctxm->max_entries;
-	ena = 0;
 	if ((bp->flags & BNXT_FLAG_ROCE_CAP) && !is_kdump_kernel()) {
 		pg_lvl = 2;
 		if (BNXT_SW_RES_LMT(bp)) {
@@ -9407,6 +9411,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 		ena |= FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_SP << i;
 	ena |= FUNC_BACKING_STORE_CFG_REQ_DFLT_ENABLES;
 
+skip_legacy:
 	if (bp->fw_cap & BNXT_FW_CAP_BACKING_STORE_V2)
 		rc = bnxt_backing_store_cfg_v2(bp, ena);
 	else
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 119d4ef6ef660..2317172166c7d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1968,10 +1968,11 @@ struct bnxt_ctx_mem_type {
 #define BNXT_CTX_CA1	FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_CA1_TRACE
 #define BNXT_CTX_CA2	FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_CA2_TRACE
 #define BNXT_CTX_RIGP1	FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_RIGP1_TRACE
+#define BNXT_CTX_KONG	FUNC_BACKING_STORE_QCAPS_V2_REQ_TYPE_AFM_KONG_HWRM_TRACE
 
 #define BNXT_CTX_MAX	(BNXT_CTX_TIM + 1)
 #define BNXT_CTX_L2_MAX	(BNXT_CTX_FTQM + 1)
-#define BNXT_CTX_V2_MAX	(BNXT_CTX_RIGP1 + 1)
+#define BNXT_CTX_V2_MAX	(BNXT_CTX_KONG + 1)
 #define BNXT_CTX_INV	((u16)-1)
 
 struct bnxt_ctx_mem_info {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
index 18d6c94d5cb82..a0a37216efb3b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
@@ -36,6 +36,7 @@ static const u16 bnxt_bstore_to_seg_id[] = {
 	[BNXT_CTX_CA1]			= BNXT_CTX_MEM_SEG_CA1,
 	[BNXT_CTX_CA2]			= BNXT_CTX_MEM_SEG_CA2,
 	[BNXT_CTX_RIGP1]		= BNXT_CTX_MEM_SEG_RIGP1,
+	[BNXT_CTX_KONG]			= BNXT_CTX_MEM_SEG_KONG,
 };
 
 static int bnxt_dbg_hwrm_log_buffer_flush(struct bnxt *bp, u16 type, u32 flags,
@@ -359,7 +360,7 @@ static u32 bnxt_get_ctx_coredump(struct bnxt *bp, void *buf, u32 offset,
 
 	if (buf)
 		buf += offset;
-	for (type = 0 ; type <= BNXT_CTX_RIGP1; type++) {
+	for (type = 0; type <= BNXT_CTX_KONG; type++) {
 		struct bnxt_ctx_mem_type *ctxm = &ctx->ctx_arr[type];
 		bool trace = bnxt_bs_trace_avail(bp, type);
 		u32 seg_id = bnxt_bstore_to_seg_id[type];
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h
index d1cd6387f3ab4..8d0f58c74cc32 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h
@@ -102,6 +102,7 @@ struct bnxt_driver_segment_record {
 #define BNXT_CTX_MEM_SEG_CA1	0x9
 #define BNXT_CTX_MEM_SEG_CA2	0xa
 #define BNXT_CTX_MEM_SEG_RIGP1	0xb
+#define BNXT_CTX_MEM_SEG_KONG	0xd
 
 #define BNXT_CRASH_DUMP_LEN	(8 << 20)
 
-- 
2.51.0

