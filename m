Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115CE198E6A;
	Thu,  6 Jun 2024 14:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683426; cv=none; b=Wq7F3b8kwmmRu7r0APTIHZUaI5qXWWOjMW3G/nbPfiCXZ6uDuzEJ0myJ2+yuKNa+ileyxa/D4ZPou/z9Q4UgK8hjiIZdFKgOmfpZId8ivvOD/gfiuFe5QAfo+A41WyzAkjIS/rPjIQWxqcnbQ1zj3JwN3v4h5ljQ2rA1NF9rZs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683426; c=relaxed/simple;
	bh=K7lihtoX1o9JjaGObGa1EwivPSb7oB7A8BdOy/3D+Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT3tBEk6HJ5lQ2X/ZEF6nGf+aAZyrfQHM1BNGfh8XPB6CVXGvQ3Iu/mWhYBvJhw54uTZCA8MRi0GCP7+tUDPjtMZzA+saC4dHKiQi6LLEjA0Rt0lf8LxvEWd6ZHRDHORxcTzQ3qwEItQNhHf0jO/MFECIHzkCOh7ldkCrUAmDew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVUMBErx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVUMBErx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CF6C2BD10;
	Thu,  6 Jun 2024 14:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683426;
	bh=K7lihtoX1o9JjaGObGa1EwivPSb7oB7A8BdOy/3D+Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVUMBErx1GuPpoC7NL1X9JMxMWRAE9sGctkJP/mp9Ee3by3A+BciCEGctV4wc3ed5
	 VT8olmam5YFyx5TjT5Oh/pbb293zeMlNGGFxFVfU/BTAk2iNbGdV9MjUwAexngaYQo
	 8YTorgze9wjYA5tHum4J7uHlVkYfisLediHT9eKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 371/744] RDMA/bnxt_re: Adds MSN table capability for Gen P7 adapters
Date: Thu,  6 Jun 2024 16:00:43 +0200
Message-ID: <20240606131744.392981314@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 07f830ae4913d0b986c8c0ff88a7d597948b9bd8 ]

GenP7 HW expects an MSN table instead of PSN table. Check
for the HW retransmission capability and populate the MSN
table if HW retansmission is supported.

