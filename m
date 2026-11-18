Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016834;
	b=a0y7CWxn41Adk2fhwZaNTRCE3T4K3/DGnroI0309Uj+3h1UgsXxGnzB6omn2d0JJzBj9
	 xVaTQwpfcpzcPbJwnuXGaPOw+2TPARc3l45SAw9wAcpeS0XxIQoJjkRhySL4Bfkou+Sls
	 4XIf9AyfhToVknJZJvVwP0KRRxvsEGg0bnQ8xIQ7S5W7f8I+WH/DNxPh1tkKHfIv6KW58
	 RsFh92qnNhNbbtcGT1bVjoUKhcsABgBBM84MkJi+FCKmSp6lubucsBy74IF63Ie63pcXr
	 JVJ0a4vN/q1triVznNOw6EPz4AhUxER+pVrjk2+QdDXgSK7y+ztoFzoi96xeY3M8+2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nWFT282nqirfFnpBwYhaA0pkUu8Tmx2mQQWRIva1KI0=;
	b=tRLTyT+6M8C4wRO1j220+uDkFlESTxj514c8VirHGE3DQpkF6DxO4JSDSJ2zPU/VjZNy
	 O8ce+djMEHjlNRfs2vFYp69Js4bPtfQ+48eT3SyGy3NN9hCV2ONSWQlyFkUqqsAfP2ZH+
	 AF/FbfcMu3RJ5g0MoKAORAvV6EMQgOu0GV1tPKkwLcTwvlHnr8cT5V+rNNX/7BSBwJD1P
	 M9ovBZURz0hyB8iHtj5kEwp1Cpjm/sknMHPnGePx4n3l9gozxCmqfNH6PLXkfJJxQYixK
	 sex5Vs0eqYI8z9ryJG5ocXQ4KeI515AEAib6NYaA4U1yLfFuWvJcoytq5TelNU/cayg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QgfapMHZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2913A606A331;
	Wed, 18 Nov 2026 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QgfapMHZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F471F000C4;
	Wed, 18 Nov 2026 15:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016834;
	bh=nWFT282nqirfFnpBwYhaA0pkUu8Tmx2mQQWRIva1KI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgfapMHZ2Erf6bgMFDf52cMfEIVkpXpHXf4938IrIuX2g7w2kyh375B1KInq6p/O8
	 auIwUDQbw9tR0CgOHNCBjPGLz2guXSJsh13HkYJ9Kqji6bjsVc7vIbLwxBS5NulXrx
	 /Yx1nTsWCbwUVCHrf3qTmHOz2HdwY+jRvsd8JtcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Zhijian Han <hanzhijian1991@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0669/2651] PCI: imx6: Fix resource leaks in probe error paths
Date: Wed, 18 Nov 2026 15:31:49 +0100
Message-ID: <20261118150311.956075717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhijian Han <hanzhijian1991@gmail.com>

[ Upstream commit 1e184f38851ff6fac0b72bfb7f51db47ed6f257f ]

imx_pcie_probe() leaks both pwrctrl devices and power domains on failure:

  - imx_pcie_attach_pd() attaches the "pcie" and "pcie_phy" power domains
    and adds device links to them, but nothing detaches the domains or
    removes the links on probe failure or deferral, so they leak.

  - A failure of devm_pm_runtime_set_active_enabled() returns directly
    without destroying the pwrctrl devices.

  - A partial failure inside imx_pcie_attach_pd() leaks the power domains
    that were already attached.

Add imx_pcie_detach_pd_action() to remove the device links and detach the
power domains in reverse order of acquisition and register it with
devm_add_action_or_reset() so they are released automatically on probe
failure.

