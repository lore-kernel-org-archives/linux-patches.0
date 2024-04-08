Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E16A80034;
	Mon,  8 Apr 2024 14:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585131; cv=none; b=SJt0aY6BS/elIxlvtHv6IIFcQ1kDeD3Ts+ZvNWlJVjcgJ1i3CrVwh/yI5i4aMf/rVCAeh0+MnbrZXGNwchVe/01OjPU0C9DfoUA8p5AdL+MqNe2c5ka6GxWmzJpZavJ4+7IwS3NN6bdpowccMFvgMmxz3G6AKIGcjd+SGs04L1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585131; c=relaxed/simple;
	bh=3Dwh6Lo+sO9UBQ2iXDyU6Qss/X1uNzLS5ZJi88Eph8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc6M+o5jAoMNNLiWRC8xdpMF1jYkvPzGCBxu1AzdiJSH2k6e6kx3+lKHyrkr0M6oV+tF/K7J9zC5wH5cPI+U0mXnWNyONi7chJ3x3iDVsXEDgcc8fTq7hQKT12B79vazd6WEWxPeZOGcnlZfkJX/6TBqXX3cNAzhPgcBFttf22g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVWcIPdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVWcIPdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437B7C43390;
	Mon,  8 Apr 2024 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585130;
	bh=3Dwh6Lo+sO9UBQ2iXDyU6Qss/X1uNzLS5ZJi88Eph8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVWcIPdPN26a9znbc/a9BneP1ykwhEUZvKMgkYmZK2PKio2Ndx2OZXo2qbyXqv1hU
	 9zEVtbUN1azFLxUKFm7cR5U+KVPYmXmLzOPiTx+A/wmFmqkGjo0Ixqvc0ovcm7r2+M
	 tGDAKaImM9NAACBDA3bLk9LyzKIfEz//AEH4iXTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 673/690] ata: sata_mv: Fix PCI device ID table declaration compilation warning
Date: Mon,  8 Apr 2024 14:58:59 +0200
Message-ID: <20240408125424.093452081@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3137b83a90646917c90951d66489db466b4ae106 ]

Building with W=1 shows a warning for an unused variable when CONFIG_PCI
is diabled:

drivers/ata/sata_mv.c:790:35: error: unused variable 'mv_pci_tbl' [-Werror,-Wunused-const-variable]
static const struct pci_device_id mv_pci_tbl[] = {

Move the table into the same block that containsn the pci_driver
definition.

Fixes: 7bb3c5290ca0 ("sata_mv: Remove PCI dependency")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_mv.c | 63 +++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index c53633d47bfb3..1c9dde51d456c 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -787,37 +787,6 @@ static const struct ata_port_info mv_port_info[] = {
 	},
 };
 
-static const struct pci_device_id mv_pci_tbl[] = {
-	{ PCI_VDEVICE(MARVELL, 0x5040), chip_504x },
-	{ PCI_VDEVICE(MARVELL, 0x5041), chip_504x },
-	{ PCI_VDEVICE(MARVELL, 0x5080), chip_5080 },
-	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
-	/* RocketRAID 1720/174x have different identifiers */
-	{ PCI_VDEVICE(TTI, 0x1720), chip_6042 },
-	{ PCI_VDEVICE(TTI, 0x1740), chip_6042 },
-	{ PCI_VDEVICE(TTI, 0x1742), chip_6042 },
-
-	{ PCI_VDEVICE(MARVELL, 0x6040), chip_604x },
-	{ PCI_VDEVICE(MARVELL, 0x6041), chip_604x },
-	{ PCI_VDEVICE(MARVELL, 0x6042), chip_6042 },
-	{ PCI_VDEVICE(MARVELL, 0x6080), chip_608x },
-	{ PCI_VDEVICE(MARVELL, 0x6081), chip_608x },
-
-	{ PCI_VDEVICE(ADAPTEC2, 0x0241), chip_604x },
-
-	/* Adaptec 1430SA */
-	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
-
-	/* Marvell 7042 support */
-	{ PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },
-
-	/* Highpoint RocketRAID PCIe series */
-	{ PCI_VDEVICE(TTI, 0x2300), chip_7042 },
-	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
-
-	{ }			/* terminate list */
-};
-
 static const struct mv_hw_ops mv5xxx_ops = {
 	.phy_errata		= mv5_phy_errata,
 	.enable_leds		= mv5_enable_leds,
@@ -4311,6 +4280,36 @@ static int mv_pci_init_one(struct pci_dev *pdev,
 static int mv_pci_device_resume(struct pci_dev *pdev);
 #endif
 
+static const struct pci_device_id mv_pci_tbl[] = {
+	{ PCI_VDEVICE(MARVELL, 0x5040), chip_504x },
+	{ PCI_VDEVICE(MARVELL, 0x5041), chip_504x },
+	{ PCI_VDEVICE(MARVELL, 0x5080), chip_5080 },
+	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
+	/* RocketRAID 1720/174x have different identifiers */
+	{ PCI_VDEVICE(TTI, 0x1720), chip_6042 },
+	{ PCI_VDEVICE(TTI, 0x1740), chip_6042 },
+	{ PCI_VDEVICE(TTI, 0x1742), chip_6042 },
+
+	{ PCI_VDEVICE(MARVELL, 0x6040), chip_604x },
+	{ PCI_VDEVICE(MARVELL, 0x6041), chip_604x },
+	{ PCI_VDEVICE(MARVELL, 0x6042), chip_6042 },
+	{ PCI_VDEVICE(MARVELL, 0x6080), chip_608x },
+	{ PCI_VDEVICE(MARVELL, 0x6081), chip_608x },
+
+	{ PCI_VDEVICE(ADAPTEC2, 0x0241), chip_604x },
+
+	/* Adaptec 1430SA */
+	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
+
+	/* Marvell 7042 support */
+	{ PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },
+
+	/* Highpoint RocketRAID PCIe series */
+	{ PCI_VDEVICE(TTI, 0x2300), chip_7042 },
+	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
+
+	{ }			/* terminate list */
+};
 
 static struct pci_driver mv_pci_driver = {
 	.name			= DRV_NAME,
@@ -4323,6 +4322,7 @@ static struct pci_driver mv_pci_driver = {
 #endif
 
 };
+MODULE_DEVICE_TABLE(pci, mv_pci_tbl);
 
 /**
  *      mv_print_info - Dump key info to kernel log for perusal.
@@ -4495,7 +4495,6 @@ static void __exit mv_exit(void)
 MODULE_AUTHOR("Brett Russ");
 MODULE_DESCRIPTION("SCSI low-level driver for Marvell SATA controllers");
 MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(pci, mv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:" DRV_NAME);
 
-- 
2.43.0



