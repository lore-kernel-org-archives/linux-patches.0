Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059758;
	b=fN6GwH7r1BRWpn+I2novh3yFQKpZrQGpr1BuhjFprAZNce2LVqSPGxAqu6W6T0L6nvzv
	 Wm/2gJEnrIOoK9ULM8osm0CiRmHpPCudnyu/R8c4aqSqhsQ41OpsXDFJCCutq5ZKi2aNM
	 wXoziPOQl5Wl1f18EOCCOlnXw0ez+8LoGoCISxfGg3OS7YzwPPfZY8iTQzySvY6I0SFCk
	 qiFxHD+VB8n2Dn+vqhu9T9Mhm/I66RG+dGXS46zXwd7awApnDRUOQvXo6DIqVkzvwP1ih
	 1tAVrL4BKFeloJVDINHibSe+pt0hRNVQvLGyCRu9NdmoIUj6zBqUR6jJu9UBk6fgUOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WMFXejn46qmBdnrsoPaWqJ+Z4cHCUWu84sG5gH3Kmi8=;
	b=YbIectxPkOa0IIuiMEs2EyU2uJvjC32hm40vM8u5nJAPAJsnJGhOqRwjVSdez+voZXfG
	 JtCSE0Gm65/athKhwoSYUBkox4ex8IeCKe1VApCbcaBxjroJNHvS8FsCMTutKM4DgMMyp
	 qclaxMxRs/8/ELVaetZO2Jc26hpZgLiI55tTSmaRCMUUduwZovJ7oO5BloCf9rvKyqhWa
	 hhNjzdsCiuMhZ+WN0Afec/op3PdeDKann8lTkBaLNJ8ncbA4wp5b8q0LiQN/2VgTw01Ag
	 MzE5Zh3TZfJuQoFCKNtKtY+pR0XQlUkvzbugRAVW9CHq41jWK1GSDAC8cORzZw7wUag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pUM+iiJ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DB5606A320;
	Thu, 19 Nov 2026 03:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUM+iiJ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6907A1F000C4;
	Thu, 19 Nov 2026 03:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059757;
	bh=WMFXejn46qmBdnrsoPaWqJ+Z4cHCUWu84sG5gH3Kmi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUM+iiJ/tCRjf/41YAdfxCsrOh0O0bTcSkXXNu3H9BWI67EIYQ+8y6uheSW/7o30Y
	 9wzm9DN6F8KhBXlzFIz7C3mEZQXI9E4MHT8VYn5fVS8AyVD0dLfswhI6RSmeyBejl9
	 7VQz3kY4cp3pYM3wbvCplT6NNfb5hGuLXOKKQwUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Aksh Garg <a-garg7@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0956/1848] PCI: cadence: Store the core controller in platform drvdata
Date: Wed, 18 Nov 2026 15:49:54 +0100
Message-ID: <20261118145957.029636751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit cfe96ce583c51bf6e034d4038c652a1e8227867c ]

cdns_plat_pcie_probe() stores a struct cdns_plat_pcie pointer with
platform_set_drvdata(). cdns_plat_pcie_shutdown() and the callbacks in
cdns_pcie_pm_ops retrieve the same pointer with dev_get_drvdata() but use
it as a struct cdns_pcie pointer. This makes them read phy_count and phy
beyond the wrapper.

struct cdns_plat_pcie only contains a pointer to struct cdns_pcie. Drop
the redundant wrapper and store the struct cdns_pcie pointer directly.

Fixes: bd22885aa188 ("PCI: cadence: Refactor driver to use as a core library")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Aksh Garg <a-garg7@ti.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260915082826.4135665-1-lilinmao@kylinos.cn
[ sashal: placed platform_set_drvdata() in each controller-mode branch instead of at the end of probe ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../controller/cadence/pcie-cadence-plat.c    | 36 ++++++-------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-plat.c b/drivers/pci/controller/cadence/pcie-cadence-plat.c
index a224afadbcc00..181b36a5d159d 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-plat.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-plat.c
@@ -15,17 +15,6 @@
 
 #define CDNS_PLAT_CPU_TO_BUS_ADDR	0x0FFFFFFF
 
-/**
- * struct cdns_plat_pcie - private data for this PCIe platform driver
- * @pcie: Cadence PCIe controller
- * @is_rc: Set to 1 indicates the PCIe controller mode is Root Complex,
- *         if 0 it is in Endpoint mode.
- */
-struct cdns_plat_pcie {
-	struct cdns_pcie        *pcie;
-	bool is_rc;
-};
-
 struct cdns_plat_pcie_of_data {
 	bool is_rc;
 };
@@ -44,10 +33,10 @@ static const struct cdns_pcie_ops cdns_plat_ops = {
 static int cdns_plat_pcie_probe(struct platform_device *pdev)
 {
 	const struct cdns_plat_pcie_of_data *data;
-	struct cdns_plat_pcie *cdns_plat_pcie;
 	const struct of_device_id *match;
 	struct device *dev = &pdev->dev;
 	struct pci_host_bridge *bridge;
+	struct cdns_pcie *pcie;
 	struct cdns_pcie_ep *ep;
 	struct cdns_pcie_rc *rc;
 	int phy_count;
@@ -62,11 +51,6 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 	is_rc = data->is_rc;
 
 	pr_debug(" Started %s with is_rc: %d\n", __func__, is_rc);
-	cdns_plat_pcie = devm_kzalloc(dev, sizeof(*cdns_plat_pcie), GFP_KERNEL);
-	if (!cdns_plat_pcie)
-		return -ENOMEM;
-
-	platform_set_drvdata(pdev, cdns_plat_pcie);
 	if (is_rc) {
 		if (!IS_ENABLED(CONFIG_PCIE_CADENCE_PLAT_HOST))
 			return -ENODEV;
@@ -78,10 +62,10 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 		rc = pci_host_bridge_priv(bridge);
 		rc->pcie.dev = dev;
 		rc->pcie.ops = &cdns_plat_ops;
-		cdns_plat_pcie->pcie = &rc->pcie;
-		cdns_plat_pcie->is_rc = is_rc;
+		pcie = &rc->pcie;
+		platform_set_drvdata(pdev, pcie);
 
-		ret = cdns_pcie_init_phy(dev, cdns_plat_pcie->pcie);
+		ret = cdns_pcie_init_phy(dev, pcie);
 		if (ret) {
 			dev_err(dev, "failed to init phy\n");
 			return ret;
@@ -106,10 +90,10 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 
 		ep->pcie.dev = dev;
 		ep->pcie.ops = &cdns_plat_ops;
-		cdns_plat_pcie->pcie = &ep->pcie;
-		cdns_plat_pcie->is_rc = is_rc;
+		pcie = &ep->pcie;
+		platform_set_drvdata(pdev, pcie);
 
-		ret = cdns_pcie_init_phy(dev, cdns_plat_pcie->pcie);
+		ret = cdns_pcie_init_phy(dev, pcie);
 		if (ret) {
 			dev_err(dev, "failed to init phy\n");
 			return ret;
@@ -133,10 +117,10 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
  err_get_sync:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
-	cdns_pcie_disable_phy(cdns_plat_pcie->pcie);
-	phy_count = cdns_plat_pcie->pcie->phy_count;
+	cdns_pcie_disable_phy(pcie);
+	phy_count = pcie->phy_count;
 	while (phy_count--)
-		device_link_del(cdns_plat_pcie->pcie->link[phy_count]);
+		device_link_del(pcie->link[phy_count]);
 
 	return 0;
 }
-- 
2.53.0



