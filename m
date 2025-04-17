Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F228462;
	Thu, 17 Apr 2025 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913806; cv=none; b=f1/DTDomKYz76EUkVvkQnCQXjVMTdIo/PWNHvGx+yjM0XPnS+adSMC3/0kQ4rKrNqFMHqF9gY+qikePHxK8VfaM1coHUcMOM2YayRnzKLPBetkuFUU9usf6fVCNy9IJhkFlSelSA3oiKPaWsTIqkMCQRHfGzAnzbndLIm7rw7Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913806; c=relaxed/simple;
	bh=uONf5Y46fZ5JZXnMWB0BVpgMlekOo2pZysDWMSvOEXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mus5m+u0xFeG1+LgARC7PxTv0/+W84a6Yz5lUQbnHVaDLled30XM9cPFafBtBOOAsO6F28c2mJ+aXRiW82ZegRFuBFjbqVFNABLpNNDh/5jsBcZSFmZKKC6pfF+Nf2MQpOUhVK24x2tezlSp4q7JQKgzhGIEVcDvpaUj9KCjXFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJUbgqhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJUbgqhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7E8C4CEE4;
	Thu, 17 Apr 2025 18:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913806;
	bh=uONf5Y46fZ5JZXnMWB0BVpgMlekOo2pZysDWMSvOEXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJUbgqhOiUEoerwSG760KB7iFEyTVSbz56JH4Iicm9wlWyoMzxpjAIkCQM0WA5JNs
	 NctMrqktp62MX3Dzkf2GSLS8cqRIYD0VvE/su5JRHZL79PJVCTvk6iDYfevQ25z3cZ
	 v5TPiGbC4YBDRzMqOUuzVQPCJNiZ7e8Vx1RkCqy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 010/414] drm/xe/hw_engine: define sysfs_ops on all directories
Date: Thu, 17 Apr 2025 19:46:08 +0200
Message-ID: <20250417175111.818227332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



