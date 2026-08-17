Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB6944998A;
	Mon, 17 Aug 2026 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974971; cv=none; b=tkTm2czP0QceBYZY/yejsxYdRK3RUoXaQFQ5n+2HoAdnVgF8DajhY2mYqfxidqiC/66fYiTbl9sMntVEeMjZd2hyZt5i9HbNK/6IxcWwgAd3h4XOjVBZijjgHzGN1pEC/Y5NWVgtNAR0OopXDAx/D8SutKw0XGH6TzYXGIrmbtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974971; c=relaxed/simple;
	bh=owcWT7cMqppt8r24thY2UjgiQqxU1tD3nicQYuVMpqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EdPZ3Gmv41MrgR4OIMq6LPh4MQz+mZMVq3XzEWrMAct9mFZJQVhx9mXAT4+qMVJsOaq3IlApPizh75r+SBUFGaTFan8AyQQisS+k9EySydkpu3at+srExg9fnMBFnC0qpaerrxcfdQSIIThJbdJH4iOK3B7IWgu4tkRX2PpzVQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fe1Pol2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fe1Pol2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6251F000E9;
	Mon, 17 Aug 2026 13:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974966;
	bh=+ee2BvKDg/CQ0mniUVxYSJSklOpdI52Gax6VnkeCqdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fe1Pol2+g4y57sKoOR5v7Fvi7mFHyIJ81focQCRsohibKAplUKzb/ucY8aMCjvM1Z
	 NYwMGEAQv3CmLj/jEK18J1nT+0s5LGQkPWJb0Z+ZH8C1eSF/1Zkuwyxu4oPe83g0qa
	 XgYp4Q0zo9PbY8qmTWQllk6G2Mnko/slKWo7qAFE=
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
Subject: [PATCH 6.18 077/250] drm/xe/uc: Apply RCS/CCS yield policy to SR-IOV VFs
Date: Mon, 17 Aug 2026 15:30:38 +0200
Message-ID: <20260817132539.590473130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 465bda3554439..b799efc838017 100644
--- a/drivers/gpu/drm/xe/xe_uc.c
+++ b/drivers/gpu/drm/xe/xe_uc.c
@@ -15,6 +15,7 @@
 #include "xe_guc.h"
 #include "xe_guc_pc.h"
 #include "xe_guc_engine_activity.h"
+#include "xe_guc_submit.h"
 #include "xe_huc.h"
 #include "xe_sriov.h"
 #include "xe_uc_fw.h"
@@ -160,12 +161,14 @@ static int vf_uc_load_hw(struct xe_uc *uc)
 	if (err)
 		goto err_out;
 
-	uc->guc.submission_state.enabled = true;
-
 	err = xe_guc_opt_in_features_enable(&uc->guc);
 	if (err)
 		goto err_out;
 
+	err = xe_guc_submit_enable(&uc->guc);
+	if (err)
+		return err;
+
 	err = xe_gt_record_default_lrcs(uc_to_gt(uc));
 	if (err)
 		goto err_out;
-- 
2.53.0



