Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7949037B413;
	Tue, 10 Mar 2026 11:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141989; cv=none; b=m9vDztEk5FrEQJVBYJAac8193np/9ICRwOneSU4ssl3xJPwzU1hrOEabFmjVpOQklLIWfbdfi9XWqnwxM7xaputYiHdy5zmAdJk358kklqAj58KeRBB/6i3B71lzwfXhH8TJll6Aq8r8klpbfRAuTDvAswP1dasjhsMoQvi0nCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141989; c=relaxed/simple;
	bh=D5tQm5XX3hr1lKfx3k49LBR2HgsnEWEKbhcQ9iReS/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anGCuOZYNhr88L/aMfO56Km+JgVcqk/IYs3OznDGpePrRrk2BOP5WEu4qfiOnHzgmVoVBDd9/7vlAq48D8grRRgp/b33L7nYRNg7adW+bkEBGiptjbjwsK+W2Lr5Zju/e5222yu7zm/t30WCHRVMxOEqk6rq7EbbA+bjb1bebJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TYcf5vF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TYcf5vF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B9DC19423;
	Tue, 10 Mar 2026 11:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141989;
	bh=D5tQm5XX3hr1lKfx3k49LBR2HgsnEWEKbhcQ9iReS/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYcf5vF0G3IhxClR7mNneSzadwMtzPHXBmyISkiQo3NlusYItRoBxmo7fFVJ5cG69
	 txvdMbmeA5O4cBPtfhFHuntefqul+BLiPd+tXo30jzp3RiqmZlaoBwJ9Y9zEOlUbZ/
	 04MYb3WiSWZgsbtaAHImECPe2SgZLfv5JXN0WW8GAYfm5IJSOEiREssUmi1Vn1aAT9
	 6fBIF5EJ8NTFwZ8UEMNsCeg6bc8w+8+h66TTrsdtFexstjW1Z2v+GlqHQtGH/egDbq
	 rStL55oYOGUtuN3p/wjLxyPcc6J4ELTTqUR2F8opikucuDimQhSFslVJHicSvGAFnH
	 ABbbacpjUpgFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 114/314] PCI: dwc: Remove duplicate dw_pcie_ep_hide_ext_capability() function
Date: Tue, 10 Mar 2026 07:16:13 -0400
Message-ID: <e641e31cb3c37d7212140b893ac932624bccf8b9.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
Stable-dep-of: 43d67ec26b32 ("PCI: dwc: ep: Fix resizable BAR support for multi-PF configurations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-ep.c   | 39 -------------------
 drivers/pci/controller/dwc/pcie-designware.h  |  7 ----
 drivers/pci/controller/dwc/pcie-dw-rockchip.c |  4 +-
 3 files changed, 1 insertion(+), 49 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 7f10d764f52b0..b6cee9eaa1165 100644
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
index a59ea4078cca8..d32ee1fa3cf85 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -888,7 +888,6 @@ int dw_pcie_ep_raise_msix_irq(struct dw_pcie_ep *ep, u8 func_no,
 int dw_pcie_ep_raise_msix_irq_doorbell(struct dw_pcie_ep *ep, u8 func_no,
 				       u16 interrupt_num);
 void dw_pcie_ep_reset_bar(struct dw_pcie *pci, enum pci_barno bar);
-int dw_pcie_ep_hide_ext_capability(struct dw_pcie *pci, u8 prev_cap, u8 cap);
 struct dw_pcie_ep_func *
 dw_pcie_ep_get_func_from_ep(struct dw_pcie_ep *ep, u8 func_no);
 #else
@@ -946,12 +945,6 @@ static inline void dw_pcie_ep_reset_bar(struct dw_pcie *pci, enum pci_barno bar)
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
index b5442ee2920e5..c2c36290be061 100644
--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -356,9 +356,7 @@ static void rockchip_pcie_ep_hide_broken_ats_cap_rk3588(struct dw_pcie_ep *ep)
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

