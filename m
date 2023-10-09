Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AA714013
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EELSyNzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAE3C433C8;
	Mon,  9 Oct 2023 13:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859331;
	bh=4wBfuv8KeJItGpAGDFIztXcurIekS7yrPpZh9FiubE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EELSyNzRs4nakJAeQ918mhP8SlGnGh6wz9wSHi7T8IDe4xiBSGR8XYo1GfDZX4ySz
	 ZRqDHQ7hIy1cLtnDNHsMZKEb4Lof6FRZpuvQy6a2Gr7rbjcBbWxG6VjfiUSHr5onpI
	 c7Vchjnv9l6gh+ofiEV0uJX0CWOnaBFe1kAdpL2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/55] fbdev/sh7760fb: Depend on FB=y
Date: Mon,  9 Oct 2023 15:06:16 +0200
Message-ID: <20231009130108.369460426@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit f75f71b2c418a27a7c05139bb27a0c83adf88d19 ]

Fix linker error if FB=m about missing fb_io_read and fb_io_write. The
linker's error message suggests that this config setting has already
been broken for other symbols.

  All errors (new ones prefixed by >>):

     sh4-linux-ld: drivers/video/fbdev/sh7760fb.o: in function `sh7760fb_probe':
     sh7760fb.c:(.text+0x374): undefined reference to `framebuffer_alloc'
     sh4-linux-ld: sh7760fb.c:(.text+0x394): undefined reference to `fb_videomode_to_var'
     sh4-linux-ld: sh7760fb.c:(.text+0x39c): undefined reference to `fb_alloc_cmap'
     sh4-linux-ld: sh7760fb.c:(.text+0x3a4): undefined reference to `register_framebuffer'
     sh4-linux-ld: sh7760fb.c:(.text+0x3ac): undefined reference to `fb_dealloc_cmap'
     sh4-linux-ld: sh7760fb.c:(.text+0x434): undefined reference to `framebuffer_release'
     sh4-linux-ld: drivers/video/fbdev/sh7760fb.o: in function `sh7760fb_remove':
     sh7760fb.c:(.text+0x800): undefined reference to `unregister_framebuffer'
     sh4-linux-ld: sh7760fb.c:(.text+0x804): undefined reference to `fb_dealloc_cmap'
     sh4-linux-ld: sh7760fb.c:(.text+0x814): undefined reference to `framebuffer_release'
  >> sh4-linux-ld: drivers/video/fbdev/sh7760fb.o:(.rodata+0xc): undefined reference to `fb_io_read'
  >> sh4-linux-ld: drivers/video/fbdev/sh7760fb.o:(.rodata+0x10): undefined reference to `fb_io_write'
     sh4-linux-ld: drivers/video/fbdev/sh7760fb.o:(.rodata+0x2c): undefined reference to `cfb_fillrect'
     sh4-linux-ld: drivers/video/fbdev/sh7760fb.o:(.rodata+0x30): undefined reference to `cfb_copyarea'
     sh4-linux-ld: drivers/video/fbdev/sh7760fb.o:(.rodata+0x34): undefined reference to `cfb_imageblit'

Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309130632.LS04CPWu-lkp@intel.com/
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230918090400.13264-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index a7e8db955ef67..30654608297f1 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2197,7 +2197,7 @@ config FB_COBALT
 
 config FB_SH7760
 	bool "SH7760/SH7763/SH7720/SH7721 LCDC support"
-	depends on FB && (CPU_SUBTYPE_SH7760 || CPU_SUBTYPE_SH7763 \
+	depends on FB=y && (CPU_SUBTYPE_SH7760 || CPU_SUBTYPE_SH7763 \
 		|| CPU_SUBTYPE_SH7720 || CPU_SUBTYPE_SH7721)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
-- 
2.40.1



