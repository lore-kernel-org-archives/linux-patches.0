Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035113;
	b=31lkpAPokQa5rzKFmzA0Glteoy3sBwz30UUiRIl5iL6qoy/vuVPdJu9VssqZOAnV45YY
	 qnmNH5ApIMC8nqG4eQGVPFF234ofALl7/7diRD/3ipqkrzFa1aA8A0uedzcjRgHnYldPJ
	 A6+WQwBQJ7LuSWB2paM42AQUhxt4shjs6R91kkSbU0nzEaXdmk/7B05NHlZ1ywjMM3dSJ
	 PLtSxRa5uWksLQm0ZwBq14B5L8S4KakN7bdENA+hdgOgdaF2Bw/PAJI9mD2ygA+rXtxUb
	 ez2ZVQTLIgQPgFpzTmAmywHJJTf0MGvCsEkB5tpUq8Pgk3equ9bzXpFqX09PC4Veg/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pqLFDWJFhO5sNhFN78l0N4vO6cHtkoWCxvPm1/MSrrU=;
	b=Cc0pLxFPg8T3Ly59KiQk7zaibaBMDS3UIijVoX2tq8/+1Z4rVkx27Mz60AMNpWrG4byt
	 5FejQFIKGwSJSlXUtUxy53uDeNqmSGkweD0/Dn0iE/EMhmpESUpioyUYJ7z8GGfB+3+Ne
	 XXZy6mbqILJdLuCLZdP8iUuNZW5obPGoxQASl9FWDLzKNHnPxDApBsMeYEUEtF6zszk0s
	 LjJ9Y9Cd6zoNWD9Haq/GucnTTvDo+4cuMt4rzcgEbaVYPYxKK803pdBSpvtovWUWicshC
	 /LQp9JEYxzO9UYpCrKTrAbL84Y+Zj1zNKgOH44Xx5f3K29ZZkVt7o/JLQHTTtg44iZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nV0kzSa5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D77E606A320;
	Wed, 18 Nov 2026 20:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nV0kzSa5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802F01F000C4;
	Wed, 18 Nov 2026 20:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035113;
	bh=pqLFDWJFhO5sNhFN78l0N4vO6cHtkoWCxvPm1/MSrrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nV0kzSa5U9d1yBVbvJBhRm6dr+WV8FEwRd8n3LX0H4Vpa5P1Z9CxK+IK3OPzU1YwK
	 P39Itwd87ntDpnG9QGN5W9K7uNY9FCc/i1iDWPlxssTtfNLevWx34VOt6FtRZW6nWQ
	 1JR70qruIngKmMUBQkk9gGoVIdsfEB6WQOOxeqKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0610/3318] ALSA: pcmtest: handle multiple wraps in random capture fill
Date: Wed, 18 Nov 2026 15:20:32 +0100
Message-ID: <20261118150336.041317572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung Byeongchan <tjdqudcks0424@naver.com>

commit 6541871e8e63e721733cd120af4d9cd22c5ef62f upstream.

The random capture helpers assume that the data generated for one timer
tick wraps the DMA ring at most once. However, b_rw describes 200 ms of
audio because the timer runs at 5 Hz, so it can be several times larger
than a small ring.

For 48 kHz, S16_LE, four-channel capture with a 512-frame buffer, the DMA
ring is 4096 bytes while one tick generates 76800 bytes. After filling the
4096-byte tail, the existing code issues a second 72704-byte write from the
ring base, writing 68608 bytes beyond the ring. Both interleaved and
non-interleaved capture are affected.

KASAN reports the first write into the adjacent free page as a
use-after-free in the random-byte generator. The underlying defect is an
out-of-bounds write from the live DMA ring, not a stale DMA allocation.

Split each random write repeatedly at the interleaved ring or per-channel
block boundary. Keep the hardware-pointer update exactly once after the
complete logical write.

The issue reproduced on three of three clean boots. With this change, the
same vulnerable geometry completed six times without a sanitizer finding.
Boundary, pattern-fill, no-timer, open/close, and module-reload controls
also completed normally.

snd-pcmtest is a test driver, and selecting random fill requires an
administrator-controlled module parameter. The written values come from the
kernel random generator; no privilege escalation or attacker-controlled
write primitive was demonstrated.

Fixes: 315a3d57c64c ("ALSA: Implement the new Virtual PCM Test Driver")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI Codex
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
Link: https://patch.msgid.link/20261003101854.1423146-1-tjdqudcks0424@naver.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/pcmtest.c |   42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -279,39 +279,35 @@ static void fill_block_pattern(struct pc
 		fill_block_pattern_n(v_iter, runtime);
 }
 
+static void fill_random_block(char *buf, size_t buf_size, size_t pos,
+			      size_t count)
+{
+	while (count) {
+		size_t chunk = min(count, buf_size - pos);
+
+		get_random_bytes(buf + pos, chunk);
+		count -= chunk;
+		pos = 0;
+	}
+}
+
 static void fill_block_rand_n(struct pcmtst_buf_iter *v_iter, struct snd_pcm_runtime *runtime)
 {
 	unsigned int channels = runtime->channels;
-	// Remaining space in all channel buffers
-	size_t bytes_remain = runtime->dma_bytes - v_iter->buf_pos;
+	size_t pos = v_iter->buf_pos / channels;
 	unsigned int i;
 
-	for (i = 0; i < channels; i++) {
-		if (v_iter->b_rw <= bytes_remain) {
-			//b_rw - count of bytes must be written for all channels at each timer tick
-			get_random_bytes(runtime->dma_area + buf_pos_n(v_iter, channels, i),
-					 v_iter->b_rw / channels);
-		} else {
-			// Write to the end of buffer and start from the beginning of it
-			get_random_bytes(runtime->dma_area + buf_pos_n(v_iter, channels, i),
-					 bytes_remain / channels);
-			get_random_bytes(runtime->dma_area + v_iter->chan_block * i,
-					 (v_iter->b_rw - bytes_remain) / channels);
-		}
-	}
+	for (i = 0; i < channels; i++)
+		fill_random_block(runtime->dma_area + v_iter->chan_block * i,
+				  v_iter->chan_block, pos,
+				  v_iter->b_rw / channels);
 	inc_buf_pos(v_iter, v_iter->b_rw, runtime->dma_bytes);
 }
 
 static void fill_block_rand_i(struct pcmtst_buf_iter *v_iter, struct snd_pcm_runtime *runtime)
 {
-	size_t in_cur_block = runtime->dma_bytes - v_iter->buf_pos;
-
-	if (v_iter->b_rw <= in_cur_block) {
-		get_random_bytes(&runtime->dma_area[v_iter->buf_pos], v_iter->b_rw);
-	} else {
-		get_random_bytes(&runtime->dma_area[v_iter->buf_pos], in_cur_block);
-		get_random_bytes(runtime->dma_area, v_iter->b_rw - in_cur_block);
-	}
+	fill_random_block(runtime->dma_area, runtime->dma_bytes,
+			  v_iter->buf_pos, v_iter->b_rw);
 	inc_buf_pos(v_iter, v_iter->b_rw, runtime->dma_bytes);
 }
 


