Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9B33803CD;
	Tue, 10 Mar 2026 11:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141988; cv=none; b=A+ZNCxx4Tye0gRmb4pKxX5emJqPsTWj3eGEbm2XkReB0KWaTmBR9iwO+ywoTCUaiSk3+9XUkSaM5c0zqISoZKx8UVKu85ubhVEEJMPe6Q+wiQdWfAvnu6NSf3fsN918EihHUTKTapl7I8K7pfyCxqg2gOnR/H9CpE4TXzFGpm6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141988; c=relaxed/simple;
	bh=dryaEcLw/M1QChWqjYgYO9+NHY3343QOqy7LfyE5MRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Asr9KDXp0+IfwndMkGOpwBkpoK54coFLKfvHAlMc+1/Dbc0mktLVIhv8aq76Nwn/2cpUeN2axmn4/IzKU9wcBCnmGwY4tsILkvdHQEgrpea96KyMMry77xlgvCea03/dJlwP2Eo2GvH8Tub1IExiittdXIRLxgPcd/E9tktWU7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5X67jL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5X67jL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA78DC2BC9E;
	Tue, 10 Mar 2026 11:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141988;
	bh=dryaEcLw/M1QChWqjYgYO9+NHY3343QOqy7LfyE5MRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5X67jL1Zmq2ik+zfWnzU+XbSU8zOkswOJP9sq17AqAf2cFsqnrp/v2qLImSfqW5T
	 5OGum6cGH31+bktcudnwEhUu6/2uepcx56RzJSr/kOdYIcLHf5D/6JYe9P2lf/Tnr6
	 g1I7nzr3yYWDC7IUGIjMZ+TN2+wV9q9BjYo+LQrJK6cqgSlBJVTXad7l5xPiqzOshO
	 MKTupbLfIZS3qYC/zG8WrTPKqsri1eiTSoUT6LVt/+3ZZcmPktv8asDfFUEEQQNriS
	 p/0mAGSHZOBYVyopb48OYT4NzWaJso9F+mN0tfrtkTiAki+MLbFS3CZr1bPcZGfB+/
	 4bKwNycP0wLDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Wenbin Yao <wenbin.yao@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/314] PCI: dwc: Add new APIs to remove standard and extended Capability
Date: Tue, 10 Mar 2026 07:16:12 -0400
Message-ID: <3ba687a17042ed064d841b7dbc2ce80173678ee9.1773141555.git.sashal@kernel.org>
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

[ Upstream commit 0183562f1e824c0ca6c918309a0978e9a269af3e ]

On some platforms, certain PCIe Capabilities may be present in hardware
but are not fully implemented as defined in PCIe spec. These incomplete
capabilities should be hidden from the PCI framework to prevent unexpected
behavior.

Introduce two APIs to remove a specific PCIe Capability and Extended
Capability by updating the previous capability's next offset field to skip
over the unwanted capability. These APIs allow RC drivers to easily hide
unsupported or partially implemented capabilities from software.

Co-developed-by: Wenbin Yao <wenbin.yao@oss.qualcomm.com>
Signed-off-by: Wenbin Yao <wenbin.yao@oss.qualcomm.com>
Signed-off-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251109-remove_cap-v1-2-2208f46f4dc2@oss.qualcomm.com
Stable-dep-of: 43d67ec26b32 ("PCI: dwc: ep: Fix resizable BAR support for multi-PF configurations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 53 ++++++++++++++++++++
 drivers/pci/controller/dwc/pcie-designware.h |  2 +
 2 files changed, 55 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 5d7a7e6f5724e..345365ea97c74 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -236,6 +236,59 @@ u16 dw_pcie_find_ext_capability(struct dw_pcie *pci, u8 cap)
 }
 EXPORT_SYMBOL_GPL(dw_pcie_find_ext_capability);
 
+void dw_pcie_remove_capability(struct dw_pcie *pci, u8 cap)
+{
+	u8 cap_pos, pre_pos, next_pos;
+	u16 reg;
+
+	cap_pos = PCI_FIND_NEXT_CAP(dw_pcie_read_cfg, PCI_CAPABILITY_LIST, cap,
+				 &pre_pos, pci);
+	if (!cap_pos)
+		return;
+
+	reg = dw_pcie_readw_dbi(pci, cap_pos);
+	next_pos = (reg & 0xff00) >> 8;
+
+	dw_pcie_dbi_ro_wr_en(pci);
+	if (pre_pos == PCI_CAPABILITY_LIST)
+		dw_pcie_writeb_dbi(pci, PCI_CAPABILITY_LIST, next_pos);
+	else
+		dw_pcie_writeb_dbi(pci, pre_pos + 1, next_pos);
+	dw_pcie_dbi_ro_wr_dis(pci);
+}
+EXPORT_SYMBOL_GPL(dw_pcie_remove_capability);
+
+void dw_pcie_remove_ext_capability(struct dw_pcie *pci, u8 cap)
+{
+	int cap_pos, next_pos, pre_pos;
+	u32 pre_header, header;
+
+	cap_pos = PCI_FIND_NEXT_EXT_CAP(dw_pcie_read_cfg, 0, cap, &pre_pos, pci);
+	if (!cap_pos)
+		return;
+
+	header = dw_pcie_readl_dbi(pci, cap_pos);
+	/*
+	 * If the first cap at offset PCI_CFG_SPACE_SIZE is removed,
+	 * only set it's capid to zero as it cannot be skipped.
+	 */
+	if (cap_pos == PCI_CFG_SPACE_SIZE) {
+		dw_pcie_dbi_ro_wr_en(pci);
+		dw_pcie_writel_dbi(pci, cap_pos, header & 0xffff0000);
+		dw_pcie_dbi_ro_wr_dis(pci);
+		return;
+	}
+
+	pre_header = dw_pcie_readl_dbi(pci, pre_pos);
+	next_pos = PCI_EXT_CAP_NEXT(header);
+
+	dw_pcie_dbi_ro_wr_en(pci);
+	dw_pcie_writel_dbi(pci, pre_pos,
+			  (pre_header & 0xfffff) | (next_pos << 20));
+	dw_pcie_dbi_ro_wr_dis(pci);
+}
+EXPORT_SYMBOL_GPL(dw_pcie_remove_ext_capability);
+
 static u16 __dw_pcie_find_vsec_capability(struct dw_pcie *pci, u16 vendor_id,
 					  u16 vsec_id)
 {
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 6c04ac0196794..a59ea4078cca8 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -557,6 +557,8 @@ void dw_pcie_version_detect(struct dw_pcie *pci);
 
 u8 dw_pcie_find_capability(struct dw_pcie *pci, u8 cap);
 u16 dw_pcie_find_ext_capability(struct dw_pcie *pci, u8 cap);
+void dw_pcie_remove_capability(struct dw_pcie *pci, u8 cap);
+void dw_pcie_remove_ext_capability(struct dw_pcie *pci, u8 cap);
 u16 dw_pcie_find_rasdes_capability(struct dw_pcie *pci);
 u16 dw_pcie_find_ptm_capability(struct dw_pcie *pci);
 
-- 
2.51.0

