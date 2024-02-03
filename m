Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D542EFC03;
	Sat,  3 Feb 2024 04:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933464; cv=none; b=t8UVmOs35zKyV87tS73PyJMae+zwjJvuPXZOz+bAy9VXk0nTGKDvD3sgVApS3XpYMD68coOER+01snPJAYQ6Medp3yoaSS2Z/c+zjsmVVz6noUFoYpUv9ppBWmcFAYaZ7VdvlMBf7uJyYziBkethP1ubMvjQIkTMe0YtGkkvRXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933464; c=relaxed/simple;
	bh=39B4aIPEfnq3rEvUOLGcV9gzXBiDJRYnz+SsK1adeuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NpVPENw4B1gFaDIx5Ocz5jZWfn5aXCHJ2jLOWKgXushhU7ko1yy/YEIkGHH3MmGvZHzV55mzU9uah04enzQVYI+dFanPXiR+J0KFVrBBEzgOSLHWITIbTbFrqOstmnsBrpFul6GsYDmgUdJ7vZZHedKwcvuU69WKiBoOCMCXFFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySd6Brw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySd6Brw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E13AC43399;
	Sat,  3 Feb 2024 04:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933464;
	bh=39B4aIPEfnq3rEvUOLGcV9gzXBiDJRYnz+SsK1adeuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySd6Brw/GLSh4BJKfH3oA7b08XLUO2aPg3uhh90TK4716VC5xhEELVqGr7VJewukf
	 BKRPD69cN4EaVssodI61bZE/nGmYwe9wN1r6aOvAh6/AozFSbnRdJPkqAdR8tpnKdf
	 GdSqIN17xFzM1EpuiCQbdICrPkEDgJRJb+T9CQ7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaojian Du <Xiaojian.Du@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/219] drm/amdgpu: Fix with right return code -EIO in amdgpu_gmc_vram_checking()
Date: Fri,  2 Feb 2024 20:05:52 -0800
Message-ID: <20240203035341.908396200@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit fac4ebd79fed60e79cccafdad45a2bb8d3795044 ]

The amdgpu_gmc_vram_checking() function in emulation checks whether
all of the memory range of shared system memory could be accessed by
GPU, from this aspect, -EIO is returned for error scenarios.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c:919 gmc_v6_0_hw_init() warn: missing error code? 'r'
drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c:1103 gmc_v7_0_hw_init() warn: missing error code? 'r'
drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c:1223 gmc_v8_0_hw_init() warn: missing error code? 'r'
drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c:2344 gmc_v9_0_hw_init() warn: missing error code? 'r'

Cc: Xiaojian Du <Xiaojian.Du@amd.com>
Cc: Lijo Lazar <lijo.lazar@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 2bc791ed8830..ea0fb079f942 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -808,19 +808,26 @@ int amdgpu_gmc_vram_checking(struct amdgpu_device *adev)
 	 * seconds, so here, we just pick up three parts for emulation.
 	 */
 	ret = memcmp(vram_ptr, cptr, 10);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret = -EIO;
+		goto release_buffer;
+	}
 
 	ret = memcmp(vram_ptr + (size / 2), cptr, 10);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret = -EIO;
+		goto release_buffer;
+	}
 
 	ret = memcmp(vram_ptr + size - 10, cptr, 10);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret = -EIO;
+		goto release_buffer;
+	}
 
+release_buffer:
 	amdgpu_bo_free_kernel(&vram_bo, &vram_gpu,
 			&vram_ptr);
 
-	return 0;
+	return ret;
 }
-- 
2.43.0



