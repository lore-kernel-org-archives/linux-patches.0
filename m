Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023890;
	b=nv0hrDYClmZw0fBkO7vOBrqTuE6+1THsBpSCXHnPP+lfet8HUkXxmwj1yvNQDv2jA/i8
	 6qVEQb44k/X016B+c76ZdOCNFob5wHXXL8JPejEMwW8ZY6CUcifubCiHn2O2kRH1Q7Vw1
	 X0k/pFnyyWniZRU4qknIgbIEZqN1VMQ6wIeD/dnBn3tsGQN2BIxd9DfISsP0M2zuEFAAI
	 vQZ4vnN6kjvYuJAQljDANGy3FOMHqA4pCvi/K0XsY7BcD6D5ufaTbsvCoqVODv9gIG0lA
	 +EUL4lG11LnHD9C9Qw8YoZEn5WWFeUS2NNmYX9iOeLTnKNgiqX0u/iaPcMN5Q1mLgZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XNAUrxDjuxafWhJCgUW6j6WJbX+82+hjVrLvSE6L/+c=;
	b=4m17L2kdEA2oxegHyh1KXqIeBOCNy3YUYXgG0rhDybZvQV1cGH86VJutu9uXkS+/CBpT
	 2RypNh+OhP+1QJlAc8In3YV5RRExzIMMzVO7kG9mUUKbNeOngHCNLbAi0lk7d8Ecl81R9
	 JU+ob3sDOHL62IOrvfK3/G+X9KGqbWNuFWpC/BAQUsBXzF2sUftj/iK4lAc19W7JsntTV
	 1UQJ/lbW8fpdk61Nq8qlqruxgoPqTCq0G3nppGEbwmsL73VXVSisFhpu4l8Pl6JjDpVqv
	 IuC2m9aKLyUFCeKtTxhODhQLVZCc354MVQiblpkCDCmMO1PcGBfj8r7t41tm99N77DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eUCcj7uA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57C1606A320;
	Wed, 18 Nov 2026 17:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eUCcj7uA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E181F000C4;
	Wed, 18 Nov 2026 17:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023890;
	bh=XNAUrxDjuxafWhJCgUW6j6WJbX+82+hjVrLvSE6L/+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUCcj7uAW3c6T1m5ymUk7iZ74X2GexCb+plcvg3Wvc4WFSpxCUxDIHaEh3XvFmds4
	 QA9x6iz+SFEfkRkonS9fvgh+tIA2k9D7y6gM2f0NWH3b7wQhGpuwN64M6yA/agi0gZ
	 AKLcxBNNYy0Nk3DyTjnh6d9c52F0akW12JPh6j+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0531/2151] ASoC: codecs: ab8500: convert to snd_soc_dapm_xxx()
Date: Wed, 18 Nov 2026 15:37:46 +0100
Message-ID: <20261118150141.364621042@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit cdc8feb84f7f22a9b21483b706382cea3cd248cd ]

This patch converts below functions.

dapm->dev					-> snd_soc_dapm_to_dev()
dapm->card					-> snd_soc_dapm_to_card()
dapm->component					-> snd_soc_dapm_to_component()

dapm_kcontrol_get_value()			-> snd_soc_dapm_kcontrol_get_value()

snd_soc_component_enable_pin()			-> snd_soc_dapm_enable_pin()
snd_soc_component_enable_pin_unlocked()		-> snd_soc_dapm_enable_pin_unlocked()
snd_soc_component_disable_pin()			-> snd_soc_dapm_disable_pin()
snd_soc_component_disable_pin_unlocked()	-> snd_soc_dapm_disable_pin_unlocked()
snd_soc_component_nc_pin()			-> snd_soc_dapm_nc_pin()
snd_soc_component_nc_pin_unlocked()		-> snd_soc_dapm_nc_pin_unlocked()
snd_soc_component_get_pin_status()		-> snd_soc_dapm_get_pin_status()
snd_soc_component_force_enable_pin()		-> snd_soc_dapm_force_enable_pin()
snd_soc_component_force_enable_pin_unlocked()	-> snd_soc_dapm_force_enable_pin_unlocked()
snd_soc_component_force_bias_level()		-> snd_soc_dapm_force_bias_level()
snd_soc_component_get_bias_level()		-> snd_soc_dapm_get_bias_level()
snd_soc_component_init_bias_level()		-> snd_soc_dapm_init_bias_level()
snd_soc_component_get_dapm()			-> snd_soc_component_to_dapm()

snd_soc_dapm_kcontrol_component()		-> snd_soc_dapm_kcontrol_to_component()
snd_soc_dapm_kcontrol_widget()			-> snd_soc_dapm_kcontrol_to_widget()
snd_soc_dapm_kcontrol_dapm()			-> snd_soc_dapm_kcontrol_to_dapm()
snd_soc_dapm_np_pin()				-> snd_soc_dapm_disable_pin()

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/87tsz18lru.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0d46182a1be7 ("ASoC: ab8500: Skip digital microphone support on AB8505")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 99e6772efc608..0c070ab489292 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -1189,7 +1189,7 @@ static int anc_status_control_put(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
-	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(component->dev);
 	struct device *dev = component->dev;
 	bool apply_fir, apply_iir;
@@ -1926,7 +1926,7 @@ static int ab8500_audio_init_audioblock(struct snd_soc_component *component)
 static int ab8500_audio_setup_mics(struct snd_soc_component *component,
 			struct amic_settings *amics)
 {
-	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	u8 value8;
 	unsigned int value;
 	int status;
@@ -2424,7 +2424,7 @@ static void ab8500_codec_of_probe(struct device *dev, struct device_node *np,
 
 static int ab8500_codec_probe(struct snd_soc_component *component)
 {
-	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct device *dev = component->dev;
 	struct device_node *np = dev->of_node;
 	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(dev);
-- 
2.53.0



