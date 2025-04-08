Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9B3265630;
	Tue,  8 Apr 2025 11:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111086; cv=none; b=tY74C/GohOs5frZcL8z9sDf0yhIBRammjImv30ZwF91UP70AsWQGiGXsdF16NeT5mtDdQ3r0K5aqGBNx8u7m2aFK99v4ug5TQ+FbAyNpsWrjaAaUXShyAUzkhoH0T5GID6AX/C/raTehhn1deMLJOTi1pTG41q+LqelFvAWyrY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111086; c=relaxed/simple;
	bh=Oks1+5BuYJIXdVpQKr/9Cssd/L7HVgu9FXd/dddRmyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VpAxULsAy2ioPGQ/rbhBTneLZjxnW5eOCxDgVlRSdo3Bwh6ghD62BJP4+1/Af+L9+t2IRC5nVsYM93u4yW6MaSYlaqR1WOTsRvPUjoVyT1j7liEv+/eyIA7Zm3JhEbbizeMi2xZx8IQQKdRHHTGUL2Xq3qVEGMmLJP+pVXO7QKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AE8l7bH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AE8l7bH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A977C4CEE7;
	Tue,  8 Apr 2025 11:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111086;
	bh=Oks1+5BuYJIXdVpQKr/9Cssd/L7HVgu9FXd/dddRmyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AE8l7bH2XVJcfCi9yTT3fs2Grt4p/nvULYG3GRS5Gvr3nHS0gOCYLVw1MMcZVaCRg
	 5+OoC+MxDvsXLSdRceAmBJ5We6uG9KGApOsxgv53t6llGPqn8wiFczMp6pypcsg+kX
	 GQEF5WrSDgHjv0Q1v8FyxPzkD4qxutHuLKzh1kPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 304/731] PCI: mediatek-gen3: Configure PBUS_CSR registers for EN7581 SoC
Date: Tue,  8 Apr 2025 12:43:21 +0200
Message-ID: <20250408104921.349897529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 249b78298078448a699c39356d27d8183af4b281 ]

Configure PBus base address and address mask to allow the hw
to detect if a given address is accessible on PCIe controller.

Fixes: f6ab898356dd ("PCI: mediatek-gen3: Add Airoha EN7581 support")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20250225-en7581-pcie-pbus-csr-v4-2-24324382424a@kernel.org
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek-gen3.c | 28 ++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index aa24ac9aaecc7..d0cc7f3b4b520 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -15,6 +15,7 @@
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
 #include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/msi.h>
 #include <linux/of_device.h>
@@ -24,6 +25,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
+#include <linux/regmap.h>
 #include <linux/reset.h>
 
 #include "../pci.h"
@@ -930,9 +932,13 @@ static int mtk_pcie_parse_port(struct mtk_gen3_pcie *pcie)
 
 static int mtk_pcie_en7581_power_up(struct mtk_gen3_pcie *pcie)
 {
+	struct pci_host_bridge *host = pci_host_bridge_from_priv(pcie);
 	struct device *dev = pcie->dev;
+	struct resource_entry *entry;
+	struct regmap *pbus_regmap;
+	u32 val, args[2], size;
+	resource_size_t addr;
 	int err;
-	u32 val;
 
 	/*
 	 * The controller may have been left out of reset by the bootloader
@@ -945,6 +951,26 @@ static int mtk_pcie_en7581_power_up(struct mtk_gen3_pcie *pcie)
 	/* Wait for the time needed to complete the reset lines assert. */
 	msleep(PCIE_EN7581_RESET_TIME_MS);
 
+	/*
+	 * Configure PBus base address and base address mask to allow the
+	 * hw to detect if a given address is accessible on PCIe controller.
+	 */
+	pbus_regmap = syscon_regmap_lookup_by_phandle_args(dev->of_node,
+							   "mediatek,pbus-csr",
+							   ARRAY_SIZE(args),
+							   args);
+	if (IS_ERR(pbus_regmap))
+		return PTR_ERR(pbus_regmap);
+
+	entry = resource_list_first_type(&host->windows, IORESOURCE_MEM);
+	if (!entry)
+		return -ENODEV;
+
+	addr = entry->res->start - entry->offset;
+	regmap_write(pbus_regmap, args[0], lower_32_bits(addr));
+	size = lower_32_bits(resource_size(entry->res));
+	regmap_write(pbus_regmap, args[1], GENMASK(31, __fls(size)));
+
 	/*
 	 * Unlike the other MediaTek Gen3 controllers, the Airoha EN7581
 	 * requires PHY initialization and power-on before PHY reset deassert.
-- 
2.39.5



