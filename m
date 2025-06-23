Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE834C6E;
	Mon, 23 Jun 2025 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686009; cv=none; b=AwHK/9SxW9c1Xp1UMcRHvi1yj0iX0EynzrrFaetK0zzL9zVf1+882iOCzF4Xk5h75xJ67LTM0MN+tMp8zQg7eGuG6/5G0GCgiXt4G5cuh7UudJf5l1mCB9Jtq+o6GqpoGvnwmx8ueQVZIkvibQAhzNiJIFA6/WpT/M7sH7mU9+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686009; c=relaxed/simple;
	bh=GTsC9Dh/i0fzb95fQFO/xKPBFxbXMy77s4L0/aY9QU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9zuuBUWTDUcWOehSNajUrHgh+5wHo09MtStQdsWQMMTSmMSkfnAvpXVT6VTMfnL5CmznpivmcN9o2hJhsfwYYTkW+zZNk3460AeyM8TLo4Tx2r5bRn8AzpP1+YGpK/InGEICmxDJPCwqe4nbv0/voXLc3mSKFPJlCmX7c6V5FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJPCk1V8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJPCk1V8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469D0C4CEEA;
	Mon, 23 Jun 2025 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686009;
	bh=GTsC9Dh/i0fzb95fQFO/xKPBFxbXMy77s4L0/aY9QU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJPCk1V8rdi0saDfzRr3rdA2h5Um2lqHWosQj7DdQoADrPy5el03Wo476Q6bBSW08
	 KPxHcLZHI4WCDX31dp1oRD4MWn7vrzX4pD6EHOom71BW/319X0054xpmI2LwByUmDb
	 MsKGKGObxDcm5MWYv1cqRcaiZggtbp7zRp4TOScU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Harish Chegondi <harish.chegondi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 276/592] drm/xe: Use copy_from_user() instead of __copy_from_user()
Date: Mon, 23 Jun 2025 15:03:54 +0200
Message-ID: <20250623130706.901162096@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Chegondi <harish.chegondi@intel.com>

[ Upstream commit aef87a5fdb5117eafb498ac4fc25e9f26f630f45 ]

copy_from_user() has more checks and is more safer than
__copy_from_user()

