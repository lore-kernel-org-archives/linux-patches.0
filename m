Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034940;
	b=Go9N5PyG4FG2wIwCzx2TIhTrrgg2aUrWaay0eV/we+y47KkdgmSmuqTi+IPJRnbEONIp
	 8QkKwrF0X4qAB88D17Kg516Gfsc3i3il/Ova/qJnesVQSCF3VWWtmVgJv+CuomivMzqgG
	 2GZspXPSnTaLRLKsTeplX0z9iGQtSRU/1wit5oERqtw+iL7vKJWHm2W/Rh5l+5VDqenfY
	 6LwHPJ6Nj9aWfu6ZumAzhthS6JKhI1TPEmCeiMoZiap6xhXYItcIpzVxc3smkvoYhd1SW
	 iZM61xv6L2ePt7UmDCDPBs8TwNvgVuxunwin916p8Vu7fGTO/Q3EavHVSL8vY5G4K+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qfMknR1jjuCLS+EsZpo1iE4nYrMn6880GTJzdJ3Uijo=;
	b=GOL2SSD7VzJxRbwuNj/31lm2UqJj4LjhJCrt0Q0+8DRaEWGGfVmOWa06Om9ZGhQJX1Cr
	 dN30zBPDvb3gwaFHO62L/cCMb2Yx4dk4CClPMfa1iOT3y6ay/pfaiG6C3tLVwhF15Ro3j
	 z+Tl5qznmSauI1ZXvJQ7uxo7iqR1sehkE2uChZQR8Mi03+t43TJVJ7+RPdjiROFWxN6pd
	 5S3dIcSo5XruKJUHoY/r7XtNWzdG17xnFWdSrnorLzRHOnnEmdqdqx7aku4+rK9XJzD+t
	 ZyS7RP3nyuJUH1isoK7I3q4RMBtb2KQeSDROK3/pWg3ImubzRu9aysFSdige98oFIWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcgWre1i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070BC606A31C;
	Wed, 18 Nov 2026 20:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcgWre1i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5295C1F000C4;
	Wed, 18 Nov 2026 20:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034939;
	bh=qfMknR1jjuCLS+EsZpo1iE4nYrMn6880GTJzdJ3Uijo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JcgWre1iVko3Brnqj1PDI523akvNmNaEan1doJyLjDbIQ5RTrktbwTogH/g9JuDbK
	 9OlPRVxHbhkbYyE4j2NbmYdaW05g4vBoBoU6t5O3dKeQ9crZO843wBVAHJYS/vcpYo
	 qp9gKb/3ylhx2yvPNwgal5y6MheWR062Gf5IGok4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+351f8764833934c68836@syzkaller.appspotmail.com,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0549/3318] ALSA: rawmidi: Fix kvfree() call in spinlock
Date: Wed, 18 Nov 2026 15:19:31 +0100
Message-ID: <20261118150333.772985800@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 20c0c49720dc4e205d4c1d64add56a5043c5ec5f ]

At the conversion of locking with guard(), I overlooked that kvfree()
must not be called inside the spinlock unlike kfree(), and this was
caught by syzkaller now.

This patch reverts the conversion partially for restoring the kvfree()
call outside the spinlock.  It's not trivial to use guard() in this
context, unfortunately.

Fixes: 84bb065b316e ("ALSA: rawmidi: Use guard() for locking")
Reported-by: syzbot+351f8764833934c68836@syzkaller.appspotmail.com
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Closes: https://lore.kernel.org/6744737b.050a0220.1cc393.007e.GAE@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241125142041.16578-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/rawmidi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 7da8ce4c1ef09..96e7c1e5c1d53 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -727,8 +727,9 @@ static int resize_runtime_buffer(struct snd_rawmidi_substream *substream,
 		newbuf = kvzalloc(params->buffer_size, GFP_KERNEL);
 		if (!newbuf)
 			return -ENOMEM;
-		guard(spinlock_irq)(&substream->lock);
+		spin_lock_irq(&substream->lock);
 		if (runtime->buffer_ref) {
+			spin_unlock_irq(&substream->lock);
 			kvfree(newbuf);
 			return -EBUSY;
 		}
@@ -736,6 +737,7 @@ static int resize_runtime_buffer(struct snd_rawmidi_substream *substream,
 		runtime->buffer = newbuf;
 		runtime->buffer_size = params->buffer_size;
 		__reset_runtime_ptrs(runtime, is_input);
+		spin_unlock_irq(&substream->lock);
 		kvfree(oldbuf);
 	}
 	runtime->avail_min = params->avail_min;
-- 
2.53.0



