Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054211;
	b=eaH8fmbS6rhzoexUAgBMtfA7/05HvCUFdo4B7Pl2Mo+2GBSI3DsELdoL8ejq+C4Z4vgn
	 9U7EzfB0ERnTB3J+lBKRW4+Pw9lV/X1T6PbtnK4lMmP41Uqb/XIDxU8jv15f66xoIA4X9
	 kQStLXRoL9MWOBuU6hwOfJM4IOUoX5yVTYvsqGhcRV6T/mZj014zIIidWRtV50G1C3+Wg
	 0+czgB0p0fzE7WL2jqwjnr+ZJ83YcafqallPJoGVwb2fi/T/LJ1UKa670RD4PcaJz2q5K
	 874uZKuFF1ZTf3AfQMxX3Gbd2mS9RFrgzu3CWvcxh6o5gF57BOlvb53d4xN42XwvWFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lcoGpjIPs0hOh7XQG7s9g1bDMdR7kaBVqIY/pxrdYYU=;
	b=CHBDx9iN+OLGspiHAbBoWV6ltsYWzhvjCU98otEZPPWp2lT6Xq+H+K3M0XimdHcXI683
	 tjNMntDuCxdC0uvrBwMUzfB8KSfqwH/uvGC7Mn8yFLUFzrpvLurhgVJyqPpnqcZfMnLqr
	 lMOIxaR/3l690DAdEdEZe4y+0+SvcUUrOZQ/YWF6HBqNBH4he9QlFiT5Lmi5OqvGPEJp6
	 pDVNOWODSv3AWWP1AwOy9hAmy55IQi0r2ncqSwbtUCMElz/z5/PEMnWaO2yQUppbn60N5
	 JrkwTacEjyvLBM/y33ypP+H7pwiZvxV/Uv9+bL/diopqC/1PqgPt4fBELMpeGy102Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxxez1FP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F656606A325;
	Thu, 19 Nov 2026 02:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxxez1FP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B2E1F000C9;
	Thu, 19 Nov 2026 02:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054211;
	bh=lcoGpjIPs0hOh7XQG7s9g1bDMdR7kaBVqIY/pxrdYYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxxez1FPe9BskZ/uinfNOOCpMIm9YMEF/ZSXf67ZVkcif6yG1FSX6HzEsSyFMWeJF
	 22uAI/z/MbLzoANk6zvU8IAYrJn+HW5R4L7wkEUdNbjywaOeX9cxtgoWKPoq2XTj7t
	 anm4yjGMhFH8UhnVQXFRvS849/utrlrTecBhFaVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1193/2214] drm/amdkfd: stop restore retries on device unplug
Date: Wed, 18 Nov 2026 15:47:49 +0100
Message-ID: <20261118150059.618524412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted notifier-locked retry handling to the existing atomic eviction counter checks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c    | 17 ++++++++++++-----
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c            |  8 +++++---
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 07aa9f8de2644..b89bcf84cfa9d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2188,6 +2188,7 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 	struct task_struct *usertask;
 	struct mm_struct *mm;
 	int evicted_bos;
+	int ret;
 
 	evicted_bos = atomic_read(&process_info->evicted_bos);
 	if (!evicted_bos)
@@ -2205,7 +2206,8 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 
 	mutex_lock(&process_info->lock);
 
-	if (update_invalid_user_pages(process_info, mm))
+	ret = update_invalid_user_pages(process_info, mm);
+	if (ret)
 		goto unlock_out;
 	/* userptr_inval_list can be empty if all evicted userptr BOs
 	 * have been freed. In that case there is nothing to validate
@@ -2215,7 +2217,8 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 		if (atomic_read(&process_info->evicted_bos) != evicted_bos)
 			goto unlock_out; /* Concurrent eviction, try again */
 
-		if (validate_invalid_user_pages(process_info))
+		ret = validate_invalid_user_pages(process_info);
+		if (ret)
 			goto unlock_out;
 	}
 	/* Final check for concurrent evicton and atomic update. If
@@ -2224,8 +2227,10 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 	 * reference counting inside KFD will handle this case.
 	 */
 	if (atomic_cmpxchg(&process_info->evicted_bos, evicted_bos, 0) !=
-	    evicted_bos)
+	    evicted_bos) {
+		ret = -EAGAIN;
 		goto unlock_out;
+	}
 	evicted_bos = 0;
 	if (kgd2kfd_resume_mm(mm)) {
 		pr_err("%s: Failed to resume KFD\n", __func__);
@@ -2239,8 +2244,10 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 	mmput(mm);
 	put_task_struct(usertask);
 
-	/* If validation failed, reschedule another attempt */
-	if (evicted_bos)
+	/* If validation failed, reschedule another attempt, unless the
+	 * device is gone for good
+	 */
+	if (evicted_bos && ret != -ENODEV)
 		schedule_delayed_work(&process_info->restore_userptr_work,
 			msecs_to_jiffies(AMDGPU_USERPTR_RESTORE_DELAY_MS));
 }
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index ff776944793a8..0b20ef89c4ad5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1575,7 +1575,7 @@ static void svm_range_restore_work(struct work_struct *work)
 	struct mm_struct *mm;
 	int evicted_ranges;
 	int invalid;
-	int r;
+	int r = 0;
 
 	svms = container_of(dwork, struct svm_range_list, restore_work);
 	evicted_ranges = atomic_read(&svms->evicted_ranges);
@@ -1645,8 +1645,10 @@ static void svm_range_restore_work(struct work_struct *work)
 	mutex_unlock(&svms->lock);
 	mmap_write_unlock(mm);
 
-	/* If validation failed, reschedule another attempt */
-	if (evicted_ranges) {
+	/* If validation failed, reschedule another attempt, unless the
+	 * device is gone for good
+	 */
+	if (evicted_ranges && r != -ENODEV) {
 		pr_debug("reschedule to restore svm range\n");
 		schedule_delayed_work(&svms->restore_work,
 			msecs_to_jiffies(AMDGPU_SVM_RANGE_RESTORE_DELAY_MS));
-- 
2.53.0



