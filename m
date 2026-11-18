Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038840;
	b=WnnlnxW/7Wf+gmHNGNU3vd5XeFqcp5K3JxTHpYWJ2Dhsd885JAxgM7RzoJPZTzmhgReU
	 G7aJxhp+Rg+jn3S8U5yDqHvKZldea1g/wMqJB2b0zsaF9ozFmGyNjW2b1XSGWBmQWAHUt
	 MT8WY0WRzcPZPaWTrwkXHkSdJsmEgiR1PIbHsv5ZD/09dXwyenEdEIYJrGiQVf59IOXMT
	 AG2AIcWTEasbp4+iLq7KwjM2ya1rR1Q16AzshcKpjRy5yMin8THuWCKVT1fk4Yk45qb/+
	 Ipl3X+EpNgCWLrg1SXgmtPAuevJUX07+gya/bOFb7RXjkipd5wxml4AResKO2cyOEYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=g6KTuWnOL7duEkSERVaJY8Dr6IkB/OkLJVZ295Uxm4Q=;
	b=qatwH28h3wt3KAag1EtRNIuth5YoZjt//x5xLBsbdmprwUfZYFzEKdsC84/+RVmXksoA
	 DMOzVZOPhuTqfnuxTcsoy6FT7eyKfn6s/quioFYFn5ypO4ZtmPkJeAQ5Bz6IrxkQqRX4+
	 Vy8uIPpBEvJApf9Qi87rxRm08hR4oQhxYST3b0BTsSvRTw0oTP0i05PLZ2PtrjHzcVFxy
	 C30No1FxaR6n8waCm+nDakKSXqj+JN2jRGaDYWCdmjp9tNAMK9l1Njkz7GVG3vi/ZzylA
	 vUyXMSypNkNRkM6Pn9p0uogqdtArfjZ3KWI6T0nM3MUjcbuFo0WFMtxiUtXzIRn/vHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLQuRO07;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DEF606A31C;
	Wed, 18 Nov 2026 21:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLQuRO07
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0BB1F000C4;
	Wed, 18 Nov 2026 21:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038840;
	bh=g6KTuWnOL7duEkSERVaJY8Dr6IkB/OkLJVZ295Uxm4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLQuRO07wm4Hxbf+myrHot+JTQumvWhdc/ebny3lDnd2HWJOTW6dRrzcdOE93WKaR
	 xFj2I/ZJ5ALTIRHGw8AdG/rnz1ukni6RRce48mXEwkoSZ8vbp8eYAb48mez4/DXL6y
	 qTXzJbhLFoq8ChMUHFL4UVfG7T6N4ZA5ZeRz4hKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1887/3318] drm/amdgpu: drop the gang leader reference when freeing gang jobs
Date: Wed, 18 Nov 2026 15:41:49 +0100
Message-ID: <20261118150418.603012918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted cleanup context for an embedded hw_fence using base.ops to check initialization ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 56eb3aa1d9d3e..b03860f23c70c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -181,17 +181,7 @@ void amdgpu_job_free_resources(struct amdgpu_job *job)
 
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
@@ -212,13 +202,14 @@ void amdgpu_job_set_gang_leader(struct amdgpu_job *job,
 
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



