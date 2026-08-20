Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B508480961;
	Thu, 20 Aug 2026 17:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248025; cv=none; b=C3VABEVzQEOzkoTKJx9OUT7nJX81+NkWIG+o3mKAtPyAKeagwUJPGebKziLI72ku2glBoh2DpQ2xuqUY1NKBh3BjGlj/2l0Nw52lQj35E5EU08aCww4aTgLu+AFxbQEE4WKZJBZjnub079/r9dO+2WwhxHTbWFIv8CYdeKQckns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248025; c=relaxed/simple;
	bh=PBhhC8Tgt8M2wJgQM85Kt6eWGVovxpOK9Pf0Z3hCpto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdVJ4v+LlNeaP/A+XKuww/EfVQGhGXWA7CPpt/GP01rSxNHbV/56bU89OteIdY+FbvtzMAiGrxcnjGDBLA+KyG4AOC37HcDAJF4u01b/I7f7bSFWvovpmVClYVjZQnxvEFM+0vaCJQA0Ua54Fi6MlVsKfqcP8ZobDDmaK7kgf1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QF02m9QZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QF02m9QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3921F000E9;
	Thu, 20 Aug 2026 17:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248024;
	bh=ZWVLIkqBl1dOn5EzRABh+ahLCn3zUHiXDzitB8f+SoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QF02m9QZTXTzok/1trnoqkdIyKZjGScnLxhsns4eUQThQ9l497h1yrcKKhRxVRHQB
	 ZRu9Eaon1ynEnc1/HGN0PSsxmyfXBu0Xd3JzKSO5KTXOVSX+/suxirWj0oFyeR5gcW
	 rrzpwYPWyggp/kxAI0KRJYVbPwX2anMid9a83ypM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/303] octeontx2: Annotate mmio regions as __iomem
Date: Thu, 20 Aug 2026 16:53:40 +0200
Message-ID: <20260820145255.686670893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit d0976b43956ee8c8bd093223df9115bfcf63dfe5 ]

This patch removes unnecessary typecasts by marking the
mbox_regions array as __iomem since it is used to store
pointers to memory-mapped I/O (MMIO) regions. Also simplified
the call to readq() in PF driver by removing redundant type casts.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1749484309-3434-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f918554fb724 ("octeontx2-pf: clear stale mailbox IRQ state before request_irq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c      |   12 ++++++------
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |    3 +--
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2329,7 +2329,7 @@ static inline void rvu_afvf_mbox_up_hand
 	__rvu_mbox_up_handler(mwork, TYPE_AFVF);
 }
 
-static int rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
+static int rvu_get_mbox_regions(struct rvu *rvu, void __iomem **mbox_addr,
 				int num, int type, unsigned long *pf_bmap)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -2354,7 +2354,7 @@ static int rvu_get_mbox_regions(struct r
 				bar4 = rvupf_read64(rvu, RVU_PF_VF_BAR4_ADDR);
 				bar4 += region * MBOX_SIZE;
 			}
-			mbox_addr[region] = (void *)ioremap_wc(bar4, MBOX_SIZE);
+			mbox_addr[region] = ioremap_wc(bar4, MBOX_SIZE);
 			if (!mbox_addr[region])
 				goto error;
 		}
@@ -2377,7 +2377,7 @@ static int rvu_get_mbox_regions(struct r
 					  RVU_AF_PF_BAR4_ADDR);
 			bar4 += region * MBOX_SIZE;
 		}
-		mbox_addr[region] = (void *)ioremap_wc(bar4, MBOX_SIZE);
+		mbox_addr[region] = ioremap_wc(bar4, MBOX_SIZE);
 		if (!mbox_addr[region])
 			goto error;
 	}
@@ -2385,7 +2385,7 @@ static int rvu_get_mbox_regions(struct r
 
 error:
 	while (region--)
-		iounmap((void __iomem *)mbox_addr[region]);
+		iounmap(mbox_addr[region]);
 	return -ENOMEM;
 }
 
@@ -2395,10 +2395,10 @@ static int rvu_mbox_init(struct rvu *rvu
 			 void (mbox_up_handler)(struct work_struct *))
 {
 	int err = -EINVAL, i, dir, dir_up;
+	void __iomem **mbox_regions;
 	void __iomem *reg_base;
 	struct rvu_work *mwork;
 	unsigned long *pf_bmap;
-	void **mbox_regions;
 	const char *name;
 	u64 cfg;
 
@@ -2421,7 +2421,7 @@ static int rvu_mbox_init(struct rvu *rvu
 
 	mutex_init(&rvu->mbox_lock);
 
-	mbox_regions = kcalloc(num, sizeof(void *), GFP_KERNEL);
+	mbox_regions = kcalloc(num, sizeof(void __iomem *), GFP_KERNEL);
 	if (!mbox_regions) {
 		err = -ENOMEM;
 		goto free_bitmap;
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -596,8 +596,7 @@ static int otx2_pfvf_mbox_init(struct ot
 		base = pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM) +
 		       MBOX_SIZE;
 	else
-		base = readq((void __iomem *)((u64)pf->reg_base +
-					      RVU_PF_VF_BAR4_ADDR));
+		base = readq(pf->reg_base + RVU_PF_VF_BAR4_ADDR);
 
 	hwbase = ioremap_wc(base, MBOX_SIZE * pf->total_vfs);
 	if (!hwbase) {


