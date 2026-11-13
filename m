Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585925;
	b=gacWdS495480lWs54bLHCKZlpLJ1FWC/hW87SxEV2INBF38PFQAiyotUHbKsGYDjv1eE
	 Ibg5V3ke3eU0ezw1M1/CM3rwwectCiEiNdvW3jW1E1l1yvBi3aycsan1qUvtdO1dlnRgz
	 c4AQ4IKpQiuqCCkWWpz9hPtmJYehn92pxIKO/2Qo9Oy4fLhHZ2hTXGIUmc2FOvjZg8nCJ
	 GKgHJPQgzf1nP2IQotdOnVK+3hB5YszHiwYGAbAL5pUbNCd8lCeS7sRa7/0Sd2jyKhXVD
	 +gtHG0Fv79u+v53VOrQxR4Nk2sc7Z8Xyxo3rbsCpU4TeR38xs8oLNxU7Oo1op5iInBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LcAyZRH/cpgv2trnQ+xsKBL2SRoJrxAX9NzEt8WatFI=;
	b=VZF0jssYHFvMKoK9ON5mmBKherq5c+UIaX0P1b1FuUG/JN8/NRU7AmCHm0L8nEDwN6gg
	 ungWyOLNNPuvrzZ7ysEsriuN8YCA0pMy7zvHJkoY5AiAdow/ncAh774Nls1UL3cQ0Cshu
	 6tTEo1lm/7yr96f2aeY+sYxdIGWwrK9WUJl9TVWv3p+V+sTUJVC3MvP5WH+dgRwURTF/x
	 QEnk20PYBfSvZdZJ2IO0B7Qs3kkNxFouPDh5l++s7DuirpugdcWhA9H9em1wNOUguGial
	 L0Xb7qCtWW1ebjYfL+u+S79UFMjxDAh0nJ3kZgmcCYQMJ17OYoQsCJXfiqplMjqnLFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lA09eEj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5062D606A897;
	Fri, 13 Nov 2026 16:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lA09eEj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B6A1F000C5;
	Fri, 13 Nov 2026 16:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585925;
	bh=LcAyZRH/cpgv2trnQ+xsKBL2SRoJrxAX9NzEt8WatFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lA09eEjwO7qwQw/OokkT1iLdY4YCZMa3NwhyQpCiOjJEE7Z0UNU6OQQw0xuy6QEz
	 d64XUWy9rt+07CR/Arf9kKvTXjiqzLX6fh0vq6ZYefbKsKsw05IkCMMknP7I7f1ErL
	 JYBmzUTxFz9dfaLqXrU0B8xiGAWan4S5jvMjgvAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Aksh Garg <a-garg7@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 485/507] PCI: cadence: Remove device links to PHY
Date: Fri, 13 Nov 2026 10:53:09 -0500
Message-ID: <20261113153813.515904286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: vladimir.oltean@nxp.com <vladimir.oltean@nxp.com>

[ Upstream commit b59e98ae3841f84d0fb21dbf80e69e6c241a29d9 ]

This is a partial revert of the device link pieces from commit
dfb80534692d ("PCI: cadence: Add generic PHY support to host and EP
drivers").

The trouble with this is that a PHY consumer driver dereferences fields
from struct phy, which will become no longer possible.

Since commit 987351e1ea77 ("phy: core: Add consumer device link support")
from 2019, the PHY core also adds a device link to order PHY provider and
consumer suspend/resume operations. The reverted functionality is from
2018 and is redundant with the PHY core now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Aksh Garg <a-garg7@ti.com>
Link: https://patch.msgid.link/20260912161440.1032188-2-vladimir.oltean@nxp.com
Stable-dep-of: cfe96ce583c5 ("PCI: cadence: Store the core controller in platform drvdata")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/cadence/pcie-cadence-plat.c   |  4 ----
 drivers/pci/controller/cadence/pcie-cadence.c    | 16 +---------------
 drivers/pci/controller/cadence/pcie-cadence.h    |  2 --
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-plat.c b/drivers/pci/controller/cadence/pcie-cadence-plat.c
index a1ea24fc3b63f..5900d68c6e83a 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-plat.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-plat.c
@@ -41,7 +41,6 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 	struct pci_host_bridge *bridge;
 	struct cdns_pcie_ep *ep;
 	struct cdns_pcie_rc *rc;
-	int phy_count;
 	bool is_rc;
 	int ret;
 
@@ -122,9 +121,6 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 	cdns_pcie_disable_phy(cdns_plat_pcie->pcie);
-	phy_count = cdns_plat_pcie->pcie->phy_count;
-	while (phy_count--)
-		device_link_del(cdns_plat_pcie->pcie->link[phy_count]);
 
 	return 0;
 }
