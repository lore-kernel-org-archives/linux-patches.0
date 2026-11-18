Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041852;
	b=CS9TxaT49AVLX8S0tlzslV9erywkSFXvwXmOOEXZOxYP+85osZJWXW9ufsnKTOcsWXBh
	 /+yY0GiFiWTNxerN6g0jUUYtBP6d+KJA7Q51GXVP0htnKu3fmhVQgLDapUCqfvHBqzIkI
	 P78oc8CETk4nYcMuwGOghW2tlJx7avgNOxxWUN/8TcaQfNiFieVLbf1mdR5x2DK3Ic+bg
	 y2uw00Fl/kYLljciZTdooK6G2tV3WGbYlDbes5bW1F4jdANBGM3IC6KywUC8c/fP52cGa
	 6kFf6AbkwsQ8Z1p0ra9R+rDm861qTbNlBH7fu/WL4wncgHqvzHLwX5EWPX0T0X71tbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JrKTC3094m6CZdXXGaS52MdscQpVUFplT9m29HWMOsE=;
	b=aYhtNKjr8cNhRo7zjAfTtk3SxzzHUCj1KLktg2FIoQYs9WNsUDymE6xDe57si49Ip3m/
	 85Fts/MiTbyqhdIE4u9DYYZlwFce1cgqjVd/CsuJ10FXwVoGye052jWtPuvz/zjXIgBOD
	 A228VJ03SyDkFGZHfFgjinjvnRQQ9w3iJkA31MecjsLH9U5R1OCs9KAbfy2aX6SSxRDso
	 3hEQIq+8yTsu2mYY+1tZuDhI39/YHR8TJY0GmkZ7mBD1mZugzswScMORQBadocpabmbh6
	 33bOmvRrX75igcsNv+o78xiuODaK683QdyKIyD34VfZTpYMe5GhiLN5Ym7RtpnFbjHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ha54PKgI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5EA606A31C;
	Wed, 18 Nov 2026 22:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ha54PKgI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BC31F000C4;
	Wed, 18 Nov 2026 22:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041852;
	bh=JrKTC3094m6CZdXXGaS52MdscQpVUFplT9m29HWMOsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ha54PKgIiT3/dTUd28VGuAPCAGAsilstYbiAGQsMbDBmijfhdyYVrXTOyPpK8/SnY
	 eCS+BfONt2Ufh6fbBY0R4folXA+8FsLUBgHvMfNNb5yVHjDzckaNFzZzyRXYH6qHyx
	 IDndI6pLwTwLT0i3sTQBAEQTnxTrC/XU9tp5sHlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2961/3318] ASoC: mediatek: mt8195: Fix HDMI TX startup error handling
Date: Wed, 18 Nov 2026 15:59:43 +0100
Message-ID: <20261118150449.128024525@linuxfoundation.org>
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

[ Upstream commit 1d6f1785d90334b66809a57ebfc40a5b1cfa80ec ]

Check and propagate errors when enabling the clock gate and MCLK
during HDMI TX/DP TX startup.

If MCLK enabling fails, disable the clock gate that was already
enabled before returning the error.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-15-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index d6100a6aa7757..66f8468e534a8 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -2326,13 +2326,25 @@ static int mtk_dai_hdmitx_dptx_startup(struct snd_pcm_substream *substream,
 	struct mtk_base_afe *afe = snd_soc_dai_get_drvdata(dai);
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	int cg_id = mtk_dai_etdm_get_cg_id_by_dai_id(dai->id);
+	int ret;
 
-	if (cg_id >= 0)
-		mt8195_afe_enable_clk(afe, afe_priv->clk[cg_id]);
+	if (cg_id >= 0) {
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[cg_id]);
+		if (ret)
+			return ret;
+	}
 
-	mtk_dai_etdm_enable_mclk(afe, dai->id);
+	ret = mtk_dai_etdm_enable_mclk(afe, dai->id);
+	if (ret)
+		goto err_disable_cg_clk;
 
 	return 0;
+
+err_disable_cg_clk:
+	if (cg_id >= 0)
+		mt8195_afe_disable_clk(afe, afe_priv->clk[cg_id]);
+
+	return ret;
 }
 
 static void mtk_dai_hdmitx_dptx_shutdown(struct snd_pcm_substream *substream,
-- 
2.53.0



