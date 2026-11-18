Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029104;
	b=vZFa9hB2ri8FFAM1/36IMLzdzLOnqw3cMTeEmFdSfXRE3hnQCiVcg6s6gErf6RIRj6V5
	 cwEBYuDwR/zF5jgJFBm34Gij6a6elS/3zWe05mxCEmB1RsnuuqFkbRfa7eyIfpFbeV4Zb
	 XOaA8fe0Z9h6KfK+CUOApn2r5VACuNcsTs6XEZX+2DZZsL6lm7loCdTc5NfwsHpo2H5Am
	 S9PUHUoorZQYhzxllPhxe6Z91S3bZOUvBN+QL+cgwZPuLCz+zLQOT9SopoVtxr/4xPR0Y
	 bGbUEQ21VqlmffF664pRSZnzZkFNCrBLO3ukr/6hw6a13RSroWj0oy2/MyTt9XsMjYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4MK/0kVuVbBsK+KvKFdVZ2qFVovz9w8x0qUVGk3aZQE=;
	b=FkR7BdGJEysTuDnhLxwxrahRDCZbElB1Awn0CXFCH4bg1+kx/DmM9tIl2Tu53A/1wl2W
	 spvHHfkvxkwtoJTvshurWTcxHBvjSjOJ+Pt492EUdR+FNWyLgZGVzkkxpzpjTUDIimfB1
	 rWRo53ghJ6VXz6Vxcqsdhi2Gudd+Cn+9fStln0JlfW2vQh2YsMcQ8mWJE/INpJuviHlnb
	 ZWxuDuU2sQ5x/Bk2VijY83StEpMJMoZMuE2bWmAr2loaMBgOG6NfbyoRm/D/Jv0zD5SCT
	 psXj1LP6BfFG4l82QK4R25Yn+N1DKKnJoPfTqf0w1YUxiGbKL56eQaLy0gir6OGdm5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hM3E86Pn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43AF606A320;
	Wed, 18 Nov 2026 19:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hM3E86Pn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D4F1F000C4;
	Wed, 18 Nov 2026 19:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029103;
	bh=4MK/0kVuVbBsK+KvKFdVZ2qFVovz9w8x0qUVGk3aZQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hM3E86PnCYXN9fa8FTd2gStAUYM4FF1CJFQJv/7E7O7ii8hY/jXwt0khLsQsgBIxU
	 WqbSob/7Sf3bTEWcZw9JwKHGI8XNtAVCqPIU6qs+mMf6JkdZqkcli3OBdhmyA1NBrg
	 WPdwCfJpVrLzCzqRW+AYxZpcp6yIa/faKTQGNzaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0214/1756] RDMA/hns: Fix missing CQE when UD QP use different SL
Date: Wed, 18 Nov 2026 15:39:01 +0100
Message-ID: <20261118150016.851860568@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 3547f46c31993d41748f0f7936f9d4dc5b5d4b12 ]

Due to the hardware contraint, CQEs may be dropped when a UD QP
sends with multiple SLs. Pin the SL to the value from the first
post_send on the QP to avoid this issue.

Fixes: 66d86e529dd5 ("RDMA/hns: Add UD support for HIP09")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260831020324.3540901-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index e184a715d1661..a825dae5744ce 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -655,6 +655,7 @@ struct hns_roce_qp {
 	u8			priority;
 	spinlock_t flush_lock;
 	struct hns_roce_dip *dip;
+	bool ud_sl_set;
 };
 
 struct hns_roce_ib_iboe {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a54f86468b053..9036593857397 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -425,7 +425,8 @@ static int set_ud_opcode(struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
 	return 0;
 }
 
-static int fill_ud_av(struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
+static int fill_ud_av(struct hns_roce_qp *qp,
+		      struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
 		      struct hns_roce_ah *ah)
 {
 	struct ib_device *ib_dev = ah->ibah.device;
@@ -435,7 +436,12 @@ static int fill_ud_av(struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_HOPLIMIT, ah->av.hop_limit);
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_TCLASS, ah->av.tclass);
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_FLOW_LABEL, ah->av.flowlabel);
-	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_SL, ah->av.sl);
+	if (!qp->ud_sl_set) {
+		qp->sl = ah->av.sl;
+		qp->ud_sl_set = true;
+	}
+
+	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_SL, qp->sl);
 
 	ud_sq_wqe->sgid_index = ah->av.gid_index;
 
@@ -485,12 +491,10 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 			  qp->qkey : ud_wr(wr)->remote_qkey);
 	hr_reg_write(ud_sq_wqe, UD_SEND_WQE_DQPN, ud_wr(wr)->remote_qpn);
 
-	ret = fill_ud_av(ud_sq_wqe, ah);
+	ret = fill_ud_av(qp, ud_sq_wqe, ah);
 	if (ret)
 		return ret;
 
-	qp->sl = to_hr_ah(ud_wr(wr)->ah)->av.sl;
-
 	set_extend_sge(qp, wr->sg_list, &curr_idx, valid_num_sge);
 
 	/*
@@ -5383,6 +5387,7 @@ static void v2_set_flushed_fields(struct ib_qp *ibqp,
 	hr_reg_write(context, QPC_SQ_PRODUCER_IDX, hr_qp->sq.head);
 	hr_reg_clear(qpc_mask, QPC_SQ_PRODUCER_IDX);
 	hr_qp->state = IB_QPS_ERR;
+	hr_qp->ud_sl_set = false;
 	spin_unlock_irqrestore(&hr_qp->sq.lock, sq_flag);
 
 	if (ibqp->srq || ibqp->qp_type == IB_QPT_XRC_INI) /* no RQ */
-- 
2.53.0



