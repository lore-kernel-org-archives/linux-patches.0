Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618998;
	b=EEaz7QVL5IDsBpScOUn3YC7Ap8JH5Wr+OQAAR1sRVC5WDqNIehAqosiKoJcHKbDt5BbL
	 pAMmmTg6lwSptUOr4BreQGtK1y+8h76QTOKrQdehTBB2Slx8PSTdV/h76Kvh5HpGuBJKd
	 RjDugWkk2SBugjjsohEccdqe1ggHmXaoMjiSmHLyJuoqGLub8ACJmjpwR0lPGxgzbW5Qo
	 ZIhtAPsBCYWO5sljTM44flzb1/EYIFIId3MwJiU2bHLN66gZd0+hQA75jLEDZIKAAreZw
	 xcber+AbnjACqPuyZjia7+wFUizs87EaAM2iMcT8G9GnWpuSsFWj6I55BdXn1tNnqzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NqdWVg8WMp64IIbEAmREh89qwN4CadowftcMcS8OLDE=;
	b=X6q9t9Gg7zJvkr7kgmQCVCvtO4lafuem2wJqUmTxZyCSV8OztcS5dHy8OZrzuXQmD6/I
	 IO5VRGTAHefUHcsGp02fEgt7PKk50eH0UM0drxglDUyPQJXsOCYdl0ask8gpdjUc9FGPU
	 RondpW4X03FpIaLDGDn1+C8a1zHlS9q8wKd3exkbl8Y36WHVkEukaRt6jph9fsqlzCIsv
	 Jb8KIR3CuhJ+HEUZM3bUvYLAe4XG1+IUKtC2x95abepyg52K1R+LzJxIREVVRS5aIA5d7
	 pjfwF2p4OauYLlQfT6pO15THRGqzI6IFU8MAw+difzA8MXYMMH/zRA8gwaWYLydhBMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Me4UNLRu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA31606A33A;
	Wed, 25 Nov 2026 15:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Me4UNLRu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3411F0093E;
	Wed, 25 Nov 2026 15:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618997;
	bh=NqdWVg8WMp64IIbEAmREh89qwN4CadowftcMcS8OLDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Me4UNLRuXZeZRTroHkCRSz4+bUCC6WnUi2i+IAIsfJmd1UqsU+aocqh17lMUJWyX1
	 Vh/XZnSZNd1l1awqPXp68+DhfBb2mSKcU9nYhLMhqWb5q35J1h2Cud+y86aj82U9wg
	 RJM59O+LRtA+ITFI58kcJk+Vtmvrh2Jmyb39llR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyang Zhao <hongyang.zhao@thundersoft.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0411/1005] ASoC: qcom: common: Add generic headset jack helpers
Date: Wed, 25 Nov 2026 15:29:09 +0100
Message-ID: <20261125143831.379903766@linuxfoundation.org>
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
index d9f256d519733..83b745f617a86 100644
--- a/sound/soc/qcom/common.c
+++ b/sound/soc/qcom/common.c
@@ -339,13 +339,11 @@ static struct snd_soc_jack_pin qcom_headset_jack_pins[] = {
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
@@ -369,6 +367,55 @@ int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
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
 	case LPI_MI2S_RX_0:
 	case TX_CODEC_DMA_TX_0:
@@ -388,8 +435,6 @@ int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
 	default:
 		break;
 	}
-
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_snd_wcd_jack_setup);
diff --git a/sound/soc/qcom/common.h b/sound/soc/qcom/common.h
index c1deac109f243..b6204a32bd64c 100644
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



