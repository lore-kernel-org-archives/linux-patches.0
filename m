Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98640BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF89C433D2;
	Tue,  7 Mar 2023 17:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209973;
	bh=j3SsXPfit0k+7teO/+qymtnavDrv+NJw0Di82qu0viU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+QIjbiuR4HnYM+3k6d5dvAAcO6vS4oF9A3IKwNxEOPZ0AlQFlj+Xn+CECUsSdnNN
	 m3CVRFlN3Kr8SM4qBzaZfJtvFurp12xcrwOazk/VOuokeJuvSkFT2Ye0XJBOrB/8YK
	 Y9mmx35+gd668oXdSBfmiFfG4xvFjT7BVSPB4TTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0360/1001] drm/bridge: tc358767: Set default CLRSIPO count
Date: Tue,  7 Mar 2023 17:52:12 +0100
Message-Id: <20230307170037.047713793@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 01338bb82fed40a6a234c2b36a92367c8671adf0 ]

The current CLRSIPO count is still marginal and does not work with high
DSI clock rates in burst mode. Increase it further to allow the DSI link
to work at up to 1Gbps lane speed. This returns the counts to defaults
as provided by datasheet.

Fixes: ea6490b02240b ("drm/bridge: tc358767: increase CLRSIPO count")
Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20221016003556.406441-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 2a58eb271f701..b9b681086fc49 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1264,10 +1264,10 @@ static int tc_dsi_rx_enable(struct tc_data *tc)
 	u32 value;
 	int ret;
 
-	regmap_write(tc->regmap, PPI_D0S_CLRSIPOCOUNT, 5);
-	regmap_write(tc->regmap, PPI_D1S_CLRSIPOCOUNT, 5);
-	regmap_write(tc->regmap, PPI_D2S_CLRSIPOCOUNT, 5);
-	regmap_write(tc->regmap, PPI_D3S_CLRSIPOCOUNT, 5);
+	regmap_write(tc->regmap, PPI_D0S_CLRSIPOCOUNT, 25);
+	regmap_write(tc->regmap, PPI_D1S_CLRSIPOCOUNT, 25);
+	regmap_write(tc->regmap, PPI_D2S_CLRSIPOCOUNT, 25);
+	regmap_write(tc->regmap, PPI_D3S_CLRSIPOCOUNT, 25);
 	regmap_write(tc->regmap, PPI_D0S_ATMR, 0);
 	regmap_write(tc->regmap, PPI_D1S_ATMR, 0);
 	regmap_write(tc->regmap, PPI_TX_RX_TA, TTA_GET | TTA_SURE);
-- 
2.39.2



