Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8840E3C1967;
	Thu, 15 Jan 2026 17:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498577; cv=none; b=bf33M4GZWOfwL52JntjYlrPEbQlZpTNfjgnYW3AAXkD23onLjzkQovdpqUwyZIbz7FocPEsL8r4ItQPM3NtHx+ci0UJg4Ej+rEZ+hgT0hrRcdsg6V6SyMwnAFN6Y+7TrDOd8VtGa/1FMohLuR6QvhN6ovGaBlnSoQ/AoZOUts/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498577; c=relaxed/simple;
	bh=1UQgR+y9q/y5mjquLJ8qbpgrHFmvF5pK24VEjbvReRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzT6Tc03vfSmv1K4ZlELU5EzpivE5sKJmmRWQuS0dsMzjR+TQWIDxYPFQyRH3HalZu/fP5vYY0SFZfGmli9rRD0tFmRwsRkaVIZ57U/LEqbh3th2nmUpLGfZGyJl/oC7J+iAn0BIJjPNZw2+10FqBBbfLp2dgpx2Ot3NHI42FDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2KY3pHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2KY3pHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E16C16AAE;
	Thu, 15 Jan 2026 17:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498577;
	bh=1UQgR+y9q/y5mjquLJ8qbpgrHFmvF5pK24VEjbvReRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2KY3pHZI8B5Pi0Yt/Ma0RfqTDYoE80PbBkqijnEGiRISj5pPotmYHVT3J0xJZxsF
	 NcX/5MppYuhJ3KSiH4y9jkiTkX6kE4o2ww+S6o51fH7+kI6ccFa4VZwYKaKlZsSIfa
	 hO1Utov2r78gCR5AwJufCWwLGDz4fgLY1BiCtKmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Stefan Christ <contact@stefanchrist.eu>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 480/554] drm/gma500: Remove unused helper psb_fbdev_fb_setcolreg()
Date: Thu, 15 Jan 2026 17:49:06 +0100
Message-ID: <20260115164303.682571701@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit be729f9de6c64240645dc80a24162ac4d3fe00a8 ]

Remove psb_fbdev_fb_setcolreg(), which hasn't been called in almost
a decade.

Gma500 commit 4d8d096e9ae8 ("gma500: introduce the framebuffer support
code") added the helper psb_fbdev_fb_setcolreg() for setting the fbdev
palette via fbdev's fb_setcolreg callback. Later
commit 3da6c2f3b730 ("drm/gma500: use DRM_FB_HELPER_DEFAULT_OPS for
fb_ops") set several default helpers for fbdev emulation, including
fb_setcmap.

The fbdev subsystem always prefers fb_setcmap over fb_setcolreg. [1]
Hence, the gma500 code is no longer in use and gma500 has been using
drm_fb_helper_setcmap() for several years without issues.

Fixes: 3da6c2f3b730 ("drm/gma500: use DRM_FB_HELPER_DEFAULT_OPS for fb_ops")
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Stefan Christ <contact@stefanchrist.eu>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.10+
Link: https://elixir.bootlin.com/linux/v6.16.9/source/drivers/video/fbdev/core/fbcmap.c#L246 # [1]
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://lore.kernel.org/r/20250929082338.18845-1-tzimmermann@suse.de
[ adapted patch from fbdev.c to framebuffer.c where the function was named psbfb_setcolreg() instead of psb_fbdev_fb_setcolreg() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/framebuffer.c |   42 -----------------------------------
 1 file changed, 42 deletions(-)

--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -35,47 +35,6 @@ static const struct drm_framebuffer_func
 	.create_handle = drm_gem_fb_create_handle,
 };
 
-#define CMAP_TOHW(_val, _width) ((((_val) << (_width)) + 0x7FFF - (_val)) >> 16)
-
-static int psbfb_setcolreg(unsigned regno, unsigned red, unsigned green,
-			   unsigned blue, unsigned transp,
-			   struct fb_info *info)
-{
-	struct drm_fb_helper *fb_helper = info->par;
-	struct drm_framebuffer *fb = fb_helper->fb;
-	uint32_t v;
-
-	if (!fb)
-		return -ENOMEM;
-
-	if (regno > 255)
-		return 1;
-
-	red = CMAP_TOHW(red, info->var.red.length);
-	blue = CMAP_TOHW(blue, info->var.blue.length);
-	green = CMAP_TOHW(green, info->var.green.length);
-	transp = CMAP_TOHW(transp, info->var.transp.length);
-
-	v = (red << info->var.red.offset) |
-	    (green << info->var.green.offset) |
-	    (blue << info->var.blue.offset) |
-	    (transp << info->var.transp.offset);
-
-	if (regno < 16) {
-		switch (fb->format->cpp[0] * 8) {
-		case 16:
-			((uint32_t *) info->pseudo_palette)[regno] = v;
-			break;
-		case 24:
-		case 32:
-			((uint32_t *) info->pseudo_palette)[regno] = v;
-			break;
-		}
-	}
-
-	return 0;
-}
-
 static vm_fault_t psbfb_vm_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -147,7 +106,6 @@ static int psbfb_mmap(struct fb_info *in
 static const struct fb_ops psbfb_unaccel_ops = {
 	.owner = THIS_MODULE,
 	DRM_FB_HELPER_DEFAULT_OPS,
-	.fb_setcolreg = psbfb_setcolreg,
 	.fb_fillrect = drm_fb_helper_cfb_fillrect,
 	.fb_copyarea = drm_fb_helper_cfb_copyarea,
 	.fb_imageblit = drm_fb_helper_cfb_imageblit,


