Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF3C18801A;
	Tue, 30 Jul 2024 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358668; cv=none; b=pPDmOSRu9pS4zWw/8sBUIWuYc0/g41f1YlkcckRzOaPjNjWc0NbgV/GuTWRgJzOz3BIyc91/CvpI5m7s/82QSfb9nE0xkgRAvYC2QCOgUFOIfkNAEJura9hqvNyBpC4qic48HNiY2G6TViKO6k4IZLRBWwiOAIQgyliRVnEkFKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358668; c=relaxed/simple;
	bh=fGLyJ0a72zkLrokuqMq8bOGXm2NPi3dBZCyXCrLrRik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SQ43rgitjJRqyVDcyotyx/GBoeTyV/hcCLZi/5lg4cjcTXQc0peCWhm1QhxN925eU/foAgUgSJ+b9O5HnQBdoBiDt7PM71bfqKXmKG8xAN/REcrRqMjznHPCi4OaBLt/iJHF9anu5JHriHuIEcyt6lSmWH3YgMjlMUBKpVEZ1QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2zO9h/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2zO9h/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD49C32782;
	Tue, 30 Jul 2024 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358668;
	bh=fGLyJ0a72zkLrokuqMq8bOGXm2NPi3dBZCyXCrLrRik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2zO9h/6lUDgsT1Kf7qnZa9z11FJl5bXS0vY3tVPfg7T+A87CBXpXwY25eZ7uTp60
	 MmkuSdzJHDc3MhehT11/tfrE7pcBeLCfuIX7V+MVTCkFh5viqRuzYmoxsQqA5SyKh3
	 5WQtbOFw2GhmBFQjatsTmLr88ifwPzfEuiAaZTnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 383/809] PCI: keystone: Relocate ks_pcie_set/clear_dbi_mode()
Date: Tue, 30 Jul 2024 17:44:19 +0200
Message-ID: <20240730151739.795915938@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
index d3a7d14ee685a..cff5bca45878d 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -245,6 +245,48 @@ static struct irq_chip ks_pcie_msi_irq_chip = {
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
@@ -340,48 +382,6 @@ static const struct irq_domain_ops ks_pcie_intx_irq_domain_ops = {
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



