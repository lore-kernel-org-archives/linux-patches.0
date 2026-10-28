Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216868;
	b=TtQmMPwmdGZM70miz/0o87iSAph8CAy4Ddt0gjKHbWPyUjruZVj/kPBKU4rpbnEKSF4G
	 CkAfWHOfvyrv3vroIMIn4ixFVp8wmuGiZJR2mcOWucmp3yLwUmP8O2fNzigHSjNMJTsZs
	 yRiOejhi9DoNVgGaibYpwPZM6dIbQ/8Jf7qqU0XtgQk7DR/Y7l9tpwE3KOCPMCIU0Al2A
	 0NcsKR91akS3Ad8FQ8cpqzpkle6XaZIXMxG7bLsSfhCwnhJtJcFGOkV0LACvsHugbgs9l
	 0ugF9v5HM67ZzM0rWsATnisGlKO9fzUAx2K7CQFz+mtDz9IpTMh2AHNljfHBBLz3/rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YXGdT4SCvrVUHXWqLmZu6OrD5Nx2W/4GOTAyFhTB/U0=;
	b=mAEb3ZCwmgQtBOyxyoJTq8aLNyF1l2XAfTnzIZ6dURHyaDw5ztp8adlkxuPX9LtxWgSa
	 zpKTYzm6YS/BNNKUSzUCcwUWqqkDOBRMVQmJQaty/X/+0JXMUkwXUgNI3XG/yJKKt9Qm+
	 RPz59T/zWLzS7rVJP8ifWhWTGpZZkAyqk6gEYx0NcrfRNtU0xsu4ZR9JU8QI7T42x7+bU
	 HWMb0odDeQgphPKeijZurpK+cY0+HtqEga9C/kL9yWVOgI5aF2Kl0YGnh0zU/tzNZrvp+
	 PR1sK5ncrENsFr1kn40C68MAKqhl/ECDA6XK0GZZcyxy8aE7wlbtyWnxKilN+tcdG8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEv0XGxP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ACA606A31F;
	Wed, 28 Oct 2026 19:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEv0XGxP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30471F01828;
	Wed, 28 Oct 2026 19:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216868;
	bh=YXGdT4SCvrVUHXWqLmZu6OrD5Nx2W/4GOTAyFhTB/U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEv0XGxPgEWgRnMuujJqwlrc7ZNoyFzmwMQyvIpZHBgxH5mTgYkDYnirKGR5MD9RD
	 1YltdSNtXYXCgYEp2dT1sTtZeGukjn9ECBdG79b8dBFKut10XBRChr/EbodpmGgfcz
	 y9xKXA3QCD5Lc059esKLztiu5Y6abfnQP/bnxSnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Tiraspolsky <stiraspo@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1708/1887] ASoC: Intel: avs: Reset the stream unless it is already prepared
Date: Wed, 28 Oct 2026 18:03:24 +0100
Message-ID: <20261028170538.324970715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index b61f753a1c60a..b6730cbd12224 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -556,7 +556,7 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	host_stream = data->host_stream;
 
-	if (runtime->state == SNDRV_PCM_STATE_XRUN)
+	if (runtime->state != SNDRV_PCM_STATE_PREPARED)
 		hdac_stream(host_stream)->prepared = false;
 	if (hdac_stream(host_stream)->prepared)
 		return 0;
-- 
2.53.0



