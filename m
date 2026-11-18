Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018078;
	b=uDxQfg0HaoWLN89feIsHBgvCJVn5lrvIAXEgiml6iO8KCwAL7s+mCeS2RHiga3wimUF1
	 rV99nRl+XIzep+hYxmX7xlO1+ZdeAML5TEyaEXvLcOc55roOAWxxyb1l788IfiHa7C1Q+
	 HuIgRKYhuDDtlEjOSx3UiJHTui9Fx+O52IXhPVh7y2LpLnSWCI/Y9dcYB4+UOAWLpR0n5
	 J5EgoytZ0ahUbxdMFfPuoUElzHbvatQBVBK0buUpwxHX4t77qHC4YT4h3mziBPLLj6xvV
	 HYCp2DUZ/V6fiQFG7fPnUm0KG0jftICRLAUldNs53D7saQag4HDUkflCoJbaYjsp3zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JZeNGhqHlL9qn2ynd3Rcrgq94yFZ7dGJujA4KZnyRBc=;
	b=V8L/FHAlFvnrsz1oJQjKxRbyvhSDwiNS8eM5+7ClFCJtv9iq7cBSUhUmtgcY84W7wSSX
	 MuF/u+67YBM1dy5ed7b0J97dt5YbnKLktrto58/6ipkvsnaY54AT4fopVNu1Dyipx9IBh
	 aKP7dZ3/QgjlzYTTPdnkKIFDLWU7e7zd5v7mqdASq2pS9jTXk7ouDbHp62elZJNKRQBfQ
	 EfXKa6VZMeWTgzjLNobaLs6fAzYY36CLgdRqdV88WzybrlcdIebH3U/LmCt1w3JFKNIkS
	 BWSyHO509SlNh1kDMLzlWDhCB4Sem4unCsWTUc80XkIlCLfuezB/efDJneK5uFNXvcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsSEV1+9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88221606A336;
	Wed, 18 Nov 2026 16:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsSEV1+9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6ED1F000C5;
	Wed, 18 Nov 2026 16:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018078;
	bh=JZeNGhqHlL9qn2ynd3Rcrgq94yFZ7dGJujA4KZnyRBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsSEV1+9lnjhBthKLQXHqvH9KnVzWK7xFCa93DVh2ImbbRhiZV06YTv31xUe57Ipq
	 11QSyl42GDoOpt5IL00ks5kFew0vSYv+WqwPQsO2BgZR4DmOHj0OI/G5ZgBX4Xtcmd
	 RIYOi0i7iBUuunUa3FDs4MuyxBP8TxJ64I/ZXIxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1088/2651] drm: Move drm_timeout_abs_to_jiffies() to drm_timeout.c
Date: Wed, 18 Nov 2026 15:38:48 +0100
Message-ID: <20261118150327.168628138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit ae72b9c39d280e02b1c9e6c91f1f7dd23b550a85 ]

drm_timeout_abs_to_jiffies() began as a static helper inside the syncobj
wait implementation and was later exported in place, so that it could be
called by multiple drivers (e.g. panfrost, lima, tegra and accel
drivers). All of them reach it through drm_utils.h.

Give it a file of its own, so that timeout conversion helpers have a
home, which will be useful when we add new timeout handlers. Also create
a drm_timeout.h header to host all timeout-related helpers.

The function was moved to the new file as it is, including the use of
"signed long" as the return type. Note that the return and parameters
types should be reconsidered in the future to better represent the
non-negative nature of a timeout.

