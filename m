Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062493;
	b=Gelbqkt57ui/xs4hQGDpAIz3iaMOeEVNPEQ33fdkrA5nLRMzRtq2cYsq755OX6TiX/kW
	 AbDrcxtHEjdciQ2eB2hzGUyUyzxjX/4MpgpDE/QvdXLB+p+u75NYT/Muvgq9SIB+mdf2o
	 K0QLElhujEyS/vjd6Ty1Oj0fEePiffn8RgIyENy58sX52jofPNTllwg4sHon2r7I+9Geq
	 ji35kqa2Lt+6CupkJvWILm75rV1OTWobvCOKfmxJCAmJr6zYw4nF9YzAekQoPsKD5cEoP
	 ee6tun7gywp13oe3Udd1MnMokc3iSUpYkaQgAjtVF5i3SpROtOgFjUukeRHB8/XdtlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WrplOB0Fons03gZSoryOrueOIIEBBFvQKoi3h8c671o=;
	b=K5609JixKUPCekFqKY9UxQnpzpuAgbJ0ctm5Xvc7TZWwtC50BrVIxE5FsUtmzhbV2jgB
	 kwZvQz90LvONQX5ngtmj82X/RKPEIpjZLM0HsIY3oyc/COgFYs1OVN0EkIW2cXCkqmnu9
	 PmbnoNFc8jjnDMl/8rSqwNw9xILef5gWMQ7I4TeUbwQIcAebq8eOdHOaJ+oDvyf0pdl3n
	 EkILtaTjHNX0T1y7oJSCJdO8vXJOI3bdb1GydMGD1qJSA+vu6LdsNfYd4s0Y1WPBiEW3G
	 U+Y6ShSbeymEgQGf/gy45h71K+sK1ikLet1+5oN76DQ4AN8ZKbtcmLXIO+zmlCF+hxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yc1H1il7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90B9606A33E;
	Sat,  7 Nov 2026 14:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yc1H1il7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F211F0089F;
	Sat,  7 Nov 2026 14:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062492;
	bh=WrplOB0Fons03gZSoryOrueOIIEBBFvQKoi3h8c671o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yc1H1il78amnCePZ3Z5KXSm8IJXOGfr6vtTn3baAT2KjEfz7y3CSkiPwjzIPFDT6H
	 bRk9Y9euccfeqzzzpStCrnPrz3VXo6E35iD5VgrPfwZASJQNpQRhh0wpXIRBbQzo2t
	 INVCVzpY/SBi1VjonxekfOJA/fdeghTmc1pQctzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1391/1536] PCI: qcom-ep: Deinitialize endpoint on remove
Date: Sat,  7 Nov 2026 08:56:47 -0500
Message-ID: <20261107135036.898174567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit ed1d71e41c7b2e755e0ef8e9af9cab9b6b185c4b ]

qcom_pcie_ep_probe() initializes the DesignWare PCIe endpoint with
dw_pcie_ep_init(). The probe failure paths call dw_pcie_ep_deinit() to
release the corresponding endpoint resources, but the remove path does
not perform the matching teardown after a successful probe.

As a result, resources initialized by the DesignWare endpoint core can
remain allocated when the endpoint controller is removed.

Notify endpoint functions about EPC deinitialization and call
dw_pcie_ep_deinit() before disabling the controller resources. Keep the
existing early return when the link is already disabled since Qualcomm
endpoint controllers depend on the host refclk for hardware cleanup.

This issue was found by manual code inspection.

Fixes: f55fee56a631 ("PCI: qcom-ep: Add Qualcomm PCIe Endpoint controller driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260916090126.2963064-1-lgs201920130244@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom-ep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom-ep.c b/drivers/pci/controller/dwc/pcie-qcom-ep.c
index b5ca5260f9049..413198e5e1dfd 100644
--- a/drivers/pci/controller/dwc/pcie-qcom-ep.c
+++ b/drivers/pci/controller/dwc/pcie-qcom-ep.c
@@ -919,6 +919,8 @@ static void qcom_pcie_ep_remove(struct platform_device *pdev)
 
 	if (pcie_ep->link_status == QCOM_PCIE_EP_LINK_DISABLED)
 		return;
+	pci_epc_deinit_notify(pcie_ep->pci.ep.epc);
+	dw_pcie_ep_deinit(&pcie_ep->pci.ep);
 
 	qcom_pcie_disable_resources(pcie_ep);
 }
-- 
2.53.0



