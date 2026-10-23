Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773832;
	b=WUMEyRb2VDThGYJ07FEd6SUWHA/vV6zUc+SmyQPS+VC5dMOaqjqZWPlV+iNL9IHotn1V
	 aKiGlz7A3sbWJ+TGzfl1JwvdpTnsHqD244983tCFkC3s4rLqUnT5kDdAziCNGYhnM8Qow
	 Mo0+TURYadgDzqt/vfe6tGCsQZ7Q96viZCgc9+3dVLHe52cgqvKER1ENghpfNmsaUrWiX
	 7KVqRaXJPHQNogXgTncaPyI6gLwdpvdeCfNsynfETTnrMmGJnHU93HOjjJSHbp+JbsdFe
	 17hWYf5IbKkDwk/K4mMLoGgyqq6+T7xD5sbykdMDwyxJlJPoLuK+EscOxEvEpvKgcPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HI9I6OC2N2onLdpTc0TRpgKjNvPWxdGYDIVbKW7iVEU=;
	b=keK6NyfJkxTvNSO7MCd1sAB4BCVOD0RVNgGcdItHarLeio/u/OsK6ESSTF59lW6pIujL
	 GGRfBZhBMprQjmwc5s8qLzielkyC1htB30MQt962Fjm4y2MW9/lsPbA1WzPTiVSA5PrHP
	 vJ+/slC8zs3CvanvN5lh1XmvOtemz7Ov4qqNeBwHbwJi64P0OYiXwXNq3xO72lItQdePW
	 8kr1eZgZfLp4ZD2A4xg71XBK1qkw0iWh4JsEuIJNg8xGHMOLYuzO64T9LWIelL9F80pHc
	 t6UUbGgJcPKHMPsYku0+z42jhFbxoC5VvjO6+xXVOY/XrA87G51PYOyMCpFnasUVMgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFTXrjGG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B344360A2611;
	Fri, 23 Oct 2026 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFTXrjGG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8931F01829;
	Fri, 23 Oct 2026 16:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773831;
	bh=HI9I6OC2N2onLdpTc0TRpgKjNvPWxdGYDIVbKW7iVEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFTXrjGG0zu+OoHuZs6WGsJvj154CoUhssChc8DTJzwF9YAHig7JH+auMDyK75MgZ
	 zFcE7/nhxg9AIN9PsZ0FUHp8dYlt11he5sMeK6AJrwJp6Fsfr5FxFABLoC8bbJQal3
	 F6wy69S86nWSw+yqvsfkgia37lri/7yubOiqgYFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Tiraspolsky <stiraspo@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/193] ASoC: Intel: avs: Reset the stream unless it is already prepared
Date: Fri, 23 Oct 2026 18:35:07 +0200
Message-ID: <20261023163714.913144257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a2c05a4ced72b..8f09d539e2246 100644
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



