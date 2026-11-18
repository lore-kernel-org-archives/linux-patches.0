Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029436;
	b=OVFYGUIhjpsHCthT6vM6JptFBSFnR7Wtub903NMl5wcwoaaIOKxOFHzMdDjI66tknJCx
	 3oXTukHT7GwsEGtq2wG5vxrCJuSMBmn5mlQRyy0OJKbGDWxuDbqcTov1RFdZqRvgnyWBO
	 NZmvJQFFhmGecWK1vV8Syy5G24xBx7tvuyn/aQ2p3napdQ0SVfbvZqusNhphMJT0HEc6l
	 2MlllaItolqw4DnSXQvojt+fgeEWwtOjHNX8tv/USIruAmMxm+E4YfNYeTbBBJtIu2RjM
	 jNUSzNyJUDas3lkrmb6GlF+VzsXCACDlSfnq7PsUMhgCSPiO6HeXMPb/ASjo/6gcHsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YUAv+i4EGgQwCJihdm+Y1JMZOC0Jo5NOWxIGGh9G9bY=;
	b=DORanZ07p19MBOH/cPUd1OEeYrLr3jK2WgnlXfbXYv3/W9VosD/mxCqH5A8LiVtaWxnu
	 dLRTsdOVYtBeN7uIBWmI0vJksI50wlyhqNdwUAMiHAW6tnt9V8aaQXiT7VrHaDH3t7SEE
	 nFb2KlYQ+Ax9AHlwJlBZEteylm+A4xVlmmOfKJYUi9q5vSzwpMs38ve1ug505J5CBU3c0
	 7s4iYykIPTzPGdrWk2V/SYKoiPo9mJexidEPrFSQTz1UAY77RV/gx29X+plv8H4ItrWxE
	 PRtMIwHh+xQKel0wAksvtiUp5Madyr42dWAzIRbKqJ4Kdj4QVNfpgJbiy2LxdBpJc3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zj6oRfV0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14E3606A31C;
	Wed, 18 Nov 2026 19:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zj6oRfV0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4226A1F000C4;
	Wed, 18 Nov 2026 19:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029435;
	bh=YUAv+i4EGgQwCJihdm+Y1JMZOC0Jo5NOWxIGGh9G9bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zj6oRfV05TMJsOCw/7O5BT/uduSwx8BZ9GX3afnvMOsNDXdOU6ISHzj/qjvmRGSsp
	 FIPIDCwQ/pC1WqrC5ZL1MWuTp2zDDE3KTc3Gmhq5kgxQK0kMvMVvkSoSAdXGwUEivM
	 Tyk/WGwUJOL4jXW1iCp8vK2nRU9YflY3v3m8/NE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0322/1756] PCI: xgene: Use managed clock for PCIe controller
Date: Wed, 18 Nov 2026 15:40:49 +0100
Message-ID: <20261118150021.112138241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit b9022584ebbae81f7bbe4a61bd1df0d0a95e1a99 ]

xgene_pcie_init_port() obtains and enables the controller clock manually.
When xgene_pcie_setup() or pci_host_probe() fails, probe returns without
disabling, unpreparing, or releasing the clock. A failed enable also leaves
the clk_get() reference unreleased.

Use devm_clk_get_enabled() so the clock is unwound automatically on probe
failure and device removal.

Fixes: 5f6b6ccdbe1c ("PCI: xgene: Add APM X-Gene PCIe driver")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260802221146.573233-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-xgene.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index 7028d4b6abe6c..e850a3183370b 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -322,18 +322,11 @@ static void xgene_pcie_linkup(struct xgene_pcie *port,
 static int xgene_pcie_init_port(struct xgene_pcie *port)
 {
 	struct device *dev = port->dev;
-	int rc;
 
-	port->clk = clk_get(dev, NULL);
+	port->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(port->clk)) {
 		dev_err(dev, "clock not available\n");
-		return -ENODEV;
-	}
-
-	rc = clk_prepare_enable(port->clk);
-	if (rc) {
-		dev_err(dev, "clock enable failed\n");
-		return rc;
+		return PTR_ERR(port->clk);
 	}
 
 	return 0;
-- 
2.53.0



