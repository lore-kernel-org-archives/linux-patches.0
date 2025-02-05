Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226141C6BE;
	Wed,  5 Feb 2025 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767867; cv=none; b=pgwF5JgIxkbFVH00OJaKy9bWaTw+kB4QaUzpt4WMSoXYxkrdry7BVNtBG/Su/8gfNSsaXOaMwppXh7U/9sRN16OHwws6sv/T9CMAjAY3u6WO5ypdK7Ma2+P03A5pePv3dFnKThmUUOf3ijXuRw+BK9piQ5D/spkzVCE2jeyK+Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767867; c=relaxed/simple;
	bh=65B7HekaxgLHEbU1DU5Sj9rTUSE2Sx3fY77uUlAWq8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rn8gwv2MqndlLdifxi0eDi4CaPGtrJx97bKpu5LYpmWDblgVFCxLtWyk96swTrmjh28mypiWmc1s/Aoe4b+5xrU30jAfoxxwJ1PCRdhzGvfBl5LG447oUIBeviHUU12nez68UU9SPAVYeNDsK0fsqvicrly1loShRXRb+o3X9DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+CGZyQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+CGZyQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8B2C4CED1;
	Wed,  5 Feb 2025 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767867;
	bh=65B7HekaxgLHEbU1DU5Sj9rTUSE2Sx3fY77uUlAWq8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+CGZyQirt9vZ9seRVH078mhnugrB5ubWHjnI60PeH1VXc6ioqlNOlizuITVe6lIk
	 IxP0ZdMjiF8bvHSyBBngBPf06EKCO7LQizGHzd7tmqAmVMokebx1M91FDSS8qkln3x
	 JjdXR7XHxvGTXcl8KgDfMjsyrk9RmSMNwOBkfi3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 464/623] PCI: imx6: Configure PHY based on Root Complex or Endpoint mode
Date: Wed,  5 Feb 2025 14:43:26 +0100
Message-ID: <20250205134513.969666148@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit de22e20589b79f35f92543119c33051f8179dba0 ]

Pass PHY_MODE_PCIE_EP if the PCI controller operates in Endpoint (EP) mode,
and fix the Root Complex (RC) mode being hardcoded using a drvdata mode
check.

Fixes: 8026f2d8e8a9 ("PCI: imx6: Call common PHY API to set mode, speed, and submode")
Link: https://lore.kernel.org/r/20241119-pci_fixup_addr-v8-6-c4bfa5193288@nxp.com
Signed-off-by: Frank Li <Frank.Li@nxp.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index c8d5c90aa4d45..9d61e7c472082 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -966,7 +966,9 @@ static int imx_pcie_host_init(struct dw_pcie_rp *pp)
 			goto err_clk_disable;
 		}
 
-		ret = phy_set_mode_ext(imx_pcie->phy, PHY_MODE_PCIE, PHY_MODE_PCIE_RC);
+		ret = phy_set_mode_ext(imx_pcie->phy, PHY_MODE_PCIE,
+				       imx_pcie->drvdata->mode == DW_PCIE_EP_TYPE ?
+						PHY_MODE_PCIE_EP : PHY_MODE_PCIE_RC);
 		if (ret) {
 			dev_err(dev, "unable to set PCIe PHY mode\n");
 			goto err_phy_exit;
-- 
2.39.5



