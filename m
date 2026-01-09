Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C442EAD10;
	Fri,  9 Jan 2026 12:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960851; cv=none; b=fKWSDU9AW0pHDPi5tPdo6mbfut5r7DaaB+8VdCpBk/8964nzyIwUg7m8Guv8Asj/n9wVXKSTS2GSAqTMV8I6b0sqQ0pC/26kOUaAOa6RHXe1M85CcSihLyItlUPYjLuXgHI6Gi1L/2sksAYoEVAF8MWFF30bbr8JcINhyy9Ima0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960851; c=relaxed/simple;
	bh=sqxqCaARzjEF4AJZBIw4rnH1yFmknHjDtdkIGCrLRhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVfiUEw1D+xZLjY/F3dsBY3Jh+bulzMGVwsHN+6Zsn+0RuwofWTmlBd1XQMfx7Uun78GuC7WoXWOqnhbq+Mk4Vn5zZXYhmWTwMtX1rFJgFXB7X723uuVjcsyOXfIxz92jz7EuHYOajryS87pT6x8fdJzOsaP8E9XVtwK58Kp9QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7CN8Vjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7CN8Vjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E26C4CEF1;
	Fri,  9 Jan 2026 12:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960850;
	bh=sqxqCaARzjEF4AJZBIw4rnH1yFmknHjDtdkIGCrLRhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7CN8VjcL8qwn70pCFwuIsKfK5OOlSvYHF4YnQIl7pJAH93/6JYfY+epJrtJTrCKL
	 S24G48BpI0TtE+oXRU0oOuRDJNlAAXqOXST38KQNzIrcj6kXzodL36MTsY7xCUpcsg
	 cps7FOErPpxhtAOMo/lduPF5L6CkEM/MepOqTSjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 6.6 548/737] ASoC: qcom: qdsp6: q6asm-dai: set 10 ms period and buffer alignment.
Date: Fri,  9 Jan 2026 12:41:27 +0100
Message-ID: <20260109112154.610563438@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


