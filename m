Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BA818B0A;
	Wed, 25 Feb 2026 01:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983281; cv=none; b=CO92x70C+H02lh0rEcNV6p0hNCUt9yIF5dZJmUJUvu+erDLxS4rN7ur9KzhSLNU4RluR1SGDo1xXCZ4d3BcnUvk4sHu9ZNkcopWCooahe57h7b+OgF0No/EFkSQds93sreDzLBFbYXxB+GaYFODzPAbddGTo2BseU9NlBtb8PkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983281; c=relaxed/simple;
	bh=gksoAF4BqSgSquOyYRFTU2dCG5qOPV4uSD6YhBCBi1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8L8JBpRAgvBUoONFQKfta6WMzSVh/IT9Ue7svjpdsV5TuY446Cipr9bcC2k/nWMNdYgkymSfOD8V9XKlrlHBi/jku30ToaSHF4msM3ZiujFbSmwCt4Gw9eaf7KNoSf4XrnRKWrOgt+Re/7lCUSotoir0+y8AjjoyrDxiIUGypY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVyh78CD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVyh78CD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9ACC116D0;
	Wed, 25 Feb 2026 01:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983281;
	bh=gksoAF4BqSgSquOyYRFTU2dCG5qOPV4uSD6YhBCBi1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVyh78CDLL1D+EoC7cJsHAZp6eLPdxhlOhprG7raUsUTLLLMR/rtFFRAQ/t3xTDB/
	 ZaUq5EnBCRP/dFds15AtjDwOK7ctE+Vc9u9smumoSmtj26WMa48nCWwbhgK4xAlwU+
	 IieO1xPgOTdPt3BMMJi2Gm9xFLYg0OQMGHV/krZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 393/781] PCI: dwc: Remove duplicate dw_pcie_ep_hide_ext_capability() function
Date: Tue, 24 Feb 2026 17:18:22 -0800
Message-ID: <20260225012409.342282402@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <qiang.yu@oss.qualcomm.com>

[ Upstream commit 86291f774fe8524178446cb2c792939640b4970c ]

Remove dw_pcie_ep_hide_ext_capability() and replace its usage with
dw_pcie_remove_ext_capability(). Both functions serve the same purpose
of hiding PCIe extended capabilities, but dw_pcie_remove_ext_capability()
provides a cleaner API that doesn't require the caller to specify the
previous capability ID.

Suggested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20251224-remove_dw_pcie_ep_hide_ext_capability-v1-1-4302c9cdc316@oss.qualcomm.com
Stable-dep-of: 72cb5ed2a5c6 ("PCI: dwc: ep: Add per-PF BAR and inbound ATU mapping support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-ep.c   | 39 -------------------
 drivers/pci/controller/dwc/pcie-designware.h  |  7 ----
 drivers/pci/controller/dwc/pcie-dw-rockchip.c |  4 +-
 3 files changed, 1 insertion(+), 49 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 1195d401df19e..cfd59899c7b85 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -75,45 +75,6 @@ static u8 dw_pcie_ep_find_capability(struct dw_pcie_ep *ep, u8 func_no, u8 cap)
 				 cap, NULL, ep, func_no);
 }
 
-/**
- * dw_pcie_ep_hide_ext_capability - Hide a capability from the linked list
- * @pci: DWC PCI device
- * @prev_cap: Capability preceding the capability that should be hidden
- * @cap: Capability that should be hidden
- *
- * Return: 0 if success, errno otherwise.
- */
-int dw_pcie_ep_hide_ext_capability(struct dw_pcie *pci, u8 prev_cap, u8 cap)
-{
-	u16 prev_cap_offset, cap_offset;
-	u32 prev_cap_header, cap_header;
-
-	prev_cap_offset = dw_pcie_find_ext_capability(pci, prev_cap);
-	if (!prev_cap_offset)
-		return -EINVAL;
-
-	prev_cap_header = dw_pcie_readl_dbi(pci, prev_cap_offset);
-	cap_offset = PCI_EXT_CAP_NEXT(prev_cap_header);
-	cap_header = dw_pcie_readl_dbi(pci, cap_offset);
-
-	/* cap must immediately follow prev_cap. */
-	if (PCI_EXT_CAP_ID(cap_header) != cap)
-		return -EINVAL;
-
-	/* Clear next ptr. */
-	prev_cap_header &= ~GENMASK(31, 20);
-
-	/* Set next ptr to next ptr of cap. */
-	prev_cap_header |= cap_header & GENMASK(31, 20);
-
-	dw_pcie_dbi_ro_wr_en(pci);
-	dw_pcie_writel_dbi(pci, prev_cap_offset, prev_cap_header);
-	dw_pcie_dbi_ro_wr_dis(pci);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(dw_pcie_ep_hide_ext_capability);
-
 static int dw_pcie_ep_write_header(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 				   struct pci_epf_header *hdr)
 {
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index f9e2eaa3571e0..8a99a9c393f53 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -906,7 +906,6 @@ int dw_pcie_ep_raise_msix_irq(struct dw_pcie_ep *ep, u8 func_no,
 int dw_pcie_ep_raise_msix_irq_doorbell(struct dw_pcie_ep *ep, u8 func_no,
 				       u16 interrupt_num);
 void dw_pcie_ep_reset_bar(struct dw_pcie *pci, enum pci_barno bar);
-int dw_pcie_ep_hide_ext_capability(struct dw_pcie *pci, u8 prev_cap, u8 cap);
 struct dw_pcie_ep_func *
 dw_pcie_ep_get_func_from_ep(struct dw_pcie_ep *ep, u8 func_no);
 #else
@@ -964,12 +963,6 @@ static inline void dw_pcie_ep_reset_bar(struct dw_pcie *pci, enum pci_barno bar)
 {
 }
 
-static inline int dw_pcie_ep_hide_ext_capability(struct dw_pcie *pci,
-						 u8 prev_cap, u8 cap)
-{
-	return 0;
-}
-
 static inline struct dw_pcie_ep_func *
 dw_pcie_ep_get_func_from_ep(struct dw_pcie_ep *ep, u8 func_no)
 {
diff --git a/drivers/pci/controller/dwc/pcie-dw-rockchip.c b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
index f8605fe61a415..2f865f67a10a7 100644
--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -327,9 +327,7 @@ static void rockchip_pcie_ep_hide_broken_ats_cap_rk3588(struct dw_pcie_ep *ep)
 	if (!of_device_is_compatible(dev->of_node, "rockchip,rk3588-pcie-ep"))
 		return;
 
-	if (dw_pcie_ep_hide_ext_capability(pci, PCI_EXT_CAP_ID_SECPCI,
-					   PCI_EXT_CAP_ID_ATS))
-		dev_err(dev, "failed to hide ATS capability\n");
+	dw_pcie_remove_ext_capability(pci, PCI_EXT_CAP_ID_ATS);
 }
 
 static void rockchip_pcie_ep_init(struct dw_pcie_ep *ep)
-- 
2.51.0



