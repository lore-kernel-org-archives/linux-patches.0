Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9059523E342;
	Mon, 13 Apr 2026 16:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098730; cv=none; b=VPrexa+q+86BZ82p+2nPAEDOUQQYXTlNeUedMeSVhA26ZeLRoj6d7Nabry/bEhEt1xBJ3ez3jBmvYWGEFzIsrt7zGoRegUXxo+GbEbamP86+sT8CgnMa8bWu2/tSGnDYVT56TfUo44rrvKEysWiDQ1jP+UUhFDeBUCfMYw+Y+94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098730; c=relaxed/simple;
	bh=IuUDVXnY1L+7L82Ozrsx+BM472O0V3LQb8cc0VIIk50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d53ADgZ5ngcof2FKSsB+8VLOWzuUAgQ+x8rk4dxfkl/w0TDoUF32FycO53f991r5OJ9n+SRD2RfHzHDwWY++G+wi12Pium6q6Dk1dkTu1lMp61k8yzFv4qy4HYwaiMHRsGeU7p8b0PtzkgQchyaHkTlE3fWsquVGzmMP2yv6Ltk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+tUywbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+tUywbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E7AC2BCB0;
	Mon, 13 Apr 2026 16:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098730;
	bh=IuUDVXnY1L+7L82Ozrsx+BM472O0V3LQb8cc0VIIk50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+tUywbA+krSDIwfLhZqAW0KG+hRx4ihOUXMkfDmZ88SG9MNEh52JHv8WvsNSTxVo
	 khBwKrBwxyDgcsUwyNlyi5Wbhrty3qm74cM28K0syBB0ng0QPnCIfWojndvS3j70/G
	 EXlXUTLk+H7tw6TuRAJR44AHI0j6xt9eBMkn2Zk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/491] ASoC: topology: use inclusive language for bclk and fsync
Date: Mon, 13 Apr 2026 17:55:10 +0200
Message-ID: <20260413155821.481125623@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit f026c123001bcc15b78311495cec79a8b73c3cf2 ]