No functional change.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patch.msgid.link/20260915-drm-timeout-helpers-v3-1-f2ae987d861f@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Stable-dep-of: 88b7a9fb64af ("drm/vc4: Use drm_timeout_rel_to_jiffies()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ethosu/ethosu_drv.c       |  2 +-
 drivers/accel/ivpu/ivpu_gem.c           |  2 +-
 drivers/accel/rocket/rocket_gem.c       |  2 +-
 drivers/gpu/drm/Makefile                |  1 +
 drivers/gpu/drm/drm_syncobj.c           | 35 +----------------
 drivers/gpu/drm/drm_timeout.c           | 50 +++++++++++++++++++++++++
 drivers/gpu/drm/lima/lima_gem.c         |  2 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c |  2 +-
 drivers/gpu/drm/tegra/uapi.c            |  2 +-
 drivers/gpu/drm/xe/xe_wait_user_fence.c |  2 +-
 include/drm/drm_timeout.h               | 16 ++++++++
 include/drm/drm_utils.h                 |  2 -
 12 files changed, 75 insertions(+), 43 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_timeout.c
 create mode 100644 include/drm/drm_timeout.h

diff --git a/drivers/accel/ethosu/ethosu_drv.c b/drivers/accel/ethosu/ethosu_drv.c
index 8108622de258f..4a24bbd2bb617 100644
--- a/drivers/accel/ethosu/ethosu_drv.c
+++ b/drivers/accel/ethosu/ethosu_drv.c
@@ -12,10 +12,10 @@
 
 #include <drm/drm_drv.h>
 #include <drm/drm_ioctl.h>
-#include <drm/drm_utils.h>
 #include <drm/drm_gem.h>
 #include <drm/drm_accel.h>
 #include <drm/drm_managed.h>
+#include <drm/drm_timeout.h>
 #include <drm/ethosu_accel.h>
 
 #include "ethosu_drv.h"
diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index 4f2005a8d4966..563eeffb57365 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -12,7 +12,7 @@
 #include <drm/drm_cache.h>
 #include <drm/drm_debugfs.h>
 #include <drm/drm_file.h>
-#include <drm/drm_utils.h>
+#include <drm/drm_timeout.h>
 
 #include "ivpu_drv.h"
 #include "ivpu_fw.h"
diff --git a/drivers/accel/rocket/rocket_gem.c b/drivers/accel/rocket/rocket_gem.c
index a5fffa51ff355..d981c6a93ff12 100644
--- a/drivers/accel/rocket/rocket_gem.c
+++ b/drivers/accel/rocket/rocket_gem.c
@@ -3,7 +3,7 @@
 
 #include <drm/drm_device.h>
 #include <drm/drm_print.h>
-#include <drm/drm_utils.h>
+#include <drm/drm_timeout.h>
 #include <drm/rocket_accel.h>
 #include <linux/dma-mapping.h>
 #include <linux/iommu.h>
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index e635fcffd3790..7283cf87880f1 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -68,6 +68,7 @@ drm-y := \
 	drm_rect.o \
 	drm_syncobj.o \
 	drm_sysfs.o \
+	drm_timeout.o \
 	drm_trace_points.o \
 	drm_vblank.o \
 	drm_vblank_work.o \
diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index c23a5de27effa..f1d4da1685457 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -208,7 +208,7 @@
 #include <drm/drm_gem.h>
 #include <drm/drm_print.h>
 #include <drm/drm_syncobj.h>
-#include <drm/drm_utils.h>
+#include <drm/drm_timeout.h>
 
 #include "drm_internal.h"
 
@@ -1193,39 +1193,6 @@ static signed long drm_syncobj_array_wait_timeout(struct drm_syncobj **syncobjs,
 	return timeout;
 }
 
-/**
- * drm_timeout_abs_to_jiffies - calculate jiffies timeout from absolute value
- *
- * @timeout_nsec: timeout nsec component in ns, 0 for poll
- *
- * Calculate the timeout in jiffies from an absolute time in sec/nsec.
- */
-signed long drm_timeout_abs_to_jiffies(int64_t timeout_nsec)
-{
-	ktime_t abs_timeout, now;
-	u64 timeout_ns, timeout_jiffies64;
-
-	/* make 0 timeout means poll - absolute 0 doesn't seem valid */
-	if (timeout_nsec == 0)
-		return 0;
-
-	abs_timeout = ns_to_ktime(timeout_nsec);
-	now = ktime_get();
-
-	if (!ktime_after(abs_timeout, now))
-		return 0;
-
-	timeout_ns = ktime_to_ns(ktime_sub(abs_timeout, now));
-
-	timeout_jiffies64 = nsecs_to_jiffies64(timeout_ns);
-	/*  clamp timeout to avoid infinite timeout */
-	if (timeout_jiffies64 >= MAX_SCHEDULE_TIMEOUT - 1)
-		return MAX_SCHEDULE_TIMEOUT - 1;
-
-	return timeout_jiffies64 + 1;
-}
-EXPORT_SYMBOL(drm_timeout_abs_to_jiffies);
-
 static int drm_syncobj_array_wait(struct drm_device *dev,
 				  struct drm_file *file_private,
 				  struct drm_syncobj_wait *wait,
diff --git a/drivers/gpu/drm/drm_timeout.c b/drivers/gpu/drm/drm_timeout.c
new file mode 100644
index 0000000000000..9329bceb02366
--- /dev/null
+++ b/drivers/gpu/drm/drm_timeout.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Timeout conversion helpers for wait ioctls.
+ *
+ * Copyright 2017 Red Hat
+ * Copyright 2016 Advanced Micro Devices, Inc.
+ */
+
+#include <linux/export.h>
+#include <linux/jiffies.h>
+#include <linux/ktime.h>
+#include <linux/sched.h>
+
+#include <drm/drm_timeout.h>
+
+/**
+ * drm_timeout_abs_to_jiffies - calculate jiffies timeout from absolute value
+ * @timeout_nsec: timeout nsec component in ns, 0 for poll
+ *
+ * Calculate the timeout in jiffies from an absolute time in ns. The result is
+ * clamped to MAX_SCHEDULE_TIMEOUT - 1 to avoid infinite timeouts.
+ *
+ * Returns:
+ * The number of jiffies until the given timeout, or the upper limit.
+ */
+signed long drm_timeout_abs_to_jiffies(s64 timeout_nsec)
+{
+	ktime_t abs_timeout, now;
+	u64 timeout_ns, timeout_jiffies64;
+
+	/* make 0 timeout means poll - absolute 0 doesn't seem valid */
+	if (timeout_nsec == 0)
+		return 0;
+
+	abs_timeout = ns_to_ktime(timeout_nsec);
+	now = ktime_get();
+
+	if (!ktime_after(abs_timeout, now))
+		return 0;
+
+	timeout_ns = ktime_to_ns(ktime_sub(abs_timeout, now));
+
+	timeout_jiffies64 = nsecs_to_jiffies64(timeout_ns);
+	/*  clamp timeout to avoid infinite timeout */
+	if (timeout_jiffies64 >= MAX_SCHEDULE_TIMEOUT - 1)
+		return MAX_SCHEDULE_TIMEOUT - 1;
+
+	return timeout_jiffies64 + 1;
+}
+EXPORT_SYMBOL(drm_timeout_abs_to_jiffies);
diff --git a/drivers/gpu/drm/lima/lima_gem.c b/drivers/gpu/drm/lima/lima_gem.c
index 0c73860bb501d..97e1dc541c2e0 100644
--- a/drivers/gpu/drm/lima/lima_gem.c
+++ b/drivers/gpu/drm/lima/lima_gem.c
@@ -10,7 +10,7 @@
 
 #include <drm/drm_file.h>
 #include <drm/drm_syncobj.h>
-#include <drm/drm_utils.h>
+#include <drm/drm_timeout.h>
 
 #include <drm/lima_drm.h>
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 96a66d673ba60..70c05210ea846 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -18,7 +18,7 @@
 #include <drm/drm_ioctl.h>
 #include <drm/drm_print.h>
 #include <drm/drm_syncobj.h>
-#include <drm/drm_utils.h>
+#include <drm/drm_timeout.h>
 
 #include "panfrost_device.h"
 #include "panfrost_drv.h"
diff --git a/drivers/gpu/drm/tegra/uapi.c b/drivers/gpu/drm/tegra/uapi.c
index c0ac6b45f2d70..bee310b07eb08 100644
--- a/drivers/gpu/drm/tegra/uapi.c
+++ b/drivers/gpu/drm/tegra/uapi.c
@@ -7,7 +7,7 @@
 
 #include <drm/drm_drv.h>
 #include <drm/drm_file.h>
-#include <drm/drm_utils.h>
+#include <drm/drm_timeout.h>
 
 #include "drm.h"
 #include "uapi.h"
diff --git a/drivers/gpu/drm/xe/xe_wait_user_fence.c b/drivers/gpu/drm/xe/xe_wait_user_fence.c
index 51eb940ceb4ee..e241f3ec35475 100644
--- a/drivers/gpu/drm/xe/xe_wait_user_fence.c
+++ b/drivers/gpu/drm/xe/xe_wait_user_fence.c
@@ -7,7 +7,7 @@
 
 #include <drm/drm_device.h>
 #include <drm/drm_file.h>
-#include <drm/drm_utils.h>
+#include <drm/drm_timeout.h>
 #include <uapi/drm/xe_drm.h>
 
 #include "xe_device.h"
diff --git a/include/drm/drm_timeout.h b/include/drm/drm_timeout.h
new file mode 100644
index 0000000000000..cd9621c520623
--- /dev/null
+++ b/include/drm/drm_timeout.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Function prototypes for timeout conversion helpers for wait ioctls.
+ *
+ * Copyright 2017 Red Hat
+ * Copyright 2016 Advanced Micro Devices, Inc.
+ */
+
+#ifndef __DRM_TIMEOUT_H__
+#define __DRM_TIMEOUT_H__
+
+#include <linux/types.h>
+
+signed long drm_timeout_abs_to_jiffies(s64 timeout_nsec);
+
+#endif
diff --git a/include/drm/drm_utils.h b/include/drm/drm_utils.h
index 7e077484c5bbf..c61dee76451c1 100644
--- a/include/drm/drm_utils.h
+++ b/include/drm/drm_utils.h
@@ -25,6 +25,4 @@ struct drm_panel_backlight_quirk {
 const struct drm_panel_backlight_quirk *
 drm_get_panel_backlight_quirk(const struct drm_edid *edid);
 
-signed long drm_timeout_abs_to_jiffies(int64_t timeout_nsec);
-
 #endif
-- 
2.53.0



