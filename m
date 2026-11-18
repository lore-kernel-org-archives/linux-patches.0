Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048638;
	b=N/xVy6hDmwHbvQHGtPs4bIRvmj19jG9UhAJS1uSdgbzsGKsyXYQFGjlr6rU8rCi0k8cm
	 W19uQn6mqUIW+tZMrwJtdEHz1zMGkxzxVLg5oyJF+cXkjbof1d1TNG5Zlg98WX+LrrUfF
	 lKZvkXM3ba4d27TV/tSz1mvjjjLSiiW9KMNmt8bUlz/UgGiXzcVg8H1ySLAyZqSXU3xK+
	 dqyV7t1igujuuKuxt+FWaXzpsBo51+mtYDmmNNn/Ug7Itr3r8yF6e72fIbBkSNiSCCcnf
	 QS2yPCGtd198ha33tPmRt2P1dQHp7W/lfgqy98JQBObb6Ol+Jl+tPTIzcbL6/8TQkig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eZ/Bxl3sULdJShvXlQEFufUc5ZG9wghfwjVuA8P2Xe4=;
	b=finvy0Lb1h/sBLCXrdXdxnpnLZZLg7WoShHN+CVS2cAHczc73g0WxY1butBJeMermoqm
	 tRtjM+EgZk5kRDK/MWqYmsukVSJ+a55CvjjcMazmvMtbeqC+ixDdim8nmEArGoMcrmugL
	 tOrOjn9UH1ixCcwyRUGCbYEUIT1CQ60oxkJPuvN1Q2RXrddzGxpgRNcx5cJ/0uwIQcFff
	 9uDycwabGov4ZQgKquxXfG+lO3lxIZLkLUk55pBShOAwaD4JbucTyjoGmEa47qKjraaN3
	 ZrJ94YXbI54d5NuJVYO3RsRNYBmpY8D6NLxxW9kjwjeYu4ixXEyrPCWwITFckjeQrHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aE7lPeSK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE04C606A325;
	Thu, 19 Nov 2026 00:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aE7lPeSK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001F81F000C7;
	Thu, 19 Nov 2026 00:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048638;
	bh=eZ/Bxl3sULdJShvXlQEFufUc5ZG9wghfwjVuA8P2Xe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aE7lPeSKNuPTIPtLrh6w8//md6bx2HhPRkqmIPHwqZ7ZG8eDQBz/x+LnoTwmOHFnb
	 bs7kWqm1YWXxqMmxMkXYsgTHnUW2nEA73CMCyCHang9ww40mk0dNJEv+UuBE24fAHa
	 +HJJUHO1nDj2s5X8WbvxiRMbrcBhFFEtHRa8SMt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2065/2857] ASoC: mediatek: mt8183: Fix wrong clock cleanup on clk_set_parent() failure
Date: Wed, 18 Nov 2026 15:51:39 +0100
Message-ID: <20261118150315.768455027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



