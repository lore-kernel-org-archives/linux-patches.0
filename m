Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9246A4302F8;
	Tue, 21 Jul 2026 19:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662481; cv=none; b=I6ob3KBDNc6PxZk7TCwYn/0vXbq1Euc7WgoTzOQikFO31JabNCzpl3ubFFNe7RyFYo+A2ekJ3kcLDqoh9x/GnTWOzjx3+az7du74qAKRnNbLJ6g23/TSxU+9hSvaIMwOd5HoeAh+4Bk8nWaSLur2Ue5NhpbNY9dbzxDA+h90Bhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662481; c=relaxed/simple;
	bh=LkVH7UcPy1tP9YNkKHloAo0C2BH1mYwKNvOctBnenvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUYn6otiqo/6Bxl+6oL4Bx24TdDkcx+UMIU8U+FjYMSdX20dsL4BWYKoaVwFqkcMXQzizchubE1fRQTY6O7Y/L+AgQT6Z6Wco7QrbROUqvkvjcFis1WmQuu+JM4m3xKI27y4i2GdCIExwtOdVaZpnoDOxhCu/WsOLprocKud55w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONk45nK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONk45nK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045A31F000E9;
	Tue, 21 Jul 2026 19:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662480;
	bh=gGtPPB7Sb7G+9Niac2pVQhAENI2IBH553qgwx1vkcnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONk45nK/p4YgTRViOuFMxmC+mjutWA9LwYPEbQ2nDQfJUI5rB6HKTCH4mNUtLDPMJ
	 xkbDpi+VmlyAIxUmczpiaDyljoAvdz9a5TltAh4UxL2ruJTN5ZJ2UUfSMbwDDufjZI
	 fUyvHXbA44wyYOGgDyHqWV9BZIJKbAUlfVSHOs0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0418/1276] PCI: Introduce named defines for PCI ROM
Date: Tue, 21 Jul 2026 17:14:21 +0200
Message-ID: <20260721152455.454369770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



