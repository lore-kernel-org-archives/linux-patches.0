Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030138;
	b=QXuxjqavNj8QGZA7syd/aL9Ewi90Qp8s170rChHIYTHtbYtujHMbAXxJhLqgrYFd5T5o
	 qeaVcW0qZ0Ysp0XlVYMemltWLKfStksNwTereeYRN0d/Uuy/Zu25/DhaMVF4CaGlYu1F1
	 ZyUcWn23yYFIPGGXFxFz5BAY6Dua/f9GlJ4yh+ZQHvUy1xYAlqiYdg58sz4K7UqfioOD+
	 eD9oEVcvMXcwSnUKgwRh0544BAqzEnjy8i+atCvstVZlJ30QaYPjHDHmesC+oiicJEjkp
	 L9MpIpksIqwlRly1FFnxMPQDCOyRpv9THWlQmS9jbEb8MSBbQEQ6hvVz0adCqNCHO2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2yJc4N6GOn0joh8LIZYXZA0XfmtRIfSZL0/mrRK3Nik=;
	b=oO/JTzJEc861KJBIuuomM89qk1Cekc/GLDeRnjuRsOgrjpZ65N8UHBXpGWAtfKa9g6ja
	 069SxJ49WjaMrFbmK/XE3syxgyKwVC76sz08w1DqwCgAJjI2VvODVMM1WU+GGQkZCKWZP
	 NpX32lSX1i5BEBP6aHFVQSJQgDdskXFgMmilVWRWIzdqznu7Vl1hvdis3nnRpetKsIEjZ
	 lsBZdbf3xHqeDYArcBnW5EgU12Oy6eOEOYqMqdVk+fL5Sorj9ZfbWR1HlFdNBDlAN7pzb
	 osDW9gxVDraOhdQP5575MaVUodNxbd2htchJIdx9Hhvxs61sGHhW9JeI5EplNiWqYHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDUqiYg0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D5860760A4;
	Wed, 18 Nov 2026 19:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDUqiYg0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDAF1F000C7;
	Wed, 18 Nov 2026 19:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030137;
	bh=2yJc4N6GOn0joh8LIZYXZA0XfmtRIfSZL0/mrRK3Nik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDUqiYg0cbsRZ9Ho/05S6dzjDvEXYJ6nY9hJbvb0IZfVwRJPAkNWakifd5FnpUQ3K
	 CNG2Ug5d9aDVkvlgl3jpL+1e9xqG9C0Hunqut/lx1U9oLhjN2DpZSyp6QIN85KYNg+
	 cE9Q2b79xHutvbPz9Org3EBolhqyGEY3f8q5WFc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0596/1756] ASoC: mediatek: mt8183: Fix wrong clock cleanup on clk_set_parent() failure
Date: Wed, 18 Nov 2026 15:45:23 +0100
Message-ID: <20261118150032.705591170@linuxfoundation.org>
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

[ Upstream commit 7f05596bd4047e4623eeb1f3c6921d6f71481c3b ]

In mt8183_afe_enable_clock(), when clk_set_parent() fails, the current
error path incorrectly cleans up the previously enabled clock instead of
the clock used by clk_set_parent().

Fix the error path to clean up the correct clock when clk_set_parent()
fails.

Fixes: a94aec035a12 ("ASoC: mediatek: mt8183: add platform driver")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903045203.175337-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8183/mt8183-afe-clk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-afe-clk.c b/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
index cc4f8f4d3dab9..6ab0734ad1365 100644
--- a/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
+++ b/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
@@ -137,7 +137,7 @@ int mt8183_afe_enable_clock(struct mtk_base_afe *afe)
 		dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIO],
 			aud_clks[CLK_CLK26M], ret);
-		goto CLK_MUX_AUDIO_ERR;
+		goto CLK_MUX_AUDIO_INTBUS_ERR;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_MUX_AUDIOINTBUS]);
@@ -153,7 +153,7 @@ int mt8183_afe_enable_clock(struct mtk_base_afe *afe)
 		dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIOINTBUS],
 			aud_clks[CLK_TOP_SYSPLL_D2_D4], ret);
-		goto CLK_MUX_AUDIO_INTBUS_ERR;
+		goto CLK_AFE_ERR;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_AFE]);
-- 
2.53.0



