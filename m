Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924F03A6B67;
	Sat, 17 Oct 2026 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253206; cv=none; b=JTbWPkpwWn4frUMCrQ+NTvkA8N9o5REk3F+SDL8lDMBwcvsg+jJk1j79eX5tUmpoP9J2DGt0nEHAI8cQvzCttTgZFYMOsGcWc1+3IKmnRr+XGEn7NK/w0ZClHwZfSY0He3jXnsy0a/nTbF3l3fxwTZGYDMsVfv1j90KW9zb5KP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253206; c=relaxed/simple;
	bh=VSZe2v3T6PVHe/3B/KwvzdLn+l6MlS7jcbS9vdG7SLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZIcT8QMjkGX/tOAWS5+Jsrl8w1qzWMlxcfQQsXpxtnuhAcpaQzNntBjw+LBLODEPBBn4JK+HikT7UFKN6Bgjfp7X1SffVE13EtwNk0xer3Etlf5SooZttPh9DDlpuptpiJPnhgL+7L31YqJFTAlZ7XmykOKwUMsYqF9aOQLwMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfFealQG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfFealQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E751F000C5;
	Sat, 17 Oct 2026 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253204;
	bh=kD+wayaM9vlCkOpwWqbY6LJmI4a1+EnilLWq5cBTG4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfFealQGOPyLVDlPRUigO8QoHy4Y5oCY83ZsPdii09s1JfcFCg65dNpqHByUfudE+
	 bE38XHXWr6Z/C40f+isKTpOJCrbvp6x+vmVWoIx5nKTf9LKdvw5+E9mU0nqI+HOd89
	 5u/sY7LS7c1XoSrBce51atcCjt/AQBcd9M5epowU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/869] drm/vc4: Use video aperture helpers
Date: Sat, 17 Oct 2026 17:48:04 +0200
Message-ID: <20261017160038.119945574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 7e89e4365fd36ca006670788ec2c1527bfd0c61c ]

DRM's aperture functions have long been implemented as helpers
under drivers/video/ for use with fbdev. Avoid the DRM wrappers by
calling the video functions directly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.com>
Cc: Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930130921.689876-25-tzimmermann@suse.de
Stable-dep-of: b816da5d5df1 ("drm/vc4: Fix firmware reference leak in vc4_drm_bind()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 8c104ace3dc6e..802e716f7dc83 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -20,6 +20,7 @@
  * driver.
  */
 
+#include <linux/aperture.h>
 #include <linux/clk.h>
 #include <linux/component.h>
 #include <linux/device.h>
@@ -30,7 +31,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 
-#include <drm/drm_aperture.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_fbdev_dma.h>
@@ -356,7 +356,7 @@ static int vc4_drm_bind(struct device *dev)
 		}
 	}
 
-	ret = drm_aperture_remove_framebuffers(driver);
+	ret = aperture_remove_all_conflicting_devices(driver->name);
 	if (ret)
 		goto err;
 
-- 
2.53.0



