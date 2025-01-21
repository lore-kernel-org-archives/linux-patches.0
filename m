Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF781F55F5;
	Tue, 21 Jan 2025 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482102; cv=none; b=rC7Bl2cewg8Whkm2zIYOoPZ413qkNDdu0vYjw+ReiC7uPFevDACpA2s+9IgI5d8nT1pmNxwpwpnjUDYNXeUHpPMSiekNzqdEwtrQwrRj/Du9SzAGAE0+pihWEwmB0w77ML24UfrlZ9j1HzjvBy0e7AP8D+6uRoAr1e2URYopNk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482102; c=relaxed/simple;
	bh=U+F3Tz94q1ZaMs/gD9L67wpU97MEqEAGzI3fHx5VRO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFgmmcvivJ11tuNUFAuLLba9fw2dwvRLfeJWK5/FwqEzDdRieOUYweWTyaQvW83xZVPuO66VsYSEuojxKaENwy0lFvOR5yXawAjcDNGHnGQltPy0iBqn5ti7C8nYe58f7Wi+m9pHqxV7rhZ5CwXEWumPwO+inqkmTMwWpu+CF6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFEMet2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFEMet2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B89C4CEDF;
	Tue, 21 Jan 2025 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482102;
	bh=U+F3Tz94q1ZaMs/gD9L67wpU97MEqEAGzI3fHx5VRO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFEMet2ZMlGMcupZ6YS0A6NeCMwnEXibZJQE1hOuWB2OG+4sIg1g/qktjp2s18d0Y
	 EV3JRdeA4h4t34CK8DG2vYidahhbsicUcEVhwPvIEic/oIepIpCNEjQqAMblMqtfS3
	 JvRpuROfZ3vEDXJiii75mgxxiTmYrubx/eJimU40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Hongguang Gao <hongguang.gao@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 35/72] RDMA/bnxt_re: Fix to export port num to ib_query_qp
Date: Tue, 21 Jan 2025 18:52:01 +0100
Message-ID: <20250121174524.775140460@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hongguang Gao <hongguang.gao@broadcom.com>

[ Upstream commit 34db8ec931b84d1426423f263b1927539e73b397 ]

Current driver implementation doesn't populate the port_num
field in query_qp. Adding the code to convert internal firmware
port id to ibv defined port number and export it.

Reviewed-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Hongguang Gao <hongguang.gao@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241211083931.968831-5-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.h | 4 ++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 1 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.h | 1 +
 4 files changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 13c65ec582568..08da793969ee5 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2220,6 +2220,7 @@ int bnxt_re_query_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 	qp_attr->retry_cnt = qplib_qp->retry_cnt;
 	qp_attr->rnr_retry = qplib_qp->rnr_retry;
 	qp_attr->min_rnr_timer = qplib_qp->min_rnr_timer;
+	qp_attr->port_num = __to_ib_port_num(qplib_qp->port_id);
 	qp_attr->rq_psn = qplib_qp->rq.psn;
 	qp_attr->max_rd_atomic = qplib_qp->max_rd_atomic;
 	qp_attr->sq_psn = qplib_qp->sq.psn;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 98baea98fc176..ef910e6e2ccb7 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -245,6 +245,10 @@ void bnxt_re_dealloc_ucontext(struct ib_ucontext *context);
 int bnxt_re_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 void bnxt_re_mmap_free(struct rdma_user_mmap_entry *rdma_entry);
 
+static inline u32 __to_ib_port_num(u16 port_id)
+{
+	return (u32)port_id + 1;
+}
 
 unsigned long bnxt_re_lock_cqs(struct bnxt_re_qp *qp);
 void bnxt_re_unlock_cqs(struct bnxt_re_qp *qp, unsigned long flags);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 871a49315c880..c4f10498c79d8 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1460,6 +1460,7 @@ int bnxt_qplib_query_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 	qp->dest_qpn = le32_to_cpu(sb->dest_qp_id);
 	memcpy(qp->smac, sb->src_mac, 6);
 	qp->vlan_id = le16_to_cpu(sb->vlan_pcp_vlan_dei_vlan_id);
+	qp->port_id = le16_to_cpu(sb->port_id);
 bail:
 	dma_free_coherent(&rcfw->pdev->dev, sbuf.size,
 			  sbuf.sb, sbuf.dma_addr);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index b5c53e864fbb3..55fd840359ef2 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -297,6 +297,7 @@ struct bnxt_qplib_qp {
 	u32				dest_qpn;
 	u8				smac[6];
 	u16				vlan_id;
+	u16				port_id;
 	u8				nw_type;
 	struct bnxt_qplib_ah		ah;
 
-- 
2.39.5



