Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040196;
	b=T3DkUK7VBETqACJF/e5/KiaIOouWA91hAEusvlfwqk3CMIm9E6sNkrp5hlDBHvbNH9C4
	 7p67+Vd6094A2Tq60wuWU3WbDGCHD6i0THkKdZLze8Rq8ZVbbUHVi3dl7mnhl323XmYQD
	 V4ZU4ctK6E4BOM4Wuq9cvwFg+/r0Hyyl7AuBtDKDvVmxX4wgYTdPt32J5lQlWMp6MgPoB
	 IT9TwN7PdxGhcrCIzKuRZrE+vnRW8EAMKF21wy3bC04BKEgnUvBePeyMXSOdGh6NCjVZf
	 HxRbNLRiTMIguG0UZl9/M9ZYUnIaT5jrayaR8ujh6ltWU7Qc75QvQvY8j2SIftAtnYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GDq5F0dm/ZtvxeHDTHOznkLtYaklu4wFQPSm4SVL51w=;
	b=DvNxQCWMLy8nMQqXiyg1j2SaGJFo9EP5rGFs0bGZ4qmov3AVyPEeRSWqapbhurLK4joE
	 WGCYLhDwLV6vrTOJe779Hufo/lKcxC3YTVbGd6HgH+BGQ6oUy21CaA0q0USRRa0DhrGTx
	 sIFebzmCZ33/5TmoIW0NEIgb2NSZk1WxbTI+EgOZoh0r1r7hP/9nQd2J+REVIvUktkb/X
	 zZO/VgdHbdinMhOgbPfWy31sk8bDrysJPqjq6D32rc7SB/KMVmPhtP6qyn5TT0/aKWSkQ
	 6PFEkaZatDEqq/xFt7EB8P50qN1OrvKVdbH/1M4JSF1fEOuPSfyjwqKUAoRngyEpMFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=usxSr1Md;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AA6606A320;
	Wed, 18 Nov 2026 22:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=usxSr1Md
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AC51F000C4;
	Wed, 18 Nov 2026 22:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040196;
	bh=GDq5F0dm/ZtvxeHDTHOznkLtYaklu4wFQPSm4SVL51w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=usxSr1MdJctpmpDclnVQm0GjTiuLSxGUsDzGL9AXqqsTQa+5ApkFpK7E+QeaDuKWO
	 zFuIXlYbA9UZOMZbosfQb9rcKFnQ3sV9XOQbN/RAIknBbU+vBOt9u3406oNz6rfUWH
	 yAo2qM+7aia5cKbeYdBcg6ZqPqB6xsdeyYyn2UiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2372/3318] ASoC: mediatek: mt8183: Fix wrong clock cleanup on clk_set_parent() failure
Date: Wed, 18 Nov 2026 15:49:54 +0100
Message-ID: <20261118150432.718340001@linuxfoundation.org>
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



