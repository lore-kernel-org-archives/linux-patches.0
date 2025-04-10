Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D911A1E9B38;
	Thu, 10 Apr 2025 17:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744306999; cv=none; b=ImrMCqHefCboDQCX0A9+hmqBMlgFxvEW6gvcfLlxpk0GnpR1Q4xHH8uDaiWq6B46DTJMfBuBPmKtLpP3ZUmgjc3LFGuaPShYnnCyIcf7ZzP7kbsAzqiS0h9g6/to38CZm8eo79fYs5deQenbqp4stgp2AZQJOi/W3PqJhEVNGFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744306999; c=relaxed/simple;
	bh=sGm9E2uANzIVYfSNuEofrKAgkyeSsVX70Z/Yzq8fawg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=jjzaiEIzoYZoKCPl6Jb3i1GaVAaAlP0U3hHQmOoITQUDMFQhjqCO1B6Y2NFI/Fa6CMPSe1YsjcoZ35/zSdNOkmggnEI9lr3nBp+vLhNwMjqaLZeXe6lt2PjSR3M3YmsGDbPV4cNPu8fPyuv7PJ3ygU+PV/3YoKDrjgfBfTb9W1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWJpmd8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWJpmd8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD85C4CEDD;
	Thu, 10 Apr 2025 17:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744306999;
	bh=sGm9E2uANzIVYfSNuEofrKAgkyeSsVX70Z/Yzq8fawg=;
	h=From:Date:Subject:To:Cc:From;
	b=hWJpmd8ycdtss7keQQ7nQyfRR4acb1VZPz1jeabgTUbYxvu37294IhtdmOZ0j4Vjf
	 onNFVthijSJnXXFV+RUcPfCA0iQJJKOeiLkpWPFT6cmouqG5n6fJ1z9FXMMTWOSz/C
	 cfi2jRElinkKNOc6WoTEIx/jogGeoUQ77HQmJ9rzQdM6lk5G4ppLwCcAtp+AvJU2Sh
	 +BrsaCFU5eAhpsck4OhIAiJ6pbOfhgjHQXTFuRm0Bac5PAzNaUxWVj6JwUlku4wL+I
	 rLkPxsMFMoxEWSynnjSRjv9tNyY+WW0PNMuQNjEDiYcqjqeeGgHyZQ9E6gCIfievX7
	 mI7WhTSgVHydg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 10 Apr 2025 10:43:08 -0700
Subject: [PATCH v2] drm/sysfb: efidrm: Avoid clang
 -Wsometimes-uninitialized in efidrm_device_create()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250410-efidrm-avoid-uninit-screen_info-warning-v2-1-b79646f58c24@kernel.org>
X-B4-Tracking: v=1; b=H4sIACsD+GcC/5WNQQ6CMBBFr0K6dgwtAuLKexhiSjvARGnNFKuGc
 HcrN3D5XvL/W0RAJgzilC2CMVIg7xKoXSbMqN2AQDaxULkq80PeAPZkeQIdPVl4OnI0QzCM6K7
 keg8vzUkOYCuFfVUbLEwp0tuD0/K9lS5t4pHC7PmzhaP82f8bUYKEqu5018nGHgt5viE7vO89D
 6Jd1/ULSySM5d8AAAA=
X-Change-ID: 20250409-efidrm-avoid-uninit-screen_info-warning-d62ef67ce3c5
To: Thomas Zimmermann <tzimmermann@suse.de>, 
 Javier Martinez Canillas <javierm@redhat.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>
Cc: dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3045; i=nathan@kernel.org;
 h=from:subject:message-id; bh=sGm9E2uANzIVYfSNuEofrKAgkyeSsVX70Z/Yzq8fawg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOk/mE1fNZs3syYt5Jy168jMFdu8mb6taGnfoVLOZnPhr
 JuRI9/qjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRfe8Y/hfdf9h1ZObWZ2EN
 tWbB7MVbWgXPdS3fwycndGXXiQouw/eMDIs1LHbqSudM70nr1tgtrOrhVruMac0yBzXJqtBlXJM
 n8QIA
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

Initialize screen_base to NULL and add a defensive error message in case
mem_flags were ever returned without one of the four valid values.

Fixes: 32ae90c66fb6 ("drm/sysfb: Add efidrm for EFI displays")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Upgrade drm_warn() to drm_err() and adjust message (Thomas).
- Carry forward Thomas's reviewed-by.
- Link to v1: https://lore.kernel.org/r/20250409-efidrm-avoid-uninit-screen_info-warning-v1-1-67babb19d831@kernel.org
---
 drivers/gpu/drm/sysfb/efidrm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sysfb/efidrm.c b/drivers/gpu/drm/sysfb/efidrm.c
index af90064a4c04..3cfd5d2cbf48 100644
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
+		drm_err(dev, "invalid mem_flags: 0x%llx\n", mem_flags);
 	if (!screen_base)
 		return ERR_PTR(-ENOMEM);
 	iosys_map_set_vaddr_iomem(&sysfb->fb_addr, screen_base);

---
base-commit: e8bf4a1bdaeadb28d13b9a2bcfd5910fda06eede
change-id: 20250409-efidrm-avoid-uninit-screen_info-warning-d62ef67ce3c5

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

