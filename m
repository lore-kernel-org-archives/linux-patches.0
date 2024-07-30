Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EBC1A76AB;
	Tue, 30 Jul 2024 17:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360434; cv=none; b=D9D/JYzGYc83y0//M/hv5I61xdjEIhY5yfYVcvMgPBYrB80GzcdVSvk39Lb/tQTJVuVwxQwMiaPH4N38Sm0cDGOnv4p15IJUQpsTPzLNkLwhswGTfMEI4VSrB4jhTX/4O2+7iduiZcNENPMu425DIQwTdhB5H1w/gGUSZ3MWjbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360434; c=relaxed/simple;
	bh=CjVprBeJMo3jhVC5Y2Uv8OYNdWAZECDV4r0ho+8OZk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzHGlExspYAG7aatkjrcxbzA65pImgi5qm7jNImXo7hB1Vad93LuR+p1vRzMpkuzaAVxhOjLeewHog5nz85/rqJ0UZzsrjrq990gP7vTIpKJ3mD2rQMyQxWDQBxHd7d4imsPTWvMOmYIBqzkOyBvW0tCz78r+1p1q61amvH/LYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdECtI//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdECtI//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97187C32782;
	Tue, 30 Jul 2024 17:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360434;
	bh=CjVprBeJMo3jhVC5Y2Uv8OYNdWAZECDV4r0ho+8OZk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdECtI//a6l8AGFuG+sdieC6TGUV5b3M3AN4CFrWpFRfbs2UnaZnEbVZHRSR8vQ0Z
	 O0bTpfUyATAM6qEn1x9PwottHCCQPSeagZj9qohaNuGW1D962afnsjiLZVnvr7Su8P
	 nHiclaL2Vv0yq6d5VTMhh5Jsvp7tGIGRhj1JbvGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 667/809] ASoC: SOF: ipc4-topology: Only handle dai_config with HW_PARAMS for ChainDMA
Date: Tue, 30 Jul 2024 17:49:03 +0200
Message-ID: <20240730151751.248431936@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit ae67ed9010a7b52933ad1038d13df8a3aae34b83 upstream.

The DMA Link ID is only valid in snd_sof_dai_config_data when the
dai_config is called with HW_PARAMS.

The commit that this patch fixes is actually moved a code section without
changing it, the same bug exists in the original code, needing different
patch to kernel prior to 6.9 kernels.

Cc: stable@vger.kernel.org
Fixes: 3858464de57b ("ASoC: SOF: ipc4-topology: change chain_dma handling in dai_config")
Link: https://github.com/thesofproject/linux/issues/5116
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://patch.msgid.link/20240724081932.24542-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -3093,8 +3093,14 @@ static int sof_ipc4_dai_config(struct sn
 		return 0;
 
 	if (pipeline->use_chain_dma) {
-		pipeline->msg.primary &= ~SOF_IPC4_GLB_CHAIN_DMA_LINK_ID_MASK;
-		pipeline->msg.primary |= SOF_IPC4_GLB_CHAIN_DMA_LINK_ID(data->dai_data);
+		/*
+		 * Only configure the DMA Link ID for ChainDMA when this op is
+		 * invoked with SOF_DAI_CONFIG_FLAGS_HW_PARAMS
+		 */
+		if (flags & SOF_DAI_CONFIG_FLAGS_HW_PARAMS) {
+			pipeline->msg.primary &= ~SOF_IPC4_GLB_CHAIN_DMA_LINK_ID_MASK;
+			pipeline->msg.primary |= SOF_IPC4_GLB_CHAIN_DMA_LINK_ID(data->dai_data);
+		}
 		return 0;
 	}
 


