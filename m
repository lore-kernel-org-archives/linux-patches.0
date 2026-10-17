Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA55E255E43;
	Sat, 17 Oct 2026 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256995; cv=none; b=Ri8lH62i2ehfOFMcmjEGY7uPUJ0VEnMxVmpxZ8X5f1cobLJi2bMVuuAbtosGng1jPVa69R0wQmOMIJCNYU/G9wlwmJN5/ff/NBMvyD74Rvh7im1N6fZeD/wKMde66saBZuubqmJvLQEngurJqsEALfWsxXazSZrGeqO9VkDih0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256995; c=relaxed/simple;
	bh=dqT+vXB0/bU4C8cZOL4olw4DhzwFlxwF/v9/RNR4fUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iW0+/qCTC9Z34ZePtMJ4HcfAe0q6mAjiJjqv1v7MxMBxzwPenjQf4i1Md9ytJ9KYcAW+apdQYAV4eDustjg92eJ1DNLaZZRCYbF4vuxrDvl1F3O4oe9jwOCXM9oYb5ELYOG/4CXB7VO6Om11FavVbzBkBDzZVLpVnshproCiO+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTWP1Z1M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTWP1Z1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9481F000C4;
	Sat, 17 Oct 2026 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256994;
	bh=gCVPxatTRX3znotYLLB26KlyUQ5OkcnCjhokuSH+PJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vTWP1Z1M9ABS8NnxAwewkb8UC1mpPwI2CTUf5MlOQrmQbzoYb80HFHTJK3yKpu+0w
	 CLuwOX8r0dnAcpi0lko1IKIkUmMMJLDCiqvnOwszHW5xNbMlnBV6IiVIT8fRnaw/pQ
	 XewAgjVm9Ds0aaV/jY4/dos5rqObT52EQhnDrlqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0417/1674] ASoC: SOF: topology: Parse DAI type token for dspless mode
Date: Sat, 17 Oct 2026 17:44:49 +0200
Message-ID: <20261017160441.834094799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit f9618ff105a0f6f5a6beed3edc557ea6a7d26df6 ]

Starting with LunarLake, the dspless mode can handle SoundWire/ALH,
DMIC and SSPs, so we need to identify the dai type from topology.

[ Backport to 6.6.y: 6.6.y still uses a stack-allocated snd_sof_dai in
  the dspless topology path; parse the DAI type into that existing object
  before connecting it. ]

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://msgid.link/r/20240213101247.28887-12-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c |  1 +
 sound/soc/sof/sof-audio.h     |  1 +
 sound/soc/sof/topology.c      | 11 +++++++++++
 3 files changed, 13 insertions(+)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 39e4f0fdd5e45..18096aefce13f 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -534,6 +534,7 @@ static int sof_ipc4_widget_setup_comp_dai(struct snd_sof_widget *swidget)
 	dev_dbg(scomp->dev, "dai %s node_type %u dai_type %u dai_index %d\n", swidget->widget->name,
 		node_type, ipc4_copier->dai_type, ipc4_copier->dai_index);
 
+	dai->type = ipc4_copier->dai_type;
 	ipc4_copier->data.gtw_cfg.node_id = SOF_IPC4_NODE_TYPE(node_type);
 
 	pipe_widget = swidget->spipe->pipe_widget;
diff --git a/sound/soc/sof/sof-audio.h b/sound/soc/sof/sof-audio.h
index 7620596ead07d..13b9026ffd4de 100644
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -514,6 +514,7 @@ struct snd_sof_route {
 struct snd_sof_dai {
 	struct snd_soc_component *scomp;
 	const char *name;
+	u32 type;
 
 	int number_configs;
 	int current_config;
diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 7eb8eb35b137c..011095722a80b 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2364,7 +2364,10 @@ static int sof_dspless_widget_ready(struct snd_soc_component *scomp, int index,
 				    struct snd_soc_tplg_dapm_widget *tw)
 {
 	if (WIDGET_IS_DAI(w->id)) {
+		static const struct sof_topology_token dai_tokens[] = {
+			{SOF_TKN_DAI_TYPE, SND_SOC_TPLG_TUPLE_TYPE_STRING, get_token_dai_type, 0}};
 		struct snd_sof_dev *sdev = snd_soc_component_get_drvdata(scomp);
+		struct snd_soc_tplg_private *priv = &tw->priv;
 		struct snd_sof_widget *swidget;
 		struct snd_sof_dai dai;
 		int ret;
@@ -2375,6 +2378,14 @@ static int sof_dspless_widget_ready(struct snd_soc_component *scomp, int index,
 
 		memset(&dai, 0, sizeof(dai));
 
+		ret = sof_parse_tokens(scomp, &dai.type, dai_tokens, ARRAY_SIZE(dai_tokens),
+				       priv->array, le32_to_cpu(priv->size));
+		if (ret < 0) {
+			dev_err(scomp->dev, "Failed to parse DAI tokens for %s\n", tw->name);
+			kfree(swidget);
+			return ret;
+		}
+
 		ret = sof_connect_dai_widget(scomp, w, tw, &dai);
 		if (ret) {
 			kfree(swidget);
-- 
2.53.0



