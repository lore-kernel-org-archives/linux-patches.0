Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA589387562;
	Tue, 10 Mar 2026 11:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141955; cv=none; b=YtyFhuhvXzpPKmVSO50V816VGffVgm38aYq2vb/CxrLxzHav1cmL5NN5TSuz60lrEx2jyyVWxLMmOswG472fjB3+CifaxFZYyHmwdYsosjlh/dJg3/+mSuH13uZVdQpy9YNHobqCeeG0dj9S+tR6+XOYnLJMWPucfv4G0wJnWF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141955; c=relaxed/simple;
	bh=g+YWXDgy6DdhOQ5+30J1HleIKeZDAIxHZCjeK4MbWBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCjffejzGuoAdpGNFW72a4gDhBY0DaUXpX7glVINfwEdLR0fXGUsPI1dFZSFJvs0BKi/SSGUrYaCOF0mMlbhq9BHVxwxnnG9p7588cwVBFAG73CQW+ovacE/XTFKqYCTl8kJ2qbbrLcCfn4YksPRfIE6onm/WP9Rwls5B6ZlHAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZlcSM1k1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZlcSM1k1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDC3C2BC86;
	Tue, 10 Mar 2026 11:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141955;
	bh=g+YWXDgy6DdhOQ5+30J1HleIKeZDAIxHZCjeK4MbWBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlcSM1k1Ifp5P97MWJxJAt1x8TwPu1Qi9aSlSyEcJkX8XRNyy8s3EnmOApZ/UJolP
	 cgNI3yMKC6nHaq57gAInOz6XbKKxOVOoIxVdH9vHJSJ28BxycuDA9HwWDqbiNSwNvb
	 oQdBgOA/Cl5dxy0ORFsnQUoDU/38zC+p+erdQOYsuuxUOEZpVt7OskkbQSojz/iRSK
	 /YZ/onnvjylIhcfFiy0+3g/Q2QHSeqeKXX9ixBYFdMCjHJkndxiIf5Y+HZMNfuRYcu
	 ECphksIRRODFWACBXPCBHiAxq6JWZzaiUFXhdjpdD6+Tr/90Jc3w14fJg7xr95VTkf
	 RLCZ3SrNpb6GA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shawn Lin <shawn.lin@rock-chips.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/314] PCI: dw-rockchip: Configure L1SS support
Date: Tue, 10 Mar 2026 07:15:38 -0400
Message-ID: <5e64d24dc249423b28ac04fd19920774cd47418c.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit b5e719f26107f4a7f82946dc5be92dceb9b443cb ]

L1 PM Substates for RC mode require support in the dw-rockchip driver
including proper handling of the CLKREQ# sideband signal. It is mostly
handled by hardware, but software still needs to set the clkreq fields
in the PCIE_CLIENT_POWER_CON register to match the hardware implementation.

For more details, see section '18.6.6.4 L1 Substate' in the RK3568 TRM 1.1
Part 2, or section '11.6.6.4 L1 Substate' in the RK3588 TRM 1.0 Part2.

[bhelgaas: set pci->l1ss_support so DWC core preserves L1SS Capability bits;
drop corresponding code here, include updates from
https://lore.kernel.org/r/aRRG8wv13HxOCqgA@ryzen]

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/1761187883-150120-1-git-send-email-shawn.lin@rock-chips.com
Link: https://patch.msgid.link/20251118214312.2598220-4-helgaas@kernel.org
Stable-dep-of: 180c3cfe3678 ("Revert "PCI: dw-rockchip: Enumerate endpoints based on dll_link_up IRQ"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-dw-rockchip.c | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-dw-rockchip.c b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
index 7be6351686e21..85999fc316c9f 100644
--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -62,6 +62,12 @@
 /* Interrupt Mask Register Related to Miscellaneous Operation */
 #define PCIE_CLIENT_INTR_MASK_MISC	0x24
 
+/* Power Management Control Register */
+#define PCIE_CLIENT_POWER_CON		0x2c
+#define  PCIE_CLKREQ_READY		FIELD_PREP_WM16(BIT(0), 1)
+#define  PCIE_CLKREQ_NOT_READY		FIELD_PREP_WM16(BIT(0), 0)
+#define  PCIE_CLKREQ_PULL_DOWN		FIELD_PREP_WM16(GENMASK(13, 12), 1)
+
 /* Hot Reset Control Register */
 #define PCIE_CLIENT_HOT_RESET_CTRL	0x180
 #define  PCIE_LTSSM_APP_DLY2_EN		BIT(1)
@@ -87,6 +93,7 @@ struct rockchip_pcie {
 	struct regulator *vpcie3v3;
 	struct irq_domain *irq_domain;
 	const struct rockchip_pcie_of_data *data;
+	bool supports_clkreq;
 };
 
 struct rockchip_pcie_of_data {
@@ -202,6 +209,35 @@ static bool rockchip_pcie_link_up(struct dw_pcie *pci)
 	return FIELD_GET(PCIE_LINKUP_MASK, val) == PCIE_LINKUP;
 }
 
+/*
+ * See e.g. section '11.6.6.4 L1 Substate' in the RK3588 TRM V1.0 for the steps
+ * needed to support L1 substates. Currently, just enable L1 substates for RC
+ * mode if CLKREQ# is properly connected and supports-clkreq is present in DT.
+ * For EP mode, there are more things should be done to actually save power in
+ * L1 substates, so disable L1 substates until there is proper support.
+ */
+static void rockchip_pcie_configure_l1ss(struct dw_pcie *pci)
+{
+	struct rockchip_pcie *rockchip = to_rockchip_pcie(pci);
+
+	/* Enable L1 substates if CLKREQ# is properly connected */
+	if (rockchip->supports_clkreq) {
+		rockchip_pcie_writel_apb(rockchip, PCIE_CLKREQ_READY,
+					 PCIE_CLIENT_POWER_CON);
+		pci->l1ss_support = true;
+		return;
+	}
+
+	/*
+	 * Otherwise, assert CLKREQ# unconditionally.  Since
+	 * pci->l1ss_support is not set, the DWC core will prevent L1
+	 * Substates support from being advertised.
+	 */
+	rockchip_pcie_writel_apb(rockchip,
+				 PCIE_CLKREQ_PULL_DOWN | PCIE_CLKREQ_NOT_READY,
+				 PCIE_CLIENT_POWER_CON);
+}
+
 static void rockchip_pcie_enable_l0s(struct dw_pcie *pci)
 {
 	u32 cap, lnkcap;
@@ -268,6 +304,7 @@ static int rockchip_pcie_host_init(struct dw_pcie_rp *pp)
 	irq_set_chained_handler_and_data(irq, rockchip_pcie_intx_handler,
 					 rockchip);
 
+	rockchip_pcie_configure_l1ss(pci);
 	rockchip_pcie_enable_l0s(pci);
 
 	/* Disable Root Ports BAR0 and BAR1 as they report bogus size */
@@ -420,6 +457,9 @@ static int rockchip_pcie_resource_get(struct platform_device *pdev,
 		return dev_err_probe(&pdev->dev, PTR_ERR(rockchip->rst),
 				     "failed to get reset lines\n");
 
+	rockchip->supports_clkreq = of_property_read_bool(pdev->dev.of_node,
+							  "supports-clkreq");
+
 	return 0;
 }
 
-- 
2.51.0

