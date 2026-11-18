Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016606;
	b=3u5g2xitrxURpYJr9Tqm/HHaKS58L2eOqINHFI8+dnOPNRx4nSSAVSp2E+bX7iS+Q0j3
	 DJdTpaHWij+q8T9ngDZp8ShTHssPKlaLQMb/M0PixqxN7cnngwcah1ejR7nza+bmu57st
	 Etrshgw5eF3WbCBkvQGt7MyjjvGcVLi3vOWeIyhh9PezrQtEgLJdnn8QXN/HaBzodTmLN
	 XAigTCXlmWk/Gz+FNmM2pVleauC5n96h+eRSPaedMmVKkDcDudbB+pygAhaHMdnYBLZAs
	 MmCRsUro99Xjur9BGah90b0hofEAizg3kpJ7/4swFMBNGg9GOjoRqMVRPZdnFjHL/Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NhX4pyMaUQ6KlpTvF2u6WKw2jHKcD1J9xmkXzoGEvh8=;
	b=pOpQCbZuFXvb433AMYqLeRemLgvp+SHRwFrJRb3BqJi2bwbGmUtt+UJ2Dssdls+55Dit
	 ME3Ka6lj7uc89azAExqA++I0QA6DrnH75p7orly06LYLoiRJDdOCO2ewFGBzbNABO0O4v
	 xfyFdKDLB+7la5lH/wNwW+Bl/iMW6UPXK5gKNY3sB+/xReQHSzclWQqgvfxV1dQVeuZKw
	 wKE78eP9eW08suFvAlFQ6HWPqP/C6A5VLKdMHeFoDUPVjQTjqtR9T38OK+panYupOtDhx
	 IieyWULtdRoFaCNjSv5yKH1kMUM+Xz50GMS+cg+ZY+lma/rKJMW0WoHSWk9Y6Mnxiig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z4Z1/+uK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9673606A31C;
	Wed, 18 Nov 2026 15:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4Z1/+uK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04D71F000C5;
	Wed, 18 Nov 2026 15:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016606;
	bh=NhX4pyMaUQ6KlpTvF2u6WKw2jHKcD1J9xmkXzoGEvh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4Z1/+uKN+9eiQTDRdVyp5KSYcBoLs4NP6J0nSmbRCcY8gTNJlU0ZAhvBC5VDnDNG
	 wV8kUxgjyQg2imBxXZ6EXd9n2Vu7eP3+gKR/OqtfDV3igFvRa+2+hNH7aD+HaFvXlW
	 SYaAjxS65tV5TXSUJJAkELmA4VmhEo1VerUszhpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0588/2651] ASoC: ab8500: Skip digital microphone support on AB8505
Date: Wed, 18 Nov 2026 15:30:28 +0100
Message-ID: <20261118150308.888657248@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 0d46182a1be7ef12f85433d91315d4d7091dd8c8 ]

The AB8505 does not have the digital microphone interface, its six
input pins or the VDMIC regulator found in AB8500. The shared codec
driver nevertheless creates the entire AB8500 DMIC DAPM graph. When an
AB8505 sound card binds, the regulator widget requests the nonexistent
V-DMIC supply and falls back to a dummy regulator.

Split the digital microphone widgets and routes from the common codec
graph and add them only when the parent MFD is an actual AB8500. This
also removes the DMIC4-only AD_OUT4 path from AB8505.

