Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622797;
	b=Y4m04pB3ugnhOP32DN2TWDM6ArCNEGvOvbOVyvts3dDt/3uvC0CY1n1zd3jt/2Sa0I7g
	 1OJkjhU8zlSLcabmtb6YlttegbxkpcUNTzteXBtdSmVNLgiAtsADVeyYEdBdxiFlGrbCT
	 d3Sodqc6T8neVMJhcWjxGVS364lRU/cwF0IGEO4oUayMtvn3Ol1dYYyTfPyfXee6phSBw
	 MPb5NkFixe9NF+Li28I0RkQSGWl7ciG8r6YCn2VqPzyPcmZ+QC+NZEmixk+9zeUA6KjJ8
	 YLksR2mSp6QrZmbpQMT2OCB+PJLqNRCT6OD7Etny9gb0w3tPfBSLZ3jUjxeUvOsD7dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N8gNJxj3ZSxEuS8EWBVtdhyOfhN+XLalGnwh89tZqCA=;
	b=dEsOOF3WJ+kS3zjApyX3NLvrB1Oj4GM8zVYfSkgIz4UN4a3rAbThLNY6t9Rd6eRt61kP
	 5F9pvqQQqslBslPYSzG0W9ubDe4JmOCdwQqm9BHGUBg+KZKI0jDMcFu+BUXEiIG70hWXn
	 5OlH08+GNWtm5JV+yOszuABBNo9BHfS2xfuhqgjyUro3YE3h3ZEwZngnFmixaxPZQlksD
	 9iIM91istzcNF380ZtyEWW7sVTpqraE9fZID0bIysNj8yeLxjzTjetOJTnIto5j71jHbA
	 cQV+37FdZtCYBYYgMAl4yUrcNbNUHff+qLHgMHlH+dpeW7xeIURHwGMB++mNVeKJOoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TN9p+3IT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC827606A336;
	Wed, 25 Nov 2026 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TN9p+3IT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1DE1F000C4;
	Wed, 25 Nov 2026 16:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622797;
	bh=N8gNJxj3ZSxEuS8EWBVtdhyOfhN+XLalGnwh89tZqCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TN9p+3ITGE+nTAQ7KKyXh1kGcO9ObWLBX/tykVsZLCCQmOQgK4K3suO66EavETMdt
	 La6m8JV6AImB4JlclMAXJLIATaIH8W9rXL0Blg5jEixFSaQvfuiDhqF+bAk3LB63Ey
	 TXyXKj4lmWKUEsaQwPJ4uqRfTe+dQ57MUFibywrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gichoon Han <gichoon.han@samsung.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 653/990] ALSA: usb-audio: Drop capture packets with bogus actual_length
Date: Wed, 25 Nov 2026 15:33:40 +0100
Message-ID: <20261125143837.387676853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -1337,6 +1337,12 @@ static void retire_capture_urb(struct sn
 					    "frame %d active: %d\n", i,
 					    urb->iso_frame_desc[i].status);
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


