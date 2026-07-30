Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9376D41DED0;
	Thu, 30 Jul 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426648; cv=none; b=EfiqU5JxERn5n/fCc7FmVBv6QJ+SkCuU5N55ZE4vu6E8pAMBy3fHSduyQsbiOrAXE4ZDKe2g8KyTo4wVTixVDve/AVA62XNwbsLWs1ik3C/HUIWcW+Upv+lkGtR05ggj5X27wvpezf2KI4cCAcYGH/Lgf7HLnRKJG4Ae4aIKvIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426648; c=relaxed/simple;
	bh=8fewv2T2aMT8QKmgNh4ceBOYuA/UTmBU1/XzjLA+Sns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYp1yPJemrj7WgQVAjv56Af1RaGkzbUKImD7K905hqY1Gp2TLZLlqt7USYCvJP0KLmoE8YCnX4PKez0in4dPLkfhMycL0hyB3ilgmFNk02ofBXa0pkGSkrn0En4W+dFiQciBhA/1bj251PI60PyDvdGoAbkhNrSnTuJakiIUswI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpTBLBzL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpTBLBzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB9B1F000E9;
	Thu, 30 Jul 2026 15:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426647;
	bh=Y88XW5vRfY3rPR4XOQyVU++odwAeS62Kz06MDLqlgFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpTBLBzLweDNizKBK7YubqjGrwna7zCBsnPmRxcbUHDQ/Z3d6Dc6QSnpPQAd5qDXL
	 lfdQQsLu7y3fuJ4I6PJ0V+YkgDZjcfuDnW/9t0maq3mtcVAl/2SZdh2pv5QRuk6cIF
	 isNFARCEQHWr3u+0cn2V9RfnRtC0obhU4EgeF25g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 493/602] octeontx2: Annotate mmio regions as __iomem
Date: Thu, 30 Jul 2026 16:14:45 +0200
Message-ID: <20260730141446.329151604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 0b352f04b9be ("octeontx2-vf: clear stale mailbox IRQ state before request_irq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c      |   12 ++++++------
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |    3 +--
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2401,7 +2401,7 @@ static inline void rvu_afvf_mbox_up_hand
 	__rvu_mbox_up_handler(mwork, TYPE_AFVF);
 }
 
-static int rvu_get_mbox_regions(struct rvu *rvu, void **mbox_addr,
+static int rvu_get_mbox_regions(struct rvu *rvu, void __iomem **mbox_addr,
 				int num, int type, unsigned long *pf_bmap)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -2426,7 +2426,7 @@ static int rvu_get_mbox_regions(struct r
 				bar4 = rvupf_read64(rvu, RVU_PF_VF_BAR4_ADDR);
 				bar4 += region * MBOX_SIZE;
 			}
-			mbox_addr[region] = (void *)ioremap_wc(bar4, MBOX_SIZE);
+			mbox_addr[region] = ioremap_wc(bar4, MBOX_SIZE);
 			if (!mbox_addr[region])
 				goto error;
 		}
@@ -2449,7 +2449,7 @@ static int rvu_get_mbox_regions(struct r
 					  RVU_AF_PF_BAR4_ADDR);
 			bar4 += region * MBOX_SIZE;
 		}
-		mbox_addr[region] = (void *)ioremap_wc(bar4, MBOX_SIZE);
+		mbox_addr[region] = ioremap_wc(bar4, MBOX_SIZE);
 		if (!mbox_addr[region])
 			goto error;
 	}
@@ -2457,7 +2457,7 @@ static int rvu_get_mbox_regions(struct r
 
 error:
 	while (region--)
-		iounmap((void __iomem *)mbox_addr[region]);
+		iounmap(mbox_addr[region]);
 	return -ENOMEM;
 }
 
@@ -2467,10 +2467,10 @@ static int rvu_mbox_init(struct rvu *rvu
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
 
@@ -2493,7 +2493,7 @@ static int rvu_mbox_init(struct rvu *rvu
 
 	mutex_init(&rvu->mbox_lock);
 
-	mbox_regions = kcalloc(num, sizeof(void *), GFP_KERNEL);
+	mbox_regions = kcalloc(num, sizeof(void __iomem *), GFP_KERNEL);
 	if (!mbox_regions) {
 		err = -ENOMEM;
 		goto free_bitmap;
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -593,8 +593,7 @@ static int otx2_pfvf_mbox_init(struct ot
 		base = pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM) +
 		       MBOX_SIZE;
 	else
-		base = readq((void __iomem *)((u64)pf->reg_base +
-					      RVU_PF_VF_BAR4_ADDR));
+		base = readq(pf->reg_base + RVU_PF_VF_BAR4_ADDR);
 
 	hwbase = ioremap_wc(base, MBOX_SIZE * pf->total_vfs);
 	if (!hwbase) {


