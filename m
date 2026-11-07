Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063400;
	b=vK4OUpsa3FLZSN9xx+XE4telvX9TpCDA+m+cl+bfErd+k/jhVRRlg5MtwFYC0t5MV/re
	 sFyNy8NWaK5Rcf2uOB56ENoVU7o/xV/Dnt9hG1aXvzfGIlmuP2Ti4XTo9xa32N+AMyTCB
	 4UvX9UQQ/Tp6zN75GmrJjbU0H3a01/qhyGW6rkqEfa4Z1vFQ2Vp7TfSXlJfxLu171gqnY
	 BladbEh/VKeAkb2xRieFqgmlET2gXLAAo1j7gdhCwtrkRYIYCFHjJrBqDs2k/vCIOUr05
	 ss0WtyE4YSaRd6UOCR8vLYz5SrbxvpG/NNJfHEqF4qOIQgssaK8h474s9HZYVw0mLbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tdTmhk8Rv9MF6WRvEWTuqGLXbJu9kYfnHYi/zJtPzI4=;
	b=JTjWaAQqoqVUeGwIBGP6OOOn38b6TcrLUii6z7lCvH3gak46ylK/kZmJdIVHQTslJG+G
	 +Rd7+BJE3jG401aw23Sdm1Hi7wghHWVmOd260qIBCLRTCOCmezTfTnp1N/4+fGS8G4GJM
	 /5emj23WFEwTdfdXN37T9gnst2wR+1HtrrWzlAZXuYsFZjJEIMvyWl5eu+IfRSoSIJb5q
	 pmhOUmTnvCDjVE/Z4/AtTe0F+5Ss/HI2KEtcX6PcpOy0vfuJr0+7UxZ7LD/at17ui3Ojf
	 J+M/a5btCY1g20I4d/T0rV149Z9X6meWn8i4bPELsy7Hn7bt979LqP4QYZMF/opq8hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nm+AR65S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F1E6082BEF;
	Sat,  7 Nov 2026 14:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nm+AR65S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2071F008A4;
	Sat,  7 Nov 2026 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063399;
	bh=tdTmhk8Rv9MF6WRvEWTuqGLXbJu9kYfnHYi/zJtPzI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nm+AR65SnRB6Ykt6HMNS0Uu6OoBeFQ3cU8BvOtF7IWIS/tnVgJM7GYUVB45+luC9G
	 UbB6I9qPKM4RqKoaX1NeBqCnS9GuF/xIAfpwmkO//9QQln1gLppmfXY2ZGIxteVctH
	 qTF4f4cRiBDkD1fTdxLSzo2PcobXd54wsF7PTSWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 571/869] PCI: xilinx-xdma: Fix device node reference leak in xilinx_pl_dma_pcie_init_irq_domain()
Date: Sat,  7 Nov 2026 08:54:13 -0500
Message-ID: <20261107134912.599437848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



