Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3389B1ADC97;
	Sat, 14 Feb 2026 01:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031041; cv=none; b=Ltu2iUs63wayzncbvvwCceDjCwdAwhkLwwj/Ekl0Fj86iiJegapDjHKE+QebTNHpoW2b+quSUgV4/T1LoUm7Yc20B4Udz+ZhOEOwuSwnXLWw+jnKX1fQolr+UFDIipZtLUnbJyADS7JNUr8B2y0ySChS88ztUSHYQ+/XEsz7pgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031041; c=relaxed/simple;
	bh=aLHQO7J6C5Lyqu2k8hj94N7/xg5S73iyBQ1nJlaaGaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f9zNcDj39sycMz7gvFayQTAwsCF8FAcXCTXAi/a2kd1VNPlOg1Kk6aoJhYb+LMhmUI5g+y8bzNCq9Zbj0p5jtX7cZWlaORgTnf+pxpkBzUpoAj3qcdXni8RQloNCHnsgD0hx9HbmwAzKZuPcSk1g3se9VW4OYtkFYf+HEvWRZRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNO4Ap3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNO4Ap3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69188C116C6;
	Sat, 14 Feb 2026 01:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031040;
	bh=aLHQO7J6C5Lyqu2k8hj94N7/xg5S73iyBQ1nJlaaGaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNO4Ap3mtJ5qzkQiAOUSPqqWSZfnfHbCXOs+fPoGP0qWOcjmojDczzjPZIbLs+3Hj
	 UftKTNi1OvhBn2nEI0ves00j24IR4gzFnOVcDgva+zX9r8jg+m19lsYSV1Vhr0W+Fm
	 6BfyrRNVCPc4H4hV8rIcbFqCmNPgSXHjVybqJzXnK/5cxc9eJtQTmFUzIWY36hTIKB
	 xjsv5ejL0oPTB6hrzK55fvgwEzHa3wcNTrmS/fbzlAsNQERVqzfHMJE8FT2YNbSgJj
	 Nc/XavLyqaOK5e8/7SAVZfvJW4lu/b/J5CZWZ3S8cIrHzyK26urXpVg55YCLWvtPDY
	 RbJGT9yMMgErA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Likun Gao <Likun.Gao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	lijo.lazar@amd.com,
	christian.koenig@amd.com,
	superm1@kernel.org,
	mario.limonciello@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	cesun102@amd.com
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amdgpu: fix NULL pointer issue buffer funcs
Date: Fri, 13 Feb 2026 19:58:34 -0500
Message-ID: <20260214010245.3671907-34-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Likun Gao <Likun.Gao@amd.com>

[ Upstream commit 9877a865d62c9c3e0f4cc369dc9ca9f7f24f5ee9 ]

If SDMA block not enabled, buffer_funcs will not initialize,
fix the null pointer issue if buffer_funcs not initialized.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. When called with `enable=false`,
`amdgpu_ttm_set_buffer_funcs_status` doesn't dereference
`buffer_funcs_ring` (the ring access is only in the `enable=true` path
at line 2166). The disable calls (lines 3991, 5064, 5330) are thus safe.
But the `enable=true` calls with the `buffer_funcs_ring->sched.ready`
guard check are the problematic ones.

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The subject explicitly says **"fix NULL pointer issue buffer funcs"** —
a clear bug fix. The description explains: *"If SDMA block not enabled,
buffer_funcs will not initialize, fix the null pointer issue if
buffer_funcs not initialized."* The author (Likun Gao, AMD engineer) and
reviewer (Hawking Zhang, AMD engineer) clearly identified a NULL pointer
dereference.

### 2. CODE CHANGE ANALYSIS

The change is minimal — a single NULL check addition:

```3312:3313:drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
        if (adev->mman.buffer_funcs_ring->sched.ready)
                amdgpu_ttm_set_buffer_funcs_status(adev, true);
```

