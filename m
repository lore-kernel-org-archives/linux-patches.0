Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7800364E89;
	Wed, 20 May 2026 16:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295444; cv=none; b=beCWfvRTvCwPIg0hVHFEqrAqDog1ArIZGkY7YcmC5bMkMiDgRw2Qu4kZ0o/DQhf9PvW51cHK2xVYpQC7EDSD9Sm6JIfJgA/8QkdNoT45/nD3qId0JVOWsABINJ/iBYWOdj2yXKOD9qfB6LfsDK7v99rwgY2C0K7fAZRc1dEykQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295444; c=relaxed/simple;
	bh=JpUsRwm4ZJdnwmiHlKKGi3MXTUwjQ8vJAJyJbXwyC5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/GJfwYdqqpA7BTz0sr0S1fe+wjZIi/PHRc1iFLa+6wlz1Y85go9I9zWzmcCF/Gs6CKBg/Y5xYW8LH/zOi0v3J60CwAiqxIzO1BqVIOtFqdq9YoA3S3VPsGKSbSokRfXQUWeQhJOYcrPRAGQRzidBYXd9jRPzFRQAAu7iSNmECQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0urFz0p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0urFz0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5438D1F000E9;
	Wed, 20 May 2026 16:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295442;
	bh=/HEKwVMpswmKTtuPy0BHshQIv6CocKS1pNoc1q6hhOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0urFz0p8RhfMZtbBfIXPYZadyMOnic2XTsOKxmW3ooGPplYTG/Jr8OGxIz7CY/+2
	 ZFz9Asvt9AtdDOqVrTqZKRqeSz5K0UcBu/R+gDSuntkErYMjb3iMNJjPqE5J+t5YWq
	 Y98nv2BbsnudvpAb6FVO4QBOCBvSEqASRzyOep3A=
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
Subject: [PATCH 7.0 0420/1146] PCI: tegra194: Use devm_gpiod_get_optional() to parse "nvidia,refclk-select"
Date: Wed, 20 May 2026 18:11:10 +0200
Message-ID: <20260520162157.700090146@linuxfoundation.org>
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

[ Upstream commit f62bc7917de1374dce86a852ffba8baf9cb7a56a ]

The GPIO DT property "nvidia,refclk-select", to select the PCIe reference
clock is optional. Use devm_gpiod_get_optional() to get it.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-7-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index ceb34110a50b3..71b80edd10c8c 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1167,9 +1167,9 @@ static int tegra_pcie_dw_parse_dt(struct tegra_pcie_dw *pcie)
 		return err;
 	}
 
-	pcie->pex_refclk_sel_gpiod = devm_gpiod_get(pcie->dev,
-						    "nvidia,refclk-select",
-						    GPIOD_OUT_HIGH);
+	pcie->pex_refclk_sel_gpiod = devm_gpiod_get_optional(pcie->dev,
+							     "nvidia,refclk-select",
+							     GPIOD_OUT_HIGH);
 	if (IS_ERR(pcie->pex_refclk_sel_gpiod)) {
 		int err = PTR_ERR(pcie->pex_refclk_sel_gpiod);
 		const char *level = KERN_ERR;
-- 
2.53.0



