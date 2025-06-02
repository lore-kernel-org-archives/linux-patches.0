Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBC7223DCD;
	Mon,  2 Jun 2025 14:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872938; cv=none; b=mo4B3gBmt62po4spLt6r1m9E2H+K93QmXZRyGTpZDwca7c7HWKyFRWdhffiuBT0K9VPCdfHcacTGCwwp0mcXL3WK3UQFZuWiHWJoXak/ZQKKlJhiBAZ9SigQAlFO0cZniQfHhMlKUfoA6B4joIZd5Ky1pRZEHk9jycaZWEbDv/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872938; c=relaxed/simple;
	bh=9Gn6K/4/YaFpK3abtoa3PMvOlZ7KKL1XU/9iDlBw2YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RD1lpFadje7hDGOzYwIczF3X2+dg/ywixIGduI1nfl0G8iNfae0qFU7Xmhg+sXSWRNen+vHQ8yBXJo3dyirK8xXKNj37hn1Uf/szwQkQJ/BQz1lx9vddjSqSpi0vuMYRfj55d7F/4JdDQxRE1dE/aAF0xnuEIec5HS4EUDvT0z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgivJZMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgivJZMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B39C4CEEB;
	Mon,  2 Jun 2025 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872938;
	bh=9Gn6K/4/YaFpK3abtoa3PMvOlZ7KKL1XU/9iDlBw2YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgivJZMfW2k2+8md+4raG/9rvH00pDdDKhEoHRl0jcC1YPMhqk8jhOSoSNiRsCc4E
	 KCXS1gu/GsYkd+WBpilh5FSnZaSUTQiod8uSDZ5Ocf3EM0Zac8YWDHLJ7arL8wRBe2
	 qb0t6LHrDdJXNSOddv84mFZTX6+VqR1wliIn87+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Algea Cao <algea.cao@rock-chips.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 44/55] phy: phy-rockchip-samsung-hdptx: Fix PHY PLL output 50.25MHz error
Date: Mon,  2 Jun 2025 15:48:01 +0200
Message-ID: <20250602134240.016984871@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Algea Cao <algea.cao@rock-chips.com>

[ Upstream commit f9475055b11c0c70979bd1667a76b2ebae638eb7 ]

When using HDMI PLL frequency division coefficient at 50.25MHz
that is calculated by rk_hdptx_phy_clk_pll_calc(), it fails to
get PHY LANE lock. Although the calculated values are within the
allowable range of PHY PLL configuration.

In order to fix the PHY LANE lock error and provide the expected
50.25MHz output, manually compute the required PHY PLL frequency
division coefficient and add it to ropll_tmds_cfg configuration
table.

Signed-off-by: Algea Cao <algea.cao@rock-chips.com>
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250427095124.3354439-1-algea.cao@rock-chips.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index dc6e01dff5c74..9b99fdd43f5f5 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -328,6 +328,8 @@ static const struct ropll_config ropll_tmds_cfg[] = {
 	  1, 1, 0, 0x20, 0x0c, 1, 0x0e, 0, 0, },
 	{ 650000, 162, 162, 1, 1, 11, 1, 1, 1, 1, 1, 1, 1, 54, 0, 16, 4, 1,
 	  1, 1, 0, 0x20, 0x0c, 1, 0x0e, 0, 0, },
+	{ 502500, 84, 84, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 11, 1, 4, 5,
+	  4, 11, 1, 0, 0x20, 0x0c, 1, 0x0e, 0, 0, },
 	{ 337500, 0x70, 0x70, 1, 1, 0xf, 1, 1, 1, 1, 1, 1, 1, 0x2, 0, 0x01, 5,
 	  1, 1, 1, 0, 0x20, 0x0c, 1, 0x0e, 0, 0, },
 	{ 400000, 100, 100, 1, 1, 11, 1, 1, 0, 1, 0, 1, 1, 0x9, 0, 0x05, 0,
-- 
2.39.5



