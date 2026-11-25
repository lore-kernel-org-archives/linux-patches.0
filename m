Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622020;
	b=THjy1C85OiGWOs5sVcyWjztC4QuC42kQJ6Bf/vxE08MqzvMGwZHXb5EtTzHAS3lj60y5
	 TxzlVW3Yb5wXWjNKeSe7xPVLd8dWF2orwTjW2sHyj+dxjkP9Btvq5vX9Ybv2t09RyD2Pu
	 o+YDQbgV4x4ab9uLzd9jmJEYPSpJBDCmvbDuzW0mOIfharcQOR5YCuYccaSNLZ69iw2+y
	 NEqpYaDf8hnC6OpvMs8EmjoUb0mGYzFDJg7RG3HhUWEviez/Js7+1acfZpBkrMK7xCq/s
	 fKybS9plxZEWKnomAQtscS0fmV3C27c/ccxHHh0ORGnBSMwcsFYC/VGpU91LCnsoOkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XEaFl2781q84roaIM8T4OQcDTbeeWB+IVgnBqc4CVQs=;
	b=yQiBGKO+TNCm1JgF1KXXMD673rUUkw7WIImJTYHdmYnKXjvSASJ6GLRSVWm2IMPikDPB
	 7UfuhA5lJhmbEpCsl59pC6ywSzoHKyrAeSrTNy2bcmpV8g3/SHhBo5fDCTSCw+9mqkj8B
	 m8VOvyO/Nmwk7pEfEPhCoyzm4+iFr8eP43C95aA7vDya6s9Ace5EPBLlEXLTDciPnLcaJ
	 DPW/ks3/HdZk7toeo745e9onC9FiLNRf2HLGmGubr/OCf0g4eELvOCTyN2771hXpJlGcp
	 QuE/cqSuhBLSWwYqB7OZ1iKC2FPoKmxwtXvlM4WcqEPP7xOTSshb6QbOnmRVUEcB+KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWULr6io;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C61606A327;
	Wed, 25 Nov 2026 15:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWULr6io
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7031E1F000CF;
	Wed, 25 Nov 2026 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622020;
	bh=XEaFl2781q84roaIM8T4OQcDTbeeWB+IVgnBqc4CVQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWULr6ioVlP8ijafO0Ctzh0n/S4QRsS1H53fxmbpRuweF/3web8r6X5U6xKCkaM0H
	 0OI0Fw0CxvuLzkJUHUvvp1eUQyWWh604ITmy4ARUwGIWDE7qK+q+HCk4cY9dFOai11
	 Ag2cKDxC9inVHaqRytVOWw26MpQAYKG6AZ4IO+oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyang Zhao <hongyang.zhao@thundersoft.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 360/990] ASoC: qcom: common: Add generic headset jack helpers
Date: Wed, 25 Nov 2026 15:28:47 +0100
Message-ID: <20261125143830.523405491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Hongyang Zhao <hongyang.zhao@thundersoft.com>

[ Upstream commit 7f8dd07370f8c17f8f98f0fa98691635828b0dac ]

qcom_snd_wcd_jack_setup() combines creation of the card-level headset
jack with the WCD-specific operation of attaching jack detection to
codecs on the TX codec DMA links. External codecs connected over MI2S
also provide component jack detection, but cannot use the WCD-specific
DAI filtering.

Factor the common jack allocation, DAPM pin registration and headset
button mappings into a private initializer. Reuse it from the existing
WCD path and add a generic setup helper which attaches the jack to every
codec component in a runtime.

Treat -ENOTSUPP as a no-op because snd_soc_component_set_jack() uses it
for components which do not provide a set_jack callback.

Add a matching cleanup helper so machine drivers can detach component
jack detection when the DAI link exits. The WCD setup behavior remains
unchanged.

