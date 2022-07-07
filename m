Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C28809
	for <patches@lists.linux.dev>; Fri,  8 Jul 2022 11:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8C7C341C0
	for <patches@lists.linux.dev>; Fri,  8 Jul 2022 11:46:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJGXQsQP"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 8 Jul 2022 12:46:47 +0100
Resent-Message-ID: <YsgZJ+aMEFCt8u7T@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Thu, 07 Jul 2022 09:08:17 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Ti7v=XM=gmail.com=savagecin@kernel.org>)
	id 1o9MYZ-003WcP-1l
	for broonie@sirena.co.uk; Thu, 07 Jul 2022 09:08:17 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 0E97261F55
	for <broonie@sirena.co.uk>; Thu,  7 Jul 2022 08:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 88CD8C341C0; Thu,  7 Jul 2022 08:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3667C3411E
	for <broonie@kernel.org>; Thu,  7 Jul 2022 08:08:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org C3667C3411E
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id 70so2757411pfx.1
        for <broonie@kernel.org>; Thu, 07 Jul 2022 01:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9OQsn3k7n+Fp/tYnNYewakJ/MpfwqjttJ4lbj4UUSe4=;
        b=WJGXQsQPGUJctU8cd/RnpN8TP6kutcpXuqVtV1Gyzy9fAxFOMoS0c5aG5BBl/r0g2V
         DX0smN9na0ycikKK9J1lLlolmPNdPh1hMPk2Yo1JE89CCZ+sS4vI2yu5+08GXTSmioBS
         wmOTQSH+xbS1OeXbY45P540rwHb9UZncvioPLvB0JRjTLIWu0X/TOX8t2/LDG+OTneYw
         C4n2aYrcGG5/ykQRVa0VrBsJT7wY5pNhen1nfFaL3tVikjnDZtWZzeVzJDm7vAFPq7QY
         cFBPEM5sLyOSCyp/13mdDJfmalBmIkLVydVvQqx+plS+D9Q0qsu4V96miuGOzM6BgC6k
         Sjsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9OQsn3k7n+Fp/tYnNYewakJ/MpfwqjttJ4lbj4UUSe4=;
        b=YD7w5v3XzTuGDGePgIQIYyFHiZXTFYBou0kfi0b7zHZOQ8FfR6axB1kp2njEKuqXHm
         erEiZlBbsroG0+0UlXDYca4C7cEWiFc9ez4XuV5AYkU3/OEUo+9lY2iGDY8tQPaKTa42
         SSgAjmxWUurEcKtEPPxg0HaFP4Cox/OQuBOq9C2w7nm9edaTrzRhtHLkfmtO8qLafPvL
         gYKTIIV3pMzmuc6bpfJ5uP3uvvnB/JjubvtLgdFTA0lBZdZh9QidHJr0E2RU9f9hsoQ6
         pEd+jWV7hZj8DYFISRP/LCz8lVUtQsV757Ahh/OYh4vfhK1gP3NzN5svcbIA4qLsShSb
         7/Kg==
X-Gm-Message-State: AJIora83dNh+cIjbGZNqRXgpkH/lWcSgKdFx0UnHXMSYYrZ0+X1GTOv8
	gax06kKOKW78zayeg+ZBlpkG9YIFFgw/Bg==
X-Google-Smtp-Source: AGRyM1vZrUQmD+5Mo6+rpCk2lsIsYar6ugQqKJvtlrfgHziLSU/Dlyc96lm7YDa1F5HgB+vs8/FMAg==
X-Received: by 2002:a63:904b:0:b0:412:aea7:9e7a with SMTP id a72-20020a63904b000000b00412aea79e7amr4292460pge.421.1657181291984;
        Thu, 07 Jul 2022 01:08:11 -0700 (PDT)
Received: from localhost.localdomain (2001-b400-e35a-838c-69b6-1f1f-b3c0-f714.emome-ip6.hinet.net. [2001:b400:e35a:838c:69b6:1f1f:b3c0:f714])
        by smtp.gmail.com with ESMTPSA id cp2-20020a170902e78200b001664d88aab3sm27059430plb.240.2022.07.07.01.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 01:08:11 -0700 (PDT)
