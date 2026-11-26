Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705410;
	b=YUG1PYKv4Wxy2zpdYo8v2geJ0FmGfSb5XlV04/vqrm34Jsd1R0uCS0xl02gVYrmkweOo
	 8V1FEgbbTV9kAz7uG6ToIsBDOF8p5errZGvhGMVV46EE1nycJyqFHCf8vrFDqLPHmjCwp
	 MweEXWmxhpPq7GgMi8GOXFrNvCbEMXTi7a1cGPNsk5gf7+dGgtHFT7WA22edKWisFB1+g
	 oDnjWa1uK66hqHPedx5Ht/UrZQLIPx41BYfP03mE3yqYvqlYJStts1ep81GUFhGmDS1p6
	 ZfkX9/gGZCziI5csghJj9y+tCAGq7kPf2YuhSdTMOlWREgn7WAy7prmcDN9RiRR+nRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r/hEWaUi0LVp1ybZ0QgHmmGuIT8sCVvnpBGGW7Ow72E=;
	b=M+k2LifRU8GuxphWJXYDfuKCV3MoO4cLrS+ttKZB6081sNZgaqApuObEcoLIAsyKe6sU
	 Au7DBg7+ptpY137BvafeoDYby5KCz6HLb0Sx+g4XWKY/0v+vt6Noh6W4/m/xxCcITPvG/
	 iSVheZMSO+ql4q6ZBRMGe/s9WyVLHX8P3L+FLzdUiaJqHzFXIrCqAo8mo42G8lhrjvTlB
	 wxEAiWy/36adRTWXZCWNQpESLnkkJbMaKI2TmfpQ9MMGAZ0FSmagbIBpqhobrk3XlHN8m
	 8wqUn5FL1JQ3Kg330eAKi/w8e1pUKVfQGH+6frZXmsDlk5KZ9IHPSw559Pv9J+4ICpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ce3Wx7cv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFBC606A321;
	Thu, 26 Nov 2026 15:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ce3Wx7cv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9631F000C6;
	Thu, 26 Nov 2026 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705409;
	bh=r/hEWaUi0LVp1ybZ0QgHmmGuIT8sCVvnpBGGW7Ow72E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ce3Wx7cvXYYHPhWPJq9RZcIYKog4x5oTZX23cEHBSJHzeeNzmM8x+0SRCJeMmhPVm
	 VVHp6FgN3vZHfAyhia+Q0Lyl7MZVjkCWQ3XJXVgEi6naAGBqpd0bKD6hX3avCC1kgI
	 5C995h3C7zzp7HC6+z3vJkXVwBNEkFM7SEN8EIOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gichoon Han <gichoon.han@samsung.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 172/319] ALSA: usb-audio: Drop capture packets with bogus actual_length
Date: Thu, 26 Nov 2026 15:39:00 +0100
Message-ID: <20261126144010.628109693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1222,6 +1222,12 @@ static void retire_capture_urb(struct sn
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


