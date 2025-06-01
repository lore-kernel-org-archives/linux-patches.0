Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8318B2676EB;
	Sun,  1 Jun 2025 23:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820388; cv=none; b=AO35y8Sjjfl8Ds7iBWmLe3EauZ7TVWC7F6mOkALR0ZMTQea2NirEwqn/jY16Sqthmzbl/XID97CvrPTW9CUkIAgfRTN3/i0nnxwMX2vWssCE+HCC2ZpoEpA/l3/WUDDkpGaPeFz0VrHFIelKKINgCVfLeWq+LpKsNywiVgB49u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820388; c=relaxed/simple;
	bh=TT6US+podrL8toDs7wcxXOuqs/KcaDkND/yo1P2ki8M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WA3rDi9Duka1nbodW7xYwjidqMHkHFWDrtYrEP0/unRESMT1cfOJl3lRNRQ2aql0a5gWSfNQODTYq05u3zlPdeqaxh1al+k6QVTlvJ/Sm36/CR53wGFQBNnnosdnvdmspWUb7SImZO8t0Rma9xMIOV2Bm/Nd1RKlpJ5Q8/S8DeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tgl0e46u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tgl0e46u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA08C4CEF3;
	Sun,  1 Jun 2025 23:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820388;
	bh=TT6US+podrL8toDs7wcxXOuqs/KcaDkND/yo1P2ki8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tgl0e46uuJ6rGP4JnC9miQ2kkEdBi2i9lbV3Z34QiRXukNXk00nsK1PdWvT8Uz3nC
	 SerimmoUL2+S0T9CEMeIS935UyAehTveiBzVkK57j5ypY9iVCEUC/1hGMam9/H3IOf
	 q3fEgYZ3fmwwbyC1cdvvs+EC1ebTcd1KGTAKv3T8+MSofcsMRMJpa/0gP+KxIBfYEJ
	 BNVJ11+TlGH1jDlO6JxTyXUNQ9qIgRuI3HwJqYJlP0UFwraa42n/vl5Fs6r2BJfO7d
	 ifIdXvdBN70i9Mb7A5jEB7mc30fH5I20sD+cIIOxR6zVnFoXMt6x0tugs8QcGh838A
	 +2Riz0us2mfnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Harish Chegondi <harish.chegondi@intel.com>,
	Kees Cook <kees@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 044/110] drm/xe: Use copy_from_user() instead of __copy_from_user()
Date: Sun,  1 Jun 2025 19:23:26 -0400
Message-Id: <20250601232435.3507697-44-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232435.3507697-1-sashal@kernel.org>
References: <20250601232435.3507697-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

**YES** This commit should be backported to stable kernel trees for the
following reasons: **Security Hardening:** - The commit replaces
`__copy_from_user()` with `copy_from_user()` across multiple user-kernel
boundary points in the xe driver - `copy_from_user()` includes
additional safety checks (like `access_ok()` validation) that
`__copy_from_user()` lacks - This change was suggested by Kees Cook, a
prominent kernel security maintainer, indicating its security importance
**Risk Assessment:** - **Low risk of regression**: The change is purely
substituting one copy function for another with identical return
semantics - **No functional changes**: Both functions return the same
error codes and handle data the same way - **Contained scope**: Only
affects the xe driver, limiting potential impact - **Small and
focused**: Simple function substitution across 10 call sites in 6 files
**Historical Precedent:** - Similar security hardening commits in the
DRM subsystem have been backported (commits #3 and #5 in the examples) -
Both historical YES commits involved improving security around user-
kernel data copying operations - The pattern of hardening copy
operations is consistent with stable tree acceptance criteria
**Practical Benefits:** - Improves security posture by adding proper
address validation checks - Prevents potential security vulnerabilities
related to invalid user space addresses - Follows kernel security best
practices for user space data access **Stable Tree Criteria
Compliance:** - ✅ **Important security improvement**: Hardens user-
kernel interface - ✅ **Small and contained**: Limited to function
substitution - ✅ **Low regression risk**: Identical functionality with
added safety - ✅ **Clear benefit**: Enhanced security validation - ✅
**No architectural changes**: Pure function replacement The commit
represents a security hardening improvement that enhances the robustness
of user-kernel data copying in the xe driver without introducing
functional changes or significant regression risk, making it an ideal
candidate for stable tree backporting.

 drivers/gpu/drm/xe/xe_bo.c         | 4 ++--
 drivers/gpu/drm/xe/xe_eu_stall.c   | 4 ++--
 drivers/gpu/drm/xe/xe_exec.c       | 4 ++--
 drivers/gpu/drm/xe/xe_exec_queue.c | 9 ++++-----
 drivers/gpu/drm/xe/xe_oa.c         | 6 +++---
 drivers/gpu/drm/xe/xe_vm.c         | 6 +++---
 6 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 64f9c936eea06..507d0cf91c3b7 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -2398,7 +2398,7 @@ static int gem_create_user_ext_set_property(struct xe_device *xe,
 	int err;
 	u32 idx;
 
-	err = __copy_from_user(&ext, address, sizeof(ext));
+	err = copy_from_user(&ext, address, sizeof(ext));
 	if (XE_IOCTL_DBG(xe, err))
 		return -EFAULT;
 
@@ -2435,7 +2435,7 @@ static int gem_create_user_extensions(struct xe_device *xe, struct xe_bo *bo,
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
index 367c84b90e9ef..30242a41d7f6a 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3082,9 +3082,9 @@ static int vm_bind_ioctl_check_args(struct xe_device *xe, struct xe_vm *vm,
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

