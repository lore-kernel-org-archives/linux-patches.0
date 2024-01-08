Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAACA6D6DC;
	Mon,  8 Jan 2024 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAXnKKft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FC9C433C7;
	Mon,  8 Jan 2024 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726920;
	bh=gKjqcJp4ny6kYiKK7CJaUcBQ66OAylJPL0rWTv7Dxwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAXnKKftFrZK3D8RtjlCfjviffEO7psRX9TC60jmOobVk1qgeWjLD1tDzLt7PgkiI
	 tY06iA97oJIQUPeDxSNSr2AX/Rf+K+VWiDYNc0N/gMb4yWsvPPGy8cSJzcMIpRA04K
	 yX0nFnJBXZv6759lIhhcqRmFESevR1jagcMOwjlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/124] phy: mediatek: mipi: mt8183: fix minimal supported frequency
Date: Mon,  8 Jan 2024 16:08:37 +0100
Message-ID: <20240108150607.160650347@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 06f76e464ac81c6915430b7155769ea4ef16efe4 ]

The lowest supported clock frequency of the PHY is 125MHz (see also
mtk_mipi_tx_pll_enable()), but the clamping in .round_rate() has the
wrong minimal value, which will make the .enable() op return -EINVAL on
low frequencies. Fix the minimal clamping value.

Fixes: efda51a58b4a ("drm/mediatek: add mipi_tx driver for mt8183")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20231123110202.2025585-1-mwalle@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-mipi-dsi-mt8183.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/mediatek/phy-mtk-mipi-dsi-mt8183.c b/drivers/phy/mediatek/phy-mtk-mipi-dsi-mt8183.c
index f021ec5a70e5c..553725e1269c9 100644
--- a/drivers/phy/mediatek/phy-mtk-mipi-dsi-mt8183.c
+++ b/drivers/phy/mediatek/phy-mtk-mipi-dsi-mt8183.c
@@ -100,7 +100,7 @@ static void mtk_mipi_tx_pll_disable(struct clk_hw *hw)
 static long mtk_mipi_tx_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 				       unsigned long *prate)
 {
-	return clamp_val(rate, 50000000, 1600000000);
+	return clamp_val(rate, 125000000, 1600000000);
 }
 
 static const struct clk_ops mtk_mipi_tx_pll_ops = {
-- 
2.43.0



