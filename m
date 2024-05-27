Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0272168C4;
	Mon, 27 May 2024 19:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837579; cv=none; b=dy90AnWo3ArKG6mwauxHYg1UMRNMALozpt4WUAP3IsbCv6+002AcTuo152ctlesxv707ZlJuAh5nI/R0ZixX2oW0n6tgbrjaCjbIH8nhH3XIjTyZOHBpIDuJ8SKnR2S1dq97FQ62pdDULoH/4PHg4dzYAJ/8pnh+zFknplkx6PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837579; c=relaxed/simple;
	bh=K18wc8E/3w1eNW3GKaakZ/57u53s2FODxQUDdw+ppOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FH1hpbpPHDzlvFu9QM1VCEoM24ma6BzZMg0szxdrhx45wd6NNlxycB/+cKQ+//z8XXYzSXVDX3s38Gdw4TFaCYq9Nda6K/W/plyzjw1e/1I/EdWvxU/kURzkf46wdoxxa4fG6roPg2KqlNyOYiKFAU2OnxtNJIRo/dNQqgRab0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7kdOcIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7kdOcIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352ADC2BBFC;
	Mon, 27 May 2024 19:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837579;
	bh=K18wc8E/3w1eNW3GKaakZ/57u53s2FODxQUDdw+ppOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7kdOcIzLinvgtmKtp43AfbSvd8he3Cev6jt+VAsXScjo7gCnoQVBKP3Le3l+YeC7
	 YUz1a3R90AsDBoaIlXTK/z3Xu3PWc07o2J6WnWAZH1VHgMZHn7jGTGAof2Q0rL4B1w
	 rMZgIl+q8voUEAjsuDZcJUhcGGHpbo9C7+3/h+BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 065/493] ASoC: SOF: ipc4-pcm: Use consistent name for snd_sof_pcm_stream pointer
Date: Mon, 27 May 2024 20:51:07 +0200
Message-ID: <20240527185631.778792792@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 965e49cdf8c19f21b8308adeded3a8139cff5c84 ]

Throughout the file the pointer for snd_sof_pcm_stream is named either
'stream' or (wrongly) 'spcm' which confuses the reader.

Use 'sps' for the pointer name as it is the most common name used in SOF
codebase.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://msgid.link/r/20240409110036.9411-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-pcm.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/soc/sof/ipc4-pcm.c b/sound/soc/sof/ipc4-pcm.c
index a99fced908251..31133c5dcbf50 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -747,7 +747,7 @@ static int sof_ipc4_pcm_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm
 	return 0;
 }
 
-static void sof_ipc4_build_time_info(struct snd_sof_dev *sdev, struct snd_sof_pcm_stream *spcm)
+static void sof_ipc4_build_time_info(struct snd_sof_dev *sdev, struct snd_sof_pcm_stream *sps)
 {
 	struct sof_ipc4_copier *host_copier = NULL;
 	struct sof_ipc4_copier *dai_copier = NULL;
@@ -758,7 +758,7 @@ static void sof_ipc4_build_time_info(struct snd_sof_dev *sdev, struct snd_sof_pc
 	int i;
 
 	/* find host & dai to locate info in memory window */
-	for_each_dapm_widgets(spcm->list, i, widget) {
+	for_each_dapm_widgets(sps->list, i, widget) {
 		struct snd_sof_widget *swidget = widget->dobj.private;
 
 		if (!swidget)
@@ -778,7 +778,7 @@ static void sof_ipc4_build_time_info(struct snd_sof_dev *sdev, struct snd_sof_pc
 		return;
 	}
 
-	info = spcm->private;
+	info = sps->private;
 	info->host_copier = host_copier;
 	info->dai_copier = dai_copier;
 	info->llp_offset = offsetof(struct sof_ipc4_fw_registers, llp_gpdma_reading_slots) +
@@ -847,7 +847,7 @@ static int sof_ipc4_pcm_hw_params(struct snd_soc_component *component,
 
 static int sof_ipc4_get_stream_start_offset(struct snd_sof_dev *sdev,
 					    struct snd_pcm_substream *substream,
-					    struct snd_sof_pcm_stream *stream,
+					    struct snd_sof_pcm_stream *sps,
 					    struct sof_ipc4_timestamp_info *time_info)
 {
 	struct sof_ipc4_copier *host_copier = time_info->host_copier;
@@ -901,7 +901,7 @@ static int sof_ipc4_pcm_pointer(struct snd_soc_component *component,
 	struct sof_ipc4_timestamp_info *time_info;
 	struct sof_ipc4_llp_reading_slot llp;
 	snd_pcm_uframes_t head_cnt, tail_cnt;
-	struct snd_sof_pcm_stream *stream;
+	struct snd_sof_pcm_stream *sps;
 	u64 dai_cnt, host_cnt, host_ptr;
 	struct snd_sof_pcm *spcm;
 	int ret;
@@ -910,8 +910,8 @@ static int sof_ipc4_pcm_pointer(struct snd_soc_component *component,
 	if (!spcm)
 		return -EOPNOTSUPP;
 
-	stream = &spcm->stream[substream->stream];
-	time_info = stream->private;
+	sps = &spcm->stream[substream->stream];
+	time_info = sps->private;
 	if (!time_info)
 		return -EOPNOTSUPP;
 
@@ -921,7 +921,7 @@ static int sof_ipc4_pcm_pointer(struct snd_soc_component *component,
 	 * the statistics is complete. And it will not change after the first initiailization.
 	 */
 	if (time_info->stream_start_offset == SOF_IPC4_INVALID_STREAM_POSITION) {
-		ret = sof_ipc4_get_stream_start_offset(sdev, substream, stream, time_info);
+		ret = sof_ipc4_get_stream_start_offset(sdev, substream, sps, time_info);
 		if (ret < 0)
 			return -EOPNOTSUPP;
 	}
@@ -1013,15 +1013,15 @@ static snd_pcm_sframes_t sof_ipc4_pcm_delay(struct snd_soc_component *component,
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct sof_ipc4_timestamp_info *time_info;
-	struct snd_sof_pcm_stream *stream;
+	struct snd_sof_pcm_stream *sps;
 	struct snd_sof_pcm *spcm;
 
 	spcm = snd_sof_find_spcm_dai(component, rtd);
 	if (!spcm)
 		return 0;
 
-	stream = &spcm->stream[substream->stream];
-	time_info = stream->private;
+	sps = &spcm->stream[substream->stream];
+	time_info = sps->private;
 	/*
 	 * Report the stored delay value calculated in the pointer callback.
 	 * In the unlikely event that the calculation was skipped/aborted, the
-- 
2.43.0



