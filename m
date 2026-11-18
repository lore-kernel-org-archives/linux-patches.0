Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024853;
	b=F0rRbYTZcMTkuvAz9I8fwsRbQe8RgI9i7krcyPhShLASMc6zTUbfXxPAZ9KJXKAeT//c
	 S0IGTtj0YXsvKzZrlfIdJbCz1iS8/TfJI6bcdcvVguE1c9vshdyaiIybtrT+NT5SxE61r
	 q9Dpgiio9wuGGk3UHNYsUrAqN4ek69Ijb6DneKeH0RoUx03SNOyVG2QgQIA46mawSAsYZ
	 LfTsj7bM9xh3w9u16hKFBriCibQ4ItcGPSlfa6XgaIvrjWYx8bGcDvTwSI+FQPgugY05a
	 hQu7Ze8r6sgOmnUHMXd5041iLuQa2/UqMPImWC67wsSutly9IK2f0isf5b6A8cck0Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OEzkUcIX9vNu6/n3FWjyyYGmZRw+CDE/z9AzlLI7gUQ=;
	b=IfxeMuFODtQbrImeFGtWbQikXiI7vKrWaJvXQAgvX6FN4vOAdHREZ0Vibz8+umtLXTZH
	 Ksj6VoEU5LjaCo25rS4i+LP2kQLKbb7HC96pmo43bl57WCXtUNb0ogd0H3Nje7Gko//1c
	 U5WiFWe5ku7xRX9GHojCQbB/iIAucTCAX+PPN6Lsblhh+W/O9GqGJZ+1FrNURdzjD/5Ou
	 gwTtvwcWkhZWBBtN46xuwCehsgSWW3a4ja8gSJqDXGeI9MVRt3Im9zM/pQLZ7QSqZNCCE
	 0fUpMxPTDwGEW+R7oIlwbHGVnXMNW/22Kdbqqi0mH6VHbKoLbXMPYZoPZegciwZ5Xwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNhFa79e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AD2606A31C;
	Wed, 18 Nov 2026 18:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNhFa79e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAC11F000C7;
	Wed, 18 Nov 2026 18:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024853;
	bh=OEzkUcIX9vNu6/n3FWjyyYGmZRw+CDE/z9AzlLI7gUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNhFa79eeHrcjRgIZZvW4uhrBppbXN77/24w4auy9f3vlb2bJKkGnCw0RcHbduTvY
	 nfdLVkjdaE6Gg0z4BAy7wArEStGzDgNou911PW9h6i1d8di9ZBCjRdnguqM2s45ew6
	 Pp2U8SwdH2CjoiUHSgq8Fqr75Y0WMfelS2RgMQwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0830/2151] ASoC: mediatek: mt8192: Propagate errors in I2S DAI DAPM event handlers
Date: Wed, 18 Nov 2026 15:42:45 +0100
Message-ID: <20261118150152.371892368@linuxfoundation.org>
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

[ Upstream commit 49aeb628d10ef3d5694c39b7a3427d34bde06bb2 ]

Currently, DAPM event handlers in mt8192-dai-i2s.c ignore return values
from mt8192_afe_gpio_request(), mt8192_apll1_enable(),
mt8192_apll2_enable(), and mt8192_mck_enable(). If GPIO configuration or
clock setup fails during DAPM events, the error is silently ignored.

Fix this by checking and propagating error codes properly in all I2S DAI
DAPM event handlers.

Fixes: 2c37b4ed730b ("ASoC: mediatek: mt8192: support i2s in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-15-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-dai-i2s.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c b/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c
index 47dc7ec4cae7e..374df85411b7c 100644
--- a/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c
+++ b/sound/soc/mediatek/mt8192/mt8192-dai-i2s.c
@@ -586,6 +586,7 @@ static int mtk_i2s_en_event(struct snd_soc_dapm_widget *w,
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
 	struct mtk_afe_i2s_priv *i2s_priv;
+	int ret;
 
 	i2s_priv = get_i2s_priv_by_name(afe, w->name);
 
@@ -599,16 +600,17 @@ static int mtk_i2s_en_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_afe_gpio_request(afe->dev, true, i2s_priv->id, 0);
+		ret = mt8192_afe_gpio_request(afe->dev, true, i2s_priv->id, 0);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
-		mt8192_afe_gpio_request(afe->dev, false, i2s_priv->id, 0);
+		ret = mt8192_afe_gpio_request(afe->dev, false, i2s_priv->id, 0);
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mtk_apll_event(struct snd_soc_dapm_widget *w,
@@ -617,6 +619,7 @@ static int mtk_apll_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
+	int ret;
 
 	dev_dbg(cmpnt->dev, "%s(), name %s, event 0x%x\n",
 		__func__, w->name, event);
@@ -624,9 +627,11 @@ static int mtk_apll_event(struct snd_soc_dapm_widget *w,
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
 		if (snd_soc_dapm_widget_name_cmp(w, APLL1_W_NAME) == 0)
-			mt8192_apll1_enable(afe);
+			ret = mt8192_apll1_enable(afe);
 		else
-			mt8192_apll2_enable(afe);
+			ret = mt8192_apll2_enable(afe);
+		if (ret)
+			return ret;
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		if (snd_soc_dapm_widget_name_cmp(w, APLL1_W_NAME) == 0)
@@ -704,6 +709,7 @@ static int mtk_mclk_en_event(struct snd_soc_dapm_widget *w,
 	struct snd_soc_component *cmpnt = snd_soc_dapm_to_component(w->dapm);
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(cmpnt);
 	struct mtk_afe_i2s_priv *i2s_priv;
+	int ret;
 
 	dev_dbg(cmpnt->dev, "%s(), name %s, event 0x%x\n",
 		__func__, w->name, event);
@@ -716,7 +722,9 @@ static int mtk_mclk_en_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8192_mck_enable(afe, i2s_priv->mclk_id, i2s_priv->mclk_rate);
+		ret = mt8192_mck_enable(afe, i2s_priv->mclk_id, i2s_priv->mclk_rate);
+		if (ret)
+			return ret;
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		i2s_priv->mclk_rate = 0;
-- 
2.53.0



