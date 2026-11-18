Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048351;
	b=Gw1McYT66EBybbUVJyxivu93EHxs6UUVWSGINatexKgdhCrcNhZimQCQ55zRCSEo9GzR
	 KCw3bCHCn2uGYyEa0U35EW+fPlnzpbtfb7XtxkN5HmTIH7R/vtqcfHHXNHNbDGG5AlU5/
	 s9daQaxl2+hsJE3w5Mv5id/PcnnvSAep5ahqRPFB/d66tGvfeGm8gTS71ZBSXp5zCchn9
	 ZX2XWKH+W4xIou02mmPC6U4VEkkhL+KhsalxdTZ+U2dNJ439jLBegIVNJgDznxMbO7eCY
	 qxGkpSFM9WKpT43raccjWQ7to2LsQ7fHFRFcjtdwK8l5/neyfanDiQB12yTGbYaXh1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LiGDNWvFrK9EA1Iazsj23A78SiGRGDvfE82SAs60xRk=;
	b=sR7bgvdSPIOMfEWrRDzqt5SW5LQ2PvHTCBmt5Xcqb7Buld5B84ADZHQhESjUumUXDvK7
	 wvgzbhhCbb4gqOgb7eNr5q1DN3fsrZqN7Iv6V4ToY5HV2HA5RUKXLsNMGYWWI5lwo637z
	 mK1c8zaicsLaaua4L/94CsH438ZWecJAOCuW+3qvX5c7gSil8UvLVtOXwgtJts1eSQEty
	 EcOhGBJ/Zw4XXHaLEb6z/cENrTLVW9UaQwaDpE3RNOhfHiR1ekASXQ4uUlq/XItZ8IL9u
	 Smxwg+vMJTu1hE/YDgaol9O3NcAPdbg7HzA+vNERBuqNf5KZhSUomYJSlRQ1Wdkw6ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3Th1noD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3292606A320;
	Thu, 19 Nov 2026 00:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3Th1noD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005121F000C5;
	Thu, 19 Nov 2026 00:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048350;
	bh=LiGDNWvFrK9EA1Iazsj23A78SiGRGDvfE82SAs60xRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3Th1noDOsuVHQx/130kwxaPojTQZHOO1LmQRW5joIah34UF5CzeaTd2KSxarzk4k
	 ssdcrZLlqxAmJNNftufjdS9fuK0sq+nTUM+cyNHFaD0RX5t4WnNliMrtP63ni0BXHh
	 uiQn+iXvK3EKpGZzBuI9/OkEpfr4QY76dItwI8Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1963/2857] PCI: dra7xx: Fix clock enable leak on probe failure
Date: Wed, 18 Nov 2026 15:49:57 +0100
Message-ID: <20261118150312.083490315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 768e5d0936d00d663ce2b8c192cc6ab0b61ad461 ]

dra7xx_pcie_probe() enables the optional clock but never disables it
when probing fails afterwards.

Switch to devm_clk_get_optional_enabled(), which disables the clock
automatically on failure.

Fixes: 5af9405397bf ("PCI: dra7xx: Get an optional clock")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260822-dra7xx-v1-1-23e204d5548b@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-dra7xx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-dra7xx.c b/drivers/pci/controller/dwc/pci-dra7xx.c
index 5894a8e685476..f93a602ec4f29 100644
--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -735,15 +735,11 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 	if (!phy)
 		return -ENOMEM;
 
-	dra7xx->clk = devm_clk_get_optional(dev, NULL);
+	dra7xx->clk = devm_clk_get_optional_enabled(dev, NULL);
 	if (IS_ERR(dra7xx->clk))
 		return dev_err_probe(dev, PTR_ERR(dra7xx->clk),
 				     "clock request failed");
 
-	ret = clk_prepare_enable(dra7xx->clk);
-	if (ret)
-		return ret;
-
 	for (i = 0; i < phy_count; i++) {
 		snprintf(name, sizeof(name), "pcie-phy%d", i);
 		phy[i] = devm_phy_get(dev, name);
-- 
2.53.0



