Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041921;
	b=W8OubaxaaEyDUfH58d6DvtrX33bkzakzuWFE4iYJc7MaK5/rHvHqJuZqo5GnyGCZh/t6
	 Vp8xsE2nOm5GuPm2RQrLEbQ1pafWk6BhCZBYVB+np5AEF0ESbr/5zZqQxdI0Ji1hjVnMZ
	 kPeijNLUjLuUa9tsKfrDkkQBvh8e03uX/Gw7Z4a4ymlojlpfl/PXwitqCA0CrTMzLBNVa
	 2ayokbkNGt3uYewuZLYVKABTMW0bHe3PRN3IXiygO6qE7lhKbmDQpJUM2OutsB3e5zmvW
	 Sg7KH2U/45bfBLWvNy2aoXvBGaZkBfzimy6Wm8dt8hO7q6PUPLWpZ5oyaWh05mhFc5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q5yIXB/GA1d2q4NYYPAPWinuaqDLIRWim6nPDhkW9Ks=;
	b=s6paCPllcXsXeR3i/XydfBWKqn1IzT/nkRZeg3qeLeIyMHIee/MzqQXomqWkbi8siFtf
	 enen4ei70U7/A1zfdZ9ksa0gjHg8nktOTzwsZMNAGG92UepQN9WxYDhbLBP7K0DUu6OC7
	 7CF2C58ix+4NXXttraCWUrpk1giaq9iT/gGvtBzC+mN3ZVQINUjEw+gXzaL4jf7eIDIa+
	 1VaDgRYW5y/INZbm/HAfn+hIIuCU7ztsdt/KRoEw5GZMwzeJVPbq2Rzzizh0QdXMaW5gS
	 yT7o2cwktttzyrGJMWFZ6LWk7ysK6NQact/0tl7pOBoGWDb4+Ma3uY071eecXmv3GEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLrNFRML;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD17C606A32F;
	Wed, 18 Nov 2026 22:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLrNFRML
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343FB1F000C4;
	Wed, 18 Nov 2026 22:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041921;
	bh=Q5yIXB/GA1d2q4NYYPAPWinuaqDLIRWim6nPDhkW9Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLrNFRML2Z1fQVi29ZhEzJDD/+SlpFGmf3qaBv0JYhFRPMg/iN9P15m3boIvv02qk
	 9QUzA5j113lNbqKm56BZcQpIeXrYq9esLvEDJL8umCrIVGn1nJ/Dmv80hcsHs2dSFC
	 cE1VjgwuO4aOaqfRqNDQPpQPfX+xf/zozYpAcYcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2935/3318] ASoC: Intel: avs: Remove redundancy around DAI shutdown
Date: Wed, 18 Nov 2026 15:59:17 +0100
Message-ID: <20261118150448.424230728@linuxfoundation.org>
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

[ Upstream commit b9d59f970ea7772957f6da02ca1ba272ef4495b8 ]

Move avs_dai_nonhda_be_shutdown() to avs_dai_shutdown() as the function
is common for all transfer types, not just non-HDAudio ones. Use it
to simplify avs_dai_fe_shutdown().

While at it, fix explicit kfree(data) and use the destructor instead.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20240426095733.3946951-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 85bc213f96ac ("ASoC: Intel: avs: Unprepare a stream when recovery occurs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 44 +++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 1270042a73429..37b3cb19eddca 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -84,6 +84,21 @@ static int avs_dai_startup(struct snd_pcm_substream *substream, struct snd_soc_d
 	return 0;
 }
 
+static void avs_dai_shutdown(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
+	struct avs_dev *adev = to_avs_dev(dai->dev);
+	struct avs_dma_data *data;
+
+	data = snd_soc_dai_get_dma_data(dai, substream);
+
+	if (rtd->dai_link->ignore_suspend)
+		adev->num_lp_paths--;
+
+	snd_soc_dai_set_dma_data(dai, substream, NULL);
+	kfree(data);
+}
+
 static int avs_dai_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *fe_hw_params,
 			     struct snd_pcm_hw_params *be_hw_params, struct snd_soc_dai *dai,
@@ -165,21 +180,6 @@ static int avs_dai_nonhda_be_startup(struct snd_pcm_substream *substream, struct
 	return avs_dai_startup(substream, dai, false, &avs_dai_nonhda_be_ops);
 }
 
-static void avs_dai_nonhda_be_shutdown(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
-{
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct avs_dev *adev = to_avs_dev(dai->dev);
-	struct avs_dma_data *data;
-
-	if (rtd->dai_link->ignore_suspend)
-		adev->num_lp_paths--;
-
-	data = snd_soc_dai_get_dma_data(dai, substream);
-
-	snd_soc_dai_set_dma_data(dai, substream, NULL);
-	kfree(data);
-}
-
 static int avs_dai_nonhda_be_hw_params(struct snd_pcm_substream *substream,
 				       struct snd_pcm_hw_params *hw_params, struct snd_soc_dai *dai)
 {
@@ -265,7 +265,7 @@ static int avs_dai_nonhda_be_trigger(struct snd_pcm_substream *substream, int cm
 
 static const struct snd_soc_dai_ops avs_dai_nonhda_be_ops = {
 	.startup = avs_dai_nonhda_be_startup,
-	.shutdown = avs_dai_nonhda_be_shutdown,
+	.shutdown = avs_dai_shutdown,
 	.hw_params = avs_dai_nonhda_be_hw_params,
 	.hw_free = avs_dai_nonhda_be_hw_free,
 	.prepare = avs_dai_nonhda_be_prepare,
@@ -289,7 +289,7 @@ static int avs_dai_hda_be_startup(struct snd_pcm_substream *substream, struct sn
 	link_stream = snd_hdac_ext_stream_assign(&codec->bus->core, substream,
 						 HDAC_EXT_STREAM_TYPE_LINK);
 	if (!link_stream) {
-		avs_dai_nonhda_be_shutdown(substream, dai);
+		avs_dai_shutdown(substream, dai);
 		return -EBUSY;
 	}
 
@@ -305,7 +305,7 @@ static void avs_dai_hda_be_shutdown(struct snd_pcm_substream *substream, struct
 	snd_hdac_ext_stream_release(link_stream, HDAC_EXT_STREAM_TYPE_LINK);
 	substream->runtime->private_data = NULL;
 
-	avs_dai_nonhda_be_shutdown(substream, dai);
+	avs_dai_shutdown(substream, dai);
 }
 
 static int avs_dai_hda_be_hw_params(struct snd_pcm_substream *substream,
@@ -529,18 +529,12 @@ static int avs_dai_fe_startup(struct snd_pcm_substream *substream, struct snd_so
 
 static void avs_dai_fe_shutdown(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct avs_dev *adev = to_avs_dev(dai->dev);
 	struct avs_dma_data *data;
 
-	if (rtd->dai_link->ignore_suspend)
-		adev->num_lp_paths--;
-
 	data = snd_soc_dai_get_dma_data(dai, substream);
 
-	snd_soc_dai_set_dma_data(dai, substream, NULL);
 	snd_hdac_ext_stream_release(data->host_stream, HDAC_EXT_STREAM_TYPE_HOST);
-	kfree(data);
+	avs_dai_shutdown(substream, dai);
 }
 
 static int avs_dai_fe_hw_params(struct snd_pcm_substream *substream,
-- 
2.53.0



