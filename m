Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1F73546D0;
	Wed, 20 May 2026 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295449; cv=none; b=ZQtNrBuLYSlLAQujs+mJewLHjNKJdgaIIvF7RIPdhtCscCfT34lJk7D6Cvc084jSDCufQkIhfn6oaWQxcQGqGkOeSZ0/wWxawyTg45u+C5A1r42KeXsKOAleR/hGUv2eCogeDLtwsCPizEhRIiO6uMVox5vQaWICAY9UydbkmMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295449; c=relaxed/simple;
	bh=hdsxvmnZ8qWX/mBXqiv8AtU6yab4K4MHCRcVZ3dEANw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAfft/z2+m61RlJ1RxQS4TE1rGTKgmihS9aNgordIu3DPc4TUFugOVUZAmgD3h2iCc/ix679AyeWfB6dpqN170SylydfNbo4FSbSjyKztdY4XsDXeBjijYoTHv9PNKnD22kHOICwPQ9c4Abb5ScUAO9pSVInW/cgSzJMj+FYOns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8KrryU8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8KrryU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF101F000E9;
	Wed, 20 May 2026 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295448;
	bh=3TunFIMPXS3y3iSEZdFvJdbF5fWjJ6AUxHKKoCtLnv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8KrryU8qmh5p7qa2gMLwRO/kuwbkqxubQb6zqHZ8psd3PBil8F6vpatP1dHjXCrv
	 XJNjcDRTRhLoG2pCWTv6CtGrB9tIqIF24fmbuWcyC5tsYiUGALkkiQPsJZZaqcSYve
	 nZogCI4tY3SQyfMgnzfr5Dpqkv1FJw5eG8cPXyxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0422/1146] PCI: tegra194: Set LTR message request before PCIe link up in Endpoint mode
Date: Wed, 20 May 2026 18:11:12 +0200
Message-ID: <20260520162157.744808406@linuxfoundation.org>
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

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit b256493bf8cacf0e524bf4c10b5c4901d0c6cefe ]

LTR message should be sent as soon as the Root Port enables LTR in the
Endpoint mode. So set snoop and no-snoop LTR timing and LTR message request
before the PCIe link comes up, so that the LTR message is sent upstream as
soon as LTR is enabled.

Without programming these values, the Endpoint would send latencies of 0 to
the host, which will be inaccurate.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-9-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 4d8bfd3e34ece..95dbf2102c898 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -485,15 +485,6 @@ static irqreturn_t tegra_pcie_ep_irq_thread(int irq, void *arg)
 	if (val & PCI_COMMAND_MASTER) {
 		ktime_t timeout;
 
-		/* 110us for both snoop and no-snoop */
-		val = FIELD_PREP(PCI_LTR_VALUE_MASK, 110) |
-		      FIELD_PREP(PCI_LTR_SCALE_MASK, 2) |
-		      LTR_MSG_REQ |
-		      FIELD_PREP(PCI_LTR_NOSNOOP_VALUE, 110) |
-		      FIELD_PREP(PCI_LTR_NOSNOOP_SCALE, 2) |
-		      LTR_NOSNOOP_MSG_REQ;
-		appl_writel(pcie, val, APPL_LTR_MSG_1);
-
 		/* Send LTR upstream */
 		val = appl_readl(pcie, APPL_LTR_MSG_2);
 		val |= APPL_LTR_MSG_2_LTR_MSG_REQ_STATE;
@@ -1803,6 +1794,15 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 	val |= APPL_INTR_EN_L1_0_0_RDLH_LINK_UP_INT_EN;
 	appl_writel(pcie, val, APPL_INTR_EN_L1_0_0);
 
+	/* 110us for both snoop and no-snoop */
+	val = FIELD_PREP(PCI_LTR_VALUE_MASK, 110) |
+	      FIELD_PREP(PCI_LTR_SCALE_MASK, 2) |
+	      LTR_MSG_REQ |
+	      FIELD_PREP(PCI_LTR_NOSNOOP_VALUE, 110) |
+	      FIELD_PREP(PCI_LTR_NOSNOOP_SCALE, 2) |
+	      LTR_NOSNOOP_MSG_REQ;
+	appl_writel(pcie, val, APPL_LTR_MSG_1);
+
 	reset_control_deassert(pcie->core_rst);
 
 	val = dw_pcie_readl_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL);
-- 
2.53.0



