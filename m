Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1738A154BE5;
	Wed,  5 Feb 2025 13:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763901; cv=none; b=jd56CI77IToJChF2q14a+nmFkpSyhQMj3uP4d93i8zoORKQZ+C6FvH3nOXxqkTpM7w4lKv7k4bGmNygCDNAoSu66Qej+xyVr1/vbM0LNWerMa6ZRuNm4QIaoD7B7AizzlR3iW/T64KuaG4bvkP17O3C1tEhoGo7WSgDptWVnQaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763901; c=relaxed/simple;
	bh=bmDxquzoLHrKpwVgDsNwBxQ22uhnnHJzYtHalr/QQJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxGvB4u7s28Zu/0AfVVZfwuW55wwSx/4rekh4kJGwuhsEtCvo6CYFVYmRqgAoDpjJKiZLoFlJP8sCxtHBXmgOkuE9yr4vPnm6rIicY7T6GFfgETlN4/Ls2XMRZjtR7YHgHXl2Z/7GU4EXzWdsp+6X/kvdsnMauAJvEYGYpoNF+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpQdCAFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpQdCAFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9CCC4CED1;
	Wed,  5 Feb 2025 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763901;
	bh=bmDxquzoLHrKpwVgDsNwBxQ22uhnnHJzYtHalr/QQJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpQdCAFeZ/d0dxAbYjtVi6liy6iEBxa4o89hAqjSHYUenbathuMJZPfpv6q9rykMF
	 W3yMpt+YAocrfdlru3yKJNofZ6TkFudDf116DB92S9hC4+eSp6rSQbIHU192iCS7zD
	 TIY/zzK5X2QL5tjuKRt5AmnF/xctLV5P8WGq3Eiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jonathan Kim <jonathan.kim@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/590] Revert "drm/amdgpu/gfx9: put queue resets behind a debug option"
Date: Wed,  5 Feb 2025 14:37:06 +0100
Message-ID: <20250205134457.973491285@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 32f00289698189b813942f37626218fd473e7302 ]

This reverts commit 7c1a2d8aba6cadde0cc542b2d805edc0be667e79.

Extended validation has completed successfully, so enable
these features by default.

Acked-by: Jiadong Zhu <Jiadong.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jonathan Kim <jonathan.kim@amd.com>
Cc: Jiadong Zhu <Jiadong.Zhu@amd.com>
Stable-dep-of: 86bde64cb795 ("drm/amdgpu: fix gpu recovery disable with per queue reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c | 4 ----
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c             | 4 ----
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c           | 6 ------
 3 files changed, 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
index 3bc0cbf45bc59..353ac458c834b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
@@ -1133,10 +1133,6 @@ uint64_t kgd_gfx_v9_hqd_get_pq_addr(struct amdgpu_device *adev,
 	uint32_t low, high;
 	uint64_t queue_addr = 0;
 
-	if (!adev->debug_exp_resets &&
-	    !adev->gfx.num_gfx_rings)
-		return 0;
-
 	kgd_gfx_v9_acquire_queue(adev, pipe_id, queue_id, inst);
 	amdgpu_gfx_rlc_enter_safe_mode(adev, inst);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index e7cd51c95141e..e2501c98e107d 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -7251,10 +7251,6 @@ static int gfx_v9_0_reset_kcq(struct amdgpu_ring *ring,
 	unsigned long flags;
 	int i, r;
 
-	if (!adev->debug_exp_resets &&
-	    !adev->gfx.num_gfx_rings)
-		return -EINVAL;
-
 	if (amdgpu_sriov_vf(adev))
 		return -EINVAL;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index ffdb966c4127e..5dc3454d7d361 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -3062,9 +3062,6 @@ static void gfx_v9_4_3_ring_soft_recovery(struct amdgpu_ring *ring,
 	struct amdgpu_device *adev = ring->adev;
 	uint32_t value = 0;
 
-	if (!adev->debug_exp_resets)
-		return;
-
 	value = REG_SET_FIELD(value, SQ_CMD, CMD, 0x03);
 	value = REG_SET_FIELD(value, SQ_CMD, MODE, 0x01);
 	value = REG_SET_FIELD(value, SQ_CMD, CHECK_VMID, 1);
@@ -3580,9 +3577,6 @@ static int gfx_v9_4_3_reset_kcq(struct amdgpu_ring *ring,
 	unsigned long flags;
 	int r;
 
-	if (!adev->debug_exp_resets)
-		return -EINVAL;
-
 	if (amdgpu_sriov_vf(adev))
 		return -EINVAL;
 
-- 
2.39.5



