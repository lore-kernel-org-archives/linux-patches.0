Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21451CEAC2;
	Tue, 27 May 2025 17:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366969; cv=none; b=raB/pPsKzRX2Et5XuND07mYEdaKvLJHP+1SYWGR1DzI/a4EKMl0ySJKZTq0ODbHtzzObNKDLBUj2Afyon75RTCudypfNiylHr8lPC16ueaRBZJ8AT8y7UGAQ+wTZg+L4fNVBBHHN0HfESOYUPhFix9FGADq/US2aNmyb5BJDds8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366969; c=relaxed/simple;
	bh=iNLo1AhpA30xOQ4TcNS87/NJZ5gbug1PhP7kAojMRV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5JHmA2kb2EL5A4iy+y0wewTGGHzFmGacJ1FcvgX8czEj/DjEFHa1QJSUeoB7nWA0GkyqjS1mzJmrgGFszg3r7n85VIn3z49vsQNR+IaqyjwgDIEki0GDEs4RGBY93/+ckCvnm+LkRtVcQBUZanfQApIUlKMa9VF9kUQBWMHa/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yg9hTY8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yg9hTY8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F8DC4CEE9;
	Tue, 27 May 2025 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366968;
	bh=iNLo1AhpA30xOQ4TcNS87/NJZ5gbug1PhP7kAojMRV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yg9hTY8xZw+qjz8kNle84AXwHp6pBS8IWM1X9ak1EOcqvRZQFENgfwS3uRCg1ZRc7
	 QrQpHeg/ICQICkmnpGKW4bnc4zXCXlaggWEy7AFYNE5L12nt/GU5ONquYeRbEX/+gm
	 zhq3hm92uWU6EyKdiY3T4ko+jW2rGhQXP7EORE4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 235/783] ASoC: qcom: sm8250: explicitly set format in sm8250_be_hw_params_fixup()
Date: Tue, 27 May 2025 18:20:32 +0200
Message-ID: <20250527162522.694021005@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 45e0c33fc3f37..9039107972e2b 100644
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



