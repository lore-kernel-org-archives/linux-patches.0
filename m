Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053850;
	b=IswN+45mR9zcymqZ8fdsQhRE5rDecCNVJHPhHOmDZHT+VS4BWNjerqD7vQO5z43cLaqB
	 eBblgOBtHbiDxgT38YXLmzBfR/HIeQ0WFJVt8DhONs4j1srrvJXlCRfw/Z5Yh/2QtTv4+
	 wipqrOpOzkzqSmzfwhileWDF4wWtYEoNb8fuy9Rm5wO11Rk/d5bhEuU0pDp3LNnh6fyOq
	 JvcuVhxmTEfXTXkc62aSRexZVCrDR4TheG2Aqcz1ukI0YAyG8V24qegQkxmvavJ2JhsX5
	 6DjBHIBwReTYGokQ0MborktBpyXUiXOsgQT/wFWZG2lMa++D/smthFRH++TopHV4uoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I59n0YhSix6FVcbvHvZcxm0clMI0c42k/sHk7EJ/oZE=;
	b=KZwNvf/v8dtT62p7qFMwk7ZqOi5NS+UEUSCJNqZ5sOzQjxSvja4+9H1soRSdndEnLPur
	 y/4IJAFN3ViR+MRGDB6mjY1mmaeLHk6CYyhsVtCv2VVWl1N8iBlVR8B2KXcNDqXRLeQ82
	 c1PMhH3XjMfHCwTxSN3B6sR0GlNUfCdaEvgLK3jwr9BqU5YiuiYcFzj81MryS0EHnZzsL
	 n9Da+alpRhn/qNJHmYyLMPKN1sYFs7SIfmXFpHeIUYnxsnYkTvrcIgncCO2uxH6Up4Vpj
	 fjvV11I/lydfpKpC3bHFYgduF0J9/ebPTfbCBQxLd4gj3mGWiChRxdpXF/pt8623n+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nw25JBdG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F63606A32C;
	Thu, 19 Nov 2026 02:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nw25JBdG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A2E1F000C4;
	Thu, 19 Nov 2026 02:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053850;
	bh=I59n0YhSix6FVcbvHvZcxm0clMI0c42k/sHk7EJ/oZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nw25JBdGxOVCKSEGdyOxsBicbEqqHVjQtHnHQ4K6dUqDyoFXs9CK4B88W4/59zfVY
	 WrN0wkkkG4UnTClrSMZdMG2xzammgfQw2biPeN3vAtHt/t/Ent6jCghVBkttPGIwm7
	 PvSpa5laCzyg/sfKUOAmE0dYf3wrXSuaowycioRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1063/2214] fbdev: core: Initialize modelist in framebuffer_alloc()
Date: Wed, 18 Nov 2026 15:45:39 +0100
Message-ID: <20261118150054.818776329@linuxfoundation.org>
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
[ sashal: adjusted framebuffer_alloc() context due to the missing info->blank assignment ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbsysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index 09ee27e7fc25f..1117127402e82 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -56,6 +56,7 @@ struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
 
 	info->device = dev;
 	info->fbcon_rotate_hint = -1;
+	INIT_LIST_HEAD(&info->modelist);
 
 #if IS_ENABLED(CONFIG_FB_BACKLIGHT)
 	mutex_init(&info->bl_curve_mutex);
-- 
2.53.0