Signed-off-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1701946060-13931-7-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 78cfd17142ef ("bnxt_re: avoid shift undefined behavior in bnxt_qplib_alloc_init_hwq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 67 ++++++++++++++++++++--
 drivers/infiniband/hw/bnxt_re/qplib_fp.h   | 14 +++++
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  2 +
 drivers/infiniband/hw/bnxt_re/qplib_res.h  |  9 +++
 include/uapi/rdma/bnxt_re-abi.h            |  1 +
 5 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 48dcb14004594..b99451b3c10fc 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -980,6 +980,9 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 	u32 tbl_indx;
 	u16 nsge;
 
+	if (res->dattr)
+		qp->dev_cap_flags = res->dattr->dev_cap_flags;
+
 	sq->dbinfo.flags = 0;
 	bnxt_qplib_rcfw_cmd_prep((struct cmdq_base *)&req,
 				 CMDQ_BASE_OPCODE_CREATE_QP,
@@ -995,6 +998,11 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 		psn_sz = bnxt_qplib_is_chip_gen_p5(res->cctx) ?
 			 sizeof(struct sq_psn_search_ext) :
 			 sizeof(struct sq_psn_search);
+
+		if (BNXT_RE_HW_RETX(qp->dev_cap_flags)) {
+			psn_sz = sizeof(struct sq_msn_search);
+			qp->msn = 0;
+		}
 	}
 
 	hwq_attr.res = res;
@@ -1003,6 +1011,13 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 	hwq_attr.depth = bnxt_qplib_get_depth(sq);
 	hwq_attr.aux_stride = psn_sz;
 	hwq_attr.aux_depth = bnxt_qplib_set_sq_size(sq, qp->wqe_mode);
+	/* Update msn tbl size */
+	if (BNXT_RE_HW_RETX(qp->dev_cap_flags) && psn_sz) {
+		hwq_attr.aux_depth = roundup_pow_of_two(bnxt_qplib_set_sq_size(sq, qp->wqe_mode));
+		qp->msn_tbl_sz = hwq_attr.aux_depth;
+		qp->msn = 0;
+	}
+
 	hwq_attr.type = HWQ_TYPE_QUEUE;
 	rc = bnxt_qplib_alloc_init_hwq(&sq->hwq, &hwq_attr);
 	if (rc)
@@ -1585,6 +1600,27 @@ void *bnxt_qplib_get_qp1_rq_buf(struct bnxt_qplib_qp *qp,
 	return NULL;
 }
 
+/* Fil the MSN table into the next psn row */
+static void bnxt_qplib_fill_msn_search(struct bnxt_qplib_qp *qp,
+				       struct bnxt_qplib_swqe *wqe,
+				       struct bnxt_qplib_swq *swq)
+{
+	struct sq_msn_search *msns;
+	u32 start_psn, next_psn;
+	u16 start_idx;
+
+	msns = (struct sq_msn_search *)swq->psn_search;
+	msns->start_idx_next_psn_start_psn = 0;
+
+	start_psn = swq->start_psn;
+	next_psn = swq->next_psn;
+	start_idx = swq->slot_idx;
+	msns->start_idx_next_psn_start_psn |=
+		bnxt_re_update_msn_tbl(start_idx, next_psn, start_psn);
+	qp->msn++;
+	qp->msn %= qp->msn_tbl_sz;
+}
+
 static void bnxt_qplib_fill_psn_search(struct bnxt_qplib_qp *qp,
 				       struct bnxt_qplib_swqe *wqe,
 				       struct bnxt_qplib_swq *swq)
@@ -1596,6 +1632,12 @@ static void bnxt_qplib_fill_psn_search(struct bnxt_qplib_qp *qp,
 
 	if (!swq->psn_search)
 		return;
+	/* Handle MSN differently on cap flags  */
+	if (BNXT_RE_HW_RETX(qp->dev_cap_flags)) {
+		bnxt_qplib_fill_msn_search(qp, wqe, swq);
+		return;
+	}
+	psns = (struct sq_psn_search *)swq->psn_search;
 	psns = swq->psn_search;
 	psns_ext = swq->psn_ext;
 
@@ -1704,8 +1746,8 @@ static u16 bnxt_qplib_required_slots(struct bnxt_qplib_qp *qp,
 	return slot;
 }
 
-static void bnxt_qplib_pull_psn_buff(struct bnxt_qplib_q *sq,
-				     struct bnxt_qplib_swq *swq)
+static void bnxt_qplib_pull_psn_buff(struct bnxt_qplib_qp *qp, struct bnxt_qplib_q *sq,
+				     struct bnxt_qplib_swq *swq, bool hw_retx)
 {
 	struct bnxt_qplib_hwq *hwq;
 	u32 pg_num, pg_indx;
@@ -1716,6 +1758,11 @@ static void bnxt_qplib_pull_psn_buff(struct bnxt_qplib_q *sq,
 	if (!hwq->pad_pg)
 		return;
 	tail = swq->slot_idx / sq->dbinfo.max_slot;
+	if (hw_retx) {
+		/* For HW retx use qp msn index */
+		tail = qp->msn;
+		tail %= qp->msn_tbl_sz;
+	}
 	pg_num = (tail + hwq->pad_pgofft) / (PAGE_SIZE / hwq->pad_stride);
 	pg_indx = (tail + hwq->pad_pgofft) % (PAGE_SIZE / hwq->pad_stride);
 	buff = (void *)(hwq->pad_pg[pg_num] + pg_indx * hwq->pad_stride);
@@ -1740,6 +1787,7 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 	struct bnxt_qplib_swq *swq;
 	bool sch_handler = false;
 	u16 wqe_sz, qdf = 0;
+	bool msn_update;
 	void *base_hdr;
 	void *ext_hdr;
 	__le32 temp32;
@@ -1767,7 +1815,7 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 	}
 
 	swq = bnxt_qplib_get_swqe(sq, &wqe_idx);
-	bnxt_qplib_pull_psn_buff(sq, swq);
+	bnxt_qplib_pull_psn_buff(qp, sq, swq, BNXT_RE_HW_RETX(qp->dev_cap_flags));
 
 	idx = 0;
 	swq->slot_idx = hwq->prod;
@@ -1799,6 +1847,8 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 					       &idx);
 	if (data_len < 0)
 		goto queue_err;
+	/* Make sure we update MSN table only for wired wqes */
+	msn_update = true;
 	/* Specifics */
 	switch (wqe->type) {
 	case BNXT_QPLIB_SWQE_TYPE_SEND:
@@ -1839,6 +1889,7 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 						      SQ_SEND_DST_QP_MASK);
 			ext_sqe->avid = cpu_to_le32(wqe->send.avid &
 						    SQ_SEND_AVID_MASK);
+			msn_update = false;
 		} else {
 			sqe->length = cpu_to_le32(data_len);
 			if (qp->mtu)
@@ -1896,7 +1947,7 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 		sqe->wqe_type = wqe->type;
 		sqe->flags = wqe->flags;
 		sqe->inv_l_key = cpu_to_le32(wqe->local_inv.inv_l_key);
-
+		msn_update = false;
 		break;
 	}
 	case BNXT_QPLIB_SWQE_TYPE_FAST_REG_MR:
@@ -1928,6 +1979,7 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 						PTU_PTE_VALID);
 		ext_sqe->pblptr = cpu_to_le64(wqe->frmr.pbl_dma_ptr);
 		ext_sqe->va = cpu_to_le64(wqe->frmr.va);
+		msn_update = false;
 
 		break;
 	}
@@ -1945,6 +1997,7 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 		sqe->l_key = cpu_to_le32(wqe->bind.r_key);
 		ext_sqe->va = cpu_to_le64(wqe->bind.va);
 		ext_sqe->length_lo = cpu_to_le32(wqe->bind.length);
