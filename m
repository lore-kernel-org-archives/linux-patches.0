Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFD827055E;
	Sat, 25 Oct 2025 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409051; cv=none; b=iQ/mC8s93y9uUMUTncqyC5aJHE/zuGAz05uMNZeOFoZvfDdjIdxy60g/gqWjb5FaYYA3sXWe5qyQPXdJN7NkTryoMRLqyWhysC9b5d/gPlJmNHRD8BMAWAargJ8UDFSSO5b8ppnXlgJxzVbS1jZMZIu5iKf3HODHZu0atij/PlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409051; c=relaxed/simple;
	bh=YRVHUjR+ZEhme/5Xu4snMahSNXDQiFNLSw7elUXYmAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9MjcFHfUz+jXzGyc8guM7YIQiJtqf5z8dPxm+GtbTOjkzmd+jWG0n16bKfl6NjL3Di+8PWtrpwi5+UxPULKv8Mis446orUmdBYpuOOpkFgpQtAwILvOHrB+UpdHwyTIJdXKX4oaikcEA4DFbz5np29J3IakLch15X91FY40EUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bexUw7Fb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bexUw7Fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F393C4CEF5;
	Sat, 25 Oct 2025 16:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409051;
	bh=YRVHUjR+ZEhme/5Xu4snMahSNXDQiFNLSw7elUXYmAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bexUw7Fb6TlMhRw1ycEoXEfzsOesNJAi1bzF+I8cSPFSLrXon9KmZwIHKV3nWP0w4
	 T7ZXG2YGUxZj14YULcxJu+FxBpY0n0ERCJI4f1vDWlT1dp0Mq70YD6T6NDtuG5WS8G
	 Zg5bZItoT5OR485vnd85mNzaBWpG7l1bui9ukk25HyecIIWuA2u5PABRObXC0Otrq4
	 lQr7EdkRZnG8wnwltZieUgczsnJ2iPYM8HmFGAmES40amY+U1F76nwQCEvxXiU4ZJH
	 a0yNx8K77QnRdLVmK2RbRR+U7WK8I4/yUlFs5HHM2pOR7iq4Bp0KQtTn+D10ZAAhbh
	 aN+LB6uahlMKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jyri.sarha@iki.fi,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/tidss: Remove early fb
Date: Sat, 25 Oct 2025 11:56:55 -0400
Message-ID: <20251025160905.3857885-184-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 942e54a372b44da3ffb0191b4d289d476256c861 ]

Add a call to drm_aperture_remove_framebuffers() to drop the possible
early fb (simplefb).

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20250416-tidss-splash-v1-2-4ff396eb5008@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this is a bug fix that helps users
- Removes firmware/early framebuffer (e.g., simplefb) so TIDSS can take
  over display cleanly. Without this, users can see takeover failures,
  flicker, or double-bound consoles when the SoC boots with a
  splash/firmware FB and then loads the real DRM driver. This is a
  common class of issues addressed in many DRM drivers.

What the change does
- Adds `#include <linux/aperture.h>` to use the aperture helpers
  (drivers/gpu/drm/tidss/tidss_drv.c).
- Calls `aperture_remove_all_conflicting_devices(tidss_driver.name)`
  after successful device registration and before setting up the DRM
  client/fbdev to explicitly drop early FBs (simplefb). In the posted
  diff this is placed after `drm_dev_register()` and before the
  fbdev/client setup call, matching the documented ordering for
  `drm_client_setup()`.
- Adds an error path (`err_drm_dev_unreg:`) to unwind with
  `drm_dev_unregister(ddev)` if removal unexpectedly fails.

Evidence this is the right pattern
- The kernel already provides standard helpers for this exact purpose
  and other SoC DRM drivers use them in probe/bind:
  - `drivers/gpu/drm/sun4i/sun4i_drv.c:101`:
    `drm_aperture_remove_framebuffers(&sun4i_drv_driver);`
  - `drivers/gpu/drm/rockchip/rockchip_drm_drv.c:148`:
    `drm_aperture_remove_framebuffers(&rockchip_drm_driver);`
  - `drivers/gpu/drm/stm/drv.c:191`,
    `drivers/gpu/drm/vc4/vc4_drv.c:359`, etc.
