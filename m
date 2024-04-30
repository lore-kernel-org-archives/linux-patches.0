Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880D01292C8;
	Tue, 30 Apr 2024 10:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474053; cv=none; b=qmRZ7lElFSC24Mxd4P0QIuGqiNw9xtMNN6UNrFea0uCGzLDaCdCejG9OhxBqL+2yovqOTkkPXCxwLHAgr6jlkAqttMDcvJKc838HrMHPyIv2PKpOHMcTog9Dgfygr1ghL1Z3XwvwhKnOoTVg8KKi2DVaEOBRnWseWXFz3aMR4M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474053; c=relaxed/simple;
	bh=Y3Pcb+eknOaKEwPtq4rKPu2zIPB780yAuKxfMkb5ODo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcKx6opTYO66BDlNFxI3b7NAVNisweJ6y9vSawaosijDrHMEwDWQJpdJRzT4UXQOmWbx+TTia8dAaykpwpeBL7yubQwuiAbFsN9xK6pr+3w8AASUiXqqEbABWpWQ4ae2jk4/saucpL8/UqvpznWwFVRu/aJyY8i7QLGB590lddw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGMTGa9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGMTGa9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6CBC2BBFC;
	Tue, 30 Apr 2024 10:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474053;
	bh=Y3Pcb+eknOaKEwPtq4rKPu2zIPB780yAuKxfMkb5ODo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGMTGa9Dp7I5J69vxCrBFlpB+sJC5qe70na2+IHz0su6BhwDKlz0PDy4qWhxpqZwM
	 SQd2/NUoSp+j0siDLyNLd1Gn/cVf35KS4WfTiPATgHdnL/YFlSG6TVf+Qy7UN1qT1S
	 jEfkHqFcO48GIZjOExoEcdugXKDnmMG7BaUZz6W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrico Bartky <enrico.bartky@gmail.com>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 044/228] drm/gma500: Remove lid code
Date: Tue, 30 Apr 2024 12:37:02 +0200
Message-ID: <20240430103105.084645162@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

[ Upstream commit 6aff4c26ed677b1f464f721fbd3e7767f24a684d ]

Due to a change in the order of initialization, the lid timer got
started before proper setup was made. This resulted in a crash during
boot.

The lid switch is handled by gma500 through a timer that periodically
polls the opregion for changes. These types of ACPI events shouldn't be
handled by the graphics driver so let's get rid of the lid code.  This
fixes the crash during boot.

Reported-by: Enrico Bartky <enrico.bartky@gmail.com>
Fixes: 8f1aaccb04b7 ("drm/gma500: Implement client-based fbdev emulation")
Tested-by: Enrico Bartky <enrico.bartky@gmail.com>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415112731.31841-1-patrik.r.jakobsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/Makefile     |  1 -
 drivers/gpu/drm/gma500/psb_device.c |  5 +-
 drivers/gpu/drm/gma500/psb_drv.h    |  9 ----
 drivers/gpu/drm/gma500/psb_lid.c    | 80 -----------------------------
 4 files changed, 1 insertion(+), 94 deletions(-)
 delete mode 100644 drivers/gpu/drm/gma500/psb_lid.c

diff --git a/drivers/gpu/drm/gma500/Makefile b/drivers/gpu/drm/gma500/Makefile
index 4f302cd5e1a6c..58fed80c7392a 100644
--- a/drivers/gpu/drm/gma500/Makefile
+++ b/drivers/gpu/drm/gma500/Makefile
@@ -34,7 +34,6 @@ gma500_gfx-y += \
 	  psb_intel_lvds.o \
 	  psb_intel_modes.o \
 	  psb_intel_sdvo.o \
-	  psb_lid.o \
 	  psb_irq.o
 
 gma500_gfx-$(CONFIG_ACPI) +=  opregion.o
diff --git a/drivers/gpu/drm/gma500/psb_device.c b/drivers/gpu/drm/gma500/psb_device.c
index dcfcd7b89d4a1..6dece8f0e380f 100644
--- a/drivers/gpu/drm/gma500/psb_device.c
+++ b/drivers/gpu/drm/gma500/psb_device.c
@@ -73,8 +73,7 @@ static int psb_backlight_setup(struct drm_device *dev)
 	}
 
 	psb_intel_lvds_set_brightness(dev, PSB_MAX_BRIGHTNESS);
-	/* This must occur after the backlight is properly initialised */
-	psb_lid_timer_init(dev_priv);
+
 	return 0;
 }
 
@@ -259,8 +258,6 @@ static int psb_chip_setup(struct drm_device *dev)
 
 static void psb_chip_teardown(struct drm_device *dev)
 {
-	struct drm_psb_private *dev_priv = to_drm_psb_private(dev);
-	psb_lid_timer_takedown(dev_priv);
 	gma_intel_teardown_gmbus(dev);
 }
 
