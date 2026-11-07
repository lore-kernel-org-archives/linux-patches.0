Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064909;
	b=0AN98kp5G/EpdQ+92JmMfJK4CvkLh5pKRspVozFsUwVeEwudr6yKF3LWv0hhnzJBF4GA
	 6HJeDGqYdJYs5BaFgCVm+6BkFxqR0gxymAREzt/wyWIw368OEUsqkBkS7dLPb1JU7vYj7
	 KkkgoBNSEcdqcW0adkgF4K8Ek4stN3LwzSuw3GOQypmQn+vGZsYK8/x3Aw90jyDNe9Ymx
	 uztcbKgd2F2uDJywC7yAU7eH0goIL6L7ugnZf6N4Jj4CYqfOpKDIHxugi1Twnvqu4Kc5z
	 U+hrIX/LD8neAEuzy/iAufgGUhtDiANzihRE4JLAiKL5uC8o+y0/tCrIuu+wsEUc1Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0oN0WJbkcMwJfLXW4jeFb+C6cSBsSDYV4Tih7e3ZfTg=;
	b=KunrQAkQfLKtkGSvW7AtD7JwhhB3h6rd/2lijkl5bvFQIbhJhXcpXdx2pZQwM1yd55rI
	 zsd5RnCncPAXk6SEZ1reZVA2RZcvKTK82kgbK1vIXS8VKJ1BRPUGDwSuK+5bwCvBZr427
	 otoZdxriEFpmCQ67W8gu6QHRFWA3TUFwZbKbE7SgERcYDYbrjzmokZl9G/KHm9cK+qdLJ
	 INy0SWobRSnH08AjTRxQpPl/oR7RNt+sQTvj21QIt7DXIHyVq14pe2fUJ+PbvQkscNsq+
	 7n7digfMXEQDYuuFz0G38DWzNjMrBDpKUD385WcAelgOzGsFQOc3gv3Ys66hIsNwZgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIfx1YgP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B7D606A9FC;
	Sat,  7 Nov 2026 15:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIfx1YgP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51321F0089F;
	Sat,  7 Nov 2026 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064908;
	bh=0oN0WJbkcMwJfLXW4jeFb+C6cSBsSDYV4Tih7e3ZfTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIfx1YgPsIfunkzYO8qq3YkfYV8cLJgDcjx1CdbFibApWL+Mq4JMG84GfXYqTDHH/
	 mXX5Yc+Vkkh1aWxSLiRueDB9Xj2eQyBL/bjEj2S55K61kMMAjoh/O+I3MQDvd4bHF9
	 9tiVb16km8mIRbtlcdyGIanHOJJ18b0fA810D5i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladyslav Tymoshchuk <tvlad744@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0810/1257] ASoC: qcom: q6asm-dai: wrap the position of a full ring to 0
Date: Sat,  7 Nov 2026 08:51:46 -0500
Message-ID: <20261107135001.712523031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladyslav Tymoshchuk <tvlad744@gmail.com>

[ Upstream commit 222d04cf55bc5b4b63602454014619c78deda89a ]

Commit 44432315444c ("ASoC: qcom: q6asm-dai: use q6asm_get_hw_pointer")
took the position from the number of period buffers the DSP has
returned in the current lap, 1..periods, and reports one frame less
than that, as q6apm-dai does.

One frame short, a playback stream whose application stops feeding it
never reaches the stop threshold: the DSP returns the last queued
buffer, the position stops at appl_ptr - 1 and no period interrupt
comes any more, so ALSA never detects the underrun, the stream stays
RUNNING and drain only ends on its timeout. On capture, the last frame
of each period is held back until the next one.

Before that commit the position wrapped to 0 at the end of the ring.
Do that again, as for q6apm-dai.

Fixes: 44432315444c ("ASoC: qcom: q6asm-dai: use q6asm_get_hw_pointer")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Vladyslav Tymoshchuk <tvlad744@gmail.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261014162703.10172-4-tvlad744@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6asm-dai.c b/sound/soc/qcom/qdsp6/q6asm-dai.c
index 4f09fdd409058..e3742663c13e3 100644
--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -485,11 +485,10 @@ static snd_pcm_uframes_t q6asm_dai_pointer(struct snd_soc_component *component,
 	struct q6asm_dai_rtd *prtd = runtime->private_data;
 	snd_pcm_uframes_t ptr;
 
-	ptr = q6asm_get_hw_pointer(prtd->audio_client, substream->stream) * runtime->period_size;
-	if (ptr)
-		return ptr - 1;
+	/* a full lap of period buffers is the start of the ring again */
+	ptr = q6asm_get_hw_pointer(prtd->audio_client, substream->stream) % runtime->periods;
 
-	return 0;
+	return ptr * runtime->period_size;
 }
 
 static int q6asm_dai_hw_params(struct snd_soc_component *component,
-- 
2.53.0



