Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022995;
	b=NG8y1heLaVW+krFMeIV3HoY86qBybEzZvUKaiFwaXdsWeE1ZTBOfHv6TVRFWb+8vgdHm
	 zjRF1XzuSNeTvW8ImxQcy22d1WcRfP4SUZec6qWxGKljVCgvjLmXZhOAkCUeA3Rj4mh3J
	 WE7InoMCzw6lQevcm0a1reFly3C7X9NHDHUhGeuh1u0fgujf68dISVpvgCTiUo2GMZzeM
	 POOcZkdd4CeQ+2g3+U7T2y25FsUa3SBqS8Ts5T7zU1fIgcDB0zeKDOAlGO3aVYSNwEC9l
	 1nRmRH8Wjwe1DVhEuT7b/RnuG/g5zPHfU+FKNCYUhycB3eREMMumYwV/HsW3wTMplmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t1T/ZrNMU+XGzB6jbQg478zB1SbWyG6Nt+Z7rYRrlFY=;
	b=Omt19wVyQEnfCuapysdGePrfxh37G9RrHh+/DFs6zq9N99a59uvlRPp+PJwyMUICoijB
	 T804Mpn+YSql+uEeQ/IdYIa/ZGQQKRvwJAgdHnpho3/D1FJBSnI82CxHuGv0mff0F0ijj
	 jDp1d7XEWSGCEK5/IOlatbJ0OhmdArRe4JlcegkQKLa+OBFhBwvCVNqoanoFFkGeRamZt
	 bpSNl2cOfLUDqVdynLVmalkpBxp0/4DIvtMOxwHab2JEErisUEDFFBHi38xFQ961b5qFl
	 UsBvtjT7N++rYQlpa3s9u1LC47VSnzaUjfE3QCgSIQlaGFs5eJo8uShC3KQ/hJdqAeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5s6y1B4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54535606A331;
	Wed, 18 Nov 2026 17:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5s6y1B4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA7F1F000C4;
	Wed, 18 Nov 2026 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022995;
	bh=t1T/ZrNMU+XGzB6jbQg478zB1SbWyG6Nt+Z7rYRrlFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5s6y1B48tX/2P/uK04314plHAWTceojVIYh7iW+5zUg22hMBr+UzwrA7/ExK7UsO
	 bz2VVfulC+PkKGrjHtR7Uq4Om/DOXVQsXNKlnXZCZe4TIliEblbTTIUXBGQ0MLgmcL
	 OE1OUIDFfJ5Ov3Iae7yWq+4FaR/FZp4W5f36FHVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0211/2151] RDMA/hns: Fix missing CQE when UD QP use different SL
Date: Wed, 18 Nov 2026 15:32:26 +0100
Message-ID: <20261118150129.467740251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 06832c0ac0556..717e48772901c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -645,6 +645,7 @@ struct hns_roce_qp {
 	u8			priority;
 	spinlock_t flush_lock;
 	struct hns_roce_dip *dip;
+	bool ud_sl_set;
 };
 
 struct hns_roce_ib_iboe {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5512a8084b7c2..2336079daa1e0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -428,7 +428,8 @@ static int set_ud_opcode(struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
 	return 0;
 }
 
-static int fill_ud_av(struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
+static int fill_ud_av(struct hns_roce_qp *qp,
+		      struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
 		      struct hns_roce_ah *ah)
 {
 	struct ib_device *ib_dev = ah->ibah.device;
@@ -438,7 +439,12 @@ static int fill_ud_av(struct hns_roce_v2_ud_send_wqe *ud_sq_wqe,
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
 
@@ -488,12 +494,10 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
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
@@ -5360,6 +5364,7 @@ static void v2_set_flushed_fields(struct ib_qp *ibqp,
 	hr_reg_write(context, QPC_SQ_PRODUCER_IDX, hr_qp->sq.head);
 	hr_reg_clear(qpc_mask, QPC_SQ_PRODUCER_IDX);
 	hr_qp->state = IB_QPS_ERR;
+	hr_qp->ud_sl_set = false;
 	spin_unlock_irqrestore(&hr_qp->sq.lock, sq_flag);
 
 	if (ibqp->srq || ibqp->qp_type == IB_QPT_XRC_INI) /* no RQ */
-- 
2.53.0



