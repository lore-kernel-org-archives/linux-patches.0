Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE6C217704;
	Sat, 14 Feb 2026 01:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031113; cv=none; b=KEQ3VNv1FW/Fi59luzkfGVlpnzljn2TS7bpwfK4LBjl0gHTaSVSFS6g2BcWjqFsnJjAIefPu/Vprvo1OIh2A61C3lSW9T9Hy094Jj2MqHf/39i619rZkds1oxuojMw/Fxfpd3kXH0oJ+8niNsDDPHHQwDOJ+tk+l+rjfWut2i7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031113; c=relaxed/simple;
	bh=oO5XvQGk6GO0pdHWKcpnzwO45cPPwdOh5VfsB130tHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YB1Wkb2nlW8gmF1xdgCU8uo3aPiO2U3TFgMoGoHq0DcUwrdfMqxH8xg2kxXU4lm4my3h+6wrK1nhA9ZZCAD9i+g68976IPFYBA2mVXdl2ik6gNwolcuVVkP/Qii4wLCc94qPyHwiG9URPohojv7KnCP0fgbdF8Gks6zBw61F62g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G37DI1QX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G37DI1QX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E404C16AAE;
	Sat, 14 Feb 2026 01:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031113;
	bh=oO5XvQGk6GO0pdHWKcpnzwO45cPPwdOh5VfsB130tHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G37DI1QXwJqX9lEwuJ64jTI1PvdIi2j35LsHZ56L9cF9iYU93POg95Oq+TL99mrjj
	 R3s3wTRVBZ9mPY8S+kgGzXS62Gckx2E45UovelH3g2AcJUfmFKDuPM6+D07/l8beUa
	 G6RUgqYqG1UsyCZig6/uK5dQp9ONzVSF9HF5zmhfYsXpKLoWEnZFTfCeY65/v7/FcT
	 eK0C1Y83YFitNECURCSFdfrzn1pIJD3u1z2P30r6WH0GjHlBeDF6rkJh3v316bpvmN
	 G/gzPmGsNaVTaaIbEpCvZ3Eh4MPJRWFBFSGnWiSvde1A5pRrJCQ0QlXHzTqv+RhfMx
	 KzC4+Tww4HiEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	ckoenig.leichtzumerken@gmail.com,
	andrealmeid@igalia.com,
	pierre-eric.pelloux-prayer@amd.com,
	phasta@kernel.org,
	YuanShang.Mao@amd.com,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.6] drm/amdgpu: avoid a warning in timedout job handler
Date: Fri, 13 Feb 2026 19:59:06 -0500
Message-ID: <20260214010245.3671907-66-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c8cf9ddc549fb93cb5a35f3fe23487b1e6707e74 ]

Only set an error on the fence if the fence is not
signalled.  We can end up with a warning if the
per queue reset path signals the fence and sets an error
as part of the reset, but fails to recover.

Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me summarize my analysis.

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The subject "drm/amdgpu: avoid a warning in timedout job handler"
clearly indicates a bug fix. The commit message explains: when the per-
queue reset path signals the fence and sets an error as part of the
reset, but the reset fails to recover, a `WARN_ON` triggers in
`dma_fence_set_error()`.

### 2. CODE CHANGE ANALYSIS

**The bug mechanism:**

The `dma_fence_set_error()` function contains a defensive `WARN_ON`:

```585:585:include/linux/dma-fence.h
        WARN_ON(test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags));
```

This triggers when trying to set an error on an already-signaled fence.

**The trigger path:**

In `amdgpu_job_timedout()`, when a GPU job times out:

1. Per-queue reset is attempted via `amdgpu_ring_reset(ring, job->vmid,
   job->hw_fence)`.
2. Inside the ring reset function (e.g., `gfx_v12_0_reset_kgq`),
   `amdgpu_ring_reset_helper_end()` calls
   `amdgpu_fence_driver_guilty_force_completion(guilty_fence)` which
   signals the hw_fence and sets errors on it.
3. When the hw_fence is signaled, the DRM scheduler callback chain
   fires: `drm_sched_job_done_cb()` → `drm_sched_job_done()` →
   `drm_sched_fence_finished()` → signals `s_fence->finished`.
4. Additionally, hardware can asynchronously signal fences through
   interrupts during the reset process (via `amdgpu_fence_process()`
   called from ISR).
