Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF9E28DC4;
	Wed, 20 May 2026 17:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298224; cv=none; b=VG17rl5LsanFCHXkUnceOZti9ILI4fLH3+MRvaijA3SLO+ILo2IgxoYC7yCkBxq2UlwZoyKmsQ5fJiB4QaETYyY7hfl/g/QvA15Q4feJASNMZD3IdIuyTPz7V5ifWEwMMzI3yZ7C4N/1D9Lo9QsZF4LS6Fdg6lGtGQlQlVjP9b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298224; c=relaxed/simple;
	bh=XNjqblKYGIpwjbY7MvbckqBTrjPFLFSV6z7Eqcskasw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uG8Lk6eTEcTjYZnOKQpF5dByp74Ndee2huzwsTrNDubqlv4cfTpHtygeXCLsSNwKRE8vgDyZRlDPXMDWoBDD5D99GoD0KFHzpbg0CLb48P9Vkx4XczpNZ/W5TRmcx8PTAqc/67PlzhQy+wuRIhSvS4tlwrokhqtThaZD7gwclkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qM2iYpPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qM2iYpPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C98B1F000E9;
	Wed, 20 May 2026 17:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298223;
	bh=sFHyuO5YWrHhQ0emJC7fjVjKL6Zfi65lX0khEH8NsDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qM2iYpPAQFdTp5kNtjRx1/TjHevp3ulUv+qyi5+j9/znfcbppDL3OQasiPF8Em8m8
	 zRqrGkMDh/c9rAjTKhW5F4p3JigoSGnz8mpmkxkN8SfKd2lZ3detPnBgMkeL/X0O4X
	 Gfq1sG+AN5qNSth0LU2AilJX5Ojp2IxUS6WI4CaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vidya Sagar <vidyas@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 329/957] PCI: dwc: Apply ECRC workaround to DesignWare 5.00a as well
Date: Wed, 20 May 2026 18:13:32 +0200
Message-ID: <20260520162141.664861236@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Maddireddy <mmaddireddy@nvidia.com>

[ Upstream commit 40805f32dceadebb7381d911003100bec7b8cd51 ]

The ECRC (TLP digest) workaround was originally added for DesignWare
version 4.90a. Tegra234 SoC has 5.00a DWC HW version, which has the same
ATU TD override behaviour, so apply the workaround for 5.00a too.

Fixes: a54e19073718 ("PCI: tegra194: Add Tegra234 PCIe support")
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-13-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 345365ea97c74..2c1dd6ffa27db 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -486,13 +486,13 @@ static inline void dw_pcie_writel_atu_ob(struct dw_pcie *pci, u32 index, u32 reg
 static inline u32 dw_pcie_enable_ecrc(u32 val)
 {
 	/*
-	 * DesignWare core version 4.90A has a design issue where the 'TD'
-	 * bit in the Control register-1 of the ATU outbound region acts
-	 * like an override for the ECRC setting, i.e., the presence of TLP
-	 * Digest (ECRC) in the outgoing TLPs is solely determined by this
-	 * bit. This is contrary to the PCIe spec which says that the
-	 * enablement of the ECRC is solely determined by the AER
-	 * registers.
+	 * DWC versions 0x3530302a and 0x3536322a have a design issue where
+	 * the 'TD' bit in the Control register-1 of the ATU outbound
+	 * region acts like an override for the ECRC setting, i.e., the
+	 * presence of TLP Digest (ECRC) in the outgoing TLPs is solely
+	 * determined by this bit. This is contrary to the PCIe spec which
+	 * says that the enablement of the ECRC is solely determined by the
+	 * AER registers.
 	 *
 	 * Because of this, even when the ECRC is enabled through AER
 	 * registers, the transactions going through ATU won't have TLP
@@ -559,7 +559,7 @@ int dw_pcie_prog_outbound_atu(struct dw_pcie *pci,
 	if (upper_32_bits(limit_addr) > upper_32_bits(parent_bus_addr) &&
 	    dw_pcie_ver_is_ge(pci, 460A))
 		val |= PCIE_ATU_INCREASE_REGION_SIZE;
-	if (dw_pcie_ver_is(pci, 490A))
+	if (dw_pcie_ver_is(pci, 490A) || dw_pcie_ver_is(pci, 500A))
 		val = dw_pcie_enable_ecrc(val);
 	dw_pcie_writel_atu_ob(pci, atu->index, PCIE_ATU_REGION_CTRL1, val);
 
-- 
2.53.0



