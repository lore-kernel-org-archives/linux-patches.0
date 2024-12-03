Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283682500B8;
	Tue,  3 Dec 2024 15:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240713; cv=none; b=cs6L+2eplXz1Jih3AOz1zK21GfOWbq/f3Ae1BSMrhoHt1FLwGkbKFIhgu0kC97yCthFRKm6C+Vw8nC52O2/LKV5OZBaRbNEjvyCfQS7lrz/K20Lbo0Zt4n0TDM0p3oivmox5YWUO5GiQ3vKUZsTbvUrdkigHsrBuvmtHoHZiVrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240713; c=relaxed/simple;
	bh=aNdKMxSV8Iw6+iKFltkgMoAgYuOPtHikCvmFHodeRWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jg1pxmDNEg99FI2StSg4d9dbHf52Rc1mDaiHGjM9kNt+WfVZ/mhLlWhQcg1qBdE8lcNOibaBqmy0+GjJXrjiqn5l9TM4HMdemMhwSJpD7ehAf08wmAF7V0oUjALvjTcdmJkLazovcvpwBpPKnZcLrxXbV1p1FkFh2WJH0SPPgJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9+CIl64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9+CIl64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE12C4CECF;
	Tue,  3 Dec 2024 15:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240713;
	bh=aNdKMxSV8Iw6+iKFltkgMoAgYuOPtHikCvmFHodeRWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9+CIl64sXMvDdFuT+P/OC4mlzX7d9ww+uJAloudp8JhJPnLSVH5NT2yBZljZooCz
	 pY7zVwkDuE79wxBAYKXRvs5cJSzY+3mBvT5af3B6rm7pNeF7UlDvUwQtPOPuczJxXs
	 xEELBE06ZHFQYYGl4v4Sk1pe4Q35OoyacjAlmZB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/826] drm/amdgpu/gfx9: Add Cleaner Shader Deinitialization in gfx_v9_0 Module
Date: Tue,  3 Dec 2024 15:39:02 +0100
Message-ID: <20241203144752.129523286@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit e47cb9d2533200d49dd5364d4a148119492f8a3d ]

This commit addresses an omission in the previous patch related to the
cleaner shader support for GFX9 hardware. Specifically, it adds the
necessary deinitialization code for the cleaner shader in the
gfx_v9_0_sw_fini function.

The added line amdgpu_gfx_cleaner_shader_sw_fini(adev); ensures that any
allocated resources for the cleaner shader are freed correctly, avoiding
potential memory leaks and ensuring that the GPU state is clean for the
next initialization sequence.

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Fixes: c2e70d307f44 ("drm/amdgpu/gfx9: Implement cleaner shader support for GFX9 hardware")
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 23f0573ae47b3..785a343a95f0f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2418,6 +2418,8 @@ static int gfx_v9_0_sw_fini(void *handle)
 	amdgpu_gfx_kiq_free_ring(&adev->gfx.kiq[0].ring);
 	amdgpu_gfx_kiq_fini(adev, 0);
 
+	amdgpu_gfx_cleaner_shader_sw_fini(adev);
+
 	gfx_v9_0_mec_fini(adev);
 	amdgpu_bo_free_kernel(&adev->gfx.rlc.clear_state_obj,
 				&adev->gfx.rlc.clear_state_gpu_addr,
-- 
2.43.0



