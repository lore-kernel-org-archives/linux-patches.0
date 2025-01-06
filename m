Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564C5145A03;
	Mon,  6 Jan 2025 15:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178880; cv=none; b=UGcoR5U+jSPZ8LDBXy6PeySc2sscn1K4XXT4B1L6nrhPfD/hQ1IcVTJtCR/eN3uUrIc6u4OXA3Ng1SbNjfLJmBrwq1V6xtYX4D/66sNAzCfO0FVZV5DfCka26oBIwa/VWcQypTnkp+T1GheGsj+0kjVbifqXN6SaHYLxWBIOVgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178880; c=relaxed/simple;
	bh=TmCZKh+gJQY2THidZVndLv/RjFUvLRoBnJ36HmgRp2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3aOiCf33osqj2KKwgYg25OodvRusOefElRIkiPkXRqvmvQkPUZAdIi8IceGOoA3Ex+fKPcCCxtmN4cQwVOHqV/U1X39SHH28IqT40UvPWFcuo8RAV7myZ0VhBweX8EaEfabyPT2rJluPk2mgtI5Png10vxzjQLAhY0XRjuaSLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVlpHRry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVlpHRry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71B1C4CED2;
	Mon,  6 Jan 2025 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178880;
	bh=TmCZKh+gJQY2THidZVndLv/RjFUvLRoBnJ36HmgRp2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVlpHRryHXeYs5829+koLe7aRj1NzESlJAmpZBGJGaQjkSFJPqsBiCXBj0cJZ0/aI
	 8WqygtKvzS3sRS3OCRH9A9o7Srg7Doh0ta1LkwenRNIhYw2qI0bny/hnXB2G6InZ86
	 0YJ3YapicmucF8UfAiaoxBWb0uHl1xLX28s+9uaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yixing Liu <liuyixing1@huawei.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/168] RDMA/hns: Remove redundant attr_mask in modify_qp_init_to_init()
Date: Mon,  6 Jan 2025 16:17:11 +0100
Message-ID: <20250106151143.092928226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yixing Liu <liuyixing1@huawei.com>

[ Upstream commit bb4874af19686019d0dafd58726ed7b4058663ca ]

The attr_mask variable is not used in the function,
so remove it.

Link: https://lore.kernel.org/r/20220922123315.3732205-5-xuhaoyue1@hisilicon.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 8673a6c2d9e4 ("RDMA/hns: Fix mapping error of zero-hop WQE buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index c013e96f956e..6fdd563c9b9e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4073,7 +4073,6 @@ static inline int get_pdn(struct ib_pd *ib_pd)
 
 static void modify_qp_reset_to_init(struct ib_qp *ibqp,
 				    const struct ib_qp_attr *attr,
-				    int attr_mask,
 				    struct hns_roce_v2_qp_context *context,
 				    struct hns_roce_v2_qp_context *qpc_mask)
 {
@@ -4137,7 +4136,7 @@ static void modify_qp_reset_to_init(struct ib_qp *ibqp,
 }
 
 static void modify_qp_init_to_init(struct ib_qp *ibqp,
-				   const struct ib_qp_attr *attr, int attr_mask,
+				   const struct ib_qp_attr *attr,
 				   struct hns_roce_v2_qp_context *context,
 				   struct hns_roce_v2_qp_context *qpc_mask)
 {
@@ -4792,11 +4791,9 @@ static int hns_roce_v2_set_abs_fields(struct ib_qp *ibqp,
 
 	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
 		memset(qpc_mask, 0, hr_dev->caps.qpc_sz);
-		modify_qp_reset_to_init(ibqp, attr, attr_mask, context,
-					qpc_mask);
+		modify_qp_reset_to_init(ibqp, attr, context, qpc_mask);
 	} else if (cur_state == IB_QPS_INIT && new_state == IB_QPS_INIT) {
-		modify_qp_init_to_init(ibqp, attr, attr_mask, context,
-				       qpc_mask);
+		modify_qp_init_to_init(ibqp, attr, context, qpc_mask);
 	} else if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR) {
 		ret = modify_qp_init_to_rtr(ibqp, attr, attr_mask, context,
 					    qpc_mask);
-- 
2.39.5



