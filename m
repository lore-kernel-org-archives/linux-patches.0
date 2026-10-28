Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211050;
	b=iOsEQrF0FsP/iUQXrto9iOoJoQylC8v4xVv0TBH6wdtmiFFAQi85yJSe3CPdWUQDcJGu
	 62raBeERow/3Qcnn/eeWi6rwP3TYcuptcfH4ngSZ/a4h0EdL69ScNr3uFkYQ6OSzgSRAm
	 1C338WXfosfv49PCk73UE7TYPKiIbPnYDQq5GGPQDkP1AykPe5ALF8P5zUsfAefxbUGlE
	 KlzhodneLUA49ZSVRCpOkxskRmb0xmVk4r39/pO8ITmzKZJW/sJ+EB0dyi73cIu3If4Ug
	 3syURLIoa4lQH/9awgsQQT+eWUii8uTtAwmZulKbjg1Ol4IjW1ErIZN2QbPNTPDrm9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2IzG7GFkeex8JaAE/HP/Czm7QLOkivBVidnBlxX9i/0=;
	b=m33lJjFlnJb1ZD9AJCM1tTTNo9O+qO4Ga1y78GXzzziWq8Nw75LWAF5sFwp+gUyDYhFi
	 IGqexJ/WmU6e0hMjlSgTpXzd8gxPqJ7MHYd3v4sAUrcOW/nMBpPfmDPRv+XABed3y3qfK
	 nGz8ApGU13nQ4itu4BLLzMLxrjallBSgsLS/7uketWdnLGdOmCXEgwjt5GgRvFml2PDNM
	 fb9rIk+eK32g8z2wr9+TFsNaV3SVfdnu7SVudElIMbh3/l/Xr/hklasw2GX9snx5tWXuV
	 VU6NmXm3eaacMVsQz2LzKkYc7Ln7kXeyzExmvtf0hvzrggHqmzVWiXE/ZuQLImoIOAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwhF6raT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B2260A6F78;
	Wed, 28 Oct 2026 18:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwhF6raT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328031F031EA;
	Wed, 28 Oct 2026 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211049;
	bh=2IzG7GFkeex8JaAE/HP/Czm7QLOkivBVidnBlxX9i/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwhF6raTq5U4xLNan/ez8uw3vnnyfv/yAudCnvIJr/y3J/h1TulWN3PViqsyZoQ9V
	 Qq3lk5OHogB0ajSrCqXMUanGWbC2Hael5BiOkKOroFwvLl9VqlbwiE5wz/NI2rEEZT
	 CglB1QxHzCZ12eUbdazoTkzZGDLrejdrs9KrBIuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+24304d323d28f156@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 224/571] ALSA: ua101: reject mismatched capture/playback packet sizes
Date: Wed, 28 Oct 2026 17:56:11 +0100
Message-ID: <20261028170013.317029707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
@@ -1022,6 +1022,15 @@ static int detect_usb_format(struct ua10
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
 


