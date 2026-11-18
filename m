Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020588;
	b=BUcYk+4GJ0S6QKyCRH4Zg2D+BZMd1y6c3nKbXNKabhxwzFx2Pe1pdicYT37Za1ALZjb0
	 Cwgrdx8pQGxbH0UdOqCFw1w3CPbjrwj1jaf5U6+Huv1iKpTuxOpjVODyIdCFCIo+iBiG9
	 QuG6WX+fzniQ86WqW/hdBUj2O91ipNvrgNnVNYhUOpABblTIUNOAxMZzmPJvkTNvWHT31
	 Nt1M6H3h9CCKwHX6MpX09seTRdnogU4sqDDsdAubtug0VRFUiDhr6HV+E0jI8KJEH/Pna
	 A4i38rDmscIf1h84X8cLVJnsmjX1n42Br98LRKxjVymTT1i2ymy4rbhSaCt6HqpYx+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OZNdJCzIMZYI0+tLzhIsyftz2D8g7CBc+VqOleRaKYw=;
	b=GITFSDo8/JDgpKXl36GvSXiC8jL62L4PnkduTswIos+HzuZrKvmgPScawzbIZvnbGZ6E
	 zhkXOJTDZs74lOqIrKoJw/6sDYs86rWS5UqSqpd4YwY0oTxRilfYzvp21iI+F1lTtEXGQ
	 zG48SoQe2gixXhFyPFY9eqR+h694vGI3khlaVJcOOdwuOVQiGvAqRNY38CIBCrm7Y1VEq
	 vEyqbQjO2zu04SQv5lS/skrw/HB1ZXqwH6lBdmLiOd8buiaaiWrZsB8Fe9FEEkxq12iHL
	 c9kA9qcTamXZNAVlwHwb053PgStbjtfctQvO7JzN5vSaFE4bp1DjQHdUgZ12Y6afLIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2ev3UVt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D791B606A31C;
	Wed, 18 Nov 2026 16:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2ev3UVt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367761F000C4;
	Wed, 18 Nov 2026 16:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020588;
	bh=OZNdJCzIMZYI0+tLzhIsyftz2D8g7CBc+VqOleRaKYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2ev3UVthpHAPQApjebp87tWksQeVNO7uLZJWkkKyNSzjvcMDvWvHLC+G1/dqO/ua
	 FLzHZ3tGvAaH6VM2UE+qOnOZj1dgeoi5JI9cpLCoQuWGxyA0X1lp0pY3WOL2JEoBpb
	 4h66M+KI89agmVXdR6cPi0j/FPlJ4aFDYyc2CeE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2004/2651] ASoC: mediatek: mt8195: Fix HDMI TX startup error handling
Date: Wed, 18 Nov 2026 15:54:04 +0100
Message-ID: <20261118150358.443442300@linuxfoundation.org>
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
index 1270fcac6b3f4..11317cdd14abc 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -2321,13 +2321,25 @@ static int mtk_dai_hdmitx_dptx_startup(struct snd_pcm_substream *substream,
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



