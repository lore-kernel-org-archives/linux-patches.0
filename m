Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208531;
	b=Qrak3idv98oJu0y7E0h9nSAMpLZ5XRxM3jWtNMp4fUNogw+2y3B3zyCLgGw/JtittQ2F
	 2IHminZuvWfL4StXO4VWbZwgHKmQkqs2UoWs98ub2TvWkVSPlFsg4R0fDyDVPUickK7LZ
	 91hgVdREZhM/UDLy+Zw49DRQ/RAKARddQ20mwoHpQLaPIsE0Aa//NMTNPeoUQmfa1KXXe
	 HV0u9m6Zk5YR6YATQZKlxrXwf/P3mxEtbp/6hFqXMS7xTIfN/M0HKMOnYhNkAUBYJycx4
	 dQ2p4fBh8emJXLIdI+EpW28U3qpm8Um6SoDZROoWFW/XaLlTxaB6Wjyp38N/yCZI37g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uulRfrBfvgaxfJ5FXltRM8oOuVCTMJHrqvMPXS8enQA=;
	b=5goSGtW8tHcv4qG9o75LMt55HDgtTFnfeeA985wO54RFGyxytE4BwUNHFhQ10N9OIvlJ
	 pYfhZJt9+/5ZC2NER2VsyTS4bgLOrWIVMhdHTOLKdToupXGfu/s9X/2EJE98Tbm8Vtp7o
	 jTo2fUcm+ekzZN8otx/b3B29C6w9nsWinHlxfjmrNl6E6dIkbRFgZ5mQcbJcT9My0QENp
	 wCTkb0glBz7/uJa/gJevM2H6ss4siHExz/FxNlOak/Vx8tt9d9oysHjfjARzO7Ac+5m8o
	 UrDhbuqpx9Vpp3sXS/TkS+x7j17Yszjdfm3uVcAbJ0L9nqGyaCN1eAiEqORw5lLtkTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqpAYMee;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44C1606A31E;
	Wed, 28 Oct 2026 17:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqpAYMee
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323351F01825;
	Wed, 28 Oct 2026 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208530;
	bh=uulRfrBfvgaxfJ5FXltRM8oOuVCTMJHrqvMPXS8enQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqpAYMeeC9bZ3TriUEDfXK+5/CxqSvQaxtY1HBQHaXlfSdgudpor1/TQJ5/TKN8LN
	 LPCJERK3hqZBdKwTXmWhGm+xX1uhHroVxq93JsWctb8bVo6l+XuH9KRGTFXUd6LwfC
	 JyHpTag/KgR5H6DkJgZfLx5FrDiQraV3tG6BDfEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+be8fa7ea6f77fdce@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 153/516] ALSA: line6: reject oversized playback packets
Date: Wed, 28 Oct 2026 17:55:05 +0100
Message-ID: <20261028170007.131319372@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

commit 61b0a5a114fa4552892da5c0ff2f42e63bf08c6b upstream.

Each playback URB is handed a slice of out.buffer that is exactly
LINE6_ISO_PACKETS * max_packet_size_out bytes, sized from the OUT
endpoint, but the number of bytes written into that slice is never
compared against it.

submit_audio_out_urb() takes the frame count from prev_fsize, which
audio_in_callback() derived from the *IN* endpoint's received packet
length, and rescales it with the playback frame size; when prev_fsize is
still zero it synthesizes a length from the sample rate instead.  On a
device declaring a large IN wMaxPacketSize and a small OUT
wMaxPacketSize, the resulting memcpy(), or the memset() when the
playback stream is idle, runs past its slice and, as the reproducer
below shows, beyond the allocation.

usb_submit_urb() is not a backstop.  max_packet_size_out comes from
usb_maxpacket(), which returns only the low 11 bits of wMaxPacketSize,
while USB core validates a high-speed isochronous length against that
base scaled by usb_endpoint_maxp_mult().  A length of up to three times
the allocated slice is therefore accepted, and even a rejected URB is
only rejected after the write.

Reject a packet that does not fit the slice the driver allocated for it.
Clamping it instead would silently shorten the capture-derived rate
feedback and desynchronize the two streams.

  BUG: KASAN: slab-out-of-bounds in submit_audio_out_urb (sound/usb/line6/playback.c:229)
  Write of size 1024 at addr ffff888100bbd400 by task kworker/1:2/5002
  Workqueue: events line6_startup_work
  Call Trace:
   __asan_memcpy (mm/kasan/shadow.c:106)
   submit_audio_out_urb (sound/usb/line6/playback.c:229)
   line6_submit_audio_out_all_urbs (sound/usb/line6/playback.c:291)
   line6_stream_start (sound/usb/line6/pcm.c:194)
   line6_pcm_acquire (sound/usb/line6/pcm.c:337)
   line6_startup_work (sound/usb/line6/driver.c:728)
   process_one_work (kernel/workqueue.c:3396)
   worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

  The buggy address belongs to the object at ffff888100bbd400
   which belongs to the cache kmalloc-256 of size 256
  The buggy address is located 0 bytes inside of
   allocated 256-byte region [ffff888100bbd400, ffff888100bbd500)

Cc: stable@vger.kernel.org
Fixes: 7a0f55aeeb8f ("ALSA: line6: Support assymetrical in/out configurations")
Reported-by: <co+be8fa7ea6f77fdce@bugs.sh>
Assisted-by: LLM
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260918234014.1318325-1-xmei5@asu.edu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/playback.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/usb/line6/playback.c
+++ b/sound/usb/line6/playback.c
@@ -182,6 +182,13 @@ static int submit_audio_out_urb(struct s
 
 		fsize *= bytes_per_frame;
 
+		if (fsize > line6pcm->max_packet_size_out) {
+			dev_err(line6pcm->line6->ifcdev,
+				"playback packet too large: %d > %d\n",
+				fsize, line6pcm->max_packet_size_out);
+			return -EMSGSIZE;
+		}
+
 		fout->offset = urb_size;
 		fout->length = fsize;
 		urb_size += fsize;