diff --git a/drivers/pci/controller/cadence/pcie-cadence.c b/drivers/pci/controller/cadence/pcie-cadence.c
index a1eada56edba7..0ac9802499414 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.c
+++ b/drivers/pci/controller/cadence/pcie-cadence.c
@@ -222,7 +222,6 @@ int cdns_pcie_init_phy(struct device *dev, struct cdns_pcie *pcie)
 	struct device_node *np = dev->of_node;
 	int phy_count;
 	struct phy **phy;
-	struct device_link **link;
 	int i;
 	int ret;
 	const char *name;
@@ -238,10 +237,6 @@ int cdns_pcie_init_phy(struct device *dev, struct cdns_pcie *pcie)
 	if (!phy)
 		return -ENOMEM;
 
-	link = devm_kcalloc(dev, phy_count, sizeof(*link), GFP_KERNEL);
-	if (!link)
-		return -ENOMEM;
-
 	for (i = 0; i < phy_count; i++) {
 		of_property_read_string_index(np, "phy-names", i, &name);
 		phy[i] = devm_phy_get(dev, name);
@@ -249,17 +244,10 @@ int cdns_pcie_init_phy(struct device *dev, struct cdns_pcie *pcie)
 			ret = PTR_ERR(phy[i]);
 			goto err_phy;
 		}
-		link[i] = device_link_add(dev, &phy[i]->dev, DL_FLAG_STATELESS);
-		if (!link[i]) {
-			devm_phy_put(dev, phy[i]);
-			ret = -EINVAL;
-			goto err_phy;
-		}
 	}
 
 	pcie->phy_count = phy_count;
 	pcie->phy = phy;
-	pcie->link = link;
 
 	ret =  cdns_pcie_enable_phy(pcie);
 	if (ret)
@@ -268,10 +256,8 @@ int cdns_pcie_init_phy(struct device *dev, struct cdns_pcie *pcie)
 	return 0;
 
 err_phy:
-	while (--i >= 0) {
-		device_link_del(link[i]);
+	while (--i >= 0)
 		devm_phy_put(dev, phy[i]);
-	}
 
 	return ret;
 }
diff --git a/drivers/pci/controller/cadence/pcie-cadence.h b/drivers/pci/controller/cadence/pcie-cadence.h
index b4d51adefea53..4a96e1869e535 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -260,7 +260,6 @@ struct cdns_plat_pcie_of_data {
  * @is_hpa: indicates if the architecture is HPA
  * @phy_count: number of supported PHY devices
  * @phy: list of pointers to specific PHY control blocks
- * @link: list of pointers to corresponding device link representations
  * @ops: Platform-specific ops to control various inputs from Cadence PCIe
  *       wrapper
  * @cdns_pcie_reg_offsets: Register bank offsets for different SoC
@@ -276,7 +275,6 @@ struct cdns_pcie {
 	bool				     is_hpa;
 	int			             phy_count;
 	struct phy		             **phy;
-	struct device_link	             **link;
 	const  struct cdns_pcie_ops          *ops;
 	const  struct cdns_plat_pcie_of_data *cdns_pcie_reg_offsets;
 	int				     max_link_speed;
-- 
2.53.0



