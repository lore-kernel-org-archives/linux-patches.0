Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE512F0030;
	Thu,  3 Jul 2025 14:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554371; cv=none; b=SAWOExc65pRaA4OyqdLyttY7DDzO8oldurI4ghMn6wncdAqb+7HFgZqrUPVwIriaNrhpWCu8+Hz318orYASSpM7K6yF/tgd2O8bYYeT9MBfFcGdYOkAAt1pQlhBXoe3G1meuoyFy+Q+Qt4N3C3mBBC1o7MasLdzjJAhmy0ZezDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554371; c=relaxed/simple;
	bh=+TcYuGUBXPgVHmQZLoZGMAYGsI/9xytFsGOBw79oxI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KrzJ16aPaA19MJPgv8MFNUeZwKDwWgR/NXgHuMirrZUbNMVXH55Kel7gRHOZvuIpIIdlIgf2LDI54jsE9LF0PG0DVjyAnZQcoRQo0zN/acCnMc2mDKxareqlr/PMYW9VPwn4bA6NjvIIj9sEVU+puD3LOWcJ6Ru0pRH/QEk9X9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0SeSHIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0SeSHIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7656C4CEE3;
	Thu,  3 Jul 2025 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554371;
	bh=+TcYuGUBXPgVHmQZLoZGMAYGsI/9xytFsGOBw79oxI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0SeSHIcc1xcHEGnecVvClace9dKc1k289EXuITTrN3b4FftdYgEJ59ApJXAtksvn
	 1GwEfgNYcImPbAnhT709aKHucoE5z7CQ7Yg03ATNM1bFk4D0vXeMyP41EKIo8+l4Du
	 +nntjvGwChb5NLRCUBTZfhhVGR2pPatdXZHnOopI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 166/218] drm/xe/guc_submit: add back fix
Date: Thu,  3 Jul 2025 16:41:54 +0200
Message-ID: <20250703144002.797711168@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -227,6 +227,17 @@ static bool exec_queue_killed_or_banned_
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


