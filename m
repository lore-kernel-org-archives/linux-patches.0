Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55B2154BFF;
	Thu,  5 Sep 2024 09:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529722; cv=none; b=nOGpTR5ih9ZqN8a/PhmFEWvrZ2O4kOQPIWOhtQ3FHOGIfalJ8Szf3RhUiy9VDoVcbWYt38vSrkqYuCARui1yCJEskPzfJkxHrkVHtKXRee70uhowA0wqiRjpjlvhKatf7nF9ybR+iXUVzECbQetuvejoLfBpZrNHZe0+1zvJQsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529722; c=relaxed/simple;
	bh=JxNV5WRdFeRwDfYBaK04mMSB++PM6e+t1pzqWj/Mtj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qvedn8lp85YCyt+cAse5AT3tPKAZI/eVnFKW0c7i7BMry0bGrcjjGWoBx33CxBfC+4vu6wO2u4RCvdgG01RxQXiJgPNCs1jXBcrQNPggx7kFh1wEaJzgUe/IZ9iQJ7/7i7sbW13tCTNmN+/4gdtoF+nLNGh3Mh8aDivVQiGOLto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gglP0mOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gglP0mOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64608C4CEC3;
	Thu,  5 Sep 2024 09:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529721;
	bh=JxNV5WRdFeRwDfYBaK04mMSB++PM6e+t1pzqWj/Mtj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gglP0mOLfsr/5GXFayPObTIYDz4w0SWgiHgRYSGuLKbfdlMn2RFtJqzkhLZGBto3H
	 vbx3uQzDhgGocH9Ij4sCGO3J4qXaSM3jsiyoVxf37Bs+9Ax3xwF6yMXFj08w+fLJ/z
	 fSEql1klko5EeHYd8wGEoL8eK/s+/xHGeOhV7P9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 121/184] PCI: al: Check IORESOURCE_BUS existence during probe
Date: Thu,  5 Sep 2024 11:40:34 +0200
Message-ID: <20240905093736.954183405@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit a9927c2cac6e9831361e43a14d91277818154e6a ]

If IORESOURCE_BUS is not provided in Device Tree it will be fabricated in
of_pci_parse_bus_range(), so NULL pointer dereference should not happen
here.

But that's hard to verify, so check for NULL anyway.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lore.kernel.org/linux-pci/20240503125705.46055-1-amishin@t-argos.ru
Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-al.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-al.c b/drivers/pci/controller/dwc/pcie-al.c
index 6dfdda59f328..643115f74092 100644
--- a/drivers/pci/controller/dwc/pcie-al.c
+++ b/drivers/pci/controller/dwc/pcie-al.c
@@ -242,18 +242,24 @@ static struct pci_ops al_child_pci_ops = {
 	.write = pci_generic_config_write,
 };
 
-static void al_pcie_config_prepare(struct al_pcie *pcie)
+static int al_pcie_config_prepare(struct al_pcie *pcie)
 {
 	struct al_pcie_target_bus_cfg *target_bus_cfg;
 	struct dw_pcie_rp *pp = &pcie->pci->pp;
 	unsigned int ecam_bus_mask;
+	struct resource_entry *ft;
 	u32 cfg_control_offset;
+	struct resource *bus;
 	u8 subordinate_bus;
 	u8 secondary_bus;
 	u32 cfg_control;
 	u32 reg;
-	struct resource *bus = resource_list_first_type(&pp->bridge->windows, IORESOURCE_BUS)->res;
 
+	ft = resource_list_first_type(&pp->bridge->windows, IORESOURCE_BUS);
+	if (!ft)
+		return -ENODEV;
+
+	bus = ft->res;
 	target_bus_cfg = &pcie->target_bus_cfg;
 
 	ecam_bus_mask = (pcie->ecam_size >> PCIE_ECAM_BUS_SHIFT) - 1;
@@ -287,6 +293,8 @@ static void al_pcie_config_prepare(struct al_pcie *pcie)
 	       FIELD_PREP(CFG_CONTROL_SEC_BUS_MASK, secondary_bus);
 
 	al_pcie_controller_writel(pcie, cfg_control_offset, reg);
+
+	return 0;
 }
 
 static int al_pcie_host_init(struct dw_pcie_rp *pp)
@@ -305,7 +313,9 @@ static int al_pcie_host_init(struct dw_pcie_rp *pp)
 	if (rc)
 		return rc;
 
-	al_pcie_config_prepare(pcie);
+	rc = al_pcie_config_prepare(pcie);
+	if (rc)
+		return rc;
 
 	return 0;
 }
-- 
2.43.0