+		msn_update = false;
 		break;
 	}
 	default:
@@ -1952,8 +2005,10 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 		rc = -EINVAL;
 		goto done;
 	}
-	swq->next_psn = sq->psn & BTH_PSN_MASK;
-	bnxt_qplib_fill_psn_search(qp, wqe, swq);
+	if (!BNXT_RE_HW_RETX(qp->dev_cap_flags) || msn_update) {
+		swq->next_psn = sq->psn & BTH_PSN_MASK;
+		bnxt_qplib_fill_psn_search(qp, wqe, swq);
+	}
 queue_err:
 	bnxt_qplib_swq_mod_start(sq, wqe_idx);
 	bnxt_qplib_hwq_incr_prod(&sq->dbinfo, hwq, swq->slots);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 23c27cb429786..39156cb7b943d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -338,6 +338,9 @@ struct bnxt_qplib_qp {
 	dma_addr_t			rq_hdr_buf_map;
 	struct list_head		sq_flush;
 	struct list_head		rq_flush;
+	u32				msn;
+	u32				msn_tbl_sz;
+	u16				dev_cap_flags;
 };
 
 #define BNXT_QPLIB_MAX_CQE_ENTRY_SIZE	sizeof(struct cq_base)
@@ -626,4 +629,15 @@ static inline u16 bnxt_qplib_calc_ilsize(struct bnxt_qplib_swqe *wqe, u16 max)
 
 	return size;
 }
+
+/* MSN table update inlin */
+static inline uint64_t bnxt_re_update_msn_tbl(u32 st_idx, u32 npsn, u32 start_psn)
+{
+	return cpu_to_le64((((u64)(st_idx) << SQ_MSN_SEARCH_START_IDX_SFT) &
+		SQ_MSN_SEARCH_START_IDX_MASK) |
+		(((u64)(npsn) << SQ_MSN_SEARCH_NEXT_PSN_SFT) &
+		SQ_MSN_SEARCH_NEXT_PSN_MASK) |
+		(((start_psn) << SQ_MSN_SEARCH_START_PSN_SFT) &
+		SQ_MSN_SEARCH_START_PSN_MASK));
+}
 #endif /* __BNXT_QPLIB_FP_H__ */
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 15e6d2b80c700..cfa777fc01316 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -905,6 +905,8 @@ int bnxt_qplib_init_rcfw(struct bnxt_qplib_rcfw *rcfw,
 	req.max_gid_per_vf = cpu_to_le32(ctx->vf_res.max_gid_per_vf);
 
 skip_ctx_setup:
+	if (BNXT_RE_HW_RETX(rcfw->res->dattr->dev_cap_flags))
+		req.flags |= CMDQ_INITIALIZE_FW_FLAGS_HW_REQUESTER_RETX_SUPPORTED;
 	req.stat_ctx_id = cpu_to_le32(ctx->stats.fw_id);
 	bnxt_qplib_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req), sizeof(resp), 0);
 	rc = bnxt_qplib_rcfw_send_message(rcfw, &msg);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.h b/drivers/infiniband/hw/bnxt_re/qplib_res.h
index 3e3383b8a9135..534db462216ac 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.h
@@ -500,6 +500,15 @@ static inline bool _is_ext_stats_supported(u16 dev_cap_flags)
 		CREQ_QUERY_FUNC_RESP_SB_EXT_STATS;
 }
 
+static inline bool _is_hw_retx_supported(u16 dev_cap_flags)
+{
+	return dev_cap_flags &
+		(CREQ_QUERY_FUNC_RESP_SB_HW_REQUESTER_RETX_ENABLED |
+		 CREQ_QUERY_FUNC_RESP_SB_HW_RESPONDER_RETX_ENABLED);
+}
+
+#define BNXT_RE_HW_RETX(a) _is_hw_retx_supported((a))
+
 static inline u8 bnxt_qplib_dbr_pacing_en(struct bnxt_qplib_chip_ctx *cctx)
 {
 	return cctx->modes.dbr_pacing;
diff --git a/include/uapi/rdma/bnxt_re-abi.h b/include/uapi/rdma/bnxt_re-abi.h
index a1b896d6d9405..3342276aeac13 100644
--- a/include/uapi/rdma/bnxt_re-abi.h
+++ b/include/uapi/rdma/bnxt_re-abi.h
@@ -55,6 +55,7 @@ enum {
 	BNXT_RE_UCNTX_CMASK_WC_DPI_ENABLED = 0x04ULL,
 	BNXT_RE_UCNTX_CMASK_DBR_PACING_ENABLED = 0x08ULL,
 	BNXT_RE_UCNTX_CMASK_POW2_DISABLED = 0x10ULL,
+	BNXT_RE_COMP_MASK_UCNTX_HW_RETX_ENABLED = 0x40,
 };
 
 enum bnxt_re_wqe_mode {
-- 
2.43.0



