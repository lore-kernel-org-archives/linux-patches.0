Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015130;
	b=rk7NnUuGHo3dyc/YhoEL0100UUu12V4hItK8qBrlrUgHK6WGZhRlHPiyXXRg6RbG1+qz
	 gqyXnKXSDofBwtqIz9T8BjG34/evvR4SLAVzIJm6tkbG+WKMKtaZsI8BL8WCyd410wFGi
	 VCQ2RPTbT2tkSl2f8oIDfsFc27tJ3SMwTjbYzIY/Jfgtxz7zScyhvUcnQs/ecrYkDTeGY
	 mR16ICUM3mgLHMZMNoqa+34W54eAjrgwBggiYYZj6H/BtDO4DdLnSs/ojY890vROuNpCx
	 +tIzJp0vd34rTr8m5pZ69G2upBESZWL1vcfqwQYK37SoVLudBvFzFQrn/9jKzbz+jRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nQNifCnRMPHzW8Lb08qXm/+gbt4tAiXB5CT+2htTadA=;
	b=V+zYlOoBmBq7SkXGKgJOxw75edwkbRwOIC7/NRd3SdeUSJscwNwL2NgLZIQONms0T1E7
	 oUpdAr1sSIfBey2MgmvLTQE1HLgmi8aLMre4PpNscsQR1kPpiKWfX8GQ+NMUFngUK2BMw
	 YWtVsjXyBPfw/DJtsIpddUfWCZJsAU2IOLS+SW+9PmgYJNE+n7WkAimMMB3CzsVm2y6bP
	 i/KjMnebmLuR5hR8zQ9WaWt5TImtA+zw9m3ac2GojodlIUnhljdugjPXLjV3/VBz+zqB5
	 x6PxsnmXeB+0j0FDIpswRvO9CFP629C09AXov9Pcw4fjinY6n8zmpoEyzjBgDZzJLhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z4Br5Sxn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F150260A2626;
	Wed, 18 Nov 2026 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z4Br5Sxn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1E11F000CB;
	Wed, 18 Nov 2026 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015129;
	bh=nQNifCnRMPHzW8Lb08qXm/+gbt4tAiXB5CT+2htTadA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4Br5Sxn67bGTNliHHAjUGOWTT3hT19DyE1xzQxppEyFwvmMVaTeOHwBW+ymSv9Lo
	 FNIw4RQPHb9PBdRZHhiVJ0PswcjpWtu8wvTUIwCri97YJMrjtSfuiYEyWuE+tzbStw
	 L0vAMeDV/KHuqmpogM5w/tyb5DhrT/p4qCxWmpuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0062/2651] drm/verisilicon: Switch to drm_fb_dma_get_addr() for framebuffer addresses
Date: Wed, 18 Nov 2026 15:21:42 +0100
Message-ID: <20261118150250.174633212@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 063019ac51afffda4ab3d658701b086caa0c8e9e ]

The verisilicon driver has a custom framebuffer address calculating
helper that the common drm_fb_dma_get_addr() can substitute.

Differences from drm_fb_dma_get_addr():

- Uses drm_format_info_min_pitch() to calculate the horizontal offset;
  however the driver does not support any of the blocked formats, so
  this just ends up being the same as in drm_fb_dma_get_addr():
  "cpp[plane] * y"

- Uses clipped source coordinates instead of non-clipped coordinates
  as in drm_fb_dma_get_addr();

  For the primary plane this doesn't matter, since the primary plane
  must match the output, i.e. it cannot be clipped. Also this driver
  doesn't support scaling.

  For the cursor plane this seems wrong, as the clipping seems to be
  done by the hardware, and thus the buffer address should be unclipped.

As such, it should be fine to use the common helper and drop the custom
code.

Tested-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Fixes: 8c4ae2189125 ("drm: verisilicon: add support for cursor planes")
Link: https://patch.msgid.link/20260813065127.341349-1-wenst@chromium.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/verisilicon/vs_cursor_plane.c |  4 +++-
 drivers/gpu/drm/verisilicon/vs_plane.c        | 20 -------------------
 drivers/gpu/drm/verisilicon/vs_plane.h        |  2 --
 .../gpu/drm/verisilicon/vs_primary_plane.c    |  7 ++++++-
 4 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/verisilicon/vs_cursor_plane.c b/drivers/gpu/drm/verisilicon/vs_cursor_plane.c
