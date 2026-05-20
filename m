Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FB52D12EE;
	Wed, 20 May 2026 16:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295462; cv=none; b=mDJ82faQa9a2CEAeSLDQh5IHFxKdBpTiBVb7NUyglBkYUUlLRE2xHQ4ptXPcFRmdCcAV89sF4JxHDbCd2KuPZe27nfm5gWHg8B+TWglHeJd8zdAFux2zrOlmIkw5idl6e3Eg4q6xZLw3ks7lw3KYciF2rVO4yuAUGY9WIK/ONbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295462; c=relaxed/simple;
	bh=yUvJXh4Hy0uy/uENQ71sGWXSiFVRUy4Vih3mtRW8nDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZB8QufWbxWlu/bY247APfUT2aMb3cgs+P/0zWYV2fLZzjtpUMTTvpHZ3q1LxJDMN7dRAOeUymmScGIE19NsrMgCSJ8OfyVY6At+wTQImzZDzUaeT3hNTQeiLKJ3hJg7SBksT2a0fxaA0JYtushm+/Yc/QanOkSrpiDNjXbJl1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzZKDM51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzZKDM51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EFC1F000E9;
	Wed, 20 May 2026 16:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295461;
	bh=BHo9dEsljp6D3svok5vpY28es4JvXoNQ2pffAv2sayY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzZKDM51eTUd1pH9dDmLyaGjbYNVopY/XaB1mAm877d1u2KgajpJhVzWr8dtY9GzQ
	 7MDu1idhD0OlEBKy/m1jvvufGsZ+fobo+SyukmlOAXG8KuRgQTfor1hHMbV3cm9ug0
	 xmq+LZoL3lkKGfQ6eZvlvWGvoz2/GTO5RFULyvLE=
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
Subject: [PATCH 7.0 0426/1146] PCI: dwc: Apply ECRC workaround to DesignWare 5.00a as well
Date: Wed, 20 May 2026 18:11:16 +0200
Message-ID: <20260520162157.832203281@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 5741c09dde7f4..bb4e82fbfd5c8 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -487,13 +487,13 @@ static inline void dw_pcie_writel_atu_ob(struct dw_pcie *pci, u32 index, u32 reg
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
@@ -563,7 +563,7 @@ int dw_pcie_prog_outbound_atu(struct dw_pcie *pci,
 	if (upper_32_bits(limit_addr) > upper_32_bits(parent_bus_addr) &&
 	    dw_pcie_ver_is_ge(pci, 460A))
 		val |= PCIE_ATU_INCREASE_REGION_SIZE;
-	if (dw_pcie_ver_is(pci, 490A))
+	if (dw_pcie_ver_is(pci, 490A) || dw_pcie_ver_is(pci, 500A))
 		val = dw_pcie_enable_ecrc(val);
 	dw_pcie_writel_atu_ob(pci, atu->index, PCIE_ATU_REGION_CTRL1, val);
 
-- 
2.53.0



