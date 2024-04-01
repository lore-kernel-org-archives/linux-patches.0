Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C4A1C0DE7;
	Mon,  1 Apr 2024 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990886; cv=none; b=OSJyLJ1zk8Ifl6RevWqvkonALZB5Mc6xJ7uFsfWOO2MXF5itP9coUke/iFqMlF9YCAaNC5hHoAV9QDUg8vTlkeZjMMzPgaP4MITAGfXR+0edfjU8p9hTDpmFKExyb4des7eL75uUAhQIzjRyLiyaHdhEZkm8g9IUeqPaD2sk14M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990886; c=relaxed/simple;
	bh=qRSVFAiMLFThcf51EnbFg67peOlizqCWBal1W3xnPiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLg1MWXRwCnMyNHoqr3heiAo+2xQovIcpxZcD4p9bcBndn2JHdodEsnsNoqZ/zes4p6GEcSxru2uMRqHVSgoWM4sM3XWBjxW7DuoZWm8q1A5EVYdSb0j1HeEdFhYLpzqAoOn1d+4JW8f7gwr6ilDUOFDSujQLjO5xB74ioClHzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbfnAbKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbfnAbKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AC2C433C7;
	Mon,  1 Apr 2024 17:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990886;
	bh=qRSVFAiMLFThcf51EnbFg67peOlizqCWBal1W3xnPiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbfnAbKtuKlpOanZjA0lG+VwPFft/IQmkJIVb2YA3uP+26bgFgMhoUYjSw26kQ10l
	 xClmg/YGYoDU9tZ9LrOOx3LF7vX3nR4LKMNQm0SCsWEToG0uy78QwI6CkJ/72F55V3
	 ERGYx8dhGYCJ58CYAxIgDRqpRAxunSHFSG79E4PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/272] PCI: qcom: Rename qcom_pcie_config_sid_sm8250() to reflect IP version
Date: Mon,  1 Apr 2024 17:44:47 +0200
Message-ID: <20240401152533.657522528@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 1f70939871b260b52e9d1941f1cad740b7295c2c ]

qcom_pcie_config_sid_sm8250() function no longer applies only to SM8250.
So let's rename it to reflect the actual IP version and also move its
definition to keep it sorted as per IP revisions.

Link: https://lore.kernel.org/r/20230316081117.14288-15-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Stable-dep-of: bf79e33cdd89 ("PCI: qcom: Enable BDF to SID translation properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 143 ++++++++++++-------------
 1 file changed, 71 insertions(+), 72 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 0ccd92faf078a..9202d2395b507 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1312,6 +1312,76 @@ static void qcom_pcie_deinit_2_7_0(struct qcom_pcie *pcie)
 	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
 }
 
