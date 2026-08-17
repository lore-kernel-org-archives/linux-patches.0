Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4380A3F7882;
	Mon, 17 Aug 2026 13:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974205; cv=none; b=mGxM0Ae8EtRRPCJhLmTbB6WT/5/6tmHuU14sbQx3q19ngos8j+xn8J1dgKtxXKszMg17zz5fs99HXiZsgRRWLKdhd4+L4EJKYqsGGSX9ilarInSvWscdbNsVn/hPSNw/34LrR2wSRV9MTdjRh6JAanwwjX/Elt3EolDuSI2WtTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974205; c=relaxed/simple;
	bh=GStyQQG2XZcG9ZBpl1GJ0u+kaiWRqWBiCbtnN4cIg6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YLUHTV7L1xwvytmBQ+GpWlqJQ3cRKTQGDbk+Y3DKRrqwdrAs777XIX92WLGyXJFzePfWcHac7AwLbDwE5tZC5REc97oxztL1yU09ShLsoBTpL9Yq5eT2EnwTe7Gw9JUr33rOUW+HS5uT+mUnxsKg/t/JUrpEkzMocuul7opFO8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmuaAScq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmuaAScq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCC71F000E9;
	Mon, 17 Aug 2026 13:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974204;
	bh=6t7H+SBR5PtlMgiTwhbQZV2qFx/x5rNRYJmAPpenx9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QmuaAScqMcxlIKoraz36IH9LARK82ebVjRySMdNg4UpjEcft73f30VBNNt3tiCTDF
	 z2gkG+Bz/77YheDFnjBK4UXhg+ypF6fY+6YcydFeN/x1/KcbZDhzcLqXUphW8vAbx/
	 GF+wg7lchM9wRhb3CDDxHUe5x19VSEf8nMbXO+nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 086/271] drm/xe/uc: Apply RCS/CCS yield policy to SR-IOV VFs
Date: Mon, 17 Aug 2026 15:30:11 +0200
Message-ID: <20260817132540.287588852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>

[ Upstream commit d1643db3b037b57f2af7f85c3821d6fe69c492f6 ]

VFs were missing the call to apply the global scheduling policy.
Call xe_guc_submit_enable() during vf_uc_load_hw() to ensure VFs
get the same policy enforcement as PF.

Fixes: 26caeae9fb48 ("drm/xe/guc: Set RCS/CCS yield policy")
Suggested-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Signed-off-by: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patch.msgid.link/20260709075945.1337660-1-marcin.bernatowicz@linux.intel.com
Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
(cherry picked from commit f09360e857130f7ab7f069e2421e6b4a6e502531)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_uc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_uc.c b/drivers/gpu/drm/xe/xe_uc.c
index 75091bde0d50c..65f59f06177fd 100644
--- a/drivers/gpu/drm/xe/xe_uc.c
+++ b/drivers/gpu/drm/xe/xe_uc.c
@@ -15,6 +15,7 @@
 #include "xe_guc_pc.h"
 #include "xe_guc_rc.h"
 #include "xe_guc_engine_activity.h"
+#include "xe_guc_submit.h"
 #include "xe_huc.h"
 #include "xe_sriov.h"
 #include "xe_wopcm.h"
@@ -159,12 +160,14 @@ static int vf_uc_load_hw(struct xe_uc *uc)
 	if (err)
 		return err;
 
-	uc->guc.submission_state.enabled = true;
-
 	err = xe_guc_opt_in_features_enable(&uc->guc);
 	if (err)
 		return err;
 
+	err = xe_guc_submit_enable(&uc->guc);
+	if (err)
+		return err;
+
 	err = xe_gt_record_default_lrcs(uc_to_gt(uc));
 	if (err)
 		return err;
-- 
2.53.0



