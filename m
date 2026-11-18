Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059879;
	b=XQ8UOGLi4l/LhoJRn7bELsS1Ba9kS/reX1UQo9JfdXJGKxg1hpgw4QjJQ4zv+pk8sxcc
	 gHjplXWwlbO//CQqZalmcZiej51/g8niA1Z6Na49k6TsoCMkZnq4UMstDBAIFTsIpG70g
	 TUbDD3VLq8dRSZzt8ct9UivYj7fP1MxWJMVkhsYEAklnhj9c2P8aVenG/VE58rXmTpESg
	 ExK7TeksY2mTtoxW1rU+esUdzmX3o9psAWrE7agjzD3d3AtAtXpB5Xaky0NKMQ5V7zYsH
	 zuyn3UnhglFimnYeuTrGKepXBcMfcACVzjnY56MxLUl4gPIC315anJ7AZrmellOjrSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bOvoOBYgag62zoSVt2mVI/vFk72JwwAIJcxmgSfLFlI=;
	b=l7fhqe9AOtYr1XhXx3Mt3vv4VQfMFUlfL96xJKmCIEbPIc5qNIwD6f75LOfWpRH2zVVW
	 cyA5lXNoXJKHX7aBdF7HD6+5bcqX/T7Z6frEZ9kgqJXi2haFFWGDiqUv+5Cdq9MiDDGuD
	 MjT799YlF0TjksvUa2WuCmrfa5I8WEyruc/2gTgmWb7pekin0/NVLvP3/ytq6FzJ4J6Wt
	 eHYQ+CCGmLh9Sh7d73xBihkosDNnym4x8AZvsYwBXO8ZrpKPPGchArTzlo6DRvDs46feC
	 LIB6tEMv6KV7TheUmb7P9U2xXMqLs+MvksGtulhqFd19FCai9nNeUGXr/Z5CQS9GKNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KWhQtV9U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE77606A320;
	Thu, 19 Nov 2026 03:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KWhQtV9U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6397D1F000C4;
	Thu, 19 Nov 2026 03:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059879;
	bh=bOvoOBYgag62zoSVt2mVI/vFk72JwwAIJcxmgSfLFlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWhQtV9UNPFAeKzQHnFM+pQGBG5rdZK4b+D6imYK098pCJwMzcRzD8FBV+myoF8go
	 0XJFqRjSVok5gyNlq2gwfl057EHUuZlR776klEs3ZUjRP9riOKTe9vd1a6XPPRLDRj
	 FJi/zSHE1P3rnehqzwqgzdnBe1e4K+PCzC1OTJy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0999/1848] drm/amdkfd: stop restore retries on device unplug
Date: Wed, 18 Nov 2026 15:50:37 +0100
Message-ID: <20261118145958.646355172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted restore retry handling to the existing atomic eviction counter and delayed-work scheduling ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c    | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index a574c89193bc4..ca89abf0aca8d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1952,6 +1952,7 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 	struct task_struct *usertask;
 	struct mm_struct *mm;
 	int evicted_bos;
+	int ret;
 
 	evicted_bos = atomic_read(&process_info->evicted_bos);
 	if (!evicted_bos)
@@ -1969,7 +1970,8 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 
 	mutex_lock(&process_info->lock);
 
-	if (update_invalid_user_pages(process_info, mm))
+	ret = update_invalid_user_pages(process_info, mm);
+	if (ret)
 		goto unlock_out;
 	/* userptr_inval_list can be empty if all evicted userptr BOs
 	 * have been freed. In that case there is nothing to validate
@@ -1979,7 +1981,8 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
 		if (atomic_read(&process_info->evicted_bos) != evicted_bos)
 			goto unlock_out; /* Concurrent eviction, try again */
 
-		if (validate_invalid_user_pages(process_info))
+		ret = validate_invalid_user_pages(process_info);
+		if (ret)
 			goto unlock_out;
 	}
 	/* Final check for concurrent evicton and atomic update. If
@@ -1988,8 +1991,10 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
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
@@ -2003,8 +2008,10 @@ static void amdgpu_amdkfd_restore_userptr_worker(struct work_struct *work)
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
-- 
2.53.0



