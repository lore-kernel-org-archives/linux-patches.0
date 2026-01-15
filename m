Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3793BF31C;
	Thu, 15 Jan 2026 17:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498269; cv=none; b=mbwVeoaRfGTvSz87kW+4RSeoj7MUo6l6QHZfJZTT50N/qbakIamjx3NdjB0QOeBS0uNcKw5xB2TvbM34OTgKazK4UKrZ5eIlV727pDJ/gw/YINzGZ3KjgC3g2VZr/VxC3LsxYBNBqrW6kKyJ4mVdfPcUFheM9n38YJau+Z5U4cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498269; c=relaxed/simple;
	bh=s8e3+/z1jESlawvG0hDZf5LtO1tMAwa2UCFLjFUx7UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYYEgSXS5O9PP257Qj0leawd0IFjH3ofa5yyjeV4ztRypqwT5OZ8RhuiPASudfeHlAINf79TatiDVYlLNQj/YDlVitPJZsLzNcrt9pyzbpPUKmdmhkx/xu1IP7ctPfe6YA5FPpbvPFWI1Ahz3uFjLtq5SC4nrM4pUNKfTEwfl4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zI5nw7TJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zI5nw7TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170AAC116D0;
	Thu, 15 Jan 2026 17:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498269;
	bh=s8e3+/z1jESlawvG0hDZf5LtO1tMAwa2UCFLjFUx7UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zI5nw7TJHYOk1c7aTrvSpeFTuMmA83ivmtKnm85KmT7jH7XDE/hHXwOt1vrycgZvC
	 K3SkNkSSEVBLm4+oogoamOw5N1zGdDTKjF9zgkwgtZjuRnjNUr5mPJpPsDjMd5Dlgz
	 AX/+rpsIW/Z/ronooLCUd7r+HDEs7x8nhfsn3noU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 5.15 372/554] ASoC: qcom: qdsp6: q6asm-dai: set 10 ms period and buffer alignment.
Date: Thu, 15 Jan 2026 17:47:18 +0100
Message-ID: <20260115164259.695206966@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


