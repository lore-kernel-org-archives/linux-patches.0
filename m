Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDBF1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0DDC433C7;
	Mon, 11 Sep 2023 14:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441234;
	bh=8UXoYR89kglgjd/TpPPt3PlE9SsE8GNVRODH1kYA+XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajsg3RhxHx5Auat+c8eH75vBxxcJgg3M2Ql6TJuP8fCLOKWaNDA8zrWC7PMNWuhMF
	 8WIrap2YBaTNm2WCmwfg0l0oV225PUMJsNLY1aYh4VFyR+olXN67lk6xzvv4shXwUJ
	 NWk1ymjujkKOjCt7uCsR+EWRBhUbKN2ZWasgeI+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 315/739] drm/amdgpu: Sort the includes in amdgpu/amdgpu_drv.c
Date: Mon, 11 Sep 2023 15:41:54 +0200
Message-ID: <20230911134659.909167273@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit e2e42edfe8533af7b30f505d41d44e0d180065da ]

Sort the include files that are included in amdgpu_drv.c alphabetically.

Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 4e2abc197f11 ("drm/amdgpu: Move vram, gtt & flash defines to amdgpu_ ttm & _psp.h")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 0593ef8fe0a63..8d16190e6b046 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -26,30 +26,29 @@
 #include <drm/drm_drv.h>
 #include <drm/drm_fbdev_generic.h>
 #include <drm/drm_gem.h>
-#include <drm/drm_vblank.h>
 #include <drm/drm_managed.h>
-#include "amdgpu_drv.h"
-
 #include <drm/drm_pciids.h>
-#include <linux/module.h>
-#include <linux/pm_runtime.h>
-#include <linux/vga_switcheroo.h>
 #include <drm/drm_probe_helper.h>
-#include <linux/mmu_notifier.h>
-#include <linux/suspend.h>
+#include <drm/drm_vblank.h>
+
 #include <linux/cc_platform.h>
 #include <linux/dynamic_debug.h>
+#include <linux/module.h>
+#include <linux/mmu_notifier.h>
+#include <linux/pm_runtime.h>
+#include <linux/suspend.h>
+#include <linux/vga_switcheroo.h>
 
 #include "amdgpu.h"
-#include "amdgpu_irq.h"
+#include "amdgpu_amdkfd.h"
 #include "amdgpu_dma_buf.h"
-#include "amdgpu_sched.h"
+#include "amdgpu_drv.h"
 #include "amdgpu_fdinfo.h"
-#include "amdgpu_amdkfd.h"
-
+#include "amdgpu_irq.h"
 #include "amdgpu_ras.h"
-#include "amdgpu_xgmi.h"
 #include "amdgpu_reset.h"
+#include "amdgpu_sched.h"
+#include "amdgpu_xgmi.h"
 #include "../amdxcp/amdgpu_xcp_drv.h"
 
 /*
-- 
2.40.1



