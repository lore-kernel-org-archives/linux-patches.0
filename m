Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672E32367DF;
	Wed, 20 May 2026 17:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298229; cv=none; b=toPRsayDPNRh3Vpi2ll/zV0EOvwJOFqz4qvQZrO0UK4Z/rJI1M/dEtBd1AuatdFgusrm69SgIM9UE4CG6Vti1EEdCjgJCoA+/D3ljSg393vFnjXDHeXqEcv33GSVyT6Ep1J8KLwENB3LzqJDgGFmGVK1aJsjBATrhBvN76Myebs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298229; c=relaxed/simple;
	bh=stkKOk6qLv279aAEoTwkiOJqEMcORMbwtiVTAs/qFLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjrlIzCw0v639+2/B3KX+d/Z4atPuTn6+JQnRT2ERLLsSFbF8c9Dbpd6KaqY/rnRWrGYKto1yBxxqbIvDe6K3gBzkPan4MNZLxeH+8L7OqDTeTF2RKyTQXf4MzPGiqhmzo8IYlIJzmeOZMdtR8lybQ1Tl+vzZ14OwA+ChCs5ehM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/KKFtgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/KKFtgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB32A1F00894;
	Wed, 20 May 2026 17:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298228;
	bh=hsMSOAH/Pcz65yuwja7UsY+hgD3FTcqLDYci7SqZn4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/KKFtgOQLXiH7AxKnNiRTdB/HrZ0IlfvUxAh9OJwrR9Q5rpgQJYnveF3EZQVq0je
	 +M4PTTwVmf49fj1llogXfakczfdN40uHfqAiLAtXX6yUHmh5j/+lTj5B2dZSfe9UxG
	 BmuAu+M17TiJCUlwP+Sn9LS8erSf0I3E4OmWPqXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 331/957] PCI: tegra194: Disable L1.2 capability of Tegra234 EP
Date: Wed, 20 May 2026 18:13:34 +0200
Message-ID: <20260520162141.708673606@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit f59df1d9e6bdb6bd7ef65fb5d200900ac40c20ba ]

When Tegra234 is operating in the Endpoint mode with L1.2 enabled, PCIe
link goes down during L1.2 exit. This is because Tegra234 powers up UPHY
PLL immediately without making sure that the REFCLK is stable.

This causes UPHY PLL to fail to lock to the correct frequency and leads to
link going down. There is no hardware fix for this, hence do not advertise
the L1.2 capability in the Endpoint mode.

Fixes: a54e19073718 ("PCI: tegra194: Add Tegra234 PCIe support")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-14-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 257965ada3bd0..c37be61f2b90a 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -234,6 +234,7 @@ struct tegra_pcie_dw_of_data {
 	bool has_sbr_reset_fix;
 	bool has_l1ss_exit_fix;
 	bool has_ltr_req_fix;
+	bool disable_l1_2;
 	u32 cdm_chk_int_en_bit;
 	u32 gen4_preset_vec;
 	u8 n_fts[2];
@@ -679,6 +680,23 @@ static void init_host_aspm(struct tegra_pcie_dw *pcie)
 	if (pcie->supports_clkreq)
 		pci->l1ss_support = true;
 
+	/*
+	 * Disable L1.2 capability advertisement for Tegra234 Endpoint mode.
+	 * Tegra234 has a hardware bug where during L1.2 exit, the UPHY PLL is
+	 * powered up immediately without waiting for REFCLK to stabilize. This
+	 * causes the PLL to fail to lock to the correct frequency, resulting in
+	 * PCIe link loss. Since there is no hardware fix available, we prevent
+	 * the Endpoint from advertising L1.2 support by clearing the L1.2 bits
+	 * in the L1 PM Substates Capabilities register. This ensures the host
+	 * will not attempt to enter L1.2 state with this Endpoint.
+	 */
+	if (pcie->of_data->disable_l1_2 &&
+	    pcie->of_data->mode == DW_PCIE_EP_TYPE) {
+		val = dw_pcie_readl_dbi(pci, l1ss + PCI_L1SS_CAP);
+		val &= ~(PCI_L1SS_CAP_PCIPM_L1_2 | PCI_L1SS_CAP_ASPM_L1_2);
+		dw_pcie_writel_dbi(pci, l1ss + PCI_L1SS_CAP, val);
+	}
+
 	/* Program L0s and L1 entrance latencies */
 	val = dw_pcie_readl_dbi(pci, PCIE_PORT_AFR);
 	val &= ~PORT_AFR_L0S_ENTRANCE_LAT_MASK;
@@ -2443,6 +2461,7 @@ static const struct tegra_pcie_dw_of_data tegra234_pcie_dw_ep_of_data = {
 	.mode = DW_PCIE_EP_TYPE,
 	.has_l1ss_exit_fix = true,
 	.has_ltr_req_fix = true,
+	.disable_l1_2 = true,
 	.cdm_chk_int_en_bit = BIT(18),
 	/* Gen4 - 6, 8 and 9 presets enabled */
 	.gen4_preset_vec = 0x340,
-- 
2.53.0



