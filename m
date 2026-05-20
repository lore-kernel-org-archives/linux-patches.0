Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A96285061;
	Wed, 20 May 2026 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295593; cv=none; b=af3XrU00f8OEehXAh/+kTC5WaXvlkbx6RmK9o367CqsfF6P9xv+X/i2o7ujLWJJ08otewKqFIh8zRst6+ZQBS06R8e6EGh02YrRI7tRV9NtQoVY9WCrdLV1zkMDV+RUv4urgvVyLdEHCdHyM7/6KReQ+T7oWGqkhwoW6vm1EmNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295593; c=relaxed/simple;
	bh=tgCc89o38wU+TjtD3YTpcuWzNzuBSBPFh4l53ER22XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oX5d293yVxAcATvq71memr5apdyGEi2NbieullApMXZdtAbsvMkQQJ0ovpU29Cq3RqweL7cxIfIJ8pQAEuaPURMquxMS6qZBR37A6yfruSMSfyIG4zvohAiDdGIQBoSabK7OOd+rtGVka7x4YCTvBB2xGfLoK9wiux6n16U8l0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWH+sQyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWH+sQyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F159E1F000E9;
	Wed, 20 May 2026 16:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295592;
	bh=k8HMxdruXge/4DzXqR+O4Leb/T6dRGXvfjzYIX3hNbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWH+sQyr+f0EGG/XFBe6+pvc4ZSEZYrWRqnuGi0yk+wwcdx49ZXtFda5Y0oHu5rcu
	 crAx10jiL9Lgn/prpd0S+FdUPelzDqoWqzQ2ZJvEpMKDCfJ0e2MZEURozgCERBoxNa
	 FHRoRMY56UBOvLkLjBCRXNo2EQgHJL1S66szfd0E=
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
Subject: [PATCH 7.0 0427/1146] PCI: tegra194: Disable L1.2 capability of Tegra234 EP
Date: Wed, 20 May 2026 18:11:17 +0200
Message-ID: <20260520162157.853228889@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 688da5a73d02e..eb24f88e0175b 100644
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
@@ -2444,6 +2462,7 @@ static const struct tegra_pcie_dw_of_data tegra234_pcie_dw_ep_of_data = {
 	.mode = DW_PCIE_EP_TYPE,
 	.has_l1ss_exit_fix = true,
 	.has_ltr_req_fix = true,
+	.disable_l1_2 = true,
 	.cdm_chk_int_en_bit = BIT(18),
 	/* Gen4 - 6, 8 and 9 presets enabled */
 	.gen4_preset_vec = 0x340,
-- 
2.53.0



