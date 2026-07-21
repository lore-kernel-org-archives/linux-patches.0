Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A557E407CCF;
	Tue, 21 Jul 2026 18:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660117; cv=none; b=dEDwzzCKfCjh0Hmw6WUdePZD1ULh7q0fzI789TNR5r/4eEYgk6nDkRmX9JkfHnqr0rUzB5RwEzx5xj9GxEVwrGi67ipG32gNVnx76EHBVcTbXzTEQcK+DbrtbxQWsQU+ktRAgPcQSkjDk+q8DhqLESYDeQKPKoM4hU7xZ8c5npw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660117; c=relaxed/simple;
	bh=aMpCjVmR0/wmUQ67Wq9vIpawiEWKNjDD9wQIdRErPAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1kLgNG5bDwKSewvcFmuTSNGIHd3V4oqj7AGKThxypG9NdmonwfNpnprXQZ87QrKD5lXMWwXNO7qE/HQXeKyeBbmUxHGXcpkCk5a0KD3VXYL4CqnbXa6EGGLIWhdloxn92h0H7+dvvVk8EmPB41JOql46tneYeGXIl94MfmXHjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ij0rxsDt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ij0rxsDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160CD1F000E9;
	Tue, 21 Jul 2026 18:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660116;
	bh=wRZ6SCCgO92AFUWdCXwux9XvBc3R1UjhLTdH3AlrtFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ij0rxsDtGCALCZX9qm0Z03wEWjeTTn4nTgI/EMM7Wa/FFNTL82OtYmkQfsVDc+t/M
	 f1ARSG40zY4nqwTk31WcMqMgTSUvrjpSvLcYI408XYJy/eoGYGYT06f0N7eqkNVt+r
	 lmvz7IhSEEDoa7tQpQk6WNg+4/AgoQi1rvyzYr50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0857/2077] PCI: intel-gw: Add .start_link() callback
Date: Tue, 21 Jul 2026 17:08:50 +0200
Message-ID: <20260721152613.002218895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Eckert <fe@dev.tdt.de>

[ Upstream commit 1eedabe7c6170b5c73c7d801f427c127be74916e ]

The pcie-intel-gw driver had no .start_link() callback.  Add one so the
driver works again and does not abort with the following error messages
during probing:

  intel-gw-pcie d1000000.pcie: host bridge /soc/pcie@d1000000 ranges:
  intel-gw-pcie d1000000.pcie:      MEM 0x00dc000000..0x00ddffffff -> 0x00dc000000
  intel-combo-phy d0c00000.combo-phy: Set combo mode: combophy[1]: mode: PCIe single lane mode
  intel-gw-pcie d1000000.pcie: No outbound iATU found
  intel-gw-pcie d1000000.pcie: Cannot initialize host
  intel-gw-pcie d1000000.pcie: probe with driver intel-gw-pcie failed with error -22
  intel-gw-pcie c1100000.pcie: host bridge /soc/pcie@c1100000 ranges:
  intel-gw-pcie c1100000.pcie:      MEM 0x00ce000000..0x00cfffffff -> 0x00ce000000
  intel-combo-phy c0c00000.combo-phy: Set combo mode: combophy[3]: mode: PCIe single lane mode
  intel-gw-pcie c1100000.pcie: No outbound iATU found
  intel-gw-pcie c1100000.pcie: Cannot initialize host
  intel-gw-pcie c1100000.pcie: probe with driver intel-gw-pcie failed with error -22

Fixes: c5097b9869a1 ("Revert "PCI: dwc: Wait for link up only if link is started"")
Fixes: da56a1bfbab5 ("PCI: dwc: Wait for link up only if link is started")
Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: remove timestamps]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260417-pcie-intel-gw-v5-5-0a2b933fe04f@dev.tdt.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-intel-gw.c | 24 ++++++++++------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-intel-gw.c b/drivers/pci/controller/dwc/pcie-intel-gw.c
index e84703c1c4a1c8..f157c716953c2d 100644
--- a/drivers/pci/controller/dwc/pcie-intel-gw.c
+++ b/drivers/pci/controller/dwc/pcie-intel-gw.c
@@ -285,6 +285,16 @@ static void intel_pcie_turn_off(struct intel_pcie *pcie)
 	pcie_rc_cfg_wr_mask(pcie, PCI_COMMAND, PCI_COMMAND_MEMORY, 0);
 }
 
+static int intel_pcie_start_link(struct dw_pcie *pci)
+{
+	struct intel_pcie *pcie = dev_get_drvdata(pci->dev);
+
+	intel_pcie_device_rst_deassert(pcie);
+	intel_pcie_ltssm_enable(pcie);
+
+	return 0;
+}
+
 static int intel_pcie_host_setup(struct intel_pcie *pcie)
 {
 	int ret;
@@ -311,25 +321,12 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 	intel_pcie_link_setup(pcie);
 	intel_pcie_init_n_fts(pci);
 
-	ret = dw_pcie_setup_rc(&pci->pp);
-	if (ret)
-		goto err;
-
 	dw_pcie_upconfig_setup(pci);
 
-	intel_pcie_device_rst_deassert(pcie);
-	intel_pcie_ltssm_enable(pcie);
-
-	ret = dw_pcie_wait_for_link(pci);
-	if (ret)
-		goto err;
-
 	intel_pcie_core_irq_enable(pcie);
 
 	return 0;
 
-err:
-	phy_exit(pcie->phy);
 phy_err:
 	clk_disable_unprepare(pcie->core_clk);
 clk_err:
@@ -387,6 +384,7 @@ static int intel_pcie_rc_init(struct dw_pcie_rp *pp)
 }
 
 static const struct dw_pcie_ops intel_pcie_ops = {
+	.start_link = intel_pcie_start_link,
 };
 
 static const struct dw_pcie_host_ops intel_pcie_dw_ops = {
-- 
2.53.0



