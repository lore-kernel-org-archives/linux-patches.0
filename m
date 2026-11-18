Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022550;
	b=fwUoEGR9qL64SM7YqnklRukD8FgcAf2k3khIBLCPGlCJ2UX+978UxV59gX3oe9QA8L1I
	 awwRqB7V0h+1Qfts/zndyytG/zCQx+g5oDrtbN69OfCdzhULzeEUFlyBCYv4r4vFLemo5
	 KE87shlEUxZEkvafcM7DzZEzwyUZqfj2JT0dGXasFKpImP7LuivQEdoXBSn7EfGhFCdLU
	 NpIXKB7rs09oEhjU4m5Natkj6ycnliEvWv6iHVp2+DYW7Lt1YStCmCO5rEOkb4aeJlU1S
	 X1wVdK7ymnag3ySf1aH+2xR+fnl5G0xzt/HQjdzuQtM7X9g98PKAg6TmO0OLDgK4T5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=V4iCn1Ta9w7HBWhxwf4U3oKx+YHqJiSGbcAG1naDrkM=;
	b=bD0zmu+6KAllXfFxgNSFF5rW0CpS9qKxZY09HL4yP6F2gwlPJ6DT8+YTmWyNGXKzjDIJ
	 mXnu0a6OZ5woiTkxnuEKZkXJkg4SCLRXZyJsvK5gB5g391PGKUF5BY6sHXvcqvoEqvwUT
	 mCP4lOQJDmvgvMMjojaPYDHk04pD8ZzcP1oWll0NWXo/TWtiy9twqYr1Tsj8Agb9EY/eR
	 3AgsouoLBDbOQxeNOPkvHK2gD00OM5FsTrBfyezy11uthZhBouug2r3xDgXodze/QNTuu
	 /Yq6UCBZPdR/JihSo57Jnx7OXSN2n9SaRkc9GLEDfhkhv85ZwAUOdYh5cp+kQxCgkmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ns/20IN7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8698606A32A;
	Wed, 18 Nov 2026 17:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ns/20IN7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D951F000C5;
	Wed, 18 Nov 2026 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022550;
	bh=V4iCn1Ta9w7HBWhxwf4U3oKx+YHqJiSGbcAG1naDrkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ns/20IN70PzqG2maKqNqAzOkckCxVjdqEhrzufLFIS1dL4m7gVbnD3eNv9shFnJoE
	 +O2QBP/87iaAswPrJatoMh1QBY+TSL+5FFQbMa8lcfgmaXF9h9xm5i8pu2T569YLg3
	 fZY45UfpCKylEoBa3gmhmCfaHOsrLZwRedZc3MZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0012/2151] ASoC/soundwire: Intel: reset the PCMSyCM registers in hda_sdw_bpt_close
Date: Wed, 18 Nov 2026 15:29:07 +0100
Message-ID: <20261118150122.086935494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 992eb0dfbc4f594d60ae57974efa835bfac34d1e ]

Resetting the PCMSyCM registers is required for Intel SoundWire stream. The
same procedure is done in sdw_hda_dai_hw_params() for the normal
SoundWire stream, too.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Acked-by: Vinod Koul <vkoul@kernel.org>
Link: https://patch.msgid.link/20260730012518.2180906-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 348bc756d912 ("ASoC: SOF: Intel: hda-sdw-bpt: Stop active DMA before closing BPT streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_ace2x.c   |  4 +++-
 include/sound/hda-sdw-bpt.h       |  5 +++--
 sound/soc/sof/intel/hda-sdw-bpt.c | 31 ++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/soundwire/intel_ace2x.c b/drivers/soundwire/intel_ace2x.c
index f0e0a79b30b0e..c1ea420bc11ff 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -192,6 +192,7 @@ static int intel_ace2x_bpt_open_stream(struct sdw_intel *sdw, struct sdw_slave *
 		__func__, str_read_write(command), ret);
 
 	ret1 = hda_sdw_bpt_close(cdns->dev->parent, /* PCI device */
+				 sdw->instance,
 				 sdw->bpt_ctx.bpt_tx_stream, &sdw->bpt_ctx.dmab_tx_bdl,
 				 sdw->bpt_ctx.bpt_rx_stream, &sdw->bpt_ctx.dmab_rx_bdl);
 	if (ret1 < 0)
