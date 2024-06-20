Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A401AD411;
	Thu, 20 Jun 2024 15:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898504; cv=none; b=n2IjUy4Nz+6kDpvVn3Nmb0h2g4drvVEqnMg04THj0nQz6pIfMxVelIy80ZLMDWCnIqz9Cv1VIOLlTKbGbN8UJGaOjX0JR7mmdCL5hv+AjRDc96bizCPlTVvAr5Yi8hiO5un8syroqJ8iMRA4TcBehZQDOPR1Ofzo+LVSqOjJ7bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898504; c=relaxed/simple;
	bh=ERDzmEKBIwJPWXFItLB7ZAVRuz4nYQB2+DCaWb+Lv9Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=NEuLpneFVJ3kzsS8zO8seWN13PkTTHBjXfKo4ZYMiACML3HyOsultj3ayY+tLrBlCl2DfeNLg1VkJKrepHFFB1N0mzXy+v9qdfzkfXz2t+F44UoBbSpevwgj2aWtD+zlKpPBdKp2eDdUzv2dvMv5hmCtrhpd3WOTh3bNtEADrWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKsMBpoY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKsMBpoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F870C2BD10;
	Thu, 20 Jun 2024 15:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718898503;
	bh=ERDzmEKBIwJPWXFItLB7ZAVRuz4nYQB2+DCaWb+Lv9Q=;
	h=From:Date:Subject:To:Cc:From;
	b=WKsMBpoY25Fs48ZgJylb7NIQRdeMPAvjI62ChRSmww8tNYdAIeLgzcY5UObWfT+nn
	 +jl073Ax5gqXQeZri6KaB65QlosptQnixQSi1L/A1BDY0PA5LpQpGCA7ewDs0eeRVp
	 mM+PV3u5vjii+vACk2nvyMgJ/3ScRxGGzmNemNY72lU/lkau96l11p7HrD7RmWiSdu
	 nell6aahNS8XKn09eiHQR/38hZ61l/5G9EL3yeQR3V1/XgES75zbTozXqDc2gi3zqv
	 3gb2x/KQjEmiXhRpScfdZ/jvNKsNehfY+UDUXYZTIDz0uc9rBF298oVO9XM794HzCD
	 xZdKyJf0KFzmg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 20 Jun 2024 08:48:16 -0700
Subject: [PATCH] drm/omap: Restrict compile testing to PAGE_SIZE less than
 64KB
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240620-omapdrm-restrict-compile-test-to-sub-64kb-page-size-v1-1-5e56de71ffca@kernel.org>
X-B4-Tracking: v=1; b=H4sIAD9PdGYC/x2NywrCMBBFf6XM2oGYllr8FXGRx6iDpgkzqUhL/
 73B5blw7tlASZgUrt0GQl9WznOD86mD8HLzk5BjY7DGDma0BnNyJUpCIa3CoWLIqfCHsLYBa0Z
 dPI7D22NxzVZeCU2YYn+hfjLeQ3suQg/+/au3+74frQTP6oUAAAA=
To: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2819; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ERDzmEKBIwJPWXFItLB7ZAVRuz4nYQB2+DCaWb+Lv9Q=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkl/u6f7Ddf0HkjaeG9JMPjU2dy7+n/twUuT3h24Cyn5
 9uZzSs9OkpZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEokMY/hldl9tQxFR4qojv
 /7EnzKlSUUZe6lM09e90doYIbhbc1cLwvzB1XtEjhQ9P5G0MGNLO313TLe2/eELdtI17sud8NmJ
 Q5wYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Prior to commit dc6fcaaba5a5 ("drm/omap: Allow build with
COMPILE_TEST=y"), it was only possible to build the omapdrm driver with
a 4KB page size. After that change, when the PAGE_SIZE is 64KB or
larger, clang points out that the driver has some assumptions around the
page size implicitly by passing PAGE_SIZE to a parameter with a type of
u16:

  drivers/gpu/drm/omapdrm/omap_gem.c:758:7: error: implicit conversion from 'unsigned long' to 'u16' (aka 'unsigned short') changes value from 65536 to 0 [-Werror,-Wconstant-conversion]
    757 |                 block = tiler_reserve_2d(fmt, omap_obj->width, omap_obj->height,
        |                         ~~~~~~~~~~~~~~~~
    758 |                                          PAGE_SIZE);
        |                                          ^~~~~~~~~
  arch/powerpc/include/asm/page.h:25:34: note: expanded from macro 'PAGE_SIZE'
     25 | #define PAGE_SIZE               (ASM_CONST(1) << PAGE_SHIFT)
        |                                  ~~~~~~~~~~~~~^~~~~~~~~~~~~
  drivers/gpu/drm/omapdrm/omap_gem.c:1504:44: error: implicit conversion from 'unsigned long' to 'u16' (aka 'unsigned short') changes value from 65536 to 0 [-Werror,-Wconstant-conversion]
   1504 |                         block = tiler_reserve_2d(fmts[i], w, h, PAGE_SIZE);
        |                                 ~~~~~~~~~~~~~~~~                ^~~~~~~~~
  arch/powerpc/include/asm/page.h:25:34: note: expanded from macro 'PAGE_SIZE'
     25 | #define PAGE_SIZE               (ASM_CONST(1) << PAGE_SHIFT)
        |                                  ~~~~~~~~~~~~~^~~~~~~~~~~~~
  2 errors generated.

As there is a lot of use of a u16 type throughout this driver and it
will only ever be run on hardware that has a 4KB page size, just
restrict compile testing to when the page size is less than 64KB (as no
other issues have been discussed and it keeps compile testing relatively
more available).

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/omapdrm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/Kconfig b/drivers/gpu/drm/omapdrm/Kconfig
index 85ed92042b74..3f7139e211d2 100644
--- a/drivers/gpu/drm/omapdrm/Kconfig
+++ b/drivers/gpu/drm/omapdrm/Kconfig
@@ -2,7 +2,7 @@
 config DRM_OMAP
 	tristate "OMAP DRM"
 	depends on DRM && OF
-	depends on ARCH_OMAP2PLUS || COMPILE_TEST
+	depends on ARCH_OMAP2PLUS || (COMPILE_TEST && PAGE_SIZE_LESS_THAN_64KB)
 	select DRM_KMS_HELPER
 	select FB_DMAMEM_HELPERS_DEFERRED if DRM_FBDEV_EMULATION
 	select VIDEOMODE_HELPERS

---
base-commit: c62b4fc4b9b86ab35e5c4236f2053ce21ee81ebc
change-id: 20240620-omapdrm-restrict-compile-test-to-sub-64kb-page-size-0c8d37e380bb

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

