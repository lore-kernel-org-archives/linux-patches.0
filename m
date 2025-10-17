Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14651946C8;
	Fri, 17 Oct 2025 15:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715032; cv=none; b=KhkcFM7BMsQf/yDBGjzRSYmcCU6lOTaWsfQU1aOIs6c+qdFVRlb5ue0kD8cR4xhUutiC1hJhfsGCHGSyNStfDYDSrSbxrjhNY3xxElSB+alAldF5vrpT11yQUF6nlEc4HKAJM8jXb/VnqpXLheC9+ug7a/gujQZU9AK30Lch4CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715032; c=relaxed/simple;
	bh=jXvPw7X0f4jKwWlVhsVpvx8V3u0L8yXL1poCKCQtXws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZmkGOw8B+M9B6jhVsO9J7I42+gZd0VQPLY33IgxTjF+TGQM/q0FP2YKGrHS9cxK1yETIBV3Aw9wp3lvbroU7hXxepjm3PxaV1ndA8p8IgM/fxfZ0T2KiNbm22kABuUCKTmGfFncINFYM318ru0B2vI6EuREs6VKDBP4wfA9aog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajeUQcpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajeUQcpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5430BC4CEE7;
	Fri, 17 Oct 2025 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715032;
	bh=jXvPw7X0f4jKwWlVhsVpvx8V3u0L8yXL1poCKCQtXws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajeUQcpf2pXEYSvdR2KnAoWW+EPt1EAQaziY/yRKwmLHcOwzLR2mpm1jnBx71blxk
	 MH8JWUYRhpFZCcWKkti9jFejADaYRRHZxxrXpXENrPBkXFQdOueqXYsYkdLt4AkoD1
	 ezxhkFH6lLvhfXIgrnQA3pZ6PnTDRSToW6baP6Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 074/371] ASoC: SOF: ipc4-topology: Account for different ChainDMA host buffer size
Date: Fri, 17 Oct 2025 16:50:49 +0200
Message-ID: <20251017145204.618816210@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 3dcf683bf1062d69014fe81b90d285c7eb85ca8a ]

For ChainDMA the firmware allocates 5ms host buffer instead of the standard
4ms which should be taken into account when setting the constraint on the
buffer size.

Fixes: 842bb8b62cc6 ("ASoC: SOF: ipc4-topology: Save the DMA maximum burst size for PCMs")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20251002135752.2430-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 9 +++++++--
 sound/soc/sof/ipc4-topology.h | 3 +++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index c93db452bbc07..16053d224dcdb 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -623,8 +623,13 @@ static int sof_ipc4_widget_setup_pcm(struct snd_sof_widget *swidget)
 				      swidget->tuples,
 				      swidget->num_tuples, sizeof(u32), 1);
 		/* Set default DMA buffer size if it is not specified in topology */
-		if (!sps->dsp_max_burst_size_in_ms)
-			sps->dsp_max_burst_size_in_ms = SOF_IPC4_MIN_DMA_BUFFER_SIZE;
+		if (!sps->dsp_max_burst_size_in_ms) {
+			struct snd_sof_widget *pipe_widget = swidget->spipe->pipe_widget;
+			struct sof_ipc4_pipeline *pipeline = pipe_widget->private;
+
+			sps->dsp_max_burst_size_in_ms = pipeline->use_chain_dma ?
+				SOF_IPC4_CHAIN_DMA_BUFFER_SIZE : SOF_IPC4_MIN_DMA_BUFFER_SIZE;
+		}
 	} else {
 		/* Capture data is copied from DSP to host in 1ms bursts */
 		spcm->stream[dir].dsp_max_burst_size_in_ms = 1;
diff --git a/sound/soc/sof/ipc4-topology.h b/sound/soc/sof/ipc4-topology.h
index ce5c69cb9ea4e..2a2afd0e83338 100644
--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -64,6 +64,9 @@
 /* FW requires minimum 4ms DMA buffer size */
 #define SOF_IPC4_MIN_DMA_BUFFER_SIZE	4
 
+/* ChainDMA in fw uses 5ms DMA buffer */
+#define SOF_IPC4_CHAIN_DMA_BUFFER_SIZE	5
+
 /*
  * The base of multi-gateways. Multi-gateways addressing starts from
  * ALH_MULTI_GTW_BASE and there are ALH_MULTI_GTW_COUNT multi-sources
-- 
2.51.0



