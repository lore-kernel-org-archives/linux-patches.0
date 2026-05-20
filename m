Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9A334B40F;
	Wed, 20 May 2026 17:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297097; cv=none; b=gZXlnv21+Hijv5eD76jOqSedIQkajvbD/+SUkorwcuPfHDXCcoo8Qu9VPPw6uLwuuBd4prifhQBL0pWuDBbex3tEkV4LLcztU86vYf0UIphus8NRStC3BMUiieOXNzyBuPQAsNA3D4+BvyKx4SAIu/GkIx1NvDUhUT8kkC3iCwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297097; c=relaxed/simple;
	bh=r2JHrKMHu1emphcPnuPJY9nrafyKbEt31P8m98Tk++g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1oe22uhDNcZDPimEt+z/qSttLqthKiNYYrSQrK6Y2qFx1XBCf/CTajWLfwLgKpmppJtUON/UP8hg6CpRklUrC/O5UAnK94SvTuRcylULv8xcGz9Xcb94L2gp6bSPN2MqXiifcSVy8lFaL/qZtRy2AHHJN+udX6V5qh3UgNRV18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4xZDIBG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4xZDIBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D530F1F000E9;
	Wed, 20 May 2026 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297096;
	bh=4IvLLIeDGk2ZBOJGV+dL7TG7yhKi3RGzibqJmmimE9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4xZDIBGpwE92Sak59zZuZCe7WYBBY8Mf0EoVb923cgYW2Rw5Ecqxl7w25TvTsG1M
	 xJov5WYGoKwNbLR87iz0GTZWc4q/hB2pBvfJuxcxR1a5imnA0P0xIOoxz2O527GEd3
	 pfhmlLAphKMxWgQGkJdFSTTztAM22FYVmi6L7nGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1008/1146] drm/xe: Use XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET enum instead of magic number
Date: Wed, 20 May 2026 18:20:58 +0200
Message-ID: <20260520162211.046080048@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhanjun Dong <zhanjun.dong@intel.com>

[ Upstream commit a7f607610da721f77db358b09be8091e60bd8e89 ]

Replace the magic number 2 with the proper enum value
XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET for better code readability
and maintainability.

Signed-off-by: Zhanjun Dong <zhanjun.dong@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260310225039.1320161-5-zhanjun.dong@intel.com
Stable-dep-of: a0fc362f0953 ("drm/xe: Drop registration of guc_submit_wedged_fini from xe_guc_submit_wedge()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index fc4f99d467635..4867a97583903 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1286,12 +1286,13 @@ void xe_guc_submit_wedge(struct xe_guc *guc)
 	if (!guc->submission_state.initialized)
 		return;
 
-	if (xe->wedged.mode == 2) {
+	if (xe->wedged.mode == XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET) {
 		err = devm_add_action_or_reset(guc_to_xe(guc)->drm.dev,
 					       guc_submit_wedged_fini, guc);
 		if (err) {
-			xe_gt_err(gt, "Failed to register clean-up on wedged.mode=2; "
-				  "Although device is wedged.\n");
+			xe_gt_err(gt, "Failed to register clean-up on wedged.mode=%s; "
+				  "Although device is wedged.\n",
+				  xe_wedged_mode_to_string(XE_WEDGED_MODE_UPON_ANY_HANG_NO_RESET));
 			return;
 		}
 
-- 
2.53.0



