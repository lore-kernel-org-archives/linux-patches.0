Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028541;
	b=MRSjEfyFLtt3E0HAjB04BI/gMnL3aapzzos0ntvAfZi5PdAV634WgZV+t0awuh3THxuQ
	 JgjXmJbagx12ZBeOVrlyFrSF2sXqRoevctNVZf+EhgIw5XW4wKNhDJkajO1I193Z8J5n1
	 CazOnCtQRPR8dLtv6VK0WU0jY3ySB1VRPC/VwpqkWJSGbYEslZbmPJ4/J1q/AR+9sfnSX
	 joNLURLsyvnhySJLXSCw5x94GfkiV4fJLBbJIbw1Xpd4E/QOLZnfKA2VSav+hpoQX1BM3
	 ufj4sT5bH2aGhgTm7VXoDhPGv6pNYSUI3qUrVlubJrgcTfYt5JfdOcUJr742jkQiE7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=USwK2v6sYuvKKBzE/eWG31USYjKd1RG1Y1HCb8jg9eg=;
	b=KGpeamtkBug+C57gZQK9J1ky0T8CUaDr08CguaVjD2dELZTFc03/qH9RqMyzYMLOPmUe
	 Ci1xRK4UfYBqidcUYDuUP1f3ljSoUrsaiR1wdFzxJoZuS7qP8SDpfxvy5cjxAeGPX28u4
	 LlsEYaxfBpwUZMLDGaZ/Qj17hzZ1slMQrzaNS7zT9wqgiCszmGcIqxlKbAuzCz+lV+Z7k
	 D7PO2WCAh4tOCN6Hw7z1A1eYmU7NMR/BO9OTsmDXz4BPXrA78yfE0RMgqxY/JruKyQwu2
	 aDeVj1mGCJpQp/tTuYksgvNkwdkOxBw0QZu35ZoqFNGUunDnUq/mxnMc50YA091T4FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kZqZbzLf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECF6606A320;
	Wed, 18 Nov 2026 19:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kZqZbzLf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB02F1F000C4;
	Wed, 18 Nov 2026 19:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028541;
	bh=USwK2v6sYuvKKBzE/eWG31USYjKd1RG1Y1HCb8jg9eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZqZbzLfXvkRB8hRTNGBPeTH/z2yQX4sFWWWIGGP2U4xFL46ZyYzoKbFqE6fZXXxQ
	 LWDdp7iFBsiM8/5mTgoOGGjBmHf9ycTbpbSCL1Pk9N26+iEjWpG27bWuz/TQ5Cj545
	 fjHPIvAOSCeTJOQS6G8S43xZfPW2jHxir01PeD0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0033/1756] drm/amdgpu: drop the gang leader reference when freeing gang jobs
Date: Wed, 18 Nov 2026 15:36:00 +0100
Message-ID: <20261118150009.179615023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted cleanup context for an embedded hw_fence instead of separately allocated hardware and VM fences ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 0abc38bb242ca..348a38ee36bb4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -274,17 +274,7 @@ void amdgpu_job_free_resources(struct amdgpu_job *job)
 
 static void amdgpu_job_free_cb(struct drm_sched_job *s_job)
 {
-	struct amdgpu_job *job = to_amdgpu_job(s_job);
-
-	drm_sched_job_cleanup(s_job);
-
-	amdgpu_sync_free(&job->explicit_sync);
-
-	/* only put the hw fence if has embedded fence */
-	if (!job->hw_fence.base.ops)
-		kfree(job);
-	else
-		dma_fence_put(&job->hw_fence.base);
+	amdgpu_job_free(to_amdgpu_job(s_job));
 }
 
 void amdgpu_job_set_gang_leader(struct amdgpu_job *job,
@@ -305,13 +295,14 @@ void amdgpu_job_set_gang_leader(struct amdgpu_job *job,
 
 void amdgpu_job_free(struct amdgpu_job *job)
 {
-	if (job->base.entity)
+	if (job->gang_submit != &job->base.s_fence->scheduled)
+		dma_fence_put(job->gang_submit);
+
+	if (job->base.s_fence)
 		drm_sched_job_cleanup(&job->base);
 
 	amdgpu_job_free_resources(job);
 	amdgpu_sync_free(&job->explicit_sync);
-	if (job->gang_submit != &job->base.s_fence->scheduled)
-		dma_fence_put(job->gang_submit);
 
 	if (!job->hw_fence.base.ops)
 		kfree(job);
-- 
2.53.0



