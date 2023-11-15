Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B57381C6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2az6ucXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6A3C433C8;
	Wed, 15 Nov 2023 19:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078130;
	bh=bIRpZr6oWT96bhp7FeJkRbgm+5Oex4SLkNzCbNvZd1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2az6ucXotKfn0vc654Tw6NUABipDwSAb6EM0I7Mbr+riwx/hEI/k9+H9Fc18I4R6J
	 d62rn3egilDGN22Jt1wCRZzY7IqMUa8efQhD7hFcImgk+bq9N0VSMZZ0otaJZNEWZF
	 6S5XbzXaUB0iCek0PDrkSQyt4NAKquDT5XTi9O28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/379] drm/bridge: tc358768: remove unused variable
Date: Wed, 15 Nov 2023 14:23:23 -0500
Message-ID: <20231115192652.688457413@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit e4a5e4442a8065c6959e045c061de801d545226d ]

Remove the unused phy_delay_nsk variable, before it was wrongly used
to compute some register value, the fixed computation is no longer using
it and therefore can be removed.

Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-10-francesco@dolcini.it
Stable-dep-of: f1dabbe64506 ("drm/bridge: tc358768: Fix tc358768_ns_to_cnt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index bdeda705b67ca..70fd560ed394e 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -647,7 +647,7 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 	u32 val, val2, lptxcnt, hact, data_type;
 	s32 raw_val;
 	const struct drm_display_mode *mode;
-	u32 dsibclk_nsk, dsiclk_nsk, ui_nsk, phy_delay_nsk;
+	u32 dsibclk_nsk, dsiclk_nsk, ui_nsk;
 	u32 dsiclk, dsibclk, video_start;
 	const u32 internal_delay = 40;
 	int ret, i;
@@ -731,11 +731,9 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 				  dsibclk);
 	dsiclk_nsk = (u32)div_u64((u64)1000000000 * TC358768_PRECISION, dsiclk);
 	ui_nsk = dsiclk_nsk / 2;
-	phy_delay_nsk = dsibclk_nsk + 2 * dsiclk_nsk;
 	dev_dbg(priv->dev, "dsiclk_nsk: %u\n", dsiclk_nsk);
 	dev_dbg(priv->dev, "ui_nsk: %u\n", ui_nsk);
 	dev_dbg(priv->dev, "dsibclk_nsk: %u\n", dsibclk_nsk);
-	dev_dbg(priv->dev, "phy_delay_nsk: %u\n", phy_delay_nsk);
 
 	/* LP11 > 100us for D-PHY Rx Init */
 	val = tc358768_ns_to_cnt(100 * 1000, dsibclk_nsk) - 1;
-- 
2.42.0



