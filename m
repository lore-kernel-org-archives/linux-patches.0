Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208306;
	b=StHedkTfb8SZra7vY21Y4GJGnz+ethMwxkA/BeR+lVRuSyn+r1oYzDmTKg/UbVogJMzB
	 pIbXhmvTfeztuYjGYuStnUKPLuFVSX5DHDEINMO9dWlBYF0CLktG2pE5G3vOTQ+J6DTtn
	 t9aHP5JgkgfxAF6FACtXHc26Sy6X9uwAxTEtaAzljHfIKmRZjsKho12NyZ1DDN0dfrWcg
	 vZ93yzMEgcpf/v5yBZrEfGK0J313LigOTOWePxTHj1Eq06ygsQyPa5K/1EE0g+i1pd6Y7
	 EjaDA9JnkM2jhTxmi18ufSCYvs5rCD793CsPa0zTof/t02ra79y4XTe6ObkvdLfbFVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ayGxBXhYN+Zqf+QTFbClqKs983IOUdo3L8fkvX0lieM=;
	b=ifen6ZB6f2duCEvGIA1hZK/nCdV0O5huxIQ6uGQrtViwal9pw5ULDfE7pNMA4wMrsI1f
	 H14LRp7yxtA6DbR4Rbhuwy1PrZUX9f7/t3UmUw7ekvvkxmuyV4O5QiYgXZs4twJnXxrvL
	 ZtMKiE8Nwxa55L3oKd26gTQhb1ye0jZwCY9UY5C9SVGr4fQqKx4tYUAy8l5ZNeBQEBbgu
	 8YG1IOghqeLuYkAs858+ZD/XeZ8/vmN9hQr9Okfwy51bKZ7ALdkDRO+lrX6d1X32anUJ+
	 Hp21W7l19m3b7tsIU+PgdlHI3mtVZxZMm/b+HP+wr/lMmDa+oV0AjQ7gR24SOOLdBPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yM/9NzRU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27645606A31C;
	Wed, 28 Oct 2026 17:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yM/9NzRU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F341F01825;
	Wed, 28 Oct 2026 17:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208306;
	bh=ayGxBXhYN+Zqf+QTFbClqKs983IOUdo3L8fkvX0lieM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yM/9NzRUEjOZzxiXCeJru0CE8jGyx5bcCKVyEP7vH/HnNMcdNLQ2MNIPb87QlOrRL
	 +KA5Os2N62a5vZYdY6rkekd9uWIhs97+veqmrCM8xj8n4fphUtB6Q7UBdl3Hc/BdPz
	 vCgAu+otTE3UCvpUf+mVXp5ib504lTAV4LIioh/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <wangborong@cdjrlc.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/516] ALSA: pcxhr: use __func__ to get funcions name in an output message
Date: Wed, 28 Oct 2026 17:53:45 +0100
Message-ID: <20261028170005.252298303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <wangborong@cdjrlc.com>

[ Upstream commit fac24b0f34c179c6ca863f5205fad42a676caf9a ]

Prefer using '"%s...", __func__' to get current function's name in
an output message.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Link: https://lore.kernel.org/r/20210731052647.141046-1-wangborong@cdjrlc.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 6c97817e2059 ("ALSA: pcxhr: initialize mutexes before requesting threaded IRQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/pcxhr/pcxhr.c | 47 ++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index c2e4831c3a13f..1fe7e876c7fb4 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -367,7 +367,7 @@ static int pcxhr_sub_set_clock(struct pcxhr_mgr *mgr,
 		mgr->codec_speed = speed;	/* save new codec speed */
 	}
 
-	dev_dbg(&mgr->pci->dev, "pcxhr_sub_set_clock to %dHz (realfreq=%d)\n",
+	dev_dbg(&mgr->pci->dev, "%s to %dHz (realfreq=%d)\n", __func__,
 		    rate, realfreq);
 	return 0;
 }
