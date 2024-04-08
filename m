Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0CC7F7C6;
	Mon,  8 Apr 2024 13:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584005; cv=none; b=nOltP0TsJgk1Zs+wQt8KQMmnOf9/9pyqlf2uFgXL2+0vVJ9L0xTLiZz7Wi/dkIqQt11TDcT+pVWm1M1C6GVXGWq+OPNALIbUih4xePiL6QWnzC6z1GVx6Ed7bP3EqUaKvdnvqv30SttHIxPoxB6IhMb9U4/kZFvahFCxP0SXWMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584005; c=relaxed/simple;
	bh=NeStGnpTqt0LuVAdhLz9cU+sexQRcutfpjJnkyOFcog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuPO5kg7NWMqSpw9hHCRKk6JXNMchs5DCcHZpLepTqbD3CDjw4c9pMPFKb/LymuyqACPbb9Uo5Mws+gbbKrODbspJBsKB6mADPvdsaUFbvtvt2VxMh5U1tiPX0TvOgjY+OHoyV0WYgA0sfdPLjMWS8jBBbtSQGaanrgxFReAty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkKRwh37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkKRwh37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC38C433F1;
	Mon,  8 Apr 2024 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584004;
	bh=NeStGnpTqt0LuVAdhLz9cU+sexQRcutfpjJnkyOFcog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkKRwh37kJuOn9z/YrLjeW/dgO9CHrbC+rmPoH87TLDgNaue/MZmeXrgN+NNRJxk7
	 VcoSE6H2h/d97FWKE5O3bdbzelf7K9mTuYtUGB8y9rQqmCNd6eiIcsizqgbkf6MitU
	 1k7ESv5LXkcwveliyVbwFqicdprgCyy4yxonVipc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 222/273] ASoC: SOF: ipc4-pcm: Move struct sof_ipc4_timestamp_info definition locally
Date: Mon,  8 Apr 2024 14:58:17 +0200
Message-ID: <20240408125316.302964648@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

commit 31d2874d083ba6cc2a4f4b26dab73c3be1c92658 upstream.

The sof_ipc4_timestamp_info is only used by ipc4-pcm.c internally, it
should not be in a generic header implying that it might be used elsewhere.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-12-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-pcm.c  |   14 ++++++++++++++
 sound/soc/sof/ipc4-priv.h |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -15,6 +15,20 @@
 #include "ipc4-topology.h"
 #include "ipc4-fw-reg.h"
 
+/**
+ * struct sof_ipc4_timestamp_info - IPC4 timestamp info
+ * @host_copier: the host copier of the pcm stream
+ * @dai_copier: the dai copier of the pcm stream
+ * @stream_start_offset: reported by fw in memory window
+ * @llp_offset: llp offset in memory window
+ */
+struct sof_ipc4_timestamp_info {
+	struct sof_ipc4_copier *host_copier;
+	struct sof_ipc4_copier *dai_copier;
+	u64 stream_start_offset;
+	u32 llp_offset;
+};
+
 static int sof_ipc4_set_multi_pipeline_state(struct snd_sof_dev *sdev, u32 state,
 					     struct ipc4_pipeline_set_state_data *trigger_list)
 {
--- a/sound/soc/sof/ipc4-priv.h
+++ b/sound/soc/sof/ipc4-priv.h
@@ -88,20 +88,6 @@ struct sof_ipc4_fw_data {
 	struct mutex pipeline_state_mutex; /* protect pipeline triggers, ref counts and states */
 };
 
-/**
- * struct sof_ipc4_timestamp_info - IPC4 timestamp info
- * @host_copier: the host copier of the pcm stream
- * @dai_copier: the dai copier of the pcm stream
- * @stream_start_offset: reported by fw in memory window
- * @llp_offset: llp offset in memory window
- */
-struct sof_ipc4_timestamp_info {
-	struct sof_ipc4_copier *host_copier;
-	struct sof_ipc4_copier *dai_copier;
-	u64 stream_start_offset;
-	u32 llp_offset;
-};
-
 extern const struct sof_ipc_fw_loader_ops ipc4_loader_ops;
 extern const struct sof_ipc_tplg_ops ipc4_tplg_ops;
 extern const struct sof_ipc_tplg_control_ops tplg_ipc4_control_ops;