Signed-off-by: Hongyang Zhao <hongyang.zhao@thundersoft.com>
Link: https://patch.msgid.link/20260904-rubikpi-next-20260605-v3-3-f49146d85af3@thundersoft.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 704251f9dad3 ("ASoC: qcom: x1e80100: recreate the headset jack on card rebind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/common.c | 61 +++++++++++++++++++++++++++++++++++------
 sound/soc/qcom/common.h |  3 ++
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/sound/soc/qcom/common.c b/sound/soc/qcom/common.c
index b021537f27ff1..71cbdd1a44ca2 100644
--- a/sound/soc/qcom/common.c
+++ b/sound/soc/qcom/common.c
@@ -356,13 +356,11 @@ static struct snd_soc_jack_pin qcom_headset_jack_pins[] = {
 	},
 };
 
-int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
-			    struct snd_soc_jack *jack, bool *jack_setup)
+static int qcom_snd_headset_jack_init(struct snd_soc_card *card,
+				      struct snd_soc_jack *jack,
+				      bool *jack_setup)
 {
-	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
-	struct snd_soc_dai *codec_dai = snd_soc_rtd_to_codec(rtd, 0);
-	struct snd_soc_card *card = rtd->card;
-	int rval, i;
+	int rval;
 
 	if (!*jack_setup) {
 		rval = snd_soc_card_jack_new_pins(card, "Headset Jack",
@@ -386,6 +384,55 @@ int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
 		*jack_setup = true;
 	}
 
+	return 0;
+}
+
+int qcom_snd_headset_jack_setup(struct snd_soc_pcm_runtime *rtd,
+				struct snd_soc_jack *jack, bool *jack_setup)
+{
+	struct snd_soc_dai *codec_dai;
+	struct snd_soc_card *card = rtd->card;
+	int rval, i;
+
+	rval = qcom_snd_headset_jack_init(card, jack, jack_setup);
+	if (rval)
+		return rval;
+
+	for_each_rtd_codec_dais(rtd, i, codec_dai) {
+		rval = snd_soc_component_set_jack(codec_dai->component, jack, NULL);
+		if (rval != 0 && rval != -ENOTSUPP) {
+			dev_warn(card->dev, "Failed to set jack: %d\n", rval);
+			qcom_snd_headset_jack_cleanup(rtd);
+			return rval;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qcom_snd_headset_jack_setup);
+
+void qcom_snd_headset_jack_cleanup(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_soc_dai *codec_dai;
+	int i;
+
+	for_each_rtd_codec_dais(rtd, i, codec_dai)
+		snd_soc_component_set_jack(codec_dai->component, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(qcom_snd_headset_jack_cleanup);
+
+int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
+			    struct snd_soc_jack *jack, bool *jack_setup)
+{
+	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
+	struct snd_soc_dai *codec_dai = snd_soc_rtd_to_codec(rtd, 0);
+	struct snd_soc_card *card = rtd->card;
+	int rval, i;
+
+	rval = qcom_snd_headset_jack_init(card, jack, jack_setup);
+	if (rval)
+		return rval;
+
 	switch (cpu_dai->id) {
 	case TX_CODEC_DMA_TX_0:
 	case TX_CODEC_DMA_TX_1:
@@ -404,8 +451,6 @@ int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
 	default:
 		break;
 	}
-
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_snd_wcd_jack_setup);
diff --git a/sound/soc/qcom/common.h b/sound/soc/qcom/common.h
index 02b24caec485e..6705e135ccd77 100644
--- a/sound/soc/qcom/common.h
+++ b/sound/soc/qcom/common.h
@@ -24,6 +24,9 @@ int qcom_snd_apply_dai_tdm_slots_cfg(struct snd_soc_pcm_runtime *rtd,
 				     const struct qcom_snd_tdm_slot_cfg *cpu_cfg,
 				     const struct qcom_snd_tdm_slot_cfg *codec_cfg);
 int qcom_snd_apply_dai_tdm_slots(struct snd_soc_pcm_runtime *rtd);
+int qcom_snd_headset_jack_setup(struct snd_soc_pcm_runtime *rtd,
+				struct snd_soc_jack *jack, bool *jack_setup);
+void qcom_snd_headset_jack_cleanup(struct snd_soc_pcm_runtime *rtd);
 int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
 			    struct snd_soc_jack *jack, bool *jack_setup);
 int qcom_snd_dp_jack_setup(struct snd_soc_pcm_runtime *rtd,
-- 
2.53.0



