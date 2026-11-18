Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041777;
	b=gQnxS3K2bh+bUJDFO+4rchXA0/mOy1ILH6j9kYpOSZLtGXWf8+rFqjjvY3XJkYlEsR3f
	 BYMNcQVA+pured11n5G5snHqxulBVo1iIziyM0oN+DrGi5UbGc68We9tzxtgPNj8nB3Qn
	 4238Ls1veqXrAXZwCG7VBa2M3HLPNc/uqTLN5bcsav/Uf9lzX1PQM96jqmv9gDbf/CGBK
	 ylwT4bKdqUkfJcAnig2I9KogMBs9ixmNE9cxZlmkSQys6W9oSXjKdCcGZSrZreuZmWuTG
	 fYL0neGfvBYh9CF9X5p+qepIR1vYFNPYXJyFEhvEnL4rMK2CY5RNHAsFMSvaFFo0ujg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+0mnzuUwfeGWMIQWQCthmVQ4JkOpdBTCrZg+JZLqC34=;
	b=j1qQQQeppwfjk5N4RPeFuqW9xFF3cqQgpUj0Tnin9X3U8a74neAV7QnJCtq0zaxDwTQP
	 qvi7mG+OCg5Vd/RFgXZ4v5zw+qm/Nz2uwn6Q1kuSmwstqykbPetZJqbWkNUqi3izx8qz6
	 qNkfpGC/vwZIVLBxVf+l4oiIEY3RmauXi2Jdch7qWyO/4Vj1f8KmgQAcAbo+UdPYDc5Bt
	 4d5WL4d5hzp1QelbvHAYPHpJ5IjdygNMgxU29Y6IT7AenSgxh/tD93btEYHTyK0CBQpZt
	 I3o127eunaDY22mqVhyWQK9HcpeBNDZN60XkC7IFK37qtg0xZFSfpg59yX9svXeNhqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=io8LqvNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBA2606A325;
	Wed, 18 Nov 2026 22:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=io8LqvNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2381F000C4;
	Wed, 18 Nov 2026 22:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041777;
	bh=+0mnzuUwfeGWMIQWQCthmVQ4JkOpdBTCrZg+JZLqC34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=io8LqvNHllF9muA4EbeEf/z1zYdTeYhFb0kL5sqrk7LPuOnbzuFr3oVaVVbTWcvnH
	 rnKWIzV+BTXE5ChhlyCpRZYw+ZjCGF+QodYSIeQbh08OOfYb/RZAfU0KvPXfmOz7Cs
	 Mf+aXKYOuACNon6e0QsnAziRnX8XNbVvOAF7GzOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2933/3318] ASoC: Intel: avs: Switch to new stream-format interface
Date: Wed, 18 Nov 2026 15:59:15 +0100
Message-ID: <20261118150448.370543933@linuxfoundation.org>
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

[ Upstream commit 615d13cb4f3e499fb5c270a7db66917286f7d0ec ]

To provide option for selecting different bit-per-sample than just the
maximum one, use the new format calculation mechanism.

Acked-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20231117120610.1755254-14-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 85bc213f96ac ("ASoC: Intel: avs: Unprepare a stream when recovery occurs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/loader.c |  4 ++--
 sound/soc/intel/avs/path.c   |  2 +-
 sound/soc/intel/avs/pcm.c    | 19 ++++++++++++++-----
 sound/soc/intel/avs/probes.c |  3 +--
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/sound/soc/intel/avs/loader.c b/sound/soc/intel/avs/loader.c
index 5c4ae3927ed24..606caf46c8482 100644
--- a/sound/soc/intel/avs/loader.c
+++ b/sound/soc/intel/avs/loader.c
@@ -371,7 +371,7 @@ int avs_hda_load_basefw(struct avs_dev *adev, struct firmware *fw)
 	hstream = hdac_stream(estream);
 
 	/* code loading performed with default format */
-	sdfmt = snd_hdac_calc_stream_format(48000, 1, SNDRV_PCM_FORMAT_S32_LE, 32, 0);
+	sdfmt = snd_hdac_stream_format(1, 32, 48000);
 	ret = snd_hdac_dsp_prepare(hstream, sdfmt, fw->size, &dmab);
 	if (ret < 0)
 		goto release_stream;
@@ -438,7 +438,7 @@ int avs_hda_load_library(struct avs_dev *adev, struct firmware *lib, u32 id)
 	stream = hdac_stream(estream);
 
 	/* code loading performed with default format */
-	sdfmt = snd_hdac_calc_stream_format(48000, 1, SNDRV_PCM_FORMAT_S32_LE, 32, 0);
+	sdfmt = snd_hdac_stream_format(1, 32, 48000);
 	ret = snd_hdac_dsp_prepare(stream, sdfmt, lib->size, &dmab);
 	if (ret < 0)
 		goto release_stream;
diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
index a4b9e209f2230..104bd6c55a593 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -87,7 +87,7 @@ static bool avs_test_hw_params(struct snd_pcm_hw_params *params,
 	return (params_rate(params) == fmt->sampling_freq &&
 		params_channels(params) == fmt->num_channels &&
 		params_physical_width(params) == fmt->bit_depth &&
-		params_width(params) == fmt->valid_bit_depth);
+		snd_pcm_hw_params_bits(params) == fmt->valid_bit_depth);
 }
 
 static struct avs_tplg_path *
diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index c3e1d9554ee1c..b8eafc56c0383 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -335,20 +335,25 @@ static int avs_dai_hda_be_prepare(struct snd_pcm_substream *substream, struct sn
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct hdac_ext_stream *link_stream = runtime->private_data;
+	struct snd_soc_pcm_stream *stream_info;
+	struct hdac_ext_stream *link_stream;
 	struct hdac_ext_link *link;
 	struct hda_codec *codec;
 	struct hdac_bus *bus;
 	unsigned int format_val;
+	unsigned int bits;
 	int ret;
 
+	link_stream = runtime->private_data;
 	if (link_stream->link_prepared)
 		return 0;
 
 	codec = dev_to_hda_codec(snd_soc_rtd_to_codec(rtd, 0)->dev);
 	bus = &codec->bus->core;
-	format_val = snd_hdac_calc_stream_format(runtime->rate, runtime->channels, runtime->format,
-						 runtime->sample_bits, 0);
+	stream_info = snd_soc_dai_get_pcm_stream(dai, substream->stream);
+	bits = snd_hdac_stream_format_bits(runtime->format, runtime->subformat,
+					   stream_info->sig_bits);
+	format_val = snd_hdac_stream_format(runtime->channels, bits, runtime->rate);
 
 	snd_hdac_ext_stream_decouple(bus, link_stream, true);
 	snd_hdac_ext_stream_reset(link_stream);
@@ -601,11 +606,13 @@ static int avs_dai_fe_hw_free(struct snd_pcm_substream *substream, struct snd_so
 static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_soc_pcm_stream *stream_info;
 	struct avs_dma_data *data;
 	struct avs_dev *adev = to_avs_dev(dai->dev);
 	struct hdac_ext_stream *host_stream;
 	struct hdac_bus *bus;
 	unsigned int format_val;
+	unsigned int bits;
 	int ret;
 
 	data = snd_soc_dai_get_dma_data(dai, substream);
@@ -620,8 +627,10 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	snd_hdac_ext_stream_decouple(bus, data->host_stream, true);
 	snd_hdac_stream_reset(hdac_stream(host_stream));
 
-	format_val = snd_hdac_calc_stream_format(runtime->rate, runtime->channels, runtime->format,
-						 runtime->sample_bits, 0);
+	stream_info = snd_soc_dai_get_pcm_stream(dai, substream->stream);
+	bits = snd_hdac_stream_format_bits(runtime->format, runtime->subformat,
+					   stream_info->sig_bits);
+	format_val = snd_hdac_stream_format(runtime->channels, bits, runtime->rate);
 
 	ret = snd_hdac_stream_set_params(hdac_stream(host_stream), format_val);
 	if (ret < 0)
diff --git a/sound/soc/intel/avs/probes.c b/sound/soc/intel/avs/probes.c
index 341773ec49072..202e50b663ab5 100644
--- a/sound/soc/intel/avs/probes.c
+++ b/sound/soc/intel/avs/probes.c
@@ -144,8 +144,7 @@ static int avs_probe_compr_set_params(struct snd_compr_stream *cstream,
 	bps = snd_pcm_format_physical_width(format);
 	if (bps < 0)
 		return bps;
-	format_val = snd_hdac_calc_stream_format(params->codec.sample_rate, params->codec.ch_out,
-						 format, bps, 0);
+	format_val = snd_hdac_stream_format(params->codec.ch_out, bps, params->codec.sample_rate);
 	ret = snd_hdac_stream_set_params(hdac_stream(host_stream), format_val);
 	if (ret < 0)
 		return ret;
-- 
2.53.0



