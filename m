Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB66E25DD0E;
	Wed,  9 Apr 2025 19:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744225424; cv=none; b=mNMdvB2ovA1GsQeFwB7uVJFo1vc5Qcd8aY4ZHtCF7WdxZY7s0nXW6wx17zLgzFU5WKpqFcNVAkQdivgMmBBGw2ciyeIAHDuVnrrFhBpZRFdSHahDfa4wKGXAez9H31u0y0cZZNscC16TEFmz97nIhi47tasDaoXQmvktJY9Mmw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744225424; c=relaxed/simple;
	bh=5RI7XzZpLuIxdNbstAilg7SNq3t9eP/hJt/0NSSzUkc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=C3dHpa2XcpDK45aP6+HynD52JGG+zTm47OyePv5eg+/hULmOWo+P9sbwXj32BtwgQ8CpZxPWiXORNBKS6g+G/yXulKbN91ZIw/XV/pyr0CLhs/eEY42NTy+bkCBniUztmIzV/5R7dppXmG6kYKhzHMPbhpe5VDp/gRjsTp111TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmMb65BZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmMb65BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA325C4CEE2;
	Wed,  9 Apr 2025 19:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744225422;
	bh=5RI7XzZpLuIxdNbstAilg7SNq3t9eP/hJt/0NSSzUkc=;
	h=From:Date:Subject:To:Cc:From;
	b=HmMb65BZ9IQWL5MGSXXOF+OlAaMo1yfG1cAdxW+Er8MeO4RZPFuOZIwljgkyaxmA+
	 9JmhqCdNLUHq+UpVtoEm4CX0Hzji6iimpH/Ije9PKRlpLLUelricX6ynQbHAJ1RVc4
	 uxY0mKd9BKY9J79IPgD2SnZNo7NxUmx3b2B0jK835O4Di1MnpnJ5ptIs2wezlLnnUk
	 BzlFLsxhewuQor8ziukwQzMSGlQnrtvqQsWXS06gmHLQCLJjqGGA36GbYAqmuzjqhW
	 YlYa1+dYO/nDHt/XpnALJAN5XyRQREeUH5gxB4EfiE9QQVQVbhodTj1uNkVN8zXAol
	 eMQ5PnCFDSoTg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 09 Apr 2025 12:03:17 -0700
Subject: [PATCH] drm/sysfb: efidrm: Avoid clang -Wsometimes-uninitialized
 in efidrm_device_create()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250409-efidrm-avoid-uninit-screen_info-warning-v1-1-67babb19d831@kernel.org>
X-B4-Tracking: v=1; b=H4sIAHTE9mcC/x2N0QqDMAxFf0XyvEDt1OF+ZcgoberysHSk6gbiv
 xv2eC6ce3aopEwV7s0OShtXLmLQXhqIryAzISdj8M73rnMjUuakbwxb4YSrsPCCNSqRPFlywW9
 QG2dMg6c83CJdYw/29lEzf//SYzqOE2GYieJ5AAAA
X-Change-ID: 20250409-efidrm-avoid-uninit-screen_info-warning-d62ef67ce3c5
To: Thomas Zimmermann <tzimmermann@suse.de>, 
 Javier Martinez Canillas <javierm@redhat.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>
Cc: dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2743; i=nathan@kernel.org;
 h=from:subject:message-id; bh=5RI7XzZpLuIxdNbstAilg7SNq3t9eP/hJt/0NSSzUkc=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOnfjvR4imzmZP15/NzDLVcc+dcqGkSsVnLVfXOj9PsUM
 9vsRwmiHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAik+QYGT6s0XGSv3ZG6m62
 uCQzY9z06apSVu6zK8+3xC17+3N3czrDPyvhVdniVma/bN2a57/rVni5+mqO7mdva233hMXFWU2
 T2QE=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/gpu/drm/sysfb/efidrm.c:353:11: error: variable 'screen_base' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
    353 |         else if (mem_flags & EFI_MEMORY_WB)
        |                  ^~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/sysfb/efidrm.c:356:7: note: uninitialized use occurs here
    356 |         if (!screen_base)
        |              ^~~~~~~~~~~
  drivers/gpu/drm/sysfb/efidrm.c:353:7: note: remove the 'if' if its condition is always true
    353 |         else if (mem_flags & EFI_MEMORY_WB)
        |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    354 |                 screen_base = devm_memremap(&pdev->dev, mem->start, resource_size(mem),
  drivers/gpu/drm/sysfb/efidrm.c:261:27: note: initialize the variable 'screen_base' to silence this warning
    261 |         void __iomem *screen_base;
        |                                  ^
        |                                   = NULL

efidrm_get_mem_flags() can only return a mask that has at least one of
the tested values set so the else case is impossible but clang's static
analysis runs before inlining so it cannot know that.

Initialize screen_base to NULL and add a defensive print in case
mem_flags were ever returned without one of the four valid values.

Fixes: 32ae90c66fb6 ("drm/sysfb: Add efidrm for EFI displays")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/sysfb/efidrm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sysfb/efidrm.c b/drivers/gpu/drm/sysfb/efidrm.c
index af90064a4c04..7d820f42956b 100644
--- a/drivers/gpu/drm/sysfb/efidrm.c
+++ b/drivers/gpu/drm/sysfb/efidrm.c
@@ -258,7 +258,7 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
 	struct drm_sysfb_device *sysfb;
 	struct drm_device *dev;
 	struct resource *mem = NULL;
-	void __iomem *screen_base;
+	void __iomem *screen_base = NULL;
 	struct drm_plane *primary_plane;
 	struct drm_crtc *crtc;
 	struct drm_encoder *encoder;
@@ -353,6 +353,8 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
 	else if (mem_flags & EFI_MEMORY_WB)
 		screen_base = devm_memremap(&pdev->dev, mem->start, resource_size(mem),
 					    MEMREMAP_WB);
+	else
+		drm_warn(dev, "unhandled mem_flags: 0x%llx\n", mem_flags);
 	if (!screen_base)
 		return ERR_PTR(-ENOMEM);
 	iosys_map_set_vaddr_iomem(&sysfb->fb_addr, screen_base);

---
base-commit: e8bf4a1bdaeadb28d13b9a2bcfd5910fda06eede
change-id: 20250409-efidrm-avoid-uninit-screen_info-warning-d62ef67ce3c5

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

