Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313CF1991AE;
	Thu,  5 Sep 2024 09:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529690; cv=none; b=BmwpGGaPj0iW75NLp4gI61co5KxxlSqm4hfomfQi01NWnGVBciWmRggTtUOUhnfwWeL7QXd6sEWGZPJFSS4G+S6calz8yRhft6+T+5gwDSKoJsslPde2s5Fk8bBKaz4S98wO5QbzJWuN8QTAyzXAI0WX+K1aVpzouiCgp6DK/OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529690; c=relaxed/simple;
	bh=PrlTEB3YnzyGujGhSSQUJjH3+CAvBum45iPTiPrMsmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiyTV1AwDL4DubOOpctx+vkJJxu8LyH3FOm+8sCGXePq2+UETdEPkIJJsZSLv8hDCubBb7IIT2gCOZGYpPITxB44UrRgTecgN91zPkakfOlmyL2nVPHqsPQIT+odQ2MtjmHwRzOU3/PD+sAUQwx8zslPCiBIjihiSPj+D4Dh0ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRyEp3j6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRyEp3j6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3CDC4CEC4;
	Thu,  5 Sep 2024 09:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529689;
	bh=PrlTEB3YnzyGujGhSSQUJjH3+CAvBum45iPTiPrMsmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRyEp3j67unctk8PHh/EAsyMWQbw6Y1HuRRY/DX1N6hAhQMtw9aYf1wqS4lOPrbFe
	 t/zUsb5SYDJsgjUfZAfdgV1sW70+YUCsvTrqpX4sFi/0nzX9224S1m6CAOqM9Qb9VG
	 edU3LrEtPLb417h4N8EVxlxkA2BJLixhlhWoNj5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 112/184] drm/xe: Fix the warning conditions
Date: Thu,  5 Sep 2024 11:40:25 +0200
Message-ID: <20240905093736.604609477@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit 4c0be90e6874b8af30541c37689780fc7c8276c9 ]

The maximum timeout display uses in xe_pcode_request is 3 msec, add the
warning in cases the function is misused with higher timeouts.

Add a warning if pcode_try_request is not passed the timeout parameter
greater than 0.

Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240508152216.3263109-3-himal.prasad.ghimiray@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pcode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pcode.c b/drivers/gpu/drm/xe/xe_pcode.c
index a5e7da8cf944..9c4eefdf6642 100644
--- a/drivers/gpu/drm/xe/xe_pcode.c
+++ b/drivers/gpu/drm/xe/xe_pcode.c
@@ -10,6 +10,7 @@
 
 #include <drm/drm_managed.h>
 
+#include "xe_assert.h"
 #include "xe_device.h"
 #include "xe_gt.h"
 #include "xe_mmio.h"
@@ -124,6 +125,8 @@ static int pcode_try_request(struct xe_gt *gt, u32 mbox,
 {
 	int slept, wait = 10;
 
+	xe_gt_assert(gt, timeout_us > 0);
+
 	for (slept = 0; slept < timeout_us; slept += wait) {
 		if (locked)
 			*status = pcode_mailbox_rw(gt, mbox, &request, NULL, 1, true,
@@ -169,6 +172,8 @@ int xe_pcode_request(struct xe_gt *gt, u32 mbox, u32 request,
 	u32 status;
 	int ret;
 
+	xe_gt_assert(gt, timeout_base_ms <= 3);
+
 	mutex_lock(&gt->pcode.lock);
 
 	ret = pcode_try_request(gt, mbox, request, reply_mask, reply, &status,
@@ -188,7 +193,6 @@ int xe_pcode_request(struct xe_gt *gt, u32 mbox, u32 request,
 	 */
 	drm_err(&gt_to_xe(gt)->drm,
 		"PCODE timeout, retrying with preemption disabled\n");
-	drm_WARN_ON_ONCE(&gt_to_xe(gt)->drm, timeout_base_ms > 1);
 	preempt_disable();
 	ret = pcode_try_request(gt, mbox, request, reply_mask, reply, &status,
 				true, 50 * 1000, true);
-- 
2.43.0



