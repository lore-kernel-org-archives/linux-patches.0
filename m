Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4903F23A1;
	Wed, 20 May 2026 18:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302157; cv=none; b=MI4C5KVn9ywvI31ubM4ctMeSs6QlMoUTABGYO5Wm+zQriXva89cSjHL7m6mLtaibeDqSHW+PUcQYl0S0CSI4LYp9WolA7kNGCZZjNUwcHAs+CV1iqLExqX0UW7GSnzybLN+iFkTVG1JNX0fqrtFRksm83Zu3tt1Scd/2GsNGV0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302157; c=relaxed/simple;
	bh=0T9yOWZ5cJUfcTUJ0SpHNEU2DWZWcABxtnkYmDZxfyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUKbNEKcRKvIizyDAVQeIu2zRH7wsQHHwrd1ZduR9lXWn+fCR1kje0hjN0pIBffsEb33viTZfBXMjACaEQ2PIwyTmmIUuLScHhaZ0UZW/rTR4nFXg/xIlrO6q2l4vS8ewRlClmR1AdQU61bJP4Tay3G7XvmsZqo7Pj2cJ0C10JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrCT9vqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrCT9vqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FF81F000E9;
	Wed, 20 May 2026 18:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302156;
	bh=vvFTGA8W2twh0LOLl5rDpwyN0Upcd08aCUijNYIfpgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrCT9vqKjYDrc+jC01WqxRnUf5FfNVeYd8DbyD3D+REkUo1p2x1CsoXz/dhHidaLt
	 MEX+ystJtlfkvaiZ7l0wkpR0uVUssxZkOGTf7t9LLDMCX7mSoBavIDbm4r+Uo2+jZM
	 Nmhmf20jk658U+uvA9CchvXeWAyrMzdZP3GXyxoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/508] PCI: tegra194: Rename root_bus to root_port_bus in tegra_pcie_downstream_dev_to_D0()
Date: Wed, 20 May 2026 18:19:42 +0200
Message-ID: <20260520162102.085106796@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit e1bd928479fb1fa60e9034b0fdb1ab9f3fa92f33 ]

In tegra_pcie_downstream_dev_to_D0(), PCI devices are transitioned to D0
state. For iterating over the devices, first the downstream bus of the Root
Port is searched from the root bus. But the name of the variable that holds
the Root Port downstream bus is named as 'root_bus', which is wrong.

Rename the variable to 'root_port_bus'. Also, move the comment on 'bringing
the devices to D0' to where the state is set exactly.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250922081057.15209-1-mani@kernel.org
Stable-dep-of: 71d9f67701e1 ("PCI: tegra194: Don't force the device into the D0 state before L2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index e79f77c3152da..47421796cc147 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1291,7 +1291,7 @@ static int tegra_pcie_bpmp_set_pll_state(struct tegra_pcie_dw *pcie,
 static void tegra_pcie_downstream_dev_to_D0(struct tegra_pcie_dw *pcie)
 {
 	struct dw_pcie_rp *pp = &pcie->pci.pp;
-	struct pci_bus *child, *root_bus = NULL;
+	struct pci_bus *child, *root_port_bus = NULL;
 	struct pci_dev *pdev;
 
 	/*
@@ -1304,19 +1304,19 @@ static void tegra_pcie_downstream_dev_to_D0(struct tegra_pcie_dw *pcie)
 	 */
 
 	list_for_each_entry(child, &pp->bridge->bus->children, node) {
-		/* Bring downstream devices to D0 if they are not already in */
 		if (child->parent == pp->bridge->bus) {
-			root_bus = child;
+			root_port_bus = child;
 			break;
 		}
 	}
 
-	if (!root_bus) {
-		dev_err(pcie->dev, "Failed to find downstream devices\n");
+	if (!root_port_bus) {
+		dev_err(pcie->dev, "Failed to find downstream bus of Root Port\n");
 		return;
 	}
 
-	list_for_each_entry(pdev, &root_bus->devices, bus_list) {
+	/* Bring downstream devices to D0 if they are not already in */
+	list_for_each_entry(pdev, &root_port_bus->devices, bus_list) {
 		if (PCI_SLOT(pdev->devfn) == 0) {
 			if (pci_set_power_state(pdev, PCI_D0))
 				dev_err(pcie->dev,
-- 
2.53.0



