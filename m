Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031256;
	b=wTcCcCiQhc++Py48t5oa4YasyeJM3+geST3Hy/Gs2S+JwM1JTpbRwwH6d5SxBaQIth1O
	 qN1d86uPXMOI7jtYyYE2yklc1rCf0rWC9WuasSUwTIFgqjnkAhQLOlSLmWO0YInSJnf7+
	 uL26ry91g+FGiLfu+TpCWxUIUtSBF3oP+8m9IlCTbfxe0Ft/UfrN2niNWbvHyF6vlpqgX
	 ZQgsOji6Dm8DS6oX7SCpbpY69HEzuHuFaHxP4jOoZMzHt1KwKgXvB4j/RKInq13Tq7Hb4
	 GxtAY5lkawBhsHt0yMpKcfKatAop+oQQOxA7ZjFRmDfPPTpcuXGt0VX7uNgBu9B8+iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2qzel9p3EChm5ZnBTU4Mb41Rc5ZZ0W0GW0eQnSP7BkY=;
	b=5DuGYxH3zeQDR0RDh4s8V9wOnHoj+vOkpmEoR6gphhR9Ni6IWD8cJqpRlEA8CdT0hP+L
	 m/S2xY5/f8ScOvPhN9Kb/y054B3FNtvNs/NU48A8wV4mf++uvHPExTIWlYpXmQVmeL6aU
	 6fz5OJR7Fbw0SHUvLHytuXfgdKazv4GLqWFsaCjjB6d6y9bG0Hwt2kBrvKIWjFT0i4Dya
	 lLX5fu57RsiqDJ/s7swZdh0QrDSOHJbG8RTLua4Lm2m6Fpd0PmzEqp/vA/mKY9jKaj/Ni
	 LKtrt39r6AIZEcapqEZln9+Hh1w6k89FywcE6ptkxuMMUeWcKIblSCctZJ6J6ZTRHiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKNpkiAp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8327606A31C;
	Wed, 18 Nov 2026 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKNpkiAp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED301F000C4;
	Wed, 18 Nov 2026 19:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031256;
	bh=2qzel9p3EChm5ZnBTU4Mb41Rc5ZZ0W0GW0eQnSP7BkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKNpkiApoP65wjKlNcLCzwztru8x5u/qLQHXJsjyQij01RFaUsS2K22a1Dey6AMJl
	 JUt5eNnKr0RVqA0hW92Hd/T9btkBvA97MGMGQoZ3ysF96z4KsMnHetT6ua6yDD4xzG
	 LrwrAshWdqgDvMd7TQGYD/JhxPjlwGpbeHlbc5yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0994/1756] ALSA: pcmtest: Fix a bogus pointer read in snd_pcmtst_pcm_pointer()
Date: Wed, 18 Nov 2026 15:52:01 +0100
Message-ID: <20261118150049.751606620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 905a07c711baf184d01aebd3cf9028a89bcd8b7f ]

Sashiko reported a potential bogus value for a pcmtest driver when a
concurrent call to PCM pointer is invoked while the pcmtest's timer
callback is running: since the position is updated in the timer
callback without locking, the following wrapping in inc_buf_pos()
might be screwed up:
	if (v_iter->buf_pos >= bytes)
		v_iter->buf_pos %= bytes;
Although it was reported as an OOB, the actual return is corrected
inside buffer_size, so no corruption is expected in this scenario, but
an error message could show a bogus value.

Also, the whole state is read and modified locklessly in the timer
callback, which can be racy against the pause operation, too.

For avoiding those races, simply put the PCM stream lock in the timer
callback (while the snd_pcm_period_elapsed() must be changed to its
*_under_stream_lock() variant for avoiding the deadlock).

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 315a3d57c64c ("ALSA: Implement the new Virtual PCM Test Driver")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172051.13240-7-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index acdafeb43858c..4a53dd84b19af 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -344,6 +344,7 @@ static void timer_timeout(struct timer_list *data)
 	v_iter = from_timer(v_iter, data, timer_instance);
 	substream = v_iter->substream;
 
+	guard(pcm_stream_lock_irqsave)(substream);
 	if (v_iter->suspend)
 		return;
 
@@ -357,7 +358,7 @@ static void timer_timeout(struct timer_list *data)
 	v_iter->period_pos += v_iter->b_rw;
 	if (v_iter->period_pos >= v_iter->period_bytes) {
 		v_iter->period_pos %= v_iter->period_bytes;
-		snd_pcm_period_elapsed(substream);
+		snd_pcm_period_elapsed_under_stream_lock(substream);
 	}
 
 	if (!v_iter->suspend)
-- 
2.53.0



