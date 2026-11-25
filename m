Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620807;
	b=1gexdaWxhXyXITgD7sP5BRMYa9Nm74/l5XmQa2qZ7BSfoj+X72kxSowWMmgijNiAqnBH
	 0wXIT1FRV1s9sp8aebywV+WomgYykgEVN1PliuzXc4Bw58I1w3qEn+X5AqigyCnK1CfWU
	 GIATLCmVNuTlu1BSEgtFiTtxdQsZ8Th1oIlNQ1Z4w2gr9N409AF1eV5+5U273MFI42GLL
	 zMchU85PIpl2qMbAlFG6+IVI0tci7J3bb6STkisQiNiJU+/7LQnw279EMmyDT5C0Z60PE
	 K5UfSrO9jMkwQxF3/M+D9GVTWfc54Tmfb8ydWZ+5Yc3LtPDNQgIadqal92g+OgnZI7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rNcHmlhgNCM9Vkd9BpBoysONL5MKTDR/Umv+bVys8Jo=;
	b=2o+4jWGZOHww/zhW5BONEKbzNM7wy1vYbChyTNNt4GR8B+ESOZdGw3dsKXREzTCOaest
	 G2BeFFUnUyN8+NDv4HBTV7pM+0w34SEg+1jFbZSzR+uKOAscidp/btnPdgFkrNmlZNbde
	 4pasgX1ADjxR4GyqoeHLHJRY09V1E0fBfbuD68MCOZqVi/XILq0MrnorVXDz3DFxEybgB
	 bWh4H4z3mzR8BybA7FGQcgdzlamhqepWwTfA8AuoUDTiY1QPmnUTFKUxploj+mWwdZfWb
	 qZmGMYL05RWlLBVG8N3FUwfv/p2M7RyTZnd7cQT086oC0KRLqh6aPG2OncSmdj8wGSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOdcdkuj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2DF606A31E;
	Wed, 25 Nov 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOdcdkuj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B68F1F000D1;
	Wed, 25 Nov 2026 15:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620807;
	bh=rNcHmlhgNCM9Vkd9BpBoysONL5MKTDR/Umv+bVys8Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOdcdkujW+jr2FV35/hmooQyZ9f3lZQhsnn/yEx8I0yZmfFg+yVQZawLaALV9D41w
	 jEUumRmxU9gWv/GiGHLp/SIDgqiKu0vqsQz9cRdPttLUbITz3rUVshcVx/g3uUD47f
	 C657sZKNolEny4Yu4ByeTY7aMBdQnYHzhf0ov/l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melbin K Mathew <mlbnkm1@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/990] fbdev: bound mode sysfs output to the sysfs buffer
Date: Wed, 25 Nov 2026 15:23:17 +0100
Message-ID: <20261125143822.793759750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melbin K Mathew <mlbnkm1@gmail.com>

[ Upstream commit d15d51fb26e830af58f3f21964f1c09c239077ea ]

mode_string() uses snprintf() which can return a value larger than the
remaining buffer space. show_modes() accumulates the return value into i
without checking whether i has reached PAGE_SIZE, causing the offset to
advance past the sysfs buffer if the modelist is long enough.

Add a size parameter to mode_string() and use scnprintf() to return
only the bytes actually written. Add an early return when offset
already exceeds the buffer. In show_modes(), stop accumulating once
the buffer is full.

Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbsysfs.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index d363f94207c3e..49d886c2dd7c8 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -28,12 +28,15 @@ static int activate(struct fb_info *fb_info, struct fb_var_screeninfo *var)
 	return 0;
 }
 
-static int mode_string(char *buf, unsigned int offset,
+static int mode_string(char *buf, size_t size, unsigned int offset,
 		       const struct fb_videomode *mode)
 {
 	char m = 'U';
 	char v = 'p';
 
+	if (offset >= size)
+		return 0;
+
 	if (mode->flag & FB_MODE_IS_DETAILED)
 		m = 'D';
 	if (mode->flag & FB_MODE_IS_VESA)
@@ -46,7 +49,7 @@ static int mode_string(char *buf, unsigned int offset,
 	if (mode->vmode & FB_VMODE_DOUBLE)
 		v = 'd';
 
-	return snprintf(&buf[offset], PAGE_SIZE - offset, "%c:%dx%d%c-%d\n",
+	return scnprintf(&buf[offset], size - offset, "%c:%dx%d%c-%d\n",
 	                m, mode->xres, mode->yres, v, mode->refresh);
 }
 
@@ -65,7 +68,7 @@ static ssize_t store_mode(struct device *device, struct device_attribute *attr,
 
 	list_for_each_entry(modelist, &fb_info->modelist, list) {
 		mode = &modelist->mode;
-		i = mode_string(mstr, 0, mode);
+		i = mode_string(mstr, sizeof(mstr), 0, mode);
 		if (strncmp(mstr, buf, max(count, i)) == 0) {
 
 			var = fb_info->var;
@@ -87,7 +90,7 @@ static ssize_t show_mode(struct device *device, struct device_attribute *attr,
 	if (!fb_info->mode)
 		return 0;
 
-	return mode_string(buf, 0, fb_info->mode);
+	return mode_string(buf, PAGE_SIZE, 0, fb_info->mode);
 }
 
 static ssize_t store_modes(struct device *device,
@@ -137,7 +140,9 @@ static ssize_t show_modes(struct device *device, struct device_attribute *attr,
 	i = 0;
 	list_for_each_entry(modelist, &fb_info->modelist, list) {
 		mode = &modelist->mode;
-		i += mode_string(buf, i, mode);
+		i += mode_string(buf, PAGE_SIZE, i, mode);
+		if (i >= PAGE_SIZE - 1)
+			break;
 	}
 	return i;
 }
-- 
2.53.0



