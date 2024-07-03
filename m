Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2096143747;
	Wed,  3 Jul 2024 11:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005853; cv=none; b=t0F5id0bDtwG9PjPntdiB6jvvrST4z+eUnzuSALdVXdK0uuFxozN/X+umVTU1Cg0Oevz2RXgNf0iwwbQJN7oUYAtTn8tPP9DHLGp4O9C/ddUf0fGsKonZHGEUIbBr77kWhKfZSTZ2U9LXpb2Yzns1rUPQ1wkLUa7xmEcaCnza6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005853; c=relaxed/simple;
	bh=m3Iiw+eFEvRQZMDS2FLmuJXq0xYUK7Vn/hrq1GOrSGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6BCr0aDO0fiHTRx77Wi2DRBkcoJuXC5/8QP4XBdxYF245zDdfY0vmljs43CL2MZig9Bau0ikD3l9l1dF359sCFHiPDW+cSTM+OU0C8ApZzIFlW3f89s7GbUnYAS/qtli4ELx4ofSb2jSlpqNKCdmPRrz0ehQlSXPQ0U0SCzLeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JT0eyiEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JT0eyiEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26564C2BD10;
	Wed,  3 Jul 2024 11:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005853;
	bh=m3Iiw+eFEvRQZMDS2FLmuJXq0xYUK7Vn/hrq1GOrSGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JT0eyiEzrcyYK/n6fa4Ugucz1xK+bmaKKnVXXjp8qvNjt/3pSZGqIWOg7xMAWP8cx
	 6uE16wa9UKgJtns/APJj1DeRI6gqt5/OL5mqx9wlqVI3h9MzB3nI5vISChmBxkMIgT
	 227kdkTSzTFbuRkuIsG7mZcp3bU3UJAMXiiW4JvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 211/356] dmaengine: ioat: use PCI core macros for PCIe Capability
Date: Wed,  3 Jul 2024 12:39:07 +0200
Message-ID: <20240703102921.090908204@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



