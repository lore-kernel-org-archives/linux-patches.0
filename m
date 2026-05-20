Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA2936494B;
	Wed, 20 May 2026 16:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294978; cv=none; b=eUd/8DULvsjpU52TSeZptkgMfRS9fW/N+evJOL/yq1/JwmYH/MTDTkcL4+aGfmiiOgljRD+AdO8I4R+bPQb5U08C17p5xapI3RLFnEY5UYlYIYns9PhBiKCfecxkDorYRjffe3xWdETZVVa3IsDKnTYf9Rr3FfNnI8bHfyme70Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294978; c=relaxed/simple;
	bh=XCEImX+KVOSEDUVVGhXOtBHBsjmQ3epfUiOHVp97eB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1PEH73DeStP4gFy+iGUfNNQvACAuM0WtUbm1ybGuYWo76KNFqGpGWoB6w/c35F6ieTtGXfSOaFHQZ3wZ2a4FMFjwJdXxyW2pH00Msj/1B5p4DCh92MhiI6f+MV2Sz5ayjHErojbHEPW/vC2zWkhwdtMMZg9EHUPFFwf9sS69f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0m5a8IZf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0m5a8IZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD6C1F000E9;
	Wed, 20 May 2026 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294976;
	bh=GUUofTw6DN4YzYrZXRJYvXHd29YIpHmXkNSs2hggrgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0m5a8IZf01rvDS9me4NmhIAjRDY/w94khxELdOyULoIR09/y1/NdchzqoeShn3ZvY
	 nYbhbRMOzto1b2WIMQt8hAv3/yf0ZnT90sLxggAYnXqF2qDB9NOItn5RDOq/yG4nEH
	 Ma+iL4qw9q36qbSPlz8/l4ZoeZ6QAi1LNX9XIKXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Martin <andrew.martin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0243/1146] drm/amdkfd: Removed commented line for MQD queue priority
Date: Wed, 20 May 2026 18:08:13 +0200
Message-ID: <20260520162153.739245482@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Martin <andrew.martin@amd.com>

[ Upstream commit bfe60e539cf7690a6739466b41fb6be250bb783e ]

Missed deleting the commented line in the original patch.

Fixes: 73463e26f7e2 ("drm/amdkfd: Disable MQD queue priority")
Signed-off-by: Andrew Martin <andrew.martin@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_cik.c   | 1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   | 1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c   | 1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c   | 1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c | 1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    | 1 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c    | 1 -
 7 files changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_cik.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_cik.c
index 562d475cf4c99..bb70e57ae4d52 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_cik.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_cik.c
@@ -70,7 +70,6 @@ static void update_cu_mask(struct mqd_manager *mm, void *mqd,
 static void set_priority(struct cik_mqd *m, struct queue_properties *q)
 {
 	m->cp_hqd_pipe_priority = pipe_priority_map[q->priority];
-	/* m->cp_hqd_queue_priority = q->priority; */
 }
 
 static struct kfd_mem_obj *allocate_mqd(struct mqd_manager *mm,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
index d6067316d7f49..77fb41e2486a4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -70,7 +70,6 @@ static void update_cu_mask(struct mqd_manager *mm, void *mqd,
 static void set_priority(struct v10_compute_mqd *m, struct queue_properties *q)
 {
 	m->cp_hqd_pipe_priority = pipe_priority_map[q->priority];
-	/* m->cp_hqd_queue_priority = q->priority; */
 }
 
 static struct kfd_mem_obj *allocate_mqd(struct mqd_manager *mm,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
index e3a7acb0ccbc8..a1e3cf2384dd3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -96,7 +96,6 @@ static void update_cu_mask(struct mqd_manager *mm, void *mqd,
 static void set_priority(struct v11_compute_mqd *m, struct queue_properties *q)
 {
 	m->cp_hqd_pipe_priority = pipe_priority_map[q->priority];
-	/* m->cp_hqd_queue_priority = q->priority; */
 }
 
 static struct kfd_mem_obj *allocate_mqd(struct mqd_manager *mm,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
index 0b97376fc6f9f..b3e122d7876e0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
@@ -77,7 +77,6 @@ static void update_cu_mask(struct mqd_manager *mm, void *mqd,
 static void set_priority(struct v12_compute_mqd *m, struct queue_properties *q)
 {
 	m->cp_hqd_pipe_priority = pipe_priority_map[q->priority];
-	/* m->cp_hqd_queue_priority = q->priority; */
 }
 
 static struct kfd_mem_obj *allocate_mqd(struct mqd_manager *mm,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
index eef6bdce4be39..c90c0d99b1e3f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
@@ -131,7 +131,6 @@ static void update_cu_mask(struct mqd_manager *mm, void *mqd,
 static void set_priority(struct v12_1_compute_mqd *m, struct queue_properties *q)
 {
 	m->cp_hqd_pipe_priority = pipe_priority_map[q->priority];
-	/* m->cp_hqd_queue_priority = q->priority; */
 }
 
 static struct kfd_mem_obj *allocate_mqd(struct mqd_manager *mm,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index a535f151cb5fd..e856bee628058 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -113,7 +113,6 @@ static void update_cu_mask(struct mqd_manager *mm, void *mqd,
 static void set_priority(struct v9_mqd *m, struct queue_properties *q)
 {
 	m->cp_hqd_pipe_priority = pipe_priority_map[q->priority];
-	/* m->cp_hqd_queue_priority = q->priority; */
 }
 
 static bool mqd_on_vram(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
index 69c1b8a690b86..f02ef2d44a07f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -73,7 +73,6 @@ static void update_cu_mask(struct mqd_manager *mm, void *mqd,
 static void set_priority(struct vi_mqd *m, struct queue_properties *q)
 {
 	m->cp_hqd_pipe_priority = pipe_priority_map[q->priority];
-	/* m->cp_hqd_queue_priority = q->priority; */
 }
 
 static struct kfd_mem_obj *allocate_mqd(struct mqd_manager *mm,
-- 
2.53.0



