Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246F411715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C4EC433C8;
	Mon, 11 Sep 2023 15:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445075;
	bh=aq3R/anmz1mo7cG/7mawEwk3Hf7qPT+6lB5P+KMSPUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMxpLgJs7WN0Y6CjGkwrOD8flrtdctpdjAyM4tnVh3kslndg7Qtq8WrIw7Dlpia3s
	 qEiydoR9dcGDQVKGKmZlPUdgXzbrcfybKVGEILHxOIu9jU1cNl7KJDofdepsEYCThr
	 ni6X82F9SHG2RjNt6kGX2stUyaEgYGydnlmQ8OkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sui Jingfeng <suijingfeng@loongson.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 219/600] drm/hyperv: Fix a compilation issue because of not including screen_info.h
Date: Mon, 11 Sep 2023 15:44:12 +0200
Message-ID: <20230911134640.080937556@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sui Jingfeng <suijingfeng@loongson.cn>

[ Upstream commit 8d1077cf2e43b15fefd76ebec2b71541eb27ef2c ]

Fixes the following build errors on arm64:

drivers/video/fbdev/hyperv_fb.c: In function 'hvfb_getmem':
>> drivers/video/fbdev/hyperv_fb.c:1033:24: error: 'screen_info' undeclared (first use in this function)
    1033 |                 base = screen_info.lfb_base;
         |                        ^~~~~~~~~~~
drivers/video/fbdev/hyperv_fb.c:1033:24: note: each undeclared identifier is reported only once for each function it appears in

>> drivers/gpu/drm/hyperv/hyperv_drm_drv.c:75:54: error: 'screen_info' undeclared (first use in this function)
      75 |         drm_aperture_remove_conflicting_framebuffers(screen_info.lfb_base,
	 |                                                      ^~~~~~~~~~~
drivers/gpu/drm/hyperv/hyperv_drm_drv.c:75:54: note: each undeclared identifier is reported only once for each function it appears in

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202307090823.nxnT8Kk5-lkp@intel.com/
Fixes: 81d2393485f0 ("fbdev/hyperv-fb: Do not set struct fb_info.apertures")
Fixes: 8b0d13545b09 ("efi: Do not include <linux/screen_info.h> from EFI header")
Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230709100514.703759-1-suijingfeng@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hyperv/hyperv_drm_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
index 29ee0814bccc8..68050409dd26c 100644
--- a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
@@ -7,6 +7,7 @@
 #include <linux/hyperv.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/screen_info.h>
 
 #include <drm/drm_aperture.h>
 #include <drm/drm_atomic_helper.h>
-- 
2.40.1



