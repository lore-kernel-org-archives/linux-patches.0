Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036204;
	b=ce8dpe5jfbKGlAj04Vb11ByAJ+46LwAXhgbXvzGi/zBBnD7lonUbMsfKoBJ8gNtdmOrQ
	 9Y7Gjh4Kc0kkZL6Adyyu8r4cq+8XriyT4W9miwuvq2yoO25K9FCOYqYyFMYwjbIB0IVGK
	 sijZhBLBlaN769IdlzWhLFj33jXBmAYBtFWSMVaOY7ibR1idWlTzd5USy/VeoQSsUzUB1
	 OzWM4uylSuF9OKSFBMLP9G3YhSK6UOD+w2m+B0GEfSbIOp++8Y8CIzmb73TU8277MvYt5
	 SIjdq/xnjOZralZTS0nLIVUGn8MAeIEhcYqiEtzmvTttZAsSNP/F+ODN7pUaU0mxoNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fRZ0PnDfuKi+M+/xwAbovQ9u19UH4Wres/6smxW9viY=;
	b=YltH5vgQU7/rBJY/WKEwEh8UYbdiH5uUGJob9DAWDjJuiNkUpuGPrHzEO1xKgRDvlCyF
	 uzCxrSjmhioJouHDXsyVh7Qfgsst3b7zK4ZklLZklyQScrIiojqctDLyzwXYrpA99AyUL
	 q9ONrxQYgjQIeNKye7pVKs1q3IGiXkmLj7BuOSnzlbUj5NGS/CGPa5kqxo8XVK4hB6+Ek
	 y0uoemPXOYiY33RHXHfdSJgsVrlUmJnI8vOfA07XLtnOi9V5R5sAdLrrxtIuJR42oL5YB
	 l+XEZberEpxZJMyUpDQMxm0/jGAgGEmNk+K69YEFHDRfxkdGJrX3UqOymNq8CGs7Nyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sWsGCLdc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7922C606A320;
	Wed, 18 Nov 2026 21:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sWsGCLdc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D461F000C4;
	Wed, 18 Nov 2026 21:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036204;
	bh=fRZ0PnDfuKi+M+/xwAbovQ9u19UH4Wres/6smxW9viY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWsGCLdcEIo+vzAsMKjVao7onxsmDL82UB5yevSDwB227inLMfUqsiI7NwBh5ucWb
	 DuTprUsQ8nFA4Xfo/vs3ZmcHXgY6eBYGNBXpuph9pA6id7ecpjS6JmdAF9pfrZXVqE
	 uJxuaV20dyE9htJj8i8ItEKQazyK7PxnuoOf9Qc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+6a04efcebe0fc0ce@bugs.sh,
	Kaho Jiang <kj2864@nyu.edu>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0977/3318] media: em28xx: fix double free in em28xx_alloc_urbs
Date: Wed, 18 Nov 2026 15:26:39 +0100
Message-ID: <20261118150349.039627848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaho Jiang <kj2864@nyu.edu>

[ Upstream commit fd427b8adae437cac78a2332241a03cac56e95c2 ]

When allocation of usb_bufs->buf[i] fails, em28xx_alloc_urbs()
explicitly frees all items within usb_bufs->buf before calling
em28xx_uninit_usb_xfer(), which also frees these items, causing them to be
freed twice.

BUG: KASAN: double-free in usb_free_urb.part.0 (drivers/usb/core/urb.c:25 ./include/linux/kref.h:65 drivers/usb/core/urb.c:96)
Free of addr ffff88802fd37c00 by task kworker/1:2/1182
Workqueue: events request_module_async
Call Trace:
  kasan_report_invalid_free (mm/kasan/report.c:557)
  check_slab_allocation (mm/kasan/common.c:235)
  kfree (./include/linux/kasan.h:199 (discriminator 1) mm/slub.c:2693 (discriminator 1) mm/slub.c:6508 (discriminator 1) mm/slub.c:6801 (discriminator 1))
  usb_free_urb.part.0 (drivers/usb/core/urb.c:25 ./include/linux/kref.h:65 drivers/usb/core/urb.c:96)
  usb_free_urb (drivers/usb/core/urb.c:95)
  em28xx_uninit_usb_xfer (drivers/media/usb/em28xx/em28xx-core.c:964)
  em28xx_alloc_urbs (drivers/media/usb/em28xx/em28xx-core.c:1076)
  em28xx_dvb_init (drivers/media/usb/em28xx/em28xx-dvb.c:1734 drivers/media/usb/em28xx/em28xx-dvb.c:1698)
  em28xx_init_extension (drivers/media/usb/em28xx/em28xx-core.c:1248)
  request_module_async (drivers/media/usb/em28xx/em28xx-cards.c:3685)
  process_one_work (kernel/workqueue.c:3396)
  worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  Allocated by task 1182:
  kasan_save_stack (mm/kasan/common.c:57)
  kasan_save_track (mm/kasan/common.c:78)
  __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
  __kmalloc_noprof (./include/linux/kasan.h:263 mm/slub.c:5414 mm/slub.c:5439)
  em28xx_alloc_urbs (./include/linux/slab.h:995 ./include/linux/slab.h:1312 drivers/media/usb/em28xx/em28xx-core.c:1081)
  em28xx_dvb_init (drivers/media/usb/em28xx/em28xx-dvb.c:1734 drivers/media/usb/em28xx/em28xx-dvb.c:1698)
  em28xx_init_extension (drivers/media/usb/em28xx/em28xx-core.c:1248)
  request_module_async (drivers/media/usb/em28xx/em28xx-cards.c:3685)
  process_one_work (kernel/workqueue.c:3396)
  worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  Freed by task 1182:
  kasan_save_stack (mm/kasan/common.c:57)
  kasan_save_track (mm/kasan/common.c:78)
  kasan_save_free_info (mm/kasan/generic.c:584)
  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
  kfree (./include/linux/kasan.h:235 mm/slub.c:2748 mm/slub.c:6508 mm/slub.c:6801)
  em28xx_alloc_urbs (drivers/media/usb/em28xx/em28xx-core.c:1084)
  em28xx_dvb_init (drivers/media/usb/em28xx/em28xx-dvb.c:1734 drivers/media/usb/em28xx/em28xx-dvb.c:1698)
  em28xx_init_extension (drivers/media/usb/em28xx/em28xx-core.c:1248)
  request_module_async (drivers/media/usb/em28xx/em28xx-cards.c:3685)
  process_one_work (kernel/workqueue.c:3396)
  worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

Remove the explicit cleanup loop and let em28xx_uninit_usb_xfer()
handle the cleanup.

Fixes: d571b592c6206 ("media: em28xx: don't use coherent buffer for DMA transfers")
Cc: stable@vger.kernel.org
Reported-by: co+6a04efcebe0fc0ce@bugs.sh
Assisted-by: LLM
Signed-off-by: Kaho Jiang <kj2864@nyu.edu>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 560d525033ff2..5208f5813dc79 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -948,9 +948,6 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 
 		usb_bufs->buf[i] = kzalloc(sb_size, GFP_KERNEL);
 		if (!usb_bufs->buf[i]) {
-			for (i--; i >= 0; i--)
-				kfree(usb_bufs->buf[i]);
-
 			em28xx_uninit_usb_xfer(dev, mode);
 			return -ENOMEM;
 		}
-- 
2.53.0



