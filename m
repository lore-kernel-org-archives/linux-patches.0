Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5A6387361;
	Tue, 10 Mar 2026 11:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141953; cv=none; b=a28oul4cGuVtBn4dtaczDUwkdvsMzfvjJCaouMCKa0uTOx5P+ETYy7glPpnQEPHEopvEiPJnr1nNDk+O+ieTqSpfTEzNVWoBBVDgRsiBjUuQYCXT+Kdrbl/45ubmrVoWA16wl8q2aqYf5TpEKF12+mbKXO42S77kuPQIEo4hiXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141953; c=relaxed/simple;
	bh=+hBmvuL5LI/atyWUlyTwboFN3+GrT4wnMxHJ4YjXFow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeKZfb7tEeHOahH7R4IdJGhwgcPKMpONsw1OagaNyIx+51Q/GfcZ72ApeyRPE/3Nq/8ZE4F13kWS1XqQWUUy3mqaYxjwdHiOaZUEpMfeGx1Yj/Soz1iv3T3pxV0J2IzdlB3wcOg0piHtf7p/JelluoTBq71Fee3NTN9k465Lo6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRQ4bcFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRQ4bcFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27195C2BC86;
	Tue, 10 Mar 2026 11:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141952;
	bh=+hBmvuL5LI/atyWUlyTwboFN3+GrT4wnMxHJ4YjXFow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRQ4bcFxZZTf5FnNAj157sab5FhhimVd91obk6xty6Rb+L0EEAcrFAxQSA/6tlTzf
	 RFofMZn+fW0P3X5GyYT+Q5oc6sQRqAYq32Ws2xv5tbrjIkrOsPPtZ3jIn2TA8vlvH5
	 aLT8A6qDqX1NkGaclpjvXY/VayfnMUV0XVbm+O6jHowYwd5S1ZWSfL9hb9iULwIZli
	 8GU7meratz8WBG/x/FibZSzYQHOUBqnYWRNhuYRzVG8ViaonvIsudeSSTEh9mknx8p
	 M0SOxzIybihiEYEVnyzGf6pCihEui+gZ5fZI465K2OdoVroe7ZngREAGg9qzuEeNO+
	 VlmMAt3NbeG0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Anand Moon <linux.amoon@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/314] PCI: j721e: Use devm_clk_get_optional_enabled() to get and enable the clock
Date: Tue, 10 Mar 2026 07:15:35 -0400
Message-ID: <e5f5a81abb6366e5dfe3aa7c285c284f78feeb63.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 6fad11c61d0dbf87601ab9e2e37cba7a9a427f7b ]

Use devm_clk_get_optional_enabled() helper instead of calling
devm_clk_get_optional() and then clk_prepare_enable().

Assign the result of devm_clk_get_optional_enabled() directly to
pcie->refclk to avoid using a local 'clk' variable.

Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://patch.msgid.link/20251028154229.6774-2-linux.amoon@gmail.com
Stable-dep-of: 4b361b1e92be ("PCI: j721e: Add config guards for Cadence Host and Endpoint library APIs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 5bc5ab20aa6d9..a88b2e52fd782 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -479,7 +479,6 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 	struct cdns_pcie_ep *ep = NULL;
 	struct gpio_desc *gpiod;
 	void __iomem *base;
-	struct clk *clk;
 	u32 num_lanes;
 	u32 mode;
 	int ret;
@@ -603,19 +602,13 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 			goto err_get_sync;
 		}
 
-		clk = devm_clk_get_optional(dev, "pcie_refclk");
-		if (IS_ERR(clk)) {
-			ret = dev_err_probe(dev, PTR_ERR(clk), "failed to get pcie_refclk\n");
+		pcie->refclk = devm_clk_get_optional_enabled(dev, "pcie_refclk");
+		if (IS_ERR(pcie->refclk)) {
+			ret = dev_err_probe(dev, PTR_ERR(pcie->refclk),
+					    "failed to enable pcie_refclk\n");
 			goto err_pcie_setup;
 		}
 
-		ret = clk_prepare_enable(clk);
-		if (ret) {
-			dev_err_probe(dev, ret, "failed to enable pcie_refclk\n");
-			goto err_pcie_setup;
-		}
-		pcie->refclk = clk;
-
 		/*
 		 * Section 2.2 of the PCI Express Card Electromechanical
 		 * Specification (Revision 5.1) mandates that the deassertion
@@ -629,10 +622,8 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 		}
 
 		ret = cdns_pcie_host_setup(rc);
-		if (ret < 0) {
-			clk_disable_unprepare(pcie->refclk);
+		if (ret < 0)
 			goto err_pcie_setup;
-		}
 
 		break;
 	case PCI_MODE_EP:
@@ -679,7 +670,6 @@ static void j721e_pcie_remove(struct platform_device *pdev)
 
 	gpiod_set_value_cansleep(pcie->reset_gpio, 0);
 
-	clk_disable_unprepare(pcie->refclk);
 	cdns_pcie_disable_phy(cdns_pcie);
 	j721e_pcie_disable_link_irq(pcie);
 	pm_runtime_put(dev);
-- 
2.51.0

