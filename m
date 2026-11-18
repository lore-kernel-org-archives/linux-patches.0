Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047436;
	b=dyzxVwCVXV7grk/eJy2K//yDntlo8hmgVzHiD270YPugXwhauO7F3rc/wfLEsjaPtsRC
	 CZxHjpdbTAoL1eK4JfetpBXlRumsgJJLEcXCvptCPfTVt5me8k/745qe0vkADDX+N6eht
	 kQX7i26CETZvUDQA6uBntGFg6dtLG5clNP10zCMNAwLYnc8bzVnQ6lg74NPpVDUHAfLHM
	 D+NcZ6hCWowBF3i49aamR7uFcCuGEY06eKiOSCVl+6DxMZN1PVqTchtN4kK2Ljuf8MaDB
	 TwMuZd75BtkMnAam0kILmhzFR57JNcu2LVAOM80infPTVI6QDYNCCNGM5dkrN3GDdDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=D4wJYihkqbTfZlahw4Q0SRjxU+enkHwy4QXZ16Mh13k=;
	b=bYL3xUsauNkgB4so70KrZzb4GdNW8Vkvz1dOtE08emr8PCsUQ2eOHTaw6SpTU+7ti7kL
	 5VEGRLn4S7AYC4pDziOT7CybYXVjG2LRXx3krNByoQ+DTRzu6zpzFOT+OfGv6SfXARWj6
	 lq9CEXzQnKt2CaauEmZQMvvUJOJimPcgl/YVjGm0nRehFSy9tx1LZi0D8DvZFOGz4ZSbd
	 2D/WiATyWLAidAfFSq134Eb8n5pHuSfH96jVQVmhzr9uj6dFaMK6AClvnPqGY1wFJMVvM
	 9d2ax/GGk7kY0QDyNEP3g/gp9sDC61h3AALS8ScAiYo4wr8as9NffSEvg6j6ltFKqmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0OVyVnD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991FF606A31C;
	Thu, 19 Nov 2026 00:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0OVyVnD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA47A1F000C4;
	Thu, 19 Nov 2026 00:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047436;
	bh=D4wJYihkqbTfZlahw4Q0SRjxU+enkHwy4QXZ16Mh13k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0OVyVnDBWHVOPyEmn2UuzMDlz2jkuyCQlqXXf4YlOFaJ7jridg6NL4Yyw7fmMLN+
	 PFmNTFlxV7ux/avx45WIyeGRw9ddkgG97CCWZl+veBwPuj/Lf+C31VK4c0gsjEbAzT
	 JnHoW8lPC1llBR0fe/tbdzfk5Ciwu7DoVutX/9eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1636/2857] drm/amdgpu: drop the gang leader reference when freeing gang jobs
Date: Wed, 18 Nov 2026 15:44:30 +0100
Message-ID: <20261118150300.243663079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit c1584e10a7deb655438f21867b2b7a356a9aaf9f ]

Every job of a gang except the leader holds a reference to the
scheduled fence of the leader in job->gang_submit. Only
amdgpu_job_free(), used for jobs which never ran, drops it, so for every
gang submission which completes the scheduler fence of the leader, and
with it its hardware fence, is leaked. amdgpu_job_free() in turn checks
for the leader only after drm_sched_job_cleanup() cleared the scheduler
fence, so a leader freed there drops a reference it never took.

On navi31, 100 submissions of a GFX + COMPUTE gang grow the slab cache
drm_sched_fence is merged into by 60 to 180 objects each time, while
100 GFX only submissions don't.

Use amdgpu_job_free() for the jobs the scheduler frees too, and check
for the gang leader there before drm_sched_job_cleanup() clears the
scheduler fence. As the scheduler clears the entity of the jobs it
picked up, check for the scheduler fence instead to tell whether the job
needs cleaning up.

Keep freeing the remaining IBs with amdgpu_job_free_resources() after
drm_sched_job_cleanup(), so that it frees them with the hardware fence or
right away and not with the scheduler fence, which nobody signals for
jobs aborted after drm_sched_job_arm(), like a CS returning -EAGAIN.

v2: unify amdgpu_job_free() and amdgpu_job_free_cb() (Christian), don't
    free the remaining IBs with the scheduler fence
v3: drop the comments (Christian)
v4: free the IBs with amdgpu_job_free_resources() again (Christian)

Fixes: 68ce8b242242 ("drm/amdgpu: add gang submit backend v2")
Fixes: f7d66fb2ea43 ("drm/amdgpu: cleanup scheduler job initialization v2")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit df4d6d404d44bbc8fc850bc7f9f136a25dabf180)
Cc: stable@vger.kernel.org
[ sashal: Adapted job cleanup to use sync and sched_sync while preserving the embedded hardware fence’s ownership model. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index d321db549a1e0..00e632e45f656 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -179,18 +179,7 @@ void amdgpu_job_free_resources(struct amdgpu_job *job)
 
 static void amdgpu_job_free_cb(struct drm_sched_job *s_job)
 {
-	struct amdgpu_job *job = to_amdgpu_job(s_job);
-
-	drm_sched_job_cleanup(s_job);
-
-	amdgpu_sync_free(&job->sync);
-	amdgpu_sync_free(&job->sched_sync);
-
-	/* only put the hw fence if has embedded fence */
-	if (!job->hw_fence.ops)
-		kfree(job);
-	else
-		dma_fence_put(&job->hw_fence);
+	amdgpu_job_free(to_amdgpu_job(s_job));
 }
 
 void amdgpu_job_set_gang_leader(struct amdgpu_job *job,
@@ -211,14 +200,15 @@ void amdgpu_job_set_gang_leader(struct amdgpu_job *job,
 
 void amdgpu_job_free(struct amdgpu_job *job)
 {
-	if (job->base.entity)
+	if (job->gang_submit != &job->base.s_fence->scheduled)
+		dma_fence_put(job->gang_submit);
+
+	if (job->base.s_fence)
 		drm_sched_job_cleanup(&job->base);
 
 	amdgpu_job_free_resources(job);
 	amdgpu_sync_free(&job->sync);
 	amdgpu_sync_free(&job->sched_sync);
-	if (job->gang_submit != &job->base.s_fence->scheduled)
-		dma_fence_put(job->gang_submit);
 
 	if (!job->hw_fence.ops)
 		kfree(job);
-- 
2.53.0



