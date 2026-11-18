Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043724;
	b=yJ54eGpxAcwTT404INr1HbCPnhcFQcFkldNXeijc9gx2S7rgqKzPE5v/0Qs2wpDWXgCY
	 89BSIhI7cv/90vhnQsP3iKtlYpmsTlsdYXGfDjQMtbbk1zc7+UbORjLkfdukiB8FpW/Pd
	 wpdqKt/hXIsePQlh9pLQFDmjg8ZjurcvztBbWvmz7EJjkZVIQfDXFVHspRI5gop1UX9s4
	 S9aQsqjIcBtMJLJD+v7RYhu9arxVyw0UM97JZ8LXAXSQX+y5ITQPf+OIarzmHNU98y43g
	 /BymJ41yOqNULckYCdI+OF9vwjJkZ4hNBsPas0NkeK3+GAlfuFaasGfp76vvsO3AIVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CVeB651fBWPhiH9x+iWba8hROffTBdyexH96pmIBMec=;
	b=iuTX7GP+ChB1VVkdEZcQ2OEjd1aqrSPx7OvdTAsCpy9+dzIUKRJu9IU2E2EukY2PhtOk
	 XHoD8YHQ5bnOLmW0/FaLoe+RGtTPZvckR0K6TQisrcUvoSeuLpS7a+5yVckQRoxTy2mIq
	 iVfBb7DZ0RSRZ+mwKTqm413qPHN24FsrH5G4AzL1rKPAF6Ixn8L5YxeGeDmeLoxcOw+ou
	 0v6/d+ADPYjTE9D7tWnQHsmwRmenNQvMEpmEIl+MX1H8rUfOOnyCe5y2ZDpkWiaWtkvvm
	 V0UwOjDgdm9X7Yh3wYJckLOliEb0m3MlRpHwUlzd8Q7gyZ3hajPCIv7/rNeVo4l4IPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4jbHTL2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B624606A31C;
	Wed, 18 Nov 2026 23:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4jbHTL2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DB31F000C5;
	Wed, 18 Nov 2026 23:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043723;
	bh=CVeB651fBWPhiH9x+iWba8hROffTBdyexH96pmIBMec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4jbHTL26tFdjIsvksIWIHv0F/pf6fMZ9NtIICYtD8IGE9csc2GrI1IEHVfkBfhXN
	 r7pmKHMUqXXYo+aIg6wcBBZ/8+VUJa0GMBDnvJ98MQMNKMUYk20EN8awqeEENpTxrc
	 giDw+moW0CtBfvuDyMHJj2JEJANLtj5uCSGEf5K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0311/2857] media: go7007: only set audio_enabled if go7007_snd_init() succeeded
Date: Wed, 18 Nov 2026 15:22:25 +0100
Message-ID: <20261118150212.642025515@linuxfoundation.org>
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


