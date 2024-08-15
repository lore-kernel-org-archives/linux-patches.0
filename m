Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D054917C984;
	Thu, 15 Aug 2024 13:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728783; cv=none; b=YOoSnhmRt0WdAKuzyKYYrkVNzL2GQVQsQoRX7STlRZIQtjSmuU7Gd/EQYrjQDkiQD3md9ITK+8n+r+Waf6Y55xuGqY78kw1PzQXK4RLYPpoZxtjjFLNHUt9QLJvER4zpm2k/9Kh/5M5kvTekre4kgJWJdWyX/4J4pZ3jndaRZuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728783; c=relaxed/simple;
	bh=a0F57Vg5+IHlJ+yzD9/OPF6mCVsWuoupCVDsskvQzV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJBDclcEfAd6941zCotHOvMimWQ9BcTJXmp68MgNTGsSkvyGOY0VyxedECv9tL/g5ObeR///Pdz5+sTM5oAmnnTbc6y/Zcn3XgMjToAIMfRq7qiSTi1fYyD15+5V4rO81xpGr0Da0AkwviuagTx9N0bLFfBDqYsKLMQWt2tTFPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=si0lSo1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="si0lSo1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58134C32786;
	Thu, 15 Aug 2024 13:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728783;
	bh=a0F57Vg5+IHlJ+yzD9/OPF6mCVsWuoupCVDsskvQzV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=si0lSo1ETbo3NdvBLmMaf/x2pH1fhiQrh0BGWSNVWZCCQiVabYhnRh6jBNjmj6Yo7
	 vYv8uhvBbP4bSTSvD8ObzlFuEvlNELeYcOihcsTS7OBiT/1LowPtS23Eru9gnih7qH
	 047eK1/YS472uy2jT7JnazwRiuMJRdfB3Jpo9gq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/196] PCI: rockchip: Make ep-gpios DT property optional
Date: Thu, 15 Aug 2024 15:23:44 +0200
Message-ID: <20240815131856.173934972@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 58adbfb3ebec460e8b58875c682bafd866808e80 ]

The Rockchip PCIe controller DT binding clearly states that 'ep-gpios' is
an optional property. And indeed there are boards that don't require it.

Make the driver follow the binding by using devm_gpiod_get_optional()
instead of devm_gpiod_get().

[bhelgaas: tidy whitespace]
Link: https://lore.kernel.org/r/20210121162321.4538-2-wens@kernel.org
Fixes: e77f847df54c ("PCI: rockchip: Add Rockchip PCIe controller support")
Fixes: 956cd99b35a8 ("PCI: rockchip: Separate common code from RC driver")
Fixes: 964bac9455be ("PCI: rockchip: Split out rockchip_pcie_parse_dt() to parse DT")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 840b7a5edf88 ("PCI: rockchip: Use GPIOD_OUT_LOW flag while requesting ep_gpio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip.c b/drivers/pci/controller/pcie-rockchip.c
index b047437605cb2..c6d2f00acf890 100644
--- a/drivers/pci/controller/pcie-rockchip.c
+++ b/drivers/pci/controller/pcie-rockchip.c
@@ -84,7 +84,7 @@ int rockchip_pcie_parse_dt(struct rockchip_pcie *rockchip)
 	}
 
 	rockchip->mgmt_sticky_rst = devm_reset_control_get_exclusive(dev,
-								     "mgmt-sticky");
+								"mgmt-sticky");
 	if (IS_ERR(rockchip->mgmt_sticky_rst)) {
 		if (PTR_ERR(rockchip->mgmt_sticky_rst) != -EPROBE_DEFER)
 			dev_err(dev, "missing mgmt-sticky reset property in node\n");
@@ -120,11 +120,11 @@ int rockchip_pcie_parse_dt(struct rockchip_pcie *rockchip)
 	}
 
 	if (rockchip->is_rc) {
-		rockchip->ep_gpio = devm_gpiod_get(dev, "ep", GPIOD_OUT_HIGH);
-		if (IS_ERR(rockchip->ep_gpio)) {
-			dev_err(dev, "missing ep-gpios property in node\n");
-			return PTR_ERR(rockchip->ep_gpio);
-		}
+		rockchip->ep_gpio = devm_gpiod_get_optional(dev, "ep",
+							    GPIOD_OUT_HIGH);
+		if (IS_ERR(rockchip->ep_gpio))
+			return dev_err_probe(dev, PTR_ERR(rockchip->ep_gpio),
+					     "failed to get ep GPIO\n");
 	}
 
 	rockchip->aclk_pcie = devm_clk_get(dev, "aclk");
-- 
2.43.0



