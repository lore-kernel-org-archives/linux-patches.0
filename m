Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059567;
	b=rabT32GN2Spi8CUiDNw1+u9HE/3vJh1SfNw4sNqyRyJoTWrgstF0Anuad/9gr2LAXe+H
	 YNjSF/LH5sEIH6Mbqldh9YbfsmBFFM7iod/Ti60VOt8P9uEDchBu4vUbBvIAdwBMtFw5H
	 e1gmLxQpMGaUxlSmO7bCnrZrUu8gQm1nRBqAZt3l0VkYE4Zv14tRNJq6e0zx0LNHlpleD
	 p84lNOJg2TiOoAHpNxvRW670/bUQZJ0H2gPMImK/2OCt3Pm5Gt/tasAy4yeKul6HyByh4
	 ltEJfEAK6MuEtur3odLs5fM5qTYK+AD+OvScIBZTiFWTMb6T8R5LEhzjf9Jcc9G5Kxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7gPdKmNNso4sfjUyUyDMh2fiNJT4+IlluuWFvamrzE0=;
	b=l5lbhPWQztXxhGnckk5wiCkRNTEr7mBHxLt3aBEjelERCdRe77GAnNOoP35EFBZc7+j1
	 B3mAX5Q01h494MQYulznY5Qy3ldyPDvqeqrUIdIimZbe03z5atfns+dpC7L5pm0aCCMzp
	 2mSSUEHakdnKSSlcAP9+6YnJmzrH4Wj+w8SZiM1IJE68Q1tzYJfeC5Gnk0rb1Gql6Jtnj
	 pinV9V/tm6Ty2CJQsf6JP8dwKvSE8pnDDDZSxjFXFKN+JxvkH0TIFW++duMIwS2NAve/J
	 VDtlQMPsZ2ZAG8kG6py1LYxqY9+3sAX1SA9xB+bo4ekkhWKtJsRkq+gWbwzAqOWMDnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kh86RYqZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3852606A32A;
	Thu, 19 Nov 2026 03:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kh86RYqZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043801F000C4;
	Thu, 19 Nov 2026 03:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059567;
	bh=7gPdKmNNso4sfjUyUyDMh2fiNJT4+IlluuWFvamrzE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kh86RYqZlZH+PKuRO706hZsd+5QpuK3sbUmgcct5EzNnlmYvKYYAUHIfxfpyB9+0J
	 VSwCAfE4HQNlz5/9m8Cvbf5IJySAlPD0gnNao3SuAVfEc14cpUoortUcfyBdScMnhM
	 ieqKnkuk3dZMEYT5IbEz8qG1MqjO1CCLKN3AUuLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Turunc <enscrpt@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0847/1848] ALSA: usb-audio: Bound packet copies by the PCM buffer size
Date: Wed, 18 Nov 2026 15:48:05 +0100
Message-ID: <20261118145952.053651716@linuxfoundation.org>
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
[ sashal: replaced missing subs->buffer_bytes with runtime->buffer_size * stride ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 802ed1dbd23b0..82cfa3f75d530 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1438,6 +1438,18 @@ static void retire_capture_urb(struct snd_usb_substream *subs,
 			bytes -= adj;
 			subs->stream_offset_adj -= adj;
 		}
+		/*
+		 * A packet can be as large as the endpoint's maxpacksize, which
+		 * the device chooses, while the ring buffer can be as small as
+		 * two 64-byte periods. The hwptr_done wrap below handles one
+		 * wrap only, so never take more than one buffer from a packet.
+		 */
+		if (unlikely(bytes > runtime->buffer_size * stride)) {
+			dev_warn_ratelimited(&subs->dev->dev,
+					     "%u-byte packet exceeds %lu-byte buffer, truncating\n",
+					     bytes, runtime->buffer_size * stride);
+			bytes = runtime->buffer_size * stride;
+		}
 		frames = bytes / stride;
 		if (!subs->txfr_quirk)
 			bytes = frames * stride;
@@ -1614,6 +1626,14 @@ static void prepare_playback_urb(struct snd_usb_substream *subs,
 		else
 			counts = snd_usb_endpoint_next_packet_size(ep);
 
+		/*
+		 * Bound by the ring buffer as well as by the URB:
+		 * copy_to_urb() wraps hwptr_done once, so one URB must
+		 * never carry more than the whole buffer.
+		 */
+		if ((frames + counts) * ep->stride > ctx->buffer_size ||
+		    (frames + counts) * ep->stride > runtime->buffer_size * stride)
+			break;
 		/* set up descriptor */
 		urb->iso_frame_desc[i].offset = frames * ep->stride;
 		urb->iso_frame_desc[i].length = counts * ep->stride;
-- 
2.53.0



