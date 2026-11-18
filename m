Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017441;
	b=INjECw9bArr2x2S25yvixDlo110imbKNUMVd2DuFaO5Hfqfo2h+AomGX7XloWzqGsX2e
	 WUJW4syMg2CnrnORnO2PQRJJCQ9IfW0hQCaRXecdvH9CeIuLzztEBXFJa9/YpD2zfk6m7
	 rNJUdA/2dVlLnIv0JrmF9smEA6irytNlVgz1o4IEmP5Hk4NEm/qznDJCTRXYRphSnN0uH
	 TVKU4H83ge4UtQ93AQ5ETZ3XlI3nhiUleICqNHd9nw8H8swR2jFKsjMAWt4LIrNnfE4JI
	 XmBG+AoaY1mPQYZidEq9uKKizM+5gPXGpgNwfe/ABwnm0x2XzvSpF+l3FrwSl8kCr8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4r1iWbF6YJV17tw5D1GXRpKHh9duMtOuaBcb8qBZszY=;
	b=etji2QLyEckqrmuqRPua8pS2Qb1swfIiOJp7gLrI//8guhjgzt1CFDT61tFX4IBWNMCV
	 sEUD9VUeWR7xPjYyClgJAz3mQGzAq8uyIhw9mz0FHpsn5WxWFIwNpa+iCks280uKUK6Gg
	 SDKaPN2A23DD1AUXms/lvkZzf6Ms6M75JfgVh2sD75ywLSfBK9UP+vwZ4UYMnVjmYvDrr
	 I4LdTgg8sqfSXtmS/MwIRFz0jkyTAv5usZic9D7gmcsYqRTwT1AdxikPZaJDq6uQF2luM
	 cJLZqI3JL/KHeS64g+gRysVGNiokRq2o0Fy3ZkvIV6JEuTAR7QdqtZgPHdw1Ouhf+gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPqobHuR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275BF606A31C;
	Wed, 18 Nov 2026 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPqobHuR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F41B1F000C4;
	Wed, 18 Nov 2026 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017440;
	bh=4r1iWbF6YJV17tw5D1GXRpKHh9duMtOuaBcb8qBZszY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPqobHuR+GhpSPiZxBb0g0TXev8XEm2ZkPfy8fd7FzjB/+Q0xkfzuUZPvjAwgK48/
	 8JXlpd+EN2u9HTwO8XO2e6C0b7y0kMAEYowSHAOhIHRO+9atQqgn3icTksMX6YHF7Q
	 +rPX35RmpX0cA30CfKvGTlsniAeFSw/bnwTKy9Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0868/2651] ASoC: mediatek: mt8183: Fix wrong clock cleanup on clk_set_parent() failure
Date: Wed, 18 Nov 2026 15:35:08 +0100
Message-ID: <20261118150319.105399425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



