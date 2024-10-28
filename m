Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869792AF07;
	Mon, 28 Oct 2024 06:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098520; cv=none; b=pruHB5iFUF2nLCwykptUSYdT2hOFFPM9xdzzayHtZJ880gemoXvr2rWVyM4nd+5ltfUKHXa+lYE4v/mFcqYwYueJie/Xr93C39QDbohiDlHKTM5a+6tfo9EFuciUoil/F8GAfozTDqJEWHX0QWPsaU7MZ9xQUGo254OcAnRpyz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098520; c=relaxed/simple;
	bh=Z6DQgowkIBRwI6XkNU7XIgjN3334pqVNQVWpUE7+8no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JCkI5UgbkSchVS0dmt4Op86uEl98EzDlUjrMK/eWibYibGvv/UBf+EdoM4NcIqbNotpFNSQmmcicpLZlO2Z/RHmFqnkBMJkRj4nvt+kCYt+jibBMSKdTNysLF5JrWdA7L1bCllpUvCw9N+vEuM4ViKfWFo7qRXRJRJdpSy7aReQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXZ9an4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXZ9an4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E28C4CEC3;
	Mon, 28 Oct 2024 06:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098520;
	bh=Z6DQgowkIBRwI6XkNU7XIgjN3334pqVNQVWpUE7+8no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXZ9an4LdhJNt64WiR7+1GbiSyw1wLOAOGnZ4V3nzODLT94RYAt8ct5oeVQNusvjM
	 e0VshtQrDTQfHSu1lE0nz+3yABtVDN9uIvQL5tiyYVCiXwLXj0bdSf8hJrIITBz9U/
	 Wnnq2lnYy1yEf9ga+tvE2uL2/uPfiJ/TG5ud+eUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 255/261] soundwire: intel_ace2x: Send PDI stream number during prepare
Date: Mon, 28 Oct 2024 07:26:37 +0100
Message-ID: <20241028062318.490249732@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

commit c78f1e15e46ac82607eed593b22992fd08644d96 upstream.

In the case of a prepare callback after an xrun or when the PCM is
restarted after a call to snd_pcm_drain/snd_pcm_drop, avoid
reprogramming the SHIM registers but send the PDI stream number so that
the link DMA data can be set. This is needed for the case that the DMA
data is cleared when the PCM is stopped and restarted without being
closed.

Link: https://github.com/thesofproject/sof/issues/9502
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
All: stable@vger.kernel.org # 6.10.x 6.11.x
Link: https://patch.msgid.link/20241016032910.14601-4-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/intel_ace2x.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/soundwire/intel_ace2x.c b/drivers/soundwire/intel_ace2x.c
index fff312c6968d..4f3dd70d6a1a 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -376,11 +376,12 @@ static int intel_hw_params(struct snd_pcm_substream *substream,
 static int intel_prepare(struct snd_pcm_substream *substream,
 			 struct snd_soc_dai *dai)
 {
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct sdw_cdns *cdns = snd_soc_dai_get_drvdata(dai);
 	struct sdw_intel *sdw = cdns_to_intel(cdns);
 	struct sdw_cdns_dai_runtime *dai_runtime;
+	struct snd_pcm_hw_params *hw_params;
 	int ch, dir;
-	int ret = 0;
 
 	dai_runtime = cdns->dai_runtime_array[dai->id];
 	if (!dai_runtime) {
@@ -389,12 +390,8 @@ static int intel_prepare(struct snd_pcm_substream *substream,
 		return -EIO;
 	}
 
+	hw_params = &rtd->dpcm[substream->stream].hw_params;
 	if (dai_runtime->suspended) {
-		struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-		struct snd_pcm_hw_params *hw_params;
-
-		hw_params = &rtd->dpcm[substream->stream].hw_params;
-
 		dai_runtime->suspended = false;
 
 		/*
@@ -415,15 +412,11 @@ static int intel_prepare(struct snd_pcm_substream *substream,
 		/* the SHIM will be configured in the callback functions */
 
 		sdw_cdns_config_stream(cdns, ch, dir, dai_runtime->pdi);
-
-		/* Inform DSP about PDI stream number */
-		ret = intel_params_stream(sdw, substream, dai,
-					  hw_params,
-					  sdw->instance,
-					  dai_runtime->pdi->intel_alh_id);
 	}
 
-	return ret;
+	/* Inform DSP about PDI stream number */
+	return intel_params_stream(sdw, substream, dai, hw_params, sdw->instance,
+				   dai_runtime->pdi->intel_alh_id);
 }
 
 static int
-- 
2.47.0



