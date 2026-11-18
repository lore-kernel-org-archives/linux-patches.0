Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041774;
	b=LnOhCu4+R42WbP4prMbHyI4GFEbSSByWRvh/IOy0odMAOZkczr5dhVAd784GAX38hPIi
	 Z/zd0eDVFDxAJV/1Jx/699dPyq/C9iZ5dshTx1VOz0YcMewTxS5KyI9RQyBGYX1gL8S+U
	 sN8n1n2a2POUXsnK5u/6UYzRAvk2U7fhBC9g5Z5xlXb6dHI2XHBlIPcfsYPjvNZi9mRGu
	 GwPpPXF4oQp38HNvMjRV4QQ+mohQBw4vk3PPOoGNkE+QlYKebPDPBsoqSFdSuvsxDaunG
	 jR99liVB96u+Cohe/f26asKElZr8rftECD479pwwAiLmFJiU66FxiIO2MWM9HAPolsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ahRibazSsS07+5oK4WhPCMAc2nnDiAxnwz4SBa7j/+Y=;
	b=tvrxQ7Fz1Cd1JFiUR6IHuX2TCWe77nw1KGm/ktqZtlyOxxFwwo8vzCAl3vsj8RekuQor
	 xFlT06v/byntuUyGg/X7b5391xNpDareWncHtTu6oSI6KX6zGzfTy9dR8x3E8cHh07HFK
	 LtczcV4btL0eIS5yvS1eM+QGt47u0OdRfgAdNU4HMkK9nQ4/h9kQ4iBH5Hez8PXJv3aSl
	 t7Y8aw9NEawbGmj/8XWd1fGBaiVcYP/Zrwik3/q/8X1uinu41GthOxXrCDtru7Z7SdrwQ
	 uYGH6Pnl7wBs3Oso1zRqRfcVeFp4nrMdkZJ2XUL3hTL1pb5yBMdFSU8e0vXe92hzR6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0P6/OTaQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF8B606A332;
	Wed, 18 Nov 2026 22:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0P6/OTaQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5C91F000C7;
	Wed, 18 Nov 2026 22:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041774;
	bh=ahRibazSsS07+5oK4WhPCMAc2nnDiAxnwz4SBa7j/+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0P6/OTaQ0t37oszA8di6Vy96xwr/2RfHe5mxtZ/LIu9bQgyS8Z7RFg6o7rRDWYMLX
	 DykAnk+vj4Yq82VthBOl5qTfefDuLgaAq6hNSUzYv/KcQId3Uj675PDj/mz576DR4Z
	 tmWXd1wbQfQabpl1OMwjsI+q7KDGETzuc/lFDTeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2932/3318] ALSA: hda: Upgrade stream-format infrastructure
Date: Wed, 18 Nov 2026 15:59:14 +0100
Message-ID: <20261118150448.343271479@linuxfoundation.org>
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

[ Upstream commit d24f1a090d3f2a5c86a8782afeda71c2d2539966 ]

Introduce a set of functions that ultimately facilite SDxFMT-related
calculations in atomic manner:

First, introduce snd_pcm_subformat_width() and snd_pcm_hw_params_bits()
helpers that separate the base functionality from the HDAudio-specific
one.

snd_hdac_format_normalize() - format converter. S20_LE, S24_LE and their
unsigned and BE friends are invalid from HDAudio perspective but still
can be specified as function argument due to compatibility reasons.

snd_hdac_stream_format_bits() - obtain just the bits-per-sample value.
Does not ignore subformat and msbits parameters.

snd_hdac_stream_format() and snd_hdac_spdif_stream_format() - obtain the
SDxFMT value given the audio format parameters. The former is stripped
away of spdif-related information. Useful for users that do not care
about them.

