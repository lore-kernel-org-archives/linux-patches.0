Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617D720C000;
	Wed, 19 Mar 2025 14:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395269; cv=none; b=Id0o30JvPckiEYfe9Jl0GqAjY7t8mFdKC8NcKzTq4bgyIeFMpDj+rX0BAnNZsoX5YyvUCtWUQDxl5s++/ky5ZDHowC46zDWGb3ocdN+wEUvGPkCTc7iugFTfSotf4/XKo+aCZnZTAbuuPpniSdruyx/DwaNxe5oGyfG8uiC8s+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395269; c=relaxed/simple;
	bh=QdB0iYIL9qPniGyYwTVULeQ8DjPtz+pCmuphiLrWx/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9AYRxDsXoYcY9XCOQ+9PiXPSiU9Fpuo3zFsmzCppBNYlyXADeVFW/fSNyKF8NW4ZSIzlzOrBr1n/PjCciE81AB6atGwDDAtnvUjyWPJJX/ml+t4rrlK2yZ3+ROQoU9bBIyGr9rFHAU0yqnSD0fvrRvB1bUEiNpSxGWorMBro5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okVMGAFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okVMGAFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAC9C4CEE8;
	Wed, 19 Mar 2025 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395269;
	bh=QdB0iYIL9qPniGyYwTVULeQ8DjPtz+pCmuphiLrWx/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okVMGAFxEbOg7qKuN7AXIrxaGuP8WnfbDjnCglct4dhFfBS4eaOclJWDsKLy9tUOZ
	 8U7NnNCCELiS/YrIt3i3IJ0irvw75m0c5OhYeCfRx5CLab4EX2wYO4renNUZd5j8WB
	 +l3YoU4bzaXh1ff0RCMMf4qE61suq16kww2Ojjjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Yanteng Si <si.yanteng@linux.dev>,
	Henry Chen <chenx97@aosc.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/166] stmmac: loongson: Pass correct arg to PCI function
Date: Wed, 19 Mar 2025 07:32:07 -0700
Message-ID: <20250319143024.256325011@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

[ Upstream commit 00371a3f48775967950c2fe3ec97b7c786ca956d ]

pcim_iomap_regions() should receive the driver's name as its third
parameter, not the PCI device's name.

Define the driver name with a macro and use it at the appropriate
places, including pcim_iomap_regions().

Cc: stable@vger.kernel.org # v5.14+
Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Yanteng Si <si.yanteng@linux.dev>
Tested-by: Henry Chen <chenx97@aosc.io>
Link: https://patch.msgid.link/20250226085208.97891-2-phasta@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index ee3604f58def5..bdeec098309ab 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -9,7 +9,10 @@
 #include <linux/of_irq.h>
 #include "stmmac.h"
 
+#define DRIVER_NAME "dwmac-loongson-pci"
+
 static int loongson_default_data(struct plat_stmmacenet_data *plat)
+
 {
 	plat->clk_csr = 2;	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
 	plat->has_gmac = 1;
@@ -95,7 +98,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
 			continue;
-		ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
+		ret = pcim_iomap_regions(pdev, BIT(0), DRIVER_NAME);
 		if (ret)
 			goto err_disable_device;
 		break;
@@ -222,7 +225,7 @@ static const struct pci_device_id loongson_dwmac_id_table[] = {
 MODULE_DEVICE_TABLE(pci, loongson_dwmac_id_table);
 
 static struct pci_driver loongson_dwmac_driver = {
-	.name = "dwmac-loongson-pci",
+	.name = DRIVER_NAME,
 	.id_table = loongson_dwmac_id_table,
 	.probe = loongson_dwmac_probe,
 	.remove = loongson_dwmac_remove,
-- 
2.39.5



