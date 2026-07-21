Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F7D40926D;
	Tue, 21 Jul 2026 18:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660141; cv=none; b=Cu2hXXJMfJA/vX81kScJ37vaJwuJPJmx/TMTbR9Gv1XK7wmbC6CIXnXR237wpvCLVIrycNNf0fQYvVZtw4ocAVIfFTe6ZjFaYS6io2CmD99GxX4gWLEu1QynUshwV49GT75+PT8StwKfl1+rKiygH8Egs4PBOgm5uWVqhBgH3pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660141; c=relaxed/simple;
	bh=8TA+qRVjmG+EnZuylyt36OFm4AAhYBBQKg7y05ISLcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tu2wAzc2Cr+jEBlD4IU9sJYpaN0rhanyxLVJ9m50mqX9llFig8q8Oy8VDDW26Qr0eqfanD8QLYI6X4zFhvHUAsHC0dE9BYmKU9A9oBqq6QYDjjQ/+y69Ro9emUlo6WjqiIO8CgqVl1Kc9ZUnBWAUSLasMKVC2g3BPk5aoxXXp1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2ehKbN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2ehKbN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2371F000E9;
	Tue, 21 Jul 2026 18:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660140;
	bh=mQFQoJkX+9d4tSYXcSbAvZ84KhTRRklTMPRvLGBYY24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2ehKbN5QUuJhSe+1YPmh2XYl3nyoWyph1YMuuDmyghzAm7FkFm1+hpD9iib5Xc1l
	 gSlbFzWTe3hzneSU5wrq0EKI4Yr6ABy80J8+TPXPDXeMkK5EjyoL209HxwlG0M7ew5
	 UmtNU3H5NesXKTLmitBD78dhur8M+W2BwDczqr7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0865/2077] PCI: dwc: Apply ECRC workaround for DesignWare cores prior to 5.10a
Date: Tue, 21 Jul 2026 17:08:58 +0200
Message-ID: <20260721152613.193102375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Maddireddy <mmaddireddy@nvidia.com>

[ Upstream commit 1e1b554c2b910591aa3fffdb8077a2ca33bf3cb2 ]

The ECRC (TLP digest) workaround was originally applied only for DesignWare
core version 4.90a. Per discussion in Synopsys case, the dependency of the
iATU TD bit on ECRC generation was removed in 5.10a, so apply the
workaround for all DWC versions below that release.

Replace the misleading comment that referred to raw version constants
with readable DesignWare release name to help readability.

Fixes: b210b1595606 ("PCI: dwc: Apply ECRC workaround to DesignWare 5.00a as well")
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
[mani: corrected fixes tag format]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260410062507.657453-1-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 16 ++++++++--------
 drivers/pci/controller/dwc/pcie-designware.h |  1 +
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index c11cf61b8319e6..76c9a0a10367b3 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -487,13 +487,13 @@ static inline void dw_pcie_writel_atu_ob(struct dw_pcie *pci, u32 index, u32 reg
 static inline u32 dw_pcie_enable_ecrc(u32 val)
 {
 	/*
-	 * DWC versions 0x3530302a and 0x3536322a have a design issue where
-	 * the 'TD' bit in the Control register-1 of the ATU outbound
-	 * region acts like an override for the ECRC setting, i.e., the
-	 * presence of TLP Digest (ECRC) in the outgoing TLPs is solely
-	 * determined by this bit. This is contrary to the PCIe spec which
-	 * says that the enablement of the ECRC is solely determined by the
-	 * AER registers.
+	 * DesignWare core versions prior to 5.10A have a design issue where the
+	 * 'TD' bit in the Control register-1 of the ATU outbound region acts
+	 * like an override for the ECRC setting, i.e., the presence of TLP
+	 * Digest (ECRC) in the outgoing TLPs is solely determined by this
+	 * bit. This is contrary to the PCIe spec which says that the
+	 * enablement of the ECRC is solely determined by the AER
+	 * registers.
 	 *
 	 * Because of this, even when the ECRC is enabled through AER
 	 * registers, the transactions going through ATU won't have TLP
@@ -563,7 +563,7 @@ int dw_pcie_prog_outbound_atu(struct dw_pcie *pci,
 	if (upper_32_bits(limit_addr) > upper_32_bits(parent_bus_addr) &&
 	    dw_pcie_ver_is_ge(pci, 460A))
 		val |= PCIE_ATU_INCREASE_REGION_SIZE;
-	if (dw_pcie_ver_is(pci, 490A) || dw_pcie_ver_is(pci, 500A))
+	if (!dw_pcie_ver_is_ge(pci, 510A))
 		val = dw_pcie_enable_ecrc(val);
 	dw_pcie_writel_atu_ob(pci, atu->index, PCIE_ATU_REGION_CTRL1, val);
 
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 3e69ef60165b0e..a07b7abda41f3f 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -35,6 +35,7 @@
 #define DW_PCIE_VER_480A		0x3438302a
 #define DW_PCIE_VER_490A		0x3439302a
 #define DW_PCIE_VER_500A		0x3530302a
+#define DW_PCIE_VER_510A		0x3531302a
 #define DW_PCIE_VER_520A		0x3532302a
 #define DW_PCIE_VER_540A		0x3534302a
 #define DW_PCIE_VER_562A		0x3536322a
-- 
2.53.0



