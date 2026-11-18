Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016413;
	b=EcHgd/hPyn0pYgpHzbAY1dDBaAdjf0m5PW0e0HQmfK2c6r7eHm6UCB2A4o+FNJ34Kh8N
	 ORkQF+WE0GsFVMiBEASmDnlsPS8S3BfIneloOeacC4LYPWarrbKDcj7dz3vQtYg+pt8E/
	 M5DNapH+8TAqFR59a8BxEHsUd5+50T7Neza6HX6BS8ib0gTxslJaH908j8hQgvTyjAtX9
	 NE4Llo4dytf2aO5yqtICBo6JxB4BlgqcFs9MNTalB5UyptNKNlgyghkBsuBm72Ct7G+wY
	 aTfsez/RoKBrA+Te3q8K+Co5DPvY63EqtuFPsJmbOAcw7wRW+xVfQuiMT382P6VB4oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ioQfqoCHqjg2evwOL9gPMAcERPTMMWt4Qirj5jmIUA0=;
	b=rktJXqrl8a3pDtoFMQ4KHB2Jq7s+WGp9TDU2XNr4JMYDC3NcKPh7Pp4I4afXDPhUuTnD
	 zsNLczR4Vn2W+QsNlSO5F0KTKvTiZuz991f8JfqGd9+O4dXOF9M7TRLVhFxAOzkwoj3Og
	 CHxQPVsfurt0BT3yZgJ5schBjAKOrpZArCqTCrWwpfLOAtLfbccJqwtChTcSxc+JWCtkC
	 bjOQJ6lLj6ECSgOpJbk8jSXGBwCDWom4Q57m6sFO9OxlCLqba0c+Azxk9j/RNfs5hYHzg
	 QwC4C9DMDmQrjRq2jqT4J3khi0eXy+/1y1gDNMTwEqPoRnm/HbEaru4NnMshKZuJj9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMWHlrcK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27F060A260B;
	Wed, 18 Nov 2026 15:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMWHlrcK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A61E1F000C4;
	Wed, 18 Nov 2026 15:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016412;
	bh=ioQfqoCHqjg2evwOL9gPMAcERPTMMWt4Qirj5jmIUA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMWHlrcKDvb6wY4Fzl0h+4cbjIUwg1T0SM4p1U9PsCZAUGjP60oWdZZBYTU2jbUTN
	 D2vKVmtPDEeY8fmEqWUjqoQWDnv6Fjv4y+RoyeComVy9CuMKuyYu+t3jJ3Ztz0Ksxs
	 D0rTD9tfDRem1y8ovf/v4IB8sbRYXc54nOpeyv8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0469/2651] phy: hisilicon: hi3670: Fix OF node and device reference leaks
Date: Wed, 18 Nov 2026 15:28:29 +0100
Message-ID: <20261118150304.680041282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7396c601d8747..0b2dc590aa6f7 100644
--- a/drivers/phy/hisilicon/phy-hi3670-pcie.c
+++ b/drivers/phy/hisilicon/phy-hi3670-pcie.c
@@ -569,6 +569,7 @@ static int hi3670_pcie_get_resources_from_pcie(struct hi3670_pcie_phy *phy)
 	}
 
 	pcie_dev = bus_find_device_by_of_node(&platform_bus_type, pcie_port);
+	of_node_put(pcie_port);
 	if (!pcie_dev) {
 		dev_err(dev, "Didn't find pcie device\n");
 		return -ENODEV;
@@ -583,6 +584,7 @@ static int hi3670_pcie_get_resources_from_pcie(struct hi3670_pcie_phy *phy)
 	 * right regmap. So, let's use the named version.
 	 */
 	phy->apb = dev_get_regmap(pcie_dev, "kirin_pcie_apb");
+	put_device(pcie_dev);
 	if (!phy->apb) {
 		dev_err(dev, "Failed to get APB regmap\n");
 		return -ENODEV;
-- 
2.53.0