diff --git a/drivers/gpu/drm/gma500/psb_drv.h b/drivers/gpu/drm/gma500/psb_drv.h
index c5edfa4aa4ccd..83c17689c454f 100644
--- a/drivers/gpu/drm/gma500/psb_drv.h
+++ b/drivers/gpu/drm/gma500/psb_drv.h
@@ -162,7 +162,6 @@
 #define PSB_NUM_VBLANKS 2
 
 #define PSB_WATCHDOG_DELAY (HZ * 2)
-#define PSB_LID_DELAY (HZ / 10)
 
 #define PSB_MAX_BRIGHTNESS		100
 
@@ -491,11 +490,7 @@ struct drm_psb_private {
 	/* Hotplug handling */
 	struct work_struct hotplug_work;
 
-	/* LID-Switch */
-	spinlock_t lid_lock;
-	struct timer_list lid_timer;
 	struct psb_intel_opregion opregion;
-	u32 lid_last_state;
 
 	/* Watchdog */
 	uint32_t apm_reg;
@@ -591,10 +586,6 @@ struct psb_ops {
 	int i2c_bus;		/* I2C bus identifier for Moorestown */
 };
 
-/* psb_lid.c */
-extern void psb_lid_timer_init(struct drm_psb_private *dev_priv);
-extern void psb_lid_timer_takedown(struct drm_psb_private *dev_priv);
-
 /* modesetting */
 extern void psb_modeset_init(struct drm_device *dev);
 extern void psb_modeset_cleanup(struct drm_device *dev);
diff --git a/drivers/gpu/drm/gma500/psb_lid.c b/drivers/gpu/drm/gma500/psb_lid.c
deleted file mode 100644
index 58a7fe3926360..0000000000000
--- a/drivers/gpu/drm/gma500/psb_lid.c
+++ /dev/null
@@ -1,80 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/**************************************************************************
- * Copyright (c) 2007, Intel Corporation.
- *
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- **************************************************************************/
-
-#include <linux/spinlock.h>
-
-#include "psb_drv.h"
-#include "psb_intel_reg.h"
-#include "psb_reg.h"
-
-static void psb_lid_timer_func(struct timer_list *t)
-{
-	struct drm_psb_private *dev_priv = from_timer(dev_priv, t, lid_timer);
-	struct drm_device *dev = (struct drm_device *)&dev_priv->dev;
-	struct timer_list *lid_timer = &dev_priv->lid_timer;
-	unsigned long irq_flags;
-	u32 __iomem *lid_state = dev_priv->opregion.lid_state;
-	u32 pp_status;
-
-	if (readl(lid_state) == dev_priv->lid_last_state)
-		goto lid_timer_schedule;
-
-	if ((readl(lid_state)) & 0x01) {
-		/*lid state is open*/
-		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) | POWER_TARGET_ON);
-		do {
-			pp_status = REG_READ(PP_STATUS);
-		} while ((pp_status & PP_ON) == 0 &&
-			 (pp_status & PP_SEQUENCE_MASK) != 0);
-
-		if (REG_READ(PP_STATUS) & PP_ON) {
-			/*FIXME: should be backlight level before*/
-			psb_intel_lvds_set_brightness(dev, 100);
-		} else {
-			DRM_DEBUG("LVDS panel never powered up");
-			return;
-		}
-	} else {
-		psb_intel_lvds_set_brightness(dev, 0);
-
-		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) & ~POWER_TARGET_ON);
-		do {
-			pp_status = REG_READ(PP_STATUS);
-		} while ((pp_status & PP_ON) == 0);
-	}
-	dev_priv->lid_last_state =  readl(lid_state);
-
-lid_timer_schedule:
-	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);
-	if (!timer_pending(lid_timer)) {
-		lid_timer->expires = jiffies + PSB_LID_DELAY;
-		add_timer(lid_timer);
-	}
-	spin_unlock_irqrestore(&dev_priv->lid_lock, irq_flags);
-}
-
-void psb_lid_timer_init(struct drm_psb_private *dev_priv)
-{
-	struct timer_list *lid_timer = &dev_priv->lid_timer;
-	unsigned long irq_flags;
-
-	spin_lock_init(&dev_priv->lid_lock);
-	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);
-
-	timer_setup(lid_timer, psb_lid_timer_func, 0);
-
-	lid_timer->expires = jiffies + PSB_LID_DELAY;
-
-	add_timer(lid_timer);
-	spin_unlock_irqrestore(&dev_priv->lid_lock, irq_flags);
-}
-
-void psb_lid_timer_takedown(struct drm_psb_private *dev_priv)
-{
-	del_timer_sync(&dev_priv->lid_timer);
-}
-
-- 
2.43.0