index 472d5d70b5cc9..b1e71da48350e 100644
--- a/drivers/gpu/drm/verisilicon/vs_cursor_plane.c
+++ b/drivers/gpu/drm/verisilicon/vs_cursor_plane.c
@@ -13,6 +13,7 @@
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_blend.h>
 #include <drm/drm_crtc.h>
+#include <drm/drm_fb_dma_helper.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_framebuffer.h>
 #include <drm/drm_gem_atomic_helper.h>
@@ -177,7 +178,8 @@ static void vs_cursor_plane_atomic_update(struct drm_plane *plane,
 		break;
 	}
 
-	dma_addr = vs_fb_get_dma_addr(fb, &state->src);
+	/* hardware handles clipping as seen below */
+	dma_addr = drm_fb_dma_get_gem_addr(fb, state, 0);
 
 	regmap_write(dc->regs, VSDC_CURSOR_ADDRESS(output),
 		     lower_32_bits(dma_addr));
diff --git a/drivers/gpu/drm/verisilicon/vs_plane.c b/drivers/gpu/drm/verisilicon/vs_plane.c
index 7ddb9d2dcb83d..f189c0bba5b72 100644
--- a/drivers/gpu/drm/verisilicon/vs_plane.c
+++ b/drivers/gpu/drm/verisilicon/vs_plane.c
@@ -107,26 +107,6 @@ int drm_format_to_vs_format(u32 drm_format, struct vs_format *vs_format)
 	return 0;
 }
 
-dma_addr_t vs_fb_get_dma_addr(struct drm_framebuffer *fb,
-			      const struct drm_rect *src_rect)
-{
-	struct drm_gem_dma_object *gem;
-	dma_addr_t dma_addr;
-
-	/* Get the physical address of the buffer in memory */
-	gem = drm_fb_dma_get_gem_obj(fb, 0);
-
-	/* Compute the start of the displayed memory */
-	dma_addr = gem->dma_addr + fb->offsets[0];
-
-	/* Fixup framebuffer address for src coordinates */
-	dma_addr += drm_format_info_min_pitch(fb->format, 0,
-					      src_rect->x1 >> 16);
-	dma_addr += (src_rect->y1 >> 16) * fb->pitches[0];
-
-	return dma_addr;
-}
-
 struct drm_plane_state *vs_plane_duplicate_state(struct drm_plane *plane)
 {
 	struct vs_plane_state *vs_state, *vs_state_old;
diff --git a/drivers/gpu/drm/verisilicon/vs_plane.h b/drivers/gpu/drm/verisilicon/vs_plane.h
index 32ed1d70f3b8c..e4f82f1fc6e91 100644
--- a/drivers/gpu/drm/verisilicon/vs_plane.h
+++ b/drivers/gpu/drm/verisilicon/vs_plane.h
@@ -75,8 +75,6 @@ static inline struct vs_plane_state *to_vs_plane_state(struct drm_plane_state *s
 }
 
 int drm_format_to_vs_format(u32 drm_format, struct vs_format *vs_format);
-dma_addr_t vs_fb_get_dma_addr(struct drm_framebuffer *fb,
-			      const struct drm_rect *src_rect);
 
 struct drm_plane_state *vs_plane_duplicate_state(struct drm_plane *plane);
 void vs_plane_destroy_state(struct drm_plane *plane,
diff --git a/drivers/gpu/drm/verisilicon/vs_primary_plane.c b/drivers/gpu/drm/verisilicon/vs_primary_plane.c
index 8e94491693019..d5a8d61e9a489 100644
--- a/drivers/gpu/drm/verisilicon/vs_primary_plane.c
+++ b/drivers/gpu/drm/verisilicon/vs_primary_plane.c
@@ -8,6 +8,7 @@
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_crtc.h>
+#include <drm/drm_fb_dma_helper.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_framebuffer.h>
 #include <drm/drm_gem_atomic_helper.h>
@@ -126,7 +127,11 @@ static void vs_primary_plane_atomic_update(struct drm_plane *plane,
 			   VSDC_FB_CONFIG_UV_SWIZZLE_EN,
 			   vs_state->format.uv_swizzle);
 
-	dma_addr = vs_fb_get_dma_addr(fb, &state->src);
+	/*
+	 * Primary plane cannot be moved, no clipping is involved,
+	 * so the non-clipped framebuffer address can be used.
+	 */
+	dma_addr = drm_fb_dma_get_gem_addr(fb, state, 0);
 
 	regmap_write(dc->regs, VSDC_FB_ADDRESS(output),
 		     lower_32_bits(dma_addr));
-- 
2.53.0



