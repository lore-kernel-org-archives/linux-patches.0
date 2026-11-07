Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063712;
	b=MswbxD8tHlWFYXbG/UIN7VHzvJsKJ23zn/ZwFeguqryh0yYAGRUcIHvMMFduJV28qSZs
	 1apMJH9e9Vsv3D1u+E9ti1eS6bbAjRkfpen1t/9MEESAiI4y79IkVaPL6qkfLmcjhNRwn
	 EUeHioyen4VGEjEd4ltZfpFEl6bhUPkXCgnaPXAiRWCk3ZRUM8Ic01lNcg6rBUr2QDZQS
	 NwVoA2f1cFxIMP+T0IxW0mcVJaYK+xUjhGKnX3Fhra5HkkLKsh2D0a4FGXnCxwsjjH7sL
	 w7+wTdtDEdaIRBjJznbi1EnHDsfxiXKuiJ0DXMunTh5m6umAeCTKnv6dZY3EkjSKHbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d7OwJ4UfiAYvSiS13U7P90kdO+1V55hWPtzFgxp8Qkk=;
	b=TBSasbF+/VjM/YhkDQz7RmD9zoQs+qfV3w46jYYWlG975o5TaU8PuUKfiWNlKYRkjUpd
	 XaEMXhSOff4JUWns4rZXvxahlIwcGeVls3MloNxH7Z8oRF+oU0vyePWV+p7goyj/vVGXS
	 smP7lOtBW3/BHihxEBMUg3aWRpCUL30su32APVEj7x8fVKBhNyCkuFJfaP9HSusvtNYxx
	 jMcuJEDz9K0sPQZp8NDxgTf8GJkTStCVEPX6qmQjHpU6fJwWi7op2n0PzmTHevLmO+jVB
	 4flndFwwVUsfwtJPXdONzVEYHGmsMvJwwOrJ4gP0YOPz+3TDMcxme6D3LsHZvLcNqzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JsltKg5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E816B606B8AF;
	Sat,  7 Nov 2026 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JsltKg5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F9A1F0089F;
	Sat,  7 Nov 2026 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063711;
	bh=d7OwJ4UfiAYvSiS13U7P90kdO+1V55hWPtzFgxp8Qkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JsltKg530du1+1OnaE6HY1ksxt0iJV/YAF85Xo6sIP47mRyHU/b8nZWbxFLZL9xT
	 kN3qTdTku3yft619ldwwlmEX8cYrUOlhgdTPalYqvK9i9+eKl+mVqO7hfhuyGzHxHz
	 4nVGJhocDE3vAUAJtzAsilv45nng6IfqI2sMkcrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 813/869] drm/amdkfd: stop restore retries on device unplug
Date: Sat,  7 Nov 2026 08:58:15 -0500
Message-ID: <20261107134920.589322312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>

[ Upstream commit 3254ed0b15f2fe656c9cb36ccb59b92422440bf8 ]

amdgpu_amdkfd_restore_userptr_worker() and svm_range_restore_work()
reschedule themselves when validation fails with evicted objects
pending. After a surprise removal the restore paths fail with -ENODEV
permanently, so rescheduling just spins the worker uselessly until
cancel_delayed_work_sync() in fini finally stops it - which can take
a while, since process teardown itself is delayed by the dead device.

Treat -ENODEV as terminal in both workers.

Cc: Xiaogang Chen <xiaogang.chen@amd.com>
Signed-off-by: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 266fab83139600e58db7e900e930c722e619b78c)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   | 18 +++++++++++++-----
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c           |  8 +++++---
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 35dffb14a20aa..6de7dfa30ce50 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2824,6 +2824,7 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 	struct task_struct *usertask;
 	struct mm_struct *mm;
 	uint32_t evicted_bos;
+	int ret;
 
 	mutex_lock(&process_info->notifier_lock);
 	evicted_bos = process_info->evicted_bos;
@@ -2843,14 +2844,16 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 
 	mutex_lock(&process_info->lock);
 
-	if (update_invalid_user_pages(process_info, mm))
+	ret = update_invalid_user_pages(process_info, mm);
+	if (ret)
 		goto unlock_out;
 	/* userptr_inval_list can be empty if all evicted userptr BOs
 	 * have been freed. In that case there is nothing to validate
 	 * and we can just restart the queues.
 	 */
 	if (!list_empty(&process_info->userptr_inval_list)) {
-		if (validate_invalid_user_pages(process_info))
+		ret = validate_invalid_user_pages(process_info);
+		if (ret)
 			goto unlock_out;
 	}
 	/* Final check for concurrent evicton and atomic update. If
@@ -2859,11 +2862,14 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 	 * reference counting inside KFD will handle this case.
 	 */
 	mutex_lock(&process_info->notifier_lock);
-	if (process_info->evicted_bos != evicted_bos)
+	if (process_info->evicted_bos != evicted_bos) {
+		ret = -EAGAIN;
 		goto unlock_notifier_out;
+	}
 
 	if (confirm_valid_user_pages_locked(process_info)) {
 		WARN(1, "User pages unexpectedly invalid");
+		ret = -EINVAL;
 		goto unlock_notifier_out;
 	}
 
@@ -2881,8 +2887,10 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 unlock_out:
 	mutex_unlock(&process_info->lock);
 
-	/* If validation failed, reschedule another attempt */
-	if (evicted_bos) {
+	/* If validation failed, reschedule another attempt, unless the
+	 * device is gone for good
+	 */
+	if (evicted_bos && ret != -ENODEV) {
 		queue_delayed_work(system_freezable_wq,
 			&process_info->restore_userptr_work,
 			msecs_to_jiffies(AMDGPU_USERPTR_RESTORE_DELAY_MS));
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 1b29dee7948d8..366b31191ac1e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1853,7 +1853,7 @@ static void svm_range_restore_work(struct work_struct *work)
 	struct mm_struct *mm;
 	int evicted_ranges;
 	int invalid;
-	int r;
+	int r = 0;
 
 	svms = container_of(dwork, struct svm_range_list, restore_work);
 	evicted_ranges = atomic_read(&svms->evicted_ranges);
@@ -1927,8 +1927,10 @@ static void svm_range_restore_work(struct work_struct *work)
 	mmap_write_unlock(mm);
 	mutex_unlock(&process_info->lock);
 
-	/* If validation failed, reschedule another attempt */
-	if (evicted_ranges) {
+	/* If validation failed, reschedule another attempt, unless the
+	 * device is gone for good
+	 */
+	if (evicted_ranges && r != -ENODEV) {
 		pr_debug("reschedule to restore svm range\n");
 		queue_delayed_work(system_freezable_wq, &svms->restore_work,
 			msecs_to_jiffies(AMDGPU_SVM_RANGE_RESTORE_DELAY_MS));
-- 
2.53.0



