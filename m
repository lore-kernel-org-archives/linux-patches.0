Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208691;
	b=k7/no51vGHszjYXbrfKQY6JcIeeg8a+wgRh40jXrTnwhHM/zRG+n0gGOH6XA5ccGxZPP
	 KKgYm3GNPJU6Ux2doapzVKYkA8tKOB+tkocBbcEXjdVoDjGyPjbUCBsKRlgEI5+eYq1j3
	 rYMzbgpBulZB1pbVXplccOBUqdjf20u5vnpHUlJ8dDIpJcUArlKEWFmL3HfTnVVwAVKBv
	 eioTJBwcOWQtVBgACS/x8zArsBgCbkrhZQoPzX6je6NK/bvjTpymqCNjhpL1XQtoOJevy
	 K/eOtuSLHbdyY41uMDcoxKrCa/c/1DKSkt798i+0xkcpxil/NQIbNzCQ7wgU18bKDuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2nltz5v+TO8ORuLCs2RfEIJklXZ3X1opo+ks1rZ2VHc=;
	b=R4Zv/0hexdWRQCDS25NoZumXbB06LwYe2N80SQ7RIDdmULshaorz2ijdLN6Q5Nlg0T1G
	 OPHJmMKoLBjW9Z7wl1ItdmAOKzNnrWBwhxpGeVkLkIJ+VkX75PsCigTLBxUQA40II8duu
	 yshV8pskpHa7mHO104lhEYZjJSokmki+RA63UpKRaOOpydfL43FtoYH6X29yegmb07FPW
	 one4gIuwQnH5BdlWeUT/JXYwrOf+eHJ+gEMrc5D6OGdXzJLT0VF3/ly+XFRp4tYLcWCjX
	 GZFjRAQDjysuhmSkSyXrIe45nZc/Q5liUSISglI5BrgarsEfBY6iKKJt33YDcWe8Q0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDskgKxk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B411E606A31A;
	Wed, 28 Oct 2026 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDskgKxk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEECE1F01825;
	Wed, 28 Oct 2026 17:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208690;
	bh=2nltz5v+TO8ORuLCs2RfEIJklXZ3X1opo+ks1rZ2VHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDskgKxkiFnvQoPf00to5bp5NdH4jLObL9oQHnZ57DREspLJ1bv3o51im2gfxmCpW
	 f5qWUO1Sb5eyHhfX+GslFj3Ck0+pLumsqqnGBDnTj7aSLQWwhYzY7kYL3lzr98n9lv
	 LVINAsNX0Q8o0URrqJB+zzgtCtceYV1cbXWsp4YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+24304d323d28f156@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 208/516] ALSA: ua101: reject mismatched capture/playback packet sizes
Date: Wed, 28 Oct 2026 17:56:00 +0100
Message-ID: <20261028170008.428524313@linuxfoundation.org>
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

commit 86f86e6fdedc33c5b8d38b9208b350f8accf57ee upstream.

detect_usb_format() cross-checks bSubframeSize, bBitResolution and
tSamFreq between the capture and playback interfaces, but never relates
the two endpoints' wMaxPacketSize and bNrChannels.  Each playback URB
gets a buffer of ua->playback.max_packet_bytes, while the number of
bytes written into it is derived from the capture stream:
capture_urb_complete() computes frames from the received capture packet
and capture.frame_bytes, and start_usb_playback() and playback_work()
multiply that by playback.frame_bytes.

A device declaring a large capture wMaxPacketSize with few capture
channels and a small playback wMaxPacketSize with many playback channels
therefore memset()s and memcpy()s past the end of the playback buffer,
in open() of the PCM node the driver registers during probe.
usb_submit_urb() rejects the over-long iso_frame_desc[0].length with
-EMSGSIZE, but only after the write.

Reject such descriptors at probe time.  Genuine UA-101/UA-1000 hardware
declares proportional packet sizes and is unaffected.

  BUG: KASAN: slab-out-of-bounds in start_usb_playback (sound/usb/misc/ua101.c:586)
  Write of size 2048 at addr ffff8881098f3c00 by task exploit/5021
  Call Trace:
   __asan_memset (mm/kasan/shadow.c:84)
   start_usb_playback (sound/usb/misc/ua101.c:586)
   playback_pcm_open (sound/usb/misc/ua101.c:679)
   snd_pcm_open_substream (sound/core/pcm_native.c:2829)
   snd_pcm_open (sound/core/pcm_native.c:2865 sound/core/pcm_native.c:2932)
   snd_pcm_playback_open (sound/core/pcm_native.c:2891)
   snd_open (sound/core/sound.c:166)
   chrdev_open (fs/char_dev.c:411)
   do_dentry_open (fs/open.c:996)
   vfs_open (fs/open.c:1101)
   path_openat (fs/namei.c:4837 fs/namei.c:5000)
   do_file_open (fs/namei.c:5029)
   do_sys_openat2 (fs/open.c:1417)
   __x64_sys_openat (fs/open.c:1423 fs/open.c:1439 fs/open.c:1434)
   do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

  The buggy address belongs to the object at ffff8881098f3c00
   which belongs to the cache kmalloc-192 of size 192
  The buggy address is located 0 bytes inside of
   allocated 168-byte region [ffff8881098f3c00, ffff8881098f3ca8)

Cc: stable@vger.kernel.org
Fixes: 63978ab3e3e9 ("sound: add Edirol UA-101 support")
Reported-by: <co+24304d323d28f156@bugs.sh>
Assisted-by: LLM
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260918225753.1278505-1-xmei5@asu.edu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/misc/ua101.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -1023,6 +1023,15 @@ static int detect_usb_format(struct ua10
 	}
 	ua->playback.usb_pipe = usb_sndisocpipe(ua->dev, usb_endpoint_num(epd));
 	ua->playback.max_packet_bytes = usb_endpoint_maxp(epd);
+
+	if (ua->capture.max_packet_bytes / ua->capture.frame_bytes *
+	    ua->playback.frame_bytes > ua->playback.max_packet_bytes) {
+		dev_err(&ua->dev->dev,
+			"playback packet size %u too small for %u capture frames\n",
+			ua->playback.max_packet_bytes,
+			ua->capture.max_packet_bytes / ua->capture.frame_bytes);
+		return -ENXIO;
+	}
 	return 0;
 }
 


