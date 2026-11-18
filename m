Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023830;
	b=xqOzvruNllGO61u49LPkRO4+0F4uFOuwhXEiBNUePQctksuwa9cy0FrwFNxJoUPn6WLm
	 5ozdZ3wqb1q+QMEIL3m1/tjUf0Uj3reGHWwDKMkdq/gTm/Lj0bYqcDRxLYOP30rlrA7ft
	 fDZ2ImqmLNsFO9CroVAerFbfHOa9TOwTLhXGA4YOpeNIijSme94LfrTDcPNgmRxR+hrOg
	 RvGkZ00NPWKme6wYoHOYgmvhQgsyib/Gzj/pxet+6/0ThIQiUwXYf7ukN1GKMdQKEkjl3
	 jVkql4EklphFB+VXpoymp1P+2C09m8eLLszP+whOPAEPhKFHUrE5udVoFlScFJn2tJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p7kxlQzpP3Tox4L5njrapyCdMJSsF9kKBUzjN91rt9k=;
	b=46YkzEwhe5JHgmrkd5mFowWfncSYFq+rqRlE5JFxtNBjciGvZq9P0yjTihl9Fgg5+AxG
	 b+u4OTSmDc+w6wV99ZAw9OzkEhn+QUgKz99zQg4gwtOOXB81z5UOn6dLmTslZKHPg9t4E
	 BQ7Ou/S0RoLgqeOV5tsdOsLmwouaBi6ezUrKlCvI8l+yQ42HGsNasoa3ZuYzuDwh2J9UB
	 xUsWH1heyBz7btmLj0XqQudW8qMV3f3kNHY0wemfg2Pq7IX/wQJvbXiH80CR78IpsRI0g
	 dhtj8B+ptkHDQCDsBtV1nGiApzcmHiasTacFxi3j+qIlAsD2i9Se7OrsFrOe4hMaB1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6aqOPb1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ED460A2602;
	Wed, 18 Nov 2026 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f6aqOPb1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FC51F000C5;
	Wed, 18 Nov 2026 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023829;
	bh=p7kxlQzpP3Tox4L5njrapyCdMJSsF9kKBUzjN91rt9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6aqOPb1j/UEngUsZbCgZy/8f97/ns/uO/+IjI/dLDUJVoLc4bYJOiA/m2O4h8nqF
	 XioTTHWGIFy0Um73iauX1ZtWnW0Mw6O6FZyknkbyGOGmwX1MmGK3gOZ/g0b2jF+Xh6
	 cLEhI1roHdncAxJCy1RfgTNExERIUUBP061yrAV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0508/2151] PCI: dra7xx: Fix clock enable leak on probe failure
Date: Wed, 18 Nov 2026 15:37:23 +0100
Message-ID: <20261118150140.556647085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8f325409d7b05..aef500fec3e96 100644
--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -728,15 +728,11 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
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



