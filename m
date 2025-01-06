Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4368634A;
	Mon,  6 Jan 2025 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178889; cv=none; b=E4VB7EjtmE840Y6lqtpQygONAmG24TmwfMnhUAAZTd8Ad8pDT7SrOxUCsMBtkpdrRWhi5uX8H1HBsc5Rlis5aiWvCNjy7jZmZgLcB9S2dQuqq0QayW/i6uF3uIlgErJVCMx11pONmg/72BjTV4Mh4moSjdw9IFnYbQ4ld3/UZug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178889; c=relaxed/simple;
	bh=yPe+RieL9Kf+KopC6Xhg6AB/+FOrusmsKayOLvwlxsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1KOcJWCso/2nqCID68YXovvPWPynIYUuwxN1HyozvXgD0fM4tc2m6iJAMxNiRisJpKWgij28r9+wDYDiCeKEXYinKd2nbY+o/2mUKeS4mBzr0SefuA+Oi3LNNQ1BTa3nfmxqsB8xFVSMQack1Je2/S4M4gX7Qx3ra9sykTVBdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZY4J4iyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZY4J4iyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFECEC4AF0B;
	Mon,  6 Jan 2025 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178889;
	bh=yPe+RieL9Kf+KopC6Xhg6AB/+FOrusmsKayOLvwlxsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZY4J4iyKbTgrAfDhE35a1ZZgk1+X76KA0rwPVrexvlpvLtNSvtpKcES9Qi+w/OxRs
	 qyD7xvwlZKXhxCnEEfxKkETuOuXR4eK75RkR3xSWeOMqlVU7j5f3GOOtSXKsz1hWHU
	 650A7GRD8BEGxI2ar0p+KyVSBb/2Kbovvwj4Yhs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/168] RDMA/hns: Fix warning storm caused by invalid input in IO path
Date: Mon,  6 Jan 2025 16:17:14 +0100
Message-ID: <20250106151143.203864636@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit fa5c4ba8cdbfd2c2d6422e001311c8213283ebbf ]

WARN_ON() is called in the IO path. And it could lead to a warning
storm. Use WARN_ON_ONCE() instead of WARN_ON().

Fixes: 12542f1de179 ("RDMA/hns: Refactor process about opcode in post_send()")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241220055249.146943-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 6fdd563c9b9e..aa0e5076f02a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -459,7 +459,7 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 	valid_num_sge = calc_wr_sge_num(wr, &msg_len);
 
 	ret = set_ud_opcode(ud_sq_wqe, wr);
-	if (WARN_ON(ret))
+	if (WARN_ON_ONCE(ret))
 		return ret;
 
 	ud_sq_wqe->msg_len = cpu_to_le32(msg_len);
@@ -563,7 +563,7 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
 	rc_sq_wqe->msg_len = cpu_to_le32(msg_len);
 
 	ret = set_rc_opcode(hr_dev, rc_sq_wqe, wr);
-	if (WARN_ON(ret))
+	if (WARN_ON_ONCE(ret))
 		return ret;
 
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_SO,
-- 
2.39.5



