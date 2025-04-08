Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F63226B2DB;
	Tue,  8 Apr 2025 12:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116254; cv=none; b=KnPGKFrmljHv1C3Kr/W6ItYrTiPa6xJRiGp0s47YsL499CyUwU17bTujmWS2CH5dilQ7H4Kfg1OEOAWl2WYMYKeHXuJ31vyf+mmZuofPxCUMN0UItNmCi2L9cC85zk/83XOu/aHNjGv/bxSY780rt8doNa192LA0ygUcAV6hRGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116254; c=relaxed/simple;
	bh=4phjdJXAvHOloPlUCc9Y8Als5NDGG57ntRs11wUoe2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JOvMLGJJZRHdGsuogMz9CE6746i231mSpOcbobMWMa5gB8g5ZTH3KJP/RFZ/LN2ABA54fiJJJqeA9ZpDMslYsIbqoU2n6Bgc9yx71CTK7nuXMomSXo4evE6pzxmUpcaKmp+PeNAynAQ/DOeT/8XmMr3SZ0TbKLfDdnznQxxsWIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wb+iwWcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wb+iwWcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48DAC4CEE5;
	Tue,  8 Apr 2025 12:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116254;
	bh=4phjdJXAvHOloPlUCc9Y8Als5NDGG57ntRs11wUoe2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wb+iwWcjP+uuTLUieUartwKoO7pn1xvJxNLZwyMl7uAeDaUJges3dw16GiTnKWyHt
	 UaUxWL2vB2pDiwizdkH2SxtxVfzDy6YIvHrEPB7fnnRHXk92e67Lv+560UYg1AvcEi
	 S29EvTD0Uru/VawVF/8ctbKaPEFppjcPgB4CWE+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/423] PCI: brcmstb: Set generation limit before PCIe link up
Date: Tue,  8 Apr 2025 12:46:38 +0200
Message-ID: <20250408104847.423668227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index 9321280f6edba..98e3531927298 100644
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



