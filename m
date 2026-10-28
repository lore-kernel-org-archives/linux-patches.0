Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207474;
	b=eYfYMz6f0AT+a+mHB0D0U3TxMYGb3gtbkrxjrw8j9OHJp3UEokAvylaN8OQ0ziskgtBL
	 c6nVgDsss/FjD4di35Nz+mV5cvNIrJ3JPGJ1L2qfaWon1GZ9vG8QAQy14qgWyTnE6xaOh
	 NXiRfa1YDDWMB8Uvuu9TN0E8KqvnB13yDV0Eb0rqr/BgCin21odFZgUyClaoxj39pvAG4
	 evEyY9mNEaTJxLU9lLtLBnVboKxMJzEYAMH4+5XFFHIK6hIs/+6AJ8V11ppSCMIDAymm5
	 FgtFgYbEPSFMhWWiEFilHJdZDvrqTr3Xoo3SnL9OmCywWiKiCpd8gHxw3cfyyOi3cCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f42yJlcmAb6qn+Pdg66YxpMO69CKLrmU+4fzV00Ys8A=;
	b=JgxUWO7MKNzhbo4ZYDcjcWsTpQbhhOqYlt9P5emyijIwJJqTe9uSr2bkd5UZP/sMeB7h
	 vhqPAKCZkbY8LcQaXLXwPk4lClklgT5DmpORd7zNQw1ILdK/kwP1sWkb9NkDoRKZYjCeV
	 r+xFFSEgMpbAc4rRI8YEjm6eyAVFyou0uI77Dj7fKpLWM5F9uoY7AJbanh8tCISXGY7Ff
	 oGX5Nvw5NX8gxGo4u608hvhI9HY+EtPNxQLMSb+ZVDyPdBnCfLdiWEiwtquw9PxhoAqEm
	 PplADzaEBwRUQAiBJ7sijBcOc1yr82yGd7+RN/SbK65LGk3EpQVTc2UGWCuWBfc3boA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGl2AeZ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4FA606A31E;
	Wed, 28 Oct 2026 17:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGl2AeZ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293D41F01825;
	Wed, 28 Oct 2026 17:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207473;
	bh=f42yJlcmAb6qn+Pdg66YxpMO69CKLrmU+4fzV00Ys8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGl2AeZ09kCXyqoERzCQolDmWYzv8DCXRReazVQ2ZyBUmDAMpAc6MErGxJddAFsra
	 JyTkolODpuNFl7JLWerbeUiJh2FEPtVgQRahqqUwKGz2v6cJ9TGf4KOBW2WHp83Zq5
	 lG85+8PdNSFLcRjBYT2y0boeQXbJwLqMzstnC9i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Tiraspolsky <stiraspo@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/247] ASoC: Intel: avs: Reset the stream unless it is already prepared
Date: Wed, 28 Oct 2026 17:57:12 +0100
Message-ID: <20261028165948.057407646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 81fe4f0218c1a..78b330e225704 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -660,7 +660,7 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	host_stream = data->host_stream;
 
-	if (runtime->state == SNDRV_PCM_STATE_XRUN)
+	if (runtime->state != SNDRV_PCM_STATE_PREPARED)
 		hdac_stream(host_stream)->prepared = false;
 	if (hdac_stream(host_stream)->prepared)
 		return 0;
-- 
2.53.0



