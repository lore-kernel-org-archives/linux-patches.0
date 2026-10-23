Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774410;
	b=CMLDvE0hUjFsknD1UtybpoOxXwsIk0XD/gOhxaP9kYrtgJBYopbHzT8fgf5lcMTajl0C
	 Wo80faMVANTCSk2eikhD8jSGaAzlriWfFzUXbbHrfX1ebI6/sxPseE4V54ZXYoIrLA/wc
	 Q3I3yymrxVo4OrzhXCJ69rDT030HnR7QBh+kb1nIr7EO/1ekHxxteATOy7//aBszjTi8r
	 WtvyEbcAn2WYpxjdBGy6ITjFDNKI3aHV1YtCO4I71uOCcleRAbfhg+mViVoJIOtOxprJ/
	 BaFTDxboRyj/oCR0M7p8FS6Dczn8DUe2O9K+Z2GiL1zJ732M+HcBxUJOJwIJHvRlsCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lA3YSARqhrvP1EsntZRHXFjmrDCxarEi/ylKxV1drA4=;
	b=2LJ1knicwJcXLVV0sc3sw+yfvDwaX+u19OnMHoQEN9bEEdrvFuBKbaEIly0xAKkd/KQF
	 cGHyzGTEfN8oPMEgGCCPX9aKxTHBD9J2Jgxi3FU1CAFrDmCIc0D+gfInu7bM2Y8bcqTvu
	 g1eImYqdKp0e+AbzTa7PDzfoeDCUMyQjr9zSB3BU12LoeH3UW7C1aHMGtRZ51m+9lIS/b
	 G3UMFP676GbsixN0X5rKkIcswVTAChU6I9du5yRCCUaI44dDG5+OCHcyOgZMw/ltMY1Mm
	 2gu6USteGDinIOF/MqmcBTpjQdRY1kuaJnTEXTG+FZzG19pon1KmmH4AAsiPhnlYFZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oBEIuKPz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BDB606A31A;
	Fri, 23 Oct 2026 16:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oBEIuKPz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DC41F01825;
	Fri, 23 Oct 2026 16:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774410;
	bh=lA3YSARqhrvP1EsntZRHXFjmrDCxarEi/ylKxV1drA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBEIuKPzcpqlG1DzoWo8vqrTKrRRdVrtAzUQSUhcrybA6S7hPdM6AEraGIAZvVp7G
	 YXIE88qFZWkxylbFllaRYAq/RnO0PdrnK9cBsr/4RPnX96SeIUEKW/yqPKVKxJ3YNV
	 alUy9oOwNqxoMVjx9eWjoOvOFsk6TPdz6kuZQZs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Tiraspolsky <stiraspo@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 031/242] ASoC: Intel: avs: Reset the stream unless it is already prepared
Date: Fri, 23 Oct 2026 18:37:53 +0200
Message-ID: <20261023163714.518026984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Tiraspolsky <stiraspo@gmail.com>

[ Upstream commit f6be9f558a83fe30a03bd3adae461c821a0cef8c ]

Commit cfca1637bc2b ("ASoC: Intel: avs: Unprepare a stream when XRUN
occurs") resets the HDA stream when ->prepare() is called in the XRUN
state. User space does not always recover that way. PipeWire's ALSA
backend recovers from an underrun with snd_pcm_drop(), snd_pcm_prepare()
and a new start, so ->prepare() runs in the SETUP state,
hdac_stream->prepared is still set and the reset is skipped. Every
recovery attempt then fails the same way:

  spa.alsa: hw:avsmax98927,1p: snd_pcm_avail after recover: Broken pipe

On a Google Pixelbook (Kaby Lake, max98927 speakers) this happens after
an occasional underrun during normal playback and silences the speakers
for one to four minutes, until the PCM is closed. It can be provoked by
stopping PipeWire with SIGSTOP for 0.5 s during playback: in one run
that single underrun led to 1297 failed recoveries over two minutes,
until the sink was suspended. A plain alsa-lib program that recovers
with snd_pcm_drop() and snd_pcm_prepare() hits the same loop, while
snd_pcm_prepare() straight from XRUN recovers at once.

Skip the reset only when the stream is already PREPARED, the repeated
->prepare() case the check exists for, and reset it otherwise. With
this change both kinds of recovery succeed with a single restart.

Fixes: cfca1637bc2b ("ASoC: Intel: avs: Unprepare a stream when XRUN occurs")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Sergey Tiraspolsky <stiraspo@gmail.com>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261010103753.16969-1-stiraspo@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 094ea1366ea8f..b6ff66525210b 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -756,7 +756,7 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	host_stream = data->host_stream;
 
-	if (runtime->state == SNDRV_PCM_STATE_XRUN)
+	if (runtime->state != SNDRV_PCM_STATE_PREPARED)
 		hdac_stream(host_stream)->prepared = false;
 	if (hdac_stream(host_stream)->prepared)
 		return 0;
-- 
2.53.0



