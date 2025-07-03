Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F6222069F;
	Thu,  3 Jul 2025 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555357; cv=none; b=LipRg6p/xxD7guQk+p6s1lr/xTWKIWn5/EQZ+bXh90UDmxUQ/86/ibRgl3E6G3giBtg5wAggbS1Op0jWV+j0SqYKEYpNB3qjfmctjIxPcHuaYAhpS7Lms5rRTd/aWh/sn6d7UFmhr0FjoFX7DTCcdpB6OvAPhiJKkAexk6EiJ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555357; c=relaxed/simple;
	bh=6Ze/NE6YOLzl/beCOEhB2wgUsX4hygHudPkzFK4M2/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMlJOOb3jeLWsEsdGqCA03QYYj6saCY5vzhSOwZAt61MfvcrVHMr6Yj/ptvKaWTJzwtD/cQJeji7p8m9gKwvgWcZD/h2LbzSGs9eW5RFQ4yABTeJ/HT+mKAj+OzVK8YD3GIrWTjIc82yvthhIKhZKcyjgyJRXkTfTKbEWowB1+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6YExVhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6YExVhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42E5C4CEE3;
	Thu,  3 Jul 2025 15:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555354;
	bh=6Ze/NE6YOLzl/beCOEhB2wgUsX4hygHudPkzFK4M2/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6YExVhSKb5ilgKhcEpZ1u9XqKqpV6ldfcK5qZ9gN9Rvp0L6OGhZb2GYIySzZ8Ky0
	 rpJr3gLThbJdKKb/14eo6uNlfgltHIwLfkLocY/J2B+t+/4LJ4CnzPahJNW7eOm3rh
	 QUHQ36bc7yLIl+MAT9+nGtxSXwvQEPDm72Aui80U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.15 225/263] drm/xe/guc_submit: add back fix
Date: Thu,  3 Jul 2025 16:42:25 +0200
Message-ID: <20250703144013.406813149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 2e824747cfbdf1fba88df5e5800d284b2602ae8f upstream.

Daniele noticed that the fix in commit 2d2be279f1ca ("drm/xe: fix UAF
around queue destruction") looks to have been unintentionally removed as
part of handling a conflict in some past merge commit. Add it back.

Fixes: ac44ff7cec33 ("Merge tag 'drm-xe-fixes-2024-10-10' of https://gitlab.freedesktop.org/drm/xe/kernel into drm-fixes")
Reported-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.12+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250603174213.1543579-2-matthew.auld@intel.com
(cherry picked from commit 9d9fca62dc49d96f97045b6d8e7402a95f8cf92a)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -229,6 +229,17 @@ static bool exec_queue_killed_or_banned_
 static void guc_submit_fini(struct drm_device *drm, void *arg)
 {
 	struct xe_guc *guc = arg;
+	struct xe_device *xe = guc_to_xe(guc);
+	struct xe_gt *gt = guc_to_gt(guc);
+	int ret;
+
+	ret = wait_event_timeout(guc->submission_state.fini_wq,
+				 xa_empty(&guc->submission_state.exec_queue_lookup),
+				 HZ * 5);
+
+	drain_workqueue(xe->destroy_wq);
+
+	xe_gt_assert(gt, ret);
 
 	xa_destroy(&guc->submission_state.exec_queue_lookup);
 }


