Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A75270545;
	Wed, 20 May 2026 18:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302168; cv=none; b=um+5ZbhjNKzYQUw0OpEWDU+2URl/7JaH5kUzCenR7jr9fubjOgfjzHBHK5bpUBpQyJbdCFwIM+wAgK2nRZiB9Y12CrM+giJriuDaabQFiaaIHoXhHpeS53jDTe1y7upBAG1PbvLggBsikBAQl1q2+//DxFdM1W2XrJhO4lCZ0NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302168; c=relaxed/simple;
	bh=tv3u/n/WKU6KCq/3gQn8AT5595Mael8hZCBu+QKeX7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shm3vEozDwWgaNloFIdBrhZOqqSAt4B4alZ1DlX2STaO3zxKI1hKZrYczh20AvkPJgn3/x6EfLhEuwCRo4oMHTCQChco6DNy2I7QPcGfcWmf2UAGRL5pf0cdhxiyZoESJFvGJKo1kQW4grR6LN8Lv2grs2k79CksEs5TXXjcKa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOXENG7M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOXENG7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D151F000E9;
	Wed, 20 May 2026 18:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302167;
	bh=v8tjQV/xmaEcVGk2TlQ9Bpbrf9bCnpP3yAG9lP2jPxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOXENG7MlpoVWlXRFReDFY4tPiP49BKdMhmgEIB3HmwDuz3O7sB1UtkS5b5qMdAYo
	 LsqF9Tdk5bMVzYL2k3ve21QYzGBtr9VNAlKpd21CeOwFpkI2094QGFPbGjHp0QDURO
	 FtkZdaDr3G4x89k9uCWx8HoDoDacLiVkML0uJtTc=
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
Subject: [PATCH 6.6 162/508] PCI: tegra194: Use devm_gpiod_get_optional() to parse "nvidia,refclk-select"
Date: Wed, 20 May 2026 18:19:45 +0200
Message-ID: <20260520162102.148371272@linuxfoundation.org>
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
index ed0d12ab579d8..dba73a0ea4210 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1197,9 +1197,9 @@ static int tegra_pcie_dw_parse_dt(struct tegra_pcie_dw *pcie)
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



