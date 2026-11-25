Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623862;
	b=gnflkIh0yYhx3CV/6faM1fFZNHJlBKfVneA8hmsno7FhE90fV3QeMKQHFDrHQHwZL4b7
	 UJEUan52QJ3UrkoDRn2z6lI7jOsDswKFiJf6wxKQ9LaJq7I9lxbSJnI3+GmLkp2y/roTv
	 LESWCe2PXBfq+4SxSwTsqDvb9RyIRaVVJ+Pisu1p1s/D23eHQ/3kcc2xt3AIVXX0kGBJ9
	 gyMf45rupPsC+BzzpF5++uOYSQ68swqm3dsm1Pu0hhPAxekPnU1cJ8ZnRAlJUY9z+ws8h
	 DvH38Rxo1SOvgXYFyt+H+z2lfuyKP/NCUa9cQEzkdlEZzKYcguE0LTTTaEAJ/R6caKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hv3iW5nGdTflw5O6jaiwI/YYr815rg35BGLDVYmifDc=;
	b=r+N/kb3bH0PGR6I1V7ewNN0YXaI5/bQHjPPPA+/uTFA9FIBW/iPJkTqthTUMw4t0uEqS
	 05pCltO/pbfsCw0rLPEzW14CHX0bYvksGDbboPPjtDuKwZ+r61uDnkraSd4HkE1jaVxrj
	 fCGzVXzLz4AVkPHNyQqHQCvNV+GGVJCyirfONpJEWc9sv58RY93NA1k4u9aGXOZu8lyXe
	 Oi1LqaxI95OxLjp6ix0l54FtYC1nW4jxRoyb19re908nkzc0ByQ8SQjokS9mAhj92PMC5
	 Qf2W94hNKj07tdCsLubdAp7TtpuH4Y+wjIqKqr530DpxgMPEGtGyz9LyFDt16qkPpyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P/rtZrVU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2CD606A331;
	Wed, 25 Nov 2026 16:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P/rtZrVU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9B81F000D3;
	Wed, 25 Nov 2026 16:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623861;
	bh=Hv3iW5nGdTflw5O6jaiwI/YYr815rg35BGLDVYmifDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/rtZrVU9OFj3xfK3R8p8VV1mO8SIuL7/g/1w+xzdsJXWmerCzwJ10/hvI+3Ah9I+
	 El2b3Sa62JpfQxmzqcvkdgBW1j/XUt0qsLFhQ8IomKFdSlut8L3Jl2N+bCkmIBZTNi
	 49BBrTiF69KLJH5y4i9xgwVTMOqXoASf3nOqvNVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riana Tauro <riana.tauro@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Subject: [PATCH 6.18 983/990] drm/xe: Dont disable GuCRC in suspend path
Date: Wed, 25 Nov 2026 15:39:10 +0100
Message-ID: <20261125143845.005313383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

commit b458597544c20c31cef9d907696e8b9652b0894e upstream.

GuCRC should not be disabled in xe_guc_stop_prepare() as C6 is a
prerequisite for s0ix and s2idle. This is a regression caused by
the patch below.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/7510
Fixes: 40a684f91d26 ("drm/xe: Decouple GuC RC code from xe_guc_pc")
Cc: Riana Tauro <riana.tauro@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Riana Tauro <riana.tauro@intel.com>
Link: https://patch.msgid.link/20260303181416.3880937-1-vinay.belgaumkar@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt.c  |    2 ++
 drivers/gpu/drm/xe/xe_guc.c |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -40,6 +40,7 @@
 #include "xe_gt_topology.h"
 #include "xe_guc_exec_queue_types.h"
 #include "xe_guc_pc.h"
+#include "xe_guc_rc.h"
 #include "xe_guc_submit.h"
 #include "xe_hw_fence.h"
 #include "xe_hw_engine_class_sysfs.h"
@@ -889,6 +890,7 @@ static int gt_reset(struct xe_gt *gt)
 	if (IS_SRIOV_PF(gt_to_xe(gt)))
 		xe_gt_sriov_pf_stop_prepare(gt);
 
+	xe_guc_rc_disable(&gt->uc.guc);
 	xe_uc_stop_prepare(&gt->uc);
 	xe_gt_pagefault_reset(gt);
 
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -1616,7 +1616,6 @@ void xe_guc_stop_prepare(struct xe_guc *
 	if (!IS_SRIOV_VF(guc_to_xe(guc))) {
 		int err;
 
-		xe_guc_rc_disable(guc);
 		err = xe_guc_pc_stop(&guc->pc);
 		xe_gt_WARN(guc_to_gt(guc), err, "Failed to stop GuC PC: %pe\n",
 			   ERR_PTR(err));


