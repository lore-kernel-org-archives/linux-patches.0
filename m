Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D5618A6D7;
	Wed,  5 Feb 2025 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767232; cv=none; b=oDmnpoSkeCTFw/rASW5tOtMoiKTyicyl+Emt51CmE6a1X8+r0fByESy2Darj0I0v36pM/NUEFymSf/518Uc0dyTa+P3lmXTHkJxye3EGQLxEtv1Gc6tLV69nMjvPljWOvXxhijuMx1Q2AqrIh/bXUC5BTgSeiA2LzXDNzGi0604=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767232; c=relaxed/simple;
	bh=ZmUwcjh3s0vgxXfgt/VY/Te+b1oNtWSN/gUKACgiw6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QaEN8GjlAm6H3x1s7et9seBcXhcJufQg/IDxkSSmWvc22i1r8TzV0T5RuIHOGBZgR/3TPa7R/qy9C9M8unCs/JXptG+I0Gmc2LD7gL3tV0V06Lnfc7PNsM0HVyJteK1CUar8VceTNxZfbbi7WuTNNBkczOOnZcGLjqWOsWlO3wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcaqZK3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcaqZK3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE5FC4CED1;
	Wed,  5 Feb 2025 14:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767232;
	bh=ZmUwcjh3s0vgxXfgt/VY/Te+b1oNtWSN/gUKACgiw6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcaqZK3o9g3cl4nSqao0a2f3UqOaRfbfJ7brVH7Dk+Y7tfvL5LrZ+dfzqjBQvxJLG
	 PeDG3BDKIKO6mxgCFsyG+XGi2ign5JO4KLjJd2V+fTXM63Sr8jKpP+vDHtH4VXZwP6
	 ZJdIQdJLu5uLjQpTtp2NZTTAkM7GxBYY4pK3uSPs=
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
Subject: [PATCH 6.12 427/590] PCI: imx6: Deassert apps_reset in imx_pcie_deassert_core_reset()
Date: Wed,  5 Feb 2025 14:43:02 +0100
Message-ID: <20250205134511.601149772@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



