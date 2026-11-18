Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041818;
	b=A8x8TrgDP5c/UV3lxruQfvV288imBxuSwy5qMMx9KwX4fOVVJAhvZ8zsTrzVT3Wvd76s
	 1LC2B1fu8R/6p3ftDMBcFTt3eYsqPfnlgBYWJVn0xaZzGpDY89XdJiVTqA8U8/hIUi6/z
	 BbNkcAYE95RkClIdw1B6zQy0gXNdpGO8oe1JSQcFjxQLMrhGUjccY63vTNofUKUBIc2CL
	 IY3v00e1TdUvA8acTj1S4spwJCX1EoPJslw4Khf9RfmL+o4slKtBOp82P54xJotuf50F7
	 Q8LCvZdnBehQG+8LDgnvAUjYRroiH1+pP+mmr//RqD1Dc2uxU4SNAX2Ogzl2MyCDR/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bNbYRyOCwLNnRuoWIe6fPYdkghSzIIH1Oyj/hO1pmI4=;
	b=PodagyHUPk4SV/WieAr0i3pJvP+HHI2tYlY6ls+tT2txzhR8zwlTS/jnD8wuf5NUIONR
	 EF9DWTF4Pnp4FraeTaGMl2f8NBBVnLKNwzUaXR5j+R+wqlDRi7RUIFqycOHeCmNq+4WZs
	 usr2RkUVKypT2NEZDnoYyms/yKjmw2t8fKc6ww2eYb+1cRrEr4qjhpD+wX16jrotUUeKK
	 9GYNCMTupAa3abryhbMPRktJJ5I9W9Ssl2LVqjzVP0j2zf/Ejbh/wci7fFUQUtv2pa9jA
	 hLnLybuBXYHo2ELo1kLyU90Hdze1OBK1Z1VS5njEMgF1dtARjnIZmSpA9MOcJH2Y9LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9iBd553;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9873C606A320;
	Wed, 18 Nov 2026 22:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9iBd553
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76F11F000C6;
	Wed, 18 Nov 2026 22:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041818;
	bh=bNbYRyOCwLNnRuoWIe6fPYdkghSzIIH1Oyj/hO1pmI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9iBd553ZcgJyU+fboY/whm9MfrPbIjqS2KJYqNhG3XUUOJpoiW4Wau5vd3Ig5NLP
	 7GNwzJQxHZv4D6mIkGdyuVmyMRofzAWPBtGWFa8HapkEy38fuPanRpQDcFvFXVSHRZ
	 hiyjV2ldUx7Enr1zFbrhO9Ogqwj2zGjpnr5DHKfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2950/3318] ASoC: mediatek: mt8195: Fix tuner clock error handling
Date: Wed, 18 Nov 2026 15:59:32 +0100
Message-ID: <20261118150448.821739599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 8e5a2eabb0d7cbd6db0b94f7f30e1ca2c0a8994f ]

Check and propagate errors from mt8195_afe_enable_clk(). If enabling
the tuner clock fails, disable the previously enabled APLL clock.

Fixes: ff5a90173d98 ("ASoC: mediatek: mt8195: enable apll tuner")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 24 +++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index f35318ae07392..5d4ba88ceaef1 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -241,21 +241,35 @@ static int mt8195_afe_enable_tuner_clk(struct mtk_base_afe *afe,
 				       unsigned int id)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
+	int ret;
 
 	switch (id) {
 	case MT8195_AUD_PLL1:
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL1_TUNER]);
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
+		if (ret)
+			return ret;
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL1_TUNER]);
+		if (ret) {
+			mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
+			return ret;
+		}
 		break;
 	case MT8195_AUD_PLL2:
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2_TUNER]);
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
+		if (ret)
+			return ret;
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2_TUNER]);
+		if (ret) {
+			mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
+			return ret;
+		}
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mt8195_afe_disable_tuner_clk(struct mtk_base_afe *afe,
-- 
2.53.0



