Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625556;
	b=OjzvdcgRTijGHyNx+QJTkNe97xjK4FjNSBE0/4PXTgY0D1j7O97F0eY4XtNP+BfFAbs1
	 +r67ptx/RTlwf2GFCIKXHgJx0lROXvOXK7BDsEKVmggDliQcnsMPEzAp/iLVHmZ7cqWzo
	 hF4G4pbVfxv/NcgH+4bs1EKg13cKuHPb3BIK0cO5ZRNqNhI3SPn3B65jilFGB+KLLpMIK
	 1y7iOynF7/pJJk6pRkdZGI1lRzBpacdscRaA0oJznBDNJyWy/XrQYHhI7Q20+L2522aBj
	 OTNfaAiNTPZOeKfmHRBKpVkEKu/BEPE4uSrX1PpDrKbSeQ+bDGQdz144ZDPaIA7U8bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CturaBGzSYSPrO7pSf0eG4zY+k7iEVZfSVtojAA86/o=;
	b=dDLlD0rfRFAAYj95Xs+x4HWnnq+NHezPBaCVdmb2QAJCbkXQJa6ilL3QBlzVIswpJta7
	 WbH+QKquNiAb+Qw47IzzwmUW2yCNxfLQj9BjVcf/g7g/tTWD7sOsf0Vr6dpLx3qGwGTWM
	 miOitUFnGtMD3k60l7dIdXYUqySNjYBXji9JDnsuyZSi+uwS5R6mXyk3lK1VrHvNDq+rF
	 NPXM9P+bsP32vCKn11jnMGIpBZtP8QBQbv8jOVyiajpVB+sfTkvxjaUJiwhYgt/G7q9ni
	 R1d0ZUavyOp/+fLyF6o8Qx8eR7PjOORFo/0/aYeOtzSiLqZJn6ZYs7FkyuHId+w2CYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b7x/SF+o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971F1606A321;
	Wed, 25 Nov 2026 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7x/SF+o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD831F000C0;
	Wed, 25 Nov 2026 16:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625556;
	bh=CturaBGzSYSPrO7pSf0eG4zY+k7iEVZfSVtojAA86/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7x/SF+ow4bES+mGEPPBh5IYl6+mdyrcPJAIJILE07Mq89k3K3wmRWLwjPED3gO1C
	 nTRvursy6EtG0awxWxGUqni90MOe+gfkL6RKDBoN9GG8N5cjE07hptsVEw2kCcyJLN
	 i3eZiWnVhXQPeG9LcM9bLx/a7RHqd9Ewtirr6woI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gichoon Han <gichoon.han@samsung.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 554/816] ALSA: usb-audio: Drop capture packets with bogus actual_length
Date: Wed, 25 Nov 2026 15:35:02 +0100
Message-ID: <20261125143902.006164436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Gichoon Han <gichoon.han@samsung.com>

commit eed0e9583a290e6adbe3a8480bdae911f31e1ed9 upstream.

retire_capture_urb() copies urb->iso_frame_desc[i].actual_length bytes
out of urb->transfer_buffer at the packet's offset, but never checks
that value against the requested packet length.  A host controller
reporting more data than requested makes memcpy() read past the end
of the URB transfer buffer.

Commit 06be918062ad ("ALSA: usb-audio: Bound packet copies by the PCM
buffer size") clamps the count to the PCM ring buffer size, which
protects the destination.  The source slot is only ep->curpacksize
bytes per packet, though, so the over-read remains.

This was hit on an ARM32 system (vendor 5.4 kernel; the code path is
unchanged in mainline) with a full-speed UAC1 microphone behind a
high-speed hub, i.e. the EHCI siTD path.  sitd_complete() computes
actual_length as desc->length - SITD_LENGTH(t); the controller
reported a remaining length larger than the programmed one, the value
wrapped to ~4G, and the capture copy faulted on the first unmapped
page after the URB buffer:

  Unable to handle kernel paging request at virtual address e8756000
  Internal error: Oops: 7 [#1] PREEMPT SMP ARM
  r3 : 00000000  r2 : 0001e700  r1 : e8756000  r0 : e878fc80
  Code: ba000002 f5d1f03c f5d1f05c f5d1f07c (e8b151f8)

A packet can never legitimately carry more than its requested length,
so warn and skip it instead of copying.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Gichoon Han <gichoon.han@samsung.com>
Link: https://patch.msgid.link/20261110060021.2146383-1-gichoon.han@samsung.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1286,6 +1286,12 @@ static void retire_capture_urb(struct sn
 			// continue;
 		}
 		bytes = urb->iso_frame_desc[i].actual_length;
+		if (unlikely(bytes > urb->iso_frame_desc[i].length)) {
+			dev_warn_ratelimited(&subs->dev->dev,
+					     "packet %d: actual_length %u exceeds length %u, dropping\n",
+					     i, bytes, urb->iso_frame_desc[i].length);
+			continue;
+		}
 		if (subs->stream_offset_adj > 0) {
 			unsigned int adj = min(subs->stream_offset_adj, bytes);
 			cp += adj;


