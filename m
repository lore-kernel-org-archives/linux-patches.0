Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970E41A6193;
	Tue, 30 Jul 2024 16:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356361; cv=none; b=iBYd5uAOEiN4PK+XB0RgFiWr0sK/M4ewOcpL1U9TD8pEkN68LSHmXl/R/4q3iEMoIX5ztaiausnBC8V5eS8n8nnZAGvNxNg/9ls199A+4CIzEIbIpATh7kv/u+QTIBaIAicyY7QPbwvMTk7dxXyf2o7v+dt0I+wc56nd6zE1AdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356361; c=relaxed/simple;
	bh=8PnXbxNr/uPNolDvZXOfBhIMQHGAJlGIpIyvc36qzn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ibh10YcZLb+W+bb8gMoUQP9WET2V6nj5pfsCiV2YaPaEG37to3aRbP/UWPmEx04wqrAfWbeRhYonQFdwLh7AzRPHjOOhqEd8ZVRBpN1iL5shpFKq3fHoDkegGgO0C4D4JQhZK2QuEFkOvNh2ScbvOCDL9rGBiJUElnuTXjq9QQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoQ6vEvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoQ6vEvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D55DC32782;
	Tue, 30 Jul 2024 16:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356361;
	bh=8PnXbxNr/uPNolDvZXOfBhIMQHGAJlGIpIyvc36qzn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoQ6vEvnC6Da4SuHKflBsnqLi5QfR6iTTLKbIVW2qlRs2gQ/JQSKLmafQHA3haJk8
	 RBMtJcn/93yfgGT0hzsuHs17z+JXI161HwxK4pdMbzaULjfyFaaRt7EcI6uwyHae+/
	 hErKrVKxI/6jJzjVHX0UbSkUuWWuhYTdpDyB1rog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/440] PCI: keystone: Relocate ks_pcie_set/clear_dbi_mode()
Date: Tue, 30 Jul 2024 17:46:51 +0200
Message-ID: <20240730151622.826205334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7ecad72cff7e7..348a9f755d0ba 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -247,6 +247,48 @@ static struct irq_chip ks_pcie_msi_irq_chip = {
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
@@ -343,48 +385,6 @@ static const struct irq_domain_ops ks_pcie_legacy_irq_domain_ops = {
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



