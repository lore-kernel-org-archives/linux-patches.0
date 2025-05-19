Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E583A22D7A4;
	Mon, 19 May 2025 21:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689753; cv=none; b=X9iuMl8uLOXP7s2rZNk5wQjRnWuR/dASFPUq6PXvd9tmsPfZ9FxVeEOgY0ILMFheDLi49ZQAtoLx5B4MOJpvllJKnnnYdUCpQTgf2+BXE6zBfe5mX6oYSM6DpGjfDK6cJ6H3IZd58UTy+y81bv07DOzAgNnFRy6fQbQBTL63ybg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689753; c=relaxed/simple;
	bh=dBGuIOIWlp/el9IYWu4JiMWESDa/kRlskhlFhzheVRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W+XnXqGI0qcySGCODo9ntRQF4xomAqp037Df1nW7QjKG9lBTFscbn066ZFam9wo8J57OXW3mmGHpsoFHxe57t9B49TOcYjdB77MSW8hW6bXatpy+lfTZNwUapK5bOjhNet0JJn2Y1BDTnwd+D14XW3E10xVIqrUWttestMLuJY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=co5W3Ofp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="co5W3Ofp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA22C4CEE4;
	Mon, 19 May 2025 21:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689752;
	bh=dBGuIOIWlp/el9IYWu4JiMWESDa/kRlskhlFhzheVRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=co5W3OfpFoKtg+N9x6V0dchAfhDVEwFdCAh/Cw97hjJhAKyNrmBJAfi1ElDCioPg2
	 1Eme2axBHQZ6DTocGCXp9TlSY+FnlNbzEfH5eZYzHY1oRRxnp6y+Zf2ref8PwSV2hl
	 G3B9HTuHpSM0rcmH3n/M5EJyZ02+clqRmYyyiUlR3kh93wH23M+RlpTxsXQEdHJ9Hv
	 OpYXgVDUwbvgGAnPhVeqiUQlu/cJHjyctfjhTwUDxQao5FpQVbeY/kX1f+SjuGMsvV
	 H8NbYB+GNP40Flw8Xl0OwqM7wnjc2qE5fxptf89mu9BuK/DQdFluiI1ZwrGU1k3FOc
	 iIjwlTFL/feDg==
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
Subject: [PATCH AUTOSEL 6.12 15/18] drm/xe: Save the gt pointer in lrc and drop the tile
Date: Mon, 19 May 2025 17:22:04 -0400
Message-Id: <20250519212208.1986028-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212208.1986028-1-sashal@kernel.org>
References: <20250519212208.1986028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.29
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
index aec7db39c061e..f78b59b220a8f 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -874,7 +874,7 @@ static void *empty_lrc_data(struct xe_hw_engine *hwe)
 
 static void xe_lrc_set_ppgtt(struct xe_lrc *lrc, struct xe_vm *vm)
 {
-	u64 desc = xe_vm_pdp4_descriptor(vm, lrc->tile);
+	u64 desc = xe_vm_pdp4_descriptor(vm, gt_to_tile(lrc->gt));
 
 	xe_lrc_write_ctx_reg(lrc, CTX_PDP0_UDW, upper_32_bits(desc));
 	xe_lrc_write_ctx_reg(lrc, CTX_PDP0_LDW, lower_32_bits(desc));
@@ -905,6 +905,7 @@ static int xe_lrc_init(struct xe_lrc *lrc, struct xe_hw_engine *hwe,
 	int err;
 
 	kref_init(&lrc->refcount);
+	lrc->gt = gt;
 	lrc->flags = 0;
 	lrc_size = ring_size + xe_gt_lrc_size(gt, hwe->class);
 	if (xe_gt_has_indirect_ring_state(gt))
@@ -923,7 +924,6 @@ static int xe_lrc_init(struct xe_lrc *lrc, struct xe_hw_engine *hwe,
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

