Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA92272E56;
	Wed, 20 May 2026 18:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302192; cv=none; b=Io3uhmVhxmMrMgCMFnFMJhEvyMPIYau6oQxh+4w5DIU/cwmsmrEexn16cDDBrgHq8HObljepMlkOgEO7pbh6lUJUiH4qI+RoDre8ScKV/w1pKWGOxpAU8AUgB/nde7Fk44DhtsqXjLlLIS5iwk+fvMG24HasBb3ig1VE8dPEWuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302192; c=relaxed/simple;
	bh=yu9BDYruO//a0hday1UWtMS1v9PklUBI7m8R919xYdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuKYncGgUHxOEDfaYFXuZ4MfEeFr8zJWQUsmEdJ+RhGUepv8js5C7x0kOfw8enq79kt1xLvA7TIG9gSZ1eemxTaVmjLS+mtwy5g9PK6RYXP0X8p8rZkAWCIvrq4hRnpCnnpYgR3+wWMbkxpf4JDW1ptlIIIXMFALuyPXsA2G/n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSR0ehpY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSR0ehpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437411F000E9;
	Wed, 20 May 2026 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302190;
	bh=Sy5C7SiXcYG0hhpiefSzO9Ej+BT0Vw9tizMCrpOZfpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSR0ehpYrgkdqwGYq26CnxFp0QlWbe78rggoKgxlotoZfRApithJarJ9j+Cj+NF9N
	 +u2NgxloK1OWRf3HxP/6XEFCu9ROVM5XbxeFSJCtMWwn590763YGHMYSNC04P38RE4
	 Xf6GABPmkhMC11yp7pvCrMPc+THX0j8xmm//9Zko=
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
Subject: [PATCH 6.6 166/508] PCI: dwc: Apply ECRC workaround to DesignWare 5.00a as well
Date: Wed, 20 May 2026 18:19:49 +0200
Message-ID: <20260520162102.236581511@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 46b12e157bebe..504450a8b6a45 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -426,13 +426,13 @@ static inline void dw_pcie_writel_atu_ob(struct dw_pcie *pci, u32 index, u32 reg
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
@@ -502,7 +502,7 @@ static int __dw_pcie_prog_outbound_atu(struct dw_pcie *pci, u8 func_no,
 	if (upper_32_bits(limit_addr) > upper_32_bits(cpu_addr) &&
 	    dw_pcie_ver_is_ge(pci, 460A))
 		val |= PCIE_ATU_INCREASE_REGION_SIZE;
-	if (dw_pcie_ver_is(pci, 490A))
+	if (dw_pcie_ver_is(pci, 490A) || dw_pcie_ver_is(pci, 500A))
 		val = dw_pcie_enable_ecrc(val);
 	dw_pcie_writel_atu_ob(pci, index, PCIE_ATU_REGION_CTRL1, val);
 
-- 
2.53.0



