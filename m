Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038411;
	b=QK1VbBdaF9AAfYt69NjgeBZN70UTmrY69ARm1Jyj32cybseflHjj3Lf42jR5VkPAOI4K
	 IkzkfpA8q4MPmPOAGrXXS11jfhQCu5sA8or6/3skMV4DLkN7JCsNY484LfexO7t2YLqGk
	 N03GMfP8uVk8LsgFrXnh2uD0WVJwNHtl4TwHYARkurzsBlnxDc3GmJy/jV3FVkBiKoh0c
	 /MtIkPC7MxvIB7aRqdM0QoL3g1q2le8IYYuePbqBMx8RpdYIr3g63+Y6C6kwmB2LsKHoe
	 iO1LIhY+cY1O+ZQ+fDZzvognvEReey6lAGX71TCBXw50b3YCZRAB5s2u+zhrta6S0AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VR4Zym12N71EKRlCwYUcVo/E14+pm4NacwNl1pHZcm4=;
	b=C+5xIiBrqWF+Mh/C420h7pdATIHnXcD4ZoTG7VfOGqJz0wHsqGGs/UpyMsJljDTmyNVp
	 tuneGsj9QtDC5+eVpYiZe075p55xQurD03N0jvTfCdKmemZbS5WkFRLxYsYqpXfneSrmp
	 CDI7o4n3y2N6jJCGTnDsnjmYYFTRwVg8WNEtjyzUzsI/zfQTpPAeENu3UaM6Se3Jlz704
	 968+ZKcaWJbZmZNLAOs58Z6tNgnyjEmDEY3PKZV9dpegQPCiCENCG0LKPo1hdM8ScJfW9
	 4ipIp97AVTCCjhQJN8sLofFnlBGaqB0HLCRZrg3VxdZfMhQy78DaumJdhx23wXtP+5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDcncnQ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE847606A325;
	Wed, 18 Nov 2026 21:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDcncnQ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6F71F000C4;
	Wed, 18 Nov 2026 21:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038410;
	bh=VR4Zym12N71EKRlCwYUcVo/E14+pm4NacwNl1pHZcm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDcncnQ2lA4VC2jFNFuQBiZo2QuCATw5sSPCLKfAG0r4hETDFF2rBGV2R+3tMmlLU
	 bpqPm54gkTcqnyNnj0u8gNSzpO+R1LsqNEWlQ52p9ZRKPBSVGqXMOu4J5Ay9w9rlg3
	 N7a6nxeXMzMjJA7rNDmNrROjZiWgT9usogc3krQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1732/3318] ASoC: qcom: q6apm-dai: wrap the position of a full ring to 0
Date: Wed, 18 Nov 2026 15:39:14 +0100
Message-ID: <20261118150413.825681670@linuxfoundation.org>
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

From: Vladyslav Tymoshchuk <tvlad744@gmail.com>

[ Upstream commit 0ea3e0b196f9dcc17b40ac881a6efef06459975b ]

q6apm_dai_pointer() turns the number of period buffers the DSP has
returned in the current lap, 1..periods, into a position and reports
one frame less than that. Commit a93dad6f4e6a ("ASoC: q6apm-dai: make
use of q6apm_get_hw_pointer") added the "- 1" so that the end of the
ring is not reported as a position equal to the buffer size.

One frame short has a cost once the application stops feeding the
stream. The DSP returns the last queued buffer and the position stops
at appl_ptr - 1, so avail stays at buffer_size - 1, below the default
stop_threshold. The DSP sends nothing more as its queue is empty, so
no period interrupt comes either: ALSA never detects the underrun and
the stream stays RUNNING. A poll-driven application that missed its
last wakeup waits forever, and drain only ends on its timeout, with
-EIO. On capture, the last frame of each period is held back until
the next one.

Before that commit the position wrapped to 0 at the end of the ring.
Do that again. A full lap is the start of the ring, and
snd_pcm_update_hw_ptr0() accounts for the wrap: the position cannot
move by more than one lap between two updates, as each returned buffer
calls snd_pcm_period_elapsed() and the DSP holds at most periods
buffers.

Seen on a OnePlus Pad 3 (SM8750) with PipeWire in interrupt-driven
scheduling: after a stall the PCM sat at hw_ptr 78239, appl_ptr 78240
(avail 3839 of 3840) for two hours.

Fixes: a93dad6f4e6a ("ASoC: q6apm-dai: make use of q6apm_get_hw_pointer")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Vladyslav Tymoshchuk <tvlad744@gmail.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261014162703.10172-2-tvlad744@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: adjusted context in q6apm_dai_pointer() because the preceding bytes_to_frames() branch is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm-dai.c b/sound/soc/qcom/qdsp6/q6apm-dai.c
index 80df749859190..9e22269a8c723 100644
--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -440,11 +440,15 @@ static snd_pcm_uframes_t q6apm_dai_pointer(struct snd_soc_component *component,
 	struct q6apm_dai_rtd *prtd = runtime->private_data;
 	snd_pcm_uframes_t ptr;
 
-	ptr = q6apm_get_hw_pointer(prtd->graph, substream->stream) * runtime->period_size;
-	if (ptr)
-		return ptr - 1;
+	/*
+	 * The hw pointer counts the period buffers the DSP has returned in
+	 * this lap, 1..periods. A full lap is the start of the ring again:
+	 * report 0 rather than one frame less, so that the position of a
+	 * drained buffer reaches appl_ptr and ALSA sees the underrun.
+	 */
+	ptr = q6apm_get_hw_pointer(prtd->graph, substream->stream) % runtime->periods;
 
-	return 0;
+	return ptr * runtime->period_size;
 }
 
 static int q6apm_dai_hw_params(struct snd_soc_component *component,
-- 
2.53.0



