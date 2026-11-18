Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023904;
	b=mHPmbNQU2Rds0UpJbU1HP+WIYI7fH7NEsLbllzJ/b/1VrxlaFECoqy/Iy1zXdU62mI1w
	 S4MOaGKfWF8NmgCo/FPa9N4FKoiqvLauUqvP5Rakj7tXA+rOjZTBiB6Ttn9E9x8JDY4DJ
	 6UOYw86N/+/dWxvnXKVIhVVQzdx2q8GXkEncA9TAKTNd2wjcF3bhYpRZCyNO1w/8BgZiG
	 s/g1IszsF51EUjSHbbXRJDxDuogimP+ekf7KQe6E1RNSEBLFP/0wGbdsgFXcr854aYQO9
	 tD5Gk7jC3GkRQZRVsD0w9uCDw5DrfDw7yaXsx5j7AhkfaGddFbplbMNO5G/9Rx/oS4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Funxdd72ISH4sFq/rHrbNZxcDwrmvHVVRVBftEgpAOc=;
	b=HdjxU4xjlgRqyH0b86NsCEnac3FkCpNAD+DLDkw/85Ev+eO5qnEqoxurl12Ii8rdONq6
	 +iiRG8bUqFoEaNzbEP8jOZU3/ihxwDPS4lN75+sz2cPbEKwJMSmJQnSl7RM9VHnsbTbyH
	 MYstlTyTztXKj7HkUcuo0F/x3gd0cdOlr/F0ehuWmZxJjADnimmnEhKErN8Hp8zfJJabf
	 pKCS+ydEAZIKWlL9EyU+/JM1nVog0oPApyh218jW2LXdmJzkk4G+qU0Nov8K889vjBLeu
	 nJQ4IT9TTAQSe6gNPownqZga6FiMt+DSeLQ8k5b7v6ho0DRME159b2OTOTLq6Ms8u9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WF5yTNjC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6109606A32A;
	Wed, 18 Nov 2026 17:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WF5yTNjC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071BD1F000C5;
	Wed, 18 Nov 2026 17:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023904;
	bh=Funxdd72ISH4sFq/rHrbNZxcDwrmvHVVRVBftEgpAOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WF5yTNjCDS8PqNyIwGTqeKocrtNrh0slLRD7lN5LB39s7hLOCg72a4n359A9VDbEy
	 OQwTUYMdMBjdspuWYYkrJUYYOwFwnpJoGliKSm+Ovpbl2nNQGEBgjq09UxbpFFNz5E
	 X4ZXxY4U0Z+As4xWQjjnmPnGmMb8tI74kzW0djJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0535/2151] ASoC: ab8500: Skip digital microphone support on AB8505
Date: Wed, 18 Nov 2026 15:37:50 +0100
Message-ID: <20261118150141.497269656@linuxfoundation.org>
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
index 11142d15df450..a3197d0a9c36f 100644
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
@@ -2040,13 +2043,30 @@ static int ab8500_codec_probe(struct snd_soc_component *component)
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



