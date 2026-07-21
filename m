Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF630231829;
	Tue, 21 Jul 2026 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659997; cv=none; b=co1jLt65GiyxET6MBmAGR4lNzzEG1hky8eVaSFD2KGqumzcea1PCO1zoZGh2e8oUpOS8Yp3fO20nbidwRhyaqOpRthG7wYhExDrrBjIZ639IRrzoe1rnYJw3A2Az1q8AwTzmfxvVSJLY0LzgqiukrXz7aW+3L6r8vdy4pclEbyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659997; c=relaxed/simple;
	bh=6t/ogE1P6WBEETi8TxEzv64/aqGHQjdZ3Pd3vKPWvxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaH6xNNHax6SR2h97L7cPVoOBwi8oUrJoCr7SS4+ZvIrj+e8Raydavaje1uzonpd134BJseg6TYfZYCcvtWv6ZW4yTjXZDKujo7sIKLrHDzuvt/LcqRIYBF7Zgu82LOHPpWhSZ78876pE+YW3C9GyjfpcHRlcbWi9aqexA96o+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRdrgBm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRdrgBm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BF21F000E9;
	Tue, 21 Jul 2026 18:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659995;
	bh=mhMkfxxOkHapv9GlecrrwSlNNR7aCXTmw5sC6GuNQW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRdrgBm6z7Sa2aOnnBfoY15CFNOmU3OrQtBfDwF45lUXVZJpz8va34f75a1gVs/5/
	 qlhxni5Wsk2ikPR4t7wTQ2cr+EOi2SanJJpgTxqh2OTCyKsuKjJgN80z/QK40mzHSP
	 DfUx7ElU0hii1uxf/g1mZsFiPcJ54m88DAdFOfXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0811/2077] RDMA/bnxt_re: Enable app allocated QPs
Date: Tue, 21 Jul 2026 17:08:04 +0200
Message-ID: <20260721152611.922103389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

[ Upstream commit 47b730054f05a05acd497c138bf3255a5de1a973 ]

The driver supports a new comp_mask: REQ_MASK_FIXED_QUE_ATTR.
The application sets this comp_mask bit in the CREATE_QP ureq
to indicate direct control of the QP. The driver goes through
the required processing for app allocated QPs (previous patches).
Only variable WQE mode is supported for these QPs.

This patch removes an unused comp_mask:
	BNXT_RE_QP_REQ_MASK_VAR_WQE_SQ_SLOTS

Link: https://patch.msgid.link/r/20260519150041.7251-10-sriharsha.basavapatna@broadcom.com
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: dc95931b7e13 ("RDMA/bnxt_re: Add a max slot check for SQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 18 +++++++++++++++---
 include/uapi/rdma/bnxt_re-abi.h          |  2 +-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 0f30e551415945..e97c17727da162 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1697,7 +1697,8 @@ static int bnxt_re_init_qp_attr(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
 				struct ib_qp_init_attr *init_attr,
 				struct bnxt_re_ucontext *uctx,
 				struct bnxt_re_qp_req *ureq,
-				struct bnxt_re_dbr_obj *dbr_obj)
+				struct bnxt_re_dbr_obj *dbr_obj,
+				bool fixed_que_attr)
 {
 	struct bnxt_qplib_dev_attr *dev_attr;
 	struct bnxt_qplib_qp *qplqp;
@@ -1720,6 +1721,13 @@ static int bnxt_re_init_qp_attr(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
 		return qptype;
 	qplqp->type = (u8)qptype;
 	qplqp->wqe_mode = bnxt_re_is_var_size_supported(rdev, uctx);
+	if (fixed_que_attr) {
+		if (qplqp->wqe_mode != BNXT_QPLIB_WQE_MODE_VARIABLE)
+			return -EOPNOTSUPP;
+		if (!ureq->sq_npsn ||
+		    ureq->sq_npsn > roundup_pow_of_two(ureq->sq_slots / 2))
+			return -EINVAL;
+	}
 	qplqp->dev_cap_flags = dev_attr->dev_cap_flags;
 	qplqp->cctx = rdev->chip_ctx;
 	if (init_attr->qp_type == IB_QPT_RC) {
@@ -1904,6 +1912,7 @@ int bnxt_re_create_qp(struct ib_qp *ib_qp, struct ib_qp_init_attr *qp_init_attr,
 	struct bnxt_qplib_dev_attr *dev_attr;
 	struct uverbs_attr_bundle *attrs;
 	struct bnxt_re_ucontext *uctx;
+	bool fixed_que_attr = false;
 	struct bnxt_re_qp_req ureq;
 	struct bnxt_re_dev *rdev;
 	struct bnxt_re_pd *pd;
@@ -1920,7 +1929,8 @@ int bnxt_re_create_qp(struct ib_qp *ib_qp, struct ib_qp_init_attr *qp_init_attr,
 
 	uctx = rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
 	if (udata) {
-		rc = ib_copy_validate_udata_in_cm(udata, ureq, qp_handle, 0);
+		rc = ib_copy_validate_udata_in_cm(udata, ureq, qp_handle,
+						  BNXT_RE_QP_REQ_MASK_FIXED_QUE_ATTR);
 		if (rc)
 			return rc;
 
@@ -1934,6 +1944,8 @@ int bnxt_re_create_qp(struct ib_qp *ib_qp, struct ib_qp_init_attr *qp_init_attr,
 			kref_get(&dbr_obj->usecnt);
 			qp->dbr_obj = dbr_obj;
 		}
+		if (ureq.comp_mask & BNXT_RE_QP_REQ_MASK_FIXED_QUE_ATTR)
+			fixed_que_attr = true;
 	}
 
 	rc = bnxt_re_test_qp_limits(rdev, qp_init_attr, dev_attr);
@@ -1944,7 +1956,7 @@ int bnxt_re_create_qp(struct ib_qp *ib_qp, struct ib_qp_init_attr *qp_init_attr,
 
 	qp->rdev = rdev;
 	rc = bnxt_re_init_qp_attr(qp, pd, qp_init_attr, uctx, &ureq,
-				  dbr_obj);
+				  dbr_obj, fixed_que_attr);
 	if (rc)
 		goto fail;
 
diff --git a/include/uapi/rdma/bnxt_re-abi.h b/include/uapi/rdma/bnxt_re-abi.h
index 4da8cda337dcbd..a4599d7b736aa4 100644
--- a/include/uapi/rdma/bnxt_re-abi.h
+++ b/include/uapi/rdma/bnxt_re-abi.h
@@ -126,7 +126,7 @@ struct bnxt_re_resize_cq_req {
 };
 
 enum bnxt_re_qp_mask {
-	BNXT_RE_QP_REQ_MASK_VAR_WQE_SQ_SLOTS = 0x1,
+	BNXT_RE_QP_REQ_MASK_FIXED_QUE_ATTR = 0x1,
 };
 
 struct bnxt_re_qp_req {
-- 
2.53.0



