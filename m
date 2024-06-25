Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DE714A09F;
	Tue, 25 Jun 2024 10:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309632; cv=none; b=AYNVh++lIOw8i+CiIIfS5taUWSgD7hzvohgmkpXc6nIZlG9YJQ54J+lieD8X/mihRaIgm8+6kxgDPGVAqVsygAdDe+bObOUeDaeGkQHLg7q9ApnNPBz/qvakeSpm8htsdqMgNUczhK/IZoiqFk4MD2P7xaioyFeCFyZknzEOLDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309632; c=relaxed/simple;
	bh=Js4CFy1RJrhG5qw2JCR+m/6gT3lm7F0KEGR7Nlc0nq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GckZ4ZXG5Ht7yU+6Cyb+iaPB9+ZOvzg6VZCNsXv4EyRnxToDsVmhsW0YBMbc5lMXV9IcKQMsX8wMU9pFSYVNA8gTA7VFtOlSxRIsuQHpHrTTcI5yLRc41HdkzaGfsDgbOJPxjPMq7ILYbAAgt7nyEXJp+Aj47uEL1oTopccpHuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQdnDNap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQdnDNap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47713C4AF0E;
	Tue, 25 Jun 2024 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309632;
	bh=Js4CFy1RJrhG5qw2JCR+m/6gT3lm7F0KEGR7Nlc0nq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQdnDNapXXjfY6Q5wAm79lu/aH9+mxzovnaOGrwbvFKw0HraKQhPe5XNngkE8et4+
	 g6U6RiYU2dVcL6NTQX9EdW4XfOUIhP4vcRfASWufqPM9EhEAJclBC2RffZQUPiAw6c
	 2CXPdF2pKs10WUbirNqnthoNlGYif/CwnRYhdTog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/131] dmaengine: ioat: use PCI core macros for PCIe Capability
Date: Tue, 25 Jun 2024 11:33:57 +0200
Message-ID: <20240625085529.059067601@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 79dcd2061b023..fc9580761825f 100644
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



