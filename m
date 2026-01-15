Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533353D6041;
	Thu, 15 Jan 2026 17:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499654; cv=none; b=DNCiWrTWpBdUHGXbPIY4Rzmb/sJP0bX5k14YKWKtHAeAqU8EDd39Us6ntdQs4axAnKtNKOhdNNcJqHn9LOEJtRCOstWrjL8T2pF6QesXAccldkqsnLfeORj/0N4MW6p9axwSZ07Pp+rBCxTC4PtOo4heY2oYZi8W92lEzO0GscM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499654; c=relaxed/simple;
	bh=gY/hZUBgD6uuhxddunQKc5eNsleT+vOBnQsRM63l5Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4SlmdIeULr8zzOb2KvQzIO39+qiiIFKmGiD3YUuvzB2jGBwVuyahckj6tFfQ2vXBwXLb3v+Iqb1NfAanYff7FO3f8LCr2UpZoj5WT+2yosiFVdbzm67dysym4OIp3z8D9kcdSt+7fNJLIrV/EWBry6yoKfEo59BdHSQrevLchs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LutQsvXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LutQsvXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB03AC116D0;
	Thu, 15 Jan 2026 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499653;
	bh=gY/hZUBgD6uuhxddunQKc5eNsleT+vOBnQsRM63l5Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LutQsvXdzynw3Jdg0x/7+QxIKbsvFRtgUL9fS5KnKIRFlefvCUutNhnG22G2MZR9b
	 nIQ7LNd484qcdPjRkhwSJjDWpZ4oC6LZuo1Q3H+LVp2wMalRet/WAwhWpVugXfqdpW
	 NMCWOvBRNSlbushOGIF7Aa5KndZUcMq0DsX6cR5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 5.10 301/451] ASoC: qcom: qdsp6: q6asm-dai: set 10 ms period and buffer alignment.
Date: Thu, 15 Jan 2026 17:48:22 +0100
Message-ID: <20260115164241.781220967@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 81c53b52de21b8d5a3de55ebd06b6bf188bf7efd upstream.

DSP expects the periods to be aligned to fragment sizes, currently
setting up to hw constriants on periods bytes is not going to work
correctly as we can endup with periods sizes aligned to 32 bytes however
not aligned to fragment size.

Update the constriants to use fragment size, and also set at step of
10ms for period size to accommodate DSP requirements of 10ms latency.

Fixes: 2a9e92d371db ("ASoC: qdsp6: q6asm: Add q6asm dai driver")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Alexey Klimov <alexey.klimov@linaro.org> # RB5, RB3
Link: https://patch.msgid.link/20251023102444.88158-4-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -413,13 +413,13 @@ static int q6asm_dai_open(struct snd_soc
 	}
 
 	ret = snd_pcm_hw_constraint_step(runtime, 0,
-		SNDRV_PCM_HW_PARAM_PERIOD_BYTES, 32);
+		SNDRV_PCM_HW_PARAM_PERIOD_SIZE, 480);
 	if (ret < 0) {
 		dev_err(dev, "constraint for period bytes step ret = %d\n",
 								ret);
 	}
 	ret = snd_pcm_hw_constraint_step(runtime, 0,
-		SNDRV_PCM_HW_PARAM_BUFFER_BYTES, 32);
+		SNDRV_PCM_HW_PARAM_BUFFER_SIZE, 480);
 	if (ret < 0) {
 		dev_err(dev, "constraint for buffer bytes step ret = %d\n",
 								ret);


