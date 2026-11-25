Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618874;
	b=D/Mk0HG/yKcq2DmmuNPbEToV3PNJyl+Xwuhs9/pkqvc+7tUu8x46niKUXq9ssq8NHxjB
	 MYUX/e1Dd2lO4MA0g5wlqorjae1WVTkPHOmhGHJsAZiQNPhkY4H/8bBhx7Wvxj28HRr2n
	 6s+MYFYP+Z3q7Pb3Nb18PILhJwDNtNtZytMyWElDBa00oZs8mt3vpYGpPY2d5avXTWtR/
	 YQqdA3fKDdYYyRuE6DSMz7sk7Xxq8j7l1Y5bscohQIIqCH0zpx5i7hzSrdJFwwQLRTYAn
	 5hK/t5ap4g3Dpv63DibZQTfLsKkv7o/C+vV5Udy5DIdvi3pnUvfmioJgOrdTMWUhmfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jUaRw1oqvhe9cQac+FTCaWS73lRarXkgRgdlDH4iGKU=;
	b=yDS5lzWDSdBLhjwU7RWJVgolT3uui7om0S+/NJh1zaOaikHXOkshKH1fuEF1YhOuwyHW
	 A1A94qGMATWGqT1HuAbr7Bp943JosfCsq79Q/50kFQnLFPTCeageT7LQhuo8QEKqH66eu
	 zYJEZ+PSGDN5BbG1eA8/MQdD1AG8VXI8icqINvBLuINtzrukybz+0aOWgn5fPflMzb6SL
	 nyN36bMB3kyI8nypeWNMRJ5nmaW+vQ1qnTYCRiClMbR0lfDsDlHxUqSyn7w4Bt79XvITc
	 6lWiEzyjbZtqLOER7cy7zWHTBGxVmx9p0gFoETOTKf/fyc2hHff4pXezVvsp1BvxQeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UXI4uWR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83CB606A33E;
	Wed, 25 Nov 2026 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UXI4uWR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B911F000E1;
	Wed, 25 Nov 2026 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618874;
	bh=jUaRw1oqvhe9cQac+FTCaWS73lRarXkgRgdlDH4iGKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXI4uWR0QnkSS/M1jgYKs9uE5kmTxYeE4yrynLw29im5LYPZb9mQrNklH0WAMkWuY
	 kBulEGqkyrGdbeQYItXfDvPr2oxJtWKGvUJd6abecfkerpoQrfGQNEL4WcBujpOUeO
	 kzncEGO7kdnyLd/h1G2I38Bg1lU5K2lXK3kYirgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Leyva <samuelslg03idk@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0417/1005] ASoC: amd: acp: es83xx: Enable speaker amplifier after the codec output
Date: Wed, 25 Nov 2026 15:29:15 +0100
Message-ID: <20261125143831.522149211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Samuel Leyva <samuelslg03idk@gmail.com>

[ Upstream commit f392763d73356760eac3e4ab7c87b0855be0d4bb ]

The speaker amplifier GPIO is driven from a SUPPLY widget. DAPM powers
supplies before the rest of the path, so the amplifier is enabled while
the ES8316 headphone driver and charge pump, which also feed the
speakers, are still powering up. This results in an audible pop every
time the speaker output is powered on.

Move the speaker GPIO handling to the Speaker endpoint widget, which
DAPM powers up last and powers down first, and give the codec output a
short time to settle before enabling the amplifier.

The headphone path is left unchanged: the Headphone endpoint widget
shares its power-up rank with the codec output drivers, so moving it
would not guarantee the same ordering, and it could not be tested.

Fixes: 54fcd9dd44b2 ("ASoC: amd: acp: Add machine driver that enables sound for systems with a ES8336 codec")
Signed-off-by: Samuel Leyva <samuelslg03idk@gmail.com>
Link: https://patch.msgid.link/20261107232225.3838-3-samuelslg03idk@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
index eb0e9a6af6ef1..80985d044896c 100644
--- a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
+++ b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
@@ -18,6 +18,7 @@
 #include <linux/input.h>
 #include <linux/io.h>
 #include <linux/acpi.h>
+#include <linux/delay.h>
 #include <linux/dmi.h>
 #include <linux/string_choices.h>
 #include "../acp-mach.h"
@@ -60,6 +61,8 @@ static const struct snd_pcm_hw_constraint_list constraints_channels = {
 #define ES83xx_12288_KHZ_MCLK_FREQ   (48000 * 256)
 #define ES83xx_48_MHZ_MCLK_FREQ      (48000 * 1000)
 
+#define ES83XX_AMP_ON_DELAY_MS	50
+
 static int acp3x_es83xx_headphone_power_event(struct snd_soc_dapm_widget *w,
 					    struct snd_kcontrol *kcontrol, int event);
 static int acp3x_es83xx_speaker_power_event(struct snd_soc_dapm_widget *w,
@@ -114,7 +117,7 @@ static struct snd_soc_jack_pin es83xx_jack_pins[] = {
 };
 
 static const struct snd_soc_dapm_widget acp3x_es83xx_widgets[] = {
-	SND_SOC_DAPM_SPK("Speaker", NULL),
+	SND_SOC_DAPM_SPK("Speaker", acp3x_es83xx_speaker_power_event),
 	SND_SOC_DAPM_HP("Headphone", NULL),
 	SND_SOC_DAPM_MIC("Headset Mic", NULL),
 	SND_SOC_DAPM_MIC("Internal Mic", NULL),
@@ -122,9 +125,6 @@ static const struct snd_soc_dapm_widget acp3x_es83xx_widgets[] = {
 	SND_SOC_DAPM_SUPPLY("Headphone Power", SND_SOC_NOPM, 0, 0,
 			    acp3x_es83xx_headphone_power_event,
 			    SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMU),
-	SND_SOC_DAPM_SUPPLY("Speaker Power", SND_SOC_NOPM, 0, 0,
-			    acp3x_es83xx_speaker_power_event,
-			    SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMU),
 };
 
 static const struct snd_soc_dapm_route acp3x_es83xx_audio_map[] = {
@@ -138,7 +138,6 @@ static const struct snd_soc_dapm_route acp3x_es83xx_audio_map[] = {
 	 */
 	{"Speaker", NULL, "HPOL"},
 	{"Speaker", NULL, "HPOR"},
-	{"Speaker", NULL, "Speaker Power"},
 };
 
 
@@ -186,10 +185,13 @@ static int acp3x_es83xx_speaker_power_event(struct snd_soc_dapm_widget *w,
 	struct acp3x_es83xx_private *priv = get_mach_priv(card);
 
 	dev_dbg(priv->codec_dev, "speaker power event: %d\n", event);
-	if (SND_SOC_DAPM_EVENT_ON(event))
+	if (SND_SOC_DAPM_EVENT_ON(event)) {
+		/* Let the codec output settle before enabling the amplifier */
+		msleep(ES83XX_AMP_ON_DELAY_MS);
 		priv->speaker_on = true;
-	else
+	} else {
 		priv->speaker_on = false;
+	}
 
 	gpiod_set_value_cansleep(priv->gpio_speakers, priv->speaker_on);
 	gpiod_set_value_cansleep(priv->gpio_headphone, priv->headphone_on);
-- 
2.53.0



