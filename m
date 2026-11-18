Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041832;
	b=hY6bSnbCb9lPbnL6veibUs/mZCW/Nn1C/5CJB3SrfNzXBeSqD68pxubq/ENgwobPJdXs
	 1dk4UcF67eOsRS1O6UZAJ7UN7m9vfjPZvMj9RHoMoj3z/I80fqoV/2exD/1XdV3sHAlUS
	 pcQ8k8OMuJUAcL9KfbsTUTIb17jTU0Rt/DbYWi73DDaOMRiKnoRDkdNzHKjHWJnsomeP5
	 I8MoJhFB7iD06kjoEpLAQ6rGevx7Y965jQ5YnS0LhCPwWu9zPBn9175ldFEavuZAYX+V2
	 HgIXYviuP8CFWHEKSZJVCtWuUJWcLb+kWdgxjoYuSvneCo86IsLDRSPR7+mc2q10rog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kwK5RxgDGJHkw6VpGxoD8F2CsF0wTXIK29np4Fy48nY=;
	b=pbhi85vYcbJ3GCwLDkTEO4T0o5OpUUbljPn1QZYPdVeVgt4m2RgSpVW93TDPm0taVHAP
	 Pe/NcLJpL3bc7LpC6KFxkil7RW1cOM5sZrbDVukOuUiJWQTdVPK452Itx9aD9OwWuenBF
	 25Cr/PPE+R3Y845GMZA0jv8XdFOW+LbO4+XKz4FZI69tR8lLMc2kUB3ty09nbk/zKWPWh
	 Z5k41fDIVtTZsu3cn/EqIgaAVlVI/G1uE0lq15MFXd+1GI/u/tmH9GsY+ZYT3j44Ir/H8
	 XwXf0S5uHlJk1o/1oOMiDC3H+elQRSVt499fAAwxaBLRTESkEzslR6PFO1v0ocpqxMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McV41IF7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CAE606A320;
	Wed, 18 Nov 2026 22:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McV41IF7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54671F000C4;
	Wed, 18 Nov 2026 22:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041832;
	bh=kwK5RxgDGJHkw6VpGxoD8F2CsF0wTXIK29np4Fy48nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McV41IF7rUzHO+4XMrGugBeRUvgoZVA1q1jHmVIZZDGMEH3yYXML77IBbUckvJ/pt
	 EMeaFG7TTrvJ1byeWEi+02Ef4/vyCXZpv41I6uDKp+7xOpR+80qcAj6utER04ZIOBp
	 jXBnxDiIXCDC3RwUlbQpqGaj6LfP0vm8136BZhg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2937/3318] ASoC: Intel: avs: Store pointer to link_stream in dma_data
Date: Wed, 18 Nov 2026 15:59:19 +0100
Message-ID: <20261118150448.477618301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit cdcb770a60e8e6b9fbb737ebe21b2daadaba1744 ]

While the HDAudio codec driver expectations must be met - store valid
pointer to HDAudio LINK stream in substream->runtime->private_data - the
code is more readable and easier to maintain if dma_data stores pointers
to both HOST and LINK stream.

DAI BE operations can refer to the LINK stream with data->link_stream,
similarly to how DAI FE operations access the HOST stream with
data->host_stream.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20240426095733.3946951-8-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 85bc213f96ac ("ASoC: Intel: avs: Unprepare a stream when recovery occurs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 40 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 4d98926de42ae..4c3ed762bedf8 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -22,13 +22,12 @@ struct avs_dma_data {
 	struct avs_tplg_path_template *template;
 	struct avs_path *path;
 	struct avs_dev *adev;
-	/*
-	 * link stream is stored within substream's runtime
-	 * private_data to fulfill the needs of codec BE path
-	 *
-	 * host stream assigned
-	 */
-	struct hdac_ext_stream *host_stream;
+
+	/* LINK-stream utilized in BE operations while HOST in FE ones. */
+	union {
+		struct hdac_ext_stream *link_stream;
+		struct hdac_ext_stream *host_stream;
+	};
 
 	struct snd_pcm_substream *substream;
 };