+static int qcom_pcie_config_sid_1_9_0(struct qcom_pcie *pcie)
+{
+	/* iommu map structure */
+	struct {
+		u32 bdf;
+		u32 phandle;
+		u32 smmu_sid;
+		u32 smmu_sid_len;
+	} *map;
+	void __iomem *bdf_to_sid_base = pcie->parf + PARF_BDF_TO_SID_TABLE_N;
+	struct device *dev = pcie->pci->dev;
+	u8 qcom_pcie_crc8_table[CRC8_TABLE_SIZE];
+	int i, nr_map, size = 0;
+	u32 smmu_sid_base;
+
+	of_get_property(dev->of_node, "iommu-map", &size);
+	if (!size)
+		return 0;
+
+	map = kzalloc(size, GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+
+	of_property_read_u32_array(dev->of_node, "iommu-map", (u32 *)map,
+				   size / sizeof(u32));
+
+	nr_map = size / (sizeof(*map));
+
+	crc8_populate_msb(qcom_pcie_crc8_table, QCOM_PCIE_CRC8_POLYNOMIAL);
+
+	/* Registers need to be zero out first */
+	memset_io(bdf_to_sid_base, 0, CRC8_TABLE_SIZE * sizeof(u32));
+
+	/* Extract the SMMU SID base from the first entry of iommu-map */
+	smmu_sid_base = map[0].smmu_sid;
+
+	/* Look for an available entry to hold the mapping */
+	for (i = 0; i < nr_map; i++) {
+		__be16 bdf_be = cpu_to_be16(map[i].bdf);
+		u32 val;
+		u8 hash;
+
+		hash = crc8(qcom_pcie_crc8_table, (u8 *)&bdf_be, sizeof(bdf_be), 0);
+
+		val = readl(bdf_to_sid_base + hash * sizeof(u32));
+
+		/* If the register is already populated, look for next available entry */
+		while (val) {
+			u8 current_hash = hash++;
+			u8 next_mask = 0xff;
+
+			/* If NEXT field is NULL then update it with next hash */
+			if (!(val & next_mask)) {
+				val |= (u32)hash;
+				writel(val, bdf_to_sid_base + current_hash * sizeof(u32));
+			}
+
+			val = readl(bdf_to_sid_base + hash * sizeof(u32));
+		}
+
+		/* BDF [31:16] | SID [15:8] | NEXT [7:0] */
+		val = map[i].bdf << 16 | (map[i].smmu_sid - smmu_sid_base) << 8 | 0;
+		writel(val, bdf_to_sid_base + hash * sizeof(u32));
+	}
+
+	kfree(map);
+
+	return 0;
+}
+
 static int qcom_pcie_get_resources_2_9_0(struct qcom_pcie *pcie)
 {
 	struct qcom_pcie_resources_2_9_0 *res = &pcie->res.v2_9_0;
@@ -1429,77 +1499,6 @@ static int qcom_pcie_link_up(struct dw_pcie *pci)
 	return !!(val & PCI_EXP_LNKSTA_DLLLA);
 }
 
-static int qcom_pcie_config_sid_sm8250(struct qcom_pcie *pcie)
-{
-	/* iommu map structure */
-	struct {
-		u32 bdf;
-		u32 phandle;
-		u32 smmu_sid;
-		u32 smmu_sid_len;
-	} *map;
-	void __iomem *bdf_to_sid_base = pcie->parf + PARF_BDF_TO_SID_TABLE_N;
-	struct device *dev = pcie->pci->dev;
-	u8 qcom_pcie_crc8_table[CRC8_TABLE_SIZE];
-	int i, nr_map, size = 0;
-	u32 smmu_sid_base;
-
-	of_get_property(dev->of_node, "iommu-map", &size);
-	if (!size)
-		return 0;
-
-	map = kzalloc(size, GFP_KERNEL);
-	if (!map)
-		return -ENOMEM;
-
-	of_property_read_u32_array(dev->of_node,
-		"iommu-map", (u32 *)map, size / sizeof(u32));
-
-	nr_map = size / (sizeof(*map));
-
-	crc8_populate_msb(qcom_pcie_crc8_table, QCOM_PCIE_CRC8_POLYNOMIAL);
-
-	/* Registers need to be zero out first */
-	memset_io(bdf_to_sid_base, 0, CRC8_TABLE_SIZE * sizeof(u32));
-
-	/* Extract the SMMU SID base from the first entry of iommu-map */
-	smmu_sid_base = map[0].smmu_sid;
-
-	/* Look for an available entry to hold the mapping */
-	for (i = 0; i < nr_map; i++) {
-		__be16 bdf_be = cpu_to_be16(map[i].bdf);
-		u32 val;
-		u8 hash;
-
-		hash = crc8(qcom_pcie_crc8_table, (u8 *)&bdf_be, sizeof(bdf_be),
-			0);
-
-		val = readl(bdf_to_sid_base + hash * sizeof(u32));
-
-		/* If the register is already populated, look for next available entry */
-		while (val) {
-			u8 current_hash = hash++;
-			u8 next_mask = 0xff;
-
-			/* If NEXT field is NULL then update it with next hash */
-			if (!(val & next_mask)) {
-				val |= (u32)hash;
-				writel(val, bdf_to_sid_base + current_hash * sizeof(u32));
-			}
-
-			val = readl(bdf_to_sid_base + hash * sizeof(u32));
-		}
-
-		/* BDF [31:16] | SID [15:8] | NEXT [7:0] */
-		val = map[i].bdf << 16 | (map[i].smmu_sid - smmu_sid_base) << 8 | 0;
-		writel(val, bdf_to_sid_base + hash * sizeof(u32));
-	}
-
-	kfree(map);
-
-	return 0;
-}
-
 static int qcom_pcie_host_init(struct dw_pcie_rp *pp)
 {
 	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
@@ -1616,7 +1615,7 @@ static const struct qcom_pcie_ops ops_1_9_0 = {
 	.init = qcom_pcie_init_2_7_0,
 	.deinit = qcom_pcie_deinit_2_7_0,
 	.ltssm_enable = qcom_pcie_2_3_2_ltssm_enable,
-	.config_sid = qcom_pcie_config_sid_sm8250,
+	.config_sid = qcom_pcie_config_sid_1_9_0,
 };
 
 /* Qcom IP rev.: 2.9.0  Synopsys IP rev.: 5.00a */
-- 
2.43.0



