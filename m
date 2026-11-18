Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041801;
	b=f3y+t7Lw4aGNlSOLNksKew1DHBzW7kh3Ok+v5MLffZVWRVWEAocP1+fHppxcsg3UGD5v
	 +r4nz1oGo+uCoRX5hXPNeBp4csKQMUz8SVf272wX0co976TeVB9g0tIyvBKD13IlVdLeX
	 hQc10tnPzWYVZFCbIFpcfjBx5Iksxey5pbMljorD6KLKMYb+bAeOozeZBION4AtZ/Wm8q
	 IGQ0zPgMq1JirF3ulvA+AS1KhXSQp1uiOCbjQfOCXsvMCk67+c/XTVto+vhgxnxuGnpE1
	 gkDF5r7HydUeB1eyRy2mI/RdMwV5mSHnSXyO9sEkdIjoWFzRd2j1t4ICNV17kXgWFVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PqndOC6p2Hlta/f+Pgx5gN2V0x1OHZsN5njXH7sVg8c=;
	b=ESwobT0j/OOKAzL6JbpWcuYbNtmTZG+kla4QzsB6uZ0val5BP5rJ+drByCIqrsYFFVQw
	 pIXsaSx3oz+grN1QLlvpj1VvTgOIRHYETsZTzSJc248GgpuEUuGtZVuHvqdhrob2QvgbU
	 1M4ewlbUHV1wWIKQCAeZAC+s6vat01mb/xH3T0Gx+1NayiQbpyOlp5GVJQRfNEm2I2oTb
	 OG2s/3mNDz7JQQ+Yprvoq79boYoGJE8d3+dBR4tJ6pUeCmL9gVAGaEoJqzBhjqEnZ99TW
	 qetcYBeXf9ULcI811/49Lj5nGwvpdp0htMArl522jEdIF7jcY7yeXpXlYK1yLDtrdbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8tdYNmD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD91606A32A;
	Wed, 18 Nov 2026 22:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8tdYNmD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C401F000C4;
	Wed, 18 Nov 2026 22:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041801;
	bh=PqndOC6p2Hlta/f+Pgx5gN2V0x1OHZsN5njXH7sVg8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8tdYNmDawc9sNk6qatliWl9/U5o5xBgCCkuuv6o21keQoT7Dutkj9G7Uc3dQ2jji
	 XJFlhodDnUaxzIyrlTfA1HhW0dxRG/sdowdBCEK1hsjWIrNl8u9rso58juQPlELwXc
	 l3xUTa8z2W3B2LP9v2AQHsS/xsJzxXqWeeTkBIPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2936/3318] ASoC: Intel: avs: Store pointer to adev in DAI dma_data
Date: Wed, 18 Nov 2026 15:59:18 +0100
Message-ID: <20261118150448.450973236@linuxfoundation.org>
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

[ Upstream commit c303a994e5d0f7d297cb6ac56052dce8f412ee67 ]

Reduce the number of to_avs_dev() casts by storing the driver context in
DAI's dma_data.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20240426095733.3946951-5-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 85bc213f96ac ("ASoC: Intel: avs: Unprepare a stream when recovery occurs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 37b3cb19eddca..4d98926de42ae 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -21,6 +21,7 @@
 struct avs_dma_data {
 	struct avs_tplg_path_template *template;
 	struct avs_path *path;
+	struct avs_dev *adev;
 	/*
 	 * link stream is stored within substream's runtime
 	 * private_data to fulfill the needs of codec BE path
@@ -59,7 +60,7 @@ static int avs_dai_startup(struct snd_pcm_substream *substream, struct snd_soc_d
 			   const struct snd_soc_dai_ops *ops)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct avs_dev *adev = to_avs_dev(dai->dev);
+	struct avs_dev *adev = to_avs_dev(dai->component->dev);
 	struct avs_tplg_path_template *template;
 	struct avs_dma_data *data;
 
@@ -76,6 +77,7 @@ static int avs_dai_startup(struct snd_pcm_substream *substream, struct snd_soc_d
 
 	data->substream = substream;
 	data->template = template;
+	data->adev = adev;
 	snd_soc_dai_set_dma_data(dai, substream, data);
 
 	if (rtd->dai_link->ignore_suspend)
@@ -87,13 +89,12 @@ static int avs_dai_startup(struct snd_pcm_substream *substream, struct snd_soc_d
 static void avs_dai_shutdown(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct avs_dev *adev = to_avs_dev(dai->dev);
 	struct avs_dma_data *data;
 
 	data = snd_soc_dai_get_dma_data(dai, substream);
 
 	if (rtd->dai_link->ignore_suspend)
-		adev->num_lp_paths--;
+		data->adev->num_lp_paths--;
 
 	snd_soc_dai_set_dma_data(dai, substream, NULL);
 	kfree(data);
@@ -106,7 +107,6 @@ static int avs_dai_hw_params(struct snd_pcm_substream *substream,
 {
 	struct avs_dma_data *data;
 	struct avs_path *path;
-	struct avs_dev *adev = to_avs_dev(dai->dev);
 	int ret;
 
 	data = snd_soc_dai_get_dma_data(dai, substream);
@@ -123,7 +123,7 @@ static int avs_dai_hw_params(struct snd_pcm_substream *substream,
 		params_rate(be_hw_params), params_channels(be_hw_params),
 		params_width(be_hw_params), params_physical_width(be_hw_params));
 
-	path = avs_path_create(adev, dma_id, data->template, fe_hw_params, be_hw_params);
+	path = avs_path_create(data->adev, dma_id, data->template, fe_hw_params, be_hw_params);
 	if (IS_ERR(path)) {
 		ret = PTR_ERR(path);
 		dev_err(dai->dev, "create path failed: %d\n", ret);
@@ -484,8 +484,7 @@ static int avs_dai_fe_startup(struct snd_pcm_substream *substream, struct snd_so
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct avs_dma_data *data;
-	struct avs_dev *adev = to_avs_dev(dai->dev);
-	struct hdac_bus *bus = &adev->base.core;
+	struct hdac_bus *bus;
 	struct hdac_ext_stream *host_stream;
 	int ret;
 
@@ -494,6 +493,7 @@ static int avs_dai_fe_startup(struct snd_pcm_substream *substream, struct snd_so
 		return ret;
 
 	data = snd_soc_dai_get_dma_data(dai, substream);
+	bus = &data->adev->base.core;
 
 	host_stream = snd_hdac_ext_stream_assign(bus, substream, HDAC_EXT_STREAM_TYPE_HOST);
 	if (!host_stream) {
@@ -626,7 +626,6 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_soc_pcm_stream *stream_info;
 	struct avs_dma_data *data;
-	struct avs_dev *adev = to_avs_dev(dai->dev);
 	struct hdac_ext_stream *host_stream;
 	struct hdac_bus *bus;
 	unsigned int format_val;
@@ -658,7 +657,7 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	if (ret < 0)
 		return ret;
 
-	ret = avs_dai_prepare(adev, substream, dai);
+	ret = avs_dai_prepare(data->adev, substream, dai);
 	if (ret)
 		return ret;
 
-- 
2.53.0



