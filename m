Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023656;
	b=PesVE2eDEI2QOfQ90QS2TBpA0M8182Zx8nK+RvbxxIXmxqPnN2RDAtmCsYB37ObvjS06
	 DRzKEZNbfqHBf91CG68k3ccP2Ibp4u04b/293c0drymQPg+EJV9j7TCY+ISGWe4GqLMjE
	 OrHxoxfy2G0O7nQ/Es5RahawjQTDldReXpBbnqcA6BBuI8rfBgA/fP2dNf5avJsUBb3R7
	 3yFsExxnNjqinP45tXAiyBrH/migQA8qwwlbNj9uUhbaxMJ2oFnET48VWx1pdp3ARZlpj
	 rduiMWMV7oyZdhSIFjkxlnqyVllBf2OniMbI8ZrNAJS8cdozji7QdKnU5yZw2laXKiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=71SpKyEvUMrzeYJwusB4mwd0VNaqnu78HwaKbUfB36I=;
	b=OXHMAJBQqcikcYbctSlv7C06WFQ6WYu3cRDz9Rx5iYAQC5aosOW1fD7w1EWcOrQjl8Cj
	 0BMMzFBtXGZtVXoPWRGCyyJF5XJsBSCK2j5by013QHZLcDvHuqIOwLRdWVJEmoFplMoTt
	 W8QrAEt5RK3UeUrrpAgtQJeqmK3nGUDdMoNV0h8qkdSz3NcjM463DQrozhKg+8O2Rs1DS
	 vHvFAIqUR2+rWA6J9TXDQC2A3of4g6cfanlLTsV0CJVABOtVG8TiuM/7azr+6v1GaOI+5
	 kSyjfVDt8CrlevJHxswsTSci91Vw/8HSQHsE8hBFRDjNn4qRriGDxTEXNIBP1OcL0YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPRbsH8k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA20606A320;
	Wed, 18 Nov 2026 17:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPRbsH8k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081861F000C4;
	Wed, 18 Nov 2026 17:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023656;
	bh=71SpKyEvUMrzeYJwusB4mwd0VNaqnu78HwaKbUfB36I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPRbsH8kQ5dlVgJGAR5536C+3ZuvKtOPF+zWrh1bhVSswcH4ByciyEmYO1QHOw8yi
	 /2CI47YEjW1RKkp2ZiU+c8jRUZLG6h15QGW2Be8rdRS8jJz+lEAxlmFrBnpNXRCEwu
	 IxMIcOKhhsSLTcfernEGNuDMdDsj8chFGWM4svbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0447/2151] phy: hisilicon: hi3670: Fix OF node and device reference leaks
Date: Wed, 18 Nov 2026 15:36:22 +0100
Message-ID: <20261118150138.317461303@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1499f3d3407f5310731bcdf324387c321258fd75 ]

hi3670_pcie_get_resources_from_pcie() leaks two references:
1) The OF node returned by of_get_child_by_name() is never released.
2) The device returned by bus_find_device_by_of_node() is never put.

Fix both leaks by calling of_node_put() right after
bus_find_device_by_of_node(), and put_device() after dev_get_regmap()
when the temporary pcie_dev reference is no longer needed.

Fixes: 73075011ffff ("phy: HiSilicon: Add driver for Kirin 970 PCIe PHY")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260219163843.1571-1-vulab@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/hisilicon/phy-hi3670-pcie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/hisilicon/phy-hi3670-pcie.c b/drivers/phy/hisilicon/phy-hi3670-pcie.c
index dbc7dcce682b7..35e6342797947 100644
--- a/drivers/phy/hisilicon/phy-hi3670-pcie.c
+++ b/drivers/phy/hisilicon/phy-hi3670-pcie.c
@@ -570,6 +570,7 @@ static int hi3670_pcie_get_resources_from_pcie(struct hi3670_pcie_phy *phy)
 	}
 
 	pcie_dev = bus_find_device_by_of_node(&platform_bus_type, pcie_port);
+	of_node_put(pcie_port);
 	if (!pcie_dev) {
 		dev_err(dev, "Didn't find pcie device\n");
 		return -ENODEV;
@@ -584,6 +585,7 @@ static int hi3670_pcie_get_resources_from_pcie(struct hi3670_pcie_phy *phy)
 	 * right regmap. So, let's use the named version.
 	 */
 	phy->apb = dev_get_regmap(pcie_dev, "kirin_pcie_apb");
+	put_device(pcie_dev);
 	if (!phy->apb) {
 		dev_err(dev, "Failed to get APB regmap\n");
 		return -ENODEV;
-- 
2.53.0