Acked-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20231117120610.1755254-5-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 85bc213f96ac ("ASoC: Intel: avs: Unprepare a stream when recovery occurs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio.h    |   5 ++
 include/sound/pcm_params.h |   2 +
 sound/core/pcm_lib.c       |  34 ++++++++++
 sound/hda/hdac_device.c    | 124 +++++++++++++++++++++++++++++++++++++
 4 files changed, 165 insertions(+)

diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index 32c59053b48ed..ed52ca898c3bb 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -140,6 +140,11 @@ int snd_hdac_get_connections(struct hdac_device *codec, hda_nid_t nid,
 			     hda_nid_t *conn_list, int max_conns);
 int snd_hdac_get_sub_nodes(struct hdac_device *codec, hda_nid_t nid,
 			   hda_nid_t *start_id);
+unsigned int snd_hdac_stream_format_bits(snd_pcm_format_t format, snd_pcm_subformat_t subformat,
+					 unsigned int maxbits);
+unsigned int snd_hdac_stream_format(unsigned int channels, unsigned int bits, unsigned int rate);
+unsigned int snd_hdac_spdif_stream_format(unsigned int channels, unsigned int bits,
+					  unsigned int rate, unsigned short spdif_ctls);
 unsigned int snd_hdac_calc_stream_format(unsigned int rate,
 					 unsigned int channels,
 					 snd_pcm_format_t format,
diff --git a/include/sound/pcm_params.h b/include/sound/pcm_params.h
index ba184f49f7e18..fbf35df6e5cf5 100644
--- a/include/sound/pcm_params.h
+++ b/include/sound/pcm_params.h
@@ -362,6 +362,8 @@ static inline int params_physical_width(const struct snd_pcm_hw_params *p)
 	return snd_pcm_format_physical_width(params_format(p));
 }
 
+int snd_pcm_hw_params_bits(const struct snd_pcm_hw_params *p);
+
 static inline void
 params_set_format(struct snd_pcm_hw_params *p, snd_pcm_format_t fmt)
 {
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 5d455bedb7c9d..459c1be526391 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1706,6 +1706,40 @@ int snd_pcm_hw_param_last(struct snd_pcm_substream *pcm,
 }
 EXPORT_SYMBOL(snd_pcm_hw_param_last);
 
+/**
+ * snd_pcm_hw_params_bits - Get the number of bits per the sample.
+ * @p: hardware parameters
+ *
+ * Return: The number of bits per sample based on the format,
+ * subformat and msbits the specified hw params has.
+ */
+int snd_pcm_hw_params_bits(const struct snd_pcm_hw_params *p)
+{
+	snd_pcm_subformat_t subformat = params_subformat(p);
+	snd_pcm_format_t format = params_format(p);
+
+	switch (format) {
+	case SNDRV_PCM_FORMAT_S32_LE:
+	case SNDRV_PCM_FORMAT_U32_LE:
+	case SNDRV_PCM_FORMAT_S32_BE:
+	case SNDRV_PCM_FORMAT_U32_BE:
+		switch (subformat) {
+		case SNDRV_PCM_SUBFORMAT_MSBITS_20:
+			return 20;
+		case SNDRV_PCM_SUBFORMAT_MSBITS_24:
+			return 24;
+		case SNDRV_PCM_SUBFORMAT_MSBITS_MAX:
+		case SNDRV_PCM_SUBFORMAT_STD:
+		default:
+			break;
+		}
+		fallthrough;
+	default:
+		return snd_pcm_format_width(format);
+	}
+}
+EXPORT_SYMBOL(snd_pcm_hw_params_bits);
+
 static int snd_pcm_lib_ioctl_reset(struct snd_pcm_substream *substream,
 				   void *arg)
 {
diff --git a/sound/hda/hdac_device.c b/sound/hda/hdac_device.c
index 51984633ea64d..1410f3e6ca3b5 100644
--- a/sound/hda/hdac_device.c
+++ b/sound/hda/hdac_device.c
@@ -13,6 +13,7 @@
 #include <sound/hdaudio.h>
 #include <sound/hda_regmap.h>
 #include <sound/pcm.h>
+#include <sound/pcm_params.h>
 #include "local.h"
 
 static void setup_fg_nodes(struct hdac_device *codec);
@@ -723,6 +724,129 @@ static const struct hda_rate_tbl rate_bits[] = {
 	{ 0 } /* terminator */
 };
 
+static snd_pcm_format_t snd_hdac_format_normalize(snd_pcm_format_t format)
+{
+	switch (format) {
+	case SNDRV_PCM_FORMAT_S20_LE:
+	case SNDRV_PCM_FORMAT_S24_LE:
+		return SNDRV_PCM_FORMAT_S32_LE;
+
+	case SNDRV_PCM_FORMAT_U20_LE:
+	case SNDRV_PCM_FORMAT_U24_LE:
+		return SNDRV_PCM_FORMAT_U32_LE;
+
+	case SNDRV_PCM_FORMAT_S20_BE:
+	case SNDRV_PCM_FORMAT_S24_BE:
+		return SNDRV_PCM_FORMAT_S32_BE;
+
+	case SNDRV_PCM_FORMAT_U20_BE:
+	case SNDRV_PCM_FORMAT_U24_BE:
+		return SNDRV_PCM_FORMAT_U32_BE;
+
+	default:
+		return format;
+	}
+}
+
+/**
+ * snd_hdac_stream_format_bits - obtain bits per sample value.
+ * @format:	the PCM format.
+ * @subformat:	the PCM subformat.
+ * @maxbits:	the maximum bits per sample.
+ *
+ * Return: The number of bits per sample.
+ */
+unsigned int snd_hdac_stream_format_bits(snd_pcm_format_t format, snd_pcm_subformat_t subformat,
+					 unsigned int maxbits)
+{
+	struct snd_pcm_hw_params params;
+	unsigned int bits;
+
+	memset(&params, 0, sizeof(params));
+
+	params_set_format(&params, snd_hdac_format_normalize(format));
+	snd_mask_set(hw_param_mask(&params, SNDRV_PCM_HW_PARAM_SUBFORMAT),
+		     (__force unsigned int)subformat);
+
+	bits = snd_pcm_hw_params_bits(&params);
+	if (maxbits)
+		return min(bits, maxbits);
+	return bits;
+}
+EXPORT_SYMBOL_GPL(snd_hdac_stream_format_bits);
+
+/**
+ * snd_hdac_stream_format - convert format parameters to SDxFMT value.
+ * @channels:	the number of channels.
+ * @bits:	bits per sample.
+ * @rate:	the sample rate.
+ *
+ * Return: The format bitset or zero if invalid.
+ */
+unsigned int snd_hdac_stream_format(unsigned int channels, unsigned int bits, unsigned int rate)
+{
+	unsigned int val = 0;
+	int i;
+
+	for (i = 0; rate_bits[i].hz; i++) {
+		if (rate_bits[i].hz == rate) {
+			val = rate_bits[i].hda_fmt;
+			break;
+		}
+	}
+
+	if (!rate_bits[i].hz)
+		return 0;
+
+	if (channels == 0 || channels > 8)
+		return 0;
+	val |= channels - 1;
+
+	switch (bits) {
+	case 8:
+		val |= AC_FMT_BITS_8;
+		break;
+	case 16:
+		val |= AC_FMT_BITS_16;
+		break;
+	case 20:
+		val |= AC_FMT_BITS_20;
+		break;
+	case 24:
+		val |= AC_FMT_BITS_24;
+		break;
+	case 32:
+		val |= AC_FMT_BITS_32;
+		break;
+	default:
+		return 0;
+	}
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(snd_hdac_stream_format);
+
+/**
+ * snd_hdac_spdif_stream_format - convert format parameters to SDxFMT value.
+ * @channels:	the number of channels.
+ * @bits:	bits per sample.
+ * @rate:	the sample rate.
+ * @spdif_ctls:	HD-audio SPDIF status bits (0 if irrelevant).
+ *
+ * Return: The format bitset or zero if invalid.
+ */
+unsigned int snd_hdac_spdif_stream_format(unsigned int channels, unsigned int bits,
+					  unsigned int rate, unsigned short spdif_ctls)
+{
+	unsigned int val = snd_hdac_stream_format(channels, bits, rate);
+
+	if (val && spdif_ctls & AC_DIG1_NONAUDIO)
+		val |= AC_FMT_TYPE_NON_PCM;
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(snd_hdac_spdif_stream_format);
+
 /**
  * snd_hdac_calc_stream_format - calculate the format bitset
  * @rate: the sample rate
-- 
2.53.0



