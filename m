Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041780;
	b=dcNk6hOrorEtEkTq8ZdpfK/ZzvZRCW6EopnKIOmckthulBX3MoIN8X9qTtW+2gi+/Djn
	 8t3dXbf5MlCSw7T22Owpi5fJkCQJrVQWbJFLtVHSioE89afXEoh4llnaBT1QVQQPO5BWj
	 hoHTGSrUBCT+lOqPaz9xICp9yK7CqL0gOotNwhmoi6nrybCKNvcoascGI2N7wMncpCg2/
	 AJucqWZ8RUYfAaAd44k8mnp4b8IPJhF+BZ1H3vg7Lg/iP7FyItn+dsEjj0gIoqepYUIb2
	 U2YcWA4pRijNW1pYZxYNlhXpP9gyMgdfdbFGo+6+wDEyA3F4E1O0T4d8P46q+cOeSvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pVyyRfq7MMYBKX3DCIy+gfNbZJdr9s/bme9mUjJ5RT8=;
	b=btPTAzTp/5ySufMteXJCzHtZs2+rAVBljTuyzzeDrlM3fpesW1jGflxsLkGftJSNYvhJ
	 7aIwePkONn/Ua18PuPtCOLsP+JA371N2F0RkGpzkjfYSq4aBRYCg++isxrVeHF3Ym/3Ew
	 azxlZpfDd1dMkjtETjezaxkWp4EOCoAUCh9WDP1fiaUZ5QWem6vGpdbrDclKeAUPtdpPY
	 B64D9xep6pe7ITGRotLb1zvI8KXIMTyQ/Amk+15C9csrh803lre77uR1m1dCToPv/5MiA
	 416eCiW/OMs/4v3qp++/F8hHo3f6eJ/PB37NF+DqZmZbge8Dzth12SGOID3D9R3xQuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZ+6cLEm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E223606A32A;
	Wed, 18 Nov 2026 22:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZ+6cLEm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53801F000C4;
	Wed, 18 Nov 2026 22:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041780;
	bh=pVyyRfq7MMYBKX3DCIy+gfNbZJdr9s/bme9mUjJ5RT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZ+6cLEmQkwlo5NG9yOmLWutnjaHHm4pyNyMs6yNdBx9QFroEBKLdn6e7qkbbxwLF
	 EKn3RKiWQTf37N2v3LXmh/aL6ddJI77R/+hQgUpZR6E9dRHSXQU7TsPEC9R5cCw8Rm
	 dnSZ0XGf7aaXp/OC9MCdsYXBPmChD+HRF04txVZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2934/3318] ASoC: Intel: avs: Relocate HDA BE DAI specific operations
Date: Wed, 18 Nov 2026 15:59:16 +0100
Message-ID: <20261118150448.397614808@linuxfoundation.org>
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

[ Upstream commit 140df6d4d5f541e950a35cad2e3dffb49186ed74 ]

DAI's startup()/shutdown() shall deal with allocation and freeing of
resources needed to facilitate streaming over it. Currently for HDAudio
BE DAIs some of that task is done in component->open()/close(). Relocate
the relevant pieces to address that.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20240426095733.3946951-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 85bc213f96ac ("ASoC: Intel: avs: Unprepare a stream when recovery occurs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 55 ++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index b8eafc56c0383..1270042a73429 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -276,12 +276,36 @@ static const struct snd_soc_dai_ops avs_dai_hda_be_ops;
 
 static int avs_dai_hda_be_startup(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
-	return avs_dai_startup(substream, dai, false, &avs_dai_hda_be_ops);
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct hdac_ext_stream *link_stream;
+	struct hda_codec *codec;
+	int ret;
+
+	ret = avs_dai_startup(substream, dai, false, &avs_dai_hda_be_ops);
+	if (ret)
+		return ret;
+
+	codec = dev_to_hda_codec(snd_soc_rtd_to_codec(rtd, 0)->dev);
+	link_stream = snd_hdac_ext_stream_assign(&codec->bus->core, substream,
+						 HDAC_EXT_STREAM_TYPE_LINK);
+	if (!link_stream) {
+		avs_dai_nonhda_be_shutdown(substream, dai);
+		return -EBUSY;
+	}
+
+	substream->runtime->private_data = link_stream;
+	return 0;
 }
 
 static void avs_dai_hda_be_shutdown(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
-	return avs_dai_nonhda_be_shutdown(substream, dai);
+	struct hdac_ext_stream *link_stream;
+
+	link_stream = substream->runtime->private_data;
+	snd_hdac_ext_stream_release(link_stream, HDAC_EXT_STREAM_TYPE_LINK);
+	substream->runtime->private_data = NULL;
+
+	avs_dai_nonhda_be_shutdown(substream, dai);
 }
 
 static int avs_dai_hda_be_hw_params(struct snd_pcm_substream *substream,
@@ -1446,8 +1470,6 @@ static int avs_component_hda_open(struct snd_soc_component *component,
 				  struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct hdac_ext_stream *link_stream;
-	struct hda_codec *codec;
 
 	if (!rtd->dai_link->no_pcm) {
 		struct snd_pcm_hardware hwparams = avs_pcm_hardware;
@@ -1479,30 +1501,6 @@ static int avs_component_hda_open(struct snd_soc_component *component,
 		return snd_soc_set_runtime_hwparams(substream, &hwparams);
 	}
 
-	codec = dev_to_hda_codec(snd_soc_rtd_to_codec(rtd, 0)->dev);
-	link_stream = snd_hdac_ext_stream_assign(&codec->bus->core, substream,
-					     HDAC_EXT_STREAM_TYPE_LINK);
-	if (!link_stream)
-		return -EBUSY;
-
-	substream->runtime->private_data = link_stream;
-	return 0;
-}
-
-static int avs_component_hda_close(struct snd_soc_component *component,
-				   struct snd_pcm_substream *substream)
-{
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct hdac_ext_stream *link_stream;
-
-	/* only BE DAI links are handled here */
-	if (!rtd->dai_link->no_pcm)
-		return 0;
-
-	link_stream = substream->runtime->private_data;
-	snd_hdac_ext_stream_release(link_stream, HDAC_EXT_STREAM_TYPE_LINK);
-	substream->runtime->private_data = NULL;
-
 	return 0;
 }
 
@@ -1513,7 +1511,6 @@ static const struct snd_soc_component_driver avs_hda_component_driver = {
 	.suspend		= avs_component_suspend,
 	.resume			= avs_component_resume,
 	.open			= avs_component_hda_open,
-	.close			= avs_component_hda_close,
 	.pointer		= avs_component_pointer,
 	.mmap			= avs_component_mmap,
 	.pcm_construct		= avs_component_construct,
-- 
2.53.0



