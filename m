Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061637;
	b=F3a9bC9MdXjiSleO7LNVSsH9SK8/PqSWBcqhF2vGrSNgJeXSrneTKTJLSPOVvrahBgJB
	 X5n95GTvu9rQ2+lxxxUx4tswC9IEDa6VuzsZu/KvT/hiJ+wRtkr3wRQZkLLHYfOw3Elg9
	 3SxySDcsGLjZofObN1tskMSQ4xqi71Q0qxFRgQrHhmvc7nFNds1lumnSAHdhAZj6gHSZY
	 ivwEef3ScfQkZYpLQHqQ6qYZU9JD4wV0JJ+ZWCI3Cm0m98Lhw6cB3sf29cnBE4Hs12ghj
	 76/9vuZklyQ3acy1Rnk62IY635BGUxzRBtePUv4rqvmo6+StMK+7X6zJbxvDzK4g1+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Z07+TzrWcva1HGi5SAqxJ2ZGCfUiWYdBew/nWWRk6k=;
	b=BQj1yR4qvfxyeXKWGZs/aWt4mWZ5d0K0Vj3SSCw6VXsb6k1OCFP2AsxIqqNBmZOFdlO9
	 UQdfBjvPipgXSNeXw2bs2qLFt08NwU2Q0VI756o1jOEzCvgGdhUBHmypMSLcamgRCr5wy
	 dB/E3acAyg60oBLtfzj8OA3QAZICvzKdWZiTW0BYD1nggIlUFjjghDSO1v7vKqNzlWO8r
	 HN6ecJEl3231aZ6EOT8c5wUEAMFHs3R1ONhZUaIU0+mGBAcCC9tPT92qI8HCDxmP+DQG1
	 ezPVlibpefE7CUXFPyQl/s7zZgfqS2ADCIDvxdxyIpvFLssRwtHtjNzLOcIU92i+goQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2pVCDhsX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720C2606A330;
	Thu, 19 Nov 2026 04:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2pVCDhsX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C561F000C5;
	Thu, 19 Nov 2026 04:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061637;
	bh=3Z07+TzrWcva1HGi5SAqxJ2ZGCfUiWYdBew/nWWRk6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2pVCDhsXxr/4N6gJUKIz+2gZVWIfKflHfsV1bTMB0UsslcXiH6+JBVIM9PtIj1O6s
	 hc8d4O3Q3E/JQo5tLzcbq9yhJH0xES/YjsMHwWweTsXllqlXtAQeRKH4Vmz8I/YBRI
	 7GLRDtyiUs9mWlp8dSxaUIvHDHT0jqdTVi5aH354=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1624/1848] ALSA: line6: Use kzalloc() for PCM buffer allocation
Date: Wed, 18 Nov 2026 16:01:02 +0100
Message-ID: <20261118150027.550713543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9ec633573c1d162bfc82cae52d14c220c875612f ]

LINE6 driver allocates the PCM buffer via kmalloc(), and this might
leave some bytes uninitialized that are out of the actual ring buffer
size, while it's still exposed via mmap.

For avoiding the leak of the uninitialized kernel memory, simply
replace it with kzalloc().

Fixes: 705ececd1c60 ("Staging: add line6 usb driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261013120528.52586-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
index 59b7c6beef6c5..5c940eb54e02a 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -155,7 +155,7 @@ static int line6_buffer_acquire(struct snd_line6_pcm *line6pcm,
 	/* Invoked multiple times in a row so allocate once only */
 	if (!test_and_set_bit(type, &pstr->opened) && !pstr->buffer) {
 		pstr->buffer =
-			kmalloc(array3_size(line6pcm->line6->iso_buffers,
+			kzalloc(array3_size(line6pcm->line6->iso_buffers,
 					    LINE6_ISO_PACKETS, pkt_size),
 				GFP_KERNEL);
 		if (!pstr->buffer)
-- 
2.53.0



