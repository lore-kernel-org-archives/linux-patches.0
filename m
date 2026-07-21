Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BF547042F;
	Tue, 21 Jul 2026 18:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656966; cv=none; b=TxmrE45j3Axs2S8etL7f4R31zWOWhWQ2ULU1Rlcl3nQU8LY/5vay493U18+ohUyRhuzv57yQjEq+/9HG4eViUvpNjSkYvtXGUejwg7zvSrakRdo2QQ+3CyyXOL4DcLAyfFA6IwCWFxaIgpZp5XybJUSOH+rI03wy8bryTd0q8ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656966; c=relaxed/simple;
	bh=Jtw2JbOnP5YEqD2paWr6kESAFfungey1PuzYX+r9YTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JC+R33ZpUOcaCkkclr9DYK8WchZPxwSTy4JEla458HNJWkuGusJrw9aswmUeMh50uwtUyBxmxcusNIeIFg+a8u27Y4kL810I3V4GsW1M3GdSB43+ng6SNSAwH+6QcNBuB0t4KMPsn9YnDJVtCi2Eewrdid9wluXLytgHG3BNGgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETR8TvQb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETR8TvQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206541F00A3E;
	Tue, 21 Jul 2026 18:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656965;
	bh=YGcwPQA2m9MFsj5NdnBD5bVd1qNmTCBU+aArnKJa6fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETR8TvQb+QMO7HqQwf4GHBc68V+EsZIm6LXGnVjUilsOPIrani0fH7h2cU/D+ROx2
	 6AQQxf4rt404ijUZHc0Yuv3/htC7JSLPZQ+3U+/iLSVnd3u34xLul66Ob0SU4SNgD4
	 TWXI4RhnXOGjnbTXUSdi/4VP+j9u0LJQ9Mnmemzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0586/1611] PCI: Introduce named defines for PCI ROM
Date: Tue, 21 Jul 2026 17:11:42 +0200
Message-ID: <20260721152528.560299790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 113e86bc58a918f85d250723436a4d541a873358 ]

Convert the magic numbers associated with PCI ROM into named
definitions. Some of these definitions will be used in the second
fix patch.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Link: https://patch.msgid.link/20260508082128.3344255-2-kanie@linux.alibaba.com
Stable-dep-of: 538796b807fc ("PCI: Check ROM header and data structure addr before accessing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/rom.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index e18d3a4383ba6b..d4a141bd148b4b 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -5,13 +5,28 @@
  * (C) Copyright 2004 Jon Smirl <jonsmirl@yahoo.com>
  * (C) Copyright 2004 Silicon Graphics, Inc. Jesse Barnes <jbarnes@sgi.com>
  */
+
+#include <linux/bits.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/pci.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 
 #include "pci.h"
 
+#define PCI_ROM_HEADER_SIZE			0x1A
+#define PCI_ROM_POINTER_TO_DATA_STRUCT		0x18
+#define PCI_ROM_LAST_IMAGE_INDICATOR		0x15
+#define PCI_ROM_LAST_IMAGE_INDICATOR_BIT	BIT(7)
+#define PCI_ROM_IMAGE_LEN			0x10
+#define PCI_ROM_IMAGE_SECTOR_SIZE		SZ_512
+#define PCI_ROM_IMAGE_SIGNATURE			0xAA55
+
+/* Data structure signature is "PCIR" in ASCII representation */
+#define PCI_ROM_DATA_STRUCT_SIGNATURE		0x52494350
+#define PCI_ROM_DATA_STRUCT_LEN			0x0A
+
 /**
  * pci_enable_rom - enable ROM decoding for a PCI device
  * @pdev: PCI device to enable
@@ -91,26 +106,27 @@ static size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom,
 	do {
 		void __iomem *pds;
 		/* Standard PCI ROMs start out with these bytes 55 AA */
-		if (readw(image) != 0xAA55) {
-			pci_info(pdev, "Invalid PCI ROM header signature: expecting 0xaa55, got %#06x\n",
-				 readw(image));
+		if (readw(image) != PCI_ROM_IMAGE_SIGNATURE) {
+			pci_info(pdev, "Invalid PCI ROM header signature: expecting %#06x, got %#06x\n",
+				 PCI_ROM_IMAGE_SIGNATURE, readw(image));
 			break;
 		}
-		/* get the PCI data structure and check its "PCIR" signature */
-		pds = image + readw(image + 24);
-		if (readl(pds) != 0x52494350) {
-			pci_info(pdev, "Invalid PCI ROM data signature: expecting 0x52494350, got %#010x\n",
-				 readl(pds));
+		/* Get the PCI data structure and check its "PCIR" signature */
+		pds = image + readw(image + PCI_ROM_POINTER_TO_DATA_STRUCT);
+		if (readl(pds) != PCI_ROM_DATA_STRUCT_SIGNATURE) {
+			pci_info(pdev, "Invalid PCI ROM data signature: expecting %#010x, got %#010x\n",
+				 PCI_ROM_DATA_STRUCT_SIGNATURE, readl(pds));
 			break;
 		}
-		last_image = readb(pds + 21) & 0x80;
-		length = readw(pds + 16);
-		image += length * 512;
+		last_image = readb(pds + PCI_ROM_LAST_IMAGE_INDICATOR) &
+				   PCI_ROM_LAST_IMAGE_INDICATOR_BIT;
+		length = readw(pds + PCI_ROM_IMAGE_LEN);
+		image += length * PCI_ROM_IMAGE_SECTOR_SIZE;
 		/* Avoid iterating through memory outside the resource window */
 		if (image >= rom + size)
 			break;
 		if (!last_image) {
-			if (readw(image) != 0xAA55) {
+			if (readw(image) != PCI_ROM_IMAGE_SIGNATURE) {
 				pci_info(pdev, "No more image in the PCI ROM\n");
 				break;
 			}
-- 
2.53.0



