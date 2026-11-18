Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057226;
	b=jfKvsFIByE3IOzFSNPRKPMb3lpv3Nl9oYyBByLzoD9gVaVeRgopVXXRUjz6nMWUtbHtb
	 UTzBwG2VdtnaIrKp2nt/2qzORHcyxEM2OG4ZvN/sVK2OsSoDCIo9nCEtYKcnBgHohElnF
	 /Haro2z0ZyX55nuTQZYaW6aHW3S9XY/QJVfxwmXMVuFrCK1gX7WMRQOpQGO/ZWlvijREn
	 Xs7dT33Z78N56ihao3ZLDAmrwUNHWm8KJqjtvD4OxUVhV7Ua4KQ14aMpEcM6QP8A8oWZL
	 XzoGAekK+yFQPl+Q6gNBx6419ujAvC07CtkIsph+pGjyFR/MbZMOvd87Zu/R1FdwMlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zD5mdU/P+cBnWWoBtUAFb6vYroaPk8I/t0GCSguvolM=;
	b=RSq/bA366OtBRNsZv+ePVnHyx0vrUNdYxO+r7jVPQDxtLQolaB8pHNXqFpXe/Emwli7B
	 vFyMDKpDijbirfGAzBPDYAtU7eGhU8FOK0qa6UZ3I0zK4fGAZ2j3oWNFxEBzb6Y63Px2i
	 xkqOp0XvUsUHY60MZ9iq6v0R3jVcPQXQuk7dBDrDtRENY6dJbCIMa/PGDhi6li5AxDS9F
	 hSIMT1KQtR0u1Bg3clEqVnmzO/kIqK4sFEpWfpEGV+gKSJiWuhPQ7EaMkry7T4qJAiwtj
	 FkNUqQDO2oulUocazmPea4QWaCVYz0m4ZjaKK6Xc3XANX09JD5HiE1xwHuXSN4om5sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="005J/1VV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F7B60A261B;
	Thu, 19 Nov 2026 03:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=005J/1VV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AB91F000C9;
	Thu, 19 Nov 2026 03:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057225;
	bh=zD5mdU/P+cBnWWoBtUAFb6vYroaPk8I/t0GCSguvolM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=005J/1VVfP3PINZsZFsL9ZFrhfFunQ8riaJE1c6UIylMS3uVptBV3pg4JPewIt+d0
	 UmO3jFZ4G7uq3/JPXADCGKwru/k2pHFsv4IdbP83ATdhPPkBJSAKSI6ljqYiQKx9G0
	 2REQwl3SuOcYH8fnpBTkiN4GV1ctL5qc81V7mJIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 0013/1848] ALSA: line6: Clear prev_fbuf on capture buffer release
Date: Wed, 18 Nov 2026 15:34:11 +0100
Message-ID: <20261118145911.723254639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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


