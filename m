Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA6D31AABD;
	Sun,  1 Jun 2025 23:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821239; cv=none; b=sEKLkyo6NVCvrHLIsov/NskxSLxY11Z64twj1NYEiz/ZGmJgSfscnqV6rtX0xDsTriPYEKnzWpNzTdkH5yTR+32mK7bAxY0UJVxA89x4JyLy1m/33Bj788UJNDcIZ1QDXDqN0lTQ0gPWzF7R59XzhkQIHsd0V5uo4ljSPc6Wa1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821239; c=relaxed/simple;
	bh=NhZ+EQ02QjpZ41+so3A5sxl7ADGSqt3HKdrDq7qpVHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hKdRcEuxL4sywGLXz6VUhY1b6Tc5x2CK2P7GKxax1p3DSLs1vCj3PR1RYv9eudIjcDXPUIgSLC0oafmE8YfABQbnq0MDkCUka5jWYOBAsFNlwKtMC+xb47XQZX7ZITwgpaOFUabO9rfXtqPNhfJsdnOb9mCD7RjXRd5fo+wggfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OuXAjqGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OuXAjqGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD930C4CEE7;
	Sun,  1 Jun 2025 23:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821239;
	bh=NhZ+EQ02QjpZ41+so3A5sxl7ADGSqt3HKdrDq7qpVHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuXAjqGUkrFm4WHU0mz2iOZ4AXLA1WXkXkH7hBdCbpqwYVps9Z1DNtzT2noUbCr2H
	 rwXnQLNUh2ifhuB58iwcFALjxKlCl4q8yXsRC555aLFJPIFv1DMUkZiVSG5PXLWkqg
	 Z3rqlmUQOE49Ni8d0YDVibaNA9pvX+JV2hzsAEM99PZTb2qGS92CcSvQ02R7cmKG4M
	 RCMdRiChc4kCeWEY667nahkoky2VilzToHE1w0Au1eNP/3eRSuYsRwabGPnyRxha1n
	 IM9A4PZfvqZjm0WCma5kg6JHuyVIsubCvljT2+JDGXZLfT2pegFp17K0xkRrNnuY58
	 8dTSAoqMbARUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	sunil.khatri@amd.com,
	vitaly.prosyak@amd.com,
	srinivasan.shanmugam@amd.com,
	tim.huang@amd.com,
	Prike.Liang@amd.com,
	Jesse.zhang@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 09/58] drm/amdgpu/gfx11: fix CSIB handling
Date: Sun,  1 Jun 2025 19:39:22 -0400
Message-Id: <20250601234012.3516352-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601234012.3516352-1-sashal@kernel.org>
References: <20250601234012.3516352-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit a9a8bccaa3ba64d509cf7df387cf0b5e1cd06499 ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. ##
Analysis ### Code Change Analysis The commit fixes a **critical bug in
CSIB (Clear State Init Buffer) handling** in the GFX11 AMD GPU driver.
The problematic code in `gfx_v11_0_get_csb_buffer()` at line 861
contained: ```c } else { return; // This was the bug! } ``` This early
return statement prevented the function from completing the CSIB setup
when encountering non-SECT_CONTEXT sections. The fix removes this
premature return, allowing the function to continue and properly
complete the buffer initialization with: 1.
**PA_SC_TILE_STEERING_OVERRIDE register setup** (lines 866-870) 2.
**PACKET3_PREAMBLE_END_CLEAR_STATE** (lines 872-873) 3.
**PACKET3_CLEAR_STATE** (lines 875-876) ### Why This Qualifies for
Backporting 1. **Fixes Important Hardware Initialization Bug**: CSIB is
critical for GPU state management. Incomplete initialization can cause
GPU hangs, rendering artifacts, or system instability. 2. **Small,
Contained Fix**: The change removes only 2 lines (`} else { return; }`)
- minimal and low-risk. 3. **No Architectural Changes**: This is a pure
bugfix with no new features or major code restructuring. 4. **Critical
Subsystem**: Graphics drivers are essential for system functionality,
and GPU state corruption can cause severe user-visible issues. 5.
**Pattern Consistency**: Looking at similar sections across different
GFX versions (v10, v9, etc.), they all handle non-SECT_CONTEXT sections
by continuing rather than returning early, confirming this was indeed a
bug. ### Historical Context Support From examining the codebase, this
pattern is consistent across all GFX generations: - **gfx_v10_0.c:4227**
and **gfx_v10_0.c:4266**: Handle SECT_CONTEXT but continue for other
sections - **gfx_v9_0.c:1609** and **gfx_v9_0.c:1645**: Same pattern -
**gfx_v8_0.c**, **gfx_v7_0.c**, **gfx_v6_0.c**: All follow the same
approach The previous GFX10 CSIB fix (commit 4905880b4515) shows AMD's
commitment to ensuring proper CSIB initialization across GPU
generations, reinforcing the importance of this subsystem. ### Risk
Assessment - **Regression Risk**: Extremely low - only removes incorrect
early termination - **Testing Surface**: Affects GFX11 GPU
initialization, easily testable - **Side Effects**: None - only allows
completion of intended initialization sequence This is a textbook
example of a stable-worthy fix: important bug, minimal change, no
regression risk, and affects critical hardware functionality.

 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 61e869839641e..d0ebc00215b13 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -645,8 +645,6 @@ static void gfx_v11_0_get_csb_buffer(struct amdgpu_device *adev,
 						PACKET3_SET_CONTEXT_REG_START);
 				for (i = 0; i < ext->reg_count; i++)
 					buffer[count++] = cpu_to_le32(ext->extent[i]);
-			} else {
-				return;
 			}
 		}
 	}
-- 
2.39.5

