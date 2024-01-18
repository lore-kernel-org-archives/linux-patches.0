Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D38122323;
	Thu, 18 Jan 2024 10:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575196; cv=none; b=My1CLhbMIIBCWDqvYZvgcyiLZ7wcTcNu674RBTnmc7lFqT1JZYEcTfOSEZKWpVCFSNmOoVkxwjU9AoY5lLErhai63ATLj+Nn60BsFus650Sreto9bY2aZoB2FZN1FshRWPbfdJLJOwLh719dKOaHyoZEIis8Zw7CTJkUE1v1emY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575196; c=relaxed/simple;
	bh=FUY/tsuoo5ErDLKB5Yt+cOOoWaxfeMt0/fvu5F9rlZk=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=AXYqWcU69GsWPdbHUYm7WtSFFfhSweAvlGz6uasDUa8gOh0jpSFdfDQqTkFiH1s8z4gWcMKW0ERFEqMD5sETYTTcEYHbrzZzRshy3Rk0ZJZH8d7cd5+0b1iSPbuHOxxyM/3tCT8YPeWvIJUimKU0xp1dS5RoczoBJzWy8+E4Qmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jf8xJ/QM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jf8xJ/QM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A622CC433C7;
	Thu, 18 Jan 2024 10:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575196;
	bh=FUY/tsuoo5ErDLKB5Yt+cOOoWaxfeMt0/fvu5F9rlZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jf8xJ/QMo/QKdTgW/sYFdqNn7dqxFWAfZwWNRUgu5iOQ21CZnZs5QC+R8/8U47Es+
	 S7m3M8TXghMuQjdrpLmwVT2vM/N6yTUP2C6oHvihyG8RtfnJHJbkx61zaZnpDvblc+
	 GO0dPze6n8CtErQN6nQt02h0QREEYoKaGNs1gZjw=
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
Subject: [PATCH 6.6 046/150] ASoC: SOF: ipc4-topology: Correct data structures for the SRC module
Date: Thu, 18 Jan 2024 11:47:48 +0100
Message-ID: <20240118104322.158813679@linuxfoundation.org>
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

[ Upstream commit c447636970e3409ac39f0bb8c2dcff6b726f36b0 ]

Separate the IPC message part as struct sof_ipc4_src_data. This struct
describes the message payload passed to the firmware via the mailbox.

