Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F7B279345;
	Wed, 23 Apr 2025 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420598; cv=none; b=GTxQnfZcKDSi551XKyTe2/7ZTCHP5iC7e24qDH4lK2AVbv0uWWKE3uraRJbGykYyS7XFGgzhiFxzvS9hA0U+ss6BsFEPfTBzP9e49y/YlUaQ5FU93H2cJTacF2lsOe1tiDtzWXihZdm8stjcjNzY/A+rpcKDgpyP+GsUTtkBizk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420598; c=relaxed/simple;
	bh=k0D0ps6qVfUEtLu++wEmkG+cAV5PqsuhoEWBBFDLFQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEFBVvjjAqtPoR/bIKz7XndIfADP/eHBbmzM8B4R/SK2H+2BlJp7s6d/7+pIeNLLn0YAUKLahPIJxEgXsQ4vvGGNsaGHHF9je0WUMRKaD+hGz2FTzMSjmY6nLKLwPHNMYwrdzJacoY6tUi+DyJ0zNjfPxrYFgw+6q48SMZrwCm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p42kVhjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p42kVhjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08704C4CEE3;
	Wed, 23 Apr 2025 15:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420598;
	bh=k0D0ps6qVfUEtLu++wEmkG+cAV5PqsuhoEWBBFDLFQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p42kVhjEziYzdkgtWvnUI3aWbj8aF7l7+9VOb1FVNYhp44yQYnN20mv46kHynXf6s
	 P560mxlZPTqmwoks7axi2GbcUP3PRT1Ubef/mjBQ1NtcIuCC5//wD7m/Pqu9yHncvY
	 F3kBSbeuwAbM3HsEqAS8bRTjApWQ+ji3Sw1WdnKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikantan R <quic_manrav@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 106/241] ASoC: codecs:lpass-wsa-macro: Fix logic of enabling vi channels
Date: Wed, 23 Apr 2025 16:42:50 +0200
Message-ID: <20250423142624.907501170@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit 7648beb65600220996ebb2da207610b1ff9b735e upstream.

Existing code only configures one of WSA_MACRO_TX0 or WSA_MACRO_TX1
paths eventhough we enable both of them. Fix this bug by adding proper
checks and rearranging some of the common code to able to allow setting
both TX0 and TX1 paths

Without this patch only one channel gets enabled in VI path instead of 2
channels. End result would be 1 channel recording instead of 2.

Fixes: 2c4066e5d428 ("ASoC: codecs: lpass-wsa-macro: add dapm widgets and route")
Cc: stable@vger.kernel.org
Co-developed-by: Manikantan R <quic_manrav@quicinc.com>
Signed-off-by: Manikantan R <quic_manrav@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20250403160209.21613-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/lpass-wsa-macro.c |  108 +++++++++++++++++++++----------------
 1 file changed, 63 insertions(+), 45 deletions(-)

--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -1459,6 +1459,67 @@ static void wsa_macro_mclk_enable(struct
 	}
 }
 
