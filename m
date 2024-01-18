Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AC123767;
	Thu, 18 Jan 2024 10:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575201; cv=none; b=DLfWxJg2OGhH4TA/ilZZ8lV5DOS9wA4b3zxgIyFiJPvOIN1grG4P5865trTHM69s6bHJ0Z0FhYsK+2/FCkw6Vmfc+DkWqkvo4UYjw/bIv8Mh/bjpA4VltL81JQoT04p85xV4oAZZmQLsWdfbu2CbSz+oUzgF+QNeXQXKHXME2qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575201; c=relaxed/simple;
	bh=BbgYcsvLj/1DeWT7Kffc3MEz5B8SOHzJOPY7SaWeo8A=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=VH84S6xvPWz8n59nE8Y0J1JkVUYZafOUxsnauMd3n/mOq7cVTS2zrbViNrxaTwVgBAW2gstVb2RxAt8D9TSAXVUKTHswkFxq6PpgIKkKhMdHSBhLnlq2cDCKvDMLUZWXDieM06QI/enaLdeG82GsH1N6HpqlulgRuDiH4lPovi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXBJRWUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXBJRWUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD7FC433F1;
	Thu, 18 Jan 2024 10:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575201;
	bh=BbgYcsvLj/1DeWT7Kffc3MEz5B8SOHzJOPY7SaWeo8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXBJRWUdrpZrGHoOdjAJFPDb8Zhi7aJFEL8nZdr60SRYgCwOfOwyrgkYHMyD429Li
	 KABDoO0P+QGUKGJA0+LClouAlcGJSHmcjzd8lREDx8PUiIuVZdwJsLbWlC9Dcjsxuu
	 68Coct7l+/n4TA3IpLMy8Tjml6MENSBftSFnChBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/150] ASoC: SOF: ipc4-topology: Correct data structures for the GAIN module
Date: Thu, 18 Jan 2024 11:47:49 +0100
Message-ID: <20240118104322.194905706@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit e238b68e6dc89ddab52bd98216fe5623e94792b1 ]

Move the base_cfg to struct sof_ipc4_gain_data. This struct
describes the message payload passed to the firmware via the mailbox.

It is not wise to be 'clever' and try to use the first part of a struct
as IPC message without marking the message section as packed and aligned.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20231129131411.27516-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-control.c  | 20 ++++++++++----------
 sound/soc/sof/ipc4-topology.c | 31 +++++++++++++++----------------
 sound/soc/sof/ipc4-topology.h | 18 +++++++++++++-----
 3 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/sound/soc/sof/ipc4-control.c b/sound/soc/sof/ipc4-control.c