@@ -278,6 +277,7 @@ static int avs_dai_hda_be_startup(struct snd_pcm_substream *substream, struct sn
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct hdac_ext_stream *link_stream;
+	struct avs_dma_data *data;
 	struct hda_codec *codec;
 	int ret;
 
@@ -293,18 +293,18 @@ static int avs_dai_hda_be_startup(struct snd_pcm_substream *substream, struct sn
 		return -EBUSY;
 	}
 
+	data = snd_soc_dai_get_dma_data(dai, substream);
+	data->link_stream = link_stream;
 	substream->runtime->private_data = link_stream;
 	return 0;
 }
 
 static void avs_dai_hda_be_shutdown(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
-	struct hdac_ext_stream *link_stream;
+	struct avs_dma_data *data = snd_soc_dai_get_dma_data(dai, substream);
 
-	link_stream = substream->runtime->private_data;
-	snd_hdac_ext_stream_release(link_stream, HDAC_EXT_STREAM_TYPE_LINK);
+	snd_hdac_ext_stream_release(data->link_stream, HDAC_EXT_STREAM_TYPE_LINK);
 	substream->runtime->private_data = NULL;
-
 	avs_dai_shutdown(substream, dai);
 }
 
@@ -312,16 +312,13 @@ static int avs_dai_hda_be_hw_params(struct snd_pcm_substream *substream,
 				    struct snd_pcm_hw_params *hw_params, struct snd_soc_dai *dai)
 {
 	struct avs_dma_data *data;
-	struct hdac_ext_stream *link_stream;
 
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	if (data->path)
 		return 0;
 
-	link_stream = substream->runtime->private_data;
-
 	return avs_dai_be_hw_params(substream, hw_params, dai,
-				    hdac_stream(link_stream)->stream_tag - 1);
+				    hdac_stream(data->link_stream)->stream_tag - 1);
 }
 
 static int avs_dai_hda_be_hw_free(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
@@ -338,7 +335,7 @@ static int avs_dai_hda_be_hw_free(struct snd_pcm_substream *substream, struct sn
 	if (!data->path)
 		return 0;
 
-	link_stream = substream->runtime->private_data;
+	link_stream = data->link_stream;
 	link_stream->link_prepared = false;
 	avs_path_free(data->path);
 	data->path = NULL;
@@ -362,13 +359,16 @@ static int avs_dai_hda_be_prepare(struct snd_pcm_substream *substream, struct sn
 	struct snd_soc_pcm_stream *stream_info;
 	struct hdac_ext_stream *link_stream;
 	struct hdac_ext_link *link;
+	struct avs_dma_data *data;
 	struct hda_codec *codec;
 	struct hdac_bus *bus;
 	unsigned int format_val;
 	unsigned int bits;
 	int ret;
 
-	link_stream = runtime->private_data;
+	data = snd_soc_dai_get_dma_data(dai, substream);
+	link_stream = data->link_stream;
+
 	if (link_stream->link_prepared)
 		return 0;
 
@@ -402,14 +402,12 @@ static int avs_dai_hda_be_trigger(struct snd_pcm_substream *substream, int cmd,
 				  struct snd_soc_dai *dai)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct hdac_ext_stream *link_stream;
 	struct avs_dma_data *data;
 	int ret = 0;
 
 	dev_dbg(dai->dev, "entry %s cmd=%d\n", __func__, cmd);
 
 	data = snd_soc_dai_get_dma_data(dai, substream);
-	link_stream = substream->runtime->private_data;
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_RESUME:
@@ -418,7 +416,7 @@ static int avs_dai_hda_be_trigger(struct snd_pcm_substream *substream, int cmd,
 		fallthrough;
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		snd_hdac_ext_stream_start(link_stream);
+		snd_hdac_ext_stream_start(data->link_stream);
 
 		ret = avs_path_pause(data->path);
 		if (ret < 0) {
@@ -441,7 +439,7 @@ static int avs_dai_hda_be_trigger(struct snd_pcm_substream *substream, int cmd,
 		if (ret < 0)
 			dev_err(dai->dev, "pause BE path failed: %d\n", ret);
 
-		snd_hdac_ext_stream_clear(link_stream);
+		snd_hdac_ext_stream_clear(data->link_stream);
 
 		ret = avs_path_reset(data->path);
 		if (ret < 0)
-- 
2.53.0



