Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622472;
	b=R0uJunWV3+nk262+XInynVjBMOxrtcFQfLGUbrFcmCvhDmhC6SQzX8QzeCzTptjd2OLm
	 JceUHxPZ3qMj+fD4qcnEYX3OzzmzvqJ8N72zbvgs2aWi2sySV2nnQHrEB8OxXvZBnPVG7
	 vAK3UHQYYEBt6DGSj+0+4IDZ8NpL5M6qoX8kzDyq/DY9FVqjbBWqCli2v6aNvgbRnbDM4
	 Bw2urXmP79Rel/bpJAWVxr+Yj1P8Aben8QxYBkmppO/qjcYcWheGPd3CTe71sVhdyeU2V
	 RSivG53SSzCPGGg7Ha+MiRmNqmXIb3iPYxud9/bj6xjSP8sEbClTg2yp8FvwnY/d2aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4J5V0m8oWPX5NwCSI1oTxu2ATSO6Z/wN6x70N0Fmk7E=;
	b=nDjc60/mZiO6wkRWLbvc7iM/SWbseARz/dzgcWULhFzxS7GJSWP2CdgBXHPfUKwBfM33
	 gs6s/G4K/7oaaVd5XoGaJC1qo5MPMIlZu++/HWBjWNEs6HWxP8mbuZOHG2xr1VlBMCxOm
	 He+Ew18TxohDfwHtLOpCHMoTiywKRHGCFDrVSSAhS+/D9h+gaYM2f+U8MiOa3CLvPUGEn
	 V+CcY/m7AU7nr32b/N3fWpDpCd46IaUtZ/p4oFPLx609dD4sChDDLkvLnh9/38R4kxoOw
	 jJt5D26akhwYxIrpUmEgSZYeQUTC9iOVh7FEO16ZEYh5YbagCEpkg6lIF3wwJVpyXvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iBcg/Y2q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DFE606A32C;
	Wed, 25 Nov 2026 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBcg/Y2q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753D11F000D8;
	Wed, 25 Nov 2026 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622472;
	bh=4J5V0m8oWPX5NwCSI1oTxu2ATSO6Z/wN6x70N0Fmk7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBcg/Y2qJ/HfoHOrXcTq0iQ2p24UlMfne/PsckZSgulh4n1xhdIpBOQQ8uTi9VAy6
	 gRD8oGsH3iuIl2z0QLnLzGsdPomlP2QwMbY46GjqE9xQMNB5sFD7Z+cjDjr+rQuQsx
	 0Z158JDKgEQYRylso+bDT7FlaVd4ZNHqeMcnDK6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 504/990] accel/amdxdna: Fix unexpected wait when flushing notifier_wq
Date: Wed, 25 Nov 2026 15:31:11 +0100
Message-ID: <20261125143833.907571924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 445d20910429b41e88768624b914344658991a5b ]

In amdxdna_gem_obj_free(), flush_workqueue(xdna->notifier_wq) waits for
all pending work items on the device-global notifier workqueue, rather
than only the work items associated with the BO being freed.

If another BO has a pending hmm_unreg_work, freeing an unrelated BO can
be unnecessarily blocked until that work completes.

