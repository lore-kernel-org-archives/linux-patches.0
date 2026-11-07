Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060559;
	b=kmVEo6Qu5jqOYHs727YTvMEoC4TCFYFBnK97NlhihpvCFbusQkxUP1Qr2F2CL6PxpLvP
	 4LLH8CyQTUXqNSup6akR0lkQQoV845ySCPTmHf+gM5UERi9nl4kM9iJDk/cip/oRWyL1x
	 PA/3mjIO2owtWb2LRuf5wfsbFv1zmifBslGRUiO9U7qEO1RNixzBxuH8PspM9bEp5hEW1
	 y1bblv2Ttauk59/EAMeAZtPiyD1EN/H91yYHD9ZF8WUEO25MyEhyGiNUhOpXTkuz91Vtc
	 rSWpbbLNn9b9L9ZMMrPXdLYs9ey0XywxTu1MmJ/Ed5RdfjeKRMFCUsZz1m24FqRdbnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GPsBM1GIw83xaiUPNHDG6VQiaCe5L1cgPUTobVtpsLA=;
	b=pkVksTxm8L4tdeqk+t6FWt873qdyFIbjxaG6jX+q3V1UWqJZxF4G+IggihV5NY8FrLcJ
	 x+KF1LTAUX6tjVRXANGx08KJxy9L9ze9tT5dMbGIDE9w666q65fPMtI+9HJaMLvgo9Jh+
	 4PK0aTC4f4hMQ7YMWfPyIjkaEMuB6Xya32KKl8OsWXpexpPhzHkhUKFJJ14yfbN+2rgDs
	 lHSN5YccXq0VNzEB2XAzmQZ9V02q4vxhBcStdxWVrpbQr3iCiCzucq8mP8oxRg9/ssJyl
	 i/zDow9HZyeA8oZ8dBRxAAI8weRtOAgrzftO6qq4wExSKl1573y4NBC+COkXR+Gp65Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMXrvNXm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0CB606A32C;
	Sat,  7 Nov 2026 14:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMXrvNXm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782271F0089F;
	Sat,  7 Nov 2026 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060558;
	bh=GPsBM1GIw83xaiUPNHDG6VQiaCe5L1cgPUTobVtpsLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMXrvNXmLfpig0P3U5G5Ux7bKpzWcQThFIWNPnCyrzmShpF705ZCHVNyNhWmUym1n
	 PbCwifPJu94sv0otz+yN8fV3MTLjcT8+jyG6PL3nVfwNSMAF9D0V3wbPoiko9Cz/yQ
	 axhTxFb45bn3J7smCVNDj1Er2bSq+LVuuNfG50/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 0023/1536] ALSA: line6: Clear prev_fbuf on capture buffer release
Date: Sat,  7 Nov 2026 08:33:59 -0500
Message-ID: <20261107134958.328535307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

commit aa118c8f61d59387961d58ffae831c5259a9f222 upstream.

A KASAN slab-use-after-free read was reported in submit_audio_out_urb()
when generating an impulse test signal:

  BUG: KASAN: slab-use-after-free in create_impulse_test_signal sound/usb/line6/playback.c:76 [inline]
  BUG: KASAN: slab-use-after-free in submit_audio_out_urb+0x1848/0x1b20 sound/usb/line6/playback.c:249
  Read of size 2 at addr ffff888008d74870 by task syz.2.3214/7785

  Allocated by task 11:
   kmem_cache_alloc_noprof+0x2f0/0x390 mm/slub.c:4144
   line6_buffer_acquire+0x1a1/0x220 sound/usb/line6/pcm.c:158
   line6_pcm_acquire+0xb6/0x230 sound/usb/line6/pcm.c:329
   line6_startup_work+0x3c/0x50 sound/usb/line6/driver.c:728

  Freed by task 7785:
   kfree+0xf8/0x390 mm/slub.c:6566
   line6_buffer_release sound/usb/line6/pcm.c:176 [inline]
   line6_buffer_release+0xa5/0xf0 sound/usb/line6/pcm.c:170
   __line6_pcm_release sound/usb/line6/pcm.c:305 [inline]
   line6_pcm_release+0x5a/0x80 sound/usb/line6/pcm.c:313
   snd_toneport_monitor_put+0x11b/0x190 sound/usb/line6/toneport.c:183

line6pcm->prev_fbuf points into the capture PCM stream buffer
(line6pcm->in.buffer), which is updated during audio_in_callback() to
feed rate synchronization, software monitoring, and impulse test signal
generation on playback side.

When all capture streams are closed, line6_buffer_release() frees
pstr->buffer with kfree().  However, it does not clear line6pcm->prev_fbuf.
If playback is subsequently started (e.g. via impulse test signal
volume control snd_line6_impulse_volume_put()), submit_audio_out_urb()
dereferences the stale pointer line6pcm->prev_fbuf under in.lock,
resulting in a slab-use-after-free read.

Clear prev_fbuf and prev_fsize in line6_buffer_release() when releasing
the capture stream buffer under in.lock, ensuring that no stale buffer
pointer can be accessed by submit_audio_out_urb().

Fixes: 63e20df1e5b2 ("ALSA: line6: Reorganize PCM stream handling")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261013063554.571-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/pcm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -173,6 +173,14 @@ static void line6_buffer_release(struct
 	clear_bit(type, &pstr->opened);
 	if (!pstr->opened) {
 		line6_wait_clear_audio_urbs(line6pcm, pstr);
+		if (pstr == &line6pcm->in) {
+			/* prev_fbuf points into the capture buffer we are about
+			 * to free; drop it while no capture URB is in flight.
+			 */
+			guard(spinlock_irqsave)(&line6pcm->in.lock);
+			line6pcm->prev_fbuf = NULL;
+			line6pcm->prev_fsize = 0;
+		}
 		kfree(pstr->buffer);
 		pstr->buffer = NULL;
 	}


