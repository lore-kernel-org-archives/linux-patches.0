Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027027;
	b=cMdYNCrcinKR/KVicE0Hr2IZCI97uMT+3Lr2tnUBM5ZrtpwjqWyg3Vri+RR+VF22NAjo
	 yrxqidQcjAk1DhtRWsHR1lHTV786/Sc1X7IlOONk3v/lKWrvERKMMJ80k3ouH9gtKSI4U
	 NmaHnAsd0hYbkOl5mJkD7ycaaYHIsQcoqMAlYxxiib0w18Oolq4SXiGyFCIB6187B0atw
	 mOF3jeUbSUj1grBVuboSQzMM6Rh8o15NKz8XAM4DSkUKQSh49dluvQk7aAhIDxC03Af/H
	 LFSZ7WN0oBeb6FU/4gO/xtcQ72NZlIxDIentRKQHrjblEnhyoCw0mhuCfR1xwkMtYVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=igCuOyzHUrDbHLwP8mXnchjnbOL1TxN91s7VygrMTes=;
	b=vxJU1HqIILieDlFoOVU0SUPbRmUdXV1CcoFbnCQA/QSytTRweKYwNi/YJHu7ADvYmyZx
	 S+tU3t2D5LbN5T7QCaBGEzxaubWIeWrw7eJWNjz+K5gXjsDLNwFH5dliyCLMiSuzYzisC
	 tybmMpp8N7HaTo3sav1MJQvoE0DRdf9F0HjTuIOsGZcN74ilLEU2pYcz4oWKNUTX68HvA
	 TlEyjB0V5C4/T4NA5NH5WEIWLqPGvZXU4+mh6ogC6bibbU/QJAu+yFHHlG8CdQV6x5Rop
	 DxzSk+HY35h32k6QIwuVQaGd6pGdkNUF/Uh2QoHsyvazen8MlOgBTEEK12JIKIQ0rlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RW2MapjR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CEE606A330;
	Wed, 18 Nov 2026 18:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RW2MapjR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9311F000C5;
	Wed, 18 Nov 2026 18:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027027;
	bh=igCuOyzHUrDbHLwP8mXnchjnbOL1TxN91s7VygrMTes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RW2MapjRIS2MAt5E3I34kFKJZbDdg5XNkAoOjNWjyFlNAS9FdU7cVFi/xdpNroSDL
	 VBJAI/4mZlGOmls5hlr1TK8Oet/n8VO04dqnwKrOVWGVVv7FNM08BUcUuWWsGiHI57
	 hJ7JKd1dAdrOaSVCLOZflBtTlfjjztVmy0APNj/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1642/2151] ASoC: mediatek: mt8195: Fix HDMI TX startup error handling
Date: Wed, 18 Nov 2026 15:56:17 +0100
Message-ID: <20261118150221.673399433@linuxfoundation.org>
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



