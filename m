Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590145;
	b=m2ZbOfMQU14rq5QiIYeoGFvBc8tlbalhO5uzZS+NR1RbEhzl49o4snOgTiIJVKxZ9wV9
	 CqxbZOfytsDi4ytPQ2vXUuN6uEiHBog50cs6z1JfwqSiAJO39OxvouSskcJ3BEeEF+al3
	 JcDkVSLKFGfzdIFVT2em905LhWJlnilMfq/LohXiK2w5uNXuNlGUWpsRvS7r/++nRnXD7
	 V+H6F9diWvH0ZW38tT0ohh7r3IHODuXj//5bItQhrdXcblrbZk8t/pZsEto66uxyDI9Df
	 uP0zDRe/Lu6EuARTP4GXQ9vMtcq2+zXuUpAB2L9EIKQtuVSIyW4nkBfg2ofwms4M4kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r7jfxlOOfW99E85TKBtgI0w2BofSiHh2bwzIHHx5TW0=;
	b=BgE4fOvWp5RvoeU8JyOXGHaYi8bCvZ/K5QY+XBZTMlb+Cm4t6CmKYuaf87CP7OLIXYRZ
	 1iRAVXqOT4xslvTypkuIiVywcMyPeA+kdpvvMUv+Ozs6Sp6SEmiZcj1trYwwqKdpj+zEw
	 EOkDqwy6Zde6r4pgoVrbwIg8luc0/yw+L7kj27gE3CUpn2fy85f8vG4JjOt9+nH4LB9j1
	 SPMVcftnXCs4xnILIW+3JaeyvwuNvad2CymOxiG48wwJfBUcyOJt/Zhp394nmQ8xZr3sF
	 NrUkuja2ejvAa4tY3bgyW+eMGBJNPSugMZeS6lAj6DLc+rsWG4lvnj1bOAx714kWqLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XU9+ywL6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83318606D482;
	Fri, 13 Nov 2026 17:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XU9+ywL6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303B11F000C4;
	Fri, 13 Nov 2026 17:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590145;
	bh=r7jfxlOOfW99E85TKBtgI0w2BofSiHh2bwzIHHx5TW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XU9+ywL6eWoTjDpRZye9rJJWBwidb+F37ag3UmiywB0qz4tOF4dCvpgrEZZ0Fa1e/
	 2eyyNk2/YtAYBJyvn8a6ymcjlOMKlrohOC5SfrHYksPB9y9cf5arG8NZFClI+Dw7eq
	 KoZNuzOY6brU8hoKvR5zlL9zN0MxzAmS4suXIw8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/686] fbdev: core: Initialize modelist in framebuffer_alloc()
Date: Fri, 13 Nov 2026 10:44:54 -0500
Message-ID: <20261113153826.239907281@linuxfoundation.org>
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

From: Andrey Misiurov <andrey.misyrov@gmail.com>

[ Upstream commit 0c9cb9321cb3863b52bdea4b8ae5a27705762c9e ]

framebuffer_alloc() returns zeroed memory, so info->modelist starts out
with NULL next and prev pointers. The list head is initialized only
later, by fb_videomode_to_modelist() or by do_register_framebuffer().

The "fix potential memory leak" commits listed below added
fb_destroy_modelist(&info->modelist) to the probe error paths of s3fb,
tdfxfb, tridentfb, i740fb and carminefb. These paths can run before
the list head is initialized:

 - s3fb, tdfxfb, tridentfb and i740fb call fb_videomode_to_modelist()
   only after a successful EDID read, and tridentfb can also hit the
   error path on an ioremap() or kmalloc() failure before that;
 - carminefb jumps to the error path when fb_find_mode() fails, before
   its fb_videomode_to_modelist() call.

fb_destroy_modelist() then dereferences the NULL head. Reproduced on
Debian 12 (6.1.180) by binding s3fb to a VGA device without EDID and
forcing fb_alloc_cmap() to fail:

  s3fb 0000:00:03.0: cannot allocate colormap
  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:fb_destroy_modelist+0x10/0x80
  Call Trace:
   s3_pci_probe.cold+0x12b/0x2bf [s3fb]
   local_pci_probe+0x41/0x80
   pci_device_probe+0xc3/0x240
   really_probe+0xde/0x380
   __driver_probe_device+0x84/0x150
   driver_probe_device+0x1f/0x90
   __driver_attach+0xce/0x1c0
   bus_for_each_dev+0x87/0xd0
   bus_add_driver+0x1ae/0x200
   driver_register+0x89/0xe0
   do_one_initcall+0x59/0x220
   do_init_module+0x4a/0x1f0

Initialize the list head in framebuffer_alloc(), so info->modelist is
always a valid, possibly empty, list and fb_destroy_modelist() is safe
on every error path. Keep the lazy initialization in
do_register_framebuffer(), as drivers that embed struct fb_info rather
than calling framebuffer_alloc() still depend on it.

Fixes: 3b0ed04bc852 ("fbdev: s3fb: fix potential memory leak in s3_pci_probe()")
Fixes: bb019d755366 ("fbdev: tdfxfb: fix potential memory leak in tdfxfb_probe()")
Fixes: 7a35ec619d9a ("fbdev: tridentfb: fix potential memory leak in trident_pci_probe()")
Fixes: 5936063409af ("fbdev: i740fb: fix potential memory leak in i740fb_probe()")
Fixes: 6fcca16a2b19 ("fbdev: carminefb: fix potential memory leak in alloc_carmine_fb()")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fb_info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/core/fb_info.c b/drivers/video/fbdev/core/fb_info.c
index 52f9bd2c5417a..05988a936bebb 100644
--- a/drivers/video/fbdev/core/fb_info.c
+++ b/drivers/video/fbdev/core/fb_info.c
@@ -43,6 +43,7 @@ struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
 	info->device = dev;
 	info->fbcon_rotate_hint = -1;
 	info->blank = FB_BLANK_UNBLANK;
+	INIT_LIST_HEAD(&info->modelist);
 
 #if IS_ENABLED(CONFIG_FB_BACKLIGHT)
 	mutex_init(&info->bl_curve_mutex);
-- 
2.53.0



