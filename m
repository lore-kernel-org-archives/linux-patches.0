Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BC72749D3;
	Tue,  5 Aug 2025 13:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399430; cv=none; b=dpF9tRArMGd+RRoL1HK7U0cmNVmocNPPh4MYk3hJrLkPUMM9P64aoZ+wq3WSRjVJlK1SRoI2qrQMDAB7zjif24EQ2WKQv2DPr2IyOAOA/B5CaWwnopIraC32Ao5xAm/+PiFB6+HiaXh9l5f0Qpve5LqnFWuyuRiZodDYhkKqfVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399430; c=relaxed/simple;
	bh=mjdH+10YkfdvNdcrWFkoPyZpCWI2x4E2VjR0AnPwxJQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pJUzpfU/ZRyZAH0FcfIC2697MUsjmJ1rWIyvMM+045yz22G+9PHxu9hUDZDSqmk0njm2W4q0/B1aM06tgfIByYDd65te0FveNhoRu5XAa6BYAzdIsZhYY6N6niJKnfY2tka0dFqjVUwTtOKaNFcQuvl6nzor+7KlH2zNbr3YoV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDHyp6AC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDHyp6AC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18D2C4CEF4;
	Tue,  5 Aug 2025 13:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399430;
	bh=mjdH+10YkfdvNdcrWFkoPyZpCWI2x4E2VjR0AnPwxJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDHyp6AC+5ilmRvlLKe3iSUU/rYC+FHL4fswXzF2bLWW6vnPivCBRtIHNvDk+hp3V
	 bz7B1UHz6gPRFTSJzQvjw19iqziPs3UZSEhbi/RDIF///evfikCmSzwOvASjf9AsDm
	 GS8JpNmb/NAp4TacY8cNWkffLaAIJc6va+FQ0R9qNugciqA20J5JiSMJIBiFq3vs+6
	 4nQGTqkzNvteL+dSEhijuJY14iz097C25YcJqczfIkF0jm55v0BU5ntUMCXEGE0jHH
	 czMAd0VVghfPuc/yKztWuHsHx8x1O3mko5QjqFhFthIAPxGRpAX5Lj9K4CuITW2vi9
	 ySu0yiEdvAVkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	alex.hung@amd.com,
	Wayne.Lin@amd.com,
	aurabindo.pillai@amd.com,
	sunpeng.li@amd.com,
	sunil.khatri@amd.com,
	chiahsuan.chung@amd.com,
	dominik.kaszewski@amd.com,
	mwen@igalia.com
Subject: [PATCH AUTOSEL 6.16-6.1] drm/amd/display: Only finalize atomic_obj if it was initialized
Date: Tue,  5 Aug 2025 09:08:54 -0400
Message-Id: <20250805130945.471732-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b174084b3fe15ad1acc69530e673c1535d2e4f85 ]

[Why]
If amdgpu_dm failed to initalize before amdgpu_dm_initialize_drm_device()
completed then freeing atomic_obj will lead to list corruption.

[How]
Check if atomic_obj state is initialized before trying to free.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear understanding of the issue. Let me provide my
analysis:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Analysis

1. **Clear Bug Fix**: The commit fixes a critical bug that can cause
   list corruption during cleanup. The issue occurs when
   `amdgpu_dm_destroy_drm_device()` is called after initialization
   failure, but before `drm_atomic_private_obj_init()` has been
   executed.

2. **Crash Prevention**: Looking at the `drm_atomic_private_obj_fini()`
   implementation in drivers/gpu/drm/drm_atomic.c:
  ```c
  list_del(&obj->head);
  obj->funcs->atomic_destroy_state(obj, obj->state);
  ```
  If `atomic_obj` was never initialized, calling `list_del()` on
  uninitialized list_head will cause list corruption, and dereferencing
  `obj->state` and `obj->funcs` will likely cause a kernel panic.

3. **Small and Contained Fix**: The fix is minimal - just adding a
   simple NULL check:
  ```c
  if (dm->atomic_obj.state)
  drm_atomic_private_obj_fini(&dm->atomic_obj);
  ```

4. **Clear Failure Path**: The initialization sequence shows:
   - `amdgpu_dm_initialize_drm_device()` calls
     `amdgpu_dm_mode_config_init()`
   - `amdgpu_dm_mode_config_init()` calls
     `drm_atomic_private_obj_init()` to initialize `atomic_obj`
   - If `amdgpu_dm_initialize_drm_device()` fails before reaching
     `amdgpu_dm_mode_config_init()`, the `atomic_obj` remains
     uninitialized
   - The error path calls `amdgpu_dm_fini()` which calls
     `amdgpu_dm_destroy_drm_device()`
   - Without this fix, `drm_atomic_private_obj_fini()` operates on
     uninitialized memory

5. **No Side Effects**: The fix only adds a defensive check and doesn't
   change any existing functionality. It only prevents cleanup of an
   uninitialized object.

6. **Follows Stable Rules**: This fix:
   - Fixes a real bug (list corruption/crash)
   - Is minimal (2 lines of code)
   - Has low risk of regression
   - Doesn't introduce new features
   - Is confined to the AMD display driver subsystem

7. **Initialization Order Issue**: The atomic_obj initialization happens
   relatively late in the initialization sequence, making this race
   condition possible in various failure scenarios during driver probe.

This is a textbook example of a commit that should be backported to
stable - it fixes a real crash bug with a minimal, safe change that
prevents operating on uninitialized data structures.

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f58fa5da7fe5..2d92dff6a77a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5368,7 +5368,8 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 
 static void amdgpu_dm_destroy_drm_device(struct amdgpu_display_manager *dm)
 {
-	drm_atomic_private_obj_fini(&dm->atomic_obj);
+	if (dm->atomic_obj.state)
+		drm_atomic_private_obj_fini(&dm->atomic_obj);
 }
 
 /******************************************************************************
-- 
2.39.5

