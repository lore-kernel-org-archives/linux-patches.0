Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DAD7C
	for <patches@lists.linux.dev>; Wed,  6 Jul 2022 18:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=4l3ZvU4NeEg70mOy/QdaF5EMsczj8SOOaqrfx4OWw+w=; b=NXcsWHSchhBzKCNrRLKYwSPT2f
	GApL1MraIqrTVq94Qn5899yWJgu725ZZMbJ+yEB5VUBrlM7ny2yW7cr8P19V4f8l7ej0WMVACOlPK
	4/wz37oFaAUfGrgXwF0lvgDmZc3o7frxfBgm1+gxMaiFFZVXwoH3l1oLgTheQqqa74r9y2MYF97dj
	EOqh+suY/K+KeLqabM5FVjGee8BT/PQl4MpamY2baqJk7Mra7EKRc8DqsXhEQ25zULpss51pHILtB
	0rU8423dGPl5R8EmfoJP+1HD3HFH3Pd2nUP0KfRaAaKkU7HRYBnYSF/9KuWo59Zn9CSSZxjHfiszX
	X61PmUyQ==;
Received: from [2601:1c0:6280:3f0::a6b3] (helo=casper.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1o99yo-001so3-2w; Wed, 06 Jul 2022 18:42:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: dri-devel@lists.freedesktop.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel@ffwll.ch>,
	Michal Simek <michal.simek@xilinx.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] drm: xlnx: add <linux/io.h> for readl/writel
Date: Wed,  6 Jul 2022 11:42:24 -0700
Message-Id: <20220706184224.29116-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a header file to prevent build errors:

../drivers/gpu/drm/xlnx/zynqmp_dp.c: In function ‘zynqmp_dp_write’:
../drivers/gpu/drm/xlnx/zynqmp_dp.c:335:9: error: implicit declaration of function ‘writel’ [-Werror=implicit-function-declaration]
  335 |         writel(val, dp->iomem + offset);
../drivers/gpu/drm/xlnx/zynqmp_dp.c: In function ‘zynqmp_dp_read’:
../drivers/gpu/drm/xlnx/zynqmp_dp.c:340:16: error: implicit declaration of function ‘readl’ [-Werror=implicit-function-declaration]
  340 |         return readl(dp->iomem + offset);

Fixes: d76271d22694 ("drm: xlnx: DRM/KMS driver for Xilinx ZynqMP DisplayPort Subsystem")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/gpu/drm/xlnx/zynqmp_dp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
@@ -25,6 +25,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
