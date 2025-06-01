Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB6531EB30;
	Sun,  1 Jun 2025 23:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821283; cv=none; b=u76ZiXNDOb/BL3LjrhVK6fA397nSHkm2V7S1p2+bbRDAM6Q4wX9OWtiW8OSuO3yI1OX2lXLkMXG1KglZ+wwPKh+L0q3Nto5lBorSW9ju50N7hVuUanG/L9fMwhtD/xBnwjK1B6j3ijx3gVuLYarS18ugEKSqvSSk3FTFHzYTXlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821283; c=relaxed/simple;
	bh=qeVze8P6XEXfyMXMdn43Gd4I2IPl51CRhvEZ4apRctY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dr1yZ404dpCVqfQsHmKy1c7iadCV1LczqqsvLE1SaYbWd5+O1I+s4B630I9/syvYDFnDOr1aQlPTAQN9uYACybWK1WOmzMxQ7TFSJjb+DxwOpfV+txgPBiaSRyFtpgXK+4+ne+QWV2gvHs+LYIPUFDYgGK+W6qO0USSAfQ0AFPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCW9Ggbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCW9Ggbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4523CC4CEE7;
	Sun,  1 Jun 2025 23:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821283;
	bh=qeVze8P6XEXfyMXMdn43Gd4I2IPl51CRhvEZ4apRctY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCW9GgbzatHdB2npOXnoWlW4uV5/i6bBvJDC9X6rvJIQpGeLE72EeYtw3mmUPLg1/
	 pt4F3osF8w6sZEG3k8wUAfvMdM6og3OpniOB4wKOW3IhWvxkPamE6TJyefWNFlRw+x
	 //YHZP84t5WDNWgYGZ3kpiTi8637rai1jm5cxG8qZ3VKmZ8RIlgCPuyNZTmDlDp6XK
	 kUeJRiSRyoQ+aExQvbPHb3fA6u/ci+0buKAHmUYLSYsr/OfcuyBd9h7cYdK8kTh1/6
	 wSCNUM3g17CniuW3ABoK4eYue07NnTrgxWW8oiUujR5Njm1rpHHHR7hQOsj2XzY8/h
	 7UzzL2drUBLtw==
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
	boyuan.zhang@amd.com,
	Prike.Liang@amd.com,
	kevinyang.wang@amd.com,
	mario.limonciello@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 29/58] drm/amdgpu/gfx8: fix CSIB handling
Date: Sun,  1 Jun 2025 19:39:42 -0400
Message-Id: <20250601234012.3516352-29-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c8b8d7a4f1c5cdfbd61d75302fb3e3cdefb1a7ab ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees.
**Extensive Analysis:** **1. Critical Bug Nature:** The code changes fix
a serious logic error in the CSIB (Clear State Indirect Buffer) handling
for AMD GFX8 hardware. The bug occurs in `gfx_v8_0_get_csb_buffer()`
where there's an early `return` statement in the `else` branch at line
1252: ```c if (sect->id == SECT_CONTEXT) { // Handle SECT_CONTEXT
sections... } else { return; // BUG: Early exit prevents rest of buffer
setup! } ``` **2. Impact and Severity:** This bug has significant
functional impact because: - The function is responsible for setting up
the Clear State Buffer, which is critical for GPU state initialization -
When encountering any section that isn't `SECT_CONTEXT` (such as
`SECT_CLEAR`, `SECT_CTRLCONST`, or `SECT_NONE` as defined in
`clearstate_defs.h`), the function exits early - This prevents the
essential final buffer setup steps from executing: - PA_SC_RASTER_CONFIG
register setup (lines 1257-1261) - PACKET3_PREAMBLE_END_CLEAR_STATE
packet (lines 1263-1264) - PACKET3_CLEAR_STATE packet (lines 1266-1267)
**3. Real-World Consequences:** An incomplete CSB buffer can lead to: -
GPU initialization failures - Rendering corruption - System instability
- Potential hangs during graphics operations **4. Code Quality
Assessment:** - **Small and contained:** The fix removes only 2 lines of
problematic code - **No architectural changes:** Pure bug fix with no
design modifications - **Clear intent:** The commit message explicitly
states the problem and solution - **Low regression risk:** Removing an
early return cannot introduce new failures **5. Comparison with
Historical Examples:** This commit aligns perfectly with the "Backport
Status: YES" example (#4) which also fixed a critical handling issue in
AMD GPU code. Like that commit, this: - Fixes a clear functional bug -
Has immediate user impact - Is small and low-risk - Affects critical GPU
subsystem functionality **6. Stable Tree Compliance:** ✓ Fixes important
user-affecting bug ✓ Small, contained change ✓ No new features
introduced ✓ Critical hardware subsystem affected ✓ Clear regression
prevention The fix ensures that all necessary GPU state initialization
packets are properly written to the buffer, which is essential for
correct hardware operation on GFX8 hardware generations.

 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index 71ef25425c7f6..a51970e82861a 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -1263,8 +1263,6 @@ static void gfx_v8_0_get_csb_buffer(struct amdgpu_device *adev,
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

