Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25418168C4;
	Mon, 27 May 2024 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837582; cv=none; b=AWSjVx8QN0VhcU5c/Mw0qg7ykhoyAZX0+2XyHH3ILqKVV3gCHsv7SnrxhLhFrTwUGeVtMNHTwMKh2yCXSamBGLKAqgCTCL7/umsWaghUkRjLCTA5Njy/kakrOKfAff5oYka2ue30WXdcAIQIGTj5LKuwzBSM07oZhFWqyzGVkow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837582; c=relaxed/simple;
	bh=cvDBuJg6yIRmyhkCSI44sPKvzWT/2YIB8W6VgZwYcO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+FoXhq48iJzAYg0ymDskUZ1WGqa+KjYLGXHFq8kIdCXw9OTZa7Te+X77c2WTMYjrh13mW07AJXvWV5z0L6uCLd0DAbmmk1JZvR3yJmlOFVvhTL4i3n3aNGFxHi/xyLCecdaVKnpouQEV9ju4pAjT2kkVr+oi/tO5hZcICISVF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KY1LIWk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KY1LIWk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE33FC2BBFC;
	Mon, 27 May 2024 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837582;
	bh=cvDBuJg6yIRmyhkCSI44sPKvzWT/2YIB8W6VgZwYcO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KY1LIWk/C23m7pkY695Qfs1AFrQ0/O7VrA7OY4sJLZev+bYX4ZoWDk0a73Em8+cgi
	 wobouEPqs1qIj6fkIMq2DaoB+l4Pbc7Q4WVu3xsUINlGjj1RLzm+90QtZ3B9TlaB9s
	 Il/+oghmk6ss3pFTb8FI5EqfW0Zm5uetbeWB6SR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 066/493] ASoC: SOF: ipc4-pcm: Use consistent name for sof_ipc4_timestamp_info pointer
Date: Mon, 27 May 2024 20:51:08 +0200
Message-ID: <20240527185631.840101714@linuxfoundation.org>
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

[ Upstream commit 36e980050b0733829e4e0f97b97f7907ba9f00bb ]

The pointer to sof_ipc4_timestamp_info named most of the time as
'time_info' only to be named as 'stream_info' or 'info' in two function.

Use the consistent name of 'time_info' throughout the file.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://msgid.link/r/20240409110036.9411-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-pcm.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/sound/soc/sof/ipc4-pcm.c b/sound/soc/sof/ipc4-pcm.c
index 31133c5dcbf50..3f8b9443496ce 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -704,7 +704,7 @@ static int sof_ipc4_pcm_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm
 {
 	struct snd_sof_pcm_stream_pipeline_list *pipeline_list;
 	struct sof_ipc4_fw_data *ipc4_data = sdev->private;
-	struct sof_ipc4_timestamp_info *stream_info;
+	struct sof_ipc4_timestamp_info *time_info;
 	bool support_info = true;
 	u32 abi_version;
 	u32 abi_offset;
@@ -735,13 +735,13 @@ static int sof_ipc4_pcm_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm
 		if (!support_info)
 			continue;
 
-		stream_info = kzalloc(sizeof(*stream_info), GFP_KERNEL);
-		if (!stream_info) {
+		time_info = kzalloc(sizeof(*time_info), GFP_KERNEL);
+		if (!time_info) {
 			sof_ipc4_pcm_free(sdev, spcm);
 			return -ENOMEM;
 		}
 
-		spcm->stream[stream].private = stream_info;
+		spcm->stream[stream].private = time_info;
 	}
 
 	return 0;
@@ -752,7 +752,7 @@ static void sof_ipc4_build_time_info(struct snd_sof_dev *sdev, struct snd_sof_pc
 	struct sof_ipc4_copier *host_copier = NULL;
 	struct sof_ipc4_copier *dai_copier = NULL;
 	struct sof_ipc4_llp_reading_slot llp_slot;
-	struct sof_ipc4_timestamp_info *info;
+	struct sof_ipc4_timestamp_info *time_info;
 	struct snd_soc_dapm_widget *widget;
 	struct snd_sof_dai *dai;
 	int i;
@@ -778,44 +778,44 @@ static void sof_ipc4_build_time_info(struct snd_sof_dev *sdev, struct snd_sof_pc
 		return;
 	}
 
-	info = sps->private;
-	info->host_copier = host_copier;
-	info->dai_copier = dai_copier;
-	info->llp_offset = offsetof(struct sof_ipc4_fw_registers, llp_gpdma_reading_slots) +
-				    sdev->fw_info_box.offset;
+	time_info = sps->private;
+	time_info->host_copier = host_copier;
+	time_info->dai_copier = dai_copier;
+	time_info->llp_offset = offsetof(struct sof_ipc4_fw_registers,
+					 llp_gpdma_reading_slots) + sdev->fw_info_box.offset;
 
 	/* find llp slot used by current dai */
 	for (i = 0; i < SOF_IPC4_MAX_LLP_GPDMA_READING_SLOTS; i++) {
-		sof_mailbox_read(sdev, info->llp_offset, &llp_slot, sizeof(llp_slot));
+		sof_mailbox_read(sdev, time_info->llp_offset, &llp_slot, sizeof(llp_slot));
 		if (llp_slot.node_id == dai_copier->data.gtw_cfg.node_id)
 			break;
 
-		info->llp_offset += sizeof(llp_slot);
+		time_info->llp_offset += sizeof(llp_slot);
 	}
 
 	if (i < SOF_IPC4_MAX_LLP_GPDMA_READING_SLOTS)
 		return;
 
 	/* if no llp gpdma slot is used, check aggregated sdw slot */
-	info->llp_offset = offsetof(struct sof_ipc4_fw_registers, llp_sndw_reading_slots) +
-					sdev->fw_info_box.offset;
+	time_info->llp_offset = offsetof(struct sof_ipc4_fw_registers,
+					 llp_sndw_reading_slots) + sdev->fw_info_box.offset;
 	for (i = 0; i < SOF_IPC4_MAX_LLP_SNDW_READING_SLOTS; i++) {
-		sof_mailbox_read(sdev, info->llp_offset, &llp_slot, sizeof(llp_slot));
+		sof_mailbox_read(sdev, time_info->llp_offset, &llp_slot, sizeof(llp_slot));
 		if (llp_slot.node_id == dai_copier->data.gtw_cfg.node_id)
 			break;
 
-		info->llp_offset += sizeof(llp_slot);
+		time_info->llp_offset += sizeof(llp_slot);
 	}
 
 	if (i < SOF_IPC4_MAX_LLP_SNDW_READING_SLOTS)
 		return;
 
 	/* check EVAD slot */
-	info->llp_offset = offsetof(struct sof_ipc4_fw_registers, llp_evad_reading_slot) +
-					sdev->fw_info_box.offset;
-	sof_mailbox_read(sdev, info->llp_offset, &llp_slot, sizeof(llp_slot));
+	time_info->llp_offset = offsetof(struct sof_ipc4_fw_registers,
+					 llp_evad_reading_slot) + sdev->fw_info_box.offset;
+	sof_mailbox_read(sdev, time_info->llp_offset, &llp_slot, sizeof(llp_slot));
 	if (llp_slot.node_id != dai_copier->data.gtw_cfg.node_id)
-		info->llp_offset = 0;
+		time_info->llp_offset = 0;
 }
 
 static int sof_ipc4_pcm_hw_params(struct snd_soc_component *component,
-- 
2.43.0



