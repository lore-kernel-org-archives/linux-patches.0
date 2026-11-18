Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052814;
	b=R5BCPFqB3rSFNgpnlFMF3jC13tpANeKrwG6uIS9qO48wATcfjVmpBXotQEQWsWzOq1uS
	 BY5IO/E36NcIr3y7cGLeJ4GLsn+kJrLIoX7lKd5RMYOqc2UVsIIwXVnfQ5lHrmN//Nj/g
	 1pD6JkxF1QYCODOlyirFZokuvdcHBVQAnzJUy+/42CRHIII2PhM8HbXVVVloBYxLxnZEb
	 e0njN8iqbB/61VyqooK7IetSW4dwKXiXq+BtAdqH9t4iyHLVfIQDczwykOzZXNybt9osn
	 OWoxFGmrQdpfc358s4QIS9w8juFbBUlK5zBC2HBLEqrp1WuVVjm07+Z5l8O1MMb9Z0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VXPdRpfKuGWN4NPid/Lq4ZdhrSeGM31CXuKgG8goYX4=;
	b=aQ4Le5AziaRwt7X5RhJwIlwz4Q1NAR6n1R8zCLcqsEuVAmzyltzt9ewGPfKWthLb4DMG
	 UpOCd0xSATdhbgmEeG4cPRJvFTvL55NiMRxchKF5JfMg8I3PzJB/AJLO1MGgw0Wnb7Hvy
	 u0pyUWvfb4O7CIb4532wCsTB6JS1nEF54aZoYQFhq50UtJHGZ4dyPlk7wT9e2prdKh9g9
	 YhHSF7lu5MjWmDlbUjsdOwdWXmGRq2foyqtWMnuSL4ujINxVu2/RArd8LN7Db2aUsV5Ug
	 PDZIgWJb2I5ZVR9NYZo9tk23fefvIGNsPUHnuI8qV0+UWuBBobBz6C9iv6JnViHfgJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWwdv2IL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A577606A31C;
	Thu, 19 Nov 2026 01:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWwdv2IL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7A01F000C4;
	Thu, 19 Nov 2026 01:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052814;
	bh=VXPdRpfKuGWN4NPid/Lq4ZdhrSeGM31CXuKgG8goYX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWwdv2ILIJKd7kTSKMnDkLXbQOb1xZ5W++sQVMQt2qAFFeDY9yMkat1K93fXtNWVc
	 0C6GiW87Rp2MGfSjJhlBCobtc9NrcxD9coac34Ea6Q+bjv0l0NjR1V+RCCQ7Nqceh6
	 +M0bsenJx05vA7ooP2NNSa15Zvdg5hiLAgMz3wy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tingjie Zhong <catme0w@live.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0681/2214] fbdev: bitblit: Fix glyph clipping when fbcon pans
Date: Wed, 18 Nov 2026 15:39:17 +0100
Message-ID: <20261118150039.013015636@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/bitblit.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/bitblit.c b/drivers/video/fbdev/core/bitblit.c
index d2e1e63117b26..dc165b62e7f0a 100644
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
+	struct fbcon_par *par = info->fbcon_par;
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



