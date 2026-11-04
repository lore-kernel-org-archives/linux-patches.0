Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829310;
	b=ys8KIHwqhPsB2FSLeDSzD4QMijjGDZQvG0Iwd8XEbuctuYkMTdUAY4vUhkhpeXmvpEgV
	 suOs5Tixxd1DFsWQ3SANPGGMIrlb/78qErxI1HQZrJu71n6lfWo6mOU9OYV4QTknBpUPl
	 9xAAumsoHlKo84nQKYOpn8sR+cQaWmxaDU1/RfjgRKOtj4j86jKIvoIuux+Loy/7ybGGt
	 gcJ4BKJT+iYvdo6kroxaXDpeYazy5bolho6M1kVhvv4+SWdMYF2RoGhyOcb/spl7driJ+
	 1nHVVzUw2GJf0uyCDf9GdOV5dV4u/Xzm5CsCkJtLuJW2/Y0dq5UcitWSEPyoCC/LflQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OM8ObayKYOU0YEMSKFgt/1/9E2MJmPeQ9QMBarjmlG8=;
	b=C2zA8VD3msPVg5kG6SOhi2yzaNQq+L1LthEyQcc0cxh7FL52I34ThUqf3t9w5PvZOGmq
	 3TTKyrxsuu2UqAbtfLb6jdt8eclPmQX30Ueb4PkZU/wE4d+U2QbWTUaetupvK8z1/XTbV
	 h6XnPizkjwkSSvUprA4Sdc3Yt3zNXGwoCkFQwN6rvlUn0RKwEkEc+zzE4MlJAXtZZXlB7
	 Pu9nMpQalG9tVCNl9w6AhCaZxGhCJKcoBCDeRV5HjqXYhHhDBH8//Lmu3IfX2qpAyP78X
	 s5I/Yb/z2m2V/27Y8jXJHEeFQ4I5ikg8gnb2eQitzJ3bJznbW+86MJA8NxH73oC4X1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYQMW8Gq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0486074918;
	Wed,  4 Nov 2026 21:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYQMW8Gq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48431F000C1;
	Wed,  4 Nov 2026 21:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829310;
	bh=OM8ObayKYOU0YEMSKFgt/1/9E2MJmPeQ9QMBarjmlG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYQMW8GqWCdXFvAtEqvk/SOsg7/Jxuxn622A6HsZxc/ZCW+nduFK4N0xaWPmMOjMR
	 97pSLVSQ0d9G90eFO149vdNrhBaIB3juYkVo/oRxB47HH0gDTeronM0vx3lLDGQOWE
	 kr9HIo1r4LJLMQN/YtNm5VC1/ddfXkAxYLOhyut8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sashiko <sashiko-bot@kernel.org>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0044/1005] drm/sysfb: simpledrm: Validate mmap size against framebuffer size
Date: Wed,  4 Nov 2026 15:56:17 -0500
Message-ID: <20261104211044.816186294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 127d52f9c64b1d9aab6226c4a1f38c37fb7254dc ]

The size of the mmap'ed framebuffer could be smaller than the minimum
required framebuffer size. Validate the resource size against the
framebuffer size.

Buggy firmware that triggers this check should be fixed up with a quirk
on a case-by-case base.

v3:
- fix size checks (Sashiko)
- improve error message for alignment check (Thierry)
- do not store aligned size value

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Suggested-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260625094509.157581-6-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sysfb/simpledrm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/gpu/drm/sysfb/simpledrm.c b/drivers/gpu/drm/sysfb/simpledrm.c
index 22f8caab39be0..91f114ab99a3e 100644
--- a/drivers/gpu/drm/sysfb/simpledrm.c
+++ b/drivers/gpu/drm/sysfb/simpledrm.c
@@ -5,6 +5,7 @@
 #include <linux/of_clk.h>
 #include <linux/minmax.h>
 #include <linux/of_reserved_mem.h>
+#include <linux/overflow.h>
 #include <linux/platform_data/simplefb.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
@@ -626,6 +627,7 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 	u16 width_mm = 0, height_mm = 0;
 	struct device_node *panel_node;
 	const struct drm_format_info *format;
+	u64 size;
 	struct resource *res, *mem = NULL;
 	struct drm_plane *primary_plane;
 	struct drm_crtc *crtc;
@@ -716,6 +718,14 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 		}
 		stride = pitch;
 	}
+	if (check_mul_overflow(height, stride, &size)) {
+		drm_err(dev, "framebuffer size exceeds maximum\n");
+		return ERR_PTR(-EINVAL);
+	}
+	if (ALIGN(size, PAGE_SIZE) < PAGE_SIZE) {
+		drm_err(dev, "page-aligned framebuffer exceeds maximum\n");
+		return ERR_PTR(-EINVAL);
+	}
 
 	sysfb->fb_mode = drm_sysfb_mode(width, height, width_mm, height_mm);
 	sysfb->fb_format = format;
@@ -741,6 +751,13 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 
 		drm_dbg(dev, "using system memory framebuffer at %pr\n", mem);
 
+		if (size > resource_size(mem)) {
+			drm_err(dev,
+				"framebuffer size of %llu exceeds memory range %pr\n",
+				size, mem);
+			return ERR_PTR(-EINVAL);
+		}
+
 		screen_base = devm_memremap(dev->dev, mem->start, resource_size(mem), MEMREMAP_WC);
 		if (IS_ERR(screen_base))
 			return screen_base;
@@ -774,6 +791,13 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 			mem = res;
 		}
 
+		if (size > resource_size(mem)) {
+			drm_err(dev,
+				"framebuffer size of %llu exceeds memory range %pr\n",
+				size, mem);
+			return ERR_PTR(-EINVAL);
+		}
+
 		screen_base = devm_ioremap_wc(&pdev->dev, mem->start, resource_size(mem));
 		if (!screen_base)
 			return ERR_PTR(-ENOMEM);
-- 
2.53.0



