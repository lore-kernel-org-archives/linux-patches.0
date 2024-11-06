Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794551E008D;
	Wed,  6 Nov 2024 12:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896498; cv=none; b=kdPYYsPonUcj6Ujgq3evC1CJ5w1Dr74KxCwVRhyxLIdm9msZNxe1981b4qV6v7v5KgBvY12eDC3feR5bbTOCci5YkbjuKIBVXYHXUkO+k3cQeeDyF5TNfGybIEWi3IAsEGnZQVuJLiPdAaRPMERkVOjA4Ee1AF3ORbHA16vryMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896498; c=relaxed/simple;
	bh=P4D9jbE6az0PAp96YCbyqyptmaqQpMqyElymgNeHOas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GZWsa9sBhz6A9syHMpc6SjftIsXI4BwBANQuFdJ/db9PIsoiaiBZ/INOhAqwfxJjTkDp5NBJW/oztbCc116cLWzkqYZ9kAE7CPQ4gB3y4F5I12Hi4QkvEc75AJGWcmdCdSi7qx1XELZT9gpztE2E3dNE/bWXMo04BThvERG97Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGYdWW5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGYdWW5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C0EC4CECD;
	Wed,  6 Nov 2024 12:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896498;
	bh=P4D9jbE6az0PAp96YCbyqyptmaqQpMqyElymgNeHOas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGYdWW5ziGjMPz94lAAUA9oUmOesYYyJe3X87GtICb8FbzODQX3uUDiCC/a5Rk4lx
	 OJOLVtIlAOarXoOUNDwqtmis7lN1unN50s8D9pk3eNvT1O+K8dHWCliD+CJZJoVyei
	 IlSUKhDNwBuyACCcyDeBM5AgMUYJ1Qn4L07/e5PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	intel-gfx@lists.freedesktop.org,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.11 222/245] drm/i915: disable fbc due to Wa_16023588340
Date: Wed,  6 Nov 2024 13:04:35 +0100
Message-ID: <20241106120324.724549059@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit c55f79f317ab428ae6d005965bc07e37496f209f upstream.

On BMG-G21 we need to disable fbc due to complications around the WA.

v2:
 - Try to handle with i915_drv.h and compat layer. (Rodrigo)
v3:
 - For simplicity retreat back to the original design for now.
 - Drop the extra \ from the Makefile (Jani)

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Vinod Govindapillai <vinod.govindapillai@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240703124338.208220-4-matthew.auld@intel.com
[ commit dc0f1644c47e ("drm/xe: Generate oob before compiling anything")
  makes part of the change to the Makefile not needed.
  Drop that to resolve conflict. ]
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_wa.h |    8 ++++++++
 drivers/gpu/drm/i915/display/intel_fbc.c        |    6 ++++++
 drivers/gpu/drm/xe/Makefile                     |    1 +
 drivers/gpu/drm/xe/display/xe_display_wa.c      |   16 ++++++++++++++++
 4 files changed, 31 insertions(+)
 create mode 100644 drivers/gpu/drm/xe/display/xe_display_wa.c

--- a/drivers/gpu/drm/i915/display/intel_display_wa.h
+++ b/drivers/gpu/drm/i915/display/intel_display_wa.h
@@ -6,8 +6,16 @@
 #ifndef __INTEL_DISPLAY_WA_H__
 #define __INTEL_DISPLAY_WA_H__
 
+#include <linux/types.h>
+
 struct drm_i915_private;
 
 void intel_display_wa_apply(struct drm_i915_private *i915);
 
+#ifdef I915
+static inline bool intel_display_needs_wa_16023588340(struct drm_i915_private *i915) { return false; }
+#else
+bool intel_display_needs_wa_16023588340(struct drm_i915_private *i915);
+#endif
+
 #endif
--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -56,6 +56,7 @@
 #include "intel_display_device.h"
 #include "intel_display_trace.h"
 #include "intel_display_types.h"
+#include "intel_display_wa.h"
 #include "intel_fbc.h"
 #include "intel_fbc_regs.h"
 #include "intel_frontbuffer.h"
@@ -1237,6 +1238,11 @@ static int intel_fbc_check_plane(struct
 		return 0;
 	}
 
+	if (intel_display_needs_wa_16023588340(i915)) {
+		plane_state->no_fbc_reason = "Wa_16023588340";
+		return 0;
+	}
+
 	/* WaFbcTurnOffFbcWhenHyperVisorIsUsed:skl,bxt */
 	if (i915_vtd_active(i915) && (IS_SKYLAKE(i915) || IS_BROXTON(i915))) {
 		plane_state->no_fbc_reason = "VT-d enabled";
--- a/drivers/gpu/drm/xe/Makefile
+++ b/drivers/gpu/drm/xe/Makefile
@@ -175,6 +175,7 @@ xe-$(CONFIG_DRM_XE_DISPLAY) += \
 	display/xe_display.o \
 	display/xe_display_misc.o \
 	display/xe_display_rps.o \
+	display/xe_display_wa.o \
 	display/xe_dsb_buffer.o \
 	display/xe_fb_pin.o \
 	display/xe_hdcp_gsc.o \
--- /dev/null
+++ b/drivers/gpu/drm/xe/display/xe_display_wa.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright © 2024 Intel Corporation
+ */
+
+#include "intel_display_wa.h"
+
+#include "xe_device.h"
+#include "xe_wa.h"
+
+#include <generated/xe_wa_oob.h>
+
+bool intel_display_needs_wa_16023588340(struct drm_i915_private *i915)
+{
+	return XE_WA(xe_root_mmio_gt(i915), 16023588340);
+}


