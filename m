Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062381;
	b=Ocv5cdm3ERcli+fW0++Ft+qQ68afEgvcoLgv2XT/M8vqmXUAESBjAQ5pvX4A2CeHCXAU
	 vvVHT2mSYYBlGMYYV93g6qvdyiVBeA7hsj1pNVfsWNG1fsUMwky5dE5MUK3n1hwRqdHn4
	 Qw8KwvV5ApHW+vEqAoYWc3tkXbyWTHc86OKEEfCoUpGAZubmm0Re9Yk+10BEMO1j9iMEb
	 uAjTytljVbX2Ao5Ej4Mx3wXWOkJnMSsrKoF6DJ/0pExiae9K9VQ9jxAPwrOaIdfd/L56P
	 qQGmMF2Bc4MA8+jTLlFuip1+UO8e5fue5F7TLpYKhCx5+jL67fYM2vJkMq0NeAPZg9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ffvr04j943fuAIEz9j4kMzFsGKxn3gS27RNb2QKdgaI=;
	b=u/9pIWZJuNsaWRnaM1+q2GUnO3hnU7dAXat0SfGWQ+c0GSsOdFaWQAGAPvCqp4+y+TVr
	 FmMsMQ0fsoyBxt4eKSlXXpBz1znASevcOVA/Ae/reXtFp28XMIxvKHrrzq92ExBZ7k47m
	 kUA5C7Rw0YdlojFyjHHkiu5yJ5LTv7lInI9ZE0qu2GLNWPnYd6qBxHiXVYODUZq3sld8C
	 SnhlP3v0OfBeeyJxq+zS3W/rGOzTBIa8DGGylyiY8uKIToXAnHWixrRoiu1vK1y65BnVQ
	 GEgnRIntQLBRvaSls85U3VUIN2SX0uOBpTEyVltSNrgMGj6D1zKJSTqEpyRkhGKDi0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0dqXfmF2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C1E6083603;
	Sat,  7 Nov 2026 14:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0dqXfmF2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B75C1F0089F;
	Sat,  7 Nov 2026 14:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062381;
	bh=ffvr04j943fuAIEz9j4kMzFsGKxn3gS27RNb2QKdgaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dqXfmF2NQD/vGpiyoCsT+iJ54mByCLI/0+dqPb2dQ4b7FfKjSl3dFxTM965iwtNl
	 cY1C9OLmLT7FaB/lCunhAdZN5N8EF6i54zeYnkotBH2j80DgYbeHHJK9VtZHyySI41
	 amoqCX3tCIyMWE8eL0s4ejhrWyvdRnvvSQC0DWDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1303/1536] PCI: xilinx-xdma: Fix device node reference leak in xilinx_pl_dma_pcie_init_irq_domain()
Date: Sat,  7 Nov 2026 08:55:19 -0500
Message-ID: <20261107135034.388732376@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 73d3d81832708137ba6332fc011663feaf97deee ]

xilinx_pl_dma_pcie_init_irq_domain() takes a reference to the PCIe
interrupt-controller child node with of_get_child_by_name(), but the
error paths after the two irq_domain_create_linear() calls and after
xilinx_pl_dma_pcie_init_msi_irq_domain() return directly without
dropping it.  irq_domain_create_linear() gets its own reference on the
fwnode, so the domains do not consume the caller's one.

Add an err_put_node label that drops the reference before returning.

Fixes: 8d786149d78c ("PCI: xilinx-xdma: Add Xilinx XDMA Root Port driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260917132459.2153240-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx-dma-pl.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pcie-xilinx-dma-pl.c b/drivers/pci/controller/pcie-xilinx-dma-pl.c
index 116c6e0e71457..d71b6dba75cc8 100644
--- a/drivers/pci/controller/pcie-xilinx-dma-pl.c
+++ b/drivers/pci/controller/pcie-xilinx-dma-pl.c
@@ -588,7 +588,7 @@ static int xilinx_pl_dma_pcie_init_irq_domain(struct pl_dma_pcie *port)
 	port->pldma_domain = irq_domain_add_linear(pcie_intc_node, 32,
 						   &event_domain_ops, port);
 	if (!port->pldma_domain)
-		return -ENOMEM;
+		goto err_put_node;
 
 	irq_domain_update_bus_token(port->pldma_domain, DOMAIN_BUS_NEXUS);
 
@@ -596,7 +596,7 @@ static int xilinx_pl_dma_pcie_init_irq_domain(struct pl_dma_pcie *port)
 						  &intx_domain_ops, port);
 	if (!port->intx_domain) {
 		dev_err(dev, "Failed to get a INTx IRQ domain\n");
-		return -ENOMEM;
+		goto err_put_node;
 	}
 
 	irq_domain_update_bus_token(port->intx_domain, DOMAIN_BUS_WIRED);
@@ -604,13 +604,17 @@ static int xilinx_pl_dma_pcie_init_irq_domain(struct pl_dma_pcie *port)
 	ret = xilinx_pl_dma_pcie_init_msi_irq_domain(port);
 	if (ret != 0) {
 		irq_domain_remove(port->intx_domain);
-		return -ENOMEM;
+		goto err_put_node;
 	}
 
 	of_node_put(pcie_intc_node);
 	raw_spin_lock_init(&port->lock);
 
 	return 0;
+
+err_put_node:
+	of_node_put(pcie_intc_node);
+	return -ENOMEM;
 }
 
 static int xilinx_pl_dma_pcie_setup_irq(struct pl_dma_pcie *port)
-- 
2.53.0



