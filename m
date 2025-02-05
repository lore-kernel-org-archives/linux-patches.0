Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F381C6BE;
	Wed,  5 Feb 2025 15:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767881; cv=none; b=hyjC3Rx0WRYwXxX+hLLIjSgpQWH7XrJvVcasrBsVvbudmZWQrxICBDe9GENbTYgQroZ09KepyGgYARqRjeE7LMGzYiiUSCz8EmJakesFH6r2BF7ZEsGD6pbyzdLp8OieXQWseWKnSwqXnxxLYI6MLYbmQDsRe8nft+/efU4woKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767881; c=relaxed/simple;
	bh=+Totolw3kj1DxV9w5f+ouYvzR2TmBNaulCaAOBFx7N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bkUEk2qmqXLSukSQDtooTcc1aVZgqvcmnmPesrhyNP6fQNez+u1Z7W4+5LCaotKKZdCvB6XkKfMKI1yGPSHKhYboxl4mbA0rTMriiWKO3b+RUSP+wlw7Lh77/dSDLIjtozGHpPPDDFbJTkStVO7PY9oFdk+Js2+SOYle/XT+uUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSt7eotp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSt7eotp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AD4C4CED1;
	Wed,  5 Feb 2025 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767880;
	bh=+Totolw3kj1DxV9w5f+ouYvzR2TmBNaulCaAOBFx7N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSt7eotp3MrgUGMoYTtG20bHWL/6Hb9UcFIdk+R7wxlURro4MZXvLAB/MtcdZEw6g
	 qHUiI9y2egMbkN4gtaEcojtsxCosj96+GUcLne/X1jWx3A3v43vioCKNbk0WL8+LaJ
	 9X6paBDhGuHyLYc5Sl29BrBarai8atk0i9eBrRpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 466/623] PCI: imx6: Deassert apps_reset in imx_pcie_deassert_core_reset()
Date: Wed,  5 Feb 2025 14:43:28 +0100
Message-ID: <20250205134514.045914186@linuxfoundation.org>
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

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit ef61c7d8d032adb467f99d03ccfaa293b417ac75 ]

Since the apps_reset is asserted in imx_pcie_assert_core_reset(), it should
be deasserted in imx_pcie_deassert_core_reset().

Fixes: 9b3fe6796d7c ("PCI: imx6: Add code to support i.MX7D")
Link: https://lore.kernel.org/r/20241126075702.4099164-6-hongxing.zhu@nxp.com
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 22bf21846b79d..94f5246b3a720 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -775,6 +775,7 @@ static void imx_pcie_assert_core_reset(struct imx_pcie *imx_pcie)
 static int imx_pcie_deassert_core_reset(struct imx_pcie *imx_pcie)
 {
 	reset_control_deassert(imx_pcie->pciephy_reset);
+	reset_control_deassert(imx_pcie->apps_reset);
 
 	if (imx_pcie->drvdata->core_reset)
 		imx_pcie->drvdata->core_reset(imx_pcie, false);
-- 
2.39.5



