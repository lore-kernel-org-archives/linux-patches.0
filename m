Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73884221DA2;
	Mon,  2 Jun 2025 14:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872802; cv=none; b=N+ErB8om3RQOvtizL7zJdqyeRSOftLhwQ+crSW2WcilyubqQ7enWDSGdonOg2iLYsEXwHDlvrNOSrHRxhsFtlB5LGBOGgXzh+GmWFGNp1m5vFsRaipjTXeCZnGRKaxm10SHfSreCC2HbKVKgoTdO3aFx/e7Hd3TIWqGcTJtj7G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872802; c=relaxed/simple;
	bh=YEvSHE7jmAbt4yQKOS6dmtoEFUnkUxjn0uAU+CK72E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pg+7YDjQ1VLwzOfqVVdH4apcjtFg/2NZ0eARydZDWnuNlHWBIBpOoSFMeG2IT1dDpD0s0YILLZQLbXE+w6kK98v70uDc7eVvIbivO/grwM3EkuFnUNPRXVSLv7b/0hdg9PCJGx60oJDfpjhk722RpW8I+5yyK9f7XvCS6oum7Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvtXGULd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvtXGULd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4722C4CEEB;
	Mon,  2 Jun 2025 14:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872802;
	bh=YEvSHE7jmAbt4yQKOS6dmtoEFUnkUxjn0uAU+CK72E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvtXGULd5Xa2Ie35xVNjzSIxac8V3BNGRbXyhT884GCGg7Jlx7aRb9/pMMHY3z5DL
	 VP1Qzb6pf2WMDnRh0ys1Aa7rR5L/8GnJ4SmiwNmoOOfg4+4+LtAnoTFPLyqcd9w1hx
	 2MdR04AlVIGf5+k+fKxtmV+jvmy45ookzA1TrU6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 66/73] drm/xe: Save the gt pointer in lrc and drop the tile
Date: Mon,  2 Jun 2025 15:47:52 +0200
Message-ID: <20250602134244.290297116@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 2a953c4f7d5dd..5d7629bb6b8dd 100644
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