Suggested-by: Kees Cook <kees@kernel.org>
Signed-off-by: Harish Chegondi <harish.chegondi@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://lore.kernel.org/r/acabf20aa8621c7bc8de09b1bffb8d14b5376484.1746126614.git.harish.chegondi@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c         | 4 ++--
 drivers/gpu/drm/xe/xe_eu_stall.c   | 4 ++--
 drivers/gpu/drm/xe/xe_exec.c       | 4 ++--
 drivers/gpu/drm/xe/xe_exec_queue.c | 9 ++++-----
 drivers/gpu/drm/xe/xe_oa.c         | 6 +++---
 drivers/gpu/drm/xe/xe_vm.c         | 6 +++---
 6 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 5922302c3e00c..2c9d57cf8d533 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -2408,7 +2408,7 @@ static int gem_create_user_ext_set_property(struct xe_device *xe,
 	int err;
 	u32 idx;
 
-	err = __copy_from_user(&ext, address, sizeof(ext));
+	err = copy_from_user(&ext, address, sizeof(ext));
 	if (XE_IOCTL_DBG(xe, err))
 		return -EFAULT;
 
@@ -2445,7 +2445,7 @@ static int gem_create_user_extensions(struct xe_device *xe, struct xe_bo *bo,
 	if (XE_IOCTL_DBG(xe, ext_number >= MAX_USER_EXTENSIONS))
 		return -E2BIG;
 
-	err = __copy_from_user(&ext, address, sizeof(ext));
+	err = copy_from_user(&ext, address, sizeof(ext));
 	if (XE_IOCTL_DBG(xe, err))
 		return -EFAULT;
 
diff --git a/drivers/gpu/drm/xe/xe_eu_stall.c b/drivers/gpu/drm/xe/xe_eu_stall.c
index e2bb156c71fb0..96732613b4b7d 100644
--- a/drivers/gpu/drm/xe/xe_eu_stall.c
+++ b/drivers/gpu/drm/xe/xe_eu_stall.c
@@ -283,7 +283,7 @@ static int xe_eu_stall_user_ext_set_property(struct xe_device *xe, u64 extension
 	int err;
 	u32 idx;
 
-	err = __copy_from_user(&ext, address, sizeof(ext));
+	err = copy_from_user(&ext, address, sizeof(ext));
 	if (XE_IOCTL_DBG(xe, err))
 		return -EFAULT;
 
@@ -313,7 +313,7 @@ static int xe_eu_stall_user_extensions(struct xe_device *xe, u64 extension,
 	if (XE_IOCTL_DBG(xe, ext_number >= MAX_USER_EXTENSIONS))
 		return -E2BIG;
 
-	err = __copy_from_user(&ext, address, sizeof(ext));
+	err = copy_from_user(&ext, address, sizeof(ext));
 	if (XE_IOCTL_DBG(xe, err))
 		return -EFAULT;
 
diff --git a/drivers/gpu/drm/xe/xe_exec.c b/drivers/gpu/drm/xe/xe_exec.c
index b75adfc99fb7c..44364c042ad72 100644
--- a/drivers/gpu/drm/xe/xe_exec.c
+++ b/drivers/gpu/drm/xe/xe_exec.c
@@ -176,8 +176,8 @@ int xe_exec_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 	}
 
 	if (xe_exec_queue_is_parallel(q)) {
-		err = __copy_from_user(addresses, addresses_user, sizeof(u64) *
-				       q->width);
+		err = copy_from_user(addresses, addresses_user, sizeof(u64) *
+				     q->width);
 		if (err) {
 			err = -EFAULT;
 			goto err_syncs;
diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index cd9b1c32f30f8..ce78cee5dec68 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -479,7 +479,7 @@ static int exec_queue_user_ext_set_property(struct xe_device *xe,
 	int err;
 	u32 idx;
 
-	err = __copy_from_user(&ext, address, sizeof(ext));
+	err = copy_from_user(&ext, address, sizeof(ext));
 	if (XE_IOCTL_DBG(xe, err))
 		return -EFAULT;
 
@@ -518,7 +518,7 @@ static int exec_queue_user_extensions(struct xe_device *xe, struct xe_exec_queue
 	if (XE_IOCTL_DBG(xe, ext_number >= MAX_USER_EXTENSIONS))
 		return -E2BIG;
 
-	err = __copy_from_user(&ext, address, sizeof(ext));
+	err = copy_from_user(&ext, address, sizeof(ext));
 	if (XE_IOCTL_DBG(xe, err))
 		return -EFAULT;
 
@@ -618,9 +618,8 @@ int xe_exec_queue_create_ioctl(struct drm_device *dev, void *data,
 	if (XE_IOCTL_DBG(xe, !len || len > XE_HW_ENGINE_MAX_INSTANCE))
 		return -EINVAL;
 
-	err = __copy_from_user(eci, user_eci,
-			       sizeof(struct drm_xe_engine_class_instance) *
-			       len);
+	err = copy_from_user(eci, user_eci,
+			     sizeof(struct drm_xe_engine_class_instance) * len);
 	if (XE_IOCTL_DBG(xe, err))
 		return -EFAULT;
 
diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 7ffc98f67e696..777ec6613abda 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1301,7 +1301,7 @@ static int xe_oa_user_ext_set_property(struct xe_oa *oa, enum xe_oa_user_extn_fr
 	int err;
 	u32 idx;
 
-	err = __copy_from_user(&ext, address, sizeof(ext));
+	err = copy_from_user(&ext, address, sizeof(ext));
 	if (XE_IOCTL_DBG(oa->xe, err))
 		return -EFAULT;
 
@@ -1338,7 +1338,7 @@ static int xe_oa_user_extensions(struct xe_oa *oa, enum xe_oa_user_extn_from fro
 	if (XE_IOCTL_DBG(oa->xe, ext_number >= MAX_USER_EXTENSIONS))
 		return -E2BIG;
 
-	err = __copy_from_user(&ext, address, sizeof(ext));
+	err = copy_from_user(&ext, address, sizeof(ext));
 	if (XE_IOCTL_DBG(oa->xe, err))
 		return -EFAULT;
 
@@ -2280,7 +2280,7 @@ int xe_oa_add_config_ioctl(struct drm_device *dev, u64 data, struct drm_file *fi
 		return -EACCES;
 	}
 
-	err = __copy_from_user(&param, u64_to_user_ptr(data), sizeof(param));
+	err = copy_from_user(&param, u64_to_user_ptr(data), sizeof(param));
 	if (XE_IOCTL_DBG(oa->xe, err))
 		return -EFAULT;
 
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 737172013a8f9..cc1ae8ba9bb75 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3087,9 +3087,9 @@ static int vm_bind_ioctl_check_args(struct xe_device *xe, struct xe_vm *vm,
 		if (!*bind_ops)
 			return args->num_binds > 1 ? -ENOBUFS : -ENOMEM;
 
-		err = __copy_from_user(*bind_ops, bind_user,
-				       sizeof(struct drm_xe_vm_bind_op) *
-				       args->num_binds);
+		err = copy_from_user(*bind_ops, bind_user,
+				     sizeof(struct drm_xe_vm_bind_op) *
+				     args->num_binds);
 		if (XE_IOCTL_DBG(xe, err)) {
 			err = -EFAULT;
 			goto free_bind_ops;
-- 
2.39.5