@@ -500,7 +500,7 @@ static int pcxhr_set_stream_state(struct snd_pcxhr *chip,
 	else {
 		if (stream->status != PCXHR_STREAM_STATUS_SCHEDULE_STOP) {
 			dev_err(chip->card->dev,
-				"pcxhr_set_stream_state CANNOT be stopped\n");
+				"%s CANNOT be stopped\n", __func__);
 			return -EINVAL;
 		}
 		start = 0;
@@ -525,7 +525,7 @@ static int pcxhr_set_stream_state(struct snd_pcxhr *chip,
 	err = pcxhr_send_msg(chip->mgr, &rmh);
 	if (err)
 		dev_err(chip->card->dev,
-			"ERROR pcxhr_set_stream_state err=%x;\n", err);
+			"ERROR %s err=%x;\n", __func__, err);
 	stream->status =
 	  start ? PCXHR_STREAM_STATUS_STARTED : PCXHR_STREAM_STATUS_STOPPED;
 	return err;
@@ -571,7 +571,7 @@ static int pcxhr_set_format(struct pcxhr_stream *stream)
 		break;
 	default:
 		dev_err(chip->card->dev,
-			"error pcxhr_set_format() : unknown format\n");
+			"error %s() : unknown format\n", __func__);
 		return -EINVAL;
 	}
 
@@ -616,7 +616,7 @@ static int pcxhr_set_format(struct pcxhr_stream *stream)
 	err = pcxhr_send_msg(chip->mgr, &rmh);
 	if (err)
 		dev_err(chip->card->dev,
-			"ERROR pcxhr_set_format err=%x;\n", err);
+			"ERROR %s err=%x;\n", __func__, err);
 	return err;
 }
 
@@ -631,7 +631,7 @@ static int pcxhr_update_r_buffer(struct pcxhr_stream *stream)
 	stream_num = is_capture ? 0 : subs->number;
 
 	dev_dbg(chip->card->dev,
-		"pcxhr_update_r_buffer(pcm%c%d) : addr(%p) bytes(%zx) subs(%d)\n",
+		"%s(pcm%c%d) : addr(%p) bytes(%zx) subs(%d)\n", __func__,
 		is_capture ? 'c' : 'p',
 		chip->chip_idx, (void *)(long)subs->runtime->dma_addr,
 		subs->runtime->dma_bytes, subs->number);
@@ -722,21 +722,20 @@ static void pcxhr_start_linked_stream(struct pcxhr_mgr *mgr)
 	}
 	if (capture_mask == 0 && playback_mask == 0) {
 		mutex_unlock(&mgr->setup_mutex);
-		dev_err(&mgr->pci->dev, "pcxhr_start_linked_stream : no pipes\n");
+		dev_err(&mgr->pci->dev, "%s : no pipes\n", __func__);
 		return;
 	}
 
-	dev_dbg(&mgr->pci->dev, "pcxhr_start_linked_stream : "
-		    "playback_mask=%x capture_mask=%x\n",
-		    playback_mask, capture_mask);
+	dev_dbg(&mgr->pci->dev, "%s : playback_mask=%x capture_mask=%x\n",
+		    __func__, playback_mask, capture_mask);
 
 	/* synchronous stop of all the pipes concerned */
 	err = pcxhr_set_pipe_state(mgr,  playback_mask, capture_mask, 0);
 	if (err) {
 		mutex_unlock(&mgr->setup_mutex);
-		dev_err(&mgr->pci->dev, "pcxhr_start_linked_stream : "
+		dev_err(&mgr->pci->dev, "%s : "
 			   "error stop pipes (P%x C%x)\n",
-			   playback_mask, capture_mask);
+			   __func__, playback_mask, capture_mask);
 		return;
 	}
 
