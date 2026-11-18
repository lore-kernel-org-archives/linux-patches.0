Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060888;
	b=ZV1vvRNUSsNVV+eNpe+6MihU5QNEDotm22yn+ooFMn5KHKxbn/IpYp1NklXPyhGEyUnE
	 QVYbjU48n39lLggcg+XDT3o5cedXTyXLLl61t6mf8+W0uxpjkWP1pieIbUxNmJEQVbE8p
	 ZgXJPPbaAatEpR4ieQxaTSNLqyF5jYLpdkIgkPuVggWT6U/JMO/MFOZ7Gf0RpCz2kUPk7
	 XKJ2dYoVQcxvhkS8af0B1haNOvMiOx2VLqgEj8vmXF+DV+JFL1uFnGduwHUfY5CazVauf
	 vqP8XNQ2x0AyaSGWQIX7g+pgKUPBTdl0WHOELbEFuGkfrX0IyNdCia/AuARilhdmO/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y1Qo0pYu0ynJhIq00K520GD9SPv2zdqV8B6zm7b+/Yc=;
	b=v3SvlhL1oVHWw3f0BaZ9zAI1p4hwBelW1kOmhffykaylkOSULa3CsBDTnPu3wwrl4XGJ
	 v+DzcSBbNbch1g/ClxQVFMzBWquJxdqmY3XVu3cUXinasuu/XLcEZ3xpV8JhMTgf/134I
	 LILfosl052o1lM08f2Fglbs942x1Mp/mV4MmD3MkKQoXDB2e8h+2mEQRqOQO7rTAygoBv
	 GWWSnVq5QpLku2Yz6xt2IZOSIWLbfEVM8gWnWUwFuFyY0xzWCRBzUmfnS0Cf+IuO701E7
	 LejaFesH7KDjL5+uiU535ln/uLM4PM88TEv9aZchvDzxVbqCQeeQILsKcynAKwJbDXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsSVJFVD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF58606A326;
	Thu, 19 Nov 2026 04:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsSVJFVD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C141F000C4;
	Thu, 19 Nov 2026 04:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060888;
	bh=y1Qo0pYu0ynJhIq00K520GD9SPv2zdqV8B6zm7b+/Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsSVJFVDvH08ZZlpq6b5BrWvagk4ESVvhxwWLWv/AZSTmIiE2biGD/cmQljLLDlKJ
	 NqBW1g2joHXk3Sx4Oa4bB/KaUX5T89sW6e2OJHiBxB6/5f/DTJ7h7lOTNKcMz89IXk
	 Yt7tSaZ+qOczO8swT7xMsCQm1S6IPxTMsm9UB0jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1359/1848] ASoC: mediatek: mt8183: Fix wrong clock cleanup on clk_set_parent() failure
Date: Wed, 18 Nov 2026 15:56:37 +0100
Message-ID: <20261118150016.497603648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 48e81c5d52fc2..d7a2617d44bd6 100644
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



