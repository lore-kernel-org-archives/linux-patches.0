Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709C618410F;
	Wed,  3 Jul 2024 11:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004885; cv=none; b=FxdqIb/BfjXSKhlAbGqW0f1fogtPy6k1JSBbdSnrPi7v73Y9/yixWXdJY6mw6PsYwttXvIVbwbv6XZ2hR/YGz8C3TPKBLOVi4X9nxyvpoiZBJHv48srRDByllWFTWT/ByjIK0v4fGjuVIb1pJGAllixCzQo7zX+Kku61HTYWemI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004885; c=relaxed/simple;
	bh=VwDSSdP3g0SZM1MZQk29wsrIrBen3kQ+SoSgBKyyW9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfEbWcD9fOseJYxEkaJ79UKQXp/B5C8pzvNPqb+n3HB3cCp07WMjbpsnAbCN2fVyJbJ8pDyQTmiZwqirqT2rFcz51CnerlonnUtHSBm6xlEIInuxBY5AkUSqZczW0XGyalguy0DkemsLphSg1uQKfrvJs+UpUkUXCtOluElU3hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4nrJZAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4nrJZAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E412AC2BD10;
	Wed,  3 Jul 2024 11:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004885;
	bh=VwDSSdP3g0SZM1MZQk29wsrIrBen3kQ+SoSgBKyyW9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4nrJZAV2CbcQnZ2Gg7TN8M3ySdC8XlCNmmuafh8mMCWUWhaCu/i6DNQapHl9VMn2
	 YtmtrBVqUTAztv7y8/rStN3ezIAhSzSvfBRT0bbUdQRpfnXDaPGKZW+Zt8NlyG7tiS
	 xuthUQUwt/yA/ZmH2hd/3ox6PQTJp4kQVMd2qROw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/290] dmaengine: ioat: use PCI core macros for PCIe Capability
Date: Wed,  3 Jul 2024 12:38:59 +0200
Message-ID: <20240703102910.148506092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 8f6707d0773be31972768abd6e0bf7b8515b5b1a ]

The PCIe Capability is defined by the PCIe spec, so use the PCI_EXP_DEVCTL
macros defined by the PCI core instead of defining copies in IOAT.  This
makes it easier to find all uses of the PCIe Device Control register.  No
functional change intended.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230307214615.887354-1-helgaas@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: f0dc9fda2e0e ("dmaengine: ioatdma: Fix error path in ioat3_dma_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c      | 6 +++---
 drivers/dma/ioat/registers.h | 7 -------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 6c27980a5ec8f..ed4910e3bc2ac 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1190,13 +1190,13 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
 		ioat_dma->dca = ioat_dca_init(pdev, ioat_dma->reg_base);
 
 	/* disable relaxed ordering */
-	err = pcie_capability_read_word(pdev, IOAT_DEVCTRL_OFFSET, &val16);
+	err = pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &val16);
 	if (err)
 		return pcibios_err_to_errno(err);
 
 	/* clear relaxed ordering enable */
-	val16 &= ~IOAT_DEVCTRL_ROE;
-	err = pcie_capability_write_word(pdev, IOAT_DEVCTRL_OFFSET, val16);
+	val16 &= ~PCI_EXP_DEVCTL_RELAX_EN;
+	err = pcie_capability_write_word(pdev, PCI_EXP_DEVCTL, val16);
 	if (err)
 		return pcibios_err_to_errno(err);
 
diff --git a/drivers/dma/ioat/registers.h b/drivers/dma/ioat/registers.h
index f55a5f92f1857..54cf0ad39887b 100644
--- a/drivers/dma/ioat/registers.h
+++ b/drivers/dma/ioat/registers.h
@@ -14,13 +14,6 @@
 #define IOAT_PCI_CHANERR_INT_OFFSET		0x180
 #define IOAT_PCI_CHANERRMASK_INT_OFFSET		0x184
 
-/* PCIe config registers */
-
-/* EXPCAPID + N */
-#define IOAT_DEVCTRL_OFFSET			0x8
-/* relaxed ordering enable */
-#define IOAT_DEVCTRL_ROE			0x10
-
 /* MMIO Device Registers */
 #define IOAT_CHANCNT_OFFSET			0x00	/*  8-bit */
 
-- 
2.43.0



