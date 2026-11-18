Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026308;
	b=Z4H9IPCTm7IUtbb5smBUMmobvcb8R6po3WdY/ZN7Q8GLe14qepDOFYzJlkELBDengOYe
	 X+rSM/X7dEcJr3wYrFM+46AiEx3lexjfje2i+zH4soIAw6eenlOm1CZd/7q3eWo1TO/ke
	 r7rj/QIhJ1hmLHpVxGPhVHfiKGZIhtPdlZzXbjabNhFZMFegoLXDVMvB/Fz+Hw1sjxD1F
	 eprvZ08EeshzwAXWL7+0+AzQo5DQsmrdc4TmksWw9vNOFNf7G9cIeCei+8Kmv5I7XY6Md
	 s/7AqSvxDwiPB9bIMgJXVYxCdr6z/rRjnc1CuvZuICs4apZXXDu3DVwxtjCjqn5GpZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvehK0GFW+LNJT5ElML0fgtlnppj4SRWpx0HEmSCe3k=;
	b=YqsS00edCVT6Ikp3OKwdX/aUIoL1gcqmIjPvst3IQqNwpygaU56Dng0j5PZSkcL4dFWF
	 DTpWBkVA5qMmQlkXJqMW46iYgMbI7WOFr7cKmzjiKeMAwH+Z22KT+k6RMHEIwDjpSGfy/
	 ZSXfgfgYA8J0T995h8FA/3dz4bg26anZxHgVvZi4qoXl1d3bP4l5ace+uopBNFPGk+duG
	 SljUb8cI/rehvbbxiMx7kY2owisuLJRUmaQ4oZHLu8wXxrSJI5AmdiDtQSmFy51e5Nfk2
	 ygvjr2ykOgd0zd02t3kmaJhosDWYmTX8OfM45+xksmWLrrpUtdqkAuAZ033YJa9+few==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yykq6UyH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42026606A32C;
	Wed, 18 Nov 2026 18:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yykq6UyH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3331F000C4;
	Wed, 18 Nov 2026 18:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026308;
	bh=PvehK0GFW+LNJT5ElML0fgtlnppj4SRWpx0HEmSCe3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yykq6UyHac22fJY8CDD0DW4vKzGClGyAi1o/1x+VmiriSh2/dLGQRBU2G7UhmnwPO
	 G2QuUkOiS8VuWolaar8/+Da6EcIHXCrjcen3wnDPG24/fK+dLtbPKcxf19eMaJVLcQ
	 ho6fLXPYoEU4zoH4rIKjm5iQifHHM+MWoHGNlUY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.18 1390/2151] PCI: qcom: Honor IOMMU providers #iommu-cells in qcom_pcie_config_sid_1_9_0()
Date: Wed, 18 Nov 2026 15:52:05 +0100
Message-ID: <20261118150212.638011927@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 5121d76cb9dde74662962cd5678a64abeaf3b3e4 ]

qcom_pcie_config_sid_1_9_0() reads the "iommu-map" property as an array
of fixed four-word {rid-base, phandle, sid, rid-len} entries to program
the BDF to SID translation table. But that layout only holds for an
IOMMU with '#iommu-cells = <1>'. The PCIe SMMUs on these SoCs use
'#iommu-cells = <2>' (SID and mask), so per the pci-iommu binding each
entry is really five cells long.

This used to work only because the DTs were themselves broken. They
described iommu-map with four-cell entries that omitted the SID mask,
which of_map_id() tolerated via its of_check_bad_map() fallback, and the
four-word parsing coincidentally matched that malformed shape.

