Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5B73019BA;
	Tue,  6 Jan 2026 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720936; cv=none; b=T3mQ5ea1XbEOaHgw1pShyPrkqJlQVVXvFsOSSSSY21e1kfc45p4cRbq8pS0DvLcVesxexQ1YkKvjDNX3xBN3twuZAVp9IMPrY0DR5aJF+8kPUNMJmBmVaO60sFM6uCGDd3aBT4Kx7PRIYJxwqOWlZy4Qc8a1PWX06/V7S0dxt04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720936; c=relaxed/simple;
	bh=9OvqG662a2rv5ibefo1XrrVF06NRJzfj1gDGWtDmu7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6Xrmmtwrz5U6pGZT/gSERHbbBUFdb7ws5c/hag5Fa+4ooky8iHtEQSvuJfjRAl5mrM+Xkm311ASSFa1xKYK80iqvZjyi1X+aaelELQYYUjYOV2zpxwa2UprmEBe7wNsHk38/ND1Tmij15ys6FthKSDv1M/vaU4qN+8BP7CUSHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7lGRhhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7lGRhhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444C5C116C6;
	Tue,  6 Jan 2026 17:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720936;
	bh=9OvqG662a2rv5ibefo1XrrVF06NRJzfj1gDGWtDmu7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7lGRhhqB/C89rSjqblKwSWWDsYYuezHiFpUD7ADc3NyhXE9xnR9jyV1AeekNNx8z
	 +iMJ6H+hegsw36U/6oMduN+zvqjE7J0lzhDNU8OvNO59mHfhh8mvnZwexkVj6LuO64
	 memCXjPeOcMsGe1H5B6tF1x/cSWTuG2vrJbrz8Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 6.12 353/567] ASoC: qcom: qdsp6: q6asm-dai: set 10 ms period and buffer alignment.
Date: Tue,  6 Jan 2026 18:02:15 +0100
Message-ID: <20260106170504.392495995@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -403,13 +403,13 @@ static int q6asm_dai_open(struct snd_soc
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