From: Wallace Lin <savagecin@gmail.com>
X-Google-Original-From: Wallace Lin <savagecin0@gmail.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com,
	alsa-devel@alsa-project.org,
	YHCHuang@nuvoton.com,
	KCHSU0@nuvoton.com,
	CTLIN0@nuvoton.com,
	WTLI@nuvoton.com,
	SJLIN0@nuvoton.com,
	scott6986@gmail.com,
	supercraig0719@gmail.com,
	dardar923@gmail.com,
	savagecin@gmail.com,
	Wallace Lin <sjlin0@nuvoton.com>
Date: Thu,  7 Jul 2022 16:07:51 +0800
Message-Id: <20220707080751.76892-1-savagecin0@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=Ti7v=XM=gmail.com=savagecin@kernel.org
Subject: [PATCH] ASOC: add new widget to control system clock
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: ujrOLFWQXRIg

From: Wallace Lin <sjlin0@nuvoton.com>

Signed-off-by: Wallace Lin <sjlin0@nuvoton.com>
Signed-off-by: Wallace Lin <savagecin@gmail.com>
---
 sound/soc/codecs/nau8821.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index 6453e93678d2..761a3dc08edc 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -34,6 +34,7 @@
 
 static int nau8821_configure_sysclk(struct nau8821 *nau8821,
 	int clk_id, unsigned int freq);
+static bool nau8821_is_jack_inserted(struct regmap *regmap);
 
 struct nau8821_fll {
 	int mclk_src;
@@ -493,7 +494,33 @@ static int nau8821_output_dac_event(struct snd_soc_dapm_widget *w,
 	return 0;
 }
 
+static int system_clock_control(struct snd_soc_dapm_widget *w,
+				struct snd_kcontrol *k, int  event)
+{
+	struct snd_soc_component *component =
+		snd_soc_dapm_to_component(w->dapm);
+	struct nau8821 *nau8821 = snd_soc_component_get_drvdata(component);
+
+	if (SND_SOC_DAPM_EVENT_OFF(event)) {
+		dev_dbg(nau8821->dev, "system clock control : POWER OFF\n");
+		/* Set clock source to disable or internal clock before the
+		 * playback or capture end. Codec needs clock for Jack
+		 * detection and button press if jack inserted; otherwise,
+		 * the clock should be closed.
+		 */
+		if (nau8821_is_jack_inserted(nau8821->regmap)) {
+			nau8821_configure_sysclk(nau8821,
+				NAU8821_CLK_INTERNAL, 0);
+		} else {
+			nau8821_configure_sysclk(nau8821, NAU8821_CLK_DIS, 0);
+		}
+	}
+	return 0;
+}
+
 static const struct snd_soc_dapm_widget nau8821_dapm_widgets[] = {
+	SND_SOC_DAPM_SUPPLY("System Clock", SND_SOC_NOPM, 0, 0,
+		system_clock_control, SND_SOC_DAPM_POST_PMD),
 	SND_SOC_DAPM_SUPPLY("MICBIAS", NAU8821_R74_MIC_BIAS,
 		NAU8821_MICBIAS_POWERUP_SFT, 0, NULL, 0),
 	SND_SOC_DAPM_SUPPLY("DMIC Clock", SND_SOC_NOPM, 0, 0,
@@ -605,6 +632,9 @@ static const struct snd_soc_dapm_route nau8821_dapm_routes[] = {
 	{"AIFTX", NULL, "ADCL Digital path"},
 	{"AIFTX", NULL, "ADCR Digital path"},
 
+	{"AIFTX", NULL, "System Clock"},
+	{"AIFRX", NULL, "System Clock"},
+
 	{"DDACL", NULL, "AIFRX"},
 	{"DDACR", NULL, "AIFRX"},
 
@@ -1430,6 +1460,7 @@ static const struct snd_soc_component_driver nau8821_component_driver = {
 	.dapm_routes		= nau8821_dapm_routes,
 	.num_dapm_routes	= ARRAY_SIZE(nau8821_dapm_routes),
 	.suspend_bias_off	= 1,
+	.non_legacy_dai_naming	= 1,
 	.idle_bias_on		= 1,
 	.use_pmdown_time	= 1,
 	.endianness		= 1,
-- 
2.25.1

