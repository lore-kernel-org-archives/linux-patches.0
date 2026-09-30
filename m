Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736B034CFDE;
	Wed, 30 Sep 2026 19:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794933; cv=none; b=ZP1IomI7k9bqmM0mn17c4A44i7m4J95d8Xfg4NU6nkVsEGlQX3p/awZKZb0WINTqXdBGWtZLY0wawWjLBmGvMQzL6eSU4XiSsOsr49xKcmTyZXFgzBl7St/03zrNFMr0Fjevw28LEoWeNAGm+oyFF+mvM5BYKKVxomnCVbaKbSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794933; c=relaxed/simple;
	bh=WKOf2UZ8wNvGEx4gE1FHRbP9EKMhBxSP6spJxWgvVtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9oZ16MLqWQL9pZI3DyxOPfVAVejhcsh0XdzlV7tW2YQ1sAb+4wkpnuW2h1xc68who2FWszxCJ44WMN21YXkhu4DuTxowQ4uXNjB3NdwFNR5hkeKRHePEHDCxbbrDI6o4/nxGgVzMeICIANLzbWkpeA7d9tmDfmOUOt+doWIYoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkThZzxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkThZzxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52391F000FF;
	Wed, 30 Sep 2026 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794932;
	bh=LtvFee2LSQsaZ4RE3MaJQh3vLWK1HbMDVaiB7u+ADuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkThZzxyvmbbTkFtUv2pdNlcad8fO9TkA11y5rSwK7Azn7MZtxs4ZhZ8tnkRg197m
	 Ck1jpwNQW3sxLquqWtrLg2byWIxHinpcA2E6iMEs3P88stxE9Td9o4ltktprEFMJhg
	 emHUhQqyy28k6izW8AotwOby0yTB/zMi1/fJeAAs=
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
Subject: [PATCH 6.6 0385/1193] drm/cirrus: Use video aperture helpers
Date: Wed, 30 Sep 2026 17:17:49 +0200
Message-ID: <20260930152442.737933651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b0361ef53c463..e1ebb651106af 100644
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
@@ -669,7 +669,7 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
 	struct cirrus_device *cirrus;
 	int ret;
 
-	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &cirrus_driver);
+	ret = aperture_remove_conflicting_pci_devices(pdev, cirrus_driver.name);
 	if (ret)
 		return ret;
 
-- 
2.53.0



