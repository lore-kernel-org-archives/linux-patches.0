Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B621AC24F;
	Thu,  6 Jun 2024 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683331; cv=none; b=g3Cuk9y1HkUThvU842DAgJjOsIL5EDh1pQMmQIyDdWQe72bmuebzzZuGU+OXeQ39SAp0xAUI3U43sS8rdFCfr0dpL+Bm5cEYuj2hd/Y8gtPSmBB6VWIpar4Itdju4XHvLOKSgrt7D0mVHt6Q5TZpgaqWk3ZlaB+gp6ZLkf1eG1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683331; c=relaxed/simple;
	bh=FQ1MZ/I9IOmvhbI1AdZUaz+JQD1b4tBOTOTeYs4jdME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWvV7vBJ6g5/iYJ3lWTpeQ0i3IdzHJvy4vEAhKIHHn1KDdJ77r0Yey8gor9k5icuMXrts3S/qcKXwjEPpX/fBEx1yqbc2Y+dDKCIRvCkeaX8+dq9+1bVJZgaPg7qOl40PXaTp/ASnDlMZ7dII7gHicM59JH/qOxQO8RPwnVyV1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NaF2N+3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NaF2N+3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EF2C32781;
	Thu,  6 Jun 2024 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683330;
	bh=FQ1MZ/I9IOmvhbI1AdZUaz+JQD1b4tBOTOTeYs4jdME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NaF2N+3CiC8udX1lsLR/M/ymweEJM/ZWXPr/sC32vafeCvpXwVfOP4cGr9cJeQEVE
	 swl7MYyfXtoTnZ1MNubcY6vQ6ss4+UirHbPF0E3watg3gpZ73AC6Wssk+EH1ltuYMf
	 6bhE5+pgJbN1O7df5KTSWQWj40FSsaz7YLowZWK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 272/744] fbdev: Provide I/O-memory helpers as module
Date: Thu,  6 Jun 2024 15:59:04 +0200
Message-ID: <20240606131741.096823247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 6b180f66c0dd6266eeb2f74b59ee79a9f14fe430 ]

Provide helpers for accessing I/O memory in a helper module. The fbdev
core uses these helpers, so select the module unconditionally for fbdev.
Drivers will later be able to select the module individually and the
helpers will become optional.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230927074722.6197-2-tzimmermann@suse.de
Stable-dep-of: 01c0cce88c54 ("drm/omapdrm: Fix console with deferred ops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/Kconfig      | 6 ++++++
 drivers/video/fbdev/core/Makefile     | 3 ++-
 drivers/video/fbdev/core/fb_io_fops.c | 3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/Kconfig b/drivers/video/fbdev/core/Kconfig
index 5ac1b06375311..56f721ebcff05 100644
--- a/drivers/video/fbdev/core/Kconfig
+++ b/drivers/video/fbdev/core/Kconfig
@@ -4,6 +4,7 @@
 #
 
 config FB_CORE
+	select FB_IOMEM_FOPS
 	select VIDEO_CMDLINE
 	tristate
 
@@ -144,12 +145,17 @@ config FB_DMAMEM_HELPERS
 	select FB_SYS_FOPS
 	select FB_SYS_IMAGEBLIT
 
+config FB_IOMEM_FOPS
+	tristate
+	depends on FB_CORE
+
 config FB_IOMEM_HELPERS
 	bool
 	depends on FB_CORE
 	select FB_CFB_COPYAREA
 	select FB_CFB_FILLRECT
 	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_FOPS
 
 config FB_SYSMEM_HELPERS
 	bool
diff --git a/drivers/video/fbdev/core/Makefile b/drivers/video/fbdev/core/Makefile
index edfde2948e5c8..d165055ec3fc5 100644
--- a/drivers/video/fbdev/core/Makefile
+++ b/drivers/video/fbdev/core/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_FB_NOTIFY)           += fb_notify.o
 obj-$(CONFIG_FB_CORE)             += fb.o
 fb-y                              := fb_info.o \
                                      fbmem.o fbcmap.o \
-                                     modedb.o fbcvt.o fb_cmdline.o fb_io_fops.o
+                                     modedb.o fbcvt.o fb_cmdline.o
 ifdef CONFIG_FB
 fb-y                              += fb_backlight.o fbmon.o
 endif
@@ -26,6 +26,7 @@ endif
 obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
 obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
 obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimgblt.o
+obj-$(CONFIG_FB_IOMEM_FOPS)    += fb_io_fops.o
 obj-$(CONFIG_FB_SYS_FILLRECT)  += sysfillrect.o
 obj-$(CONFIG_FB_SYS_COPYAREA)  += syscopyarea.o
 obj-$(CONFIG_FB_SYS_IMAGEBLIT) += sysimgblt.o
diff --git a/drivers/video/fbdev/core/fb_io_fops.c b/drivers/video/fbdev/core/fb_io_fops.c
index 5985e5e1b040c..871b829521af3 100644
--- a/drivers/video/fbdev/core/fb_io_fops.c
+++ b/drivers/video/fbdev/core/fb_io_fops.c
@@ -131,3 +131,6 @@ ssize_t fb_io_write(struct fb_info *info, const char __user *buf, size_t count,
 	return (cnt) ? cnt : err;
 }
 EXPORT_SYMBOL(fb_io_write);
+
+MODULE_DESCRIPTION("Fbdev helpers for framebuffers in I/O memory");
+MODULE_LICENSE("GPL");
-- 
2.43.0



