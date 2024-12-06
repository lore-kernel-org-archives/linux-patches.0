Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2622066D6;
	Fri,  6 Dec 2024 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496357; cv=none; b=OkXVU9VrBevxP3KSibOYFDscX4n/9AzHfCXz2vpoysQmg2Z/Sh4vdoHqOwGtGk8sXG22hSWWbFKC5fAkxCtXyKzo8gXyDSeICKJchG4p+MiaFXR6phNYKIyiYy5WyX1cbqnbSDMHPC0/ZvKIqGRVUbTGGn2wwlc3YtcsdduxUD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496357; c=relaxed/simple;
	bh=azvlObPvAuAw6HP8VEoUKtliF5OiH6aP2348wK16LyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/eYuWMfnlN/csoMQeZnWoOPuhUx9aAHLAQdhNxIXlMUlbofSoEf/0jcs4iGIS2a3vTeNMHJ0jr15QZ7fexme19PkGSz55hWrRAyvHaG0nuuAm+xqYhVEDWDKZwxFyQnjmOmh64ziebWYLJuK5XnggL5jh4e0ox8BAxUAiyxNfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRTOkl+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRTOkl+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D40FC4CEE9;
	Fri,  6 Dec 2024 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496356;
	bh=azvlObPvAuAw6HP8VEoUKtliF5OiH6aP2348wK16LyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRTOkl+clGjRvxKogemdNLYZMDkC+gnbCjHq/0bTE5nmsjYZNIX8Cnpt5Utx5kOvC
	 2ZH4wEAhJhsA0Mmy2p+m77FvM0LEy7Nel+7xciTXtvOCfzheHCZd6jDsX3t84Ddo1b
	 7mOMLyusE9y+AkhW3509u1yDlHQc2UnlrJwV1xyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	John Harrison <john.c.harrison@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>
Subject: [PATCH 6.12 129/146] drm/xe/xe_guc_ads: save/restore OA registers and allowlist regs
Date: Fri,  6 Dec 2024 15:37:40 +0100
Message-ID: <20241206143532.618496043@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cavitt <jonathan.cavitt@intel.com>

commit 55858fa7eb2f163f7aa34339fd3399ba4ff564c6 upstream.

Several OA registers and allowlist registers were missing from the
save/restore list for GuC and could be lost during an engine reset.  Add
them to the list.

v2:
- Fix commit message (Umesh)
- Add missing closes (Ashutosh)

v3:
- Add missing fixes (Ashutosh)

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2249
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Suggested-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Suggested-by: John Harrison <john.c.harrison@intel.com>
Signed-off-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
CC: stable@vger.kernel.org # v6.11+
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241023200716.82624-1-jonathan.cavitt@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_ads.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -13,6 +13,7 @@
 #include "regs/xe_engine_regs.h"
 #include "regs/xe_gt_regs.h"
 #include "regs/xe_guc_regs.h"
+#include "regs/xe_oa_regs.h"
 #include "xe_bo.h"
 #include "xe_gt.h"
 #include "xe_gt_ccs_mode.h"
@@ -601,6 +602,11 @@ static unsigned int guc_mmio_regset_writ
 		guc_mmio_regset_write_one(ads, regset_map, e->reg, count++);
 	}
 
+	for (i = 0; i < RING_MAX_NONPRIV_SLOTS; i++)
+		guc_mmio_regset_write_one(ads, regset_map,
+					  RING_FORCE_TO_NONPRIV(hwe->mmio_base, i),
+					  count++);
+
 	/* Wa_1607983814 */
 	if (needs_wa_1607983814(xe) && hwe->class == XE_ENGINE_CLASS_RENDER) {
 		for (i = 0; i < LNCFCMOCS_REG_COUNT; i++) {
@@ -609,6 +615,14 @@ static unsigned int guc_mmio_regset_writ
 		}
 	}
 
+	guc_mmio_regset_write_one(ads, regset_map, EU_PERF_CNTL0, count++);
+	guc_mmio_regset_write_one(ads, regset_map, EU_PERF_CNTL1, count++);
+	guc_mmio_regset_write_one(ads, regset_map, EU_PERF_CNTL2, count++);
+	guc_mmio_regset_write_one(ads, regset_map, EU_PERF_CNTL3, count++);
+	guc_mmio_regset_write_one(ads, regset_map, EU_PERF_CNTL4, count++);
+	guc_mmio_regset_write_one(ads, regset_map, EU_PERF_CNTL5, count++);
+	guc_mmio_regset_write_one(ads, regset_map, EU_PERF_CNTL6, count++);
+
 	return count;
 }
 


