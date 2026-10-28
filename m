Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216038;
	b=NXnEEZ4TB96CXA/dkZDGJWIEi7uIccwDsk3tT1h+MNDn+C7nIbcvnMYK6bGfAFUdFaiE
	 wYoGZxCqfoMY15OZr7wht/UcU0QoR2mhaPI12ztaZTJGaIm7kqqSfpco0JDC0i4GhtGe9
	 +0LceULJh63RAfo7L80LqsS5pZI4VM4XBGtcWJ98Ou6Lp1AgTX0vPzaB7qWwfUeubAmKp
	 qA/VKeTWmlNmOxM/Uqwh2KQ3Lj/RYmWdoVMPhrkfabpomFS2wKbB54N1Ms+PlPUsFgWfk
	 i3b4yavns4dEFziPRTATicuBgZnGpz/VgJSCSh79o3I9Blx+H27O3cG2EEuLsD4je4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tlGHzF15xrf36oozBcuE0hQl6pbqozZRaaGJYlL0CQE=;
	b=wlbcK1k2lXLiDLWROQBQUcIdjiTT6aJ52B1LVal2HHduCEZBvdbB6MA4meLofAHJp3fR
	 /LnzOuvLuiBJ3q0xvUpvHJu8SsasxRY0eea0rZc1FvmOnL3oXLfxfgS09C7ENmmlQ3Bli
	 EqUzn06ju600op+wrvJxF2CyGQJgqemRQLBQOReIBekNHt2BbspAzodtShXyMHWxMzRTZ
	 IhBBgL/zGjnbvF4MOxlGH7LsFVDboRxAr2Pt2QlM/VRFe/Ml/+UWKgic/DsUOKeqCpGY8
	 QTQab58EnNBM6EB5cywZHr3qSSSAVt7I+aWaavaKaxsTFy7gRguQDYDF7yZ+Mx9KyZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDF727DX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D4B606A31A;
	Wed, 28 Oct 2026 19:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDF727DX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDAE1F01825;
	Wed, 28 Oct 2026 19:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216037;
	bh=tlGHzF15xrf36oozBcuE0hQl6pbqozZRaaGJYlL0CQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDF727DXwUGMw0w8GbXNRC26PCEpSJBn5bQNhoyF56xzn38E6FlRT7DMLVgUJNe9K
	 LsQh2+04/3CmYESmtEz5T7ThEfvHwuWM3sz/JpxTojMHsuyfNUsLgNe4R+06Xw9dPM
	 Wq2cAGJLravRYJhtUqCbXeNdvwPhSinXtedqDdz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1412/1887] fbdev: Add initializer macros for struct fb_ops
Date: Wed, 28 Oct 2026 17:58:28 +0100
Message-ID: <20261028170531.589170218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit f1061fa641b8b15c7815d58c20a6c29f2f1f5337 ]

For framebuffers in I/O and system memory, add macros that set
struct fb_ops to the respective callback functions.

For deferred I/O, add macros that generate callback functions with
damage handling. Add initializer macros that set struct fb_ops to
the generated callbacks.

These macros can remove a lot boilerplate code from fbdev drivers.
The drivers are supposed to use the macro that is required for its
framebuffer. Each macro is split into smaller helpers, so that
drivers with non-standard callbacks can pick and customize callbacks
as needed. There are individual helper macros for read/write, mmap
and drawing.

v5:
	* fix whitespace errors (Jingfeng)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230530151228.22979-3-tzimmermann@suse.de