Changed to:
```c
        if (adev->mman.buffer_funcs_ring &&
            adev->mman.buffer_funcs_ring->sched.ready)
                amdgpu_ttm_set_buffer_funcs_status(adev, true);
```

**Root cause**: `buffer_funcs_ring` is explicitly initialized to NULL:

```4544:4545:drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
        adev->mman.buffer_funcs = NULL;
        adev->mman.buffer_funcs_ring = NULL;
```

It only gets set to a non-NULL value when SDMA `set_buffer_funcs()`
callbacks run during SDMA `early_init`. This happens in every SDMA
version: `sdma_v4_0`, `sdma_v5_0`, `sdma_v5_2`, `sdma_v6_0`,
`sdma_v7_0`, etc. If SDMA is disabled (via `amdgpu_ip_block_mask` module
parameter, harvesting, or early_init failure returning `-ENOENT`),
`buffer_funcs_ring` stays NULL.

The dereference of `adev->mman.buffer_funcs_ring->sched.ready` when
`buffer_funcs_ring` is NULL triggers a **kernel NULL pointer
dereference** (oops/crash).

### 3. ORIGIN OF THE BUG

The vulnerable pattern was introduced by commit `b70438004a14f`
("drm/amdgpu: move buffer funcs setting up a level") which landed in
**v6.7-rc1**. That commit moved the `buffer_funcs_ring->sched.ready`
checks from SDMA-specific code into `amdgpu_device.c` at four locations
(init, resume, reset, suspend-unwind), but didn't add NULL guards for
configurations where SDMA is absent.

### 4. SCOPE AND RISK

- **Lines changed**: 2 (adding `&&` with NULL check)
- **Files changed**: 1
- **Risk**: Extremely low. The NULL check guard only prevents
  dereferencing a NULL pointer. When `buffer_funcs_ring` is non-NULL,
  behavior is identical. When it IS NULL, it prevents a crash and
  correctly skips `amdgpu_ttm_set_buffer_funcs_status(adev, true)` —
  which is the right thing to do since there's no SDMA ring to use.
- **Regression potential**: Essentially zero.

### 5. USER IMPACT

- **Who is affected**: Users with AMD GPUs where SDMA is not enabled —
  either by hardware design (harvested), by configuration (module
  parameter), or by init failure.
- **Severity**: **Kernel crash** (NULL pointer dereference/oops) during
  device initialization.
- **Frequency**: Every boot attempt on affected hardware.

### 6. COMPLETENESS NOTE

There are **three other** unprotected dereferences of
`buffer_funcs_ring->sched.ready` in the same file (lines 4206, 5344,
6076 — in resume, unwind, and reset paths). This commit only fixes the
init path. However:
- The init path is hit first and is the primary crash point
- If SDMA is absent at init, the device likely won't reach resume/reset
  in normal operation
- Each fix is independently valuable

### 7. STABLE CRITERIA CHECK

- Obviously correct: Yes — simple NULL guard before dereference
- Fixes a real bug: Yes — NULL pointer dereference = kernel crash
- Important issue: Yes — prevents crash during device initialization
- Small and contained: Yes — 2-line change in one file
- No new features/APIs: Correct
- Reviewed by subsystem experts: Yes (Hawking Zhang, Alex Deucher at
  AMD)
- Affected versions: v6.7+ (when b70438004a14f landed)

The fix is small, surgical, obviously correct, and prevents a kernel
crash on AMD GPU initialization. It meets all stable kernel criteria
with effectively zero regression risk.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index d2c3885de711f..ba6fb23b840a0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3309,7 +3309,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 	if (r)
 		goto init_failed;
 
-	if (adev->mman.buffer_funcs_ring->sched.ready)
+	if (adev->mman.buffer_funcs_ring &&
+	    adev->mman.buffer_funcs_ring->sched.ready)
 		amdgpu_ttm_set_buffer_funcs_status(adev, true);
 
 	/* Don't init kfd if whole hive need to be reset during init */
-- 
2.51.0