+static void wsa_macro_enable_disable_vi_sense(struct snd_soc_component *component, bool enable,
+						u32 tx_reg0, u32 tx_reg1, u32 val)
+{
+	if (enable) {
+		/* Enable V&I sensing */
+		snd_soc_component_update_bits(component, tx_reg0,
+					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
+					      CDC_WSA_TX_SPKR_PROT_RESET);
+		snd_soc_component_update_bits(component, tx_reg1,
+					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
+					      CDC_WSA_TX_SPKR_PROT_RESET);
+		snd_soc_component_update_bits(component, tx_reg0,
+					      CDC_WSA_TX_SPKR_PROT_PCM_RATE_MASK,
+					      val);
+		snd_soc_component_update_bits(component, tx_reg1,
+					      CDC_WSA_TX_SPKR_PROT_PCM_RATE_MASK,
+					      val);
+		snd_soc_component_update_bits(component, tx_reg0,
+					      CDC_WSA_TX_SPKR_PROT_CLK_EN_MASK,
+					      CDC_WSA_TX_SPKR_PROT_CLK_ENABLE);
+		snd_soc_component_update_bits(component, tx_reg1,
+					      CDC_WSA_TX_SPKR_PROT_CLK_EN_MASK,
+					      CDC_WSA_TX_SPKR_PROT_CLK_ENABLE);
+		snd_soc_component_update_bits(component, tx_reg0,
+					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
+					      CDC_WSA_TX_SPKR_PROT_NO_RESET);
+		snd_soc_component_update_bits(component, tx_reg1,
+					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
+					      CDC_WSA_TX_SPKR_PROT_NO_RESET);
+	} else {
+		snd_soc_component_update_bits(component, tx_reg0,
+					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
+					      CDC_WSA_TX_SPKR_PROT_RESET);
+		snd_soc_component_update_bits(component, tx_reg1,
+					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
+					      CDC_WSA_TX_SPKR_PROT_RESET);
+		snd_soc_component_update_bits(component, tx_reg0,
+					      CDC_WSA_TX_SPKR_PROT_CLK_EN_MASK,
+					      CDC_WSA_TX_SPKR_PROT_CLK_DISABLE);
+		snd_soc_component_update_bits(component, tx_reg1,
+					      CDC_WSA_TX_SPKR_PROT_CLK_EN_MASK,
+					      CDC_WSA_TX_SPKR_PROT_CLK_DISABLE);
+	}
+}
+
+static void wsa_macro_enable_disable_vi_feedback(struct snd_soc_component *component,
+						 bool enable, u32 rate)
+{
+	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
+
+	if (test_bit(WSA_MACRO_TX0, &wsa->active_ch_mask[WSA_MACRO_AIF_VI]))
+		wsa_macro_enable_disable_vi_sense(component, enable,
+				CDC_WSA_TX0_SPKR_PROT_PATH_CTL,
+				CDC_WSA_TX1_SPKR_PROT_PATH_CTL, rate);
+
+	if (test_bit(WSA_MACRO_TX1, &wsa->active_ch_mask[WSA_MACRO_AIF_VI]))
+		wsa_macro_enable_disable_vi_sense(component, enable,
+				CDC_WSA_TX2_SPKR_PROT_PATH_CTL,
+				CDC_WSA_TX3_SPKR_PROT_PATH_CTL, rate);
+}
+
 static int wsa_macro_mclk_event(struct snd_soc_dapm_widget *w,
 				struct snd_kcontrol *kcontrol, int event)
 {
@@ -1475,7 +1536,6 @@ static int wsa_macro_enable_vi_feedback(
 {
 	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
-	u32 tx_reg0, tx_reg1;
 	u32 rate_val;
 
 	switch (wsa->pcm_rate_vi) {
@@ -1499,56 +1559,14 @@ static int wsa_macro_enable_vi_feedback(
 		break;
 	}
 
-	if (test_bit(WSA_MACRO_TX0, &wsa->active_ch_mask[WSA_MACRO_AIF_VI])) {
-		tx_reg0 = CDC_WSA_TX0_SPKR_PROT_PATH_CTL;
-		tx_reg1 = CDC_WSA_TX1_SPKR_PROT_PATH_CTL;
-	} else if (test_bit(WSA_MACRO_TX1, &wsa->active_ch_mask[WSA_MACRO_AIF_VI])) {
-		tx_reg0 = CDC_WSA_TX2_SPKR_PROT_PATH_CTL;
-		tx_reg1 = CDC_WSA_TX3_SPKR_PROT_PATH_CTL;
-	}
-
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
 		/* Enable V&I sensing */
-		snd_soc_component_update_bits(component, tx_reg0,
-					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
-					      CDC_WSA_TX_SPKR_PROT_RESET);
-		snd_soc_component_update_bits(component, tx_reg1,
-					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
-					      CDC_WSA_TX_SPKR_PROT_RESET);
-		snd_soc_component_update_bits(component, tx_reg0,
-					      CDC_WSA_TX_SPKR_PROT_PCM_RATE_MASK,
-					      rate_val);
-		snd_soc_component_update_bits(component, tx_reg1,
-					      CDC_WSA_TX_SPKR_PROT_PCM_RATE_MASK,
-					      rate_val);
-		snd_soc_component_update_bits(component, tx_reg0,
-					      CDC_WSA_TX_SPKR_PROT_CLK_EN_MASK,
-					      CDC_WSA_TX_SPKR_PROT_CLK_ENABLE);
-		snd_soc_component_update_bits(component, tx_reg1,
-					      CDC_WSA_TX_SPKR_PROT_CLK_EN_MASK,
-					      CDC_WSA_TX_SPKR_PROT_CLK_ENABLE);
-		snd_soc_component_update_bits(component, tx_reg0,
-					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
-					      CDC_WSA_TX_SPKR_PROT_NO_RESET);
-		snd_soc_component_update_bits(component, tx_reg1,
-					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
-					      CDC_WSA_TX_SPKR_PROT_NO_RESET);
+		wsa_macro_enable_disable_vi_feedback(component, true, rate_val);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		/* Disable V&I sensing */
-		snd_soc_component_update_bits(component, tx_reg0,
-					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
-					      CDC_WSA_TX_SPKR_PROT_RESET);
-		snd_soc_component_update_bits(component, tx_reg1,
-					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
-					      CDC_WSA_TX_SPKR_PROT_RESET);
-		snd_soc_component_update_bits(component, tx_reg0,
-					      CDC_WSA_TX_SPKR_PROT_CLK_EN_MASK,
-					      CDC_WSA_TX_SPKR_PROT_CLK_DISABLE);
-		snd_soc_component_update_bits(component, tx_reg1,
-					      CDC_WSA_TX_SPKR_PROT_CLK_EN_MASK,
-					      CDC_WSA_TX_SPKR_PROT_CLK_DISABLE);
+		wsa_macro_enable_disable_vi_feedback(component, false, rate_val);
 		break;
 	}
 


