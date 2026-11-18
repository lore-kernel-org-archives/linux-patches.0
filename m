Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048345;
	b=1vENvHHlKdBsiHuZF+KNyO83Lc5GhsGc8iMX2u1CXTVavi55Mygfodoid9xAyFOjuy6Z
	 gPZlSju5U/vcxSU0TdnPVBxGsjK5rHImFEAFnVng+HAN2be6WAVpAu4FRG47lpxCeTqO/
	 7Sch8yv4SktVkhSegxJLqa9J015jTZLmN3zkK41ACgI+qwAsvwAembLVcBgJrkWuXydP2
	 kL0zGmz6xmCENkEcxI0gEC3qZd/e0yHO+qkMc8AuH97r5nI6FbPSlzRrcJ2o3PVH9sNPC
	 0mn/vr7TMW1OHU9ZAfLQiDFJllVWwAzwCNhbieDoEMO7rAJJUVJl1/fu6lf8bLek7BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NyVHNriAGXMD7ZsfU2BnSioLWdkos8F18wtYDrc8Jtw=;
	b=tzbLL4FAEmIuuHZufTyZXHUziluFDE3xE3jXVVHa+jWPaXkIJX8o3ZUO8j71COqzfbib
	 YSzS/rI9wyjX4ByQtfyNwkBPjtcrgiL2pozd7v8NFltfacMm2F2s0BKksLKirjF3T3gDO
	 xqR2ng6+pqs6YkLp0kxPULn4BW3foNHg5yVMPngjFnrC+d/j7iCknjDiAwtmxX8Y0RGkv
	 wEthwKvr9MF2CeDdQ4nGWprTvieBCYWq65DxNUltdtFi+aS3wFZl3jDpuVzlXTFLih1/T
	 T2sKotVVHEVZqYBW3hlxTuoSsNJPM9O/jnG7lZcCHj8yc1ZX2crK4QbDs5paFSycRyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LbA3IqIw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D10E606A320;
	Thu, 19 Nov 2026 00:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LbA3IqIw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5558A1F000C4;
	Thu, 19 Nov 2026 00:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048344;
	bh=NyVHNriAGXMD7ZsfU2BnSioLWdkos8F18wtYDrc8Jtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbA3IqIw4x52ja3D+1DWBRkYtSIX1B9vU8pnk1MJAdmgEGwsfw61uzz75CJuLrAcH
	 BY1Ba4rUdWVMjmgaYxUTf8TztxCEn6TmvpXo7EXog9BXvCQWfjbhegcutoZXreK3qm
	 2nSEYRmYyqZkBP6t9TKdWk4GGl9Diaa5Qa1RqS2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Aksh Garg <a-garg7@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1962/2857] PCI: dra7xx: Remove device links to PHY
Date: Wed, 18 Nov 2026 15:49:56 +0100
Message-ID: <20261118150312.048037112@linuxfoundation.org>
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

From: vladimir.oltean@nxp.com <vladimir.oltean@nxp.com>

[ Upstream commit 52cd9bb3772e82d792cb0def3c2a5a9b6bd24ffb ]

This is a full revert of commit 7a4db656a635 ("PCI: dra7xx: Create
functional dependency between PCIe and PHY").

The trouble with this is that a PHY consumer driver dereferences fields
from struct phy, which will become no longer possible.

Since commit 987351e1ea77 ("phy: core: Add consumer device link support")
from 2019, the PHY core also adds a device link to order PHY provider and
consumer suspend/resume operations. The reverted functionality is from 2017
and is redundant with the PHY core now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Aksh Garg <a-garg7@ti.com>
Link: https://patch.msgid.link/20260912161440.1032188-3-vladimir.oltean@nxp.com
Stable-dep-of: 768e5d0936d0 ("PCI: dra7xx: Fix clock enable leak on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-dra7xx.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-dra7xx.c b/drivers/pci/controller/dwc/pci-dra7xx.c
index 38462ed11d075..5894a8e685476 100644
--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -9,7 +9,6 @@
 
 #include <linux/clk.h>
 #include <linux/delay.h>
-#include <linux/device.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -689,7 +688,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 	int i;
 	int phy_count;
 	struct phy **phy;
-	struct device_link **link;
 	void __iomem *base;
 	struct dw_pcie *pci;
 	struct dra7xx_pcie *dra7xx;
@@ -737,10 +735,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 	if (!phy)
 		return -ENOMEM;
 
-	link = devm_kcalloc(dev, phy_count, sizeof(*link), GFP_KERNEL);
-	if (!link)
-		return -ENOMEM;
-
 	dra7xx->clk = devm_clk_get_optional(dev, NULL);
 	if (IS_ERR(dra7xx->clk))
 		return dev_err_probe(dev, PTR_ERR(dra7xx->clk),
@@ -755,12 +749,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 		phy[i] = devm_phy_get(dev, name);
 		if (IS_ERR(phy[i]))
 			return PTR_ERR(phy[i]);
-
-		link[i] = device_link_add(dev, &phy[i]->dev, DL_FLAG_STATELESS);
-		if (!link[i]) {
-			ret = -EINVAL;
-			goto err_link;
-		}
 	}
 
 	dra7xx->base = base;
@@ -855,10 +843,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 	pm_runtime_disable(dev);
 	dra7xx_pcie_disable_phy(dra7xx);
 
-err_link:
-	while (--i >= 0)
-		device_link_del(link[i]);
-
 	return ret;
 }
 
-- 
2.53.0



