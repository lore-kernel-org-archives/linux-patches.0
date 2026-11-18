Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039770;
	b=K3eAs8SudlVJk5fBAkDY4p464E0MXe3d8MXKp9FqfisTGCFBJgIdCNg4KHC0HeQ4NQWr
	 igrzWEQfBxDVBe/ZATjS5OzTFsYsjWkOwtGTNeWRm21XdH9z9+4Qh57xpgGgmEDJ8Bjcz
	 7+BL3KA9Xb7zdxT/sLrPTSUqd63ERH1v2Xlq/W8cAPT5yaDVLImPxS0gR6+75h7ztT0zf
	 WX81DNb2WSHxmsa0kCptJMfVH56PiKSR8BnsRgjkG7GkalNayRF95Kf9nTuupNXG5207g
	 /khMKqyQEn8o2AnuWDMF0JSEXCmAGC+LnPz9tg/toeP5HPfGYo1ZdYse7qxWkMJPIZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eYIjm3JKEJ0eThIYs+HzKdzlCAr9BDl6kp4//Y28h/k=;
	b=ZArcVuVzAAUm0gVn6ev/ow9eOwh4ZV6voVBQEWaMpGXkFCjJTNDCrz1Tbmy92drvj1z7
	 CWKN2FGsZ3V5pKcikLCtSXSptivEfHu0HnrSIG8pHTYEw7MXlONvY+aULz6qAywcx0bX7
	 LlsluYYwT8l+DoVbfNGUDhYZHucC+XAZq5ee1GSB95aCe82iGTuilRKUvq8bS+8bjQ5nY
	 DfSilpxvQVweuduaSw8Nezya7+cUI88Apq90+0AypxgzhLRREMFGCuYEhOOdDREoQDW1P
	 U4iSjO330WItDTnrLu80rLJv4DIwPptmuc/ZgUROiXsgFPji4sjfeLhJSmC0X9qoRmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vYJYh48z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588EE606A31C;
	Wed, 18 Nov 2026 22:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vYJYh48z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE39E1F000C4;
	Wed, 18 Nov 2026 22:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039770;
	bh=eYIjm3JKEJ0eThIYs+HzKdzlCAr9BDl6kp4//Y28h/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYJYh48z9Tq0xA1Z4NJdscvRURSyENiPUTQBnPGrSeJl3uNlozKAAnqXCbrxcSaBf
	 Y8XSB+eQ09Z9fw8PNbTvKhyjBSI9/Ku4B32ptLS1DafyGcNFARyZQVxGYjtNqXRNGs
	 cnS82f251mRh6Ivw4B5zgnrJ5vjUvtOeFAAUZou0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2218/3318] phy: hisilicon: hi3670: Fix OF node and device reference leaks
Date: Wed, 18 Nov 2026 15:47:20 +0100
Message-ID: <20261118150428.437025534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0ac9634b398da..6903148367dfc 100644
--- a/drivers/phy/hisilicon/phy-hi3670-pcie.c
+++ b/drivers/phy/hisilicon/phy-hi3670-pcie.c
@@ -565,6 +565,7 @@ static int hi3670_pcie_get_resources_from_pcie(struct hi3670_pcie_phy *phy)
 	}
 
 	pcie_dev = bus_find_device_by_of_node(&platform_bus_type, pcie_port);
+	of_node_put(pcie_port);
 	if (!pcie_dev) {
 		dev_err(dev, "Didn't find pcie device\n");
 		return -ENODEV;
@@ -579,6 +580,7 @@ static int hi3670_pcie_get_resources_from_pcie(struct hi3670_pcie_phy *phy)
 	 * right regmap. So, let's use the named version.
 	 */
 	phy->apb = dev_get_regmap(pcie_dev, "kirin_pcie_apb");
+	put_device(pcie_dev);
 	if (!phy->apb) {
 		dev_err(dev, "Failed to get APB regmap\n");
 		return -ENODEV;
-- 
2.53.0