It is not wise to be 'clever' and try to use the first part of a struct
as IPC message without marking the message section as packed and aligned.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20231129131411.27516-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 21 +++++++++++----------
 sound/soc/sof/ipc4-topology.h | 16 ++++++++++++----
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 05c3b1153a91..42f6a99935d1 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -139,7 +139,7 @@ static const struct sof_topology_token gain_tokens[] = {
 /* SRC */
 static const struct sof_topology_token src_tokens[] = {
 	{SOF_TKN_SRC_RATE_OUT, SND_SOC_TPLG_TUPLE_TYPE_WORD, get_token_u32,
-		offsetof(struct sof_ipc4_src, sink_rate)},
+		offsetof(struct sof_ipc4_src_data, sink_rate)},
 };
 
 static const struct sof_token_info ipc4_token_list[SOF_TOKEN_COUNT] = {
@@ -812,11 +812,12 @@ static int sof_ipc4_widget_setup_comp_src(struct snd_sof_widget *swidget)
 
 	swidget->private = src;
 
-	ret = sof_ipc4_get_audio_fmt(scomp, swidget, &src->available_fmt, &src->base_config);
+	ret = sof_ipc4_get_audio_fmt(scomp, swidget, &src->available_fmt,
+				     &src->data.base_config);
 	if (ret)
 		goto err;
 
-	ret = sof_update_ipc_object(scomp, src, SOF_SRC_TOKENS, swidget->tuples,
+	ret = sof_update_ipc_object(scomp, &src->data, SOF_SRC_TOKENS, swidget->tuples,
 				    swidget->num_tuples, sizeof(*src), 1);
 	if (ret) {
 		dev_err(scomp->dev, "Parsing SRC tokens failed\n");
@@ -825,7 +826,7 @@ static int sof_ipc4_widget_setup_comp_src(struct snd_sof_widget *swidget)
 
 	spipe->core_mask |= BIT(swidget->core);
 
-	dev_dbg(scomp->dev, "SRC sink rate %d\n", src->sink_rate);
+	dev_dbg(scomp->dev, "SRC sink rate %d\n", src->data.sink_rate);
 
 	ret = sof_ipc4_widget_setup_msg(swidget, &src->msg);
 	if (ret)
@@ -1896,7 +1897,7 @@ static int sof_ipc4_prepare_src_module(struct snd_sof_widget *swidget,
 	u32 out_ref_rate, out_ref_channels, out_ref_valid_bits;
 	int output_format_index, input_format_index;
 
-	input_format_index = sof_ipc4_init_input_audio_fmt(sdev, swidget, &src->base_config,
+	input_format_index = sof_ipc4_init_input_audio_fmt(sdev, swidget, &src->data.base_config,
 							   pipeline_params, available_fmt);
 	if (input_format_index < 0)
 		return input_format_index;
@@ -1926,7 +1927,7 @@ static int sof_ipc4_prepare_src_module(struct snd_sof_widget *swidget,
 	 */
 	out_ref_rate = params_rate(fe_params);
 
-	output_format_index = sof_ipc4_init_output_audio_fmt(sdev, &src->base_config,
+	output_format_index = sof_ipc4_init_output_audio_fmt(sdev, &src->data.base_config,
 							     available_fmt, out_ref_rate,
 							     out_ref_channels, out_ref_valid_bits);
 	if (output_format_index < 0) {
@@ -1936,10 +1937,10 @@ static int sof_ipc4_prepare_src_module(struct snd_sof_widget *swidget,
 	}
 
 	/* update pipeline memory usage */
-	sof_ipc4_update_resource_usage(sdev, swidget, &src->base_config);
+	sof_ipc4_update_resource_usage(sdev, swidget, &src->data.base_config);
 
 	out_audio_fmt = &available_fmt->output_pin_fmts[output_format_index].audio_fmt;
-	src->sink_rate = out_audio_fmt->sampling_frequency;
+	src->data.sink_rate = out_audio_fmt->sampling_frequency;
 
 	/* update pipeline_params for sink widgets */
 	return sof_ipc4_update_hw_params(sdev, pipeline_params, out_audio_fmt);
@@ -2297,8 +2298,8 @@ static int sof_ipc4_widget_setup(struct snd_sof_dev *sdev, struct snd_sof_widget
 	{
 		struct sof_ipc4_src *src = swidget->private;
 
-		ipc_size = sizeof(struct sof_ipc4_base_module_cfg) + sizeof(src->sink_rate);
-		ipc_data = src;
+		ipc_size = sizeof(src->data);
+		ipc_data = &src->data;
 
 		msg = &src->msg;
 		break;
diff --git a/sound/soc/sof/ipc4-topology.h b/sound/soc/sof/ipc4-topology.h
index d75f17f4749c..f96536dbaee5 100644
--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -387,16 +387,24 @@ struct sof_ipc4_mixer {
 	struct sof_ipc4_msg msg;
 };
 
-/**
- * struct sof_ipc4_src SRC config data
+/*
+ * struct sof_ipc4_src_data - IPC data for SRC
  * @base_config: IPC base config data
  * @sink_rate: Output rate for sink module
+ */
+struct sof_ipc4_src_data {
+	struct sof_ipc4_base_module_cfg base_config;
+	uint32_t sink_rate;
+} __packed __aligned(4);
+
+/**
+ * struct sof_ipc4_src - SRC config data
+ * @data: IPC base config data
  * @available_fmt: Available audio format
  * @msg: IPC4 message struct containing header and data info
  */
 struct sof_ipc4_src {
-	struct sof_ipc4_base_module_cfg base_config;
-	uint32_t sink_rate;
+	struct sof_ipc4_src_data data;
 	struct sof_ipc4_available_audio_format available_fmt;
 	struct sof_ipc4_msg msg;
 };
-- 
2.43.0



