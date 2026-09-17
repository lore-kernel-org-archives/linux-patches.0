Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762C6502D70;
	Thu, 17 Sep 2026 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668725; cv=none; b=V5P5cr6Pm7dHlNynHWTr5/8crngYpNjZvd8zg9GZXfTLpanpyVEf1Y+yCXSTJigtRPz7v1XfWXWlke7xQtFWEOKxpXm0o3OU5OyvAnf54sxHj+lrSMkQNJtzrUxf4xad4rN0MRRWXKNKxRknpfTxe9UYpzFMlivL3lE9NJ+eDY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668725; c=relaxed/simple;
	bh=b4N9WlKwNS4e8TQYikh/LUYE+/EyaO12phoU3aKt3mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYCWrugnFRFQLxF3aPYl27VeftRxTQjKREXD3JIOCgrmbhnXOHi7K+HD5Ta4A/uIpDtzROJWrO5tVRycUDoy/LAbuk9cjp+d8Cx2DWS0Z98ppk4esBEFVED/QnTHnR30G1ToQ/qd6vLd+7QIpJibaE0ryiJfnhGLkHF3CG7q3UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2AKzmvJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2AKzmvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B2A1F000FF;
	Thu, 17 Sep 2026 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668723;
	bh=6NrZkwBaBd4mQ7ccJ7not3gLM5/tIoA0hV8dtHGgOMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2AKzmvJW0ZmjynbAaRxQPzxIBVQc+0lk08Kt0Iill7aft5I/+Gc3lwOr7RPp8Pvb
	 OFR31BbH4n3CFtRAXLCD2cI3NDybwl16PvXnWJbOhdSl2fYqMJuBSGfwnSMjA12HaT
	 3W2pgCYqCyT1uUMyiaX/NKuTEHLyl5ylKWh8VM4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Dave Airlie <airlied@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0513/1102] drm/cirrus: Use video aperture helpers
Date: Thu, 17 Sep 2026 16:07:36 +0100
Message-ID: <20260917151552.629432325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit c77ec6b18b0397cf1f0c270ea77310f70fe48081 ]

DRM's aperture functions have long been implemented as helpers
under drivers/video/ for use with fbdev. Avoid the DRM wrappers by
calling the video functions directly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930130921.689876-23-tzimmermann@suse.de
Stable-dep-of: 92312d333bf7 ("drm/cirrus-qemu: Validate BAR0 size during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/cirrus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tiny/cirrus.c b/drivers/gpu/drm/tiny/cirrus.c
index c7e81f2610f8c..bf0e6e297e33a 100644
--- a/drivers/gpu/drm/tiny/cirrus.c
+++ b/drivers/gpu/drm/tiny/cirrus.c
@@ -16,6 +16,7 @@
  * Copyright 1999-2001 Jeff Garzik <jgarzik@pobox.com>
  */
 
+#include <linux/aperture.h>
 #include <linux/iosys-map.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -23,7 +24,6 @@
 #include <video/cirrus.h>
 #include <video/vga.h>
 
-#include <drm/drm_aperture.h>
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_atomic_state_helper.h>
@@ -670,7 +670,7 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
 	struct cirrus_device *cirrus;
 	int ret;
 
-	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &cirrus_driver);
+	ret = aperture_remove_conflicting_pci_devices(pdev, cirrus_driver.name);
 	if (ret)
 		return ret;
 
-- 
2.53.0