Stable-dep-of: 9ad709afdfa3 ("fbdev: ssd1307fb: defer I2C transfers from damage callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fb.h | 112 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/include/linux/fb.h b/include/linux/fb.h
index 0b128f96ec770..2435aeddf47fa 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -607,9 +607,31 @@ int fb_set_var_from_user(struct fb_info *info, struct fb_var_screeninfo *var);
 extern void cfb_fillrect(struct fb_info *info, const struct fb_fillrect *rect);
 extern void cfb_copyarea(struct fb_info *info, const struct fb_copyarea *area);
 extern void cfb_imageblit(struct fb_info *info, const struct fb_image *image);
+/*
+ * Initializes struct fb_ops for framebuffers in I/O memory.
+ */
+
+#define __FB_DEFAULT_IO_OPS_RDWR \
+	.fb_read	= fb_io_read, \
+	.fb_write	= fb_io_write
+
+#define __FB_DEFAULT_IO_OPS_DRAW \
+	.fb_fillrect	= cfb_fillrect, \
+	.fb_copyarea	= cfb_copyarea, \
+	.fb_imageblit	= cfb_imageblit
+
+#define __FB_DEFAULT_IO_OPS_MMAP \
+	.fb_mmap	= NULL // default implementation
+
+#define FB_DEFAULT_IO_OPS \
+	__FB_DEFAULT_IO_OPS_RDWR, \
+	__FB_DEFAULT_IO_OPS_DRAW, \
+	__FB_DEFAULT_IO_OPS_MMAP
+
 /*
  * Drawing operations where framebuffer is in system RAM
  */
+
 extern void sys_fillrect(struct fb_info *info, const struct fb_fillrect *rect);
 extern void sys_copyarea(struct fb_info *info, const struct fb_copyarea *area);
 extern void sys_imageblit(struct fb_info *info, const struct fb_image *image);
@@ -618,6 +640,27 @@ extern ssize_t fb_sys_read(struct fb_info *info, char __user *buf,
 extern ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
 			    size_t count, loff_t *ppos);
 
+/*
+ * Initializes struct fb_ops for framebuffers in system memory.
+ */
+
+#define __FB_DEFAULT_SYS_OPS_RDWR \
+	.fb_read	= fb_sys_read, \
+	.fb_write	= fb_sys_write
+
+#define __FB_DEFAULT_SYS_OPS_DRAW \
+	.fb_fillrect	= sys_fillrect, \
+	.fb_copyarea	= sys_copyarea, \
+	.fb_imageblit	= sys_imageblit
+
+#define __FB_DEFAULT_SYS_OPS_MMAP \
+	.fb_mmap	= NULL // default implementation
+
+#define FB_DEFAULT_SYS_OPS \
+	__FB_DEFAULT_SYS_OPS_RDWR, \
+	__FB_DEFAULT_SYS_OPS_DRAW, \
+	__FB_DEFAULT_SYS_OPS_MMAP
+
 /* drivers/video/fbmem.c */
 extern int register_framebuffer(struct fb_info *fb_info);
 extern void unregister_framebuffer(struct fb_info *fb_info);
@@ -673,6 +716,75 @@ extern void fb_deferred_io_cleanup(struct fb_info *info);
 extern int fb_deferred_io_fsync(struct file *file, loff_t start,
 				loff_t end, int datasync);
 
+/*
+ * Generate callbacks for deferred I/O
+ */
+
+#define __FB_GEN_DEFAULT_DEFERRED_OPS_RDWR(__prefix, __damage_range, __mode) \
+	static ssize_t __prefix ## _defio_read(struct fb_info *info, char __user *buf, \
+					       size_t count, loff_t *ppos) \
+	{ \
+		return fb_ ## __mode ## _read(info, buf, count, ppos); \
+	} \
+	static ssize_t __prefix ## _defio_write(struct fb_info *info, const char __user *buf, \
+						size_t count, loff_t *ppos) \
+	{ \
+		unsigned long offset = *ppos; \
+		ssize_t ret = fb_ ## __mode ## _write(info, buf, count, ppos); \
+		if (ret > 0) \
+			__damage_range(info, offset, ret); \
+		return ret; \
+	}
+
+#define __FB_GEN_DEFAULT_DEFERRED_OPS_DRAW(__prefix, __damage_area, __mode) \
+	static void __prefix ## _defio_fillrect(struct fb_info *info, \
+						const struct fb_fillrect *rect) \
+	{ \
+		__mode ## _fillrect(info, rect); \
+		__damage_area(info, rect->dx, rect->dy, rect->width, rect->height); \
+	} \
+	static void __prefix ## _defio_copyarea(struct fb_info *info, \
+						const struct fb_copyarea *area) \
+	{ \
+		__mode ## _copyarea(info, area); \
+		__damage_area(info, area->dx, area->dy, area->width, area->height); \
+	} \
+	static void __prefix ## _defio_imageblit(struct fb_info *info, \
+						 const struct fb_image *image) \
+	{ \
+		__mode ## _imageblit(info, image); \
+		__damage_area(info, image->dx, image->dy, image->width, image->height); \
+	}
+
+#define FB_GEN_DEFAULT_DEFERRED_IO_OPS(__prefix, __damage_range, __damage_area) \
+	__FB_GEN_DEFAULT_DEFERRED_OPS_RDWR(__prefix, __damage_range, io) \
+	__FB_GEN_DEFAULT_DEFERRED_OPS_DRAW(__prefix, __damage_area, cfb)
+
+#define FB_GEN_DEFAULT_DEFERRED_SYS_OPS(__prefix, __damage_range, __damage_area) \
+	__FB_GEN_DEFAULT_DEFERRED_OPS_RDWR(__prefix, __damage_range, sys) \
+	__FB_GEN_DEFAULT_DEFERRED_OPS_DRAW(__prefix, __damage_area, sys)
+
+/*
+ * Initializes struct fb_ops for deferred I/O.
+ */
+
+#define __FB_DEFAULT_DEFERRED_OPS_RDWR(__prefix) \
+	.fb_read	= __prefix ## _defio_read, \
+	.fb_write	= __prefix ## _defio_write
+
+#define __FB_DEFAULT_DEFERRED_OPS_DRAW(__prefix) \
+	.fb_fillrect	= __prefix ## _defio_fillrect, \
+	.fb_copyarea	= __prefix ## _defio_copyarea, \
+	.fb_imageblit	= __prefix ## _defio_imageblit
+
+#define __FB_DEFAULT_DEFERRED_OPS_MMAP(__prefix) \
+	.fb_mmap	= fb_deferred_io_mmap
+
+#define FB_DEFAULT_DEFERRED_OPS(__prefix) \
+	__FB_DEFAULT_DEFERRED_OPS_RDWR(__prefix), \
+	__FB_DEFAULT_DEFERRED_OPS_DRAW(__prefix), \
+	__FB_DEFAULT_DEFERRED_OPS_MMAP(__prefix)
+
 static inline bool fb_be_math(struct fb_info *info)
 {
 #ifdef CONFIG_FB_FOREIGN_ENDIAN
-- 
2.53.0



