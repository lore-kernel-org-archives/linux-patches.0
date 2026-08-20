Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9710747D443;
	Thu, 20 Aug 2026 16:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243519; cv=none; b=bBLO9sj3HW3eXwVQJWDwQ3HVMq9Dsd0LSxHQtt25J8hn1sJ7Swp1VpiO3Zt0wvU5dicKCxisHEy7HnrZ10dVqe7dlGPyxtoqv43jItEKDEeMRcueJUhd+TKaZmWnpLR+h8BGVLdIsvkk+gmo6GkjnoBQh7XYupp2XVMMshXKgqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243519; c=relaxed/simple;
	bh=JDG9pq4jqaBPPEy9frKkoMr3RNoFNdGb2Uhqeq4Bl7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mas3pVIFPNtAxdVcHSsLtjvrxSWHJAJcYLlIgF2L75ATTceE2xGovKA/0sRlRUUHKjVd1CNLUIYDNMZFR12VwdjdTdz8p5Kgdm6OogX+/hlFPJw48wt2TEXY/hpOVx6ziFreloCtNTc73goSG26i8W3R7AOpx1VPaur9aakOK54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJ7TCQNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJ7TCQNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BA21F000E9;
	Thu, 20 Aug 2026 16:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243518;
	bh=8ijC6D8LynmQAL3vDBHHyBdWIyTcbyL39CiQ6yym+d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pJ7TCQNfzlIerSBtkBDhAHQYcAspJxYztiDI+psAc8ytb+ZRF7Preu5WxhPHfa8ra
	 u1ZFm9/KWpTkgtWI7LfmObhA78aqDhan7r0KUzD7vnJp8tkxSI5sVneu92AzJgmQl4
	 V/hrmKvLI5qgdDbuXnZUIhy5Xjrjk6HsTqMw59aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/272] dmaengine: dw-edma: Remove unused irq field in struct dw_edma_chip
Date: Thu, 20 Aug 2026 16:54:59 +0200
Message-ID: <20260820145234.718746384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 5a0e4529d9aee8ce348f628ad476c9ddb6cf457d ]

The "irq" field of struct dw_edma_chip was never used. Remove it.

Link: https://lore.kernel.org/r/20220524152159.2370739-2-Frank.Li@nxp.com
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-By: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8ffba0171c6b ("dmaengine: dw-edma: Add spinlock to protect DONE_INT_MASK and ABORT_INT_MASK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-pcie.c |    1 -
 include/linux/dma/edma.h           |    2 --
 2 files changed, 3 deletions(-)

--- a/drivers/dma/dw-edma/dw-edma-pcie.c
+++ b/drivers/dma/dw-edma/dw-edma-pcie.c
@@ -231,7 +231,6 @@ static int dw_edma_pcie_probe(struct pci
 	chip->dw = dw;
 	chip->dev = dev;
 	chip->id = pdev->devfn;
-	chip->irq = pdev->irq;
 
 	dw->mf = vsec_data.mf;
 	dw->nr_irqs = nr_irqs;
--- a/include/linux/dma/edma.h
+++ b/include/linux/dma/edma.h
@@ -18,13 +18,11 @@ struct dw_edma;
  * struct dw_edma_chip - representation of DesignWare eDMA controller hardware
  * @dev:		 struct device of the eDMA controller
  * @id:			 instance ID
- * @irq:		 irq line
  * @dw:			 struct dw_edma that is filed by dw_edma_probe()
  */
 struct dw_edma_chip {
 	struct device		*dev;
 	int			id;
-	int			irq;
 	struct dw_edma		*dw;
 };
 


