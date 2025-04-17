Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878972571BE;
	Thu, 17 Apr 2025 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912443; cv=none; b=aYQNd0f0EAr1Aj/0yg28ZGsmNkVgxAvTSFNda/FWdTeDO3prQzespWb+IE/VzD0rLJe2/PZpEUELznTmImgEElGCTL2pU0MwceifHM7WGkTjthAy9JoLSvsLAnx0jv51tJQNIZbhAE8LKJbtURHdTrNJAztHlveN1PL7NaZrkRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912443; c=relaxed/simple;
	bh=N4hCDTNesplZRI4o0oa3XMdHJVy0m9fFx4ny0bmT1Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+l1PMRD5ob9wNSv3nZFMjqld7tLPX7QJdxtPeNTtubFvZ4LFlOnzydvYJwYia2DL/QahzBs1+4/RVBTAJMgf+VBw9UAcO1HCAwOjhWYCnsAcenBOuBTZunPU31lxo0whTrZc8QMr1/HINdWstgo5RzZXlwFkktDm9fwCTKmy28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqkIs5rT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqkIs5rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF23DC4CEE4;
	Thu, 17 Apr 2025 17:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912443;
	bh=N4hCDTNesplZRI4o0oa3XMdHJVy0m9fFx4ny0bmT1Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqkIs5rTgkmvSrLHGg26+0Xq9dWJ/lqb0bIJ0iptKkyNe4puvvx2mxSXojTwbYhje
	 7s+V+iPUtbgH0OdaXbUrOsgqKfSN5MBfvt8nxd9k6iflaCaA4n6EGi83uEy6jWdQfA
	 KN8zDjZA3NtM2OM+GP9xtrG5n/vGlOpEw6puMKZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 013/449] drm/xe/hw_engine: define sysfs_ops on all directories
Date: Thu, 17 Apr 2025 19:45:01 +0200
Message-ID: <20250417175118.524244591@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit a5c71fd5b69b9da77e5e0b268e69e256932ba49c ]

Sysfs_ops needs to be defined on all directories which
can have attr files with set/get method. Add sysfs_ops
to even those directories which is currently empty but
would have attr files with set/get method in future.
Leave .default with default sysfs_ops as it will never
have setter method.

V2(Himal/Rodrigo):
 - use single sysfs_ops for all dir and attr with set/get
 - add default ops as ./default does not need runtime pm at all

Fixes: 3f0e14651ab0 ("drm/xe: Runtime PM wake on every sysfs call")
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250327122647.886637-1-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 40780b9760b561e093508d07b8b9b06c94ab201e)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c | 108 +++++++++---------
 1 file changed, 52 insertions(+), 56 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c b/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c
index b53e8d2accdbd..a440442b4d727 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c
@@ -32,14 +32,61 @@ bool xe_hw_engine_timeout_in_range(u64 timeout, u64 min, u64 max)
 	return timeout >= min && timeout <= max;
 }
 
-static void kobj_xe_hw_engine_release(struct kobject *kobj)
+static void xe_hw_engine_sysfs_kobj_release(struct kobject *kobj)
 {
 	kfree(kobj);
 }
 
