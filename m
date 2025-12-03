Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FCB36BCFE;
	Wed,  3 Dec 2025 16:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779507; cv=none; b=llJLzoQjj6+Q69uuqdNvEdtrFn/Ro7yE4RtTwnr8Ax9tiGdbXZlGIXI5Qzv0BZR0Fx4hUoFgNM1nFTPq+Lh/1qpC6bEZ94pBZWQpo33oW64q1yf3RX2/nJKio3SBBVM5F6HNwpHqvhN4nltUK+Nv4KA8OYuY8mrUNOa0wqGOHjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779507; c=relaxed/simple;
	bh=vpQLAHA0yrRNa84lEdJzd2mX0vvGhxrIBNNYLNqKS9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KT9KZk4CKEuhuY14SCN+SkyWdjDH9zcUtOI1dBxY3bqqkJA3pPL8Ld5TBJ1PHv6x1IlMxnqy1uvrsW1P77QP97RKGYVGbKm2KNP+ZtdcNKlD/WectwNThQkWhYnGb4v5beYB1AGSv7wxawUWNUK7AN0mbQDimUrruZbzyHddTSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjZhXlOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjZhXlOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D746DC116B1;
	Wed,  3 Dec 2025 16:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779507;
	bh=vpQLAHA0yrRNa84lEdJzd2mX0vvGhxrIBNNYLNqKS9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjZhXlORXGE9GDmB0wWXMBZaUcka4q6WaQqZdxUx3kEANCepUT3/rSRxh0+Ba+gnu
	 oehavk8OxgOhV6A0kbjqtOll8Asp+N93T0WAL12pDrcy7eWS414BOOXQRrm5BIkM9P
	 QvwuF4i7UhIOKxV2xKIZvABWqHVCmbLHJD+hyxSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/568] RDMA/irdma: Remove unused struct irdma_cq fields
Date: Wed,  3 Dec 2025 16:24:38 +0100
Message-ID: <20251203152450.818462757@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index baa3dff6faab1..fb02017a1aa63 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2088,8 +2088,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 			goto cq_free_rsrc;
 		}
 
-		iwcq->iwpbl = iwpbl;
-		iwcq->cq_mem_size = 0;
 		cqmr = &iwpbl->cq_mr;
 
 		if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
@@ -2104,7 +2102,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 				err_code = -EPROTO;
 				goto cq_free_rsrc;
 			}
-			iwcq->iwpbl_shadow = iwpbl_shadow;
 			cqmr_shadow = &iwpbl_shadow->cq_mr;
 			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
 			cqmr->split = true;
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index 0bc0d0faa0868..b55d30df96261 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -113,19 +113,13 @@ struct irdma_mr {
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



