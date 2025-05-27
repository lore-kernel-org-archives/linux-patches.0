Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5232F28032D;
	Tue, 27 May 2025 16:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364892; cv=none; b=jo9TSvaLrQ14cpP6FDrxvLwJrVU6wXXHTU2oYMqPevK0EtREAGlZxTIMbQxrtn7l4mvx7+KTkwShvINK5iQOSZv1YjJtukSxE54hKR1qoGEIIHgjxAjWbAxyodfiMKU/o20j0LmyEfpZlRRl3tAlKlR4vGL5vVL1i07KSqaAP8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364892; c=relaxed/simple;
	bh=05fwvd+4kxO+KskQF62sYzuR6VZYYU9QGPRl/2ZGOYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEGjSdPb4zcKjC3W4dgb2v4zvKtzCYTZJSSSNAEJ5Ds0mTQJRywKqHtDum06pFQI4WCi7b88DyZ/yhcdmJs1ntMZgEThJAJyB79ySTQ5LQhlz3psF4woj/PAF6ybAzYBukrk5Q3st0cPxtq6tpYTIqtrxJhFKytKOdlijVsEu3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8gZeev2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8gZeev2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD6CC4CEEF;
	Tue, 27 May 2025 16:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364892;
	bh=05fwvd+4kxO+KskQF62sYzuR6VZYYU9QGPRl/2ZGOYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8gZeev23E+pRULZLgauq/L+5hzz7b5H0jN2xV7RAcT5d7KXphgQeqHXMy2n0TLer
	 IMSzBXg/14EIj7zyfYZ5Zx20/EK4eRbSUz6pLOMP99mQSEeAujzgop1DB2jXQJ5tVM
	 YgW6Dw5Bg758zwdozrbsgbiN1pXm8yZcWoSmjbGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/626] ASoC: qcom: sm8250: explicitly set format in sm8250_be_hw_params_fixup()
Date: Tue, 27 May 2025 18:21:32 +0200
Message-ID: <20250527162453.106732263@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 89be3c15a58b2ccf31e969223c8ac93ca8932d81 ]

Setting format to s16le is required for compressed playback on compatible
soundcards.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20250228161430.373961-1-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/sm8250.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/qcom/sm8250.c b/sound/soc/qcom/sm8250.c
index 19adadedc88a2..1001fd3213803 100644
--- a/sound/soc/qcom/sm8250.c
+++ b/sound/soc/qcom/sm8250.c
@@ -7,6 +7,7 @@
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/pcm.h>
+#include <sound/pcm_params.h>
 #include <linux/soundwire/sdw.h>
 #include <sound/jack.h>
 #include <linux/input-event-codes.h>
@@ -39,9 +40,11 @@ static int sm8250_be_hw_params_fixup(struct snd_soc_pcm_runtime *rtd,
 					SNDRV_PCM_HW_PARAM_RATE);
 	struct snd_interval *channels = hw_param_interval(params,
 					SNDRV_PCM_HW_PARAM_CHANNELS);
+	struct snd_mask *fmt = hw_param_mask(params, SNDRV_PCM_HW_PARAM_FORMAT);
 
 	rate->min = rate->max = 48000;
 	channels->min = channels->max = 2;
+	snd_mask_set_format(fmt, SNDRV_PCM_FORMAT_S16_LE);
 
 	return 0;
 }
-- 
2.39.5