index c6d404d44097..e4ce1b53fba6 100644
--- a/sound/soc/sof/ipc4-control.c
+++ b/sound/soc/sof/ipc4-control.c
@@ -89,7 +89,7 @@ sof_ipc4_set_volume_data(struct snd_sof_dev *sdev, struct snd_sof_widget *swidge
 	struct sof_ipc4_control_data *cdata = scontrol->ipc_control_data;
 	struct sof_ipc4_gain *gain = swidget->private;
 	struct sof_ipc4_msg *msg = &cdata->msg;
-	struct sof_ipc4_gain_data data;
+	struct sof_ipc4_gain_params params;
 	bool all_channels_equal = true;
 	u32 value;
 	int ret, i;
@@ -109,20 +109,20 @@ sof_ipc4_set_volume_data(struct snd_sof_dev *sdev, struct snd_sof_widget *swidge
 	 */
 	for (i = 0; i < scontrol->num_channels; i++) {
 		if (all_channels_equal) {
-			data.channels = SOF_IPC4_GAIN_ALL_CHANNELS_MASK;
-			data.init_val = cdata->chanv[0].value;
+			params.channels = SOF_IPC4_GAIN_ALL_CHANNELS_MASK;
+			params.init_val = cdata->chanv[0].value;
 		} else {
-			data.channels = cdata->chanv[i].channel;
-			data.init_val = cdata->chanv[i].value;
+			params.channels = cdata->chanv[i].channel;
+			params.init_val = cdata->chanv[i].value;
 		}
 
 		/* set curve type and duration from topology */
-		data.curve_duration_l = gain->data.curve_duration_l;
-		data.curve_duration_h = gain->data.curve_duration_h;
-		data.curve_type = gain->data.curve_type;
+		params.curve_duration_l = gain->data.params.curve_duration_l;
+		params.curve_duration_h = gain->data.params.curve_duration_h;
+		params.curve_type = gain->data.params.curve_type;
 
-		msg->data_ptr = &data;
-		msg->data_size = sizeof(data);
+		msg->data_ptr = &params;
+		msg->data_size = sizeof(params);
 
 		ret = sof_ipc4_set_get_kcontrol_data(scontrol, true, lock);
 		msg->data_ptr = NULL;
diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 42f6a99935d1..2c075afd237c 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -128,12 +128,12 @@ static const struct sof_topology_token comp_ext_tokens[] = {
 
 static const struct sof_topology_token gain_tokens[] = {
 	{SOF_TKN_GAIN_RAMP_TYPE, SND_SOC_TPLG_TUPLE_TYPE_WORD,
-		get_token_u32, offsetof(struct sof_ipc4_gain_data, curve_type)},
+		get_token_u32, offsetof(struct sof_ipc4_gain_params, curve_type)},
 	{SOF_TKN_GAIN_RAMP_DURATION,
 		SND_SOC_TPLG_TUPLE_TYPE_WORD, get_token_u32,
-		offsetof(struct sof_ipc4_gain_data, curve_duration_l)},
+		offsetof(struct sof_ipc4_gain_params, curve_duration_l)},
 	{SOF_TKN_GAIN_VAL, SND_SOC_TPLG_TUPLE_TYPE_WORD,
-		get_token_u32, offsetof(struct sof_ipc4_gain_data, init_val)},
+		get_token_u32, offsetof(struct sof_ipc4_gain_params, init_val)},
 };
 
 /* SRC */
@@ -721,15 +721,15 @@ static int sof_ipc4_widget_setup_comp_pga(struct snd_sof_widget *swidget)
 
 	swidget->private = gain;
 
-	gain->data.channels = SOF_IPC4_GAIN_ALL_CHANNELS_MASK;
-	gain->data.init_val = SOF_IPC4_VOL_ZERO_DB;
+	gain->data.params.channels = SOF_IPC4_GAIN_ALL_CHANNELS_MASK;
+	gain->data.params.init_val = SOF_IPC4_VOL_ZERO_DB;
 
-	ret = sof_ipc4_get_audio_fmt(scomp, swidget, &gain->available_fmt, &gain->base_config);
+	ret = sof_ipc4_get_audio_fmt(scomp, swidget, &gain->available_fmt, &gain->data.base_config);
 	if (ret)
 		goto err;
 
-	ret = sof_update_ipc_object(scomp, &gain->data, SOF_GAIN_TOKENS, swidget->tuples,
-				    swidget->num_tuples, sizeof(gain->data), 1);
+	ret = sof_update_ipc_object(scomp, &gain->data.params, SOF_GAIN_TOKENS,
+				    swidget->tuples, swidget->num_tuples, sizeof(gain->data), 1);
 	if (ret) {
 		dev_err(scomp->dev, "Parsing gain tokens failed\n");
 		goto err;
@@ -737,8 +737,8 @@ static int sof_ipc4_widget_setup_comp_pga(struct snd_sof_widget *swidget)
 
 	dev_dbg(scomp->dev,
 		"pga widget %s: ramp type: %d, ramp duration %d, initial gain value: %#x\n",
-		swidget->widget->name, gain->data.curve_type, gain->data.curve_duration_l,
-		gain->data.init_val);
+		swidget->widget->name, gain->data.params.curve_type,
+		gain->data.params.curve_duration_l, gain->data.params.init_val);
 
 	ret = sof_ipc4_widget_setup_msg(swidget, &gain->msg);
 	if (ret)
@@ -1822,7 +1822,7 @@ static int sof_ipc4_prepare_gain_module(struct snd_sof_widget *swidget,
 	u32 out_ref_rate, out_ref_channels, out_ref_valid_bits;
 	int ret;
 
-	ret = sof_ipc4_init_input_audio_fmt(sdev, swidget, &gain->base_config,
+	ret = sof_ipc4_init_input_audio_fmt(sdev, swidget, &gain->data.base_config,
 					    pipeline_params, available_fmt);
 	if (ret < 0)
 		return ret;
@@ -1832,7 +1832,7 @@ static int sof_ipc4_prepare_gain_module(struct snd_sof_widget *swidget,
 	out_ref_channels = SOF_IPC4_AUDIO_FORMAT_CFG_CHANNELS_COUNT(in_fmt->fmt_cfg);
 	out_ref_valid_bits = SOF_IPC4_AUDIO_FORMAT_CFG_V_BIT_DEPTH(in_fmt->fmt_cfg);
 
-	ret = sof_ipc4_init_output_audio_fmt(sdev, &gain->base_config, available_fmt,
+	ret = sof_ipc4_init_output_audio_fmt(sdev, &gain->data.base_config, available_fmt,
 					     out_ref_rate, out_ref_channels, out_ref_valid_bits);
 	if (ret < 0) {
 		dev_err(sdev->dev, "Failed to initialize output format for %s",
@@ -1841,7 +1841,7 @@ static int sof_ipc4_prepare_gain_module(struct snd_sof_widget *swidget,
 	}
 
 	/* update pipeline memory usage */
-	sof_ipc4_update_resource_usage(sdev, swidget, &gain->base_config);
+	sof_ipc4_update_resource_usage(sdev, swidget, &gain->data.base_config);
 
 	return 0;
 }
@@ -2277,9 +2277,8 @@ static int sof_ipc4_widget_setup(struct snd_sof_dev *sdev, struct snd_sof_widget
 	{
 		struct sof_ipc4_gain *gain = swidget->private;
 
-		ipc_size = sizeof(struct sof_ipc4_base_module_cfg) +
-			   sizeof(struct sof_ipc4_gain_data);
-		ipc_data = gain;
+		ipc_size = sizeof(gain->data);
+		ipc_data = &gain->data;
 
 		msg = &gain->msg;
 		break;
diff --git a/sound/soc/sof/ipc4-topology.h b/sound/soc/sof/ipc4-topology.h
index f96536dbaee5..21436657ad85 100644
--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -344,7 +344,7 @@ struct sof_ipc4_control_data {
 };
 
 /**
- * struct sof_ipc4_gain_data - IPC gain blob
+ * struct sof_ipc4_gain_params - IPC gain parameters
  * @channels: Channels
  * @init_val: Initial value
  * @curve_type: Curve type
@@ -352,24 +352,32 @@ struct sof_ipc4_control_data {
  * @curve_duration_l: Curve duration low part
  * @curve_duration_h: Curve duration high part
  */
-struct sof_ipc4_gain_data {
+struct sof_ipc4_gain_params {
 	uint32_t channels;
 	uint32_t init_val;
 	uint32_t curve_type;
 	uint32_t reserved;
 	uint32_t curve_duration_l;
 	uint32_t curve_duration_h;
-} __aligned(8);
+} __packed __aligned(4);
 
 /**
- * struct sof_ipc4_gain - gain config data
+ * struct sof_ipc4_gain_data - IPC gain init blob
  * @base_config: IPC base config data
+ * @params: Initial parameters for the gain module
+ */
+struct sof_ipc4_gain_data {
+	struct sof_ipc4_base_module_cfg base_config;
+	struct sof_ipc4_gain_params params;
+} __packed __aligned(4);
+
+/**
+ * struct sof_ipc4_gain - gain config data
  * @data: IPC gain blob
  * @available_fmt: Available audio format
  * @msg: message structure for gain
  */
 struct sof_ipc4_gain {
-	struct sof_ipc4_base_module_cfg base_config;
 	struct sof_ipc4_gain_data data;
 	struct sof_ipc4_available_audio_format available_fmt;
 	struct sof_ipc4_msg msg;
-- 
2.43.0



