Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8380263C;
	Thu, 15 Aug 2024 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731536; cv=none; b=CU4iGJGNktMLOXmPzaJhWOa9K/xOKCvw/NLU/LrOmPhGnGgFtLiAloyh5eEawzdFYtCwmiZsjIPbxzuYZDC3b2rQEg2jmDrXtWwDjKb60OYMD361I3yfWYqGW0QhpquSD+IdeZiuD7SNm2jzCvIQPT4ySjFLjuqOHiVdEmVd/dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731536; c=relaxed/simple;
	bh=mOpb079qLSR0GV5pbh2W5H9o85wxiudEvtTR9KhUu2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2OXXwLMClX7xVzfQ+GCnX8ufSDHLqUlvel07+jiQsumTLjxkPGu5b9kRRRp1HYnp9kWBq6k6GNvIqmfVFrHqAYAhgb1Z5ILAqRDS09YKuDYjYgL8iFo1n4odc8hgYO9ng1sqfhJ516J3UoVzuamxX9SUvStNtAoSatRRh+rGfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DkcGHE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DkcGHE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D243EC32786;
	Thu, 15 Aug 2024 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731536;
	bh=mOpb079qLSR0GV5pbh2W5H9o85wxiudEvtTR9KhUu2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DkcGHE93PBxl/gmQEyR46J3Xc5VUf2MKHH2IWOKapc33F7BtmYlLvjmcG5M9Rj4Y
	 60ZlMYnY3GQ1xXuiFoYPIkvZEIynOnpH6maFB4oFg6dR3v8zDlUhJFOeouxJ9G8a7C
	 bjdHUV12hS+Bcy+eeQ4kAa2yOhRsWeWhFhbuTUfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/259] PCI: rockchip: Make ep-gpios DT property optional
Date: Thu, 15 Aug 2024 15:24:52 +0200
Message-ID: <20240815131908.925181448@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



