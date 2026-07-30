Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D690365A19;
	Thu, 30 Jul 2026 16:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428073; cv=none; b=czNAJ/H/9rNN72mJ/x5JYJnmzj/PLy7enxh8IBU9f2WIiKOAgcFWcvs3XoDWtelQhXo+znMhKgPs1UmbpaJm07p35/47579t69LMLlrJloskax8fQWZsq8NXo+D47DsJPUUVnLqX2M90QW5kZMwcPLF8sGru96UsaGrnWiX8byk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428073; c=relaxed/simple;
	bh=5VTiEAkBGNlr/hmzZftQIlPqoze0ZKWGhRI4teMwG1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWviVCX70FN3fS31AjfTc2Qf22GHO+Ol6NapiLDo8plSQ8l8QYUi4i1U7aD0YGiaCcd9sFTK+w+vQWjaZsovMjVkfMe+lobJNge/5V03wc3yEmzrt/iOyO8xic4U77/76PHpUgyQ7s7ZLV1cLGvSx5aHtpYg/y4zGDm7OeDxVtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctuR2uJb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctuR2uJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3249E1F00A3D;
	Thu, 30 Jul 2026 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428070;
	bh=JuCddbZQXcHfCksvGpMx9tIHN8OMIDIbOd3CUgb4h1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctuR2uJb8xgfXPJ3RvB45Ijf3BLyC2cR3V04w+9DUGbBonLXcPO3WavCLoTrGA/j9
	 eywylrMurS3Pod277u+/yDeezXu4WUkDQIH0tJEEYHq4hm+4l5D1kE5XTd8SGKBNxs
	 u0p/6zgWnXhKhJF5QQs4FrKELlkvCbQnC364j7gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 393/484] octeontx2: Annotate mmio regions as __iomem
Date: Thu, 30 Jul 2026 16:14:50 +0200
Message-ID: <20260730141432.011756617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -2330,7 +2330,7 @@ static inline void rvu_afvf_mbox_up_hand
 	__rvu_mbox_up_handler(mwork, TYPE_AFVF);
 }
 
-static int rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
+static int rvu_get_mbox_regions(struct rvu *rvu, void __iomem **mbox_addr,
 				int num, int type, unsigned long *pf_bmap)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -2355,7 +2355,7 @@ static int rvu_get_mbox_regions(struct r
 				bar4 = rvupf_read64(rvu, RVU_PF_VF_BAR4_ADDR);
 				bar4 += region * MBOX_SIZE;
 			}
-			mbox_addr[region] = (void *)ioremap_wc(bar4, MBOX_SIZE);
+			mbox_addr[region] = ioremap_wc(bar4, MBOX_SIZE);
 			if (!mbox_addr[region])
 				goto error;
 		}
@@ -2378,7 +2378,7 @@ static int rvu_get_mbox_regions(struct r
 					  RVU_AF_PF_BAR4_ADDR);
 			bar4 += region * MBOX_SIZE;
 		}
-		mbox_addr[region] = (void *)ioremap_wc(bar4, MBOX_SIZE);
+		mbox_addr[region] = ioremap_wc(bar4, MBOX_SIZE);
 		if (!mbox_addr[region])
 			goto error;
 	}
@@ -2386,7 +2386,7 @@ static int rvu_get_mbox_regions(struct r
 
 error:
 	while (region--)
-		iounmap((void __iomem *)mbox_addr[region]);
+		iounmap(mbox_addr[region]);
 	return -ENOMEM;
 }
 
@@ -2396,10 +2396,10 @@ static int rvu_mbox_init(struct rvu *rvu
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
 
@@ -2422,7 +2422,7 @@ static int rvu_mbox_init(struct rvu *rvu
 
 	mutex_init(&rvu->mbox_lock);
 
-	mbox_regions = kcalloc(num, sizeof(void *), GFP_KERNEL);
+	mbox_regions = kcalloc(num, sizeof(void __iomem *), GFP_KERNEL);
 	if (!mbox_regions) {
 		err = -ENOMEM;
 		goto free_bitmap;
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -597,8 +597,7 @@ static int otx2_pfvf_mbox_init(struct ot
 		base = pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM) +
 		       MBOX_SIZE;
 	else
-		base = readq((void __iomem *)((u64)pf->reg_base +
-					      RVU_PF_VF_BAR4_ADDR));
+		base = readq(pf->reg_base + RVU_PF_VF_BAR4_ADDR);
 
 	hwbase = ioremap_wc(base, MBOX_SIZE * pf->total_vfs);
 	if (!hwbase) {