Fixes: 679d7abdc754 ("ASoC: codecs: Add AB8500 codec-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260918-ux500-simple-sound-v2-4-88d29416e3c3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 144 ++++++++++++++++++--------------
 1 file changed, 82 insertions(+), 62 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index e1a0e35836e6c..35df09705440a 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -299,7 +299,6 @@ static const struct snd_soc_dapm_widget ab8500_dapm_widgets[] = {
 	SND_SOC_DAPM_REGULATOR_SUPPLY("V-AUD", 0, 0),
 	SND_SOC_DAPM_REGULATOR_SUPPLY("V-AMIC1", 0, 0),
 	SND_SOC_DAPM_REGULATOR_SUPPLY("V-AMIC2", 0, 0),
-	SND_SOC_DAPM_REGULATOR_SUPPLY("V-DMIC", 0, 0),
 
 	/* Power */
 	SND_SOC_DAPM_SUPPLY("Audio Power",
@@ -324,7 +323,6 @@ static const struct snd_soc_dapm_widget ab8500_dapm_widgets[] = {
 	SND_SOC_DAPM_AIF_OUT("AD_OUT1", NULL, 0, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_AIF_OUT("AD_OUT2", NULL, 0, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_AIF_OUT("AD_OUT3", NULL, 0, SND_SOC_NOPM, 0, 0),
-	SND_SOC_DAPM_AIF_OUT("AD_OUT4", NULL, 0, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_AIF_OUT("AD_OUT57", NULL, 0, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_AIF_OUT("AD_OUT68", NULL, 0, SND_SOC_NOPM, 0, 0),
 
@@ -584,36 +582,6 @@ static const struct snd_soc_dapm_widget ab8500_dapm_widgets[] = {
 	SND_SOC_DAPM_SUPPLY("AD5768 Enable", AB8500_ADPATHENA,
 			    AB8500_ADPATHENA_ENAD5768, 0, NULL, 0),
 
-	/* Digital Microphone path */
-
-	SND_SOC_DAPM_INPUT("DMic 1"),
-	SND_SOC_DAPM_INPUT("DMic 2"),
-	SND_SOC_DAPM_INPUT("DMic 3"),
-	SND_SOC_DAPM_INPUT("DMic 4"),
-	SND_SOC_DAPM_INPUT("DMic 5"),
-	SND_SOC_DAPM_INPUT("DMic 6"),
-
-	SND_SOC_DAPM_MIXER("DMIC1",
-			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC1, 0,
-			NULL, 0),
-	SND_SOC_DAPM_MIXER("DMIC2",
-			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC2, 0,
-			NULL, 0),
-	SND_SOC_DAPM_MIXER("DMIC3",
-			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC3, 0,
-			NULL, 0),
-	SND_SOC_DAPM_MIXER("DMIC4",
-			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC4, 0,
-			NULL, 0),
-	SND_SOC_DAPM_MIXER("DMIC5",
-			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC5, 0,
-			NULL, 0),
-	SND_SOC_DAPM_MIXER("DMIC6",
-			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC6, 0,
-			NULL, 0),
-	SND_SOC_DAPM_MIXER("AD4 Channel Volume",
-			SND_SOC_NOPM, 0, 0,
-			NULL, 0),
 	/* Acoustical Noise Cancellation path */
 
 	SND_SOC_DAPM_MUX("ANC Source",
@@ -648,6 +616,40 @@ static const struct snd_soc_dapm_widget ab8500_dapm_widgets[] = {
 			NULL, 0),
 };
 
+static const struct snd_soc_dapm_widget ab8500_dmic_dapm_widgets[] = {
+	SND_SOC_DAPM_REGULATOR_SUPPLY("V-DMIC", 0, 0),
+	SND_SOC_DAPM_AIF_OUT("AD_OUT4", NULL, 0, SND_SOC_NOPM, 0, 0),
+
+	SND_SOC_DAPM_INPUT("DMic 1"),
+	SND_SOC_DAPM_INPUT("DMic 2"),
+	SND_SOC_DAPM_INPUT("DMic 3"),
+	SND_SOC_DAPM_INPUT("DMic 4"),
+	SND_SOC_DAPM_INPUT("DMic 5"),
+	SND_SOC_DAPM_INPUT("DMic 6"),
+
+	SND_SOC_DAPM_MIXER("DMIC1",
+			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC1, 0,
+			NULL, 0),
+	SND_SOC_DAPM_MIXER("DMIC2",
+			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC2, 0,
+			NULL, 0),
+	SND_SOC_DAPM_MIXER("DMIC3",
+			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC3, 0,
+			NULL, 0),
+	SND_SOC_DAPM_MIXER("DMIC4",
+			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC4, 0,
+			NULL, 0),
+	SND_SOC_DAPM_MIXER("DMIC5",
+			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC5, 0,
+			NULL, 0),
+	SND_SOC_DAPM_MIXER("DMIC6",
+			AB8500_DIGMICCONF, AB8500_DIGMICCONF_ENDMIC6, 0,
+			NULL, 0),
+	SND_SOC_DAPM_MIXER("AD4 Channel Volume",
+			SND_SOC_NOPM, 0, 0,
+			NULL, 0),
+};
+
 /*
  * DAPM-routes
  */
@@ -853,35 +855,6 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 	{"AD_OUT68", NULL, "Main Supply"},
 	{"AD_OUT68", NULL, "AD6 Channel Volume"},
 
-	/* Digital Microphone path */
-
-	{"DMic 1", NULL, "V-DMIC"},
-	{"DMic 2", NULL, "V-DMIC"},
-	{"DMic 3", NULL, "V-DMIC"},
-	{"DMic 4", NULL, "V-DMIC"},
-	{"DMic 5", NULL, "V-DMIC"},
-	{"DMic 6", NULL, "V-DMIC"},
-
-	{"DMIC1", NULL, "DMic 1"},
-	{"DMIC2", NULL, "DMic 2"},
-	{"DMIC3", NULL, "DMic 3"},
-	{"DMIC4", NULL, "DMic 4"},
-	{"DMIC5", NULL, "DMic 5"},
-	{"DMIC6", NULL, "DMic 6"},
-
-	{"AD1 Source Select", "DMic 1", "DMIC1"},
-	{"AD2 Source Select", "DMic 2", "DMIC2"},
-	{"AD3 Source Select", "DMic 3", "DMIC3"},
-	{"AD5 Source Select", "DMic 5", "DMIC5"},
-	{"AD6 Source Select", "DMic 6", "DMIC6"},
-
-	{"AD4 Channel Volume", NULL, "DMIC4"},
-	{"AD4 Channel Volume", NULL, "AD34 Enable"},
-
-	{"ab8500_0c", NULL, "AD_OUT4"},
-	{"AD_OUT4", NULL, "Main Supply"},
-	{"AD_OUT4", NULL, "AD4 Channel Volume"},
-
 	/* LineIn Bypass path */
 
 	{"LINL to HSL Volume", NULL, "LINL Enable"},
@@ -911,7 +884,6 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 	{"Sidetone Left Source", "Headset Left", "DA_IN1"},
 	{"Sidetone Right Source", "LineIn Right", "AD2 Channel Volume"},
 	{"Sidetone Right Source", "Mic 1", "AD3 Channel Volume"},
-	{"Sidetone Right Source", "DMic 4", "AD4 Channel Volume"},
 	{"Sidetone Right Source", "Headset Right", "DA_IN2"},
 
 	{"STFIR1 Control", NULL, "Sidetone Left Source"},
@@ -924,6 +896,37 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 	{"DA2 Enable", NULL, "STFIR2 Volume"},
 };
 
+static const struct snd_soc_dapm_route ab8500_dmic_dapm_routes[] = {
+	{"DMic 1", NULL, "V-DMIC"},
+	{"DMic 2", NULL, "V-DMIC"},
+	{"DMic 3", NULL, "V-DMIC"},
+	{"DMic 4", NULL, "V-DMIC"},
+	{"DMic 5", NULL, "V-DMIC"},
+	{"DMic 6", NULL, "V-DMIC"},
+
+	{"DMIC1", NULL, "DMic 1"},
+	{"DMIC2", NULL, "DMic 2"},
+	{"DMIC3", NULL, "DMic 3"},
+	{"DMIC4", NULL, "DMic 4"},
+	{"DMIC5", NULL, "DMic 5"},
+	{"DMIC6", NULL, "DMic 6"},
+
+	{"AD1 Source Select", "DMic 1", "DMIC1"},
+	{"AD2 Source Select", "DMic 2", "DMIC2"},
+	{"AD3 Source Select", "DMic 3", "DMIC3"},
+	{"AD5 Source Select", "DMic 5", "DMIC5"},
+	{"AD6 Source Select", "DMic 6", "DMIC6"},
+
+	{"AD4 Channel Volume", NULL, "DMIC4"},
+	{"AD4 Channel Volume", NULL, "AD34 Enable"},
+
+	{"ab8500_0c", NULL, "AD_OUT4"},
+	{"AD_OUT4", NULL, "Main Supply"},
+	{"AD_OUT4", NULL, "AD4 Channel Volume"},
+
+	{"Sidetone Right Source", "DMic 4", "AD4 Channel Volume"},
+};
+
 static const struct snd_soc_dapm_route ab8500_dapm_routes_mic1a_vamicx[] = {
 	{"MIC1A V-AMICx Enable", NULL, "V-AMIC1"},
 	{"MIC1A V-AMICx Enable", NULL, "V-AMIC2"},
@@ -2043,13 +2046,30 @@ static int ab8500_codec_probe(struct snd_soc_component *component)
 {
 	struct device *dev = component->dev;
 	struct device_node *np = dev->of_node;
+	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 	struct ab8500_codec_platform_data codec_pdata;
+	struct snd_soc_dapm_context *dapm;
 	int status;
 
 	dev_dbg(dev, "%s: Enter.\n", __func__);
 
 	ab8500_codec_of_probe(dev, np, &codec_pdata);
 
+	if (is_ab8500(ab8500)) {
+		dapm = snd_soc_component_to_dapm(component);
+		status = snd_soc_dapm_new_controls(dapm,
+						   ab8500_dmic_dapm_widgets,
+						   ARRAY_SIZE(ab8500_dmic_dapm_widgets));
+		if (status)
+			return status;
+
+		status = snd_soc_dapm_add_routes(dapm,
+						 ab8500_dmic_dapm_routes,
+						 ARRAY_SIZE(ab8500_dmic_dapm_routes));
+		if (status)
+			return status;
+	}
+
 	status = ab8500_audio_init_audioblock(component);
 	if (status < 0) {
 		dev_err(dev, "%s: failed to init audio-block (%d)!\n",
-- 
2.53.0



