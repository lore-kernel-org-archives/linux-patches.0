Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050350;
	b=VGD9gcz4I7AN3xISxZ9VaSC220DK6/ZyUW8OMxvckrW9HqXNjA94tfETNUGjHT2ZnErG
	 Q/TUUQ9UL4CjZPvdWs8yqSnS8aeAoGD2w62PHBFwgRQW+RxhcJsJ6bgS6bT8xhyk5KaJA
	 CEMVBjf4zCnxBcdSBVHWNONxlUAUawDwfSt2wv2tq8SWrjtR1W7FGHih7+XFf06gcjvMG
	 ViMze8et1DTr8MJAQsTK9ezXQPfQTjhCTinp4GF0SjNbtaX9lVO1F+WleItyt5vKShCps
	 N5EcI3VMd4i/ckZg7TnD7l8gzK4oH5r0XYR3NsjP2XAheRkXvpR0sLgja0+O2nwv1uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HyQ+qZIAsS/EFZ2/GsiL7S7nVkAHoFR7wzg1yOvw4YI=;
	b=xwRACYJzfkPIp7AYMe0UyV9/uZ2jfBpCApv0WvdHc0tGSJvB3h+EvPXvXS0wlmuPhlw7
	 aG+akC6LAonSRCX3smRPuyto2NCRoJA/jMFYpFZHouBArsBCMZO3D2WIHvm25yIm+E3lF
	 aUkh/L0ga8OmzSBfVhqJYcF2PwJQ5h8sUYTy7TXwHHfGxFICsYPGccVCD8kasA9VlfXPq
	 zTp7TTd7OlMGVmBVXUHrf3K4XfP1vChEeZ8nB6A+Wi5V+IrC0PZPWxfvN9O7Jvp1Mxzxq
	 Il9tfdb9wAZYWM872ghIwbZdeHskD9ml70C9qbz2u8yn1BcxGVxtzfGV7YgPzwN+7+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gUEMDATD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B884606A32F;
	Thu, 19 Nov 2026 01:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gUEMDATD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30A21F000C4;
	Thu, 19 Nov 2026 01:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050350;
	bh=HyQ+qZIAsS/EFZ2/GsiL7S7nVkAHoFR7wzg1yOvw4YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUEMDATDJdTowdFd6C5VG859yj6hxx4z7+1PfgMEQG407VZbN34cu/ynKwHmpbpfn
	 z3FJ4wNl9r8e1HmV+cSWGAQgXFHiDSMaWuG1zkVJTsjxaxQJHEi4MCFdrBV3DEtDXg
	 T2heQZSeJqDZR5DLHxj5ATdkIY/ukMdfQew++77c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2678/2857] ASoC: samsung: Use snd_soc_substream_to_rtd() for accessing private_data
Date: Wed, 18 Nov 2026 16:01:52 +0100
Message-ID: <20261118150337.998270291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 3e726593107d134221f666b4f2be612b278c3ddb ]

Do not open-code snd_soc_substream_to_rtd().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240430-asoc-snd-substream-clean-v1-12-6f8a8902b479@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d9c23ac1217a ("ASoC: samsung: midas_wm1811: run FLL1 at the AIF1 configured rate when idle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/midas_wm1811.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/midas_wm1811.c b/sound/soc/samsung/midas_wm1811.c
index 126098fdcf1b4..fe1478bf63908 100644
--- a/sound/soc/samsung/midas_wm1811.c
+++ b/sound/soc/samsung/midas_wm1811.c
@@ -129,7 +129,7 @@ static int midas_stop_fll1(struct snd_soc_pcm_runtime *rtd)
 static int midas_aif1_hw_params(struct snd_pcm_substream *substream,
 				struct snd_pcm_hw_params *params)
 {
-	struct snd_soc_pcm_runtime *rtd	= substream->private_data;
+	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	unsigned int pll_out;
 
 	/* AIF1CLK should be at least 3MHz for "optimal performance" */
-- 
2.53.0



