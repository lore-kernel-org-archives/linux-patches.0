Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591475;
	b=mWbf6jHNuragZ6H+WwtBMZXY1BfbntG1xsgLA2VCvn1oyA3g0p2Ths/ePznGcfY94YGS
	 ASaUoQ2w6C+1rA/5mxc4gTU/MGsFniTw2mYCkmxhRoCHHBcdTlw5J0tnYJ/1Ka737VyQD
	 cG7pS5X6nTMK2L5qddzJltwghiLZFwgWSGD1B6kKpsnejK3FF3aWdFKYFhf2d6i3IgcNj
	 Xbqyv5uvHOCioo5BlOCu1bDzrjupxiJj8UcNJFebvP5YywH5Dy140FyEws6CSB8ewRC7S
	 1ItxIJP4m8wr//wDjDlB6mIb+fgFsrioz8oocE3b451tPh0NrZrVzrjagJbTyOBqEvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h5MzLMSF+HPXTy1N2eixDpOBi0VoWWs8p+H88bCGHL8=;
	b=mWwBvQVA5FxUg/HUMfYCqOBTvbW+kZ6DTY9s1ciqjYqRz+gHEzamcm+AnkubURYIX6fr
	 h67XLlYrYR9U01nfHpchSUpRkdLFSFTzY7ld25Fs9p+P+dzWUYe3r/YNBa9S2iYkkV5/n
	 qDqsBnXScSHfxbxteM3fUye+aGQYgg7vtgASZpoooDmfMhymgWdCz5L2BRFqR48Yzy7z/
	 OQA2BrCPZgPPc1gZNWfBA/J7oTqn4NcwVeArMdsoVULDE7ytD9y49bM/NUQytCRRlAWLQ
	 NV00aSzU36ChgbbYuomloqB7BAHwq98z0PQ1kL+Ar+zzMQSavUtRk0eetw5oZzYUAZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlYX6FJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB25606E212;
	Fri, 13 Nov 2026 17:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlYX6FJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5531F000C4;
	Fri, 13 Nov 2026 17:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591475;
	bh=h5MzLMSF+HPXTy1N2eixDpOBi0VoWWs8p+H88bCGHL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlYX6FJZhR0dEtGrfec6X7u53sdwf2qrfcy3dqSktirla/XnVcZn/shqf4ghOCwe9
	 T9kMci+1IP4yn8M6xUBOtsBpC6H2qodjUqLUShfJBVrb6SotjJpfv6dQhhtoZgtfrK
	 wlSNQ7a00VjVDiwCURrTk8svuli3+jzpnSzxlx/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 557/670] ASoC: qcom: q6apm-dai: wrap the position of a full ring to 0
Date: Fri, 13 Nov 2026 10:52:01 -0500
Message-ID: <20261113153830.761102639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3b00c6d5174ab..fef69e4318908 100644
--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -441,11 +441,15 @@ static snd_pcm_uframes_t q6apm_dai_pointer(struct snd_soc_component *component,
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



