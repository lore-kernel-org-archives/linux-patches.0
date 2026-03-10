Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11CE3876D5;
	Tue, 10 Mar 2026 11:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141957; cv=none; b=p66y1qWP5qOyJo7NJ3GtkD2ERXfDFDJWv7vH55Xak8HdzopgBQsnnebOe411nZ0eHShplK6i1QHtzEKwcvMBBxrSPrQ0PdxDoA9JL5uTFopPjoNZC2OWeIxglKgh93VZoTVU9dyREg38dyvbRanld3EBxmhcBsrzMvhuO1otzFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141957; c=relaxed/simple;
	bh=qVnfQ0rLd4QwRu3lbuwMu68yLwtoDiqgsYktTUx0d8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9+7k0S+8RPgm6M1noT825CWnnusopjzuQtmgKYL6q4P+ybj/aY/QzrnOBC/d89vu0BpNcc8ZwFZ4vA996vvq+BdJ4OTPocKYUUfE6jKZJvwap39QK+ZFVyykCewl23hhcTLbGyVLW8S65/+q1LYNqoPheNT47I2WVnkgmGfJ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i/TIEZhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i/TIEZhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1388C2BC86;
	Tue, 10 Mar 2026 11:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141957;
	bh=qVnfQ0rLd4QwRu3lbuwMu68yLwtoDiqgsYktTUx0d8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/TIEZhz8t8n+I3tRnuVMSjA4x5kRPg3KDrn/FiIf5G3mGYdaBDzJrMO3IV6NgFtr
	 Q1ZHpppfAl0M1QoUXIHRPq2PqlwSlXl/IlPVU3bnTcYyJkXt9ICxq7VaSbwKNbCOHH
	 pS8S+zA2zLk5fgnKySPP1RbHx/YmK/0Wb4zAEidnHJlSKDqRB7Or1Z2poPcQpeSxJV
	 QCXNWC91XDMDdUw3zWGhlsuSOn+ElDOD5p9r1RTExSn+FKW58/oQlclw1nTPVypycD
	 hkYDkMpeHgp8dxpXWRqjt466ihueSAxGcyEI4iKZgTFh0yE7FxbhqvrcaPB2uSFWNj
	 PaZdPy1EmhWjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/314] PCI: dw-rockchip: Change get_ltssm() to provide L1 Substates info
Date: Tue, 10 Mar 2026 07:15:40 -0400
Message-ID: <ed323c253f34de5021adab863529d61a616b55a2.1773141555.git.sashal@kernel.org>
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

[ Upstream commit f994bb8f1c94726e0124356ccd31c3c23a8a69f4 ]

Rename rockchip_pcie_get_ltssm() to rockchip_pcie_get_ltssm_reg() and add
rockchip_pcie_get_ltssm() to get_ltssm() callback in order to show the
proper L1 Substates. The PCIE_CLIENT_LTSSM_STATUS[5:0] register returns
the same LTSSM layout as enum dw_pcie_ltssm. So the driver just need to
convey L1 PM Substates by returning the proper value defined in
pcie-designware.h.

  cat /sys/kernel/debug/dwc_pcie_a40000000.pcie/ltssm_status
  L1_2 (0x142)

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/1765503205-22184-2-git-send-email-shawn.lin@rock-chips.com
Stable-dep-of: 180c3cfe3678 ("Revert "PCI: dw-rockchip: Enumerate endpoints based on dll_link_up IRQ"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-dw-rockchip.c | 29 ++++++++++++++++---
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-dw-rockchip.c b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
index 85999fc316c9f..0a5d1cfb88437 100644
--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -68,6 +68,11 @@
 #define  PCIE_CLKREQ_NOT_READY		FIELD_PREP_WM16(BIT(0), 0)
 #define  PCIE_CLKREQ_PULL_DOWN		FIELD_PREP_WM16(GENMASK(13, 12), 1)
 
+/* RASDES TBA information */
+#define PCIE_CLIENT_CDM_RASDES_TBA_INFO_CMN	0x154
+#define  PCIE_CLIENT_CDM_RASDES_TBA_L1_1	BIT(4)
+#define  PCIE_CLIENT_CDM_RASDES_TBA_L1_2	BIT(5)
+
 /* Hot Reset Control Register */
 #define PCIE_CLIENT_HOT_RESET_CTRL	0x180
 #define  PCIE_LTSSM_APP_DLY2_EN		BIT(1)
@@ -184,11 +189,26 @@ static int rockchip_pcie_init_irq_domain(struct rockchip_pcie *rockchip)
 	return 0;
 }
 
