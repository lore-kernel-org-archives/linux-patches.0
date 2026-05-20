Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B106331220;
	Wed, 20 May 2026 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300618; cv=none; b=sFp1oko9VnnH3kh4RQ8LPqhT863BDQySOBpFOgAW9oI66/i3OUcyVB5zxLSkekY+HBKv8pWxt4rI4gtt83JhAZSMmeqsqPmHqI5qKn7TT2wEF3w/IwKhL4I4Kvvj403eV2r7oPeN3K8X/vOJpIcPPNtle4h7pjH4ThEgLPRUok8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300618; c=relaxed/simple;
	bh=kcJ4gsUIa4SBGX8TV5RcRPxvZc8BeHuVzuO/EbWKQt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJUxCBnn6HXW8vQC3K6mUCGhjIu7ByQ7DwepSPd7nzNI/qfpDaXZmZ8e4QG01f8SoNCdlnNZoYI+hXnFNrzgxsbiNdjJmlFkp/VAj7lvTBt6ncNhxs58xiRwepOxqzrubpobASNXGdRGdAZVcu8IDZK4S5mJlB8A4+TkuzvCzFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LExWUff3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LExWUff3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962A41F000E9;
	Wed, 20 May 2026 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300617;
	bh=gH7yDrkxrTkO0LWc9VdRD4KEwdlXGW7xcAa0pBgvR1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LExWUff3BWTGNh7AqfKH7OdRc0b221FTbsNxRiBj5Rm3rXY6bAcmJWQByMpUE6NlO
	 zOaJkDf4pOrPsZIanQpnlg7e886x1aVgpX7hijuuxj59/+9rOKxjVLZ7/wD7T9sbPQ
	 HzeOCH34HluUj6jJiWFgxM/eyaDw/5bcKRryAe2Q=
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
Subject: [PATCH 6.12 242/666] PCI: tegra194: Free up Endpoint resources during remove()
Date: Wed, 20 May 2026 18:17:33 +0200
Message-ID: <20260520162116.463571762@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 8870f02f7868209eb9bdc5dc53540a6262cf9227 ]

Free up the resources during remove() that were acquired by the DesignWare
driver for the Endpoint mode during probe().

Fixes: bb617cbd8151 ("PCI: tegra194: Clean up the exit path for Endpoint mode")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-11-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index bf7acdb725a33..dd08ad8d08cbd 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -2282,6 +2282,7 @@ static int tegra_pcie_dw_probe(struct platform_device *pdev)
 static void tegra_pcie_dw_remove(struct platform_device *pdev)
 {
 	struct tegra_pcie_dw *pcie = platform_get_drvdata(pdev);
+	struct dw_pcie_ep *ep = &pcie->pci.ep;
 
 	if (pcie->of_data->mode == DW_PCIE_RC_TYPE) {
 		if (!pcie->link_state)
@@ -2293,6 +2294,7 @@ static void tegra_pcie_dw_remove(struct platform_device *pdev)
 	} else {
 		disable_irq(pcie->pex_rst_irq);
 		pex_ep_event_pex_rst_assert(pcie);
+		dw_pcie_ep_deinit(ep);
 	}
 
 	pm_runtime_disable(pcie->dev);
-- 
2.53.0



