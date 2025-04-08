Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EB9269892;
	Tue,  8 Apr 2025 12:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114493; cv=none; b=bhXIhVfBrdOQFOF9P9ZXWHSY2dDj9jZ1Y3EY9ZxMxGzKISnQ83M7BmORB/Vz2cQNKuC063Xu4zMSfuWP3BJ+vpP6BG1M4ANcV6jC91Lw08iHm+0VzoZO10cmmKeOR2lHICWZ3FsMxg2GFE4dr766b4njRpw/QpZX0IKPrL5UO9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114493; c=relaxed/simple;
	bh=J7xt1K8meFIHbAUtluy7tjnL9OZWQT/rognsmIv6gaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RpzWbEgMb0mEpIHZl2hHBSoNcfMqZGsEy5/zIJC6NTinkUAVPG7DdCBqqFUfPC/5M4to9MM76O5DIvbtTypMKOTcqIUMBIeQ3wcqSbH1hxCLZ1x4ulX7V0DQd6Ly/2ctUYhhCNnYzdcl4VJw+O4T893CP60+d19n6etUyxv+O9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJsoZnlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJsoZnlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E40C4CEE5;
	Tue,  8 Apr 2025 12:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114493;
	bh=J7xt1K8meFIHbAUtluy7tjnL9OZWQT/rognsmIv6gaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJsoZnlV6VtfBkGX42XjYD1TddfqgP3Vh03YP5e2Q+F/ofl/khwq1fMn0SXIXlY8n
	 dRDApYr9ZFhLZ86haJilW7Xwx5z73fNBuwvCPcFo2liBX2mpAE/hbvCiUf5K3+KhXp
	 SVFx2I1wfqinovtjK9nTJhWJnZSCiIQKAFBBD+F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 088/499] PCI: brcmstb: Set generation limit before PCIe link up
Date: Tue,  8 Apr 2025 12:45:00 +0200
Message-ID: <20250408104853.411016248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

From: Jim Quinlan <james.quinlan@broadcom.com>

[ Upstream commit 72d36589c6b7bef6b30eb99fcb7082f72faca37f ]

When the user elects to limit the PCIe generation via the appropriate
devicetree property, apply the settings before the PCIe link up, not
after.

Fixes: c0452137034b ("PCI: brcmstb: Add Broadcom STB PCIe host controller driver")
Signed-off-by: Jim Quinlan <james.quinlan@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250214173944.47506-2-james.quinlan@broadcom.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index e733a27dc8df8..b2d523e268b3c 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1276,6 +1276,10 @@ static int brcm_pcie_start_link(struct brcm_pcie *pcie)
 	bool ssc_good = false;
 	int ret, i;
 
+	/* Limit the generation if specified */
+	if (pcie->gen)
+		brcm_pcie_set_gen(pcie, pcie->gen);
+
 	/* Unassert the fundamental reset */
 	ret = pcie->perst_set(pcie, 0);
 	if (ret)
@@ -1302,9 +1306,6 @@ static int brcm_pcie_start_link(struct brcm_pcie *pcie)
 
 	brcm_config_clkreq(pcie);
 
-	if (pcie->gen)
-		brcm_pcie_set_gen(pcie, pcie->gen);
-
 	if (pcie->ssc) {
 		ret = brcm_pcie_set_ssc(pcie);
 		if (ret == 0)
-- 
2.39.5



