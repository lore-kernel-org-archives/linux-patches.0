Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026565;
	b=jk8YA51fE1uaMUm1OCormePTq/OQGFQbpRu9Zc4rhPYmp7pjQOjDX8e8+vU2pEL0Bq1q
	 m54B5l7Lqc4YhnNgFWobmJvkSWXY+vOWAgy+IyHqCOw4SWWQayrr+fazeRpdE6X1ZTUWR
	 zs4POG9B+ZnNF1zUDbwFMtrzBQNACqP7QnG0rI0LiAwSHZqIe6huO4iN01Fow0hViHCzq
	 2zoArgHwm+3ByJZFSFq6RvtQabsoitgfWfnCgQ6zYYz7yoYd2mzDlNQa1RCiCfzUP5lBC
	 aYCwueXtmwlsHDGJRsGm+P9hoMj9jNCW+PeeZJhiN/mJjm1r8rguf1gkZqk6SB6aBzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wc53iwX0Zzjl1nOpKwwQDOSl/SO1ohJ/4DWXqX1kMgk=;
	b=WlbCDt2ko1MyjsYNGwnTA4l4oiLBCrhjxALAa9Sbx57C/rDy0/tqJCjEwPZNGL+VQtdj
	 NuZlYmu3r80Lq6dojxMXjQ0H6TO9xcSEmOgC6D3bp++jCHVLI2tZrbaiMgjpuaIoBrebH
	 jpIagnceg5IOlHCdvBbDGjyn0O/j7bJN6+Fs3fSiGbqoifJbvthzbVf+paCS13Y5YH9Uz
	 dvBBUebCn6lHDeGyg+BBdhLtw0TWkG9kuz2DZPIl0cbho0m2FSa6GTC6dyimdqm5dYsNC
	 x3uQYb0pd6qVZK7ZAinQ/2Tywtb+VvMupVqzNOo84TOGtvu68QmzHrvZSvuW4w2eQ3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=svFun8wT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED10606A31C;
	Wed, 18 Nov 2026 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=svFun8wT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D911F000C4;
	Wed, 18 Nov 2026 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026565;
	bh=Wc53iwX0Zzjl1nOpKwwQDOSl/SO1ohJ/4DWXqX1kMgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svFun8wTBJNKctRhCAGqp6lleHm5VE3kAjOJJqYZyqyPy8zxSyssGMHzXKJiKzVqr
	 +q9oJ3rUd7pZ3iADGaLa1yK8URSPrz+zy1waeHpOkN6ZpDyv/yZe8HXa8DxWQNsqfJ
	 sKLdkDsq7ZJEp2ZQAIuOdWiDwpvMIHWDY5hIdO1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1482/2151] ALSA: line6: Use kzalloc() for PCM buffer allocation
Date: Wed, 18 Nov 2026 15:53:37 +0100
Message-ID: <20261118150215.873648650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index f46e20ba58435..1f58eafa75fda 100644
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



