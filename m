Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE9822F0B;
	Thu, 18 Jan 2024 10:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575182; cv=none; b=DzSvRtDQ/X1udcnay8SvUnFLktlIkiz0+Eu/KsfZjkqmRf+BJX3fnQuSlER8Nr4zXCgg2Vi5MgMRZ9hZr6Kfi3vLzCCOVMGOvDdZQajSx1EhlcGdZP6v6yDwYcFxgydz+6wdjJdb64SD2bo0YvAtkcVaCiQJNK3zQmlUKyZZus4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575182; c=relaxed/simple;
	bh=KB2DZD8JfW9KPuK9CMC9WeDQtjhz0TgUWvoCOuvdfYc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=q0Y1vab44NNuge5EWqtaAIAaBL6yjKvHE/joP4DpuD66WszDdiejW6XaxjCXJmIxTRGmHivOKVoWT49RTUomPpETkp1GicrBNUqo9CY3jhItTU0tTVeXZn9Zrq+dRJl3PRLbCzhSjB4YljORnkDBBRHjLPlT2L7P5PBokCrSsHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trvOeV9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trvOeV9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D28C433C7;
	Thu, 18 Jan 2024 10:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575182;
	bh=KB2DZD8JfW9KPuK9CMC9WeDQtjhz0TgUWvoCOuvdfYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trvOeV9d3dxzwqU3iMrDIPcRmox9sFm5BwYI4cpKnPJ5FNu0rUfKP8yUs842AfVfa
	 bmIt0Reu8mwTSnugaWf/y7CVlJNGyKwBEVv8DQW9ORuzCu6yY9vn3ZHSQpy5eRq224
	 dBSs8Q2wuwot1fbZsUF1AWOmZ886eyiX7xndFikU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/150] ASoC: SOF: ipc4-topology: Add core_mask in struct snd_sof_pipeline
Date: Thu, 18 Jan 2024 11:47:43 +0100
Message-ID: <20240118104321.970689134@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 0376b995bb7a65fb0c056f3adc5e9695ad0c1805 ]

With IPC4, a pipeline may contain multiple modules in the data
processing domain and they can be scheduled to run on different cores.
Add a new field in struct snd_sof_pipeline to keep track of all the
cores that are associated with the modules in the pipeline. Set the
pipeline core mask for IPC3 when initializing the pipeline widget IPC
structure. For IPC4, set the core mark when initializing the pipeline
widget and initializing processing modules in the data processing domain.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20231124135743.24674-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-topology.c | 2 ++
 sound/soc/sof/ipc4-topology.c | 9 +++++++++
 sound/soc/sof/sof-audio.h     | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index ba4ef290b634..2c7a5e7a364c 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -493,6 +493,7 @@ static int sof_ipc3_widget_setup_comp_mixer(struct snd_sof_widget *swidget)
 static int sof_ipc3_widget_setup_comp_pipeline(struct snd_sof_widget *swidget)
 {
 	struct snd_soc_component *scomp = swidget->scomp;
+	struct snd_sof_pipeline *spipe = swidget->spipe;
 	struct sof_ipc_pipe_new *pipeline;
 	struct snd_sof_widget *comp_swidget;
 	int ret;
@@ -545,6 +546,7 @@ static int sof_ipc3_widget_setup_comp_pipeline(struct snd_sof_widget *swidget)
 		swidget->dynamic_pipeline_widget);
 
 	swidget->core = pipeline->core;
+	spipe->core_mask |= BIT(pipeline->core);
 
 	return 0;
 
diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index c9c1d2ec7af2..05c3b1153a91 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -654,6 +654,7 @@ static int sof_ipc4_widget_setup_comp_pipeline(struct snd_sof_widget *swidget)
 {
 	struct snd_soc_component *scomp = swidget->scomp;
 	struct sof_ipc4_pipeline *pipeline;
+	struct snd_sof_pipeline *spipe = swidget->spipe;
 	int ret;
 
 	pipeline = kzalloc(sizeof(*pipeline), GFP_KERNEL);
@@ -668,6 +669,7 @@ static int sof_ipc4_widget_setup_comp_pipeline(struct snd_sof_widget *swidget)
 	}
 
 	swidget->core = pipeline->core_id;
+	spipe->core_mask |= BIT(pipeline->core_id);
 
 	if (pipeline->use_chain_dma) {
 		dev_dbg(scomp->dev, "Set up chain DMA for %s\n", swidget->widget->name);
@@ -798,6 +800,7 @@ static int sof_ipc4_widget_setup_comp_mixer(struct snd_sof_widget *swidget)
 static int sof_ipc4_widget_setup_comp_src(struct snd_sof_widget *swidget)
 {
 	struct snd_soc_component *scomp = swidget->scomp;
+	struct snd_sof_pipeline *spipe = swidget->spipe;
 	struct sof_ipc4_src *src;
 	int ret;
 
@@ -820,6 +823,8 @@ static int sof_ipc4_widget_setup_comp_src(struct snd_sof_widget *swidget)
 		goto err;
 	}
 
+	spipe->core_mask |= BIT(swidget->core);
+
 	dev_dbg(scomp->dev, "SRC sink rate %d\n", src->sink_rate);
 
 	ret = sof_ipc4_widget_setup_msg(swidget, &src->msg);
@@ -865,6 +870,7 @@ static int sof_ipc4_widget_setup_comp_process(struct snd_sof_widget *swidget)
 {
 	struct snd_soc_component *scomp = swidget->scomp;
 	struct sof_ipc4_fw_module *fw_module;
+	struct snd_sof_pipeline *spipe = swidget->spipe;
 	struct sof_ipc4_process *process;
 	void *cfg;
 	int ret;
@@ -921,6 +927,9 @@ static int sof_ipc4_widget_setup_comp_process(struct snd_sof_widget *swidget)
 
 	sof_ipc4_widget_update_kcontrol_module_id(swidget);
 
+	/* set pipeline core mask to keep track of the core the module is scheduled to run on */
+	spipe->core_mask |= BIT(swidget->core);
+
 	return 0;
 free_base_cfg_ext:
 	kfree(process->base_config_ext);
diff --git a/sound/soc/sof/sof-audio.h b/sound/soc/sof/sof-audio.h
index 5d5eeb1a1a6f..a6d6bcd00cee 100644
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -480,6 +480,7 @@ struct snd_sof_widget {
  * @paused_count: Count of number of PCM's that have started and have currently paused this
 		  pipeline
  * @complete: flag used to indicate that pipeline set up is complete.
+ * @core_mask: Mask containing target cores for all modules in the pipeline
  * @list: List item in sdev pipeline_list
  */
 struct snd_sof_pipeline {
@@ -487,6 +488,7 @@ struct snd_sof_pipeline {
 	int started_count;
 	int paused_count;
 	int complete;
+	unsigned long core_mask;
 	struct list_head list;
 };
 
-- 
2.43.0



