Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016168;
	b=1N/Tn2eO57fQWIcPNbPTyxBcsu7whVdzdqOm7ZVjJbmlFCbJX2FW2Zw3mlLtobW0a3Ev
	 H76d+WIBGTJdwyqLQ2SNrojMWnKuFEMDbQMOZGsMYOLVpAzq/RFbNzDNof1ESblh8J1YG
	 kw3zvg6nj9am+zXfuU/ozFEJi2ZLeWbN3R4CrrDnB0dd1+erJCKZ+MNfwB/ETgK393XxD
	 yl6YniJPWz7cRAjzf2m9sKwWw8twcza3tCUpnZFG1YX8UxZJSeZqpTeQmEPJrZTbCbM/J
	 WZWpdzVfBN7FxYfmv+QWmZDT3e2ClqIA1r0X0OZdfE+3pDMs+eV/TihJGu+3grgZ/Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lQKOWYAx9Dv9l/OHhWIeqBzzcai0umtgERAxH5MGaE4=;
	b=VmKzDxCIDcFb8M0Qyn/VxXL/6eQy1I6MTY0osfyKiQOq8QMe+5F0R4MMpxoFdNgmsC5D
	 5vy0FM1pb4TS+fYY/BCnLeC3z/6CCyfgud54Kj7m3fiVx6BPUbBM/dSvbVTh3Z36WKdRh
	 33mkY7pNjlEp3qxYbN/LLUUf2e/Q796QgB06I3wfDac4aALiUuFNU9I5MKnOIwp4YSRve
	 6IJHEgK1ZotL+piRE3NIomnqugL/FzzrNhJ6FQx84IPsoSLBzTkT/QlNJizTjHx7A1cdF
	 voMWFd9nAyKQF72IinAgbyX9f9fj+hVhDhqwZSQSHvPL1dh2zb142KGvuPXt6CFv+eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WnRyeMEu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5890606A32A;
	Wed, 18 Nov 2026 15:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WnRyeMEu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE931F000C5;
	Wed, 18 Nov 2026 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016167;
	bh=lQKOWYAx9Dv9l/OHhWIeqBzzcai0umtgERAxH5MGaE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WnRyeMEuQctM8B0H9Z2O+p5bPtel0IvuO0CVt6orXLq4tyfzpd16CY2fTvlU5solx
	 5DnS8PQALI9cDDcHuIX3M7dZF07y0VYjDJOFmSm1aOKPntIBa/7NO4IVVlxBdm8euv
	 cjVhN4AQxOSL3FbSwTWtYNTo1LXohu3qHz11ZV7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roshan Kumar <roshaen09@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0426/2651] drm/pl111: drop alpha formats the hardware cannot scan out
Date: Wed, 18 Nov 2026 15:27:46 +0100
Message-ID: <20261118150303.165823471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roshan Kumar <roshaen09@gmail.com>

[ Upstream commit 9d4c98219598e77ca7044c453ae6994519ac0a96 ]

The PL110/PL111 controller scans out a single framebuffer and never
blends its alpha channel with anything. In every pixel-format table
each alpha-carrying entry (ARGB/ABGR in 8888, 1555 and 4444) maps to
exactly the same register configuration as its XRGB/XBGR counterpart,
so the alpha byte was never used by the hardware.

