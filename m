Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B633FFAB5;
	Thu, 12 Mar 2026 20:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346367; cv=none; b=Xdzk2UFw8KkcJWtOIW6CkkanVE8e3uCaluf7lIJ3yDCZt90GsXSAGjYXlcckS9TmoR2cR7dClozoZuEqmQuQ/8D1PIieBCvfdLKEEfaYy7807LUu5f/UxSaL8ublibHK2xRuUAyWeABa/gVjkxmfK5r6VY4tk9vu/HnIkXL8+54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346367; c=relaxed/simple;
	bh=5Bqn21nodpagypYTc0l68hDpPrp+wCAItIsvgPZWy9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y02ABqE1skX0WXx9n/OcHSw/vg5+OgTmRUR+IVq+c+1l5zHhLeQDw6c8V1p+lQIx4UXEkZ1lS5uy750onYJiWLrt1LHYHwnVyT8+5BbEl51I60to0kw/HJkRChACTx0azoE9iNnHT21ZLihgo9myHPPYl0EN9hgno5OLSgWLu3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVPNfJoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVPNfJoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150FBC4CEF7;
	Thu, 12 Mar 2026 20:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346367;
	bh=5Bqn21nodpagypYTc0l68hDpPrp+wCAItIsvgPZWy9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVPNfJoXA1YTBXlBv2s1q3hajfn1R0jb1SU+KMNwil5Eb5X2f1rRjPHVHYl31K9Z5
	 VtVSzvq6LL4p408NSUu0x+0cpIbilEdYdKIm5EF5Xrt5wYg5W49C5rY68z8JXLX6Be
	 qgQ8ww2/DV9Yzk0e42ZEtHVS9hxrc5aNldS4TYhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/265] PCI: dwc: ep: Use align addr function for dw_pcie_ep_raise_{msi,msix}_irq()
Date: Thu, 12 Mar 2026 21:06:53 +0100
Message-ID: <20260312201019.129750604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 3fafc38b77bebeeea5faa2a588b92353775bb390 ]

Use the dw_pcie_ep_align_addr() function to calculate the alignment in
dw_pcie_ep_raise_{msi,msix}_irq() instead of open coding the same.

Link: https://lore.kernel.org/r/20241017132052.4014605-6-cassel@kernel.org
Link: https://lore.kernel.org/r/20241104205144.409236-2-cassel@kernel.org
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
[kwilczynski: squashed patch that fixes memory map sizes]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: c22533c66cca ("PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-ep.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index b093c4153f14f..b8c9cb5d65f70 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -526,7 +526,8 @@ int dw_pcie_ep_raise_msi_irq(struct dw_pcie_ep *ep, u8 func_no,
 	u32 msg_addr_lower, msg_addr_upper, reg;
 	struct dw_pcie_ep_func *ep_func;
 	struct pci_epc *epc = ep->epc;
-	unsigned int aligned_offset;
+	size_t map_size = sizeof(u32);
+	size_t offset;
 	u16 msg_ctrl, msg_data;
 	bool has_upper;
 	u64 msg_addr;
@@ -554,14 +555,13 @@ int dw_pcie_ep_raise_msi_irq(struct dw_pcie_ep *ep, u8 func_no,
 	}
 	msg_addr = ((u64)msg_addr_upper) << 32 | msg_addr_lower;
 
-	aligned_offset = msg_addr & (epc->mem->window.page_size - 1);
-	msg_addr = ALIGN_DOWN(msg_addr, epc->mem->window.page_size);
+	msg_addr = dw_pcie_ep_align_addr(epc, msg_addr, &map_size, &offset);
 	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
-				  epc->mem->window.page_size);
+				  map_size);
 	if (ret)
 		return ret;
 
-	writel(msg_data | (interrupt_num - 1), ep->msi_mem + aligned_offset);
+	writel(msg_data | (interrupt_num - 1), ep->msi_mem + offset);
 
 	dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
 
@@ -612,8 +612,9 @@ int dw_pcie_ep_raise_msix_irq(struct dw_pcie_ep *ep, u8 func_no,
 	struct pci_epf_msix_tbl *msix_tbl;
 	struct dw_pcie_ep_func *ep_func;
 	struct pci_epc *epc = ep->epc;
+	size_t map_size = sizeof(u32);
+	size_t offset;
 	u32 reg, msg_data, vec_ctrl;
-	unsigned int aligned_offset;
 	u32 tbl_offset;
 	u64 msg_addr;
 	int ret;
@@ -638,14 +639,13 @@ int dw_pcie_ep_raise_msix_irq(struct dw_pcie_ep *ep, u8 func_no,
 		return -EPERM;
 	}
 
-	aligned_offset = msg_addr & (epc->mem->window.page_size - 1);
-	msg_addr = ALIGN_DOWN(msg_addr, epc->mem->window.page_size);
+	msg_addr = dw_pcie_ep_align_addr(epc, msg_addr, &map_size, &offset);
 	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
-				  epc->mem->window.page_size);
+				  map_size);
 	if (ret)
 		return ret;
 
-	writel(msg_data, ep->msi_mem + aligned_offset);
+	writel(msg_data, ep->msi_mem + offset);
 
 	dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
 
-- 
2.51.0



