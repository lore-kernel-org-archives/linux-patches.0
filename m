Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059586;
	b=DGlRL0372znzkgimuF/Da+sZatI80N7fVDT3TQkX6CsotrDGGys/4uI28WaTxEsBU+AY
	 Qm7eOvXu8JZ/lxS/S+JXCQCd7B8GXKMQMacaT6Yc0DzB09QYsUqVJyZs5o1StJ0l5V0SB
	 71hb1A0gGJJlgbQiRIwGwZ1r3UwGKQSYIb7K+u4tXdZAIt4pQ56tmljWcyqeMyBDo4OrX
	 2r3l71Dkc97BCPEutsrvAyZ518BmhEejhZ1V2oNuABaDDwvxujDZFfyYuAtmb/o5P4If5
	 +mW2RJJ9JBf4lIX7LUXrIIknpEh3Kv7pbbWWocqPhPabXIbqhxkXno60xP2Uj26Os0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zF1wYqvLigrTINedFwqM2k4SFyd1BIG4X3xK4bspwnU=;
	b=lk/i2GLrcNYHP0nU79tudVEih5IBhrC0H2EElVzQuU3EKgcHuGZnA/2cnjz8PG6i/taa
	 7vrhsdoU5HzAKv+d7kxwg4YtvAe2qVPkzUDFiBGmv36DurLRnKQCnyYUXJO34npI1Lvz1
	 EYlarL3sv0Cat/9sSHG+0ngupNJJz/XTgZYDFJaSUVXxcb6Zze9fX7VdEXdUMUn14/ePx
	 HUzHgHWGMVeBAgq/o+suGR3T3zU8hnHeSJF433eQLBJpeZ7zwkv8UF71pGJxJC1RHSCVP
	 mgJEGKngBCBegsvCnJcb1EABCYiKsCJsKRJJT6K2atIgqFJ0r6YdWGMwEa+HKZO0sdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKe2OzpQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557D360A2619;
	Thu, 19 Nov 2026 03:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKe2OzpQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5BA1F000C6;
	Thu, 19 Nov 2026 03:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059586;
	bh=zF1wYqvLigrTINedFwqM2k4SFyd1BIG4X3xK4bspwnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKe2OzpQ4PQuhNzcOYdRj7zxe2x+AndcFKdCAj8LQLwU/C73puWXqileNfaRLdUuO
	 iH1fgZOZCKKGuiOZ+18UC0QP/48CTctFuwWz+so3A2HPr3+koEbbsCnKQ+bm5T/RGN
	 C/mHUHWBwzWdgnQbfWLVfmDXq+Xx/ykPwujq+t3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0895/1848] fbdev: core: Initialize modelist in framebuffer_alloc()
Date: Wed, 18 Nov 2026 15:48:53 +0100
Message-ID: <20261118145954.072210131@linuxfoundation.org>
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
[ sashal: adjusted framebuffer_alloc() context due to the missing info->blank initialization ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbsysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index 65dae05fff8e6..30798dc64aa89 100644
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