Commit 860e748bddcc ("drm: ensure blend mode supported if pixel format
with alpha exposed") added validation that warns when a plane exposes
alpha formats without a pixel blend mode property, and PL111 does exactly
that. With panic_on_warn enabled the warning prevents the syzkaller
vexpress-a15 manager from booting.

Drivers should not report formats they do not support, so remove the
alpha formats from all variant tables: the generic PL110, PL111 and
Nomadik tables in pl111_drv.c and the board-specific Integrator, IM-PD1,
Versatile and RealView/Versatile-Express tables in pl111_versatile.c,
plus the now dead case labels in the display setup and the Versatile
syscon connector switch, instead of advertising a blend mode property.
Behavior is unchanged for userspace that picks an XRGB/XBGR/RGB format;
alpha-picking clients fall back to the identical X variant.

Link: https://github.com/google/syzkaller/issues/7805
Fixes: 860e748bddcc ("drm: ensure blend mode supported if pixel format with alpha exposed")
Signed-off-by: Roshan Kumar <roshaen09@gmail.com>

Changes in v2: drop the alpha formats entirely instead of advertising a
DRM_MODE_BLEND_PIXEL_NONE property, per review feedback from Thomas
Zimmermann. Leandro's Reviewed-by from v1 is not carried as the
approach changed.

Changes in v3: v2 missed the board-specific variant tables in
pl111_versatile.c (Integrator, IM-PD1, Versatile, RealView and
Versatile Express), which still exposed alpha formats and would fall
through to the WARN_ONCE default in pl111_display_enable() on those
boards. Pointed out by the sashiko AI reviewer.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://github.com/google/syzkaller/issues/7805
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260910192526.137057-1-roshaen09@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/pl111/pl111_display.c   |  6 ------
 drivers/gpu/drm/pl111/pl111_drv.c       | 16 ----------------
 drivers/gpu/drm/pl111/pl111_versatile.c | 18 ------------------
 3 files changed, 40 deletions(-)

diff --git a/drivers/gpu/drm/pl111/pl111_display.c b/drivers/gpu/drm/pl111/pl111_display.c
index 5d10bc5fdf1f6..e1b513d36c27c 100644
--- a/drivers/gpu/drm/pl111/pl111_display.c
+++ b/drivers/gpu/drm/pl111/pl111_display.c
@@ -267,14 +267,12 @@ static void pl111_display_enable(struct drm_simple_display_pipe *pipe,
 		if (priv->variant->st_bitmux_control)
 			cntl |= CNTL_ST_LCDBPP24_PACKED;
 		break;
-	case DRM_FORMAT_ABGR8888:
 	case DRM_FORMAT_XBGR8888:
 		if (priv->variant->st_bitmux_control)
 			cntl |= CNTL_LCDBPP24 | CNTL_BGR;
 		else
 			cntl |= CNTL_LCDBPP24;
 		break;
-	case DRM_FORMAT_ARGB8888:
 	case DRM_FORMAT_XRGB8888:
 		if (priv->variant->st_bitmux_control)
 			cntl |= CNTL_LCDBPP24;
@@ -297,13 +295,11 @@ static void pl111_display_enable(struct drm_simple_display_pipe *pipe,
 		else
 			cntl |= CNTL_LCDBPP16_565 | CNTL_BGR;
 		break;
-	case DRM_FORMAT_ABGR1555:
 	case DRM_FORMAT_XBGR1555:
 		cntl |= CNTL_LCDBPP16;
 		if (priv->variant->st_bitmux_control)
 			cntl |= CNTL_ST_1XBPP_5551 | CNTL_BGR;
 		break;
-	case DRM_FORMAT_ARGB1555:
 	case DRM_FORMAT_XRGB1555:
 		cntl |= CNTL_LCDBPP16;
 		if (priv->variant->st_bitmux_control)
@@ -311,13 +307,11 @@ static void pl111_display_enable(struct drm_simple_display_pipe *pipe,
 		else
 			cntl |= CNTL_BGR;
 		break;
-	case DRM_FORMAT_ABGR4444:
 	case DRM_FORMAT_XBGR4444:
 		cntl |= CNTL_LCDBPP16_444;
 		if (priv->variant->st_bitmux_control)
 			cntl |= CNTL_ST_1XBPP_444 | CNTL_BGR;
 		break;
-	case DRM_FORMAT_ARGB4444:
 	case DRM_FORMAT_XRGB4444:
 		cntl |= CNTL_LCDBPP16_444;
 		if (priv->variant->st_bitmux_control)
diff --git a/drivers/gpu/drm/pl111/pl111_drv.c b/drivers/gpu/drm/pl111/pl111_drv.c
index 8ec659b3c08eb..0e97261e988db 100644
--- a/drivers/gpu/drm/pl111/pl111_drv.c
+++ b/drivers/gpu/drm/pl111/pl111_drv.c
@@ -342,13 +342,9 @@ static void pl111_amba_shutdown(struct amba_device *amba_dev)
  * This early variant lacks the 565 and 444 pixel formats.
  */
 static const u32 pl110_pixel_formats[] = {
-	DRM_FORMAT_ABGR8888,
 	DRM_FORMAT_XBGR8888,
-	DRM_FORMAT_ARGB8888,
 	DRM_FORMAT_XRGB8888,
-	DRM_FORMAT_ABGR1555,
 	DRM_FORMAT_XBGR1555,
-	DRM_FORMAT_ARGB1555,
 	DRM_FORMAT_XRGB1555,
 };
 
@@ -362,19 +358,13 @@ static const struct pl111_variant_data pl110_variant = {
 
 /* RealView, Versatile Express etc use this modern variant */
 static const u32 pl111_pixel_formats[] = {
-	DRM_FORMAT_ABGR8888,
 	DRM_FORMAT_XBGR8888,
-	DRM_FORMAT_ARGB8888,
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_BGR565,
 	DRM_FORMAT_RGB565,
-	DRM_FORMAT_ABGR1555,
 	DRM_FORMAT_XBGR1555,
-	DRM_FORMAT_ARGB1555,
 	DRM_FORMAT_XRGB1555,
-	DRM_FORMAT_ABGR4444,
 	DRM_FORMAT_XBGR4444,
-	DRM_FORMAT_ARGB4444,
 	DRM_FORMAT_XRGB4444,
 };
 
@@ -388,19 +378,13 @@ static const struct pl111_variant_data pl111_variant = {
 static const u32 pl110_nomadik_pixel_formats[] = {
 	DRM_FORMAT_RGB888,
 	DRM_FORMAT_BGR888,
-	DRM_FORMAT_ABGR8888,
 	DRM_FORMAT_XBGR8888,
-	DRM_FORMAT_ARGB8888,
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_BGR565,
 	DRM_FORMAT_RGB565,
-	DRM_FORMAT_ABGR1555,
 	DRM_FORMAT_XBGR1555,
-	DRM_FORMAT_ARGB1555,
 	DRM_FORMAT_XRGB1555,
-	DRM_FORMAT_ABGR4444,
 	DRM_FORMAT_XBGR4444,
-	DRM_FORMAT_ARGB4444,
 	DRM_FORMAT_XRGB4444,
 };
 
diff --git a/drivers/gpu/drm/pl111/pl111_versatile.c b/drivers/gpu/drm/pl111/pl111_versatile.c
index 0d8331a3909f4..9a60f10231b16 100644
--- a/drivers/gpu/drm/pl111/pl111_versatile.c
+++ b/drivers/gpu/drm/pl111/pl111_versatile.c
@@ -209,9 +209,7 @@ static void pl111_versatile_enable(struct drm_device *drm, u32 format)
 	drm_info(drm, "enable Versatile CLCD connectors\n");
 
 	switch (format) {
-	case DRM_FORMAT_ABGR8888:
 	case DRM_FORMAT_XBGR8888:
-	case DRM_FORMAT_ARGB8888:
 	case DRM_FORMAT_XRGB8888:
 		val |= SYS_CLCD_MODE_888;
 		break;
@@ -221,9 +219,7 @@ static void pl111_versatile_enable(struct drm_device *drm, u32 format)
 	case DRM_FORMAT_RGB565:
 		val |= SYS_CLCD_MODE_565_B_LSB;
 		break;
-	case DRM_FORMAT_ABGR1555:
 	case DRM_FORMAT_XBGR1555:
-	case DRM_FORMAT_ARGB1555:
 	case DRM_FORMAT_XRGB1555:
 		val |= SYS_CLCD_MODE_5551;
 		break;
@@ -266,44 +262,30 @@ static void pl111_realview_clcd_enable(struct drm_device *drm, u32 format)
 
 /* PL110 pixel formats for Integrator, vanilla PL110 */
 static const u32 pl110_integrator_pixel_formats[] = {
-	DRM_FORMAT_ABGR8888,
 	DRM_FORMAT_XBGR8888,
-	DRM_FORMAT_ARGB8888,
 	DRM_FORMAT_XRGB8888,
-	DRM_FORMAT_ABGR1555,
 	DRM_FORMAT_XBGR1555,
-	DRM_FORMAT_ARGB1555,
 	DRM_FORMAT_XRGB1555,
 };
 
 /* Extended PL110 pixel formats for Integrator and Versatile */
 static const u32 pl110_versatile_pixel_formats[] = {
-	DRM_FORMAT_ABGR8888,
 	DRM_FORMAT_XBGR8888,
-	DRM_FORMAT_ARGB8888,
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_BGR565, /* Uses external PLD */
 	DRM_FORMAT_RGB565, /* Uses external PLD */
-	DRM_FORMAT_ABGR1555,
 	DRM_FORMAT_XBGR1555,
-	DRM_FORMAT_ARGB1555,
 	DRM_FORMAT_XRGB1555,
 };
 
 static const u32 pl111_realview_pixel_formats[] = {
-	DRM_FORMAT_ABGR8888,
 	DRM_FORMAT_XBGR8888,
-	DRM_FORMAT_ARGB8888,
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_BGR565,
 	DRM_FORMAT_RGB565,
-	DRM_FORMAT_ABGR1555,
 	DRM_FORMAT_XBGR1555,
-	DRM_FORMAT_ARGB1555,
 	DRM_FORMAT_XRGB1555,
-	DRM_FORMAT_ABGR4444,
 	DRM_FORMAT_XBGR4444,
-	DRM_FORMAT_ARGB4444,
 	DRM_FORMAT_XRGB4444,
 };
 
-- 
2.53.0