mmu_interval_notifier_remove() is deferred to a workqueue because it
cannot be called from the MMU notifier callback itself. The BO free path
is not a notifier callback, so call mmu_interval_notifier_remove()
directly there and avoid the workqueue.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260813205016.941743-1-lizhi.hou@amd.com
[ sashal: Replaced abo->mem.uva with abo->mem.userptr in the unreg work handler, and adjusted surrounding context in the BO free path to match this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 69 +++++++++++++++++++----------
 drivers/accel/amdxdna/amdxdna_gem.h |  1 +
 2 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 412b48f49fa20..69c9034fae78a 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -106,13 +106,16 @@ static bool amdxdna_hmm_invalidate(struct mmu_interval_notifier *mni,
 	struct amdxdna_gem_obj *abo = mapp->abo;
 	struct amdxdna_dev *xdna;
 
+	if (!mmu_notifier_range_blockable(range))
+		return false;
+
+	if (mapp->unmapped)
+		return true;
+
 	xdna = to_xdna_dev(to_gobj(abo)->dev);
 	XDNA_DBG(xdna, "Invalidating range 0x%lx, 0x%lx, type %d",
 		 mapp->range.start, mapp->range.end, abo->type);
 
-	if (!mmu_notifier_range_blockable(range))
-		return false;
-
 	down_write(&xdna->notifier_lock);
 	abo->mem.map_invalid = true;
 	mapp->invalid = true;
@@ -153,33 +156,40 @@ static void amdxdna_hmm_unregister(struct amdxdna_gem_obj *abo,
 
 	down_write(&xdna->notifier_lock);
 	list_for_each_entry(mapp, &abo->mem.umap_list, node) {
-		if (!vma || compare_range(mapp, vma->vm_mm, vma->vm_start, vma->vm_end)) {
-			if (!mapp->unmapped) {
-				queue_work(xdna->notifier_wq, &mapp->hmm_unreg_work);
-				mapp->unmapped = true;
-			}
-			if (vma)
-				break;
-		}
+		if (!compare_range(mapp, vma->vm_mm, vma->vm_start, vma->vm_end))
+			continue;
+
+		queue_work(xdna->notifier_wq, &mapp->hmm_unreg_work);
+		mapp->unmapped = true;
 	}
 	up_write(&xdna->notifier_lock);
 }
 
-static void amdxdna_umap_release(struct kref *ref)
+static void amdxdna_hmm_unregister_all(struct amdxdna_gem_obj *abo)
 {
-	struct amdxdna_umap *mapp = container_of(ref, struct amdxdna_umap, refcnt);
-	struct amdxdna_gem_obj *abo = mapp->abo;
-	struct amdxdna_dev *xdna;
-
-	mmu_interval_notifier_remove(&mapp->notifier);
+	struct amdxdna_dev *xdna = to_xdna_dev(to_gobj(abo)->dev);
+	struct amdxdna_umap *mapp, *tmp;
+	LIST_HEAD(dead);
 
-	xdna = to_xdna_dev(to_gobj(mapp->abo)->dev);
 	down_write(&xdna->notifier_lock);
-	list_del(&mapp->node);
-	if (list_empty(&abo->mem.umap_list))
-		abo->mem.userptr = AMDXDNA_INVALID_ADDR;
+	list_for_each_entry_safe(mapp, tmp, &abo->mem.umap_list, node) {
+		mapp->unmapped = true;
+		mapp->cleanup = true;
+		list_move(&mapp->node, &dead);
+	}
 	up_write(&xdna->notifier_lock);
 
+	list_for_each_entry_safe(mapp, tmp, &dead, node) {
+		cancel_work_sync(&mapp->hmm_unreg_work);
+		amdxdna_umap_put(mapp);
+	}
+}
+
+static void amdxdna_umap_release(struct kref *ref)
+{
+	struct amdxdna_umap *mapp = container_of(ref, struct amdxdna_umap, refcnt);
+
+	mmu_interval_notifier_remove(&mapp->notifier);
 	kvfree(mapp->range.hmm_pfns);
 	kfree(mapp);
 }
@@ -193,6 +203,20 @@ static void amdxdna_hmm_unreg_work(struct work_struct *work)
 {
 	struct amdxdna_umap *mapp = container_of(work, struct amdxdna_umap,
 						 hmm_unreg_work);
+	struct amdxdna_gem_obj *abo = mapp->abo;
+	struct amdxdna_dev *xdna;
+
+	xdna = to_xdna_dev(to_gobj(mapp->abo)->dev);
+	down_write(&xdna->notifier_lock);
+	if (mapp->cleanup) {
+		up_write(&xdna->notifier_lock);
+		return;
+	}
+
+	list_del(&mapp->node);
+	if (list_empty(&abo->mem.umap_list))
+		abo->mem.userptr = AMDXDNA_INVALID_ADDR;
+	up_write(&xdna->notifier_lock);
 
 	amdxdna_umap_put(mapp);
 }
@@ -482,8 +506,7 @@ static void amdxdna_gem_obj_free(struct drm_gem_object *gobj)
 
 	XDNA_DBG(xdna, "BO type %d xdna_addr 0x%llx", abo->type, abo->mem.dev_addr);
 
-	amdxdna_hmm_unregister(abo, NULL);
-	flush_workqueue(xdna->notifier_wq);
+	amdxdna_hmm_unregister_all(abo);
 
 	if (abo->pinned)
 		amdxdna_gem_unpin(abo);
diff --git a/drivers/accel/amdxdna/amdxdna_gem.h b/drivers/accel/amdxdna/amdxdna_gem.h
index b3c814c0bb7e6..8d89874f1fca3 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.h
+++ b/drivers/accel/amdxdna/amdxdna_gem.h
@@ -17,6 +17,7 @@ struct amdxdna_umap {
 	struct kref			refcnt;
 	bool				invalid;
 	bool				unmapped;
+	bool				cleanup;
 };
 
 struct amdxdna_mem {
-- 
2.53.0



