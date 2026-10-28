Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216070;
	b=dvH6HH6xPMnDOSXNXPPjZYs6c9bkEwEOf/Gpcru7W6AYVOAb4YC/NLhCCJZV9euZ7Djo
	 zxA6NzqlgF9mobu4yoLdD9kFm5Tcyj7MMdFGhIK/u7PvVwo9Zn8NB7xaqeO/RN2dd1T7z
	 hcQ5XFF/vvpfCPEjTKip6FmEd7o1+yXBEk/UXAX2daqMEYjXfDURSK9eJu294TxYzfWoT
	 +CLtwEMOYOS6IRtYf6tdbnjpUaJF5laMK9bsge+vJaVU80WsXuyxUC2QQ0p+7U9Yc+5Mc
	 DfSM3ze6K1JRngviRkjynepHs26Y8nfAaOniYLc5T5KwWoY/H9sgtNvz32kBoDAGR6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cr2tQ+yDWVxgHpl1cSsmkvncy8J+nfL2S/l2hDIznF4=;
	b=ODNKUetNc705zew9clcAxI10BmdWijfhF9LDd3TQ3F9bHKPSK031c03kJEngeQEoyl3m
	 gvtLNLqLQhWjtIrc8a1XKU3zQ/VtduLngEL3Tk1YuBvWVrPsQokIchIPD18nVDylbo9qE
	 haCxlzqaaNVJTtMXwFjIJNx2msaynyPELh6Y9UUhG9d1qEgqHSNW+eKwrGpSxjVqajfYT
	 aPAD0lDBKxPX9m1uSkwy0bfjWeVTdCc4Yh3wA+DYa7kUuALZOr/YVq/yAvunSgOuci6jm
	 2YVPfbIKQ3citrswpOvViSfJm9OLXKWq3LbNIdeu22FVH/ARpcThI0UUxmQfFTzAJtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cjg+YNrN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF984606A31A;
	Wed, 28 Oct 2026 19:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cjg+YNrN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3EB1F01825;
	Wed, 28 Oct 2026 19:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216069;
	bh=Cr2tQ+yDWVxgHpl1cSsmkvncy8J+nfL2S/l2hDIznF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjg+YNrN2t9gr9YNMj5D8ZLUXHIQa3UOyPU+A75ufbTmMjhRt7I4qkVOadVDpIefg
	 JjJ31QgSMPwtfYnPAj8brQjBd4WMnFY2knQJv4/46ijkcSY0pwY5KXr+b7I8bZdEwc
	 +85n3udFGx92jCNxxSYkVyOGpb6ozfr4QlHRukxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1413/1887] fbdev/ssd1307fb: Generate deferred I/O ops
Date: Wed, 28 Oct 2026 17:58:29 +0100
Message-ID: <20261028170531.612391471@linuxfoundation.org>
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

[ Upstream commit 417218ae730b4802419b36d3449eb7435fcec7c1 ]

Use the existing generator macros to create deferred-I/O helpers
for ssd1307fb and set them in the fb_ops structure. Functions
for damage handling on memory ranges and areas are provided by
the driver.

Ssd1307fb's implementation of fb_write writes to system memory,
so the generated code can use the respective helper internally.
This also fixes a long-standing bug where fb_write returned an
errno code instead of the number of written bytes. See the commit
message of commit 921b7383f348 ("fbdev: Return number of bytes
read or written") for more details.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Helge Deller <deller@gmx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230706151432.20674-9-tzimmermann@suse.de
Stable-dep-of: 9ad709afdfa3 ("fbdev: ssd1307fb: defer I2C transfers from damage callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/ssd1307fb.c | 69 ++++++---------------------------
 1 file changed, 11 insertions(+), 58 deletions(-)

diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index 7620c6913520a..a7b8be508f562 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -292,43 +292,6 @@ static int ssd1307fb_update_display(struct ssd1307fb_par *par)
 	return ssd1307fb_update_rect(par, 0, 0, par->width, par->height);
 }
 
-static ssize_t ssd1307fb_write(struct fb_info *info, const char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct ssd1307fb_par *par = info->par;
-	unsigned long total_size;
-	unsigned long p = *ppos;
-	void *dst;
-	int ret;
-
-	if (!info->screen_buffer)
-		return -ENODEV;
-
-	total_size = info->fix.smem_len;
-
-	if (p > total_size)
-		return -EINVAL;
-
-	if (count + p > total_size)
-		count = total_size - p;
-
-	if (!count)
-		return -EINVAL;
-
-	dst = info->screen_buffer + p;
-
-	if (copy_from_user(dst, buf, count))
-		return -EFAULT;
-
-	ret = ssd1307fb_update_display(par);
-	if (ret < 0)
-		return ret;
-
-	*ppos += count;
-
-	return count;
-}
-
 static int ssd1307fb_blank(int blank_mode, struct fb_info *info)
 {
 	struct ssd1307fb_par *par = info->par;
@@ -339,39 +302,29 @@ static int ssd1307fb_blank(int blank_mode, struct fb_info *info)
 		return ssd1307fb_write_cmd(par->client, SSD1307FB_DISPLAY_ON);
 }
 
-static void ssd1307fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
+static void ssd1307fb_defio_damage_range(struct fb_info *info, off_t off, size_t len)
 {
 	struct ssd1307fb_par *par = info->par;
-	sys_fillrect(info, rect);
-	ssd1307fb_update_rect(par, rect->dx, rect->dy, rect->width,
-			      rect->height);
-}
 
-static void ssd1307fb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
-{
-	struct ssd1307fb_par *par = info->par;
-	sys_copyarea(info, area);
-	ssd1307fb_update_rect(par, area->dx, area->dy, area->width,
-			      area->height);
+	ssd1307fb_update_display(par);
 }
 
-static void ssd1307fb_imageblit(struct fb_info *info, const struct fb_image *image)
+static void ssd1307fb_defio_damage_area(struct fb_info *info, u32 x, u32 y,
+					u32 width, u32 height)
 {
 	struct ssd1307fb_par *par = info->par;
-	sys_imageblit(info, image);
-	ssd1307fb_update_rect(par, image->dx, image->dy, image->width,
-			      image->height);
+
+	ssd1307fb_update_rect(par, x, y, width, height);
 }
 
+FB_GEN_DEFAULT_DEFERRED_SYS_OPS(ssd1307fb,
+				ssd1307fb_defio_damage_range,
+				ssd1307fb_defio_damage_area)
+
 static const struct fb_ops ssd1307fb_ops = {
 	.owner		= THIS_MODULE,
-	.fb_read	= fb_sys_read,
-	.fb_write	= ssd1307fb_write,
+	FB_DEFAULT_DEFERRED_OPS(ssd1307fb),
 	.fb_blank	= ssd1307fb_blank,
-	.fb_fillrect	= ssd1307fb_fillrect,
-	.fb_copyarea	= ssd1307fb_copyarea,
-	.fb_imageblit	= ssd1307fb_imageblit,
-	.fb_mmap	= fb_deferred_io_mmap,
 };
 
 static void ssd1307fb_deferred_io(struct fb_info *info, struct list_head *pagereflist)
-- 
2.53.0



