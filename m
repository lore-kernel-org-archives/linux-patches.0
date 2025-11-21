Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7CB346A0E;
	Fri, 21 Nov 2025 13:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732816; cv=none; b=dajbT+CPjch7tqbF6IAKin5rfljWcAFVwgKj7sQpFvHqOF4PR44eN5UU3H/OMiu0nLUeDGMF9tgpiJDPYGLt2wWSKh6CCfHIXSNeVYbVJju9gLjEGBus3koEPLNBO8KPZXGUJQEV16mGEHM1+qzouFTm9M8K5bwERDbLkKb48aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732816; c=relaxed/simple;
	bh=RbijoJT+ktgBPqCIwL52aup2UvmfjzlxPQ1PHC1rOJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+ui+No7PCmhelv5R2gfwv0m2r1In5SnkHtlqZnSXsa2iJPVLylF3rcQ1ZJ2m1Xoe6CZKlVBOLrwkYYE0fzCSHd8ycEbpdgzM4y5YAYqOJGUJDYxPOp9cSa/8xpin2F+ontv9fBK9cYe7zAO6u/WICVASog0mQ/F2MWCqwsrDQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xR4Ymhi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xR4Ymhi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5334AC4CEFB;
	Fri, 21 Nov 2025 13:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732816;
	bh=RbijoJT+ktgBPqCIwL52aup2UvmfjzlxPQ1PHC1rOJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xR4Ymhi2HQU7vQH2F/Yf2nk6TXV8y0+kvovWnWSj0SIRXEjlac5egVRNrfZcjoD+D
	 PrFaQzYHq9TNrb99JZT74yHNXrbBQlIh5y/EpuO95B0qqsL502Q6gXQ7Bcc5DHcFyw
	 UDh1a7XWklDFmybcONlu0SwLYVaKSAJ69xlbfnwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/529] ASoC: qcom: sc8280xp: explicitly set S16LE format in sc8280xp_be_hw_params_fixup()
Date: Fri, 21 Nov 2025 14:09:13 +0100
Message-ID: <20251121130240.057705856@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 9565c9d53c5b440f0dde6fa731a99c1b14d879d2 ]

Setting format to s16le is required for compressed playback on compatible
soundcards.

Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20250911154340.2798304-1-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/sc8280xp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/qcom/sc8280xp.c b/sound/soc/qcom/sc8280xp.c
index d5cc967992d16..ee195a54d0c3b 100644
--- a/sound/soc/qcom/sc8280xp.c
+++ b/sound/soc/qcom/sc8280xp.c
@@ -7,6 +7,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/pcm.h>
+#include <sound/pcm_params.h>
 #include <linux/soundwire/sdw.h>
 #include <sound/jack.h>
 #include <linux/input-event-codes.h>
@@ -58,8 +59,10 @@ static int sc8280xp_be_hw_params_fixup(struct snd_soc_pcm_runtime *rtd,
 					SNDRV_PCM_HW_PARAM_RATE);
 	struct snd_interval *channels = hw_param_interval(params,
 					SNDRV_PCM_HW_PARAM_CHANNELS);
+	struct snd_mask *fmt = hw_param_mask(params, SNDRV_PCM_HW_PARAM_FORMAT);
 
 	rate->min = rate->max = 48000;
+	snd_mask_set_format(fmt, SNDRV_PCM_FORMAT_S16_LE);
 	channels->min = 2;
 	channels->max = 2;
 	switch (cpu_dai->id) {
-- 
2.51.0



