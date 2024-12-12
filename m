Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6951F211476;
	Thu, 12 Dec 2024 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016024; cv=none; b=XnVCP8NVE2jYCfe00RT8Qmfog/oND6Qql6bZTmFYIjaEWSFsU4vDh6vu++DQsNPGYHd6ZPJDS5RxurL9URSaDIACyKdOGbvxbTilkMTS1q1lS/0/O6q5n7SBmX3B3+1NPyW6gQFfxLh8wwnVxIpN6WzxvD9dKDtL2l0nndhSgW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016024; c=relaxed/simple;
	bh=mDvPE5ftZ6qlq6TMnmH51pv+6O3vdnJ8HvLOcuGQp2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6/3t+wWJ22WGa2M2maQY2J7bnqBfowEgiKY1zGtwFOyfvqGTG0B9o5PNPbJ/IokB+8KCxWvmck/Te9S3CL2+H9hLI0zuJyJzNRyZyT49xSIb89C5ZCQQ0Cs/gErK9c+9kBblVPB8QqGuiobjjD2JVkE/UeMVbm56eYhvOCbopE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nrc0RuPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nrc0RuPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A8DC4CECE;
	Thu, 12 Dec 2024 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016024;
	bh=mDvPE5ftZ6qlq6TMnmH51pv+6O3vdnJ8HvLOcuGQp2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nrc0RuPDqAmCQZUJI2PadP4JkSoC8eUy+iVbSds5SS3nj+t/VF4qk+GIKOGhAPIix
	 0dqMB+ctBGYgRdvEfkFduek7CmEvLK42+7pk00vBKxH0Fo0izmRpWBnu6lElYuDW2T
	 7HRDLd3YAFchQocRemjhU3/662644uSrh5MxI5/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/466] ASoC: SOF: ipc3-topology: Convert the topology pin index to ALH dai index
Date: Thu, 12 Dec 2024 15:54:22 +0100
Message-ID: <20241212144310.490616079@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit e9db1b551774037ebe39dde4a658d89ba95e260b ]

Intel SoundWire machine driver always uses Pin number 2 and above.
Currently, the pin number is used as the FW DAI index directly. As a
result, FW DAI 0 and 1 are never used. That worked fine because we use
up to 2 DAIs in a SDW link. Convert the topology pin index to ALH dai
index, the mapping is using 2-off indexing, iow, pin #2 is ALH dai #0.

The issue exists since beginning. And the Fixes tag is the first commit
that this commit can be applied.

Fixes: b66bfc3a9810 ("ASoC: SOF: sof-audio: Fix broken early bclk feature for SSP")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20241127092955.20026-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6d544ea21d36 ("ASoC: SOF: ipc3-topology: fix resource leaks in sof_ipc3_widget_setup_comp_dai()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-topology.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index be61e377e59e0..c2fce554a674b 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -20,6 +20,9 @@
 /* size of tplg ABI in bytes */
 #define SOF_IPC3_TPLG_ABI_SIZE 3
 
+/* Base of SOF_DAI_INTEL_ALH, this should be aligned with SOC_SDW_INTEL_BIDIR_PDI_BASE */
+#define INTEL_ALH_DAI_INDEX_BASE 2
+
 struct sof_widget_data {
 	int ctrl_type;
 	int ipc_cmd;
@@ -1594,6 +1597,17 @@ static int sof_ipc3_widget_setup_comp_dai(struct snd_sof_widget *swidget)
 	if (ret < 0)
 		goto free;
 
+	/* Subtract the base to match the FW dai index. */
+	if (comp_dai->type == SOF_DAI_INTEL_ALH) {
+		if (comp_dai->dai_index < INTEL_ALH_DAI_INDEX_BASE) {
+			dev_err(sdev->dev,
+				"Invalid ALH dai index %d, only Pin numbers >= %d can be used\n",
+				comp_dai->dai_index, INTEL_ALH_DAI_INDEX_BASE);
+			return -EINVAL;
+		}
+		comp_dai->dai_index -= INTEL_ALH_DAI_INDEX_BASE;
+	}
+
 	dev_dbg(scomp->dev, "dai %s: type %d index %d\n",
 		swidget->widget->name, comp_dai->type, comp_dai->dai_index);
 	sof_dbg_comp_config(scomp, &comp_dai->config);
@@ -2167,8 +2181,16 @@ static int sof_ipc3_dai_config(struct snd_sof_dev *sdev, struct snd_sof_widget *
 	case SOF_DAI_INTEL_ALH:
 		if (data) {
 			/* save the dai_index during hw_params and reuse it for hw_free */
-			if (flags & SOF_DAI_CONFIG_FLAGS_HW_PARAMS)
-				config->dai_index = data->dai_index;
+			if (flags & SOF_DAI_CONFIG_FLAGS_HW_PARAMS) {
+				/* Subtract the base to match the FW dai index. */
+				if (data->dai_index < INTEL_ALH_DAI_INDEX_BASE) {
+					dev_err(sdev->dev,
+						"Invalid ALH dai index %d, only Pin numbers >= %d can be used\n",
+						config->dai_index, INTEL_ALH_DAI_INDEX_BASE);
+					return -EINVAL;
+				}
+				config->dai_index = data->dai_index - INTEL_ALH_DAI_INDEX_BASE;
+			}
 			config->alh.stream_id = data->dai_data;
 		}
 		break;
-- 
2.43.0



