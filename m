Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378827;
	b=lCwm+WWaw/dsdkcHwWPuIjdLCLbtzKNDgawTuQLCAnG0NBvX5XX/QkZKq7PANRs3RAU2
	 EMbO2Ui4gRB5tSC6aGgtQtD9BaDE9Z2Xs79YBPpAELO5Agx3oGfY/y/qc7XNes/Gc2YF/
	 qzNNq+rVNt/hxr9h3wyTLDnd7/cU3kBVAVDRBp9lP1i57BhRTOEQV24AtQ7/LUmE8t8pX
	 s4OBhPwXQd59jeJBoWeButwaHw0qZkN4/bKFvneAPknnyjF2H6sw6MMzbaDguXr4wH1MU
	 V22NHWbDw/6x/vyjjPv/aLh2R35DzhkHql1WI80wAGWwwJa2JAPh/vlXJmLRgTXCY9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378827;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mY5PvwJKwFmptWdKvfQLtKhWBG7XaqgROKtzg4HO8Gk=;
	b=lkTL+Sv38IXMCpkPnR2GtOElJohdc2vbJni6JueSDnhvuwK2bILufu7Mq1Zs+pyXrrEV
	 J4Qu3SxDawBb8Yvbo80MlVayYfse/4MBhmsztQldy027rK312uzl2WQgoO6YBA7GHL6Oy
	 0z8sGijiMQLVoSoNNOMzZ4qHFa2wNSz1HH0MBoNsIqUR15YN+GRzv46Y2heEL2VibSa9S
	 vxSvD6R8mtnNtWe+O3VEH00qMoa+LmrJSmMvwEq7cjVLtxiaDFDMPnQX1yfMKyIEmRz0v
	 spagFsy+9sRh+Pbz9oH4szntTUMo7J6Aq1YYN2nFfcRAiDDqWh0ILe0DMd6j8Dl8iww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dHpyzwoW;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AA1606A322;
	Fri, 30 Oct 2026 16:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82AA1606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dHpyzwoW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mY5PvwJKwFmptWdKvfQLtKhWBG7XaqgROKtzg4HO8Gk=; b=dHpyzwoWsOJRgypIJvn5IQREZO
	9QCrGB9mJLBLVsAfAygFQOwixJPFfbiwjvMn0b4Wb4ntChwrmiSoO9M0Bh/KVpqCYB8zaYuRAXMOH
	3XlrtK5LuSiAb2pGiqo58sFffT034F3GRIK0FI1/XxWGxXnrjb3nNCPlIzbbeJ0FD16eMNx90qvZl
	YpKbL/503ZdIVGl34/6ToVtemfsuCDJa7xLFm3dHMFABwqHrSf9EedO7FsX+3lrOAiWFxBBXxhh3P
	Ks2pNx9e1iOqG/Ozo+1457TWuNarYeEpmwNseVFV/6Xxzm+c6fWtPU74rrLTXoWwRxuRhTs5xrFSh
	7Z+NGVUw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMpkq-0000000C9vQ-1R0Q;
	Fri, 30 Oct 2026 16:47:00 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH 7/8] MIPS: Octeon: pci: fix missing function prototype warnings
Date: Fri, 30 Oct 2026 09:46:56 -0700
Message-ID: <20261030164657.2808262-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030164657.2808262-1-rdunlap@infradead.org>
References: <20261030164657.2808262-1-rdunlap@infradead.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The octeon_pci[e]_pcibios_map_irq() functions are not used outside of
their source files, so they can be static to eliminate build warnings:

arch/mips/pci/pci-octeon.c:234:12: warning: no previous prototype for 'octeon_pci_pcibios_map_irq' [-Wmissing-prototypes]
  234 | int __init octeon_pci_pcibios_map_irq(const struct pci_dev *dev,
arch/mips/pci/pcie-octeon.c:1471:5: warning: no previous prototype for 'octeon_pcie_pcibios_map_irq' [-Wmissing-prototypes]
 1471 | int octeon_pcie_pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org

 arch/mips/pci/pci-octeon.c  |    2 +-
 arch/mips/pci/pcie-octeon.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20261028.orig/arch/mips/pci/pcie-octeon.c
+++ linux-next-20261028/arch/mips/pci/pcie-octeon.c
@@ -1468,7 +1468,7 @@ static int cvmx_pcie_rc_initialize(int p
  *		 as it goes through each bridge.
  * Returns Interrupt number for the device
  */
-int octeon_pcie_pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+static int octeon_pcie_pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	/*
 	 * The EBH5600 board with the PCI to PCIe bridge mistakenly
--- linux-next-20261028.orig/arch/mips/pci/pci-octeon.c
+++ linux-next-20261028/arch/mips/pci/pci-octeon.c
@@ -231,7 +231,7 @@ const char *octeon_get_pci_interrupts(vo
  *		 as it goes through each bridge.
  * Returns Interrupt number for the device
  */
-int __init octeon_pci_pcibios_map_irq(const struct pci_dev *dev,
+static int __init octeon_pci_pcibios_map_irq(const struct pci_dev *dev,
 				      u8 slot, u8 pin)
 {
 	int irq_num;
