Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038196;
	b=favbhoaIwV6s1f1KVIaPrDMJJVBXcaDDSk1HXjpuQF4/oaKCvrudHPOZwr1ll/C9Tp8U
	 cwPHYoDzjL4Lnzzgr5Fdm7qIDYc4L6V3RXYs+R9tDEs1AvGoY0VUcCG/c9M4C+MvGwVlw
	 pgTCsh+a/21ZVTZu0eOIugMrN2XkrbGheNRU8pm/QRxCnu4erJdFuysaDI5mxL4CnSIY5
	 IUVpYTCUxMuVM11ovvb0sW2QFtP2p+wkRceLwEcSv8pWLf1BrEC5FVI+CPwpRMSMlFQrd
	 J4R5hF8iySxUP2wVXZylZ+npUnOwrOyOTCpI2/bkQVq5FzXAN9oSiSqgH4CZEFIkomw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UDYrwHFCykR6jC9QApnnqK//AqZztnwQblpCYve1P3U=;
	b=sqJjX3HbWhmWiwc7/Ne7cxj+kUt2jMyKb1AZ49DRx5ORse3oQYCP6D+k5qaC/vg7zZRj
	 7t5nYR7nAW/kl+O6LE7C90AYQZShtBrdKTbEPoNy0kk7F5YdkmnY2SjDpZJ9kYEnKPxzN
	 UFqhf15Xm6CJ7d8fIy4IrDfi7FgkHo8vO45J1ATzHxCnyN5ZXcmuRYHskgqPYCpPdROHC
	 3WwxF1QfGs5qgry8HejqTNKo+q+QUDoCRCFa8nGqEnMxSslq1CvrVGIvJgPb5AbHyDzbQ
	 PEklB/4F/KfUD/XJ/XfOQ7N0ayZD8ol6Hiy+RxDX5rKcdfekVfBGWeZbBc7W5exUK9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqjFz1xO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCBD606A31C;
	Wed, 18 Nov 2026 21:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqjFz1xO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733C21F000C4;
	Wed, 18 Nov 2026 21:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038196;
	bh=UDYrwHFCykR6jC9QApnnqK//AqZztnwQblpCYve1P3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqjFz1xOBh2U5vNX7cyWIX/YEtjP1ihqfKIj7Tb18AmIWgTRZlyzrfW8TZ1E1gKjJ
	 q3NALEyPsyxoV2vEDsPJm/laltiRw1YRTQcnqsXcoPlBOsr9bMCEP1NhEipUPqquEd
	 qCG8IyuUzCxgzWhsgB57hnkSHz6UmefwlkOaNjeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Turunc <enscrpt@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1660/3318] ALSA: usb-audio: Bound packet copies by the PCM buffer size
Date: Wed, 18 Nov 2026 15:38:02 +0100
Message-ID: <20261118150411.575103145@linuxfoundation.org>
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
[ sashal: adjusted indentation to match the less-nested packet loop in prepare_playback_urb() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 5aadd1221f725..dd7554cde865d 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1292,6 +1292,18 @@ static void retire_capture_urb(struct snd_usb_substream *subs,
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
@@ -1505,8 +1517,14 @@ static int prepare_playback_urb(struct snd_usb_substream *subs,
 
 	for (i = 0; i < ctx->packets; i++) {
 		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, avail);
+		/*
+		 * Bound by the ring buffer as well as by the URB:
+		 * copy_to_urb() wraps hwptr_done once, so one URB must
+		 * never carry more than the whole buffer.
+		 */
 		if (counts < 0 ||
-		    (frames + counts) * stride > ctx->buffer_size)
+		    (frames + counts) * stride > ctx->buffer_size ||
+		    (frames + counts) * stride > subs->buffer_bytes)
 			break;
 		/* set up descriptor */
 		urb->iso_frame_desc[i].offset = frames * stride;
-- 
2.53.0



