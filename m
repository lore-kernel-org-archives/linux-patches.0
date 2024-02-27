Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE385143C48;
	Tue, 27 Feb 2024 14:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044197; cv=none; b=Io6Xs0kCwDfZ9p503mcIHwkvnm7UCWykcSdU3wGyHvJDYedPu6p3W9xeTfTjB8TkvLEvPGeNptLHzzU5wrzgRpPNZ86yj4qabHomjUq1kXtK3yDMHRlMUNxBbefaWkE0kbX1o+vOwaHXASL53aPGuLGnQX57KmaO7ztAcEV12WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044197; c=relaxed/simple;
	bh=8mqjDDhN54YoLJmYesWb5+4TcrpQkJao3yA6Bnzyma4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnfIluHOHkAMQoDWZcN1IK2Qm991Wj9Tdc6Q94yJnZdiGS0rcEqQu7UMeg+hKAoRLNe6LNYpspWjwvTFkk2e5DHSkrGwePI8xqXxn4iN/Ii9rg35Ja/+q4SvyU3TS+6x7FvCSngh/Ne1dLF1YVNBxQVxz6nEAXN6a+hKvCLudfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tO05HJHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tO05HJHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD5CC433C7;
	Tue, 27 Feb 2024 14:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044197;
	bh=8mqjDDhN54YoLJmYesWb5+4TcrpQkJao3yA6Bnzyma4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tO05HJHdaKFqJ1DRnpHD1TXMrBP3UJ456Gk61hcxoQugMKZ6bXE0tHzi/rIyfJkPa
	 bXmjrG48GPSLLKs3ujwQNO1CGyruMO1djOybtQHDNFyGoD2Oj/7XRHfxU1E+Q9M7/+
	 08LaBJyDfyf7xCBxPVafbLHcMGN7XwHwmPWIa6Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/122] RDMA/bnxt_re: Return error for SRQ resize
Date: Tue, 27 Feb 2024 14:27:38 +0100
Message-ID: <20240227131601.876372360@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 3687b450c5f32e80f179ce4b09e0454da1449eac ]

SRQ resize is not supported in the driver. But driver is not
returning error from bnxt_re_modify_srq() for SRQ resize.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1705985677-15551-5-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 2a973a1390a4a..a0d7777acb6d4 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1711,7 +1711,7 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 	switch (srq_attr_mask) {
 	case IB_SRQ_MAX_WR:
 		/* SRQ resize is not supported */
-		break;
+		return -EINVAL;
 	case IB_SRQ_LIMIT:
 		/* Change the SRQ threshold */
 		if (srq_attr->srq_limit > srq->qplib_srq.max_wqe)
@@ -1726,13 +1726,12 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 		/* On success, update the shadow */
 		srq->srq_limit = srq_attr->srq_limit;
 		/* No need to Build and send response back to udata */
-		break;
+		return 0;
 	default:
 		ibdev_err(&rdev->ibdev,
 			  "Unsupported srq_attr_mask 0x%x", srq_attr_mask);
 		return -EINVAL;
 	}
-	return 0;
 }
 
 int bnxt_re_query_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr)
-- 
2.43.0



