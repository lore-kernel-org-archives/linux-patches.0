Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C444B22D799;
	Mon, 10 Mar 2025 17:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627283; cv=none; b=qnX/rMC4Ys1uoxZ6lCd4meKaasogf/NyfagQj4nH/Q+3uRhUpOWhNR289tYGK13+g3Azj8ja7Gn5QyzQ40aw8SI7RzjZwq9OEvgrqJV2PS8D8kbO3MtublMF2RfiD2Np8ylk0zCQIMaO35xfv9C/nbn1bBJAP0jVoJZSpN3Gf9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627283; c=relaxed/simple;
	bh=azNDlZXQsfAsSrPiA0Gk3O8CFd17FdBc0JVyb5op36s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHcJC7ae7Enj97nUP6uWN8NbNe0MJpFN8VUD+tK02AzP/gc/sqsgtXFgTw1Jw86S2n148Dg/gjPvHAKlqOZeoet4BCOZ6v+a1sESszN86wLYYFu9A+Ikw6+2A8hSkZpjXfu9rduGkqDusZtlrfPA9xA/Zc2cJ9MA3xvAU7z/mYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHkYZ/+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHkYZ/+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E581C4CEE5;
	Mon, 10 Mar 2025 17:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627283;
	bh=azNDlZXQsfAsSrPiA0Gk3O8CFd17FdBc0JVyb5op36s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHkYZ/+9v8TJslRBsIpwplrhEvJOTRwbSa57iCog60Y83TY9sgsboOQXrre64LSEK
	 F3Gxi1MMW0TL5ExriNq1xn9n3wFhCv27tw6uaIhrrbUThQLXPrr2I4h+dIXrH/P+V4
	 TjEwGydrUY24b1faXFFhax1gun6FSnsQvZHzo6fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Yanteng Si <si.yanteng@linux.dev>,
	Henry Chen <chenx97@aosc.io>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 075/269] stmmac: loongson: Pass correct arg to PCI function
Date: Mon, 10 Mar 2025 18:03:48 +0100
Message-ID: <20250310170500.714533220@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


