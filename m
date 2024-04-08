Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7193013A407;
	Mon,  8 Apr 2024 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583488; cv=none; b=kW5EXTZQPBKIsHutFqYqO9JYsqJkDCVx82rwyTFVYS/g54NQNoNOs15UvWvGHTCkXXeyydUnFaOqPwDsr7YdyC74DxMQjV6Ob2WwcNNbxI4kLX9zyhjulyPhTmCzH41vSk7F+oHPk8BKfglEjYty47m6SnIHExB4zHNuSwP1LvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583488; c=relaxed/simple;
	bh=YKYcBN5ZFVM44ZnUAvk0+mI3fxurLWHFeDY+ZrchZtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHhF/Jgv7t+XhA6k5zUHaB8cxl6qXaKj/Cmlb4MqRDG2QM+znIexqKXwIyMtWtxfxyrKzGMMjC8CUENQcOe8HY/+Z5YgdwsPHatok/MtxcXqHP5nGzH6MPmKtzQm+eOZ4vCgueEcuh7XazxBFzQ/jWervS0Ovy3pkEe7AuSTBV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSnOz/1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSnOz/1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826FEC43390;
	Mon,  8 Apr 2024 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583487;
	bh=YKYcBN5ZFVM44ZnUAvk0+mI3fxurLWHFeDY+ZrchZtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSnOz/1jrbl12uz00u6FnccujxnAoRi4G+Qg9zDjNm0Gj+/zYNueSmkmUwYPYfA3X
	 +tyMiRyeAVipB56oj2d7Ho7V5PZsXZbK9YZ60rJE3CuevYgXAo0P3x94vzeEI0Na75
	 NGhqUe91CAoudqiomP8xo9WFgUGlHE6xzZYoxz38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Michal Mrozek <michal.mrozek@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 184/273] drm/i915/gt: Limit the reserved VM space to only the platforms that need it
Date: Mon,  8 Apr 2024 14:57:39 +0200
Message-ID: <20240408125315.003966147@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi.shyti@linux.intel.com>

[ Upstream commit 94bf3e60e1a61973cdb6488af873b8de66250c77 ]

Commit 9bb66c179f50 ("drm/i915: Reserve some kernel space per
vm") reduces the available VM space of one page in order to apply
Wa_16018031267 and Wa_16018063123.

This page was reserved indiscrimitely in all platforms even when
not needed. Limit it to DG2 onwards.

Fixes: 9bb66c179f50 ("drm/i915: Reserve some kernel space per vm")
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Chris Wilson <chris.p.wilson@linux.intel.com>
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Acked-by: Michal Mrozek <michal.mrozek@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240327200546.640108-1-andi.shyti@linux.intel.com
(cherry picked from commit 9721634441d5dedba7f9eebb2bf0c9411cbafc4e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c | 3 +++
 drivers/gpu/drm/i915/gt/intel_gt.c   | 6 ++++++
 drivers/gpu/drm/i915/gt/intel_gt.h   | 9 +++++----
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
index fa46d2308b0ed..81bf2216371be 100644
--- a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
@@ -961,6 +961,9 @@ static int gen8_init_rsvd(struct i915_address_space *vm)
 	struct i915_vma *vma;
 	int ret;
 
+	if (!intel_gt_needs_wa_16018031267(vm->gt))
+		return 0;
+
 	/* The memory will be used only by GPU. */
 	obj = i915_gem_object_create_lmem(i915, PAGE_SIZE,
 					  I915_BO_ALLOC_VOLATILE |
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index a425db5ed3a22..6a2c2718bcc38 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -1024,6 +1024,12 @@ enum i915_map_type intel_gt_coherent_map_type(struct intel_gt *gt,
 		return I915_MAP_WC;
 }
 
+bool intel_gt_needs_wa_16018031267(struct intel_gt *gt)
+{
+	/* Wa_16018031267, Wa_16018063123 */
+	return IS_GFX_GT_IP_RANGE(gt, IP_VER(12, 55), IP_VER(12, 71));
+}
+
 bool intel_gt_needs_wa_22016122933(struct intel_gt *gt)
 {
 	return MEDIA_VER_FULL(gt->i915) == IP_VER(13, 0) && gt->type == GT_MEDIA;
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.h b/drivers/gpu/drm/i915/gt/intel_gt.h
index 608f5c8729285..003eb93b826fd 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt.h
@@ -82,17 +82,18 @@ struct drm_printer;
 		  ##__VA_ARGS__);					\
 } while (0)
 
-#define NEEDS_FASTCOLOR_BLT_WABB(engine) ( \
-	IS_GFX_GT_IP_RANGE(engine->gt, IP_VER(12, 55), IP_VER(12, 71)) && \
-	engine->class == COPY_ENGINE_CLASS && engine->instance == 0)
-
 static inline bool gt_is_root(struct intel_gt *gt)
 {
 	return !gt->info.id;
 }
 
+bool intel_gt_needs_wa_16018031267(struct intel_gt *gt);
 bool intel_gt_needs_wa_22016122933(struct intel_gt *gt);
 
+#define NEEDS_FASTCOLOR_BLT_WABB(engine) ( \
+	intel_gt_needs_wa_16018031267(engine->gt) && \
+	engine->class == COPY_ENGINE_CLASS && engine->instance == 0)
+
 static inline struct intel_gt *uc_to_gt(struct intel_uc *uc)
 {
 	return container_of(uc, struct intel_gt, uc);
-- 
2.43.0



