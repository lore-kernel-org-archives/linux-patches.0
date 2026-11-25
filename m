Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624737;
	b=djDuCDa9oFoefcnnl6DLz+fcd/I56O9TWjHafKcniH3+o+QbMIhfPPakUfnVnXSmJdU4
	 QG+KqAlytn2m0RLGNW8RhXWURYF4jYShvm+3eCuws3bExyu7TvnCOizQxWOGYqfXpvBFK
	 qeQfk9uATDJ3EAtf/qyo6nkvOuc0inSszufjiTBswJBdtGzF81VrFocFu5q+wcdxRIUcD
	 pUi5TrZukomEeiZH2zdBcJISHrGNZBKQZcUjMTXfqy9Otu+NlEdjQQDJ+Hxj1XKjCaWxj
	 kIaEsye572N8sUOawjp0i+KETV3TLRso36aTzhEUKoJQQRx5Pd8zRcucdl7U91TlYYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ja0Tu/KMR2mqnDKG/nYiXke5jkhTzGsagg5/U006clY=;
	b=eEfgxK+hAmcvfSJhbCKEWzFDIAmpv0zWDR529bMl/IZaTHBz0Kz0dK38s4Qz37uPM4B5
	 Vnn2s831LgznTm2NWcpIVdrdoHhlvcdKXSzBBIJAuhgpfCFIzDRfk0hn9Ze4ZXWBqlnaP
	 rPZ0u66ctIzY1D6YGczy74+hiRkjqwSlwduO31TFD6tiw3J6kO7tdN8hDDqaD5tZaTUS8
	 OVmUZ4npYPkZIk4aO9PrpDYk3rnX79IvMROhL54gOIgdmN8oJDN5Rwq6Krwz0YDuoeLN/
	 rR22H7cEGQfLqWPTddZfsGC1owPNAHp4sjJsRKjVba6F/yFC8DQiQ76bftNFY38y06Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y8XBDWCr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D22606A33B;
	Wed, 25 Nov 2026 16:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y8XBDWCr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E201F000D0;
	Wed, 25 Nov 2026 16:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624737;
	bh=ja0Tu/KMR2mqnDKG/nYiXke5jkhTzGsagg5/U006clY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8XBDWCrI4B220gz/tZ9ISp8s49G+7pOJ2TObzRthZQyZzPLVofAYto3PQ+vmd7MH
	 qjauqR9b1blyrvfPXxSYO1dfGbl2uS/t+jVe9h9osbILzum6+A4l0MAgXNTq8hZbV5
	 OsD6C1cynFw7SeHGk6tB/cT8+c286GHYto+i51H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Leyva <samuelslg03idk@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 291/816] ASoC: amd: acp: es83xx: Enable speaker amplifier after the codec output
Date: Wed, 25 Nov 2026 15:30:39 +0100
Message-ID: <20261125143855.941175087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d39907b65afd2..47cc0b1c71e13 100644
--- a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
+++ b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
@@ -19,6 +19,7 @@
 #include <linux/input.h>
 #include <linux/io.h>
 #include <linux/acpi.h>
+#include <linux/delay.h>
 #include <linux/dmi.h>
 #include "../acp-mach.h"
 #include "acp3x-es83xx.h"
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
 
 
@@ -184,10 +183,13 @@ static int acp3x_es83xx_speaker_power_event(struct snd_soc_dapm_widget *w,
 	struct acp3x_es83xx_private *priv = get_mach_priv(w->dapm->card);
 
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



