Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020333;
	b=Eg5gAgZRMIzve5J+CmqkQJSzkO86FZv1Se53jbd9UJv8lPgl/5Wc9OpY7OhHeinWPLZO
	 GShB1K1LwkvZGSBpiuN4dm0yRkpKTDv1DugDi1K1CfX+lX5SE+WY1ZuZuyJ34quai32j6
	 BUWgRYP16Yt0i0sDygFKUNWvfHcczXfXIh7R8fhbC9dc+LKuxgIcrlKI7o9RMP+1u+0iv
	 2n51x6Otf4TV16vMw9Z3dezRysT02YDdSzM5dNZPMi/HmAFohrQuiONZQSDV0wbYMT62T
	 e0A8xqvR+JbV3+NYJ4sCTOOu5mO0TAXnPbUyRl0SW+/oZdVXEPeqJuXlbXIZ3ac8MJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/yefe2Vmva0jpJbcaojVYywdr6Zmehmpu3eytRfUdIs=;
	b=J/TV73uMaE/4n0DawTpU7v4p87CD/ptCHqGYNShguPhuYa0E9JoS1L1610JulJ2FTwEg
	 Z0vmnuc1ssnQlNfH9epbKfpbKXfLxNvd2NLdIOzgKOalJu/mCnGgTyw9Vw+zdegsbkQhE
	 qyqpR3oWt99GNFMWQVQ9sb+D4TSSpVd+aJKQOcWMrXRuIcAmVU8G+m97yvqNfGveVpXbu
	 1f73eZ/helvUqitS9MY3Qdji9b8oWXh4tTwh1ovfuiN0ktLZ4kgBZOyknkC5VCnsSJvWK
	 kE4fmmSrvH3tj+XsMbh2Caljdr1ASZ04s0rsP+5u6MYettZtEFKiixaaEhOP55QJy3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6gJLBGi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B36A606A325;
	Wed, 18 Nov 2026 16:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6gJLBGi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA521F000C4;
	Wed, 18 Nov 2026 16:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020333;
	bh=/yefe2Vmva0jpJbcaojVYywdr6Zmehmpu3eytRfUdIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6gJLBGiuhP1nwL3HgI/dgWco170miEN66nQYJcx3mUIZUwyUlz8xVed0vOeDogHF
	 twHwgDdt6+ws5aUszkgevG6Vp6azGZGrEPnhZQBzqOI2t8Gto1fK5e9VbOzSRY/sza
	 5PCD3xLs60hDPe+h6CVPBufPyLGyqwzSET+tVx6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Semih Baskan <strst.gs@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1913/2651] PCI: iproc: Use the EROM outbound window on BCMA
Date: Wed, 18 Nov 2026 15:52:33 +0100
Message-ID: <20261118150355.645960710@linuxfoundation.org>
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

From: Semih Baskan <strst.gs@gmail.com>

[ Upstream commit 9850907ee1dd4376c09c4129e0adbe3b39d191b7 ]

The PCIe outbound window base on Northstar depends on the PCIe Gen2 core
revision. Revision 0x01 uses 0x08000000, 0x40000000 and 0x48000000 for
controllers 0 to 2, while revision 0x07 (NS-B0) uses 0x08000000,
0x20000000 and 0x28000000. Broadcom's own driver branches on the core
revision for exactly this reason.

bcm-ns.dtsi is shared by every Northstar SoC, so it cannot carry a value
that is correct on both. Commit 767012397976 ("ARM: dts: BCM5301X:
Describe PCIe controllers fully") gave the controllers a ranges property.
The commit shipped in v7.1.

With that property present, two things go wrong with this driver:

  1) devm_pci_alloc_host_bridge() parses those ranges and requests them,
     then this driver adds its own window and requests the whole list a
     second time, so every controller fails to probe with -EBUSY.

  2) The DT window itself is only correct on core revision 0x07. On
     revision 0x01 it points at an address the hardware does not decode,
     and the first MMIO access to a BAR takes an imprecise external abort.

The enumeration ROM reports the correct base for the revision actually
present, and bcma already provides it as addr_s[0].

To solve 1), use pci_alloc_host_bridge() directly to avoid the request of
all the DT resources done in pci_parse_request_of_pci_ranges(). Instead,
request the memory window from the EROM.

To solve 2), parse the memory resources from DT and emit a warning if it
describes a window that doesn't match the window from the EROM.  The
mismatch means the devicetree describes a window the hardware does not
decode, and that should be fixed in the dts rather than ignored silently.

