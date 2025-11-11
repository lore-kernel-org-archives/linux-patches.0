Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44603255F28;
	Tue, 11 Nov 2025 01:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824900; cv=none; b=KU4OuQkbKJxeXtRvt2IW1SQnBdlhQ5QYdfPn5Lz+bb4rx4fndwdpjCQvf3ZnMidLyk/Vst/KB7mIKp7GlrzXAbkUwsvh51BCBnCHPyUirTxNNNqBlQbM3HeWPYKHL+n2lGVqox3ZMAKMuFPjkmYHwMZftVQZw0K+H+PYMP8oJ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824900; c=relaxed/simple;
	bh=/l9k3s4R5xTvRJKTyyz9DKkxImFguyCcSKeAk8giSFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUAUmLAfnsfthD6u7IUbbBAvl4uxfk56X3if+xUpydU7a+OdcbFjX+WM9P0G3gieRfy6qyPY7UC1tIVoto8MPaIhMhg5ZNmvY2kFFPEH5WeoRTmQjxIkZ0MMpJ+2p12VkyJl6xo8eE8wao2Jjnnx8Wis+Ubceb+D4Q6wYNJtMx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qewgp2rY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qewgp2rY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A4CC19421;
	Tue, 11 Nov 2025 01:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824899;
	bh=/l9k3s4R5xTvRJKTyyz9DKkxImFguyCcSKeAk8giSFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qewgp2rYJNkVp8uDKTVb0DxZMrNrn8hNpghcZfj9BKlEfoOx0t3f/7WrOncqB43Uz
	 FQqTO1OxJNlPuCfb1UdrlCAhe135/E/YWDGP2sk2Ks3lDIOuxol/3c095AcxXyaqjf
	 xkbJTrQbtJePNVSeJKrZY44fhqM8fpNnjfi4GnHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 594/849] ASoC: qcom: sc8280xp: explicitly set S16LE format in sc8280xp_be_hw_params_fixup()
Date: Tue, 11 Nov 2025 09:42:44 +0900
Message-ID: <20251111004550.783198977@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 6847ae4acbd18..78e327bc2f077 100644
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
@@ -86,8 +87,10 @@ static int sc8280xp_be_hw_params_fixup(struct snd_soc_pcm_runtime *rtd,
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



