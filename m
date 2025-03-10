Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF5322D79B;
	Mon, 10 Mar 2025 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626582; cv=none; b=Jh8EyQrbWq4rG+s9lkRmNORpjMlDdtKX6DdA/m61vo9N+MsOxKnoM+BJ5vTMXQoqu4cxZgLnL910+oU9td2Wn68eWQlEh9Aqa4sv5AoDLpBEF+e4hL67n/0O12/iRoMGQSGfyn86wjZz/0R+9HuQE9y8coER1UZA09Va08SQ/R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626582; c=relaxed/simple;
	bh=IGjdUz4y0TbjTmP2f1p7qpBnqJG7zdG7cZVIEqN1kzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptFRkxIbZpi2wh0TdueIAy2Yb8Z3X1qNpZEyxtebjJgYmZczk3xzoWLnCwFonsx4Cz1wBzefyVcCQeCx1KEQjBPfdB+TN/gNNrne7KKDy0sw/Lec+3acVVZKqRaDlfhTPKbhAqTgggkklPUWFdaYm9QltEYLVqNsFGP38+PSt+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNrP1GJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNrP1GJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2EEC4CEE5;
	Mon, 10 Mar 2025 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626581;
	bh=IGjdUz4y0TbjTmP2f1p7qpBnqJG7zdG7cZVIEqN1kzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNrP1GJPAYCj5vBvJQEOYNduF6aQ6yvNAkR/MSdvVaKTQPp5rNKmqOyAfrxZnQIWb
	 bn6QmVg4rISxe9LTH57KHhE0o60vA0yfDhXDMuEz5vJDTK0lTv1FAurQR1efEi0DiY
	 Vp4hYDM/bwBaL62B20brD6Cwl8LvDJQIO0kM2NCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Yanteng Si <si.yanteng@linux.dev>,
	Henry Chen <chenx97@aosc.io>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 010/207] stmmac: loongson: Pass correct arg to PCI function
Date: Mon, 10 Mar 2025 18:03:23 +0100
Message-ID: <20250310170448.173852469@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

commit 00371a3f48775967950c2fe3ec97b7c786ca956d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -11,6 +11,8 @@
 #include "dwmac_dma.h"
 #include "dwmac1000.h"
 
+#define DRIVER_NAME "dwmac-loongson-pci"
+
 /* Normal Loongson Tx Summary */
 #define DMA_INTR_ENA_NIE_TX_LOONGSON	0x00040000
 /* Normal Loongson Rx Summary */
@@ -568,7 +570,7 @@ static int loongson_dwmac_probe(struct p
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
 			continue;
-		ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
+		ret = pcim_iomap_regions(pdev, BIT(0), DRIVER_NAME);
 		if (ret)
 			goto err_disable_device;
 		break;
@@ -687,7 +689,7 @@ static const struct pci_device_id loongs
 MODULE_DEVICE_TABLE(pci, loongson_dwmac_id_table);
 
 static struct pci_driver loongson_dwmac_driver = {
-	.name = "dwmac-loongson-pci",
+	.name = DRIVER_NAME,
 	.id_table = loongson_dwmac_id_table,
 	.probe = loongson_dwmac_probe,
 	.remove = loongson_dwmac_remove,


