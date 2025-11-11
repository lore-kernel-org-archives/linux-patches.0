Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF681C28E;
	Tue, 11 Nov 2025 01:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825158; cv=none; b=htcc+6v0mkQBRhhnkGjppM9NimCuU1Qf5G2SIzlEOXM8sv5f9QbXfcxHhiTBjEl1Zn134EJ6unrRtZ3GQCiTN4BfNx0S/WC/lWUg6eyOYcNovd61ySKwME5XaZCPpdcz6k1tC7Qx+tdRkxBvLwsKOnVGoLf1w42Osis4W1f00V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825158; c=relaxed/simple;
	bh=Y6GEKy8nhdsCfcN13R5xfWoBFacfinpS4k78r9kRnZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIotIjDI3WXQcxMPTOFzY40LrEZTvcQdTrt44pbHaEn3HbnaKLMImu7YgeflrAFfOKDzkawJpQdZ1tbS5Oq5+dP7IlQSJevoa87TMoLjOLyLneJS2FucboxG5pWYwWjcXXfh3Xb6+sINtDXn86WeHy8YzF6mrpJ5WTE8lnhIyKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvcscChu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvcscChu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ED6C4CEF5;
	Tue, 11 Nov 2025 01:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825158;
	bh=Y6GEKy8nhdsCfcN13R5xfWoBFacfinpS4k78r9kRnZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvcscChu7oQ3+j13bbwDT2NRty4xbU8A4NUDv7RwCgJodPhxVGxqZ2CATG8h/eRXp
	 nCdBcefVZMAzZpYHkww9ih6ka6fRt5GlN4s1GxpdWFt+Dx8GoAyg4wYiDnz8lLZr8n
	 SEDuyZ9hjK/dY02dSw4HmZ2O+9O6uT7otPsYps1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 685/849] RDMA/irdma: Remove unused struct irdma_cq fields
Date: Tue, 11 Nov 2025 09:44:15 +0900
Message-ID: <20251111004552.984386120@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index da5a41b275d83..105ffb1764b80 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2116,8 +2116,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 			goto cq_free_rsrc;
 		}
 
-		iwcq->iwpbl = iwpbl;
-		iwcq->cq_mem_size = 0;
 		cqmr = &iwpbl->cq_mr;
 
 		if (rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
@@ -2132,7 +2130,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 				err_code = -EPROTO;
 				goto cq_free_rsrc;
 			}
-			iwcq->iwpbl_shadow = iwpbl_shadow;
 			cqmr_shadow = &iwpbl_shadow->cq_mr;
 			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
 			cqmr->split = true;
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index cfa140b36395a..4381e5dbe782a 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -115,21 +115,15 @@ struct irdma_mr {
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