- Aperture helpers are specifically designed to hot-unplug firmware fb
  drivers and prevent sysfb from re-registering them
  (drivers/video/aperture.c). The wrapper used here
  (`aperture_remove_all_conflicting_devices`) is equivalent in intent to
  `drm_aperture_remove_framebuffers()` and is safe even if
  CONFIG_APERTURE_HELPERS=n (it is a no-op stub that returns 0).

Scope, risk, and side effects
- Small, localized to a single driver. No architectural changes.
- Only affects takeover of early/firmware framebuffers; normal operation
  otherwise unchanged.
- Error handling is conservative: on failure it unregisters the DRM
  device and unwinds. In practice, the current implementation of
  `aperture_remove_conflicting_devices()` for non-PCI platforms returns
  0 (and performs the detach), so the new error path should not trigger.
- This follows the long-standing DRM takeover model; many drivers rely
  on exactly this call to avoid conflicts with simplefb/efifb/vesafb.

Stable backport considerations
- This is a classic stable-friendly fix: improves reliability of display
  takeover; minimal risk; contained to a driver; no new features.
- The specific helper used in the patch
  (`aperture_remove_all_conflicting_devices`) lives in
  `include/linux/aperture.h` and exists in 6.1+; for older stable trees
  (e.g., 5.10/5.15), use the DRM helper instead:
  - `drm_aperture_remove_framebuffers(&tidss_driver);` (include
    `drm/drm_aperture.h`)
- Placement must remain before the fbdev/client setup for the DRM
  device:
  - In current trees using `drm_client_setup()`: keep it after
    `drm_dev_register()` and before `drm_client_setup()`.
  - In older trees using `drm_fbdev_dma_setup()` (e.g.,
    drivers/gpu/drm/tidss/tidss_drv.c:189): insert removal between
    `drm_dev_register()` (drivers/gpu/drm/tidss/tidss_drv.c:183) and
    fbdev setup (drivers/gpu/drm/tidss/tidss_drv.c:189).
- The posted diff also shows `#include "tidss_oldi.h"` and a
  `tidss_oldi_deinit(tidss)` call in an error path; those appear to be
  from adjacent series and are not required to deliver the early-FB
  removal. For minimal-risk stable backports, restrict the change to
  adding the early FB removal call and associated include, and keep
  existing error handling as-is unless those oldi changes already exist
  in the target stable branch.

Conclusion
- This is a low-risk, targeted fix that aligns TIDSS with standard DRM
  takeover practices, prevents conflicts with early/simplefb
  framebuffers, and improves user experience on TI SoCs that boot with a
  splash/firmware FB. It is suitable for stable backporting, with minor
  API adaptation on older series as noted.

 drivers/gpu/drm/tidss/tidss_drv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/tidss/tidss_drv.c b/drivers/gpu/drm/tidss/tidss_drv.c
index a1b12e52aca47..27d9a8fd541fc 100644
--- a/drivers/gpu/drm/tidss/tidss_drv.c
+++ b/drivers/gpu/drm/tidss/tidss_drv.c
@@ -8,6 +8,7 @@
 #include <linux/of.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
+#include <linux/aperture.h>
 
 #include <drm/clients/drm_client_setup.h>
 #include <drm/drm_atomic.h>
@@ -192,12 +193,20 @@ static int tidss_probe(struct platform_device *pdev)
 		goto err_irq_uninstall;
 	}
 
+	/* Remove possible early fb before setting up the fbdev */
+	ret = aperture_remove_all_conflicting_devices(tidss_driver.name);
+	if (ret)
+		goto err_drm_dev_unreg;
+
 	drm_client_setup(ddev, NULL);
 
 	dev_dbg(dev, "%s done\n", __func__);
 
 	return 0;
 
+err_drm_dev_unreg:
+	drm_dev_unregister(ddev);
+
 err_irq_uninstall:
 	tidss_irq_uninstall(ddev);
 
-- 
2.51.0