@@ -779,9 +778,9 @@ static void pcxhr_start_linked_stream(struct pcxhr_mgr *mgr)
 	err = pcxhr_set_pipe_state(mgr, playback_mask, capture_mask, 1);
 	if (err) {
 		mutex_unlock(&mgr->setup_mutex);
-		dev_err(&mgr->pci->dev, "pcxhr_start_linked_stream : "
+		dev_err(&mgr->pci->dev, "%s : "
 			   "error start pipes (P%x C%x)\n",
-			   playback_mask, capture_mask);
+			   __func__, playback_mask, capture_mask);
 		return;
 	}
 
@@ -890,7 +889,7 @@ static int pcxhr_hardware_timer(struct pcxhr_mgr *mgr, int start)
 	}
 	err = pcxhr_send_msg(mgr, &rmh);
 	if (err < 0)
-		dev_err(&mgr->pci->dev, "error pcxhr_hardware_timer err(%x)\n",
+		dev_err(&mgr->pci->dev, "error %s err(%x)\n", __func__,
 			   err);
 	return err;
 }
@@ -905,7 +904,7 @@ static int pcxhr_prepare(struct snd_pcm_substream *subs)
 	int err = 0;
 
 	dev_dbg(chip->card->dev,
-		"pcxhr_prepare : period_size(%lx) periods(%x) buffer_size(%lx)\n",
+		"%s : period_size(%lx) periods(%x) buffer_size(%lx)\n", __func__,
 		    subs->runtime->period_size, subs->runtime->periods,
 		    subs->runtime->buffer_size);
 
@@ -998,12 +997,12 @@ static int pcxhr_open(struct snd_pcm_substream *subs)
 	runtime->hw = pcxhr_caps;
 
 	if( subs->stream == SNDRV_PCM_STREAM_PLAYBACK ) {
-		dev_dbg(chip->card->dev, "pcxhr_open playback chip%d subs%d\n",
-			    chip->chip_idx, subs->number);
+		dev_dbg(chip->card->dev, "%s playback chip%d subs%d\n",
+			    __func__, chip->chip_idx, subs->number);
 		stream = &chip->playback_stream[subs->number];
 	} else {
-		dev_dbg(chip->card->dev, "pcxhr_open capture chip%d subs%d\n",
-			    chip->chip_idx, subs->number);
+		dev_dbg(chip->card->dev, "%s capture chip%d subs%d\n",
+			    __func__, chip->chip_idx, subs->number);
 		if (mgr->mono_capture)
 			runtime->hw.channels_max = 1;
 		else
@@ -1012,8 +1011,8 @@ static int pcxhr_open(struct snd_pcm_substream *subs)
 	}
 	if (stream->status != PCXHR_STREAM_STATUS_FREE){
 		/* streams in use */
-		dev_err(chip->card->dev, "pcxhr_open chip%d subs%d in use\n",
-			   chip->chip_idx, subs->number);
+		dev_err(chip->card->dev, "%s chip%d subs%d in use\n",
+			   __func__, chip->chip_idx, subs->number);
 		mutex_unlock(&mgr->setup_mutex);
 		return -EBUSY;
 	}
@@ -1078,7 +1077,7 @@ static int pcxhr_close(struct snd_pcm_substream *subs)
 
 	mutex_lock(&mgr->setup_mutex);
 
-	dev_dbg(chip->card->dev, "pcxhr_close chip%d subs%d\n",
+	dev_dbg(chip->card->dev, "%s chip%d subs%d\n", __func__,
 		    chip->chip_idx, subs->number);
 
 	/* sample rate released */
@@ -1569,7 +1568,7 @@ static int pcxhr_probe(struct pci_dev *pci,
 	/* init setup mutex*/
 	mutex_init(&mgr->setup_mutex);
 
-	mgr->prmh = kmalloc(sizeof(*mgr->prmh) + 
+	mgr->prmh = kmalloc(sizeof(*mgr->prmh) +
 			    sizeof(u32) * (PCXHR_SIZE_MAX_LONG_STATUS -
 					   PCXHR_SIZE_MAX_STATUS),
 			    GFP_KERNEL);
-- 
2.53.0



