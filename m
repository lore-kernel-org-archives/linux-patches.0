Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793576829;
	b=VU32FxraonO+gSzwLVxUjaxlzADx+Q/NEPBeQmmiYaCX+opc8jB9yBcF1s9QdnnZVBqv
	 TFQt/7caU1PzAb553Jlm1jVxHxPGHgTp28Dr/Wg52WilPauwMEj4beu93/CHc7cPgLxUy
	 92FlCu0mmfSEQUEc8iZRV8ZaX10+EjUrbzCmnVYJ2HYXrT+J9ampai2b+DUTFqAOgKxwX
	 oX2Pktu/n7/wI5tEuKgGwhWB2y8vLRWEG+iJYbBsc74L/kOsYXfFmBADz408JT0bAzPp5
	 Riy/xVsp1RdvH+EeHnJ4grQj47tkhhgKdswwmKtGNMSNMczs75y2X1HANzLaVD4K91g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793576829;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DlbTwK82u35GatECwdx50xlJp0xNuQ58zeclGnjbOeg=;
	b=1uLsUm4lEAoWZO8LGrUEQanJB9xOYjW34trGsG9Lfh7aIT4gWGCrTvRD/dbP5mhFNM3J
	 Al67lze1Xqbf6JLNJ4BjRT3oUlh7pVZrgZVdN9YqRmCX57hGHHqOylwlv0RRFVn30XnBX
	 z+ITasP7wFWmZDJuthOLpPOzibcIbFiuwDQ/+H3rJFm+Dl0Hto/ebbRw+H3/JxLkJjWHT
	 FkKkRoNORZsU4zNx+4hMc7vF1ZZU9CsIt2A1Kz95WiefNt3YTqeBXeYQrzrrjc/xrLh3/
	 65lzedJe47fRwqscGkt2dL6IfakKHM1T7NH6DjYHIoHJZxaPLJoEqy2FFHcvBaT1yew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=fJRz9EYn;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A681A606A32F;
	Sun,  1 Nov 2026 23:47:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A681A606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=fJRz9EYn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DlbTwK82u35GatECwdx50xlJp0xNuQ58zeclGnjbOeg=; b=fJRz9EYnlRxG+6TWihFMc5QJSW
	S9PrJP9WguxxSY2gdSKR45IqMLqgUAgiJAxPIjHrWf+ykVa/Dket2QWd0CLDlWZ78VIiOCPw1hk8Q
	hLMQi/ZxSq7/3sM+t6ecPiVRPzTm3I8cfFZO8okWe7NLTxCjxQM6cmRO8CKsx5cYRJ5wJLIx28rj6
	mH2Di6I+ikUlgrcJsc/9VAbXg7vrp7pnCF4WMxHxFRaEJR8t5Is9kNlQlJwL0HZ/RpwjGrQXTEtae
	H0SQjnJmVC65FIf10e0YL01OkFUGJmru5UTiCcLGYAdK68YCtSM6cWPw/ikwoyzhJ8F6a+Qz14Afj
	Mrp0/r2Q==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNfGP-0000000FGD8-3sb5;
	Sun, 01 Nov 2026 23:47:01 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-mips@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-watchdog@vger.kernel.org
Subject: [PATCH v2 7/8] MIPS: Octeon: pci: fix missing function prototype warnings
Date: Sun,  1 Nov 2026 15:46:56 -0800
Message-ID: <20261101234657.1820661-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101234657.1820661-1-rdunlap@infradead.org>
References: <20261101234657.1820661-1-rdunlap@infradead.org>
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
v2: no change

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
