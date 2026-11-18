Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042998;
	b=jdT9KyV7eUecai512eEkXnKORUMw13lT5nFjyZDeKJqdEgihg3/j+94Bi7phCnDVXcOB
	 BrkFINS1MM+RUEuU8Mo4h4LM1UuMjb85uAX+Kl7ErO2bMi21KTbXty3QD62qA0KgoSbMv
	 KTFeaciPKZclRYIAL7PAFX85QyLZB2dNeV0unoAaWoPcSOS2qKM2mebqYBzZevgtfb9zC
	 E+sUYpnShjTA/dtsPvvaIH9UAtAq4FYViMZdXBbTfDigccbZQu3skNVvaxF+wElEmzdA/
	 QCsCz40g8Dy3vE/eeyCfDnDQ+9uv2+nokXkX/9uOkG6que/5/b1DrQrqwxLwdl32woQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=daWNGHV9MbLdcd0me67W5Nv52TporlQFtripGq8h4d8=;
	b=CF5Ig5kPCXYGnVsLl3rj/889QdLaFG/Ugp3LgtluKrdO1vzLIfzzPtLLVtqsbkLrMBOo
	 2LywaFxCbyYr+jaFLhqdOGIsMp3S5ahBYwZSVYTK5T4o16J0b7wQKJtNKVG4HI0Yo3Ny0
	 tIUw6CZobJyKxM83EutEhJEkaY6lNeFyap7p4v5ZF5ouv98CZiE2HW6Uha6YF1lJPKn4l
	 2L1ePpkyGmuyvG2Y6kObVpBJesXD3boNrQ97d56RsTtikyNhgJqLaiskhvfPqoNOIM7uR
	 XXSC6bezp4b9rvk8D0QWRZjwWc/EB1kGxtxjL00yqbx3VJDERjyWB8nPayKy/f1Divw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEXscDk2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDDA606A331;
	Wed, 18 Nov 2026 23:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEXscDk2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E4F1F000C4;
	Wed, 18 Nov 2026 23:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042998;
	bh=daWNGHV9MbLdcd0me67W5Nv52TporlQFtripGq8h4d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEXscDk2QLTEsVrwrODWaAyguTFqp3A1Z3KAByLSD/PBcbndeELnABB/IELeN0kRw
	 pOf62aTGPSnHUMu2+N34BT1huU+5r/36NJvpRArv+YwC1RrTifKYnWRJDg5xw9K/UF
	 gG8QxltRcMRz3xSd6Ql0J3dCyCOHI0IJI/VKsZjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0017/2857] ALSA: line6: Clear prev_fbuf on capture buffer release
Date: Wed, 18 Nov 2026 15:17:31 +0100
Message-ID: <20261118150201.980486922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


