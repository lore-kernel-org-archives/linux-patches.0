Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050887;
	b=l91sZudSN76UpQ/qKQyIaQuNsXrimscJtJT9ceIYQ3urGY+y21puUJTOQdh0BBxSNCEh
	 k3JliTcZkpVqr3ebmOHH9AQYOYpv3tl8S1Ta9smfFyBHYyFn+Aos/Nh14vwSLo9EvVSSM
	 9vRQnqp/vV8M+iVvnclI99DwzUn08951jBugOE6Q7d3UX6s3x+GeGGzodbZLYSM8JAEKc
	 g3KBHu1L19+XFPUnMAaM00RdnzQGVVI5yBxuh4GH5hlqhwMTl/zW2ZefyiODFE0bR2r4f
	 oeXMvklrXp9eadMW3HAKES6t6GrLXTiYUC8xzYr9OZfoQVCCbmiFqTpPItcDxjvej6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oSH3lShm4GkIpF7UFs9tQJ62mHfv4ytyb8SCWFHl0UU=;
	b=NWf5rJedCE7hwc7w2ZHYDAzTQog3Iz0YWg6v7tVu52G55s8qmwyODA3QqWT94GfgsWlX
	 axvjWAN6S78x5qtuVFRGvtZVXk0TLdBYZFnbV6qX7r45VRXNh4XEcwK/RgBYzLbxHM0x1
	 +oXYrhCV6J6vZ87iaQWQ3dCIda2zMLAULiKh2r83WENDlzDTEH/N3mMiR6b6k1JC85UoT
	 7aXSvkYjJpkYpUgIit+UA1NXPlCMVSRn4JQtNHB39D2qpOlBTTFSgpaw7XWVboUqDL+23
	 Oy6+YXJ7Pg5mbb6y0jYCdgJomxyVqQqmaq1krIvEKR7YSY24HgvEJXzkOCdYU2jQDcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBnKISVT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A72606A320;
	Thu, 19 Nov 2026 01:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBnKISVT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100421F000C4;
	Thu, 19 Nov 2026 01:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050887;
	bh=oSH3lShm4GkIpF7UFs9tQJ62mHfv4ytyb8SCWFHl0UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBnKISVTRzbuoMW71ySCX7MuRFi5mTOk0AtfscpcgsX813awg9QEycwm9FQ1N8J5d
	 P/TvI3GELYL4FRwLA+zAdH/Z9rqb2aTr2RMj4deat2a3yHXG7vcNmQqH5MGTWU0DiW
	 3aaXad4J2VtRfKlycWNuBg3SJP32NZYoUoX8KoTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 0014/2214] ALSA: line6: Clear prev_fbuf on capture buffer release
Date: Wed, 18 Nov 2026 15:28:10 +0100
Message-ID: <20261118150010.715063325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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


