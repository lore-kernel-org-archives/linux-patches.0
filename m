Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625585;
	b=lMIlO1hu9iYm55qi78VSnu5So+YlhJmRMtSS/1tGkPXkYLPFU1DJ0olsLDh/GfxlDnGj
	 KmV9FWhzlk0cVD2QfwuJ730oeQwiPDlNszHJpzUuaXXd851hT2dY8gewgkFfuzuK/S7H3
	 tWd5/AAG+KlHe/EP90PsYPFzHifgBb4JsRzF3xrYCwufH2ZgJKeUKJsB+mtCTxljw/QAd
	 fnH9IwmQALJ7V6ZjapBe1n3+vFbR/G6yQv2Ip9k9NZbk/m82v+HoP+DdZw0iy1/6ln1fA
	 ehdqNEso4FcO2c5r7CbXeN/m5Oru8Omymu6g03oV7D0CjOcmi+8xOqcUBAQwFDp7nbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lR9lWPdVuUZnkUFLDq0NQfDnCLTF9wpv/ETdbcpfyWY=;
	b=w4zMtVmdWbRzxKGb/PpSJXvEXmfYICjf9vxHFuJfM+dJig+gPunGSGsyHE4v9JoKq9DC
	 aQRHlw0pNsb54L1S0k5Cp7Z1v8nRGpicy3L/Ob3DxZV7VIaNKmflBzNYFGRNwWeP9L8sT
	 Ta1X0BeLEtvIoFvWEy/UAUMN4ORl0FkdYy3Tv7cqlsf9iEx4U0Vnvq1XKLD+3VhEMrbD8
	 RKOAKuB1R2lWFmDTdbKTHOQi3xCripvTGA8DtzSFuiJK5qRl4GanTS9+shpB4pEWuuA98
	 PYfaF2L6i6rZ4G53tbPgdUcxd+bXS58CEzUVB5aYo6g8Gc3V1pLDvLdhUf8nHHjpIWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0p0MnvBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4050606A31E;
	Wed, 25 Nov 2026 16:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0p0MnvBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB081F000C4;
	Wed, 25 Nov 2026 16:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625584;
	bh=lR9lWPdVuUZnkUFLDq0NQfDnCLTF9wpv/ETdbcpfyWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0p0MnvBDFJJBfAP1tTP/usYdl4kJaqVecJtj/ZzeYexJe1v1pWVG6yhdBaFd4HEHs
	 dYnTLlauQcWSEQtWI3sMkwRkgtQYc9rZQCVUCf9LBl5iRZYFbVjFKHUKL/S8XRwoYr
	 MkD2pwwCY5w+OrY3PfWrzjyGrk7lcZzwUz2H2HDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 520/816] ALSA: aloop: Keep shared timer callbacks alive through close
Date: Wed, 25 Nov 2026 15:34:28 +0100
Message-ID: <20261125143901.223856844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit a7d4d780f34b9e43eefab6a7e6c9f4101f2c144e ]

The shared sound-timer callback must finish using the selected PCM
runtimes before a close can detach them. loopback_snd_timer_period_elapsed()
saves the active substreams under cable->lock, then drops the lock before
calling snd_pcm_period_elapsed() or snd_pcm_stop_xrun(). The sound-timer
backend has no per-stream close drain, and free_cable() keeps the timer
open when the paired endpoint remains attached.

With both directions running on a shared sound timer, playback can be
dropped and closed while a notification is pending. Capture keeps the
timer alive, allowing this order:

  Timer callback                       Playback owner
  --------------                       --------------
  select playback under cable->lock
  unlock; delay notification
                                       DROP; HW_FREE -> OPEN
                                       close: snd_pcm_drop(); unlock
                                       free_cable(); peer stays alive
  snd_pcm_period_elapsed()
    lock stream; cache runtime
                                       snd_pcm_detach_substream()
                                         free runtime and its fasync
    read runtime->fasync

The stream lock taken by snd_pcm_drop() cannot protect a notification
that starts after it returns, and detach does not take it. The callback
can therefore read runtime->fasync after the runtime has been freed, and
an escaped notification can also reach a replacement runtime if the same
substream slot is reopened before the notification resumes.

Take the existing cable->stop_count reference under cable->lock when
selecting the targets and release it after the PCM callbacks finish,
including the XRUN path. free_cable() already removes the closing
endpoint under that lock and waits for stop_count before returning, so
runtime detach and slot reuse cannot overtake the notification.

Fixes: 26c53379f98d ("ALSA: aloop: Support selection of snd_timer instead of jiffies")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM
Link: https://patch.msgid.link/pm-pmb-275c4399f517e09d7188-v2-2f64c1328529ef7a8fec@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Replaced snd_refcount get/put with atomic_inc/atomic_dec_and_test plus wake_up on the existing stop_count, and adapted the function body to the spin_lock_irqsave form instead of scoped_guard. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index fa8d2877516d9..7c69f5141ed2e 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -98,7 +98,7 @@ struct loopback_ops {
 struct loopback_cable {
 	spinlock_t lock;
 	struct loopback_pcm *streams[2];
-	/* in-flight peer stops running outside cable->lock */
+	/* in-flight PCM callbacks running outside cable->lock */
 	atomic_t stop_count;
 	wait_queue_head_t stop_wait;
 	struct snd_pcm_hardware hw;
@@ -809,6 +809,8 @@ static void loopback_snd_timer_period_elapsed(struct loopback_cable *cable,
 	valid_runtime = (running & (1 << SNDRV_PCM_STREAM_PLAYBACK)) ?
 				dpcm_play->substream->runtime :
 				dpcm_capt->substream->runtime;
+	/* Keep runtimes alive through the PCM callbacks. */
+	atomic_inc(&cable->stop_count);
 
 	/* resolution is only valid for SNDRV_TIMER_EVENT_TICK events */
 	if (event == SNDRV_TIMER_EVENT_TICK) {
@@ -823,7 +825,7 @@ static void loopback_snd_timer_period_elapsed(struct loopback_cable *cable,
 				snd_pcm_stop_xrun(substream_play);
 			if (substream_capt)
 				snd_pcm_stop_xrun(substream_capt);
-			return;
+			goto exit;
 		}
 	}
 
@@ -847,6 +849,10 @@ static void loopback_snd_timer_period_elapsed(struct loopback_cable *cable,
 		snd_pcm_period_elapsed(substream_play);
 	if (substream_capt)
 		snd_pcm_period_elapsed(substream_capt);
+
+exit:
+	if (atomic_dec_and_test(&cable->stop_count))
+		wake_up(&cable->stop_wait);
 }
 
 static void loopback_snd_timer_function(struct snd_timer_instance *timeri,
@@ -1092,7 +1098,7 @@ static void free_cable(struct snd_pcm_substream *substream)
 		other_alive = cable->streams[!substream->stream];
 	}
 
-	/* Pair with the stop_count increment in loopback_check_format(). */
+	/* Wait for PCM callbacks running outside cable->lock. */
 	wait_event(cable->stop_wait, !atomic_read(&cable->stop_count));
 	if (other_alive)
 		return;
-- 
2.53.0



