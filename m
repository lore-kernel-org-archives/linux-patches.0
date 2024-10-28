Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5AE18D649;
	Mon, 28 Oct 2024 06:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098478; cv=none; b=l05N1RVdAtNgCuaoef+GMYBaaGU4cYiAMZs2DWNOKHAuu8sPfrg6oG4Aelx0XgpZeHHIBpaQiMSDpIajvIcfAETk04CHj8992Sfq9q8Xiq09eshFXL1qP0CLH45IPABD7DkQMoqgZ6zWJiM5off8TIL8iIRsby/RhJZZyY8R65U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098478; c=relaxed/simple;
	bh=AOfmFMT0pIIe72NjYAvICkumgqTfie2WOmY5GCJU7II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Goa3fAfcttSxFoe14MuT0hF7D0L5WsaTG5Pr7lf1MuietFxZFI9nKVo1Sk40BsHLaJFfwXDdNKCaPkjsnfZM+xi+mv1JTnevBfbghdDIAEP8WyY+A/BGaO4RxGte2dYF+KB5ZV5rwcIcnbn3GC1dSutJx5Pn6jkgEhHxOqwQzO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXeR9/j/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXeR9/j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC80C4CEC3;
	Mon, 28 Oct 2024 06:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098477;
	bh=AOfmFMT0pIIe72NjYAvICkumgqTfie2WOmY5GCJU7II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXeR9/j/WYw5EDNq52YCny0pjvGj9YxohS/YV1uMQs2gFB98sHfq7zRBEJxBCTSLP
	 hTnlHPzFoZgTzrMVYpP3XDEN5wPNfiMhVH3O7Y8+xkLll/7U7hKCfKuoydHfR+aVy1
	 sLPR1k1N/W9KrTsRwRsEPOIntr9zqQy7Icg5PjJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 243/261] ASoC: SOF: Intel: hda-loader: do not wait for HDaudio IOC
Date: Mon, 28 Oct 2024 07:26:25 +0100
Message-ID: <20241028062318.200990943@linuxfoundation.org>
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

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit 9814c1447f9cc67c9e88e0a4423de3a496078360 upstream.

Commit 9ee3f0d8c999 ("ASOC: SOF: Intel: hda-loader: only wait for
HDaudio IOC for IPC4 devices") removed DMA wait for IPC3 case.
Proceed and remove the wait for IPC4 devices as well.

There is no dependency to IPC version in the load logic and
checking the firmware status is a sufficient check in case of
errors.

The removed code also had a bug in that -ETIMEDOUT is returned
without stopping the DMA transfer.

Cc: stable@vger.kernel.org
Link: https://github.com/thesofproject/linux/issues/5135
Fixes: 9ee3f0d8c999 ("ASOC: SOF: Intel: hda-loader: only wait for HDaudio IOC for IPC4 devices")
Suggested-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20241008060710.15409-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-loader.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -294,14 +294,9 @@ int hda_cl_copy_fw(struct snd_sof_dev *s
 {
 	struct sof_intel_hda_dev *hda = sdev->pdata->hw_pdata;
 	const struct sof_intel_dsp_desc *chip = hda->desc;
-	struct sof_intel_hda_stream *hda_stream;
-	unsigned long time_left;
 	unsigned int reg;
 	int ret, status;
 
-	hda_stream = container_of(hext_stream, struct sof_intel_hda_stream,
-				  hext_stream);
-
 	dev_dbg(sdev->dev, "Code loader DMA starting\n");
 
 	ret = hda_cl_trigger(sdev->dev, hext_stream, SNDRV_PCM_TRIGGER_START);
@@ -310,18 +305,6 @@ int hda_cl_copy_fw(struct snd_sof_dev *s
 		return ret;
 	}
 
-	if (sdev->pdata->ipc_type == SOF_IPC_TYPE_4) {
-		/* Wait for completion of transfer */
-		time_left = wait_for_completion_timeout(&hda_stream->ioc,
-							msecs_to_jiffies(HDA_CL_DMA_IOC_TIMEOUT_MS));
-
-		if (!time_left) {
-			dev_err(sdev->dev, "Code loader DMA did not complete\n");
-			return -ETIMEDOUT;
-		}
-		dev_dbg(sdev->dev, "Code loader DMA done\n");
-	}
-
 	dev_dbg(sdev->dev, "waiting for FW_ENTERED status\n");
 
 	status = snd_sof_dsp_read_poll_timeout(sdev, HDA_DSP_BAR,


