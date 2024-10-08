Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A034D192594;
	Tue,  8 Oct 2024 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390986; cv=none; b=ViWcMRGmkA9/AbC/2w1Ixu+AFoTnU6IjQmrYQDs2R0oAFynWCBk0nX1WFqIlZJb0rwJox7p26j459aAPmgAV7/BZ11s9/w2vfcPDGuVXs/M3NdHl6PMUoRk8uQjUJ37XkwKKB3mM1uAEVC0JS/nEnugvJPfMuEXkHQFzDhY9DRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390986; c=relaxed/simple;
	bh=erH7kyPwNHgU/WWsCQ69ox0lD3MMhH4/wXG1gBJrxHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA7xOzokRsGyIJ+L0c6OCdRNxHFqc0LRBF82wa9FI3M2yqUXB5wuJpdTLQkU5EHxOiwF2JBofJyXVpKIu9ySGS6Y/t52VRuRuXJMZ/nJKM+NTmW1V+LOghmfgt82MZ7MD5tnXs/nVBVsHUXyLLJ+yOccv3Cdsh/mCOWGfRVLoqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCE2DlKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCE2DlKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25582C4CEC7;
	Tue,  8 Oct 2024 12:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390986;
	bh=erH7kyPwNHgU/WWsCQ69ox0lD3MMhH4/wXG1gBJrxHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCE2DlKysB/sNjQ+ktLAUgdPHSBXLL+GiuKqo4HCGsadrKgUQglMzJ8YXOIetC7wb
	 vJW5tAoNv5XvdDemOtEQdZEpD+3JK06UmxaORYrRRQFnjImEohmjtlyy0ZAIrifE22
	 9L7mujYtkICSY8WwfYYIULhOAGPAzzSPALW3TQZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 455/482] drm/xe: Delete unused GuC submission_state.suspend
Date: Tue,  8 Oct 2024 14:08:38 +0200
Message-ID: <20241008115706.422643522@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 3f371a98deada9aee53d908c9aa53f6cdcb1300b ]

GuC submission_state.suspend is unused, delete it.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240425054747.1918811-1-matthew.brost@intel.com
Stable-dep-of: 2d2be279f1ca ("drm/xe: fix UAF around queue destruction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 4 ----
 drivers/gpu/drm/xe/xe_guc_types.h  | 9 ---------
 2 files changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 958dde8422d7e..a40287a7c3de8 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -251,7 +251,6 @@ static void primelockdep(struct xe_guc *guc)
 	fs_reclaim_acquire(GFP_KERNEL);
 
 	mutex_lock(&guc->submission_state.lock);
-	might_lock(&guc->submission_state.suspend.lock);
 	mutex_unlock(&guc->submission_state.lock);
 
 	fs_reclaim_release(GFP_KERNEL);
@@ -279,9 +278,6 @@ int xe_guc_submit_init(struct xe_guc *guc)
 
 	xa_init(&guc->submission_state.exec_queue_lookup);
 
-	spin_lock_init(&guc->submission_state.suspend.lock);
-	guc->submission_state.suspend.context = dma_fence_context_alloc(1);
-
 	primelockdep(guc);
 
 	return drmm_add_action_or_reset(&xe->drm, guc_submit_fini, guc);
diff --git a/drivers/gpu/drm/xe/xe_guc_types.h b/drivers/gpu/drm/xe/xe_guc_types.h
index 82bd93f7867d1..546ac6350a31f 100644
--- a/drivers/gpu/drm/xe/xe_guc_types.h
+++ b/drivers/gpu/drm/xe/xe_guc_types.h
@@ -72,15 +72,6 @@ struct xe_guc {
 		atomic_t stopped;
 		/** @submission_state.lock: protects submission state */
 		struct mutex lock;
-		/** @submission_state.suspend: suspend fence state */
-		struct {
-			/** @submission_state.suspend.lock: suspend fences lock */
-			spinlock_t lock;
-			/** @submission_state.suspend.context: suspend fences context */
-			u64 context;
-			/** @submission_state.suspend.seqno: suspend fences seqno */
-			u32 seqno;
-		} suspend;
 #ifdef CONFIG_PROVE_LOCKING
 #define NUM_SUBMIT_WQ	256
 		/** @submission_state.submit_wq_pool: submission ordered workqueues pool */
-- 
2.43.0



