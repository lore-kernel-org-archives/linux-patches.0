Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059714;
	b=dI8ocmECXPMfId6mDMrDH0EzqP8We39jsCsVJ/wtDhv+RwJqf03dB93Qsqnj08gdp6+s
	 YOPKVHtkuKAp5kbMU9vbm4XQXjCadMAW+e3VxXj8vUQAJhhxbARDPCVTEpkuBHhrmcoo4
	 1DrbnLXtXiS1UYLpD8XWUcVnPDHNy2XVMwk+kaFwTfaUiU9Vn6jFyDov253icz2LMKUYM
	 N8yvDfQZJG7KYGx9PfsCoEOjUDswNicXA1nSJawKCPY+VWbKw3iW9i6a/+M4vfP3SKDcg
	 AA5ymMYpIoQWEkd6yO0hBWbVxZ0ife6zpZTb9LM8QMLrbeUreH/f6GerIR/RWr+XyOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wMFYTics+CRn+fhADhyVs5vr3CoIFV9z+KJotTs4mvI=;
	b=tYUoT1FtQxbL4jZMvTqb/z9vTK/r6uRz543gqkZClJqS5Hz/lRxFDjMNlfM53kpYy8T4
	 iaEv6yHqA3EFZvTJONs8DSe02FGnmTYLA+bEIxfjprOodLv4CbdPim5zf4ZLswBSCgW9N
	 sEIGRnYvo6vwUF/Rw2AppMYuzIQh+EB4utMH81lqAKSjSVsIjBzQZ6BswK2LG/26wOOKz
	 PHHEGksL4H4g4lqOF5eeyKoc3ho6fxQG8pIzokfYTIfxnaxjcI27vOn1cWg1Xi+0rlQ2s
	 eU2xnTaXLKw5pRVMNztzMGf4rtfBJp7R4jam3awaZy5FYVRP08ChiiYrlbRYYxqsh8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fgn/kSKM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8BF606A326;
	Thu, 19 Nov 2026 03:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fgn/kSKM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335611F000C4;
	Thu, 19 Nov 2026 03:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059713;
	bh=wMFYTics+CRn+fhADhyVs5vr3CoIFV9z+KJotTs4mvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgn/kSKMFXqWeXz1QkAXwGVLd8iCh5fPSaeZitGYiL4pTUvqVdB1o0STA6c6a5glk
	 /bxGCLTotbTRCB34c/sVHnJQN1mVZF9brbBhHzFzHidk5CYL4tfsorPv0Q7FURgTDb
	 4EVhoxadUMM9nVDjsZL9QI3VI7atqKDe0KexgxB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tingjie Zhong <catme0w@live.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0941/1848] fbdev: bitblit: Fix glyph clipping when fbcon pans
Date: Wed, 18 Nov 2026 15:49:39 +0100
Message-ID: <20261118145956.374673417@linuxfoundation.org>
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

From: Tingjie Zhong <catme0w@live.cn>

[ Upstream commit 06fccf840640d8f6b0e08a1756f8d2f0435b4cbe ]

Commit 3637d34b35b2 ("fbdev: Add bounds checking in bit_putcs to fix
vmalloc-out-of-bounds") made bit_putcs() clip glyphs to var.yres. When
fbcon scrolls by panning, it draws text rows up to var.yres_virtual,
so after the first pan most new text is not drawn until the next full
redraw. This affects fbdev drivers that set FBINFO_HWACCEL_YPAN or
FBINFO_HWACCEL_YWRAP, such as vesafb with the ypan option, when
CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION=y.

Clip to GETVYRES() instead, which fbcon_ud.c and fbcon_ccw.c already
use as the drawing area height. When fbcon does not pan, GETVYRES()
returns var.yres, keeping the existing bound. When fbcon pans, it
returns var.yres_virtual, which the framebuffer memory must cover
anyway for panning to work.

Fixes: 3637d34b35b2 ("fbdev: Add bounds checking in bit_putcs to fix vmalloc-out-of-bounds")
Reported-by: Thomas Zimmermann <tzimmermann@suse.de>
Closes: https://lore.kernel.org/linux-fbdev/b8b52ffd-ecec-4fba-b432-ba32135c2f99@suse.de/
Tested-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Tingjie Zhong <catme0w@live.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
[ sashal: Changed struct fbcon_par to the older struct fbcon_ops type. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/bitblit.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/bitblit.c b/drivers/video/fbdev/core/bitblit.c
index c36f92965e0de..fbc05fbbd82a2 100644
--- a/drivers/video/fbdev/core/bitblit.c
+++ b/drivers/video/fbdev/core/bitblit.c
@@ -18,6 +18,7 @@
 #include <linux/console.h>
 #include <asm/types.h>
 #include "fbcon.h"
+#include "fbcon_rotate.h"
 
 /*
  * Accelerated handlers.
@@ -151,7 +152,9 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 		      const unsigned short *s, int count, int yy, int xx,
 		      int fg, int bg)
 {
+	struct fbcon_ops *par = info->fbcon_par;
 	struct fb_image image;
+	u32 vyres = GETVYRES(par->p, info);
 	u32 width = DIV_ROUND_UP(vc->vc_font.width, 8);
 	u32 cellsize = width * vc->vc_font.height;
 	u32 maxcnt = info->pixmap.size/cellsize;
@@ -168,10 +171,10 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 	image.height = vc->vc_font.height;
 	image.depth = 1;
 
-	if (image.dy >= info->var.yres)
+	if (image.dy >= vyres)
 		return;
 
-	image.height = min(image.height, info->var.yres - image.dy);
+	image.height = min(image.height, vyres - image.dy);
 
 	if (attribute) {
 		buf = kmalloc(cellsize, GFP_ATOMIC);
-- 
2.53.0



