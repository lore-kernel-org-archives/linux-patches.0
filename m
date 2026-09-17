Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32F64E4C35;
	Thu, 17 Sep 2026 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661160; cv=none; b=NmKHmK8OKNYggdqlpDuQd2A9jeNX3J0Vq20IqBwAMKEoTdRQWDGPX+Bdg0xEjEUm/52WFbGxll0rvUta04IojDBifu/Sw7YxD4OczrHH/VmgH4P8AZcICwXV5OvmAvtJa+FdDtjyYa3Jft2dzgqWdYBgQOR1bzmFIEsNksVQZ58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661160; c=relaxed/simple;
	bh=GGIRxxZTNlh1R4NC2LRauT/RAoGUFThQA1t52Gy+xz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HRzLKB5F3xNLx+p0hAnPFau/K55xBFfmmFpMok5GRA+tpZkCtfXQpWGjNBZcKZww75Wv6QA0+gnuGe4YxFIr/BETwMHq+QXLixIlZBx8ENaOPPscLglNwoarURMV0MeehNigscHvCyQpKiTnHHTIaRie+DEcUPc/huXFB8QTzZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBFl8kLF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBFl8kLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349711F000FF;
	Thu, 17 Sep 2026 16:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661158;
	bh=RWZw+VnMs4lDcYQ3aq8Qc014RkdH0lHWc8FrZD8/G7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qBFl8kLFMKD+HyCQwQf3xl8FWS6wZLNSLz3gotQQkN6thwH1U4yWBWQw0FSSSbm2R
	 GAYXUbHnRH1ZtN+pJVjzbVaQLB+iJb/YdJRWIccp8BHM4WupGt/BH7GqNbev8xb1cq
	 n8ryTIKAUxFgmrptn5IYWMQVkBBaz8wt23tGkQdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0102/1250] PCI: intel-gw: Enable clock before PHY init
Date: Thu, 17 Sep 2026 15:58:17 +0100
Message-ID: <20260917151554.757251785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c21906eced618..8b51eb30112d9 100644
--- a/drivers/pci/controller/dwc/pcie-intel-gw.c
+++ b/drivers/pci/controller/dwc/pcie-intel-gw.c
@@ -285,13 +285,9 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
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
@@ -300,13 +296,17 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
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
 
@@ -315,7 +315,7 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
 	ret = dw_pcie_wait_for_link(pci);
 	if (ret)
-		goto app_init_err;
+		goto err;
 
 	/* Enable integrated interrupts */
 	pcie_app_wr_mask(pcie, PCIE_APP_IRNEN, PCIE_APP_IRN_INT,
@@ -323,11 +323,12 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
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



