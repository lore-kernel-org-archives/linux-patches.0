Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C132153D2;
	Sat, 25 Oct 2025 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409046; cv=none; b=gsdobtLkN19k7SQ32uHMm7MvPZDzOo+jAwapIEd/ruYlHRyYzRnzOAQzzLlTFnWGFHmJOyufUspk1M/DL0UJfbWM7TBv9T3FJ23ZKiRblt07NC2jYSlrtwuqrIx5WGcKz9wrDfayCN8QU7ZR8qHPNWmxecs/06ZtLSDNi+kF8Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409046; c=relaxed/simple;
	bh=pEsF0uFZavTEih5HOyMhLFtNWeMgC3Luz2do/MeGJOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jvQE+38RoBJH4Nq+vrbXCTIXq+zantazVFopBo5XfBoUp9KJ+H6HpuMEBYDk64IYeh/x8AZnOCg9sUtmwiiHr+j+/Arl/+PSqQa8RrB9tMQXtNFchKDkHyBA3Tl9qsqmh6XsRiasZN7blo6E6g9Je8I9SS20LsSQCxbLxtqqnGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtFl7MrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtFl7MrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D33FC4CEF5;
	Sat, 25 Oct 2025 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409045;
	bh=pEsF0uFZavTEih5HOyMhLFtNWeMgC3Luz2do/MeGJOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtFl7MrAO8Gj9B7uf/HMMfT7MvOlq9kMzYAkP0wS2Mx7ZQTzJd5NvIVcuoVgpXaNC
	 rDKPHbqsrhzT0qLHzLtQ42nezMnBxg78uRWMxwOcB9kdu4A44siO223yWJ8DpBKnlk
	 dFDUnP0IpmqqgmpMxmr4tF/9x1GQqgbWYHG5V/1fUwvt7YMZTG//F4baP4Jh29EvGY
	 noaLw1jeChiW6GmgVIzRL9FeqPHNVtmovVi3TjCpRml19egPVjfDPvUvyRHHbEl3tx
	 pjLZOOqlGfSdyBQiB5pAaXSeO+SbhUftXvJiCfpg4OU6+6zKHVBrdb7JZfTYYX/TPF
	 4peBheAh9nl1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Stanley.Yang" <Stanley.Yang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sathishkumar.sundararaju@amd.com,
	leo.liu@amd.com,
	Mangesh.Gadre@amd.com,
	lijo.lazar@amd.com,
	alexandre.f.demers@gmail.com,
	FangSheng.Huang@amd.com,
	sonny.jiang@amd.com,
	Boyuan.Zhang@amd.com,
	Jesse.Zhang@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Fix vcn v5.0.1 poison irq call trace
Date: Sat, 25 Oct 2025 11:56:52 -0400
Message-ID: <20251025160905.3857885-181-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Stanley.Yang" <Stanley.Yang@amd.com>

[ Upstream commit b1b29aa88f5367d0367c8eeef643635bc6009a9a ]

Why:
    [13014.890792] Call Trace:
    [13014.890793]  <TASK>
    [13014.890795]  ? show_trace_log_lvl+0x1d6/0x2ea
    [13014.890799]  ? show_trace_log_lvl+0x1d6/0x2ea
    [13014.890800]  ? vcn_v5_0_1_hw_fini+0xe9/0x110 [amdgpu]
    [13014.890872]  ? show_regs.part.0+0x23/0x29
    [13014.890873]  ? show_regs.cold+0x8/0xd
    [13014.890874]  ? amdgpu_irq_put+0xc6/0xe0 [amdgpu]
    [13014.890934]  ? __warn+0x8c/0x100
    [13014.890936]  ? amdgpu_irq_put+0xc6/0xe0 [amdgpu]
    [13014.890995]  ? report_bug+0xa4/0xd0
    [13014.890999]  ? handle_bug+0x39/0x90
    [13014.891001]  ? exc_invalid_op+0x19/0x70
    [13014.891003]  ? asm_exc_invalid_op+0x1b/0x20
    [13014.891005]  ? amdgpu_irq_put+0xc6/0xe0 [amdgpu]
    [13014.891065]  ? amdgpu_irq_put+0x63/0xe0 [amdgpu]
    [13014.891124]  vcn_v5_0_1_hw_fini+0xe9/0x110 [amdgpu]
    [13014.891189]  amdgpu_ip_block_hw_fini+0x3b/0x78 [amdgpu]
    [13014.891309]  amdgpu_device_fini_hw+0x3c1/0x479 [amdgpu]
How:
    Add omitted vcn poison irq get call.

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Root cause and symptom:
  - vcn_v5_0_1 enables the VCN poison IRQ source in sw_init via
    `amdgpu_irq_add_id()` (drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c:100),
    and disables it in hw_fini via `amdgpu_irq_put()`
    (drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c:288). However, it never
    enables the IRQ at init time (i.e., no `amdgpu_irq_get()`), so the
    `amdgpu_irq_put()` in hw_fini hits the WARN in `amdgpu_irq_put()`
    when the IRQ wasn’t enabled, matching the call trace in the commit
    message (invalid op from WARN_ON in IRQ put).
  - The WARN is explicitly emitted by `amdgpu_irq_put()` when the IRQ
    isn’t enabled: drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:619.

