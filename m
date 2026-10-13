Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF0D4F5DF1;
	Tue, 13 Oct 2026 11:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892625; cv=none; b=Fm9YjSmewV5/6TuPg6cayWFcaXFYphnp1/0g1Z37LotfThR/PoQ/xCE1Z2cFC+OpFKgHwhPo3L/Yvv3eFR8QxeXOLELTElXB1ljX1cPEMKGFNeWWRbHG1TSrb+mt+YwHh03byH2VFCN7I4jGx3T+CDnLsZLSrMwF1V1+UJ3keoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892625; c=relaxed/simple;
	bh=tNbcdZH5oc6NIBKIKN18oxbfqKQnAKrqoEWUE4FKS78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJFa7gr7xBOiFIEJREj9/MZJdv/LHeWHJts1TSbf9fB2gc4Bs3v6Lolpeo1eDA8Y/D25rIO5waMu7GmAVjWVjMDiPNRQJ4e3KijJNmR1M1QlrGUWGJG129W0KQHfUlo0MNNCE9xb+5OQE7n5MQsSnWaoap40YXxfMAwn/kN9DcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFJE5Ub2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFJE5Ub2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D5B1F000FF;
	Tue, 13 Oct 2026 11:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892624;
	bh=kWjYNVZ5OJK7J7ezTf8NeOMVM1q+5Ul7k2ZnpelUbKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFJE5Ub24nHMzea/osHIIx8k/M2uYNceEXbEKNFiPNWXwK+3oRwrh/PNQ4pln1k/l
	 4+tXoLqR+N19EG7tqQ5G9qRIHBd8Cd+dwa1OxfpPSwb/aAhq/eEVYqtTiwNeJTemnf
	 rBpHdQNmTkg+OtaXtZMzASPT4xmNvYxd0n8oBW10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 218/281] drm/xe: Do not emit Wa_16010904313 twice
Date: Tue, 13 Oct 2026 13:38:54 +0200
Message-ID: <20261013112900.450981398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit f7fc61e66041b1f8300cad87005ba84604bfefd9 ]

