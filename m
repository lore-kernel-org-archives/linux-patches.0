Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903D92745E;
	Fri, 17 Oct 2025 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714687; cv=none; b=NlxUfiQ2JYc941GEHzlMpbk7gzvk7Ag4S3CtfU5aUM47//AVM8QGXDmociqIj4/Llt4fMLI7L8f84ajMUTG36bWi34DJ9aGB9ihCcfNAA/wph11VoI6gevsnU9BH3ZMzPi0VTMR0/NiO3pN15SNKiz8EA/Py6D8wrjPOALByh14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714687; c=relaxed/simple;
	bh=KAIkPGwoOks6SiiPxXVts4GZuTJFEUBwW7iGHzexJyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyyvpHUVx3suqiD+SfnGr5R+Wbtc95hr9wXkzmhKIJQzjTPAYlTi6vQvhTA+D3BE4PWBEiPUDqv2U8pr8VqRpA8J7ODAa//+o5Mkl4Oyl3IGPkXES6/OlPDDEmDKarkifIg8rZszxc6v1DpEGb7Ql03k0hZIFcS0ug16se0uLMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uduyNG6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uduyNG6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4618C4CEE7;
	Fri, 17 Oct 2025 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714687;
	bh=KAIkPGwoOks6SiiPxXVts4GZuTJFEUBwW7iGHzexJyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uduyNG6rLAj3G9Ub4opxbxVQIajGmzdmVlACnZC0rPC0wS+fp8Zu6gCY8FgWUZxZB
	 HgPPSkVJsh055fyrbp0BI0CNXX0gvWQyXuq7wromQeIzRzEAZt5o3H+pv0+NdUNwV7
	 AtLEPjzc0AtnMemhf/VWry5HglQ/pOVPOPWZK5+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 231/277] ASoC: SOF: ipc4-pcm: Enable delay reporting for ChainDMA streams
Date: Fri, 17 Oct 2025 16:53:58 +0200
Message-ID: <20251017145155.569825456@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit a1d203d390e04798ccc1c3c06019cd4411885d6d ]

All streams (currently) which is configured to use ChainDMA can only work
on Link/host DMA pairs where the link side position can be access via host
registers (like HDA on CAVS 2.5 platforms).

Since the firmware does not provide time_info for ChainDMA, unlike for HDA
stream, the kernel should calculate the start and end offsets that is
needed for the delay calculation.

With this small change we can report accurate delays when the stream is
configured to use ChainDMA.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20250619102848.12389-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: bcd1383516bb ("ASoC: SOF: ipc4-pcm: fix delay calculation when DSP resamples")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-pcm.c      |   49 ++++++++++++++++++++++++++++++++++++++----
 sound/soc/sof/ipc4-topology.c |    6 ++---
 sound/soc/sof/ipc4-topology.h |    1 
 3 files changed, 49 insertions(+), 7 deletions(-)

--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -409,9 +409,33 @@ static int sof_ipc4_trigger_pipelines(st
 	 * If use_chain_dma attribute is set we proceed to chained DMA
 	 * trigger function that handles the rest for the substream.
 	 */
-	if (pipeline->use_chain_dma)
-		return sof_ipc4_chain_dma_trigger(sdev, spcm, substream->stream,
-						  pipeline_list, state, cmd);
+	if (pipeline->use_chain_dma) {
+		struct sof_ipc4_timestamp_info *time_info;
+
+		time_info = sof_ipc4_sps_to_time_info(&spcm->stream[substream->stream]);
+
+		ret = sof_ipc4_chain_dma_trigger(sdev, spcm, substream->stream,
+						 pipeline_list, state, cmd);
+		if (ret || !time_info)
+			return ret;
+
+		if (state == SOF_IPC4_PIPE_PAUSED) {
+			/*
+			 * Record the DAI position for delay reporting
+			 * To handle multiple pause/resume/xrun we need to add
+			 * the positions to simulate how the firmware behaves
+			 */
+			u64 pos = snd_sof_pcm_get_dai_frame_counter(sdev, component,
+								    substream);
+
+			time_info->stream_end_offset += pos;
+		} else if (state == SOF_IPC4_PIPE_RESET) {
+			/* Reset the end offset as the stream is stopped */
+			time_info->stream_end_offset = 0;
+		}
+
+		return 0;
+	}
 
 	/* allocate memory for the pipeline data */
 	trigger_list = kzalloc(struct_size(trigger_list, pipeline_instance_ids,
@@ -924,8 +948,24 @@ static int sof_ipc4_get_stream_start_off
 	if (!host_copier || !dai_copier)
 		return -EINVAL;
 
-	if (host_copier->data.gtw_cfg.node_id == SOF_IPC4_INVALID_NODE_ID)
+	if (host_copier->data.gtw_cfg.node_id == SOF_IPC4_INVALID_NODE_ID) {
 		return -EINVAL;
+	} else if (host_copier->data.gtw_cfg.node_id == SOF_IPC4_CHAIN_DMA_NODE_ID) {
+		/*
+		 * While the firmware does not supports time_info reporting for
+		 * streams using ChainDMA, it is granted that ChainDMA can only
+		 * be used on Host+Link pairs where the link position is
+		 * accessible from the host side.
+		 *
+		 * Enable delay calculation in case of ChainDMA via host
+		 * accessible registers.
+		 *
+		 * The ChainDMA uses 2x 1ms ping-pong buffer, dai side starts
+		 * when 1ms data is available
+		 */
+		time_info->stream_start_offset = substream->runtime->rate / MSEC_PER_SEC;
+		goto out;
+	}
 
 	node_index = SOF_IPC4_NODE_INDEX(host_copier->data.gtw_cfg.node_id);
 	offset = offsetof(struct sof_ipc4_fw_registers, pipeline_regs) + node_index * sizeof(ppl_reg);
@@ -943,6 +983,7 @@ static int sof_ipc4_get_stream_start_off
 	time_info->stream_end_offset = ppl_reg.stream_end_offset;
 	do_div(time_info->stream_end_offset, dai_sample_size);
 
+out:
 	/*
 	 * Calculate the wrap boundary need to be used for delay calculation
 	 * The host counter is in bytes, it will wrap earlier than the frames
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1782,10 +1782,10 @@ sof_ipc4_prepare_copier_module(struct sn
 			pipeline->msg.extension |= SOF_IPC4_GLB_EXT_CHAIN_DMA_FIFO_SIZE(fifo_size);
 
 			/*
-			 * Chain DMA does not support stream timestamping, set node_id to invalid
-			 * to skip the code in sof_ipc4_get_stream_start_offset().
+			 * Chain DMA does not support stream timestamping, but it
+			 * can use the host side registers for delay calculation.
 			 */
-			copier_data->gtw_cfg.node_id = SOF_IPC4_INVALID_NODE_ID;
+			copier_data->gtw_cfg.node_id = SOF_IPC4_CHAIN_DMA_NODE_ID;
 
 			return 0;
 		}
--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -58,6 +58,7 @@
 
 #define SOF_IPC4_DMA_DEVICE_MAX_COUNT 16
 
+#define SOF_IPC4_CHAIN_DMA_NODE_ID	0x7fffffff
 #define SOF_IPC4_INVALID_NODE_ID	0xffffffff
 
 /* FW requires minimum 4ms DMA buffer size */


