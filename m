Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E7F1A619B;
	Tue, 30 Jul 2024 16:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357376; cv=none; b=ugDSwsLthJYMf6JU3PiNJkj9uyOYZTNQoiQdmCuUmijY7WFn2R4DzQT1Ql/79RvcA2KctB/jU5jaYnlOpw0ilNHJm65vRA1bCqyrbqeW+0cHT2EQ+3oJG+UejEb3IfSEM1sx2Zhh9GzDpJosjsG8337rRnRiiSOS8UdA5c6fXOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357376; c=relaxed/simple;
	bh=l6Ny0XeJjBdf+HLES5MAw1bqKPCAP+EaBcOGtBYVy9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YIxCzlHuOTCaivVLfSHRTux1sDnnJmoxnjBgJcnQwuuefpZAixWngmjL8fM2cMSgAXckaGuq9IhnlHtAPKPwxHLs2yHVC3v0pm4OMSSVVL25+KdYRQY25FB1p9zyn4JOOnp1t3ORBHbPZXkFg8sORhjZ1PTTi+Zb4uyPzRR5rmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpfKf45f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpfKf45f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A132C32782;
	Tue, 30 Jul 2024 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357376;
	bh=l6Ny0XeJjBdf+HLES5MAw1bqKPCAP+EaBcOGtBYVy9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpfKf45fBZ/7ylFgYmz0FI3Qlojd3I+0+OF/Xf1rIk4pQiXrN1BhKgwyGU91RUIHt
	 GffO6+gSmJ6FavylzBFP2apqZJTb5fnf351K3XR11MguSH2uvgVhZl4VnVbMtCVpAO
	 l+pPVTxhEAWos0bkuS0Khl2T3pTjd5RwKwyptN/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/568] PCI: keystone: Relocate ks_pcie_set/clear_dbi_mode()
Date: Tue, 30 Jul 2024 17:45:56 +0200
Message-ID: <20240730151649.612850261@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 5125fdc3292eea20870d4e6cefa62dc1245ce7ec ]

Relocate ks_pcie_set_dbi_mode() and ks_pcie_clear_dbi_mode() to avoid
forward declaration in a subsequent patch. No functional change intended.

Link: https://lore.kernel.org/linux-pci/20240328085041.2916899-2-s-vadapalli@ti.com
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 9ffa0e70b2da ("PCI: keystone: Don't enable BAR 0 for AM654x")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 84 +++++++++++------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index cf3836561316d..bf907c8ca25bb 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -246,6 +246,48 @@ static struct irq_chip ks_pcie_msi_irq_chip = {
 	.irq_unmask = ks_pcie_msi_unmask,
 };
 
+/**
+ * ks_pcie_set_dbi_mode() - Set DBI mode to access overlaid BAR mask registers
+ * @ks_pcie: A pointer to the keystone_pcie structure which holds the KeyStone
+ *	     PCIe host controller driver information.
+ *
+ * Since modification of dbi_cs2 involves different clock domain, read the
+ * status back to ensure the transition is complete.
+ */
+static void ks_pcie_set_dbi_mode(struct keystone_pcie *ks_pcie)
+{
+	u32 val;
+
+	val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
+	val |= DBI_CS2;
+	ks_pcie_app_writel(ks_pcie, CMD_STATUS, val);
+
+	do {
+		val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
+	} while (!(val & DBI_CS2));
+}
+
+/**
+ * ks_pcie_clear_dbi_mode() - Disable DBI mode
+ * @ks_pcie: A pointer to the keystone_pcie structure which holds the KeyStone
+ *	     PCIe host controller driver information.
+ *
+ * Since modification of dbi_cs2 involves different clock domain, read the
+ * status back to ensure the transition is complete.
+ */
+static void ks_pcie_clear_dbi_mode(struct keystone_pcie *ks_pcie)
+{
+	u32 val;
+
+	val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
+	val &= ~DBI_CS2;
+	ks_pcie_app_writel(ks_pcie, CMD_STATUS, val);
+
+	do {
+		val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
+	} while (val & DBI_CS2);
+}
+
 static int ks_pcie_msi_host_init(struct dw_pcie_rp *pp)
 {
 	pp->msi_irq_chip = &ks_pcie_msi_irq_chip;
@@ -342,48 +384,6 @@ static const struct irq_domain_ops ks_pcie_legacy_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onetwocell,
 };
 
-/**
- * ks_pcie_set_dbi_mode() - Set DBI mode to access overlaid BAR mask registers
- * @ks_pcie: A pointer to the keystone_pcie structure which holds the KeyStone
- *	     PCIe host controller driver information.
- *
- * Since modification of dbi_cs2 involves different clock domain, read the
- * status back to ensure the transition is complete.
- */
-static void ks_pcie_set_dbi_mode(struct keystone_pcie *ks_pcie)
-{
-	u32 val;
-
-	val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
-	val |= DBI_CS2;
-	ks_pcie_app_writel(ks_pcie, CMD_STATUS, val);
-
-	do {
-		val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
-	} while (!(val & DBI_CS2));
-}
-
-/**
- * ks_pcie_clear_dbi_mode() - Disable DBI mode
- * @ks_pcie: A pointer to the keystone_pcie structure which holds the KeyStone
- *	     PCIe host controller driver information.
- *
- * Since modification of dbi_cs2 involves different clock domain, read the
- * status back to ensure the transition is complete.
- */
-static void ks_pcie_clear_dbi_mode(struct keystone_pcie *ks_pcie)
-{
-	u32 val;
-
-	val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
-	val &= ~DBI_CS2;
-	ks_pcie_app_writel(ks_pcie, CMD_STATUS, val);
-
-	do {
-		val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
-	} while (val & DBI_CS2);
-}
-
 static void ks_pcie_setup_rc_app_regs(struct keystone_pcie *ks_pcie)
 {
 	u32 val;
-- 
2.43.0



