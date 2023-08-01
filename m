Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFE51F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4E7C433C9;
	Tue,  1 Aug 2023 09:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882930;
	bh=n6AVU3VCKsW5BSDhsrLWOUcN/75bYvWX08d7K3BBUTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFKSL/DLKwZFokRe+Qbmdr1WxrXRrR33QoO3kXSQ/0cvnsmSdenkCQC1jnCNHmFG3
	 XUszXt01+G8hdP0bFyZDmNIgFo4ionEBQJjEDxQ9+UMGry/LMEZhKKLY76JqA2Sp7n
	 fddiqaphi+9ondHzEEzUJGN2JqiTezsnvzBDKU7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Ranquet <granquet@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 053/239] phy: mediatek: hdmi: mt8195: fix prediv bad upper limit test
Date: Tue,  1 Aug 2023 11:18:37 +0200
Message-ID: <20230801091927.446680865@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guillaume Ranquet <granquet@baylibre.com>

[ Upstream commit 95bd315f0a5ed7d7afe771776272c5b3cdb29bc8 ]

The pll prediv calculus searchs for the smallest prediv that gets
the ns_hdmipll_ck in the range of 5 GHz to 12 GHz.

A typo in the upper bound test was testing for 5Ghz to 1Ghz

Fixes: 45810d486bb44 ("phy: mediatek: add support for phy-mtk-hdmi-mt8195")
Signed-off-by: Guillaume Ranquet <granquet@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230529-hdmi_phy_fix-v1-1-bf65f53af533@baylibre.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c b/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
index 8aa7251de4a96..bbfe11d6a69d7 100644
--- a/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
+++ b/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
@@ -253,7 +253,7 @@ static int mtk_hdmi_pll_calc(struct mtk_hdmi_phy *hdmi_phy, struct clk_hw *hw,
 	for (i = 0; i < ARRAY_SIZE(txpredivs); i++) {
 		ns_hdmipll_ck = 5 * tmds_clk * txposdiv * txpredivs[i];
 		if (ns_hdmipll_ck >= 5 * GIGA &&
-		    ns_hdmipll_ck <= 1 * GIGA)
+		    ns_hdmipll_ck <= 12 * GIGA)
 			break;
 	}
 	if (i == (ARRAY_SIZE(txpredivs) - 1) &&
-- 
2.39.2



