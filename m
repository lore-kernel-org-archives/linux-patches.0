Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214646;
	b=gqP9BD3OZxc4plnUoQLW2LemdJ485TTNRGYXu2mBMbrO7zr/ChNQ73F0bEtqzT98BrO9
	 j4h4NlTvTAYTOH2nNfWTAqgj+kEV0Q3gtKu5tQimDNE8G3csCFMT1KZYhY0NFbknaFYO3
	 BhCSVn0wEmkVuE+HxANOoknLBnm2aeBCJa+Cqb4z4Oc+0ko/v5cBenjnzzV1koGLruW+c
	 NYjrj0Ncj1lipyWEMFzDdpEDiXJ407nYlhHrCUdzEOaINj/Eaaqy6lTIgxvgci6l1aFwN
	 kdx3Qam+CJN5gMo9guUxErb2KVZxuEKhE726i7XHxx1I9IWUFsE+SkXaI0SxwT2H+Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8dGpKRHePYHvJjg0RHT1u5fnkVugZD3JeXFsNV8ZEnU=;
	b=JzkQSRAmV6pXvkC0VI9CdHwEqOFhgH2CKMz+/3630+LIr231h4JgXXtvyu2NXtaOnVu8
	 qIZLCQkl0OfHjeu5t/I6uz+ISCHQTBSWlJaFl+RlJct1+kMtp1vwDz8rnaHLz9rb4T9MS
	 +u2XK++h6Lt6u4IqVGlm+GxIuDsUbooTDJVz6u0K/HoTJ8u/J4dZDD1T0ZRGtNgNqztzN
	 oeZ64kOCssXtHqjZ3rxBQTUXGcTAQ/LFbZpKSlw4KDulTazGp8eVB8RWXHYcKsR3LPCiJ
	 gvblXwTn4/MTc4Z+Goa/LUFQOuvNDMFpFbP4sbXD1eT5N0e6a9gmZVxukscFx7jKHuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmc0amVn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904AC606AB19;
	Wed, 28 Oct 2026 19:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmc0amVn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21B61F01825;
	Wed, 28 Oct 2026 19:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214646;
	bh=8dGpKRHePYHvJjg0RHT1u5fnkVugZD3JeXFsNV8ZEnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmc0amVn2DUvvKrdlVR13Qc99zQU8HhyNXuU4OX12HcoX7157wxYwADQf+rQfymyi
	 lF/Tj8rxkhX2tTdSolSZ3hSsntTN3inX3rrHUd8Dz6mYW7bl2P9Y+RY6w1o5nHTKQj
	 pe37nfUUVom7QjroSUgG64DuvmMGus9iL/KGejkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0931/1887] ALSA: usb-audio: Prevent excessive number of frames
Date: Wed, 28 Oct 2026 17:50:27 +0100
Message-ID: <20261028170520.599610449@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit ef5749ef8b307bf8717945701b1b79d036af0a15 ]

In this case, the user constructed the parameters with maxpacksize 40
for rate 22050 / pps 1000, and packsize[0] 22 packsize[1] 23. The buffer
size for each data URB is maxpacksize * packets, which in this example
is 40 * 6 = 240; When the user performs a write operation to send audio
data into the ALSA PCM playback stream, the calculated number of frames
is packsize[0] * packets = 264, which exceeds the allocated URB buffer
size, triggering the out-of-bounds (OOB) issue reported by syzbot [1].

Added a check for the number of single data URB frames when calculating
the number of frames to prevent [1].

[1]
BUG: KASAN: slab-out-of-bounds in copy_to_urb+0x261/0x460 sound/usb/pcm.c:1487
Write of size 264 at addr ffff88804337e800 by task syz.0.17/5506
Call Trace:
 copy_to_urb+0x261/0x460 sound/usb/pcm.c:1487
 prepare_playback_urb+0x953/0x13d0 sound/usb/pcm.c:1611
 prepare_outbound_urb+0x377/0xc50 sound/usb/endpoint.c:333

Reported-by: syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6db0415d6d5c635f72cb
Tested-by: syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://patch.msgid.link/tencent_9AECE6CD2C7A826D902D696C289724E8120A@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index f2c798c4506b0..17e539b1fdb4c 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1461,7 +1461,8 @@ static int prepare_playback_urb(struct snd_usb_substream *subs,
 
 	for (i = 0; i < ctx->packets; i++) {
 		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, avail);
-		if (counts < 0)
+		if (counts < 0 ||
+		    (frames + counts) * stride > ctx->buffer_size)
 			break;
 		/* set up descriptor */
 		urb->iso_frame_desc[i].offset = frames * stride;
-- 
2.53.0



