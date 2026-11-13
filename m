Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590265;
	b=mrdk3xTdspV9Sg3+Gc8zn+oBmxP8Cg6Wtd6yh6BIZdulY9NJ+v8KQOmSCj+IjhwlqxE4
	 NRkgAZX6qH810OXfleWP2Sk3iz8Jz+nMM6Jnyq1MxRh/rsugx7QCS8HErBBlXabGtPxpW
	 zVbp6w/SEl3yK/1NhknNh4yb11XyNQipPvboQ0dB0XD3uGqBERSR+sLsrZMlWM3QG4hAp
	 Ep6ms239r29V+FzGVr97KaS9yGtLd5SoNZGcjYDzfJjffAVKrWaLW+WN0TEqeSE8lqb02
	 WIiimI2rBGp7av/TK8kKDWCRxIA1gvLi2UcZsV2TYXrrnVcLx3YpB+KS5kcLdmNb2OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Mb4LTUK8eXaEn89bWlLNEalYaMjIEk2x6HoxDIKYeE=;
	b=Kyy0njs4xnh4NqPZlp2rMjLNhKxK6rodH+DqAIW/nYE0HmhhiEhN9WWLqgeygZFu9Fsa
	 /KWqa8gMV5cpYXGO9FdX+nqZVC77Na2YEGWCFpnoHQJusYc20ZCw2znEwQT5uHpStuX/o
	 bjd1jlvVXAnY3XkFAxB43eKOV0DwZVKp7U1hIDv7SUmYX298O+eW3Ta8WJNQi7oDBI01S
	 3+KsKJdrZrIWYfF1iHLVBSXljFQatK61ZY9n7+p8DcJ+iCLgC96YXyhyEKefcTA5WmnCI
	 kjMdlOOYPtYmQcuiumEiSL8MlcmlcPHy8DSYP2Ck+j+rYdMKjEJmGysQQ6mwiNSbiXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFC1ZLOr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DDF60A3822;
	Fri, 13 Nov 2026 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFC1ZLOr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2D01F000C4;
	Fri, 13 Nov 2026 17:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590265;
	bh=1Mb4LTUK8eXaEn89bWlLNEalYaMjIEk2x6HoxDIKYeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFC1ZLOrKU+MvxBt/d45YYseBdSJ+qf8eLPAD+ybdit1U6ywRLSfHyuvFUTcodMzr
	 IxhhRMMJMlTLMAO502kfWmPbmN09kUKRs4yqMbFHk4i5+ExOlyJxRSa4DFsEDKOLJV
	 a9bLmOT7sfrToLt88ve1VuECXSIbKRTibWWsczos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 231/686] ALSA: usx2y: Initialize idle URBs before submitting streams
Date: Fri, 13 Nov 2026 10:46:04 -0500
Message-ID: <20261113153828.873908667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit ceb0d8c22473933099b46cec70639d0f1f7c68ad ]

usb_stream_start() submits the first two capture and playback URBs and
only afterwards assigns sk->idle_inurb, sk->idle_outurb,
sk->completed_inurb and sk->completed_outurb to the remaining two URBs
of each direction.

A transfer can complete as soon as usb_submit_urb() has been called, so
the completion handler i_capture_start() or i_playback_start() may run
before those pointers are set.  While the stream is still being
synchronized (state below usb_stream_sync1), stream_start() then calls
playback_prep_freqn(sk, sk->idle_outurb) with sk->idle_outurb still
NULL, and the packet descriptors are written through that NULL pointer:

  Oops: general protection fault, probably for non-canonical address
  0xdffffc0000000018: 0000 [#1] SMP KASAN
  KASAN: null-ptr-deref in range [0x00000000000000c0-0x00000000000000c7]
  RIP: 0010:playback_prep_freqn+0x11c/0x4a0 sound/usb/usx2y/usb_stream.c:33
  Call Trace:
   <IRQ>
   stream_start+0x5dc/0x8d0 sound/usb/usx2y/usb_stream.c:596
   i_capture_start+0x3da/0x710 sound/usb/usx2y/usb_stream.c:654
   __usb_hcd_giveback_urb+0x238/0x550 drivers/usb/core/hcd.c:1657
   usb_giveback_urb_bh+0x20b/0x530 drivers/usb/core/hcd.c:1691
   tasklet_hi_action+0xa/0x20 kernel/softirq.c:994
   handle_softirqs+0x16f/0x440 kernel/softirq.c:645
   </IRQ>

The four URBs referenced by these pointers are allocated long before and
do not depend on any transfer state, so assign them before the submit
loop.  Keeping the assignment inside the retry path also restores a
well-defined URB rotation when the start frame mismatch handling kills
and resubmits the streams.

Fixes: 030a07e441296c372f946cd4065b5d831d8dc40c ("ALSA: Add USB US122L driver")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261028103158.22996-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usb_stream.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/usb/usx2y/usb_stream.c b/sound/usb/usx2y/usb_stream.c
index 3122cf653273d..7d621280fba33 100644
--- a/sound/usb/usx2y/usb_stream.c
+++ b/sound/usb/usx2y/usb_stream.c
@@ -682,6 +682,10 @@ int usb_stream_start(struct usb_stream_kernel *sk)
 	s->sync_packet = -1;
 	s->inpacket_head = -1;
 	sk->iso_frame_balance = 0;
+	sk->idle_inurb = sk->inurb[USB_STREAM_NURBS - 2];
+	sk->idle_outurb = sk->outurb[USB_STREAM_NURBS - 2];
+	sk->completed_inurb = sk->inurb[USB_STREAM_NURBS - 1];
+	sk->completed_outurb = sk->outurb[USB_STREAM_NURBS - 1];
 	++try;
 	for (u = 0; u < 2; u++) {
 		struct urb *inurb = sk->inurb[u];
@@ -739,11 +743,6 @@ int usb_stream_start(struct usb_stream_kernel *sk)
 		return -EFAULT;
 	}
 
-	sk->idle_inurb = sk->inurb[USB_STREAM_NURBS - 2];
-	sk->idle_outurb = sk->outurb[USB_STREAM_NURBS - 2];
-	sk->completed_inurb = sk->inurb[USB_STREAM_NURBS - 1];
-	sk->completed_outurb = sk->outurb[USB_STREAM_NURBS - 1];
-
 /* wait, check */
 	{
 		int wait_ms = 3000;
-- 
2.53.0