Since commit ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps") the
OF core parses such maps correctly, so the device trees were converted
to proper five-cell entries, e.g. commit c41749e9554d ("arm64: dts:
qcom: sm8250: Fix the PCIe iommu-map entries"). With five-cell entries
the fixed four-word stride slips by one cell for each entry after the
first, so qcom_pcie_config_sid_1_9_0() reads the endpoint mapping's RID
from the preceding entry's length cell and its SID from the phandle cell.
As the RID is the hash key, the endpoint's real RID is never programmed
into the BDF to SID table. Its DMA then hashes to an unprogrammed slot,
gets tagged with SID 0 and the SMMU faults like below on QCS8300:

  arm-smmu 15200000.iommu: Unhandled context fault: fsr=0x402, iova=0xffa00000, cbfrsynra=0x0, cb=1

To fix this, walk the map with a stride of 3 + '#iommu-cells' of the
referenced IOMMU and take the SID from the first specifier cell, which is
all the BDF to SID table needs. Validate the layout instead of trusting
the array size. Also, preserve the legacy behavior of the old DTs by
detecting the same pattern that of_check_bad_map() recognizes and
falling back to a stride of four.

Fixes: 4c9398822106 ("PCI: qcom: Add support for configuring BDF to SID mapping for SM8250")
Reported-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Tested-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Link: https://patch.msgid.link/20260907143349.317495-1-mani@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 90 ++++++++++++++++++--------
 1 file changed, 64 insertions(+), 26 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index fbdb5a9264785..559aa85902d51 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1063,50 +1063,90 @@ static void qcom_pcie_deinit_2_7_0(struct qcom_pcie *pcie)
 
 static int qcom_pcie_config_sid_1_9_0(struct qcom_pcie *pcie)
 {
-	/* iommu map structure */
-	struct {
-		u32 bdf;
-		u32 phandle;
-		u32 smmu_sid;
-		u32 smmu_sid_len;
-	} *map;
 	void __iomem *bdf_to_sid_base = pcie->parf + PARF_BDF_TO_SID_TABLE_N;
 	struct device *dev = pcie->pci->dev;
+	struct device_node *iommu_np;
 	u8 qcom_pcie_crc8_table[CRC8_TABLE_SIZE];
-	int i, nr_map, size = 0;
-	u32 smmu_sid_base;
+	const __be32 *map;
+	u32 iommu_cells, entry_cells, phandle, smmu_sid_base;
+	int i, nr_cells, nr_map, size = 0;
 	u32 val;
 
-	of_get_property(dev->of_node, "iommu-map", &size);
-	if (!size)
+	map = of_get_property(dev->of_node, "iommu-map", &size);
+	if (!map || !size)
 		return 0;
 
+	if (size % sizeof(*map)) {
+		dev_err(dev, "Malformed iommu-map property\n");
+		return -EINVAL;
+	}
+	nr_cells = size / sizeof(*map);
+
+	/*
+	 * Each iommu-map entry is: rid-base (1 cell), phandle (1 cell),
+	 * IOMMU specifier (#iommu-cells cells), length (1 cell). Read
+	 * #iommu-cells from the IOMMU provider referenced by the first
+	 * entry to compute the per-entry stride.
+	 */
+	phandle = be32_to_cpu(map[1]);
+	iommu_np = of_find_node_by_phandle(phandle);
+	if (!iommu_np) {
+		dev_err(dev, "Failed to find IOMMU node in iommu-map\n");
+		return -ENODEV;
+	}
+
+	if (of_property_read_u32(iommu_np, "#iommu-cells", &iommu_cells))
+		iommu_cells = 1;
+	of_node_put(iommu_np);
+
+	entry_cells = 3 + iommu_cells;
+
+	/*
+	 * Retain backward compatibility with DTs that describe iommu-map
+	 * with 4-cell entries against an IOMMU declaring #iommu-cells = 2,
+	 * matching the fallback in drivers/of/base.c::of_check_bad_map().
+	 */
+	if (iommu_cells == 2 && !(nr_cells % 4)) {
+		bool legacy = true;
+
+		for (i = 0; i < nr_cells; i += 4) {
+			if (be32_to_cpu(map[i + 1]) != phandle ||
+			    be32_to_cpu(map[i + 3]) != 1) {
+				legacy = false;
+				break;
+			}
+		}
+
+		if (legacy) {
+			dev_warn_once(dev, "iommu-map has 1-cell entries with #iommu-cells=2, using 1-cell\n");
+			entry_cells = 4;
+		}
+	}
+
+	if (nr_cells % entry_cells) {
+		dev_err(dev, "Malformed iommu-map property\n");
+		return -EINVAL;
+	}
+	nr_map = nr_cells / entry_cells;
+
 	/* Enable BDF to SID translation by disabling bypass mode (default) */
 	val = readl(pcie->parf + PARF_BDF_TO_SID_CFG);
 	val &= ~BDF_TO_SID_BYPASS;
 	writel(val, pcie->parf + PARF_BDF_TO_SID_CFG);
 
-	map = kzalloc(size, GFP_KERNEL);
-	if (!map)
-		return -ENOMEM;
-
-	of_property_read_u32_array(dev->of_node, "iommu-map", (u32 *)map,
-				   size / sizeof(u32));
-
-	nr_map = size / (sizeof(*map));
-
 	crc8_populate_msb(qcom_pcie_crc8_table, QCOM_PCIE_CRC8_POLYNOMIAL);
 
 	/* Registers need to be zero out first */
 	memset_io(bdf_to_sid_base, 0, CRC8_TABLE_SIZE * sizeof(u32));
 
 	/* Extract the SMMU SID base from the first entry of iommu-map */
-	smmu_sid_base = map[0].smmu_sid;
+	smmu_sid_base = be32_to_cpu(map[2]);
 
 	/* Look for an available entry to hold the mapping */
 	for (i = 0; i < nr_map; i++) {
-		__be16 bdf_be = cpu_to_be16(map[i].bdf);
-		u32 val;
+		u32 bdf = be32_to_cpu(map[i * entry_cells]);
+		u32 sid = be32_to_cpu(map[i * entry_cells + 2]);
+		__be16 bdf_be = cpu_to_be16(bdf);
 		u8 hash;
 
 		hash = crc8(qcom_pcie_crc8_table, (u8 *)&bdf_be, sizeof(bdf_be), 0);
@@ -1128,12 +1168,10 @@ static int qcom_pcie_config_sid_1_9_0(struct qcom_pcie *pcie)
 		}
 
 		/* BDF [31:16] | SID [15:8] | NEXT [7:0] */
-		val = map[i].bdf << 16 | (map[i].smmu_sid - smmu_sid_base) << 8 | 0;
+		val = bdf << 16 | (sid - smmu_sid_base) << 8 | 0;
 		writel(val, bdf_to_sid_base + hash * sizeof(u32));
 	}
 
-	kfree(map);
-
 	return 0;
 }
 
-- 
2.53.0