The driver is correct whether or not the DT describes a window.

The same commit also added compatible = "brcm,iproc-pcie", so these
nodes now match pcie-iproc-platform. With CONFIG_PCIE_IPROC_PLATFORM
enabled, which is the default on ARCH_BCM_IPROC, that driver binds them
first and this driver's probe fails inside devm_pci_alloc_host_bridge().
This commit fixes the configurations where the BCMA driver is the one in
use; OpenWrt builds that way, with PCIE_IPROC_PLATFORM disabled. The
platform path takes the DT window as-is and has the same wrong address
on core revision 0x01, so that side needs a devicetree fix either way.

Based on:
  https://patch.msgid.link/20260807160526.379-1-strst.gs@gmail.com
  https://patch.msgid.link/20260912043626.437-1-strst.gs@gmail.com

Fixes: 767012397976 ("ARM: dts: BCM5301X: Describe PCIe controllers fully")
Signed-off-by: Semih Baskan <strst.gs@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Semih Baskan <strst.gs@gmail.com>
Link: https://patch.msgid.link/20261013220421.1588051-3-bhelgaas@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc-bcma.c | 40 ++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pcie-iproc-bcma.c b/drivers/pci/controller/pcie-iproc-bcma.c
index 593418c2bc3aa..1e258cd8fed4f 100644
--- a/drivers/pci/controller/pcie-iproc-bcma.c
+++ b/drivers/pci/controller/pcie-iproc-bcma.c
@@ -11,7 +11,9 @@
 #include <linux/phy/phy.h>
 #include <linux/bcma/bcma.h>
 #include <linux/ioport.h>
+#include <linux/of_address.h>
 
+#include "../pci.h"
 #include "pcie-iproc.h"
 
 
@@ -31,6 +33,29 @@ static int iproc_bcma_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return bcma_core_irq(bdev, 5);
 }
 
+static void iproc_bcma_pcie_check_dt_window(struct iproc_pcie *pcie)
+{
+	struct device_node *np = pcie->dev->of_node;
+	struct of_pci_range_parser parser;
+	struct of_pci_range range;
+	struct resource res;
+
+	if (!np || of_pci_range_parser_init(&parser, np))
+		return;
+
+	for_each_of_pci_range(&parser, &range) {
+		if ((range.flags & IORESOURCE_TYPE_BITS) != IORESOURCE_MEM)
+			continue;
+
+		if (of_pci_range_to_resource(&range, np, &res))
+			continue;
+
+		if (res.start != pcie->mem.start || res.end != pcie->mem.end)
+			dev_warn(pcie->dev, "DT window %pR does not match EROM window %pR, using EROM\n",
+				 &res, &pcie->mem);
+	}
+}
+
 static int iproc_bcma_pcie_probe(struct bcma_device *bdev)
 {
 	struct device *dev = &bdev->dev;
@@ -38,10 +63,20 @@ static int iproc_bcma_pcie_probe(struct bcma_device *bdev)
 	struct pci_host_bridge *bridge;
 	int ret;
 
-	bridge = devm_pci_alloc_host_bridge(dev, sizeof(*pcie));
+	bridge = pci_alloc_host_bridge(sizeof(*pcie));
 	if (!bridge)
 		return -ENOMEM;
 
+	bridge->dev.parent = dev;
+
+	ret = devm_add_action_or_reset(dev, devm_pci_alloc_host_bridge_release,
+				       bridge);
+	if (ret)
+		return -ENOMEM;
+
+	bridge->swizzle_irq = pci_common_swizzle;
+	bridge->map_irq = iproc_bcma_pcie_map_irq;
+
 	pcie = pci_host_bridge_priv(bridge);
 
 	pcie->dev = dev;
@@ -59,13 +94,12 @@ static int iproc_bcma_pcie_probe(struct bcma_device *bdev)
 	pcie->mem.end = bdev->addr_s[0] + SZ_128M - 1;
 	pcie->mem.name = "PCIe MEM space";
 	pcie->mem.flags = IORESOURCE_MEM;
+	iproc_bcma_pcie_check_dt_window(pcie);
 	pci_add_resource(&bridge->windows, &pcie->mem);
 	ret = devm_request_pci_bus_resources(dev, &bridge->windows);
 	if (ret)
 		return ret;
 
-	bridge->map_irq = iproc_bcma_pcie_map_irq;
-
 	bcma_set_drvdata(bdev, pcie);
 
 	return iproc_pcie_setup(pcie, &bridge->windows);
-- 
2.53.0



