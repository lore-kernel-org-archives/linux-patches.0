Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DC434EEED;
	Fri, 21 Nov 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732955; cv=none; b=SoaGnklmr7+2sx0C0De4furBw4jwm9H8KfbiskgVvkNJzWA+Zo3VJj7ZXT5tYoN4KcKzcmwlGBIXtkv858r/o1pH4lK9dI+RAS5HsmNOwJ4nEKzibOkW7UL1SSF+ecIo9AD3mcTYfL2uNnIdk7gzB9na2NI2RmnwHA0TUpVJEJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732955; c=relaxed/simple;
	bh=tC6kydH71733yzKfpfdf6ZuXrasNuLcTsmrtaumZVRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Isl6F7/YzRGXSF1VeNtKY2WXo0ytGNDFL85Yc5AWU47Qz8badsbZdC1kxdYb4vR90YThYzNKqxCa+bR57LieWMF+4LcVnkVqfBsSo6rO3Mv2Mpgr0YRPMrKRzvzMZnLVET3+SWQP44t3ILO/pVlO/FDeGQ4iG9uo2QhJVK0b0iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMiDD8Fi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMiDD8Fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C48FC4CEF1;
	Fri, 21 Nov 2025 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732955;
	bh=tC6kydH71733yzKfpfdf6ZuXrasNuLcTsmrtaumZVRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMiDD8Fi+M1eiTkLoWIo9CNSOhnvLxWGneVG28HtJS12btg64zYXYKrufG87Lx4cO
	 53VREaJX1KYMpOTgX5L95UTNsGwL2ZlA2demSNwp6g6fnYmpIXgMjnzAQRPhVMyUjM
	 tyd4HKbFi6POhShWI2l+GgekZMSnHSQGEPQWOqDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/529] RDMA/irdma: Remove unused struct irdma_cq fields
Date: Fri, 21 Nov 2025 14:10:00 +0100
Message-ID: <20251121130241.735820504@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 38cecb28d322e..7243255c224f4 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2115,8 +2115,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 			goto cq_free_rsrc;
 		}
 
-		iwcq->iwpbl = iwpbl;
-		iwcq->cq_mem_size = 0;
 		cqmr = &iwpbl->cq_mr;
 
 		if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
@@ -2131,7 +2129,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 				err_code = -EPROTO;
 				goto cq_free_rsrc;
 			}
-			iwcq->iwpbl_shadow = iwpbl_shadow;
 			cqmr_shadow = &iwpbl_shadow->cq_mr;
 			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
 			cqmr->split = true;
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index 20297a14c9a61..50c2610d1cbfb 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -113,21 +113,15 @@ struct irdma_mr {
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
 	struct completion free_cq;
 	refcount_t refcnt;
 	spinlock_t lock; /* for poll cq */
-	struct irdma_pbl *iwpbl;
-	struct irdma_pbl *iwpbl_shadow;
 	struct list_head resize_list;
 	struct irdma_cq_poll_info cur_cqe;
 	struct list_head cmpl_generated;
-- 
2.51.0



