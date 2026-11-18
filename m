Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024497;
	b=UZcK/zE0T042uxZUJXLRaHmj6+bG71tlac1b/L+HOvX6A3A27+3NcP7Zanmahi3BSyTP
	 Fbn4ziSLBSsUyWsIwRL/MygRWjbbSNr38eZa6afPCn4yVfwDMclaWYrPO/cHl/bcj+T3a
	 SlV9bOEhzOs3DLijsRqiqj8OX2jWQipdq4KJF5eXX9Qa4e01Ouys7f9C9fibdigh0D2u3
	 Ug0ZP04+v19ji4DeaKpvRgZTDsW1HTuyhnT0AIPuijy5T4NABA8Qeac5ZIZhyETnMuYj3
	 8ILkarV/TgrHoaCna3aecQGoKe91l/lrREtXwa6TM4K0w7BHkIlsB+04OZ3hkH1yVjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QJt61AH+vWFJrmGfZy0jjHb9v61pQoxdydwuwOJTHhg=;
	b=ceHQtBgrLWEWxo+xcJjPtZzZ67XOeu0HAC8XCxu53CsZLjoz8SNoAYOwJizMp9s4GT0b
	 B0Oz1LT6nVnkvIiJcKGwE4gX5BZa9Zx0bYWHc2UX3jI9a5zWAGz/lpm/gp9BGXdqyNWCB
	 TGKy4+3pyqhXK+ZkcWzGnn60o19IG/wbqplXC48AJOiQnR7KKKAO00xcmPgCuOIMh2tT9
	 v3P3328eIcN7waTeO5+2suHYCaVlj56OD5bC5Jar/ZuKRzculFMVJOteJZvwWXCxYhYld
	 pKxMiFnTv+GhFRsmd0C4PTboWgD5/hVKVSQkIOoFT9RCRnE+ZwVzCwvvFZ7vly8eRNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=owG4FA21;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FBC606A32A;
	Wed, 18 Nov 2026 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=owG4FA21
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC911F000C4;
	Wed, 18 Nov 2026 17:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024497;
	bh=QJt61AH+vWFJrmGfZy0jjHb9v61pQoxdydwuwOJTHhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owG4FA21UHIz0OL8C6eTRcJLcbMGcTMAoRGO8iH55oAwkNm4fWNbclvPRr1ZzEvbI
	 najGfkTGClasXQ6VCf2epxLtGpZwuzt4nCQc36g1+QjrD847Q1RYsApqaZX4WLpv5P
	 T5OQznkbf22EReQahpa3m9NZcfjrKW6Hia8vWs3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0747/2151] ASoC: mediatek: mt8183: Fix wrong clock cleanup on clk_set_parent() failure
Date: Wed, 18 Nov 2026 15:41:22 +0100
Message-ID: <20261118150149.238081199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