During development of commit e8372edec948 ("drm/xe/xelp: Implement
Wa_16010904313")
one of the interim patch versions contained an incorrect rebase on top of
some upstream changes, which caused Wa_16010904313 to be emitted both from
the indirect context and from the workaround batch buffer.

As this workaround needs to be emitted from the indirect context for rcs
and ccs, but from the workaround batch buffer for bcs, vcs and vecs, we
need to pass the location as an input parameter to setup_timestamp_wa() so
it can decide whether to emit itself or not.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: e8372edec948 ("drm/xe/xelp: Implement Wa_16010904313")
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20260925080016.64802-1-tvrtko.ursulin@igalia.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo: small adjustments on commit message for check-patch]
(cherry picked from commit 38631a7bce195b88814b93bf2b6d3e48c827fef2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_lrc.c | 38 ++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index 9f8217ff1904c..224e64bccaebc 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -1099,8 +1099,7 @@ static void xe_lrc_finish(struct xe_lrc *lrc)
 #define CONTEXT_ACTIVE XE_LRC_CTX_TIMESTAMP_ACTIVE
 static ssize_t setup_utilization_wa(struct xe_lrc *lrc,
 				    struct xe_hw_engine *hwe,
-				    u32 *batch,
-				    size_t max_len)
+				    u32 *batch, size_t max_len, bool indirect)
 {
 	u32 *cmd = batch;
 
@@ -1131,19 +1130,25 @@ static ssize_t setup_utilization_wa(struct xe_lrc *lrc,
 }
 
 static ssize_t setup_timestamp_wa(struct xe_lrc *lrc, struct xe_hw_engine *hwe,
-				  u32 *batch, size_t max_len)
+				  u32 *batch, size_t max_len, bool indirect)
 {
 	const u32 ts_addr = __xe_lrc_ctx_timestamp_ggtt_addr(lrc);
 	u32 *cmd = batch;
 
-	if (!XE_GT_WA(lrc->gt, 16010904313) ||
-	    !(hwe->class == XE_ENGINE_CLASS_RENDER ||
-	      hwe->class == XE_ENGINE_CLASS_COMPUTE ||
-	      hwe->class == XE_ENGINE_CLASS_COPY ||
+	if (!XE_GT_WA(lrc->gt, 16010904313))
+		return 0;
+
+	if (!indirect &&
+	    !(hwe->class == XE_ENGINE_CLASS_COPY ||
 	      hwe->class == XE_ENGINE_CLASS_VIDEO_DECODE ||
 	      hwe->class == XE_ENGINE_CLASS_VIDEO_ENHANCE))
 		return 0;
 
+	if (indirect &&
+	    !(hwe->class == XE_ENGINE_CLASS_RENDER ||
+	      hwe->class == XE_ENGINE_CLASS_COMPUTE))
+		return 0;
+
 	if (xe_gt_WARN_ON(lrc->gt, max_len < 12))
 		return -ENOSPC;
 
@@ -1169,7 +1174,8 @@ static ssize_t setup_timestamp_wa(struct xe_lrc *lrc, struct xe_hw_engine *hwe,
 
 static ssize_t setup_configfs_post_ctx_restore_bb(struct xe_lrc *lrc,
 						  struct xe_hw_engine *hwe,
-						  u32 *batch, size_t max_len)
+						  u32 *batch, size_t max_len,
+						  bool indirect)
 {
 	struct xe_device *xe = gt_to_xe(lrc->gt);
 	const u32 *user_batch;
@@ -1198,7 +1204,8 @@ static ssize_t setup_configfs_post_ctx_restore_bb(struct xe_lrc *lrc,
 
 static ssize_t setup_configfs_mid_ctx_restore_bb(struct xe_lrc *lrc,
 						 struct xe_hw_engine *hwe,
-						 u32 *batch, size_t max_len)
+						 u32 *batch, size_t max_len,
+						 bool indirect)
 {
 	struct xe_device *xe = gt_to_xe(lrc->gt);
 	const u32 *user_batch;
@@ -1227,7 +1234,8 @@ static ssize_t setup_configfs_mid_ctx_restore_bb(struct xe_lrc *lrc,
 
 static ssize_t setup_invalidate_state_cache_wa(struct xe_lrc *lrc,
 					       struct xe_hw_engine *hwe,
-					       u32 *batch, size_t max_len)
+					       u32 *batch, size_t max_len,
+					       bool indirect)
 {
 	u32 *cmd = batch;
 
@@ -1247,7 +1255,8 @@ static ssize_t setup_invalidate_state_cache_wa(struct xe_lrc *lrc,
 
 static ssize_t setup_invalidate_auxccs_wa(struct xe_lrc *lrc,
 					  struct xe_hw_engine *hwe,
-					  u32 *batch, size_t max_len)
+					  u32 *batch, size_t max_len,
+					  bool indirect)
 {
 	struct xe_gt *gt = lrc->gt;
 	u32 *(*emit)(struct xe_gt *gt, u32 *cmd) =
@@ -1264,7 +1273,7 @@ static ssize_t setup_invalidate_auxccs_wa(struct xe_lrc *lrc,
 
 struct bo_setup {
 	ssize_t (*setup)(struct xe_lrc *lrc, struct xe_hw_engine *hwe,
-			 u32 *batch, size_t max_size);
+			 u32 *batch, size_t max_size, bool indirect);
 };
 
 struct bo_setup_state {
@@ -1273,6 +1282,7 @@ struct bo_setup_state {
 	struct xe_hw_engine	*hwe;
 	size_t			max_size;
 	size_t                  reserve_dw;
+	bool			indirect;
 	unsigned int		offset;
 	const struct bo_setup	*funcs;
 	unsigned int		num_funcs;
@@ -1298,7 +1308,8 @@ static int setup_bo(struct bo_setup_state *state)
 
 	for (size_t i = 0; i < state->num_funcs; i++) {
 		ssize_t len = state->funcs[i].setup(state->lrc, state->hwe,
-						    state->ptr, remain);
+						    state->ptr, remain,
+						    state->indirect);
 
 		remain -= len;
 
@@ -1404,6 +1415,7 @@ setup_indirect_ctx(struct xe_lrc *lrc, struct xe_hw_engine *hwe)
 	struct bo_setup_state state = {
 		.lrc = lrc,
 		.hwe = hwe,
+		.indirect = true,
 		.max_size = (63 * 64) /* max 63 cachelines */,
 		.buffer = NULL,
 		.offset = __xe_lrc_indirect_ctx_offset(lrc),
-- 
2.53.0



