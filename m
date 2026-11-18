Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023827;
	b=2PPtocEkbfp3mYFQxJnG5MX0vQE7UAkDYrat849ii+Kk7+9ThwoJqsohxmAThnfl3Lzq
	 seQeg2Z5Ztx41yhart38WmzcCtEMfsrvJWRudmwQbrseEr5wqo9LU/h5cIsQ1zRR/8cp5
	 933A6QM+hWI3V+0E1wZsTPGnivxzP2c7MVY1MMxM3UP+a0mQUGAwKUXh9o018o1TdS+04
	 DJBQ7ksdbeD5SvK2hAtyoRRPJqtk8juyJQ25JcoM9BxjsLy+Etif33D5UbUJQZhpfDKtO
	 LX/Emg2/6rPh1F05Jil5gs7NlSRXQlSZhfMnOzcspe+DanSMrlDiW1SzPiNSnVfeUAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KGqfGWxOCzelrB9Lkb9ajXfIlLx8XJM/93TfOIjghCE=;
	b=r5jE6d+Ssfh5rWzrpfht0EOmt8THvLNft69kESwtDsn14z2HOJ1oOLKoGRyu8bkifOao
	 v9JatchEV7495Dehn9YsRSQ7ln5ntnUHaW6HeOlh5i3/lBMQqiH6FuDcKPqTSIOoqx9MK
	 XlSHq/6mqdq0PrxFewVsGymKlLYVXCziXz1UaB8ElDUaN4s+BgSr1GlaP0AC4obGGPscr
	 MyDe9tlawXyPZrqy6I4PoGL6TdE95sI966Zv13kUyuJZBYFnKflc5YwWxd0eL58w7xv3f
	 eWboA+zpecv5xR7BCNZR15Tc81SVB+oMLeSP+IC/ZJLwdZAJGOPQRaABJRCnItvJAsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F50PzCYt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEDA606A325;
	Wed, 18 Nov 2026 17:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F50PzCYt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FF21F000CA;
	Wed, 18 Nov 2026 17:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023827;
	bh=KGqfGWxOCzelrB9Lkb9ajXfIlLx8XJM/93TfOIjghCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F50PzCYtl0kq1dOwhLURCkLweLTFfWWVs/dMpteI3xJdfautKaa9SXTVILGprbzvx
	 PC6tDud89Zi1uwMYpZdiubG+Xs3TGa4/ymnIWhXysrMZfGPRPL5/V6nEfKWRDJwDWH
	 DOUFbNlRoDzyj7Af5wQqwiND1+JLRCsrImjdy5EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Aksh Garg <a-garg7@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0507/2151] PCI: dra7xx: Remove device links to PHY
Date: Wed, 18 Nov 2026 15:37:22 +0100
Message-ID: <20261118150140.520018509@linuxfoundation.org>
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
index 01cfd9aeb0b81..8f325409d7b05 100644
--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -9,7 +9,6 @@
 
 #include <linux/clk.h>
 #include <linux/delay.h>
-#include <linux/device.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -682,7 +681,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 	int i;
 	int phy_count;
 	struct phy **phy;
-	struct device_link **link;
 	void __iomem *base;
 	struct dw_pcie *pci;
 	struct dra7xx_pcie *dra7xx;
@@ -730,10 +728,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 	if (!phy)
 		return -ENOMEM;
 
-	link = devm_kcalloc(dev, phy_count, sizeof(*link), GFP_KERNEL);
-	if (!link)
-		return -ENOMEM;
-
 	dra7xx->clk = devm_clk_get_optional(dev, NULL);
 	if (IS_ERR(dra7xx->clk))
 		return dev_err_probe(dev, PTR_ERR(dra7xx->clk),
@@ -748,12 +742,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
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



