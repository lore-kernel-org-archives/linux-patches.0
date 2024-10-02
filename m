Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC771D26FE;
	Wed,  2 Oct 2024 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877922; cv=none; b=lKdFckFwRVRO9/3h67bbgryXArNbUIeJvmoRgZBAH6fqmAQWSEik/INYO8vqQoVxzVA6cIc4pjTzfLT0u3knUw6RtY/pt/VQcUdYfXn/TIH2woXvYlmWmJNUhnqMZSJ1Uj3IjfMhzJAP7PGHH7OaD6ybNWpCWa/OH+0luPQlWNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877922; c=relaxed/simple;
	bh=f3R7qUrauKXJn+4t8heDqzHm2TF5QPB2lRZcUqj1b0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOs/KgV6tgaLcKDc6nzoc3hqXJUcV8PrTT/92Z0JTxbYJp3q5KbRJz5ux6OZArjRJJJRHpZIhHmqFWPgtHLEPkm4FBWsuHWNLLgM4tbRXpQ9wfUJOWe7RCB7hcvmwWp7v9jAxv2j7Q4yUgazvHFKH20OA6zCIb6LromgJr9wxdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJjs+hCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJjs+hCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73749C4CEC2;
	Wed,  2 Oct 2024 14:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877921;
	bh=f3R7qUrauKXJn+4t8heDqzHm2TF5QPB2lRZcUqj1b0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJjs+hCMJ6S8WLnLgST5iyL8NvOXgq5RyxnAipPrqbE4hHYkD6kjCpfdtzgPEwhmN
	 BwUei8g5olsiUsJ3D+1ZTzedlmZLybTJm3xeX1Myf9YMDRXnQl4wO4mJ7IIMywmtVM
	 FBJe4FHst1Xt+OKenvkJrn44SC9WJ0pPlFpvrX2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 199/634] drm/msm: Use a7xx family directly in gpu_state
Date: Wed,  2 Oct 2024 14:54:59 +0200
Message-ID: <20241002125818.960636457@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Connor Abbott <cwabbott0@gmail.com>

[ Upstream commit db75ef03d72ea75515f5282fe8a4925ae8373fe1 ]

With a7xx, we need to import a new header for each new generation and
switch to a different list of registers, instead of making
backwards-compatible changes. Using the helpers inadvertently made a750
use the a740 list of registers, instead use the family directly to fix
this.

