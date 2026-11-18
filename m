Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030079;
	b=Z5XE+2jx3B2JgVGYqvks/3SSdis02ra0HDvpxULp+CINjN4RA6o0V/qCyGwMmiCfTpHK
	 Rt4zM/+tcM0mp87pBloXzyxh0NxHEfC0uEPwHv3+HhXpqN2dQTlYuZjjEimh810hGMDrY
	 LogXtZ6ECmV+f3xeu8MMObpq3UhRkm+CWOk/cKP1uAH5lD3RBC6eMgTR2DjJ3hIiddaI7
	 hNJ3WnIC8KHndQ9j7e05ptk2fic53ZvkuFFWi8NoMNUofc2jNVrJk3815UqeB9A98s+in
	 n+M7GsZG5ztNMlYs8SBsrhaEnPUvIykVuXPVC1dnc412AQL1nFa5PLnB8NItTThM7dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QP2c7qZNT91u4FVDBrjEHfljRj9F93JgNrR27W1IHEs=;
	b=4mDHc4fxoEa0AmsHZQ7tsYxaV5fxwGg20iy1HhE07plIJLU9HkItedmiQkykR8pvDNlu
	 EzcGKCmlo0FIrXRVi3r3OEv/Hn6WAAdX40kDqUPeDpk6lwGqLaEcnbEUYw5bJ+LOK6Peb
	 XSJT8lyuMiIzFTYS7XL3KCBMNhqmQgSw0PZbp1ItEi4OwHqWTEOPXcNsUowcxQPNnDcmg
	 0ZjB1CV+3AQHjrpMEKAj1RXRO7uQiaWYkshkufS7Bom4zSFB2ikvoh+vUPBZ9SYEAF/2B
	 NbdyyQoxS/yfKxsSFi4ISrGwhqFEWaRf/INSqjv1B/IRI0YE6AWfXAtUeTwUrnOJj1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vzr6vPXh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4BF606C713;
	Wed, 18 Nov 2026 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vzr6vPXh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDED1F000CA;
	Wed, 18 Nov 2026 19:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030078;
	bh=QP2c7qZNT91u4FVDBrjEHfljRj9F93JgNrR27W1IHEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vzr6vPXhSi2I+Z6NhM7hXtJxLcbvffgsJNYaaJ7KlED42+GlnQ8Fg5ZnO+hRUg4eP
	 Y5DxMxw2jh9dDTc9TLqKxf1uPPWfzwdV8Xj8f3QRa2IF9N0i7l5kyakXoLsxISMiA5
	 O+xpaQ1NTBXbnPeWJQ8ghCJ/HbH9xVSr+T2SFrtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0577/1756] ASoC: mediatek: mt8188: mt8188-afe-clk: Handle tuner clock enable errors
Date: Wed, 18 Nov 2026 15:45:04 +0100
Message-ID: <20261118150032.011456147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit a2c3ee3349a7da91e563b9a21a355a28fa754bc7 ]

Clock enable errors are currently ignored when enabling the APLL
and tuner clocks.
Check the return values and roll back the APLL clock if the tuner
clock fails to enable.

Fixes: f6b026479b13 ("ASoC: mediatek: mt8188: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260907120310.135693-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-clk.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
index 7f411b8577823..b41069b752a94 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
@@ -260,15 +260,28 @@ static int mt8188_afe_enable_tuner_clk(struct mtk_base_afe *afe,
 				       unsigned int id)
 {
 	struct mt8188_afe_private *afe_priv = afe->platform_priv;
+	int ret;
 
 	switch (id) {
 	case MT8188_AUD_PLL1:
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL]);
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL1_TUNER]);
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL]);
+		if (ret)
+			return ret;
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL1_TUNER]);
+		if (ret) {
+			mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL]);
+			return ret;
+		}
 		break;
 	case MT8188_AUD_PLL2:
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2]);
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2_TUNER]);
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2]);
+		if (ret)
+			return ret;
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2_TUNER]);
+		if (ret) {
+			mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2]);
+			return ret;
+		}
 		break;
 	default:
 		return -EINVAL;
-- 
2.53.0