+static ssize_t xe_hw_engine_class_sysfs_attr_show(struct kobject *kobj,
+						  struct attribute *attr,
+						  char *buf)
+{
+	struct xe_device *xe = kobj_to_xe(kobj);
+	struct kobj_attribute *kattr;
+	ssize_t ret = -EIO;
+
+	kattr = container_of(attr, struct kobj_attribute, attr);
+	if (kattr->show) {
+		xe_pm_runtime_get(xe);
+		ret = kattr->show(kobj, kattr, buf);
+		xe_pm_runtime_put(xe);
+	}
+
+	return ret;
+}
+
+static ssize_t xe_hw_engine_class_sysfs_attr_store(struct kobject *kobj,
+						   struct attribute *attr,
+						   const char *buf,
+						   size_t count)
+{
+	struct xe_device *xe = kobj_to_xe(kobj);
+	struct kobj_attribute *kattr;
+	ssize_t ret = -EIO;
+
+	kattr = container_of(attr, struct kobj_attribute, attr);
+	if (kattr->store) {
+		xe_pm_runtime_get(xe);
+		ret = kattr->store(kobj, kattr, buf, count);
+		xe_pm_runtime_put(xe);
+	}
+
+	return ret;
+}
+
+static const struct sysfs_ops xe_hw_engine_class_sysfs_ops = {
+	.show = xe_hw_engine_class_sysfs_attr_show,
+	.store = xe_hw_engine_class_sysfs_attr_store,
+};
+
 static const struct kobj_type kobj_xe_hw_engine_type = {
-	.release = kobj_xe_hw_engine_release,
-	.sysfs_ops = &kobj_sysfs_ops
+	.release = xe_hw_engine_sysfs_kobj_release,
+	.sysfs_ops = &xe_hw_engine_class_sysfs_ops,
+};
+
+static const struct kobj_type kobj_xe_hw_engine_type_def = {
+	.release = xe_hw_engine_sysfs_kobj_release,
+	.sysfs_ops = &kobj_sysfs_ops,
 };
 
 static ssize_t job_timeout_max_store(struct kobject *kobj,
@@ -543,7 +590,7 @@ static int xe_add_hw_engine_class_defaults(struct xe_device *xe,
 	if (!kobj)
 		return -ENOMEM;
 
-	kobject_init(kobj, &kobj_xe_hw_engine_type);
+	kobject_init(kobj, &kobj_xe_hw_engine_type_def);
 	err = kobject_add(kobj, parent, "%s", ".defaults");
 	if (err)
 		goto err_object;
@@ -559,57 +606,6 @@ static int xe_add_hw_engine_class_defaults(struct xe_device *xe,
 	return err;
 }
 
-static void xe_hw_engine_sysfs_kobj_release(struct kobject *kobj)
-{
-	kfree(kobj);
-}
-
-static ssize_t xe_hw_engine_class_sysfs_attr_show(struct kobject *kobj,
-						  struct attribute *attr,
-						  char *buf)
-{
-	struct xe_device *xe = kobj_to_xe(kobj);
-	struct kobj_attribute *kattr;
-	ssize_t ret = -EIO;
-
-	kattr = container_of(attr, struct kobj_attribute, attr);
-	if (kattr->show) {
-		xe_pm_runtime_get(xe);
-		ret = kattr->show(kobj, kattr, buf);
-		xe_pm_runtime_put(xe);
-	}
-
-	return ret;
-}
-
-static ssize_t xe_hw_engine_class_sysfs_attr_store(struct kobject *kobj,
-						   struct attribute *attr,
-						   const char *buf,
-						   size_t count)
-{
-	struct xe_device *xe = kobj_to_xe(kobj);
-	struct kobj_attribute *kattr;
-	ssize_t ret = -EIO;
-
-	kattr = container_of(attr, struct kobj_attribute, attr);
-	if (kattr->store) {
-		xe_pm_runtime_get(xe);
-		ret = kattr->store(kobj, kattr, buf, count);
-		xe_pm_runtime_put(xe);
-	}
-
-	return ret;
-}
-
-static const struct sysfs_ops xe_hw_engine_class_sysfs_ops = {
-	.show = xe_hw_engine_class_sysfs_attr_show,
-	.store = xe_hw_engine_class_sysfs_attr_store,
-};
-
-static const struct kobj_type xe_hw_engine_sysfs_kobj_type = {
-	.release = xe_hw_engine_sysfs_kobj_release,
-	.sysfs_ops = &xe_hw_engine_class_sysfs_ops,
-};
 
 static void hw_engine_class_sysfs_fini(void *arg)
 {
@@ -640,7 +636,7 @@ int xe_hw_engine_class_sysfs_init(struct xe_gt *gt)
 	if (!kobj)
 		return -ENOMEM;
 
-	kobject_init(kobj, &xe_hw_engine_sysfs_kobj_type);
+	kobject_init(kobj, &kobj_xe_hw_engine_type);
 
 	err = kobject_add(kobj, gt->sysfs, "engines");
 	if (err)
-- 
2.39.5



