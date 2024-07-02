Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839B0178381;
	Tue,  2 Jul 2024 17:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940086; cv=none; b=YxHVt3nGhHR/OGl58oO/V0xHKmGIQoTJy2KOXab9mZBeza5EwIhzrPmgbsDFaJgPYpXBYNAoK6paJGTNLyly+I1njJUTjzROU5YJo3qcCn+F5ynx/UqmtT8DdUUrX6xNpokJwVgilSriNyypO0own0Kj9Y1lxgwhVPJ9briukQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940086; c=relaxed/simple;
	bh=vYDWBYyLP+K5r03lalnLbz8RVwyoyEUPeMw7QF3nb90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKe9ViMkMhgpzfHFhp6tF31kfkDxN6l5k0+1+AbuKPH6JMVZv3OxYhKNWhbkZU/CE2BwZy9G4T9afRYGk78FaF41pRhJf38cjWLdmSDuh5m7E5lp4AAMPwRrFEWtjFkMiGFhHNvc0uSzWjLB0MbVNNue02wNiNF47uLlySWRl+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjTm3PP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjTm3PP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1905C116B1;
	Tue,  2 Jul 2024 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940086;
	bh=vYDWBYyLP+K5r03lalnLbz8RVwyoyEUPeMw7QF3nb90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjTm3PP+hVu4+QCxvGncwzoF+7weaypgHhzlQA/FnVYs6bm4nbF32tuWZZWPkCK6H
	 GpfQexcHWprH80v4XnaZy/pth+itKP9qrKTuZBdWgM72T6V/yhUD9ddJRgKDfWfHlJ
	 Da5bktfceTkGo/yhggw+kt2pZDJlSnNkexeSeO+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 017/222] ASoC: mediatek: mt8183-da7219-max98357: Fix kcontrol name collision
Date: Tue,  2 Jul 2024 19:00:55 +0200
Message-ID: <20240702170244.632506065@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit 97d8613679eb53bd0c07d0fbd3d8471e46ba46c1 ]

Since "Headphone Switch" kcontrol name has already been used by da7219,
rename the control name from "Headphone" to "Headphones" to prevent the
colision. Also, this change makes kcontrol name align with the one in
mt8186-mt6366-da7219-max98357.c.

Fixes: 9c7388baa2053 ("ASoC: mediatek: mt8183-da7219-max98357: Map missing jack kcontrols")
Change-Id: I9ae69a4673cd04786b247cc514fdd20f878ef009
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://msgid.link/r/20240531-da7219-v1-1-ac3343f3ae6a@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
index acaf81fd6c9b5..f848e14b091a1 100644
--- a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
@@ -31,7 +31,7 @@ struct mt8183_da7219_max98357_priv {
 
 static struct snd_soc_jack_pin mt8183_da7219_max98357_jack_pins[] = {
 	{
-		.pin	= "Headphone",
+		.pin	= "Headphones",
 		.mask	= SND_JACK_HEADPHONE,
 	},
 	{
@@ -626,7 +626,7 @@ static struct snd_soc_codec_conf mt6358_codec_conf[] = {
 };
 
 static const struct snd_kcontrol_new mt8183_da7219_max98357_snd_controls[] = {
-	SOC_DAPM_PIN_SWITCH("Headphone"),
+	SOC_DAPM_PIN_SWITCH("Headphones"),
 	SOC_DAPM_PIN_SWITCH("Headset Mic"),
 	SOC_DAPM_PIN_SWITCH("Speakers"),
 	SOC_DAPM_PIN_SWITCH("Line Out"),
@@ -634,7 +634,7 @@ static const struct snd_kcontrol_new mt8183_da7219_max98357_snd_controls[] = {
 
 static const
 struct snd_soc_dapm_widget mt8183_da7219_max98357_dapm_widgets[] = {
-	SND_SOC_DAPM_HP("Headphone", NULL),
+	SND_SOC_DAPM_HP("Headphones", NULL),
 	SND_SOC_DAPM_MIC("Headset Mic", NULL),
 	SND_SOC_DAPM_SPK("Speakers", NULL),
 	SND_SOC_DAPM_SPK("Line Out", NULL),
@@ -680,7 +680,7 @@ static struct snd_soc_codec_conf mt8183_da7219_rt1015_codec_conf[] = {
 };
 
 static const struct snd_kcontrol_new mt8183_da7219_rt1015_snd_controls[] = {
-	SOC_DAPM_PIN_SWITCH("Headphone"),
+	SOC_DAPM_PIN_SWITCH("Headphones"),
 	SOC_DAPM_PIN_SWITCH("Headset Mic"),
 	SOC_DAPM_PIN_SWITCH("Left Spk"),
 	SOC_DAPM_PIN_SWITCH("Right Spk"),
@@ -689,7 +689,7 @@ static const struct snd_kcontrol_new mt8183_da7219_rt1015_snd_controls[] = {
 
 static const
 struct snd_soc_dapm_widget mt8183_da7219_rt1015_dapm_widgets[] = {
-	SND_SOC_DAPM_HP("Headphone", NULL),
+	SND_SOC_DAPM_HP("Headphones", NULL),
 	SND_SOC_DAPM_MIC("Headset Mic", NULL),
 	SND_SOC_DAPM_SPK("Left Spk", NULL),
 	SND_SOC_DAPM_SPK("Right Spk", NULL),
-- 
2.43.0



