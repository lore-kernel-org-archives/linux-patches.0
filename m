Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3431D3DC4DD;
	Wed, 30 Sep 2026 18:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793962; cv=none; b=mWSpLeLvvo8Sbu5x8fBJIXUe4fXjTLTuZ8+CM8QxqOrigE8sXCmT0E9pCTBuHodSAc0JworzE8Q343/E9y0nlHcAJ9W4X89b7YpuvB7IQSyGiTCuvqX1HapWOUgagisH9dDc4M6Eo6nV9CoxpgKGbs+LjUGOEHX24vwrjGzHU3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793962; c=relaxed/simple;
	bh=DOBDrwnXkdl0PgwP55A9Pekd6k3YFbdNLqSZIBsTvyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NNmeCMi0ks8CB1x1wQ4B0bpTFRcfbBIUo1jE5CFmj3YtUwPpZqAKi24CQWBf+64MKu1EBYS+oLPtzpOHwu+MPMu1W31j6mGG3uPE8HU/9+J5SmZakqaEbG3HIRGQHxnzCbXqaFXkZAiv71o/YHHK0l24ii9hbp3ZWTKxLlCRnPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dn8yJpQQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dn8yJpQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915551F00899;
	Wed, 30 Sep 2026 18:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793960;
	bh=TtM0F0rEgzZd6MZAR7wlhn79XxW8cp+UYgmQC3KjH3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dn8yJpQQIBoH1w1z/ihYrsLtp9s6PDAfQ1JiUCjy+vbesZ32J+/IC65OOQHdzQMal
	 XQlJcog8TIH8jAqXlq6Uy01KdR8L5SuVObcOyr7jXu0Lhk3omPM8hrxlVNE4Fa56CB
	 VK8hOA2Ngn3hW/1nX+EW7NqNo5NTzG7/kMS1qZ/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0042/1193] PCI: intel-gw: Enable clock before PHY init
Date: Wed, 30 Sep 2026 17:12:06 +0200
Message-ID: <20260930152435.219530289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Florian Eckert <fe@dev.tdt.de>

[ Upstream commit febf9ed3c35e5eec7ea384ebbd55a5296e3ca5e9 ]

To ensure that the boot sequence is correct, the DWC PCIe core clock must
be switched on before PHY init call [1]. This changes are based on patched
kernel sources of the MaxLinear SDK.

The reason why the MaxLinear SDK is used as a reference here is, that this
PCIe DWC IP is used in the URX851 and URX850 SoC. This SoC was originally
developed by Intel when they acquired Lantiq’s home networking division in
2015 [2]. In 2020 the home network division was sold to MaxLinear [3].
Since then, this SoC belongs to MaxLinear. They use their own SDK, which
runs on kernel version '5.15.x'.

[1] https://github.com/maxlinear/linux/blob/updk_9.1.90/drivers/pci/controller/dwc/pcie-intel-gw.c#L544
[2] https://www.intc.com/news-events/press-releases/detail/364/intel-to-acquire-lantiq-advancing-the-connected-home
[3] https://investors.maxlinear.com/press-releases/detail/395/maxlinear-to-acquire-intels-home-gateway-platform

Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260417-pcie-intel-gw-v5-4-0a2b933fe04f@dev.tdt.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-intel-gw.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-intel-gw.c b/drivers/pci/controller/dwc/pcie-intel-gw.c
index c9c93524e01dc..f5e7c57ceae89 100644
--- a/drivers/pci/controller/dwc/pcie-intel-gw.c
+++ b/drivers/pci/controller/dwc/pcie-intel-gw.c
@@ -286,13 +286,9 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
 	intel_pcie_core_rst_assert(pcie);
 	intel_pcie_device_rst_assert(pcie);
-
-	ret = phy_init(pcie->phy);
-	if (ret)
-		return ret;
-
 	intel_pcie_core_rst_deassert(pcie);
 
+	/* Controller clock must be provided earlier than PHY */
 	ret = clk_prepare_enable(pcie->core_clk);
 	if (ret) {
 		dev_err(pcie->pci.dev, "Core clock enable failed: %d\n", ret);
@@ -301,13 +297,17 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
 	pci->atu_base = pci->dbi_base + 0xC0000;
 
+	ret = phy_init(pcie->phy);
+	if (ret)
+		goto phy_err;
+
 	intel_pcie_ltssm_disable(pcie);
 	intel_pcie_link_setup(pcie);
 	intel_pcie_init_n_fts(pci);
 
 	ret = dw_pcie_setup_rc(&pci->pp);
 	if (ret)
-		goto app_init_err;
+		goto err;
 
 	dw_pcie_upconfig_setup(pci);
 
@@ -316,7 +316,7 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
 	ret = dw_pcie_wait_for_link(pci);
 	if (ret)
-		goto app_init_err;
+		goto err;
 
 	/* Enable integrated interrupts */
 	pcie_app_wr_mask(pcie, PCIE_APP_IRNEN, PCIE_APP_IRN_INT,
@@ -324,11 +324,12 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
 	return 0;
 
-app_init_err:
+err:
+	phy_exit(pcie->phy);
+phy_err:
 	clk_disable_unprepare(pcie->core_clk);
 clk_err:
 	intel_pcie_core_rst_assert(pcie);
-	phy_exit(pcie->phy);
 
 	return ret;
 }
-- 
2.53.0



