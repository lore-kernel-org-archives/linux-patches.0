Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289835674E;
	Wed, 23 Apr 2025 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419548; cv=none; b=Io+NPorCiYLaOodvNszN21cMcov/JAozxVfB9RoFn0DLZ6yToEI8aFL8EJyw+euRle/beOkmGrvE6U7vKfSxqUi1B8hLz4XtNt2yGiU0IbA/POZaHG8J9dX8uBgsDK4keG75tzNaXpFgn0p1F7VLiDstVpdFJwF0G2Cinti8n+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419548; c=relaxed/simple;
	bh=EIcGuEwUjWMXHsKN0qPCiRhrFirdyhws7hGIcM0e5iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJOaLDYeNu5AMkGqxKSsnIKphHIsh+dIIJVJOu2IIEqgI90VvNq7IYqbdXNHfAbNcqETz3AoeUNaFh//d9q3rLmdYtE1+Wbl3hR91WeyXQVS+YztHUrPQd61QMWpBqimQ6fSgKSmENHY+sVJ/D9HIE1MxORQ0DUy7xWDGp/GNUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIH5wqFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIH5wqFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACEDC4CEE2;
	Wed, 23 Apr 2025 14:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419547;
	bh=EIcGuEwUjWMXHsKN0qPCiRhrFirdyhws7hGIcM0e5iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIH5wqFDkkugbTHmkAMvfhbc2W4rGZ7KSzpbErdRhhd9dkYex2z1KQhPQJesAy+8N
	 pzna/LOkTMNHA7h1TD/qYaL1naLyMBh2SZ8OmVm95TtWBr7WwNZxbXtRRQlgZ4Fm0L
	 Y6yMPlubb8NBw6cMh61Ymq+WBazcuZlC9IAeOXo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Chegondi <harish.chegondi@intel.com>,
	Haridhar Kalvala <haridhar.kalvala@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/393] drm/i915/xelpg: Extend driver code of Xe_LPG to Xe_LPG+
Date: Wed, 23 Apr 2025 16:38:19 +0200
Message-ID: <20250423142643.389529847@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Chegondi <harish.chegondi@intel.com>

[ Upstream commit 84bf82f4f8661930a134a1d86bde16f7d8bcd699 ]

Xe_LPG+ (IP version 12.74) should take the same general code
paths as Xe_LPG (versions 12.70 and 12.71).

Xe_LPG+'s workaround list will be handled by the next patch.

Signed-off-by: Harish Chegondi <harish.chegondi@intel.com>
Signed-off-by: Haridhar Kalvala <haridhar.kalvala@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240108122738.14399-3-haridhar.kalvala@intel.com
Stable-dep-of: 9d3d9776bd3b ("drm/i915: Disable RPG during live selftest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c | 3 ++-
 drivers/gpu/drm/i915/gt/intel_mocs.c      | 2 +-
 drivers/gpu/drm/i915/gt/intel_rc6.c       | 2 +-
 drivers/gpu/drm/i915/i915_debugfs.c       | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index d9bb352b8baab..0729ab5955171 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -1218,7 +1218,8 @@ static int intel_engine_init_tlb_invalidation(struct intel_engine_cs *engine)
 			num = ARRAY_SIZE(xelpmp_regs);
 		}
 	} else {
-		if (GRAPHICS_VER_FULL(i915) == IP_VER(12, 71) ||
+		if (GRAPHICS_VER_FULL(i915) == IP_VER(12, 74) ||
+		    GRAPHICS_VER_FULL(i915) == IP_VER(12, 71) ||
 		    GRAPHICS_VER_FULL(i915) == IP_VER(12, 70) ||
 		    GRAPHICS_VER_FULL(i915) == IP_VER(12, 50) ||
 		    GRAPHICS_VER_FULL(i915) == IP_VER(12, 55)) {
diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
index 353f93baaca05..25c1023eb5f9f 100644
--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -495,7 +495,7 @@ static unsigned int get_mocs_settings(struct drm_i915_private *i915,
 	memset(table, 0, sizeof(struct drm_i915_mocs_table));
 
 	table->unused_entries_index = I915_MOCS_PTE;
-	if (IS_GFX_GT_IP_RANGE(to_gt(i915), IP_VER(12, 70), IP_VER(12, 71))) {
+	if (IS_GFX_GT_IP_RANGE(to_gt(i915), IP_VER(12, 70), IP_VER(12, 74))) {
 		table->size = ARRAY_SIZE(mtl_mocs_table);
 		table->table = mtl_mocs_table;
 		table->n_entries = MTL_NUM_MOCS_ENTRIES;
diff --git a/drivers/gpu/drm/i915/gt/intel_rc6.c b/drivers/gpu/drm/i915/gt/intel_rc6.c
index 6e8c182b2559e..483d557858816 100644
--- a/drivers/gpu/drm/i915/gt/intel_rc6.c
+++ b/drivers/gpu/drm/i915/gt/intel_rc6.c
@@ -123,7 +123,7 @@ static void gen11_rc6_enable(struct intel_rc6 *rc6)
 	 * temporary wa and should be removed after fixing real cause
 	 * of forcewake timeouts.
 	 */
-	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 71)))
+	if (IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 70), IP_VER(12, 74)))
 		pg_enable =
 			GEN9_MEDIA_PG_ENABLE |
 			GEN11_MEDIA_SAMPLER_PG_ENABLE;
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 7a90a2e32c9f1..1fde21d8bb59a 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -144,7 +144,7 @@ static const char *i915_cache_level_str(struct drm_i915_gem_object *obj)
 {
 	struct drm_i915_private *i915 = obj_to_i915(obj);
 
-	if (IS_GFX_GT_IP_RANGE(to_gt(i915), IP_VER(12, 70), IP_VER(12, 71))) {
+	if (IS_GFX_GT_IP_RANGE(to_gt(i915), IP_VER(12, 70), IP_VER(12, 74))) {
 		switch (obj->pat_index) {
 		case 0: return " WB";
 		case 1: return " WT";
-- 
2.39.5