Fixes: 2c5768344f88 ("PCI: imx6: Move pci_pwrctrl_create_devices() to imx_pcie_probe()")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/all/20260822013640.182C01F000E9@smtp.kernel.org/
Signed-off-by: Zhijian Han <hanzhijian1991@gmail.com>
[mani: removed the imx_pcie_detach_pd() helper]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
[bhelgaas: update commit log to match inlining of imx_pcie_detach_pd() into
imx_pcie_detach_pd_action()]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260904012307.3434449-1-hanzhijian1991@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 54 +++++++++++++++++++++------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 785f575e0134e..59b23eb8e9562 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -180,8 +180,12 @@ struct imx_pcie {
 	struct imx_lut_data	luts[IMX95_MAX_LUT];
 	/* power domain for pcie */
 	struct device		*pd_pcie;
+	/* device link for pcie power domain */
+	struct device_link	*pd_link;
 	/* power domain for pcie phy */
 	struct device		*pd_pcie_phy;
+	/* device link for pcie phy power domain */
+	struct device_link	*pd_phy_link;
 	struct phy		*phy;
 	const struct imx_pcie_drvdata *drvdata;
 
@@ -639,10 +643,34 @@ static int imx6q_pcie_abort_handler(unsigned long addr,
 }
 #endif
 
+static void imx_pcie_detach_pd_action(void *data)
+{
+	struct imx_pcie *imx_pcie = data;
+
+	if (!IS_ERR_OR_NULL(imx_pcie->pd_phy_link)) {
+		device_link_del(imx_pcie->pd_phy_link);
+		imx_pcie->pd_phy_link = NULL;
+	}
+
+	if (!IS_ERR_OR_NULL(imx_pcie->pd_link)) {
+		device_link_del(imx_pcie->pd_link);
+		imx_pcie->pd_link = NULL;
+	}
+
+	if (!IS_ERR_OR_NULL(imx_pcie->pd_pcie_phy)) {
+		dev_pm_domain_detach(imx_pcie->pd_pcie_phy, true);
+		imx_pcie->pd_pcie_phy = NULL;
+	}
+
+	if (!IS_ERR_OR_NULL(imx_pcie->pd_pcie)) {
+		dev_pm_domain_detach(imx_pcie->pd_pcie, true);
+		imx_pcie->pd_pcie = NULL;
+	}
+}
+
 static int imx_pcie_attach_pd(struct device *dev)
 {
 	struct imx_pcie *imx_pcie = dev_get_drvdata(dev);
-	struct device_link *link;
 
 	/* Do nothing when in a single power domain */
 	if (dev->pm_domain)
@@ -654,11 +682,11 @@ static int imx_pcie_attach_pd(struct device *dev)
 	/* Do nothing when power domain missing */
 	if (!imx_pcie->pd_pcie)
 		return 0;
-	link = device_link_add(dev, imx_pcie->pd_pcie,
-			DL_FLAG_STATELESS |
-			DL_FLAG_PM_RUNTIME |
-			DL_FLAG_RPM_ACTIVE);
-	if (!link) {
+	imx_pcie->pd_link = device_link_add(dev, imx_pcie->pd_pcie,
+					    DL_FLAG_STATELESS |
+					    DL_FLAG_PM_RUNTIME |
+					    DL_FLAG_RPM_ACTIVE);
+	if (!imx_pcie->pd_link) {
 		dev_err(dev, "Failed to add device_link to pcie pd\n");
 		return -EINVAL;
 	}
@@ -667,11 +695,11 @@ static int imx_pcie_attach_pd(struct device *dev)
 	if (IS_ERR(imx_pcie->pd_pcie_phy))
 		return PTR_ERR(imx_pcie->pd_pcie_phy);
 
-	link = device_link_add(dev, imx_pcie->pd_pcie_phy,
-			DL_FLAG_STATELESS |
-			DL_FLAG_PM_RUNTIME |
-			DL_FLAG_RPM_ACTIVE);
-	if (!link) {
+	imx_pcie->pd_phy_link = device_link_add(dev, imx_pcie->pd_pcie_phy,
+						DL_FLAG_STATELESS |
+						DL_FLAG_PM_RUNTIME |
+						DL_FLAG_RPM_ACTIVE);
+	if (!imx_pcie->pd_phy_link) {
 		dev_err(dev, "Failed to add device_link to pcie_phy pd\n");
 		return -EINVAL;
 	}
@@ -1952,6 +1980,10 @@ static int imx_pcie_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, imx_pcie);
 
+	ret = devm_add_action_or_reset(dev, imx_pcie_detach_pd_action, imx_pcie);
+	if (ret)
+		return ret;
+
 	ret = imx_pcie_attach_pd(dev);
 	if (ret)
 		return ret;
-- 
2.53.0