Fixes: f3f8207d8aed ("drm/msm: Add devcoredump support for a750")
Signed-off-by: Connor Abbott <cwabbott0@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/607392/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 41 ++++++++++-----------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 789a11416f7a4..f2030e521a03a 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -388,18 +388,18 @@ static void a7xx_get_debugbus_blocks(struct msm_gpu *gpu,
 	const u32 *debugbus_blocks, *gbif_debugbus_blocks;
 	int i;
 
-	if (adreno_is_a730(adreno_gpu)) {
+	if (adreno_gpu->info->family == ADRENO_7XX_GEN1) {
 		debugbus_blocks = gen7_0_0_debugbus_blocks;
 		debugbus_blocks_count = ARRAY_SIZE(gen7_0_0_debugbus_blocks);
 		gbif_debugbus_blocks = a7xx_gbif_debugbus_blocks;
 		gbif_debugbus_blocks_count = ARRAY_SIZE(a7xx_gbif_debugbus_blocks);
-	} else if (adreno_is_a740_family(adreno_gpu)) {
+	} else if (adreno_gpu->info->family == ADRENO_7XX_GEN2) {
 		debugbus_blocks = gen7_2_0_debugbus_blocks;
 		debugbus_blocks_count = ARRAY_SIZE(gen7_2_0_debugbus_blocks);
 		gbif_debugbus_blocks = a7xx_gbif_debugbus_blocks;
 		gbif_debugbus_blocks_count = ARRAY_SIZE(a7xx_gbif_debugbus_blocks);
 	} else {
-		BUG_ON(!adreno_is_a750(adreno_gpu));
+		BUG_ON(adreno_gpu->info->family != ADRENO_7XX_GEN3);
 		debugbus_blocks = gen7_9_0_debugbus_blocks;
 		debugbus_blocks_count = ARRAY_SIZE(gen7_9_0_debugbus_blocks);
 		gbif_debugbus_blocks = gen7_9_0_gbif_debugbus_blocks;
@@ -509,7 +509,7 @@ static void a6xx_get_debugbus(struct msm_gpu *gpu,
 		const struct a6xx_debugbus_block *cx_debugbus_blocks;
 
 		if (adreno_is_a7xx(adreno_gpu)) {
-			BUG_ON(!(adreno_is_a730(adreno_gpu) || adreno_is_a740_family(adreno_gpu)));
+			BUG_ON(adreno_gpu->info->family > ADRENO_7XX_GEN3);
 			cx_debugbus_blocks = a7xx_cx_debugbus_blocks;
 			nr_cx_debugbus_blocks = ARRAY_SIZE(a7xx_cx_debugbus_blocks);
 		} else {
@@ -660,11 +660,11 @@ static void a7xx_get_dbgahb_clusters(struct msm_gpu *gpu,
 	const struct gen7_sptp_cluster_registers *dbgahb_clusters;
 	unsigned dbgahb_clusters_size;
 
-	if (adreno_is_a730(adreno_gpu)) {
+	if (adreno_gpu->info->family == ADRENO_7XX_GEN1) {
 		dbgahb_clusters = gen7_0_0_sptp_clusters;
 		dbgahb_clusters_size = ARRAY_SIZE(gen7_0_0_sptp_clusters);
 	} else {
-		BUG_ON(!adreno_is_a740_family(adreno_gpu));
+		BUG_ON(adreno_gpu->info->family > ADRENO_7XX_GEN3);
 		dbgahb_clusters = gen7_2_0_sptp_clusters;
 		dbgahb_clusters_size = ARRAY_SIZE(gen7_2_0_sptp_clusters);
 	}
@@ -818,14 +818,14 @@ static void a7xx_get_clusters(struct msm_gpu *gpu,
 	const struct gen7_cluster_registers *clusters;
 	unsigned clusters_size;
 
-	if (adreno_is_a730(adreno_gpu)) {
+	if (adreno_gpu->info->family == ADRENO_7XX_GEN1) {
 		clusters = gen7_0_0_clusters;
 		clusters_size = ARRAY_SIZE(gen7_0_0_clusters);
-	} else if (adreno_is_a740_family(adreno_gpu)) {
+	} else if (adreno_gpu->info->family == ADRENO_7XX_GEN2) {
 		clusters = gen7_2_0_clusters;
 		clusters_size = ARRAY_SIZE(gen7_2_0_clusters);
 	} else {
-		BUG_ON(!adreno_is_a750(adreno_gpu));
+		BUG_ON(adreno_gpu->info->family != ADRENO_7XX_GEN3);
 		clusters = gen7_9_0_clusters;
 		clusters_size = ARRAY_SIZE(gen7_9_0_clusters);
 	}
@@ -893,7 +893,7 @@ static void a7xx_get_shader_block(struct msm_gpu *gpu,
 	if (WARN_ON(datasize > A6XX_CD_DATA_SIZE))
 		return;
 
-	if (adreno_is_a730(adreno_gpu)) {
+	if (adreno_gpu->info->family == ADRENO_7XX_GEN1) {
 		gpu_rmw(gpu, REG_A7XX_SP_DBG_CNTL, GENMASK(1, 0), 3);
 	}
 
@@ -923,7 +923,7 @@ static void a7xx_get_shader_block(struct msm_gpu *gpu,
 		datasize);
 
 out:
-	if (adreno_is_a730(adreno_gpu)) {
+	if (adreno_gpu->info->family == ADRENO_7XX_GEN1) {
 		gpu_rmw(gpu, REG_A7XX_SP_DBG_CNTL, GENMASK(1, 0), 0);
 	}
 }
@@ -956,14 +956,14 @@ static void a7xx_get_shaders(struct msm_gpu *gpu,
 	unsigned num_shader_blocks;
 	int i;
 
-	if (adreno_is_a730(adreno_gpu)) {
+	if (adreno_gpu->info->family == ADRENO_7XX_GEN1) {
 		shader_blocks = gen7_0_0_shader_blocks;
 		num_shader_blocks = ARRAY_SIZE(gen7_0_0_shader_blocks);
-	} else if (adreno_is_a740_family(adreno_gpu)) {
+	} else if (adreno_gpu->info->family == ADRENO_7XX_GEN2) {
 		shader_blocks = gen7_2_0_shader_blocks;
 		num_shader_blocks = ARRAY_SIZE(gen7_2_0_shader_blocks);
 	} else {
-		BUG_ON(!adreno_is_a750(adreno_gpu));
+		BUG_ON(adreno_gpu->info->family != ADRENO_7XX_GEN3);
 		shader_blocks = gen7_9_0_shader_blocks;
 		num_shader_blocks = ARRAY_SIZE(gen7_9_0_shader_blocks);
 	}
@@ -1348,14 +1348,14 @@ static void a7xx_get_registers(struct msm_gpu *gpu,
 	const u32 *pre_crashdumper_regs;
 	const struct gen7_reg_list *reglist;
 
-	if (adreno_is_a730(adreno_gpu)) {
+	if (adreno_gpu->info->family == ADRENO_7XX_GEN1) {
 		reglist = gen7_0_0_reg_list;
 		pre_crashdumper_regs = gen7_0_0_pre_crashdumper_gpu_registers;
-	} else if (adreno_is_a740_family(adreno_gpu)) {
+	} else if (adreno_gpu->info->family == ADRENO_7XX_GEN2) {
 		reglist = gen7_2_0_reg_list;
 		pre_crashdumper_regs = gen7_0_0_pre_crashdumper_gpu_registers;
 	} else {
-		BUG_ON(!adreno_is_a750(adreno_gpu));
+		BUG_ON(adreno_gpu->info->family != ADRENO_7XX_GEN3);
 		reglist = gen7_9_0_reg_list;
 		pre_crashdumper_regs = gen7_9_0_pre_crashdumper_gpu_registers;
 	}
@@ -1405,8 +1405,7 @@ static void a7xx_get_post_crashdumper_registers(struct msm_gpu *gpu,
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	const u32 *regs;
 
-	BUG_ON(!(adreno_is_a730(adreno_gpu) || adreno_is_a740_family(adreno_gpu) ||
-		 adreno_is_a750(adreno_gpu)));
+	BUG_ON(adreno_gpu->info->family > ADRENO_7XX_GEN3);
 	regs = gen7_0_0_post_crashdumper_registers;
 
 	a7xx_get_ahb_gpu_registers(gpu,
@@ -1514,11 +1513,11 @@ static void a7xx_get_indexed_registers(struct msm_gpu *gpu,
 	const struct a6xx_indexed_registers *indexed_regs;
 	int i, indexed_count, mempool_count;
 
-	if (adreno_is_a730(adreno_gpu) || adreno_is_a740_family(adreno_gpu)) {
+	if (adreno_gpu->info->family <= ADRENO_7XX_GEN2) {
 		indexed_regs = a7xx_indexed_reglist;
 		indexed_count = ARRAY_SIZE(a7xx_indexed_reglist);
 	} else {
-		BUG_ON(!adreno_is_a750(adreno_gpu));
+		BUG_ON(adreno_gpu->info->family != ADRENO_7XX_GEN3);
 		indexed_regs = gen7_9_0_cp_indexed_reg_list;
 		indexed_count = ARRAY_SIZE(gen7_9_0_cp_indexed_reg_list);
 	}
-- 
2.43.0



