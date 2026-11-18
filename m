Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016527;
	b=Fac9gTow9KJlNwI7c2bLbv+dyZ/79se7yFoxT8+eIDwQ/Wfbr1VJToXUoC1Qic/roZTn
	 V3TWjmdeMUa6RV0byjyoYwvrfFwCrLMP6YgoebcvQcE1m7tukavoSmO0n+z+gWjG5g78A
	 5h62Gt40n+NDhxQCAO9AFWbX/10YMIeFzjcwQa/mvsvuNUANmu3Ez+SjEKQ+v4YyoBmec
	 rkTSOSF591WKXu6Fh8JD3NGm0i90AYiiBvZvI3RODE6X3nYunFSrgRu+khdspoRf4GciL
	 oNOwmJWebctKfTIcV7JzqYpEUN79RUQjf1fzCaGuHOevnGpysRU3/M4s45YD+9TEqOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HC6TyYZsgqO5V9FzzrLx+q9lphpPm/mhhzE8cBvapgk=;
	b=Xs+FgGweWd+VJtImzx1hEb94++0/Vc+NsqelJH3UmBr6U+ehfFNaAV9bRM/6ibWx5Ram
	 9YkEy6vRcUfMn+ATbWXMQUVWC/58NxvQL/twB2VxVi1goiD/KhQ3tE4jLfJ+UMDZgvgVR
	 NYjrqLO55WM2KXJBEBssmjKBmWzgwVVC3E2URfpeCEJxiNE76idpvEJmpq9SicY7usWQ6
	 wcuuw0LWRzfTcoUgDrj+y5nLUVNCXAWF/gc80wc4w1hb/AcbHNoDC6e/HkQY8gMn0RUnV
	 ITdFiaAFB70xOIFp9p/VVuuQnfXY8WGTnzy6XzAWG7XXBFPTeN/2O6x81dDxSJDuSRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZLwy5Aiz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FCE606A320;
	Wed, 18 Nov 2026 15:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZLwy5Aiz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40AA1F000C4;
	Wed, 18 Nov 2026 15:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016527;
	bh=HC6TyYZsgqO5V9FzzrLx+q9lphpPm/mhhzE8cBvapgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLwy5AiztMUGjpNxqMwwT+y3mJ8yIP7sBiM/uZAT2/WmwVQRpiGem79IHkMWmj2zH
	 /NfyYncZIjwRdXsEo7MLwkBFdm0mKbD+gLiU7eeMc9HOYjjrcZtv6pRmLio++2d4+B
	 NVPv/6VmwIobHCY2KDwF/Mj9aFpY8HKeobc+7PdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Aksh Garg <a-garg7@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0558/2651] PCI: dra7xx: Remove device links to PHY
Date: Wed, 18 Nov 2026 15:29:58 +0100
Message-ID: <20261118150307.831424360@linuxfoundation.org>
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
index 6ae5b27e27b32..6c9e881776002 100644
--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -9,7 +9,6 @@
 
 #include <linux/clk.h>
 #include <linux/delay.h>
-#include <linux/device.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -680,7 +679,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 	int i;
 	int phy_count;
 	struct phy **phy;
-	struct device_link **link;
 	void __iomem *base;
 	struct dw_pcie *pci;
 	struct dra7xx_pcie *dra7xx;
@@ -728,10 +726,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 	if (!phy)
 		return -ENOMEM;
 
-	link = devm_kcalloc(dev, phy_count, sizeof(*link), GFP_KERNEL);
-	if (!link)
-		return -ENOMEM;
-
 	dra7xx->clk = devm_clk_get_optional(dev, NULL);
 	if (IS_ERR(dra7xx->clk))
 		return dev_err_probe(dev, PTR_ERR(dra7xx->clk),
@@ -746,12 +740,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
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
@@ -853,10 +841,6 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
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



