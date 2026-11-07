Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064861;
	b=yKdYLTSVGP53SYrGrohkt9r/2FGrJ3EcaJvHdFL8y/AoMkmqO9ZYRuZ4neEo9VcRscm2
	 GL7HzhOV2uyi71Lg6JWLveM0tC845gFsYiLH9zHaQxv6qXp1sXuDIXIZEOBcQYtEgpNNw
	 j5KzzgmwyTy/bPgGRQ+TmHVypP43YQDTBtTEwXpSsynrOVCy3Zj8riFynZ2tQe+v6pBe/
	 hyrr+TuCstDJSwzkKvzZQ5NWBgpsq3LABiiJdzGSHLJeyrTbMQOlo9f5iHXorRPMbR3a2
	 ELrAIVDvAlfgLwXlrzjp8qHu/fyjGlCjGJd/8TpNigl4KBITR7cJwBsVDSeUool9YTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rRGUmyrB5liQAOQh0nbhLnOmT5GJJwstwtO5wPyqNfA=;
	b=IYBd50texo7YgVUAXi0MUOeln9dwylKRhA5eVQOxFNRQ5L2VNVI5l4TPxwwfyCVzj6WN
	 xtmCqmWNgZR5DVK4Ic/GUn//oN/zRNzoEP/Mdfg3vpHnc9CTz/Yl02pA1xmpKdZ7kpu/Y
	 tRz4Qu59MwOubLszJFO1cY+o3Pksb5ZHuFeeDPANdpeaiB1GJNrvXoHIQMKXPsaJlSrl9
	 CqVtzrOgyk20lnmBBmlfRcqvSfYbKIbbwCEbKy+Reld1xmQ/14wImvNX2pHnjUF5/4UdW
	 YU81RO8AIQL0Whoal748hxy3hAggFzS/T1QcQuOvm6L7prKVUdjMuZCwt7tG+QTCLaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EYC6gRM+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC5606A333;
	Sat,  7 Nov 2026 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EYC6gRM+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAAB1F0089F;
	Sat,  7 Nov 2026 15:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064861;
	bh=rRGUmyrB5liQAOQh0nbhLnOmT5GJJwstwtO5wPyqNfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYC6gRM+cFOISaGVkVlRNG3lZMgQGUMfJ5ZE2vab+KqaczYgl87LkxtgjaN3vH75C
	 UfdT0OY3KGPQliAx8R1zkZtq74yd5EnU1x3kIKG03hmrX8os4K15DsoyKfhw8PQeIB
	 1ZB3J61+gsI2zkEhyD35xYN5Ifz7v3D1PQKeO6F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0780/1257] PCI: xilinx-xdma: Fix device node reference leak in xilinx_pl_dma_pcie_init_irq_domain()
Date: Sat,  7 Nov 2026 08:51:16 -0500
Message-ID: <20261107135000.850874933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index b037c8f315e46..e18eeecdc8a9a 100644
--- a/drivers/pci/controller/pcie-xilinx-dma-pl.c
+++ b/drivers/pci/controller/pcie-xilinx-dma-pl.c
@@ -581,7 +581,7 @@ static int xilinx_pl_dma_pcie_init_irq_domain(struct pl_dma_pcie *port)
 	port->pldma_domain = irq_domain_create_linear(of_fwnode_handle(pcie_intc_node), 32,
 						      &event_domain_ops, port);
 	if (!port->pldma_domain)
-		return -ENOMEM;
+		goto err_put_node;
 
 	irq_domain_update_bus_token(port->pldma_domain, DOMAIN_BUS_NEXUS);
 
@@ -589,7 +589,7 @@ static int xilinx_pl_dma_pcie_init_irq_domain(struct pl_dma_pcie *port)
 						     &intx_domain_ops, port);
 	if (!port->intx_domain) {
 		dev_err(dev, "Failed to get a INTx IRQ domain\n");
-		return -ENOMEM;
+		goto err_put_node;
 	}
 
 	irq_domain_update_bus_token(port->intx_domain, DOMAIN_BUS_WIRED);
@@ -597,13 +597,17 @@ static int xilinx_pl_dma_pcie_init_irq_domain(struct pl_dma_pcie *port)
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