-static u32 rockchip_pcie_get_ltssm(struct rockchip_pcie *rockchip)
+static u32 rockchip_pcie_get_ltssm_reg(struct rockchip_pcie *rockchip)
 {
 	return rockchip_pcie_readl_apb(rockchip, PCIE_CLIENT_LTSSM_STATUS);
 }
 
+static enum dw_pcie_ltssm rockchip_pcie_get_ltssm(struct dw_pcie *pci)
+{
+	struct rockchip_pcie *rockchip = to_rockchip_pcie(pci);
+	u32 val = rockchip_pcie_readl_apb(rockchip,
+			PCIE_CLIENT_CDM_RASDES_TBA_INFO_CMN);
+
+	if (val & PCIE_CLIENT_CDM_RASDES_TBA_L1_1)
+		return DW_PCIE_LTSSM_L1_1;
+
+	if (val & PCIE_CLIENT_CDM_RASDES_TBA_L1_2)
+		return DW_PCIE_LTSSM_L1_2;
+
+	return rockchip_pcie_get_ltssm_reg(rockchip) & PCIE_LTSSM_STATUS_MASK;
+}
+
 static void rockchip_pcie_enable_ltssm(struct rockchip_pcie *rockchip)
 {
 	rockchip_pcie_writel_apb(rockchip, PCIE_CLIENT_ENABLE_LTSSM,
@@ -204,7 +224,7 @@ static void rockchip_pcie_disable_ltssm(struct rockchip_pcie *rockchip)
 static bool rockchip_pcie_link_up(struct dw_pcie *pci)
 {
 	struct rockchip_pcie *rockchip = to_rockchip_pcie(pci);
-	u32 val = rockchip_pcie_get_ltssm(rockchip);
+	u32 val = rockchip_pcie_get_ltssm_reg(rockchip);
 
 	return FIELD_GET(PCIE_LINKUP_MASK, val) == PCIE_LINKUP;
 }
@@ -494,6 +514,7 @@ static const struct dw_pcie_ops dw_pcie_ops = {
 	.link_up = rockchip_pcie_link_up,
 	.start_link = rockchip_pcie_start_link,
 	.stop_link = rockchip_pcie_stop_link,
+	.get_ltssm = rockchip_pcie_get_ltssm,
 };
 
 static irqreturn_t rockchip_pcie_rc_sys_irq_thread(int irq, void *arg)
@@ -508,7 +529,7 @@ static irqreturn_t rockchip_pcie_rc_sys_irq_thread(int irq, void *arg)
 	rockchip_pcie_writel_apb(rockchip, reg, PCIE_CLIENT_INTR_STATUS_MISC);
 
 	dev_dbg(dev, "PCIE_CLIENT_INTR_STATUS_MISC: %#x\n", reg);
-	dev_dbg(dev, "LTSSM_STATUS: %#x\n", rockchip_pcie_get_ltssm(rockchip));
+	dev_dbg(dev, "LTSSM_STATUS: %#x\n", rockchip_pcie_get_ltssm_reg(rockchip));
 
 	if (reg & PCIE_RDLH_LINK_UP_CHGED) {
 		if (rockchip_pcie_link_up(pci)) {
@@ -535,7 +556,7 @@ static irqreturn_t rockchip_pcie_ep_sys_irq_thread(int irq, void *arg)
 	rockchip_pcie_writel_apb(rockchip, reg, PCIE_CLIENT_INTR_STATUS_MISC);
 
 	dev_dbg(dev, "PCIE_CLIENT_INTR_STATUS_MISC: %#x\n", reg);
-	dev_dbg(dev, "LTSSM_STATUS: %#x\n", rockchip_pcie_get_ltssm(rockchip));
+	dev_dbg(dev, "LTSSM_STATUS: %#x\n", rockchip_pcie_get_ltssm_reg(rockchip));
 
 	if (reg & PCIE_LINK_REQ_RST_NOT_INT) {
 		dev_dbg(dev, "hot reset or link-down reset\n");
-- 
2.51.0

