Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063693;
	b=UdnOjSbADolwthfWCqvfGLLjot9GJeFUgYIlFBh8whKzx0uvKTIttKnD64FVubjJKEZq
	 GBjVTAouv4eugkBmMaF5w4uoUsAiTyBTxBlKG4vmGxEv8CV13rhb12j2D5S4sK9qsQCno
	 YbHC82hCnO9I1NNe7ZsaosyHmBsFC6qFJRexWFvSF9c88ACApWldu1Vm+sAySp0VNdQpy
	 w7hgs7z9Kq/ITt5e5z3SzKfu5azlkBDDfj3WxD1AYgJ5ibMSixjTUbLNei9kVvb7v1+/O
	 smj0HYXA9tMZ7Z3g/fXoqZIg1PY1wSCnMw4OAKCyBf9D1Z6BsvCraOC6sm3zyJS5ylA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uygsieeDqlun48Uc+ooUPg6HC4Zg/z0H/M/Sr9vGAo8=;
	b=j4EtKQmYVeC+yVJ750YgL2AISAO6HzZsmqoAkBXsosvyIVJD4eGVyonEJfNAjHb3PuiG
	 EPkKGw+E4hGyBR4r/9OEtJLICFOwXrpdoONyALfJx4ExUluQ7Q9yHwQ5r+r8W72ht+s0d
	 pt3/NTHMrrkvxlArdeLAlhHvFppEZe1dWyk53FTgIzdjjqac+ToyQOTn1qIj2gSaAHYGl
	 hBe0yo4RINMi41WZ5i/eie+++wKSZlAD7B5y6V0RZPUg/0XLHvxElZQyHfUoZwsw+gCmT
	 DIBcz7wMVjicFCw66+pPp02YQ6RhuLDIL0ZbmgAnMOPNhBnLlTm7x43Frba/LOrTXCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJGbav4C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ABB606A32C;
	Sat,  7 Nov 2026 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJGbav4C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716561F0089F;
	Sat,  7 Nov 2026 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063692;
	bh=uygsieeDqlun48Uc+ooUPg6HC4Zg/z0H/M/Sr9vGAo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJGbav4CjCTDjMlsXbK9gzGULzMjl+AX+pVfxGlWwuuWmrkqN6OeZMKLSef9TG5WY
	 0YWoPxPMQNwlBcK0ko49Ruza7d4jQ844W6gj/x9svkLA06fWvU1T8EeRXCBO9sBsW/
	 iZJeqS6uGILtG1p7i2YZbnCisxybSlfP2a8Mj+7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Turunc <enscrpt@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 798/869] ALSA: usb-audio: Bound packet copies by the PCM buffer size
Date: Sat,  7 Nov 2026 08:58:00 -0500
Message-ID: <20261107134919.894925027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Sinan Turunc <enscrpt@pm.me>

[ Upstream commit 06be918062adc1a5a76dc346803b136b20bdb5ae ]

retire_capture_urb() and prepare_playback_urb() assume that one USB
packet never carries more data than the whole ALSA ring buffer. Nothing
enforces that: the packet size comes from the device (wMaxPacketSize,
and curpacksize == maxpacksize when the class-specific endpoint
descriptor sets MaxPacketsOnly), while the PCM hardware constraints only
require 64-byte periods, two periods and a period time of one data
interval. An 8 kHz mono U8 stream on a 128-byte buffer is legal, and a
full-speed device can send 1023-byte packets into it.

On the first oversized packet hwptr_done is wrapped once and stays
beyond buffer_bytes (895 for 1023 bytes into 128). On the next packet
the wrap arithmetic in the copy path computes

    bytes1 = subs->buffer_bytes - oldptr

with oldptr > buffer_bytes, so bytes1 wraps to about 4 GB and memcpy()
runs off the end of the URB buffer and of the vmalloc'd DMA buffer:

  BUG: KASAN: slab-out-of-bounds in retire_capture_urb+0x251/0x870
  Read of size 4294966529 at addr ffff88800c1e2800 by task vhci_rx/82

and for playback, where copy_to_urb() has the same shape:

  BUG: KASAN: vmalloc-out-of-bounds in copy_to_urb.isra.0+0x188/0x430
  Read of size 4294966529 at addr ffffc9000004537f by task vhci_rx/79
   prepare_playback_urb+0x98a/0x1fc0

Truncate an oversized capture packet to the buffer size, and stop
filling a playback URB once it holds a whole buffer. With bytes <=
buffer_bytes the single wrap of hwptr_done and the two-part memcpy()
in both copy paths stay inside the buffer. A device whose packets do
not fit the buffer at all was never going to play correctly anyway.

Reproduced on 7.3-rc7 with a USB/IP device (dummy_hcd cannot carry
isochronous data) advertising a UAC1 endpoint with MaxPacketsOnly and
wMaxPacketSize 1023, and a PCM client using period_size 64, periods 2.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Sinan Turunc <enscrpt@pm.me>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261026223543.620-2-enscrpt@pm.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 682b6c1fe76ba..c2f7b08607ac8 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1343,6 +1343,18 @@ static void retire_capture_urb(struct snd_usb_substream *subs,
 			bytes -= adj;
 			subs->stream_offset_adj -= adj;
 		}
+		/*
+		 * A packet can be as large as the endpoint's maxpacksize, which
+		 * the device chooses, while the ring buffer can be as small as
+		 * two 64-byte periods. The hwptr_done wrap below handles one
+		 * wrap only, so never take more than one buffer from a packet.
+		 */
+		if (unlikely(bytes > subs->buffer_bytes)) {
+			dev_warn_ratelimited(&subs->dev->dev,
+					     "%u-byte packet exceeds %u-byte buffer, truncating\n",
+					     bytes, subs->buffer_bytes);
+			bytes = subs->buffer_bytes;
+		}
 		frames = bytes / stride;
 		if (!subs->txfr_quirk)
 			bytes = frames * stride;
@@ -1553,8 +1565,14 @@ static int prepare_playback_urb(struct snd_usb_substream *subs,
 
 		for (i = 0; i < ctx->packets; i++) {
 			counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, avail);
+			/*
+			 * Bound by the ring buffer as well as by the URB:
+			 * copy_to_urb() wraps hwptr_done once, so one URB must
+			 * never carry more than the whole buffer.
+			 */
 			if (counts < 0 ||
-			    (frames + counts) * stride > ctx->buffer_size)
+			    (frames + counts) * stride > ctx->buffer_size ||
+			    (frames + counts) * stride > subs->buffer_bytes)
 				break;
 			/* set up descriptor */
 			urb->iso_frame_desc[i].offset = frames * stride;
-- 
2.53.0