- What the patch does:
  - VCN: Adds the missing `amdgpu_irq_get()` for the poison IRQ in
    `vcn_v5_0_1_ras_late_init()` so the later `amdgpu_irq_put()` in
    `vcn_v5_0_1_hw_fini()` is balanced.
    - Before: `vcn_v5_0_1_ras_late_init()` only called
      `amdgpu_ras_bind_aca()` and returned
      (drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c:1593).
    - After (per patch): if RAS is supported and `ras_poison_irq.funcs`
      is set, call `amdgpu_irq_get(adev,
      &adev->vcn.inst->ras_poison_irq, 0)`. This mirrors the established
      pattern in the generic helper `amdgpu_vcn_ras_late_init()`
      (drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c:1214), which performs the
      `amdgpu_irq_get()` per instance. vcn_v5_0_1 overrides the generic
      ras_late_init and had omitted this step; the patch restores this
      missing piece.
  - JPEG: Reorders operations in `jpeg_v5_0_1_ras_late_init()` to bind
    ACA before enabling the poison IRQ. While that JPEG v5.0.1 file may
    not exist on all branches, the change is a benign ordering fix that
    keeps RAS/ACA setup consistent before enabling the IRQ.

- Why this is a correct and minimal fix:
  - The call trace shows a WARN in `amdgpu_irq_put()` due to an
    unbalanced put; adding a matching `amdgpu_irq_get()` in
    ras_late_init is the smallest correct change to restore balance.
  - The guard `amdgpu_ras_is_supported(adev, ras_block->block) &&
    adev->vcn.inst->ras_poison_irq.funcs` ensures the get only occurs
    when RAS is supported and the IRQ source is correctly set up,
    minimizing risk.
  - Other VCN versions rely on the generic `amdgpu_vcn_ras_late_init()`
    which already does an `amdgpu_irq_get()`; this change simply brings
    vcn_v5_0_1 in line with the established pattern and with its own
    `hw_fini` which unconditionally calls `amdgpu_irq_put()` when RAS is
    supported (drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c:288).

- Backport suitability:
  - Fixes a real user-visible bug (WARN/trace on shutdown/suspend/reset
    paths), confirmed by the provided stack trace.
  - Small, self-contained, and localized to the AMDGPU VCN/JPEG RAS init
    path.
  - No API/ABI or architectural changes; no feature additions.
  - Aligns behavior with other IP blocks and the generic RAS late init
    code path.
  - Low regression risk: only enables an IRQ that is already registered
    and later disabled; gated by RAS support and presence of IRQ funcs.

- Specific code references to support the analysis:
  - Missing get in vcn v5.0.1:
    drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c:1593
  - Unbalanced put causing WARN:
    drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c:288
  - WARN in `amdgpu_irq_put()` when IRQ not enabled:
    drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:619
  - Correct generic pattern (does get in late init):
    drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c:1214
  - VCN poison IRQ registered in sw_init (needs get to enable):
    drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c:119

Given the above, this commit is an important, minimal-risk bugfix and
should be backported to stable trees that contain VCN/JPEG 5.0.1.

 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c | 10 +++++-----
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c  |  7 +++++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
index 54523dc1f7026..03ec4b741d194 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -1058,6 +1058,11 @@ static int jpeg_v5_0_1_ras_late_init(struct amdgpu_device *adev, struct ras_comm
 	if (r)
 		return r;
 
+	r = amdgpu_ras_bind_aca(adev, AMDGPU_RAS_BLOCK__JPEG,
+				&jpeg_v5_0_1_aca_info, NULL);
+	if (r)
+		goto late_fini;
+
 	if (amdgpu_ras_is_supported(adev, ras_block->block) &&
 		adev->jpeg.inst->ras_poison_irq.funcs) {
 		r = amdgpu_irq_get(adev, &adev->jpeg.inst->ras_poison_irq, 0);
@@ -1065,11 +1070,6 @@ static int jpeg_v5_0_1_ras_late_init(struct amdgpu_device *adev, struct ras_comm
 			goto late_fini;
 	}
 
-	r = amdgpu_ras_bind_aca(adev, AMDGPU_RAS_BLOCK__JPEG,
-				&jpeg_v5_0_1_aca_info, NULL);
-	if (r)
-		goto late_fini;
-
 	return 0;
 
 late_fini:
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
index d8bbb93767318..cb560d64da08c 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -1608,6 +1608,13 @@ static int vcn_v5_0_1_ras_late_init(struct amdgpu_device *adev, struct ras_commo
 	if (r)
 		goto late_fini;
 
+	if (amdgpu_ras_is_supported(adev, ras_block->block) &&
+		adev->vcn.inst->ras_poison_irq.funcs) {
+		r = amdgpu_irq_get(adev, &adev->vcn.inst->ras_poison_irq, 0);
+		if (r)
+			goto late_fini;
+	}
+
 	return 0;
 
 late_fini:
-- 
2.51.0

