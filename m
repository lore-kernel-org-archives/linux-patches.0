Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A020118658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2678EC433C8;
	Wed, 20 Sep 2023 11:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210578;
	bh=Z35EEmi/+HMboqqxlSAKhVlLitRsTj5aiyUUM0CsTk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8hWseIHyQI/b1rUipWD/Y6pp66RG0ZWu9u0pQLBqGimXVbyn8pg5vWjYOijRzuOX
	 gcQ3Bd9h6tFBHoU+y7qD+Etpne4xXB6tHSsp2pGn2XYB8Y2F1rh2l3bFIrMqvpfkCd
	 YvO/+UMHgGorZ+oNB8R6gdlbua3+hHuPHJd/bRJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 103/211] PCI: fu740: Set the number of MSI vectors
Date: Wed, 20 Sep 2023 13:29:07 +0200
Message-ID: <20230920112848.993250896@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

[ Upstream commit 551a60e1225e71fff8efd9390204c505b0870e0f ]

The iMSI-RX module of the DW PCIe controller provides multiple sets of
MSI_CTRL_INT_i_* registers, and each set is capable of handling 32 MSI
interrupts. However, the fu740 PCIe controller driver only enabled one set
of MSI_CTRL_INT_i_* registers, as the total number of supported interrupts
was not specified.

Set the supported number of MSI vectors to enable all the MSI_CTRL_INT_i_*
registers on the fu740 PCIe core, allowing the system to fully utilize the
available MSI interrupts.

Link: https://lore.kernel.org/r/20230807055621.2431-1-yongxuan.wang@sifive.com
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-fu740.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-fu740.c b/drivers/pci/controller/dwc/pcie-fu740.c
index 0c90583c078bf..1e9b44b8bba48 100644
--- a/drivers/pci/controller/dwc/pcie-fu740.c
+++ b/drivers/pci/controller/dwc/pcie-fu740.c
@@ -299,6 +299,7 @@ static int fu740_pcie_probe(struct platform_device *pdev)
 	pci->dev = dev;
 	pci->ops = &dw_pcie_ops;
 	pci->pp.ops = &fu740_pcie_host_ops;
+	pci->pp.num_vectors = MAX_MSI_IRQS;
 
 	/* SiFive specific region: mgmt */
 	afp->mgmt_base = devm_platform_ioremap_resource_byname(pdev, "mgmt");
-- 
2.40.1



