Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415AA22DF91;
	Tue, 29 Apr 2025 17:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948291; cv=none; b=i6rg+dOaPIR0fnrvq4PKZFypYbQ5TB6fnz3VH+5cDeG8ZvYJgz+lxZ3ofoz3CytRhxLfI72TB9TPxd6GlKpaUtUMhRwgL2pMwvj0P9ANoc6U/B1mmHxxWG/j3ISfShY6/cKlrQBWxFBa+wNoZ9gDzzW0uwGDgygb2VH4QuQyyVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948291; c=relaxed/simple;
	bh=Rz8TOQoceIVMs0jnICwryYKbTCele+69KkUzpU78bYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KZyaSJZ187L9Fohm3q3o6YAynAqPYdaVtciFBICTm6z8re1r0LqiNLb2TjFg4rwfhjJzZob6Evt7qUeq+dOV29IUhzEKRhUe8vQWUIGlRrJyPULM9sRLVMaQAcE0h/QAbOk1RaQHr25Do3k/2XVK52IwOBzAoLu6Eu5c6nJ6HJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyAuw1ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyAuw1ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82AFC4CEE3;
	Tue, 29 Apr 2025 17:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948291;
	bh=Rz8TOQoceIVMs0jnICwryYKbTCele+69KkUzpU78bYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyAuw1juer1zYlgLPQLtkha/6hHW2RZC7AIZR7mCTXIWXcY94v2BtzIdEWS4s3WC4
	 4pm7Qn6/zfm+vtfWp9P7+TakDI6P/c0NRFhjRLrzPgnlZ33LAeUarVoZ+HpZDipCsq
	 15JrxhD6fuaxHUN/TVnX5JIjW3tsyUbgOUfzNOWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/280] drm/amdgpu: use a dummy owner for sysfs triggered cleaner shaders v4
Date: Tue, 29 Apr 2025 18:43:06 +0200
Message-ID: <20250429161125.149411945@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 447fab30955cf7dba7dd563f42b67c02284860c8 ]

Otherwise triggering sysfs multiple times without other submissions in
between only runs the shader once.

v2: add some comment
v3: re-add missing cast
v4: squash in semicolon fix

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8b2ae7d492675e8af8902f103364bef59382b935)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 05ebb8216a55a..3c2ac5f4e814b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -1426,9 +1426,11 @@ static int amdgpu_gfx_run_cleaner_shader_job(struct amdgpu_ring *ring)
 	struct amdgpu_device *adev = ring->adev;
 	struct drm_gpu_scheduler *sched = &ring->sched;
 	struct drm_sched_entity entity;
+	static atomic_t counter;
 	struct dma_fence *f;
 	struct amdgpu_job *job;
 	struct amdgpu_ib *ib;
+	void *owner;
 	int i, r;
 
 	/* Initialize the scheduler entity */
@@ -1439,9 +1441,15 @@ static int amdgpu_gfx_run_cleaner_shader_job(struct amdgpu_ring *ring)
 		goto err;
 	}
 
-	r = amdgpu_job_alloc_with_ib(ring->adev, &entity, NULL,
-				     64, 0,
-				     &job);
+	/*
+	 * Use some unique dummy value as the owner to make sure we execute
+	 * the cleaner shader on each submission. The value just need to change
+	 * for each submission and is otherwise meaningless.
+	 */
+	owner = (void *)(unsigned long)atomic_inc_return(&counter);
+
+	r = amdgpu_job_alloc_with_ib(ring->adev, &entity, owner,
+				     64, 0, &job);
 	if (r)
 		goto err;
 
-- 
2.39.5



