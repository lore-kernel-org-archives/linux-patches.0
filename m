Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F26A47F2C2;
	Thu, 20 Aug 2026 16:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244352; cv=none; b=LGp0iSk8Tjsv6t5xDy9/ChVHiM+NfzLRL5E5rbLX3YEtu5SdBm085PDVWt3cXv0+Ghf29/VBqLbyt34amkkjhdtbVWbMVSsTlpERa/Z6221D7OahU0GPk2q09ws3SikiE/3NyPbDcwPno/79F7c3d2egUp3ZRINvD2vrrc7FaO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244352; c=relaxed/simple;
	bh=F6vBGg4Z4BDJt6//DzoO/1fQyeR1kg2t1mFJegl3rf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNk6lCXMthOI2jPjoebTiCjFScNjNeI1H0UJBY9J47zpQiCOe8CoyZyl5IcgJ+Li7ix5dsezXP2YW3CkhrTiUzOS2C0fLlk1E1RjmiAfBa9BDHnipI0Hj1jQZvPJ+Xeay43+1rbGY1IgELP7zEJyU5JYxSCNQ1APDUU/rQ72I6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTtH3ikG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTtH3ikG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8821F00A3D;
	Thu, 20 Aug 2026 16:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244351;
	bh=uvmljgmtpmKw4VSPHuDQmyQn/1pn5XEXLp9SSzbHZ8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KTtH3ikGoVNNNX9oG7I1MGWTC/rOCBMRyhTEd7IGq/G8KhuWFPG7iJc+UxrZSe5Wg
	 6ISPFGRoPDvQMM62Z4n41kIzxFJjVS5yQepPfsBGXsLd6zfsupzViGREXE/sAui99J
	 wP8h8LtyfwcSaigYQxxzT4njEl1Dwre/ny5WgV8Q=
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
Subject: [PATCH 5.10 100/235] dmaengine: dw-edma: Remove unused irq field in struct dw_edma_chip
Date: Thu, 20 Aug 2026 16:55:36 +0200
Message-ID: <20260820145219.490948216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -175,7 +175,6 @@ static int dw_edma_pcie_probe(struct pci
 	chip->dw = dw;
 	chip->dev = dev;
 	chip->id = pdev->devfn;
-	chip->irq = pdev->irq;
 
 	dw->chip = chip;
 	dw->version = pdata->version;
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
 


