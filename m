Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5963234F492;
	Wed,  3 Dec 2025 16:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777922; cv=none; b=iq8TFl+47TBvjX2ntix5T9yd/WuZcPG8NQPNLtpCGSCzRsKQq8X93/mkJT+FI/pd2rRVpXWshVliW8LfD8E97bTqsS8+LFvLFH+yizmpBjfGrCD4VdATVOzKnIV7kpTfq+KZOpR5tDfryAuhqJ4kDAPP/sFiinR8zxQT0n9eewM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777922; c=relaxed/simple;
	bh=lFhqOodEK+PKf465591w3nkkpa39q8h2ajMvG7PZTBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifHhQ6+ENh/MmchxOprbzwTsrNsFOxSThUHNICZ7rZKIBtkoJIyRBBoAwe9hZn5Csv9ELWANYvzK3EzUMPWrtjC4QUrDnCLd+GmW3iTy9bHwg2EmwgBeUHqoPACDLNCcdPe/byZ5vjzMvopbrRz5+uOJOfS5oAqXihKtLN7/Y+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9uesgCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9uesgCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA11C4CEF5;
	Wed,  3 Dec 2025 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777922;
	bh=lFhqOodEK+PKf465591w3nkkpa39q8h2ajMvG7PZTBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9uesgCCgBQ6d//93xdX65KCLwJkLZq8wXg4ikDxPKo1ewSVj7DXnNk6hmHPQBkKW
	 3spJE1L5Yuuvj28Q28Y0N60pf9tvmMgZq1Toe7UQ43fDjFg9oW+LpaaKU5gOiRBPCF
	 012BUKhBRkzpLxQ49myOFeYgk+2ZnLgi+5KaETlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/392] RDMA/irdma: Remove unused struct irdma_cq fields
Date: Wed,  3 Dec 2025 16:25:38 +0100
Message-ID: <20251203152420.996248453@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 880245fd029a8f8ee8fd557c2681d077c1b1a959 ]

These fields were set but not used anywhere, so remove them.

Link: https://patch.msgid.link/r/20250923142128.943240-1-jmoroni@google.com
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 5575b7646b94 ("RDMA/irdma: Set irdma_cq cq_num field during CQ create")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 3 ---
 drivers/infiniband/hw/irdma/verbs.h | 6 ------
 2 files changed, 9 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index b2bf147883edb..8896cbf9ec4d0 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2006,8 +2006,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 			goto cq_free_rsrc;
 		}
 
-		iwcq->iwpbl = iwpbl;
-		iwcq->cq_mem_size = 0;
 		cqmr = &iwpbl->cq_mr;
 
 		if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
@@ -2022,7 +2020,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 				err_code = -EPROTO;
 				goto cq_free_rsrc;
 			}
-			iwcq->iwpbl_shadow = iwpbl_shadow;
 			cqmr_shadow = &iwpbl_shadow->cq_mr;
 			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
 			cqmr->split = true;
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index a934c985dbb4d..a74b24429b246 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -107,19 +107,13 @@ struct irdma_mr {
 struct irdma_cq {
 	struct ib_cq ibcq;
 	struct irdma_sc_cq sc_cq;
-	u16 cq_head;
-	u16 cq_size;
 	u16 cq_num;
 	bool user_mode;
 	atomic_t armed;
 	enum irdma_cmpl_notify last_notify;
-	u32 polled_cmpls;
-	u32 cq_mem_size;
 	struct irdma_dma_mem kmem;
 	struct irdma_dma_mem kmem_shadow;
 	spinlock_t lock; /* for poll cq */
-	struct irdma_pbl *iwpbl;
-	struct irdma_pbl *iwpbl_shadow;
 	struct list_head resize_list;
 	struct irdma_cq_poll_info cur_cqe;
 	struct list_head cmpl_generated;
-- 
2.51.0



