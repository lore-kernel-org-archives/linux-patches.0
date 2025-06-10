Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0806264638
	for <patches@lists.linux.dev>; Tue, 10 Jun 2025 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584455; cv=none; b=oMRzzhs7WNYqToK4tXOaBjBgUNjhGngJ8aRr5t4UC2rmaj1M6zDBPW8UeaFjLLlPB1q345c2qtwIRr5svxhM9zmdjUij2tyCNuBoKSQvpxNQ5uEzbXlxyDsyY7gsZ0r9MILBr9NtKolfIJ0p6OPMBSRe4FOHOrChWvxO6UQDkKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584455; c=relaxed/simple;
	bh=PuWSXOW8pH8dhgCgmmewwS2mB8eJQ3RlTMCixJuSTRg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=EndfN0hoLohCsonbPxevfOztNtzF/7iIhSVSb4ve3Jg5KvOg7RcBsHMr8ZPAmrbgvrtOhlRmcNnNIepXj5hZgSQ6gFHNiHkqGvegPIdS3SG4QF6PsHkOYfTvJzxHblUsrdV0DusS8U5LPCeQUicpIlSNl2hbatqSbOBIzPsGo6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSXq5/2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSXq5/2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E30C4CEED;
	Tue, 10 Jun 2025 19:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749584455;
	bh=PuWSXOW8pH8dhgCgmmewwS2mB8eJQ3RlTMCixJuSTRg=;
	h=From:Date:Subject:To:Cc:From;
	b=JSXq5/2iYEXiiLXbXVFlrTEApAPRoI0YncszaJavmX3+pZlkErBPwqb3SVMzxYlnn
	 of7keTaOZMCvjrGBPztqWv1i9HIPJWJ6UHnlANAnPDNXNBEf0BrsbqSA0u1rEsEQip
	 N2mU6XXiKWqt0bpAN24YqJ9mWJqxUkMmkysZc2QX//HG/HFEVoaouf6bJ2G/ugBX5K
	 ASpwNv5TBSjphe/+e8w/sZVPHW8FsqLAQr1vl+G2B9eujNpGe4n0IbCtqkifsq+kqL
	 +DLFTvD1+tZ9rdpRXvA1clqYWP6HrU/pAI9Y9wMEEBSrPh8DYFT1yyrDuVFoG1TxLr
	 YEj8C/MZ8Y5Fw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 10 Jun 2025 12:40:38 -0700
Subject: [PATCH drm-misc-fixes] drm/sitronix: st7571-i2c: Select
 VIDEOMODE_HELPERS
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250610-drm-st7571-i2c-select-videomode-helpers-v1-1-d30b50ff6e64@kernel.org>
X-B4-Tracking: v=1; b=H4sIADWKSGgC/yWNwQ6CMBAFf4Xs2U3aKhb9FeLBtA/ZhFLSJcSE8
 O9WPc4cZnZSFIHSvdmpYBOVPFewp4bC+JxfYImVyRnXmqs1HEtiXX3rLYsLrJgQVt4kIqccwSO
 mBUXZx8HcLufOdb6jWlsKBnn/Tj19I0k08F89juMDiw2vsYkAAAA=
X-Change-ID: 20250610-drm-st7571-i2c-select-videomode-helpers-7df094382878
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Javier Martinez Canillas <javierm@redhat.com>, 
 Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: dri-devel@lists.freedesktop.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1237; i=nathan@kernel.org;
 h=from:subject:message-id; bh=PuWSXOW8pH8dhgCgmmewwS2mB8eJQ3RlTMCixJuSTRg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBkeXa4sGe77DgssXbuflzerp/372y4pj4dxtpM8D4anH
 5nY0cXcUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACayUoHhr2R88IkJeQ17jA68
 2mj+9/ejhqmVeXe7FrAds87XUHGML2H4X/Hc5lzry9I3er8+xkZ8vllm/cojaXU43/unD152Teu
 wYQIA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

This driver requires of_get_display_timing() from
CONFIG_VIDEOMODE_HELPERS but does not select it. If no other driver
selects it, there will be a failure from the linker if the driver is
built in or modpost if it is a module.

  ERROR: modpost: "of_get_display_timing" [drivers/gpu/drm/sitronix/st7571-i2c.ko] undefined!

Select CONFIG_VIDEOMODE_HELPERS to resolve the build failure.

Fixes: 4b35f0f41ee2 ("drm/st7571-i2c: add support for Sitronix ST7571 LCD controller")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/sitronix/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/sitronix/Kconfig b/drivers/gpu/drm/sitronix/Kconfig
index c069d0d41775..741d1bb4b83f 100644
--- a/drivers/gpu/drm/sitronix/Kconfig
+++ b/drivers/gpu/drm/sitronix/Kconfig
@@ -5,6 +5,7 @@ config DRM_ST7571_I2C
 	select DRM_GEM_SHMEM_HELPER
 	select DRM_KMS_HELPER
 	select REGMAP_I2C
+	select VIDEOMODE_HELPERS
 	help
 	  DRM driver for Sitronix ST7571 panels controlled over I2C.
 

---
base-commit: 0cee6c4d3518b2e757aedae78771f17149f57653
change-id: 20250610-drm-st7571-i2c-select-videomode-helpers-7df094382878

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

