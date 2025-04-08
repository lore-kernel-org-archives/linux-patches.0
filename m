Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320C5224F6;
	Tue,  8 Apr 2025 11:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111092; cv=none; b=rv711Zcrl2IElES77Ynzd8CNkuXL9bkN+NyQlbc8lBRGYRys6aQ+1JnsVESVzJEwE31XbEIZ1D4IXehe+BUJnDtkevYrln4Y+ci6MBSHMy+SQRqbRi6WJB3fvOpJZ2Z9OEd2HirQTpDW+fUg5W7kJgz0VGeholzsS48extG5tcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111092; c=relaxed/simple;
	bh=8ZbNA5ICu6iPraDu9HwT+kq1BABrapza2OiGwTQvlqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ELeP2sahvj6Mcv4jlB2St1UAMQXycaeMdy2sUTkXOyyyh9rEiNtYGPFxLgO7gFemT8Tji53SGyMK29AstuVJXJM7267SGL3ZScwgVjc2VDzDB9hq4AUuFc52F9/bVsGKNKrFiWe1WeZQO2h2QTDt9sGb4GyTx5OM62Td5Am/kZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdE9ZWw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdE9ZWw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BA0C4CEE5;
	Tue,  8 Apr 2025 11:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111092;
	bh=8ZbNA5ICu6iPraDu9HwT+kq1BABrapza2OiGwTQvlqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdE9ZWw+NYZfoplfQNroAP/7dBiQAo2zlIWwqf0laM6HUO3BkyUczZFb1N0PMGjaX
	 3kvzEovew58SnXwPSAgZhgB+WabnJpmAdEDRBTC50R5FiHLerEHZ9LHmo/PHNfi7fm
	 D2a23pFOE7Lw/CuoZyR4C6OE2OWorUz3FnXpvYoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 306/731] PCI: brcmstb: Set generation limit before PCIe link up
Date: Tue,  8 Apr 2025 12:43:23 +0200
Message-ID: <20250408104921.395939720@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



