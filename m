Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD11018DF83;
	Mon, 28 Oct 2024 06:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098484; cv=none; b=RBK+km1iUHfLWAQIYyCqG0BtCUIPXq3FTo0Ywp84f5Ap+vwHVYGpjtzocbOvwof0ShGq+QLeSbq6g9TIvYkGKTIZshGrELJKGP0Gy2y/fT8fgP4lNJJxGogyRjMXEuEbThY/hMHQBvXqLVWwco1iLPCTlzmKG6HgFdIb6apxXRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098484; c=relaxed/simple;
	bh=XK6ezY1xONK767U9Lk+vjbRYCqceCjp6NPUe3ZtIchI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=es6u2JwpAl9S6FyZt/JWn3v8enCnlwAb0l4Byfjow+SGQH9e0azIM37en6coMHFC1J/PyihOWMMTR9ucSBgyQRX6wvUvGzdXBHZ74Kzc0AGa4s3pRSXUPICRB4SN2s+faSkstOFzMkv0fCYG4sQhJyaPqlKcy1f4t9JYs+w76eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IApYTO2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IApYTO2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6DAC4CEC3;
	Mon, 28 Oct 2024 06:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098484;
	bh=XK6ezY1xONK767U9Lk+vjbRYCqceCjp6NPUe3ZtIchI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IApYTO2TRD2nZ67f6OlDXT/KouABThTP3qbALDX9j2d8RJd53aNDZ+xw/ErnaQbeE
	 jhtXCPLw3711WWG3N1V3tHoPH5x2ae4gy8d0O9SlbdjtAfN4079x6GmTSjhliKbfs4
	 nhSBlc4RwsmvfsTPb5YgmKnXptjnQqDfxllpsNHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 246/261] ASoC: SOF: ipc4-topology: Do not set ALH node_id for aggregated DAIs
Date: Mon, 28 Oct 2024 07:26:28 +0100
Message-ID: <20241028062318.276656503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

commit 9822b4c90d77e3c6555fb21c459c4a61c6a8619f upstream.

For aggregated DAIs, the node ID is set to the group_id during the DAI
widget's ipc_prepare op. With the current logic, setting the dai_index
for node_id in the dai_config is redundant as it will be overwritten
with the group_id anyway. Removing it will also prevent any accidental
clearing/resetting of the group_id for aggregated DAIs due to the
dai_config calls could that happen before the allocated group_id is
freed.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
All: stable@vger.kernel.org # 6.10.x 6.11.x
Link: https://patch.msgid.link/20241016032910.14601-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 87be7f16e8c2..240fee2166d1 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -3129,9 +3129,20 @@ static int sof_ipc4_dai_config(struct snd_sof_dev *sdev, struct snd_sof_widget *
 		 * group_id during copier's ipc_prepare op.
 		 */
 		if (flags & SOF_DAI_CONFIG_FLAGS_HW_PARAMS) {
+			struct sof_ipc4_alh_configuration_blob *blob;
+
+			blob = (struct sof_ipc4_alh_configuration_blob *)ipc4_copier->copier_config;
 			ipc4_copier->dai_index = data->dai_node_id;
-			copier_data->gtw_cfg.node_id &= ~SOF_IPC4_NODE_INDEX_MASK;
-			copier_data->gtw_cfg.node_id |= SOF_IPC4_NODE_INDEX(data->dai_node_id);
+
+			/*
+			 * no need to set the node_id for aggregated DAI's. These will be assigned
+			 * a group_id during widget ipc_prepare
+			 */
+			if (blob->alh_cfg.device_count == 1) {
+				copier_data->gtw_cfg.node_id &= ~SOF_IPC4_NODE_INDEX_MASK;
+				copier_data->gtw_cfg.node_id |=
+					SOF_IPC4_NODE_INDEX(data->dai_node_id);
+			}
 		}
 
 		break;
-- 
2.47.0