@@ -226,7 +227,8 @@ static void intel_ace2x_bpt_close_stream(struct sdw_intel *sdw, struct sdw_slave
 	struct sdw_cdns *cdns = &sdw->cdns;
 	int ret;
 
-	ret = hda_sdw_bpt_close(cdns->dev->parent /* PCI device */, sdw->bpt_ctx.bpt_tx_stream,
+	ret = hda_sdw_bpt_close(cdns->dev->parent /* PCI device */, sdw->instance,
+				sdw->bpt_ctx.bpt_tx_stream,
 				&sdw->bpt_ctx.dmab_tx_bdl, sdw->bpt_ctx.bpt_rx_stream,
 				&sdw->bpt_ctx.dmab_rx_bdl);
 	if (ret < 0)
diff --git a/include/sound/hda-sdw-bpt.h b/include/sound/hda-sdw-bpt.h
index f649549b75d52..330cda50f100c 100644
--- a/include/sound/hda-sdw-bpt.h
+++ b/include/sound/hda-sdw-bpt.h
@@ -27,7 +27,7 @@ int hda_sdw_bpt_send_async(struct device *dev, struct hdac_ext_stream *bpt_tx_st
 int hda_sdw_bpt_wait(struct device *dev, struct hdac_ext_stream *bpt_tx_stream,
 		     struct hdac_ext_stream *bpt_rx_stream);
 
-int hda_sdw_bpt_close(struct device *dev, struct hdac_ext_stream *bpt_tx_stream,
+int hda_sdw_bpt_close(struct device *dev, int link_id, struct hdac_ext_stream *bpt_tx_stream,
 		      struct snd_dma_buffer *dmab_tx_bdl, struct hdac_ext_stream *bpt_rx_stream,
 		      struct snd_dma_buffer *dmab_rx_bdl);
 #else
@@ -56,7 +56,8 @@ static inline int hda_sdw_bpt_wait(struct device *dev, struct hdac_ext_stream *b
 	return -EOPNOTSUPP;
 }
 
-static inline int hda_sdw_bpt_close(struct device *dev, struct hdac_ext_stream *bpt_tx_stream,
+static inline int hda_sdw_bpt_close(struct device *dev, int link_id,
+				    struct hdac_ext_stream *bpt_tx_stream,
 				    struct snd_dma_buffer *dmab_tx_bdl,
 				    struct hdac_ext_stream *bpt_rx_stream,
 				    struct snd_dma_buffer *dmab_rx_bdl)
diff --git a/sound/soc/sof/intel/hda-sdw-bpt.c b/sound/soc/sof/intel/hda-sdw-bpt.c
index ff5abccf0d88b..4e5c99413c750 100644
--- a/sound/soc/sof/intel/hda-sdw-bpt.c
+++ b/sound/soc/sof/intel/hda-sdw-bpt.c
@@ -297,7 +297,8 @@ int hda_sdw_bpt_open(struct device *dev, int link_id, struct hdac_ext_stream **b
 		__func__, ret);
 
 close:
-	ret1 = hda_sdw_bpt_close(dev, *bpt_tx_stream, dmab_tx_bdl, *bpt_rx_stream, dmab_rx_bdl);
+	ret1 = hda_sdw_bpt_close(dev, link_id, *bpt_tx_stream, dmab_tx_bdl,
+				 *bpt_rx_stream, dmab_rx_bdl);
 	if (ret1 < 0)
 		dev_err(dev, "%s: hda_sdw_bpt_close failed: %d\n",
 			__func__, ret1);
@@ -422,14 +423,38 @@ int hda_sdw_bpt_wait(struct device *dev, struct hdac_ext_stream *bpt_tx_stream,
 }
 EXPORT_SYMBOL_NS(hda_sdw_bpt_wait, "SND_SOC_SOF_INTEL_HDA_SDW_BPT");
 
-int hda_sdw_bpt_close(struct device *dev, struct hdac_ext_stream *bpt_tx_stream,
+int hda_sdw_bpt_close(struct device *dev, int link_id, struct hdac_ext_stream *bpt_tx_stream,
 		      struct snd_dma_buffer *dmab_tx_bdl, struct hdac_ext_stream *bpt_rx_stream,
 		      struct snd_dma_buffer *dmab_rx_bdl)
 {
+	struct snd_sof_dev *sdev = dev_get_drvdata(dev);
 	int ret;
 	int ret1;
 
-	ret = hda_sdw_bpt_dma_deprepare(dev, bpt_rx_stream, dmab_rx_bdl);
+	/*
+	 * In the case of SoundWire we need to reset the PCMSyCM registers.
+	 * Need to continue depreparing the DMA buffers even if this fails.
+	 */
+	ret = hdac_bus_eml_sdw_map_stream_ch(sof_to_bus(sdev), link_id,
+					     0, /* PDI0 */
+					     0, 0, SNDRV_PCM_STREAM_PLAYBACK);
+	if (ret < 0)
+		dev_err(dev, "%s: hdac_bus_eml_sdw_map_stream_ch failed %d for PDI0\n",
+			__func__, ret);
+
+	ret1 = hdac_bus_eml_sdw_map_stream_ch(sof_to_bus(sdev), link_id,
+					      1, /* PDI1 */
+					      0, 0, SNDRV_PCM_STREAM_CAPTURE);
+	if (ret1 < 0) {
+		dev_err(dev, "%s: hdac_bus_eml_sdw_map_stream_ch failed %d for PDI1\n",
+			__func__, ret1);
+		if (!ret)
+			ret = ret1;
+	}
+
+	ret1 = hda_sdw_bpt_dma_deprepare(dev, bpt_rx_stream, dmab_rx_bdl);
+	if (!ret)
+		ret = ret1;
 
 	ret1 = hda_sdw_bpt_dma_deprepare(dev, bpt_tx_stream, dmab_tx_bdl);
 	if (!ret)
-- 
2.53.0



