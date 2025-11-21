Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1EB2F363E;
	Fri, 21 Nov 2025 13:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730875; cv=none; b=fTVxaiseBecK1BzfpgHhp3TelmyTSChm9MpPGXIHTgRvAdEFNrrJRYtkF8TDX6wsNyvDOgJY3hhzWvQwijHR76sc8PCtkurr6euvS4rHLU1XNlmbl8UB6f0Ygu+GTVLVj0JQqfs9FZ+NR6UVQOxEcirPyPGGxTWL5jcNoOP4qiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730875; c=relaxed/simple;
	bh=8hQs+m1/m5JeHnVZTR5nwrHjvuPIMNj9dMwJEfcsqGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPyX1hN+CWPbMIiLBcyZXSCD9ycWeIsIkIYrYA1CZTTkGqCk4g777JWu1AKUJn3BzSAD7UzWBgnXFjJ1hSFgEqXPiOiXvnmQgtyJQyFshUsnCUhdZWxBwCWB5rS08WYtHRVQYkAMQfS7kZrihOEMWLSAPQgPA5Tu2lqBK/STo6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtSVqeol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtSVqeol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750EDC4CEF1;
	Fri, 21 Nov 2025 13:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730874;
	bh=8hQs+m1/m5JeHnVZTR5nwrHjvuPIMNj9dMwJEfcsqGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtSVqeolbvkh/Rr1EeHHmee+5g64VDWP/W1b1aQq5mjweCB23/EtQ3BPW7wSAp/Lt
	 u7+av5EETg07wzX6P/B9bXy5zGdXXZWP+mSpP4g1JmdjZJfwp832FwsDaabfdVIrcq
	 dKT2f7wAjgGMCC2pHe42l8gi3pQip/QgoUeYDOVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 005/247] drm/amdgpu: set default gfx reset masks for gfx6-8
Date: Fri, 21 Nov 2025 14:09:12 +0100
Message-ID: <20251121130154.790062647@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 90b75e12a6e831c8516498f690058d4165d5a5d6 ]

These were not set so soft recovery was inadvertantly
disabled.

Fixes: 6ac55eab4fc4 ("drm/amdgpu: move reset support type checks into the caller")
Reviewed-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1972763505d728c604b537180727ec8132e619df)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 5 +++++
 drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c | 5 +++++
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index 70d7a1f434c4b..e2cf598f773a4 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -3103,6 +3103,11 @@ static int gfx_v6_0_sw_init(struct amdgpu_ip_block *ip_block)
 			return r;
 	}
 
+	adev->gfx.gfx_supported_reset =
+		amdgpu_get_soft_full_reset_mask(&adev->gfx.gfx_ring[0]);
+	adev->gfx.compute_supported_reset =
+		amdgpu_get_soft_full_reset_mask(&adev->gfx.compute_ring[0]);
+
 	return r;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
index 2aa323dab34e3..df1993d137364 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
@@ -4400,6 +4400,11 @@ static int gfx_v7_0_sw_init(struct amdgpu_ip_block *ip_block)
 
 	gfx_v7_0_gpu_early_init(adev);
 
+	adev->gfx.gfx_supported_reset =
+		amdgpu_get_soft_full_reset_mask(&adev->gfx.gfx_ring[0]);
+	adev->gfx.compute_supported_reset =
+		amdgpu_get_soft_full_reset_mask(&adev->gfx.compute_ring[0]);
+
 	return r;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index 367449d8061b0..13e38b44540bd 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -2024,6 +2024,11 @@ static int gfx_v8_0_sw_init(struct amdgpu_ip_block *ip_block)
 	if (r)
 		return r;
 
+	adev->gfx.gfx_supported_reset =
+		amdgpu_get_soft_full_reset_mask(&adev->gfx.gfx_ring[0]);
+	adev->gfx.compute_supported_reset =
+		amdgpu_get_soft_full_reset_mask(&adev->gfx.compute_ring[0]);
+
 	return 0;
 }
 
-- 
2.51.0