5. If the ring reset ultimately fails (returns non-zero), code falls
   through to line 150: `dma_fence_set_error(&s_job->s_fence->finished,
   -ETIME)`.
6. Since `s_fence->finished` is already signaled, the `WARN_ON`
   triggers.

**The fix:**

```diff
- dma_fence_set_error(&s_job->s_fence->finished, -ETIME);
+       if (dma_fence_get_status(&s_job->s_fence->finished) == 0)
+               dma_fence_set_error(&s_job->s_fence->finished, -ETIME);
```

`dma_fence_get_status()` returns 0 if the fence is not yet signaled, 1
if signaled without error, or negative if signaled with an error. The
fix only sets the error when the fence has not yet been signaled (status
== 0), which is the only case where setting the error is both safe and
meaningful.

### 3. AFFECTED VERSIONS

The bug was introduced in **v6.17** by a series of commits that reworked
the per-queue reset:
- `43ca5eb94b38c` "move guilty handling into ring resets" (removed
  conditional `dma_fence_set_error()`)
- `38b20968f3d8a` "move scheduler wqueue handling into callbacks"
- `6ac55eab4fc41` "move reset support type checks into the caller"
  (passes `&job->hw_fence` to `amdgpu_ring_reset()` enabling fence
  signaling in `_helper_end()`)

In **6.12 and 6.15/6.16**, the code structure is fundamentally different
- `dma_fence_set_error()` was called before or inside the per-queue
reset block, and the ring reset functions didn't signal fences
internally. The bug doesn't manifest there.

### 4. SEVERITY AND IMPACT

- **WARN_ON in kernel log**: Produces a stack trace in dmesg, pollutes
  logs.
- **Panic on `panic_on_warn=1`**: Systems with `panic_on_warn=1` will
  crash. This is common in testing environments and some production
  setups.
- **Real trigger scenario**: GPU job timeouts are not uncommon on AMD
  GPUs, especially under load or with problematic workloads. The per-
  queue reset failing after partially processing fences is a realistic
  race condition.

### 5. FIX QUALITY AND RISK

- **Size**: 2-line change (add condition check before existing call).
- **Correctness**: Obviously correct. If the fence is already signaled,
  setting an error on it is meaningless (nobody will see it) and
  triggers a WARN_ON. Skipping it is the right behavior.
- **Risk**: Extremely low. The only change is adding a guard condition.
  In the normal path (fence not signaled), behavior is unchanged. In the
  edge case (fence already signaled), we avoid a spurious warning.
- **Dependencies**: `dma_fence_get_status()` has been available since at
  least v6.6. The fix requires no other changes.
- **Reviewed by**: Timur Kristóf, a known AMD GPU contributor.
- **Author**: Alex Deucher, the AMD DRM subsystem maintainer.

### 6. STABLE TREE APPLICABILITY

The fix applies cleanly to **6.17.y** and **6.18.y** where the same code
structure exists. The patch would need a minor adjustment for 6.17 (the
`debug_disable_gpu_ring_reset` check present in 6.17/6.18 but removed in
6.19). For 6.12.y and earlier, the bug doesn't exist in this form.

### Conclusion

This is a small, surgical, obviously correct bug fix that prevents a
kernel WARN_ON (potentially a panic with `panic_on_warn=1`) in a
realistic GPU job timeout recovery scenario. It was authored by the AMD
DRM maintainer, reviewed by a knowledgeable contributor, and has zero
regression risk. It meets all stable kernel criteria: fixes a real bug,
is small and contained, and introduces no new features.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 7ccb724b2488d..aaf5477fcd7ac 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -147,7 +147,8 @@ static enum drm_gpu_sched_stat amdgpu_job_timedout(struct drm_sched_job *s_job)
 		dev_err(adev->dev, "Ring %s reset failed\n", ring->sched.name);
 	}
 
-	dma_fence_set_error(&s_job->s_fence->finished, -ETIME);
+	if (dma_fence_get_status(&s_job->s_fence->finished) == 0)
+		dma_fence_set_error(&s_job->s_fence->finished, -ETIME);
 
 	if (amdgpu_device_should_recover_gpu(ring->adev)) {
 		struct amdgpu_reset_context reset_context;
-- 
2.51.0