Mirror suggested changes in alsa-lib.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20201112163100.5081-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 95bc5c225513 ("ASoC: soc-core: flush delayed work before removing DAIs and widgets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-dai.h   | 32 ++++++++++++++++++++------------
 include/uapi/sound/asoc.h | 22 ++++++++++++++--------
 sound/soc/soc-topology.c  | 24 ++++++++++++------------
 sound/soc/sof/topology.c  |  6 +++---
 4 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/include/sound/soc-dai.h b/include/sound/soc-dai.h
index fe86172e86020..580d1e6b935e6 100644
--- a/include/sound/soc-dai.h
+++ b/include/sound/soc-dai.h
@@ -72,21 +72,29 @@ struct snd_compr_stream;
 #define SND_SOC_DAIFMT_IB_IF		(4 << 8) /* invert BCLK + FRM */
 
 /*
- * DAI hardware clock masters.
+ * DAI hardware clock providers/consumers
  *
  * This is wrt the codec, the inverse is true for the interface
- * i.e. if the codec is clk and FRM master then the interface is
- * clk and frame secondary.
+ * i.e. if the codec is clk and FRM provider then the interface is
+ * clk and frame consumer.
  */
-#define SND_SOC_DAIFMT_CBM_CFM		(1 << 12) /* codec clk & FRM master */
-#define SND_SOC_DAIFMT_CBS_CFM		(2 << 12) /* codec clk secondary & FRM master */
-#define SND_SOC_DAIFMT_CBM_CFS		(3 << 12) /* codec clk master & frame secondary */
-#define SND_SOC_DAIFMT_CBS_CFS		(4 << 12) /* codec clk & FRM secondary */
-
-#define SND_SOC_DAIFMT_FORMAT_MASK	0x000f
-#define SND_SOC_DAIFMT_CLOCK_MASK	0x00f0
-#define SND_SOC_DAIFMT_INV_MASK		0x0f00
-#define SND_SOC_DAIFMT_MASTER_MASK	0xf000
+#define SND_SOC_DAIFMT_CBP_CFP		(1 << 12) /* codec clk provider & frame provider */
+#define SND_SOC_DAIFMT_CBC_CFP		(2 << 12) /* codec clk consumer & frame provider */
+#define SND_SOC_DAIFMT_CBP_CFC		(3 << 12) /* codec clk provider & frame consumer */
+#define SND_SOC_DAIFMT_CBC_CFC		(4 << 12) /* codec clk consumer & frame follower */
+
+/* previous definitions kept for backwards-compatibility, do not use in new contributions */
+#define SND_SOC_DAIFMT_CBM_CFM		SND_SOC_DAIFMT_CBP_CFP
+#define SND_SOC_DAIFMT_CBS_CFM		SND_SOC_DAIFMT_CBC_CFP
+#define SND_SOC_DAIFMT_CBM_CFS		SND_SOC_DAIFMT_CBP_CFC
+#define SND_SOC_DAIFMT_CBS_CFS		SND_SOC_DAIFMT_CBC_CFC
+
+#define SND_SOC_DAIFMT_FORMAT_MASK		0x000f
+#define SND_SOC_DAIFMT_CLOCK_MASK		0x00f0
+#define SND_SOC_DAIFMT_INV_MASK			0x0f00
+#define SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK	0xf000
+
+#define SND_SOC_DAIFMT_MASTER_MASK	SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK
 
 /*
  * Master Clock Directions
diff --git a/include/uapi/sound/asoc.h b/include/uapi/sound/asoc.h
index a74ca232f1fc1..da61398b1f8f3 100644
--- a/include/uapi/sound/asoc.h
+++ b/include/uapi/sound/asoc.h
@@ -170,16 +170,22 @@
 #define SND_SOC_TPLG_LNK_FLGBIT_VOICE_WAKEUP            (1 << 3)
 
 /* DAI topology BCLK parameter
- * For the backwards capability, by default codec is bclk master
+ * For the backwards capability, by default codec is bclk provider
  */
-#define SND_SOC_TPLG_BCLK_CM         0 /* codec is bclk master */
-#define SND_SOC_TPLG_BCLK_CS         1 /* codec is bclk slave */
+#define SND_SOC_TPLG_BCLK_CP         0 /* codec is bclk provider */
+#define SND_SOC_TPLG_BCLK_CC         1 /* codec is bclk consumer */
+/* keep previous definitions for compatibility */
+#define SND_SOC_TPLG_BCLK_CM         SND_SOC_TPLG_BCLK_CP
+#define SND_SOC_TPLG_BCLK_CS         SND_SOC_TPLG_BCLK_CC
 
 /* DAI topology FSYNC parameter
- * For the backwards capability, by default codec is fsync master
+ * For the backwards capability, by default codec is fsync provider
  */
-#define SND_SOC_TPLG_FSYNC_CM         0 /* codec is fsync master */
-#define SND_SOC_TPLG_FSYNC_CS         1 /* codec is fsync slave */
+#define SND_SOC_TPLG_FSYNC_CP         0 /* codec is fsync provider */
+#define SND_SOC_TPLG_FSYNC_CC         1 /* codec is fsync consumer */
+/* keep previous definitions for compatibility */
+#define SND_SOC_TPLG_FSYNC_CM         SND_SOC_TPLG_FSYNC_CP
+#define SND_SOC_TPLG_FSYNC_CS         SND_SOC_TPLG_FSYNC_CC
 
 /*
  * Block Header.
@@ -336,8 +342,8 @@ struct snd_soc_tplg_hw_config {
 	__u8 clock_gated;	/* SND_SOC_TPLG_DAI_CLK_GATE_ value */
 	__u8 invert_bclk;	/* 1 for inverted BCLK, 0 for normal */
 	__u8 invert_fsync;	/* 1 for inverted frame clock, 0 for normal */
-	__u8 bclk_master;	/* SND_SOC_TPLG_BCLK_ value */
-	__u8 fsync_master;	/* SND_SOC_TPLG_FSYNC_ value */
+	__u8 bclk_provider;	/* SND_SOC_TPLG_BCLK_ value */
+	__u8 fsync_provider;	/* SND_SOC_TPLG_FSYNC_ value */
 	__u8 mclk_direction;    /* SND_SOC_TPLG_MCLK_ value */
 	__le16 reserved;	/* for 32bit alignment */
 	__le32 mclk_rate;	/* MCLK or SYSCLK freqency in Hz */
diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index aa57f796e9dd3..b9ef95c99c6ee 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2173,7 +2173,7 @@ static void set_link_hw_format(struct snd_soc_dai_link *link,
 			struct snd_soc_tplg_link_config *cfg)
 {
 	struct snd_soc_tplg_hw_config *hw_config;
-	unsigned char bclk_master, fsync_master;
+	unsigned char bclk_provider, fsync_provider;
 	unsigned char invert_bclk, invert_fsync;
 	int i;
 
@@ -2213,18 +2213,18 @@ static void set_link_hw_format(struct snd_soc_dai_link *link,
 			link->dai_fmt |= SND_SOC_DAIFMT_IB_IF;
 
 		/* clock masters */
-		bclk_master = (hw_config->bclk_master ==
-			       SND_SOC_TPLG_BCLK_CM);
-		fsync_master = (hw_config->fsync_master ==
-				SND_SOC_TPLG_FSYNC_CM);
-		if (bclk_master && fsync_master)
-			link->dai_fmt |= SND_SOC_DAIFMT_CBM_CFM;
-		else if (!bclk_master && fsync_master)
-			link->dai_fmt |= SND_SOC_DAIFMT_CBS_CFM;
-		else if (bclk_master && !fsync_master)
-			link->dai_fmt |= SND_SOC_DAIFMT_CBM_CFS;
+		bclk_provider = (hw_config->bclk_provider ==
+			       SND_SOC_TPLG_BCLK_CP);
+		fsync_provider = (hw_config->fsync_provider ==
+				SND_SOC_TPLG_FSYNC_CP);
+		if (bclk_provider && fsync_provider)
+			link->dai_fmt |= SND_SOC_DAIFMT_CBP_CFP;
+		else if (!bclk_provider && fsync_provider)
+			link->dai_fmt |= SND_SOC_DAIFMT_CBC_CFP;
+		else if (bclk_provider && !fsync_provider)
+			link->dai_fmt |= SND_SOC_DAIFMT_CBP_CFC;
 		else
-			link->dai_fmt |= SND_SOC_DAIFMT_CBS_CFS;
+			link->dai_fmt |= SND_SOC_DAIFMT_CBC_CFC;
 	}
 }
 
diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index b6327c30c2b5a..e3aa9fa0f112f 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2786,15 +2786,15 @@ static void sof_dai_set_format(struct snd_soc_tplg_hw_config *hw_config,
 			       struct sof_ipc_dai_config *config)
 {
 	/* clock directions wrt codec */
-	if (hw_config->bclk_master == SND_SOC_TPLG_BCLK_CM) {
+	if (hw_config->bclk_provider == SND_SOC_TPLG_BCLK_CM) {
 		/* codec is bclk master */
-		if (hw_config->fsync_master == SND_SOC_TPLG_FSYNC_CM)
+		if (hw_config->fsync_provider == SND_SOC_TPLG_FSYNC_CM)
 			config->format |= SOF_DAI_FMT_CBM_CFM;
 		else
 			config->format |= SOF_DAI_FMT_CBM_CFS;
 	} else {
 		/* codec is bclk slave */
-		if (hw_config->fsync_master == SND_SOC_TPLG_FSYNC_CM)
+		if (hw_config->fsync_provider == SND_SOC_TPLG_FSYNC_CM)
 			config->format |= SOF_DAI_FMT_CBS_CFM;
 		else
 			config->format |= SOF_DAI_FMT_CBS_CFS;
-- 
2.51.0



