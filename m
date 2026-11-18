Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051722;
	b=yKE+d8P+5PHfs7yCWMcTYpcYu2S7iPbV8ZlgM/INEJsHc5UHZUyvjNJPu6KOJwd4V7yK
	 dpb3go6q2ecGutlbqc2sSxj9igjk4KZOsd3ajaxskLGys3fsGQTh9dDuM3IzWKmzKqph2
	 GtilUqeT21x9hCws0Lmxl1HLBIY7mYQo0+AYBqzgZxSPsy1nKONmsemLtzbz/zu2elrq2
	 Xoq0KmZ70OU2ravkU/JJ4ZJJZUea297HRMAhsP8Wffk542ZHIeg41aL7SzP9nFbdDkMFK
	 R2VIgUdhp5MoCgwoDZWdmFZBIwM2Y/W27kuJtVeT3h59JkYp5LZxC+stRd433jSVbFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hh0ksF/y1Jiw5mpG3Mgk9EhnHk/XepQ9gMLd1Vo4tlo=;
	b=ffY++PxDEAuQ/ee2jZmTRSl7SF58IaF7W59yDHu9MhL5h0YctDAjp0FXaP8Snzgc9+T/
	 +MsvkcIaK8akgdrf4HmsY1nZ1Hi2BQuEVoujB80FIcs0bkQdgmhcL+T5NODNR2Q5zFGG/
	 hDgK/jOMyybHMJ1NYWYhDbbn3lbAiViEMAYu+L+lrBgeUFqLKr8+8p4tnLafYGWEwYu3y
	 4dEaKyJnCHXyiqrSAe6WqzCDZLFu/kRE6/qdEno2oo/bkUW3p9zjKthLw52CBC1WkA7Us
	 46CMrCcK8w+9v9iJXU/JWSojaJcPgzluxegqbOrYeWe2UzIYWvQ+72/jH4sxJrAv29A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aA1p8tGg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9CF606A31C;
	Thu, 19 Nov 2026 01:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aA1p8tGg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2561F000C4;
	Thu, 19 Nov 2026 01:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051722;
	bh=Hh0ksF/y1Jiw5mpG3Mgk9EhnHk/XepQ9gMLd1Vo4tlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aA1p8tGg3qQ2c1s5bEsk7IRKzlpTXZHmu6c04Ta5/vPagTKrLYROgDB6XFL4Swwm9
	 srwc0G5yIQ3yW1J+6utOSYUg68mf5dfmibOBIUCI/1duVB4Bu9fWiz9bbwHMHijanZ
	 UEIY6WqV4VDJ5HBP7ilJ7JbDkm7xsqq9thppsz8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 0262/2214] media: go7007: only set audio_enabled if go7007_snd_init() succeeded
Date: Wed, 18 Nov 2026 15:32:18 +0100
Message-ID: <20261118150020.588820465@linuxfoundation.org>
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


