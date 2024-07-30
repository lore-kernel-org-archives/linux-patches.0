Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D621817D8BB;
	Tue, 30 Jul 2024 16:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358714; cv=none; b=b2BY+l9JDw+bbZNQYKDUCp6HFJW9CilUH0VmaDqoKKXJZ/YzVPfTJRIe7AK0utsWA/6aaGp1ONE+HiHBdQYxUKlVj20097hlCxFiidYZdxmkMDnFX7t0jfDURQFgIELRGEekFw45KYs2e5h0LYtfpSzX8Dve8V/5tGUdTpqOixc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358714; c=relaxed/simple;
	bh=eoAeIMOkDzgoMwIOl3Gc3NlK4/nKsWXfYmXDijdl8Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FFLw76zkI1jXpU3PttwiThj5mogGWwXtABAogMUBfF82lu9XIuCmsZefVf+XyiTJw+IY47FQNkEqemXfIeqgmB0d5MyiwWz6UMEtAxXhqi9+sgsNRB0QzZnalNetOBDq4Ur6WKu32PbTDoDm+FQ61ZvqBmboanJ/Z+pU86FcTiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJG/qql3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJG/qql3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446B3C32782;
	Tue, 30 Jul 2024 16:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358713;
	bh=eoAeIMOkDzgoMwIOl3Gc3NlK4/nKsWXfYmXDijdl8Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJG/qql32FbSvCil6paMFDU7CGpPh7paTZk8dd8WzB+cjTd2FdZgxcWDf/3rBfvu8
	 4nyIT5oVbL7PjIUclhRG28dgCfKrLJZfllZX+osZHs/aZKOiLXIAdbvjMUH+ffeVYl
	 uWzi5419EYA5/maVnKbfQP0pg4IW7FBTvWndJeG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 387/809] PCI: tegra194: Set EP alignment restriction for inbound ATU
Date: Tue, 30 Jul 2024 17:44:23 +0200
Message-ID: <20240730151739.955631749@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit d19a86d584e04191cdab7ced24d7ed791075697a ]

Tegra194 and Tegra234 PCIe EP controllers have 64K alignment restriction
for the inbound ATU. Set the endpoint inbound ATU alignment to 64kB in the
Tegra194 PCIe driver.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Suggested-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Link: https://lore.kernel.org/linux-pci/20240508092207.337063-1-jonathanh@nvidia.com
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 93f5433c5c550..4537313ef37a9 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -2015,6 +2015,7 @@ static const struct pci_epc_features tegra_pcie_epc_features = {
 	.bar[BAR_3] = { .type = BAR_RESERVED, },
 	.bar[BAR_4] = { .type = BAR_RESERVED, },
 	.bar[BAR_5] = { .type = BAR_RESERVED, },
+	.align = SZ_64K,
 };
 
 static const struct pci_epc_features*
-- 
2.43.0



