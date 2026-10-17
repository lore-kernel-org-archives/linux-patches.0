Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42862DF126;
	Sat, 17 Oct 2026 17:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257561; cv=none; b=UymVGxNaX4J5ARmPmgzY9FwsLWKxp1AzpgXubPdzNAAamVZN5cYLT79WZbepw8jZoQskZ5/9pDyxwrNy585s5KD4rQo2XepdbYmnjMwVaHjNo2O+yO550mmx3NjjMUIshGLxM9skLKoFipaHbzfiq5MPtKnkGh8KumauxK0cZH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257561; c=relaxed/simple;
	bh=OY2euPAQs5pToZOwKJAXrLY8D1tiRCsiBnTOlbmR3Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u/1qiEX1KnV6BSUUyNHpK8uXjrhqpZmjpkD3TFvNhdTygE9fNpmyU4UAqmzsWlKJsyWYjGT97ueN5T8ga67X6hMDavPLbOT0IvPbuS+od2JxOMJfVAw+j2xHthc9a7M8By5MLSe+a44sKbuhyDU3Hp7IWt2IAspj3UHW+pZe5aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQ6l8nXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQ6l8nXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453B21F000C4;
	Sat, 17 Oct 2026 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257559;
	bh=vnGzl5fYMbfIbDhMe6NrS1/J4WNrCTvKf/hFaj/6FLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQ6l8nXcNLqiXM8uQhqyxBB6Zz6UDmXVAzKjIKWEeppXoP1uB0g7rfZbh2KinWlSM
	 lJynnP35kGjxgat7rhA/61eQDHNfHOl1G6gNxaVlGlWsmmcIddDhR3VD3pk2IQRjEK
	 RMrPUkoOnX6odKDG5rUlC1rvbuMZiCS4S61cSaVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0597/1674] ASoC: SOF: Intel: hda-dai: Ensure DAI widget is valid during params
Date: Sat, 17 Oct 2026 17:47:49 +0200
Message-ID: <20261017160446.405813982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 569922b82ca660f8b24e705f6cf674e6b1f99cc7 ]

Each cpu DAI should associate with a widget. However, the topology might
not create the right number of DAI widgets for aggregated amps. And it
will cause NULL pointer deference.
Check that the DAI widget associated with the CPU DAI is valid to prevent
NULL pointer deference due to missing DAI widgets in topologies with
aggregated amps.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20241203104853.56956-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Assisted-by: LLM
[ Backport to 6.6.y: Keep the NULL-widget checks in
  sdw_hda_dai_hw_params() and sdw_params_stream(). Omit the extra check
  in the newer IPC4 CPU-DAI aggregation loop, which this target lacks. ]
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 6 ++++++
 sound/soc/sof/intel/hda.c     | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index a3d0b6d721aaf..f541cd0fe78a4 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -454,6 +454,12 @@ int sdw_hda_dai_hw_params(struct snd_pcm_substream *substream,
 	struct snd_sof_dev *sdev;
 	int ret;
 
+	if (!w) {
+		dev_err(cpu_dai->dev, "%s widget not found, check amp link num in the topology\n",
+			cpu_dai->name);
+		return -EINVAL;
+	}
+
 	ret = non_hda_dai_hw_params(substream, params, cpu_dai);
 	if (ret < 0) {
 		dev_err(cpu_dai->dev, "%s: non_hda_dai_hw_params failed %d\n", __func__, ret);
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 15e6779efaa3b..aa3f9c9611737 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -102,6 +102,11 @@ static int sdw_params_stream(struct device *dev,
 	struct snd_soc_dapm_widget *w = snd_soc_dai_get_widget(d, params_data->substream->stream);
 	struct snd_sof_dai_config_data data = { 0 };
 
+	if (!w) {
+		dev_err(dev, "%s widget not found, check amp link num in the topology\n",
+			d->name);
+		return -EINVAL;
+	}
 	data.dai_index = (params_data->link_id << 8) | d->id;
 	data.dai_data = params_data->alh_stream_id;
 
-- 
2.53.0



