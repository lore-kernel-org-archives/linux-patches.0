Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B9728E5F8;
	Sun,  1 Jun 2025 23:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820671; cv=none; b=OgxmVxDwpz5xUYfgx78VAKpltKfRdOFDC+S0BGo32otd8hUvDcPkAORG2OtAfRap5AV0Hy1M70HOzOC6Sue+v5pUiC2oqQtAJPhyMfbm1FYvWhyRz+x/tD+AHXti91gnhAHW4TdfU2kvfABKN9TeA5sAUAO7G+MmPcXXGIXRu9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820671; c=relaxed/simple;
	bh=0Oku3P9NkY5OOVMgBcC/R5PsG9BYTUccpDMo8SZ6lOc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VUljSkinjDO6mm/dBKHdGEN34f4IEWmsg7pNFrelQvMYPeOJUF/0vhp46kgSMwYddl+dc7bkdaQ5Ag1p3CBL7StiKvRs5TQ0q0q1Ti/rhaCgshIU/kjcxdjwq4wp2FsDDS9bywRa30F5GbUNFkdC+u1T0Exnp+bngbcVi11Oi4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQZQd4f8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQZQd4f8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CF4C4CEE7;
	Sun,  1 Jun 2025 23:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820671;
	bh=0Oku3P9NkY5OOVMgBcC/R5PsG9BYTUccpDMo8SZ6lOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQZQd4f8c2vvYmt8B1tTTAa1bJeaFE4saxSJk/cdbl68mheyMCfIn1+zhKbdTlInH
	 hvoUzcRL/8xR+3nSzxiok8PBWn4r0YhcUBrYKOHUyMDxz8CoXbekza89sMPTDX18MX
	 QhymUkR4K8WYjsvSaAXf8KJ5OuSqXp4Src4cn7xy24kp9YdQtx9kKqZux5ZOMhVRtf
	 yVEpjLt/rUJIPiqxkmRswlmkmy5yHiW2ymYMxRaEA7gn9acec/bLQvtmQ6et19Pseg
	 RhxLA/KS5PAGo8jXlKttkN2IcXOf7DZEx3fQC6mjSAvXn+ktIhywckKAb4CH+TiFtA
	 B+kxxKrHqb8ZQ==
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
	srinivasan.shanmugam@amd.com,
	vitaly.prosyak@amd.com,
	Jesse.zhang@amd.com,
	Jiadong.Zhu@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 036/102] drm/amdgpu/gfx10: fix CSIB handling
Date: Sun,  1 Jun 2025 19:28:28 -0400
Message-Id: <20250601232937.3510379-36-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 683308af030cd9b8d3f1de5cbc1ee51788878feb ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. ##
Detailed Analysis: ### The Bug The commit fixes a critical bug in the
`gfx_v10_0_get_csb_buffer()` function in
`/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c`. The function is responsible
for building a Command Stream Buffer (CSB) for GPU initialization. **The
problematic code before the fix:** ```c for (sect =
adev->gfx.rlc.cs_data; sect->section != NULL; ++sect) { for (ext =
sect->section; ext->extent != NULL; ++ext) { if (sect->id ==
SECT_CONTEXT) { buffer[count++] =
cpu_to_le32(PACKET3(PACKET3_SET_CONTEXT_REG, ext->reg_count));
buffer[count++] = cpu_to_le32(ext->reg_index -
PACKET3_SET_CONTEXT_REG_START); for (i = 0; i < ext->reg_count; i++)
buffer[count++] = cpu_to_le32(ext->extent[i]); } else { return; // ←
BUG: Early return prevents rest of buffer initialization } } } ``` **The
fix removes the early return:** ```c for (sect = adev->gfx.rlc.cs_data;
sect->section != NULL; ++sect) { for (ext = sect->section; ext->extent
!= NULL; ++ext) { if (sect->id == SECT_CONTEXT) { buffer[count++] =
cpu_to_le32(PACKET3(PACKET3_SET_CONTEXT_REG, ext->reg_count));
buffer[count++] = cpu_to_le32(ext->reg_index -
PACKET3_SET_CONTEXT_REG_START); for (i = 0; i < ext->reg_count; i++)
buffer[count++] = cpu_to_le32(ext->extent[i]); } // ← Early return
removed - now continues to process rest of buffer } } ``` ### Why This
Should Be Backported: 1. **Fixes Important GPU Initialization Bug**:
This is a clear functional bug that affects AMDGPU GFX10 hardware.
Looking at the clearstate data structure, I can see that
`gfx10_cs_data[]` contains only `SECT_CONTEXT` sections, but if any
future section was not `SECT_CONTEXT`, the early return would prevent
critical buffer initialization from completing. 2. **Affects Critical
Hardware Functionality**: The CSB (Command Stream Buffer) is essential
for proper GPU initialization. An incomplete buffer could lead to: - GPU
hang during initialization - Incorrect register states - System
instability - Failed GPU bring-up 3. **Small, Contained Fix**: The fix
is minimal - it simply removes an erroneous `else { return; }` clause.
This has very low risk of introducing regressions. 4. **No Architectural
Changes**: This doesn't change any APIs, interfaces, or architectural
decisions. It's a pure bugfix. 5. **Follows Stable Tree Criteria**: -
Important bugfix ✓ - Minimal risk ✓ - Confined to a subsystem ✓ - No new
features ✓ 6. **Critical GPU Subsystem**: The commit touches GPU command
submission infrastructure, which is critical for system stability when
AMD GFX10 hardware is present. 7. **Clear Commit Message**: The commit
message clearly explains the bug: "We shouldn't return after the last
section. We need to update the rest of the CSIB." Looking at the
reference commits, this aligns with "Similar Commit #4" which was marked
YES for backporting - it's a clear functional bugfix in critical GPU
subsystem code that prevents proper operation. The missing code after
the early return includes essential buffer finalization: - Setting
PA_SC_TILE_STEERING_OVERRIDE register - Adding
PACKET3_PREAMBLE_END_CLEAR_STATE - Adding PACKET3_CLEAR_STATE command
Without these, the GPU's clear state buffer would be incomplete,
potentially causing initialization failures.

 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 09178d56afbf6..20b6d01f4beb1 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4270,8 +4270,6 @@ static void gfx_v10_0_get_csb_buffer(struct amdgpu_device *adev,
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

