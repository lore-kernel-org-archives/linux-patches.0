Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044404;
	b=vhu2OSxAso9txCQ0RzFessgmFZBO6w7LGkjb/AZRCi54wJza1MqxXb2pvsYch7yt1REO
	 VV0YuuB1Y/tgVQQnsOc/dsGWXTeyQRZ+ASR6/PNemETCnZLGOeGu9JBZX3FI7GbP0aImQ
	 ooCKTDQvGYeLrofR3CFV9hXTMFFPYchchxF5oz8yy8dDxQYT90cHNFJkdp8aCq2U4C2Yd
	 HqqGm6fxWuVapuLMOp/CwNl0CvonNSceNehHjJrEJtu1Ytni9F+4uRT4CHgmRhruQc8vv
	 VaceRwnmEofuruXeCk6HSHK/jxKOrca/fjJT+vG0SEQFy0q1MKzbs+CMajU63/IgXTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uiAP4P/iBCJ2u3LeQnScpdhezUAuT70L1QH3pWZnHFo=;
	b=Kupo7ScQf3eS2+ePfMEbDL60N+nFD8fR87iOZ2dLfgj/4NlrGYnSSWU9TjTkzCUETucf
	 8IMnT8LuDI0OyKRTeDLA94x0AivWKv7QrQuOQK4TAoNh+3J+wGQc/NHJ6KaTheZKzc82x
	 hd4wXszlA5WuZeBzxD0sQV8WlO8GECMdoM5+izRytDPZv0Dn/XMB0d7+itbjavcpuj9Dm
	 9H/HpbXBBq9SuaSzD7MDQT4Mkkc5wYw9UlDvigoj43hXB2Pxkpe4I1efdt6nZ86n9Eu9u
	 tEmocAgvvh72gfaNwoV6btDrP9FaKlf6wCtplCQT2SkxqE+ghuve5ccuThd7rR0O97g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDcIJh4f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A82606A31C;
	Wed, 18 Nov 2026 23:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDcIJh4f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510B51F000C4;
	Wed, 18 Nov 2026 23:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044403;
	bh=uiAP4P/iBCJ2u3LeQnScpdhezUAuT70L1QH3pWZnHFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDcIJh4fMXQ5fdO5xe7F1REGAikGFb54e7VA1RZAiFEK6wYRGEIJ9dEXBVDU6quYq
	 /r7kVEt9b/l1Q3m+UqJyXFZopxJhMGbCzPmF0bs6wfViieUL3LzdfvvyJIfOdZOdEc
	 KuuXLkfBKEKnCleBxpbb8szw2Kc/PkpiHWBOVXHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+ed9902f2e44184d9@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0554/2857] fbdev: udlfb: dont rebuild the mode list while the framebuffer is in use
Date: Wed, 18 Nov 2026 15:26:28 +0100
Message-ID: <20261118150221.439059166@linuxfoundation.org>
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

commit ac9cfa552102b8e80e88c2872e80dc9cb5f07dda upstream.

dlfb_setup_modes() frees info->modelist with fb_destroy_modelist() and
rebuilds it, but fbcon holds raw pointers into that list in
fb_display[i].mode and nothing un-publishes them the way
do_unregister_framebuffer() and store_modes() do with
fbcon_delete_modelist(). The function does refuse to install a new mode
while the framebuffer has users (dlfb->fb_count != 0), but only after the
list is already destroyed. Reached from the 0666 "edid" sysfs attribute,
an unprivileged write to /sys/class/graphics/fb0/edid therefore fails with
-EINVAL and still leaves every fb_display[i].mode dangling; the next
console switch reads the freed fb_videomode in fb_videomode_to_var().

Test fb_count before touching the list. fbcon takes a reference through
fbcon_open(), so that condition covers exactly the states in which
fb_display[] points into the list, and the errno returned to userspace is
unchanged.

  BUG: KASAN: slab-use-after-free in fb_videomode_to_var (drivers/video/fbdev/core/modedb.c:905)
  Read of size 4 at addr ffff8880107b449c by task kworker/1:1/47
  Workqueue: events console_callback
  Call Trace:
   fb_videomode_to_var (drivers/video/fbdev/core/modedb.c:905)
   display_to_var (drivers/video/fbdev/core/fbcon.c:998)
   fbcon_switch (drivers/video/fbdev/core/fbcon.c:2182)
   redraw_screen (drivers/tty/vt/vt.c:994)
   complete_change_console (drivers/tty/vt/vt_ioctl.c:1141)
   console_callback (drivers/tty/vt/vt.c:3358)
   process_one_work (kernel/workqueue.c:3396)
   worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  ...
  The buggy address is located 28 bytes inside of
   freed 96-byte region [ffff8880107b4480, ffff8880107b44e0)

Cc: stable@vger.kernel.org
Fixes: 7d9485e2c53c ("Staging: udlfb: Add functions to expose sysfs metrics and controls")
Reported-by: co+ed9902f2e44184d9@bugs.sh
Closes: https://lore.kernel.org/all/1jSCSNaDKmuUG7h40rTsSl1rMaSwdlJef4rp%40bugs.sh/
Assisted-by: Claude:claude-opus-5
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://lore.kernel.org/all/1jSCSNaDKmuUG7h40rTsSl1rMaSwdlJef4rp%40bugs.sh/
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/udlfb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1336,6 +1336,11 @@ static int dlfb_setup_modes(struct dlfb_
 		goto error;
 	}
 
+	if (dlfb->fb_count) {
+		result = -EINVAL;
+		goto error;
+	}
+
 	fb_destroy_modelist(&info->modelist);
 	memset(&info->monspecs, 0, sizeof(info->monspecs));
 


