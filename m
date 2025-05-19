Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286932236E8;
	Mon, 19 May 2025 21:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689723; cv=none; b=Jlt9ShPe1wFJJo131VW7+Hjr77wz0ca24fvyRMsaln7MQZQp35qzL3mvyoYYQQg5PvLF0gZhBewv2lT+o1tzG2jm66GWixEIT/mCw9O8bulVDDNjwBE6E4SQNu1jrbZDOCgYJ3No7ZEdzzmxF4rmbfq1ce6Os2BNZiEoM7bgXvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689723; c=relaxed/simple;
	bh=EAmgiyPFV5c9rJFBaTMy007/kWYs/PDsFSDsIkiOCqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PpCacxETAnxkXrQaop8ie0IWYE823bWZ1SA4wHB9lKitNmAi4VjvbYN4hvs6Pb3wePOHSqwCFr/rVHt3ppZJV+8JPgd3yBMN6y/0Vw2zzuga7v7NpDQ7bk52kMxazZF/CMn4UxADBwSe8DWOMCcL4ih9kUtS/IrTlbBeoynWWks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hgUqBMV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hgUqBMV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA98CC4CEE9;
	Mon, 19 May 2025 21:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689723;
	bh=EAmgiyPFV5c9rJFBaTMy007/kWYs/PDsFSDsIkiOCqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgUqBMV49KSjJpD6AUXJra0syGwXEDqAIfct8aDIs/GMjDrbrwhuqSzZAp8tXL08l
	 BLVB14GwlT4ny59FIZGq3MXUXifoSNzMbWIISJLzN5/uyGtYlb8O9V/DHnGQNUVZqo
	 qInZ0YGLAvrok+KufwjkyW2eGfs9ivJjm+uyA+oxK4SNxos0Wih1wkBoM+WoLdEj9j
	 /dmEV1kEI8iEfME7p3B8TzuenUX+stueIFKY5kR4JsC5H8PnRSmAIs+pr+0pGgAIbz
	 5NSK+eULWSUWsH08wUlHqmOv5uJVp3poUoxXgCQUtJxSVAkJ7Ofe5XyvD2zm0gSU6M
	 fVAcZWBci6EiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@linux.ie,
	daniel@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 20/23] drm/xe: Save the gt pointer in lrc and drop the tile
Date: Mon, 19 May 2025 17:21:27 -0400
Message-Id: <20250519212131.1985647-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
Content-Transfer-Encoding: 8bit

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit ce15563e49fb0b5c802564433ff8468acd1339eb ]

Save the gt pointer in the lrc so that it can used for gt based helpers.

Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250509161159.2173069-7-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 741d3ef8b8b88fab2729ca89de1180e49bc9cef0)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_lrc.c       | 4 ++--
 drivers/gpu/drm/xe/xe_lrc_types.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index bbb9ffbf63672..64e36830fd03d 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -864,7 +864,7 @@ static void *empty_lrc_data(struct xe_hw_engine *hwe)
 
 static void xe_lrc_set_ppgtt(struct xe_lrc *lrc, struct xe_vm *vm)
 {
-	u64 desc = xe_vm_pdp4_descriptor(vm, lrc->tile);
+	u64 desc = xe_vm_pdp4_descriptor(vm, gt_to_tile(lrc->gt));
 
 	xe_lrc_write_ctx_reg(lrc, CTX_PDP0_UDW, upper_32_bits(desc));
 	xe_lrc_write_ctx_reg(lrc, CTX_PDP0_LDW, lower_32_bits(desc));
@@ -895,6 +895,7 @@ static int xe_lrc_init(struct xe_lrc *lrc, struct xe_hw_engine *hwe,
 	int err;
 
 	kref_init(&lrc->refcount);
+	lrc->gt = gt;
 	lrc->flags = 0;
 	lrc_size = ring_size + xe_gt_lrc_size(gt, hwe->class);
 	if (xe_gt_has_indirect_ring_state(gt))
@@ -913,7 +914,6 @@ static int xe_lrc_init(struct xe_lrc *lrc, struct xe_hw_engine *hwe,
 		return PTR_ERR(lrc->bo);
 
 	lrc->size = lrc_size;
-	lrc->tile = gt_to_tile(hwe->gt);
 	lrc->ring.size = ring_size;
 	lrc->ring.tail = 0;
 	lrc->ctx_timestamp = 0;
diff --git a/drivers/gpu/drm/xe/xe_lrc_types.h b/drivers/gpu/drm/xe/xe_lrc_types.h
index 71ecb453f811a..cd38586ae9893 100644
--- a/drivers/gpu/drm/xe/xe_lrc_types.h
+++ b/drivers/gpu/drm/xe/xe_lrc_types.h
@@ -25,8 +25,8 @@ struct xe_lrc {
 	/** @size: size of lrc including any indirect ring state page */
 	u32 size;
 
-	/** @tile: tile which this LRC belongs to */
-	struct xe_tile *tile;
+	/** @gt: gt which this LRC belongs to */
+	struct xe_gt *gt;
 
 	/** @flags: LRC flags */
 #define XE_LRC_FLAG_INDIRECT_RING_STATE		0x1
-- 
2.39.5

