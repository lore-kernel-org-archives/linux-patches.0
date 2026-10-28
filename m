Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216168;
	b=PQAwLpIxkSq5KGzc97PI4WzvbIUzJgeJ/nIWVfD0sjUBfY96LGnr2lju+FDWiwH76bg/
	 VkK7NBYi2xlNBz56uV5kGR1gpjjh8mgiQgkVf0wTlPp+sKG3z42LbBL4TLRkbYg52h5fI
	 NjpouqfP6naZwuyLRkSLXro9N2jMn0LCwA9GgJ+OvO1sq3OqBdjjB6c4avciEXF3oiRwI
	 5lAuXpyb85K/4P+mCEbkWBZzmMoalVUi8Q30Gg6jHA5g+5TLUl7YMWMwY84VDFm3iubGI
	 gC1xmDa/guiuJprnpBiaJln0f4vYgtXxM4DNBx+ZjHvq+j7F3V4zuUWfnT/VTKMH+pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lXhJcUG9wYFNKsKbPZs7+rrHfY8beqqg06QdNtTBUMs=;
	b=d2CSh2NnSx5EbWFH0/dEkAK86hQbL40ShstZZtLZSxnl6TCuhrg0wjiNMXUwvUhpkUGL
	 oWDaUTLZrbiPjQ80g12oaRVipryFjRdyO7xggZaugnUa5m+pk0SaKEEftz2dnJOxcjOSD
	 +xOp7z+6I6EkAyj/LXpQnDR0PxDOLuNz+VPXEfSt1r9Crf/xOEEkhRWPfubHCNn7SZKB7
	 SVkOW7yHDrZ28fXGX9V+ogiSw+M+lBshBgYAA7jrPC8BhXWn0mc3cC20vsGa8bAzH4t80
	 pXcwQ3SCafeZVxz5vD1WRsZJozMf4s2P8S3ajenWAXO8KAt50yKiGZWp8ZVh7SZTimQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X+/SUYl/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE06C606A31A;
	Wed, 28 Oct 2026 19:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+/SUYl/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B51E1F01825;
	Wed, 28 Oct 2026 19:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216167;
	bh=lXhJcUG9wYFNKsKbPZs7+rrHfY8beqqg06QdNtTBUMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+/SUYl/hqPG6KuhNOtd6Bh8mqTtYoU/DJYfQ02KGKa21O2rAyWWUDNsxT6w6B+fc
	 H2YSjNIpw8WX2stXywI60RE1b0NKzI7hj2YVNPsyjv3xHRqptk5SOseC/WwN2ceYH8
	 wPIIxIJasR0GfLDs182j18WGNLKnFZkOg9ab0DLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sui Jingfeng <suijingfeng@loongson.cn>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1411/1887] fbdev: Validate info->screen_{base, buffer} in fb_ops implementations
Date: Wed, 28 Oct 2026 17:58:27 +0100
Message-ID: <20261028170531.567363137@linuxfoundation.org>
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

[ Upstream commit 3f8974f68f408f4983443b745a3cf95b06112469 ]

Push the test for info->screen_base from fb_read() and fb_write() into
the implementations of struct fb_ops.{fb_read,fb_write}. In cases where
the driver operates on info->screen_buffer, test this field instead.

While bothi fields, screen_base and screen_buffer, are stored in the
same location, they refer to different address spaces. For correctness,
we want to test each field in exactly the code that uses it.

v2:
	* also test screen_base in pvr2fb (Geert)
	* also test screen_buffer in ivtvfb, arcfb, broadsheetfb,
	  hecubafb, metronomefb and ssd1307fb (Geert)
	* give a rational for the change (Geert)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Sui Jingfeng <suijingfeng@loongson.cn>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Helge Deller <deller@gmx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230428122452.4856-18-tzimmermann@suse.de
