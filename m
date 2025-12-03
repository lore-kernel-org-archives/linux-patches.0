Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F30C34D3B6;
	Wed,  3 Dec 2025 16:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779386; cv=none; b=oc9mK+pKASN62BV9SMhotlGwkRWRpHeiLjaalhZ3WX9lB7L+7L2PLKnK4iOybsufbJq8NkIAYQfXrmigGL7KcOSnB5/AuPVRxir+DaJ5z+azfXD1bm82Y0g0YWMeGSJMO0jPU8IKcYmpwjDRluvtjKZjm7wmOTtqbU5xNmfqOCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779386; c=relaxed/simple;
	bh=lny3wRn/F8N2QWYIgrkxg604UJB9elbRBetqx8Qh97U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pcm+o8y2qu5FtWVvyi7yyFIKb3eaZGk/7oeJwYxNtlWCIP2YdUDeKrmTG1J2JaRDNyH/cVZ7fZ9BCyvTg0vay14LPpLkdvwFF+8UBgb1nz1e31O02yd2WSsb1q7TU83eAKIso2km1nxPev0J8o5V2ZpQ6Amc6hgyYuazUDY3O0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EY948IQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EY948IQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB244C116B1;
	Wed,  3 Dec 2025 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779386;
	bh=lny3wRn/F8N2QWYIgrkxg604UJB9elbRBetqx8Qh97U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EY948IQGtSfgLuWHL2bLoWzrHZx8yI/73oNJOCbl9I3a41/FOdT1a7OuRhomFy2l+
	 uoLCx0BlJzSBpoGJnJl0w0w0YD++n9CbnBPlW/imLVwfqY/4tKL15XRkRsZOT4RjXi
	 J4Om2bxH6hiQM3CSetfO6aBpHtVUWnvV8LqM7FCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/568] ASoC: qcom: sc8280xp: explicitly set S16LE format in sc8280xp_be_hw_params_fixup()
Date: Wed,  3 Dec 2025 16:24:03 +0100
Message-ID: <20251203152449.546798355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 14d9fea33d16a..8ae2fe917c370 100644
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
@@ -39,8 +40,10 @@ static int sc8280xp_be_hw_params_fixup(struct snd_soc_pcm_runtime *rtd,
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



