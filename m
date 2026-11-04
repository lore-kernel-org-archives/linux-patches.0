Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831146;
	b=G47lQ51Ho4mCY2GQp3ctElYTiZVsfWDBqRwD1a5fA1kZV1qdIWazuO3l0HCYI03B1rwK
	 7+dTcs4j5HQYS6dyqdZS8KJ8hp8cv7DwKXuna2Cvlx64tKMuBsD5G+WkRzec1UTF89MOc
	 F/QYgdU0CilIcrAkPUmIw/xRx5lxSEHNM4DpPtcRapTMRIDpUllHPi1VeqhB+lpx7noJ3
	 h8fXZj4nwWkJKzwM4357xbIxcU+NI9tbZlNlHnAfGC5da0RMnOpcxos02XQ/dnfIbMVR/
	 m6ypPd11+Y490XgCUta9I9MPFkLr6lzk0ttiNTV3nUE0weIbzkhRfM3NSU/i/wiq7TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=re9w5nIfEfDr0FC9IOwiEkC+yj+WLBEhBo6x5hmdS7c=;
	b=p1kcn9axPb6gMCWeUFlif6EQQJjbBAHcMS6d0LMTprXuwdQovrjgEo+m5QjAI44VOKI8
	 O/qdeMvZ22+a2Z4qV8YMfYLMJwQtD27NljASCJeSwjMz8yfG/zXPyYMw4w1KKUAVRrTPH
	 qmcNnamX7CzblEubSrnEdh6Q4DpaLFsk9y/YAdg6caxoXCowheZ9kDQFq9rmbpITGquIL
	 wSBNy0ZKK7ZzhwVOxiDY3kpt89YtT7bDyE44rId7D7iC0rdXoOGJzkl5X5Duiu/Oo6jgE
	 J8uzcIdlQu6SDPGVxGZyk1QFR1WXyMu8WB1qEoww645iZlaAU7e+WNeKAE+mSUe6kcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWIpS4r1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43DE606B3B8;
	Wed,  4 Nov 2026 22:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWIpS4r1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C28D1F000C1;
	Wed,  4 Nov 2026 22:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831145;
	bh=re9w5nIfEfDr0FC9IOwiEkC+yj+WLBEhBo6x5hmdS7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWIpS4r11LDQ0OFfsWhQFzouZufjLG9vyJMd8loi93lSf7um+MIagNAVuZeGXuaBP
	 B+0cfdsjWBxjyTfYowt6kI78U0e9qVLB9LYz10HZ6QrS1ra5SYVgZodzgAdReum9sd
	 6vw+QuPXrykE9dbRSrEAqoX9dcWnuQx8OMjCfU5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0525/1005] media: go7007: only set audio_enabled if go7007_snd_init() succeeded
Date: Wed,  4 Nov 2026 16:04:18 -0500
Message-ID: <20261104211058.620817183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

commit 2eacf058d2dbb0ae3aaf576459da9e5f2b6bbfbd upstream.

go7007_register_encoder() sets go->audio_enabled before calling
go7007_snd_init() and discards its return value.  go7007_snd_init()
assigns go->snd_context only on success, so a failed ALSA setup leaves
audio_enabled set with snd_context still NULL.  The disconnect path tests
audio_enabled and calls go7007_snd_remove(), which dereferences
snd_context unconditionally.

go7007_snd_init() returns -ENODEV once its never-decremented static card
counter reaches SNDRV_CARDS, so SNDRV_CARDS attach/detach cycles arm the
next attach; no memory pressure is needed.

Set go->audio_enabled only once go7007_snd_init() has succeeded.

  Oops: general protection fault, probably for non-canonical address ...
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  Workqueue: usb_hub_wq hub_event
  RIP: 0010:go7007_snd_remove (drivers/media/usb/go7007/snd-go7007.c:273)
  Call Trace:
   go7007_usb_disconnect (drivers/media/usb/go7007/go7007-usb.c:1336)
   usb_unbind_interface (drivers/usb/core/driver.c:461)
   device_remove (drivers/base/dd.c:618)
   device_release_driver_internal (drivers/base/dd.c:1349)
   bus_remove_device (drivers/base/bus.c:664)
   device_del (drivers/base/core.c:3965)
   usb_disable_device (drivers/usb/core/message.c:1478)
   usb_disconnect
   hub_event (drivers/usb/core/hub.c:5966)
   process_one_work (kernel/workqueue.c:3396)
   worker_thread (kernel/workqueue.c:3560)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  Kernel panic - not syncing: Fatal exception

Cc: stable@vger.kernel.org
Fixes: 866b8695d67e ("Staging: add the go7007 video driver")
Assisted-by: LLM
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/go7007/go7007-driver.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -306,10 +306,9 @@ int go7007_register_encoder(struct go700
 	if (ret < 0)
 		return ret;
 
-	if (go->board_info->flags & GO7007_BOARD_HAS_AUDIO) {
+	if ((go->board_info->flags & GO7007_BOARD_HAS_AUDIO) &&
+	    go7007_snd_init(go) == 0)
 		go->audio_enabled = 1;
-		go7007_snd_init(go);
-	}
 	return 0;
 }
 EXPORT_SYMBOL(go7007_register_encoder);