Stable-dep-of: 9ad709afdfa3 ("fbdev: ssd1307fb: defer I2C transfers from damage callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtvfb.c        |  3 +++
 drivers/video/fbdev/arcfb.c            |  3 +++
 drivers/video/fbdev/broadsheetfb.c     |  3 +++
 drivers/video/fbdev/cobalt_lcdfb.c     |  6 ++++++
 drivers/video/fbdev/core/fb_sys_fops.c |  6 ++++++
 drivers/video/fbdev/core/fbmem.c       | 10 ++++++++--
 drivers/video/fbdev/hecubafb.c         |  3 +++
 drivers/video/fbdev/metronomefb.c      |  3 +++
 drivers/video/fbdev/pvr2fb.c           |  3 +++
 drivers/video/fbdev/sm712fb.c          |  4 ++--
 drivers/video/fbdev/ssd1307fb.c        |  3 +++
 11 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 23e6cc5172d7f..19f5abd06907e 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -378,6 +378,9 @@ static ssize_t ivtvfb_write(struct fb_info *info, const char __user *buf,
 	unsigned long dma_size;
 	u16 lead = 0, tail = 0;
 
+	if (!info->screen_base)
+		return -ENODEV;
+
 	total_size = info->screen_size;
 
 	if (total_size == 0)
diff --git a/drivers/video/fbdev/arcfb.c b/drivers/video/fbdev/arcfb.c
index 024d0ee4f04f9..69a6cda61cebe 100644
--- a/drivers/video/fbdev/arcfb.c
+++ b/drivers/video/fbdev/arcfb.c
@@ -451,6 +451,9 @@ static ssize_t arcfb_write(struct fb_info *info, const char __user *buf,
 	struct arcfb_par *par;
 	unsigned int xres;
 
+	if (!info->screen_buffer)
+		return -ENODEV;
+
 	p = *ppos;
 	par = info->par;
 	xres = info->var.xres;
diff --git a/drivers/video/fbdev/broadsheetfb.c b/drivers/video/fbdev/broadsheetfb.c
index c694ab918978f..4c6c42e2d32f7 100644
--- a/drivers/video/fbdev/broadsheetfb.c
+++ b/drivers/video/fbdev/broadsheetfb.c
@@ -1013,6 +1013,9 @@ static ssize_t broadsheetfb_write(struct fb_info *info, const char __user *buf,
 	int err = 0;
 	unsigned long total_size;
 
+	if (!info->screen_buffer)
+		return -ENODEV;
+
 	total_size = info->fix.smem_len;
 
 	if (p > total_size)
diff --git a/drivers/video/fbdev/cobalt_lcdfb.c b/drivers/video/fbdev/cobalt_lcdfb.c
index 5f8b6324d2e8c..26dbd1c78195c 100644
--- a/drivers/video/fbdev/cobalt_lcdfb.c
+++ b/drivers/video/fbdev/cobalt_lcdfb.c
@@ -129,6 +129,9 @@ static ssize_t cobalt_lcdfb_read(struct fb_info *info, char __user *buf,
 	unsigned long pos;
 	int len, retval = 0;
 
+	if (!info->screen_base)
+		return -ENODEV;
+
 	pos = *ppos;
 	if (pos >= LCD_CHARS_MAX || count == 0)
 		return 0;
@@ -175,6 +178,9 @@ static ssize_t cobalt_lcdfb_write(struct fb_info *info, const char __user *buf,
 	unsigned long pos;
 	int len, retval = 0;
 
+	if (!info->screen_base)
+		return -ENODEV;
+
 	pos = *ppos;
 	if (pos >= LCD_CHARS_MAX || count == 0)
 		return 0;
diff --git a/drivers/video/fbdev/core/fb_sys_fops.c b/drivers/video/fbdev/core/fb_sys_fops.c
index facf47a69483c..432fa3fa7fa13 100644
--- a/drivers/video/fbdev/core/fb_sys_fops.c
+++ b/drivers/video/fbdev/core/fb_sys_fops.c
@@ -21,6 +21,9 @@ ssize_t fb_sys_read(struct fb_info *info, char __user *buf, size_t count,
 	int err = 0;
 	unsigned long total_size;
 
+	if (!info->screen_buffer)
+		return -ENODEV;
+
 	total_size = info->screen_size;
 
 	if (total_size == 0)
@@ -58,6 +61,9 @@ ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
 	int err = 0;
 	unsigned long total_size;
 
+	if (!info->screen_buffer)
+		return -ENODEV;
+
 	total_size = info->screen_size;
 
 	if (total_size == 0)
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index c68e1c7b2c729..9b456163db890 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -768,7 +768,7 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	int c, cnt = 0, err = 0;
 	unsigned long total_size;
 
-	if (!info || ! info->screen_base)
+	if (!info)
 		return -ENODEV;
 
 	if (info->state != FBINFO_STATE_RUNNING)
@@ -777,6 +777,9 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	if (info->fbops->fb_read)
 		return info->fbops->fb_read(info, buf, count, ppos);
 
+	if (!info->screen_base)
+		return -ENODEV;
+
 	total_size = info->screen_size;
 
 	if (total_size == 0)
@@ -833,7 +836,7 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	int c, cnt = 0, err = 0;
 	unsigned long total_size;
 
-	if (!info || !info->screen_base)
+	if (!info)
 		return -ENODEV;
 
 	if (info->state != FBINFO_STATE_RUNNING)
@@ -842,6 +845,9 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (info->fbops->fb_write)
 		return info->fbops->fb_write(info, buf, count, ppos);
 
+	if (!info->screen_base)
+		return -ENODEV;
+
 	total_size = info->screen_size;
 
 	if (total_size == 0)
diff --git a/drivers/video/fbdev/hecubafb.c b/drivers/video/fbdev/hecubafb.c
index f6be62ed42c5a..98e224a9641c7 100644
--- a/drivers/video/fbdev/hecubafb.c
+++ b/drivers/video/fbdev/hecubafb.c
@@ -163,6 +163,9 @@ static ssize_t hecubafb_write(struct fb_info *info, const char __user *buf,
 	int err = 0;
 	unsigned long total_size;
 
+	if (!info->screen_buffer)
+		return -ENODEV;
+
 	total_size = info->fix.smem_len;
 
 	if (p > total_size)
diff --git a/drivers/video/fbdev/metronomefb.c b/drivers/video/fbdev/metronomefb.c
index 17307c00d46f0..eba185b58f0ce 100644
--- a/drivers/video/fbdev/metronomefb.c
+++ b/drivers/video/fbdev/metronomefb.c
@@ -523,6 +523,9 @@ static ssize_t metronomefb_write(struct fb_info *info, const char __user *buf,
 	int err = 0;
 	unsigned long total_size;
 
+	if (!info->screen_buffer)
+		return -ENODEV;
+
 	total_size = info->fix.smem_len;
 
 	if (p > total_size)
diff --git a/drivers/video/fbdev/pvr2fb.c b/drivers/video/fbdev/pvr2fb.c
index 6e14884b4f8d0..6c03dd356d200 100644
--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -647,6 +647,9 @@ static ssize_t pvr2fb_write(struct fb_info *info, const char __user *buf,
 	struct page **pages;
 	int ret, i;
 
+	if (!info->screen_base)
+		return -ENODEV;
+
 	nr_pages = (count + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	pages = kmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
diff --git a/drivers/video/fbdev/sm712fb.c b/drivers/video/fbdev/sm712fb.c
index b1bccb5f83e09..88f898580a68d 100644
--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1028,7 +1028,7 @@ static ssize_t smtcfb_read(struct fb_info *info, char __user *buf,
 	int c, i, cnt = 0, err = 0;
 	unsigned long total_size;
 
-	if (!info || !info->screen_base)
+	if (!info->screen_base)
 		return -ENODEV;
 
 	total_size = info->screen_size;
@@ -1091,7 +1091,7 @@ static ssize_t smtcfb_write(struct fb_info *info, const char __user *buf,
 	int c, i, cnt = 0, err = 0;
 	unsigned long total_size;
 
-	if (!info || !info->screen_base)
+	if (!info->screen_base)
 		return -ENODEV;
 
 	total_size = info->screen_size;
diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index b9fefa844574e..7620c6913520a 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -301,6 +301,9 @@ static ssize_t ssd1307fb_write(struct fb_info *info, const char __user *buf,
 	void *dst;
 	int ret;
 
+	if (!info->screen_buffer)
+		return -ENODEV;
+
 	total_size = info->fix.smem_len;
 
 	if (p > total_size)
-- 
2.53.0



