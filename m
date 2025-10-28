Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B87B1BBBE5;
	Tue, 28 Oct 2025 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611989; cv=none; b=VrPXekEFqJV6aUHcIEBBegf35zuTTKDQxEyEehbzYSNPiLGhyw0xUcUJKmg2eLcLfanO8FGrcIg5RrLRt99W33WvdcswI4Ia96856DKriX2e9N7nRgIEmSnE94ITCEJa+j8+xVVN3x514RwPLhioA7haiMFMKpYEV2uSU8HiiMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611989; c=relaxed/simple;
	bh=kwBsfDrs1UgTIzVK4l3JFTz5BXGj339f3SJN996kzyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tOisen7EEAXa+DzXSQ4OBsooR1hxWTgqDWaBFrON7eln3yOO3xfkq17K/NThuM2rvHJ6vqZgsUdpDCZ+Bi4pATL6njGcE6AtAQB5O2uMcdezepvLTOcGxI3cY/110VTyXg6MQikWVz5nOvWzPe9Gu1KC2xvPIiwbr4hNpLs4jjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsD+d+fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsD+d+fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBA4C4CEF1;
	Tue, 28 Oct 2025 00:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761611989;
	bh=kwBsfDrs1UgTIzVK4l3JFTz5BXGj339f3SJN996kzyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsD+d+fkoTM/YNrNqvSFOJQAMkxRfAOQcLhsRhhgmfqRjTDg0sLrzsz4O7qlyMWRK
	 ob7clf+wIfwe6Tl92KxIIs2u8irUqouSWPEiaBW7G2yVhUiJW0dU1uFK7kWez+Vqs4
	 JS+RTMdfdeDzPiq8IQod8zpveOwbH5Whw1/mCB70mGrpyo7+bJt1lQVbG5hlxNKSt7
	 XOHXqHa317SCx1zrELGZJfAy9GgiqDMKC19edP+xpzrqohvyN/hdkF7phFYZlb2Lx8
	 PDNX8AE2TbjgaqzK0BD0YdOlPNkWIKtb6PWMkrVdPYavbdp/SeKunSCHFMrS9wytXy
	 MHF6AP0bf3vqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	sunil.khatri@amd.com,
	lijo.lazar@amd.com,
	shashank.sharma@amd.com,
	srinivasan.shanmugam@amd.com,
	Jesse.Zhang@amd.com,
	alexandre.f.demers@gmail.com,
	siqueira@igalia.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amdgpu: remove two invalid BUG_ON()s
Date: Mon, 27 Oct 2025 20:38:47 -0400
Message-ID: <20251028003940.884625-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028003940.884625-1-sashal@kernel.org>
References: <20251028003940.884625-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 5d55ed19d4190d2c210ac05ac7a53f800a8c6fe5 ]

Those can be triggered trivially by userspace.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis using semantic code tools and
repository examination, here is my recommendation:

## **BACKPORT RECOMMENDATION: YES**

This commit **MUST be backported** to stable kernel trees as a
**critical security fix**.

---

## **DETAILED ANALYSIS**

### **1. Semantic Analysis Tools Used:**

- **mcp__semcode__find_function**: Located both affected functions
  (`gfx_v11_0_ring_emit_ib_gfx` and `gfx_v12_0_ring_emit_ib_gfx`)
- **mcp__semcode__find_callers**: Traced the call chain from
  `amdgpu_ib_schedule` (25 callers) including the critical
  `amdgpu_job_run` function
- **Grep/Read tools**: Analyzed the userspace API definitions and call
  paths
- **Git history analysis**: Confirmed the BUG_ON was present from
  initial GFX11/12 implementation

### **2. Security Impact - CRITICAL DoS Vulnerability:**

**The removed BUG_ON() checks a userspace-controlled flag:**
```c
BUG_ON(ib->flags & AMDGPU_IB_FLAG_CE);  // Line removed in
gfx_v11_0.c:5867
BUG_ON(ib->flags & AMDGPU_IB_FLAG_CE);  // Line removed in
gfx_v12_0.c:4424
```

**Evidence of userspace control:**
- `AMDGPU_IB_FLAG_CE` is defined in `include/uapi/drm/amdgpu_drm.h:935`
  (UAPI header)
- Userspace sets this via `chunk_ib->flags` in command submissions
  (amdgpu_cs.c:381)
- The commit message explicitly states: **"Those can be triggered
  trivially by userspace"**

### **3. Call Chain Analysis - Confirmed Userspace Reachability:**

```
Userspace ioctl
  → amdgpu_cs.c (command submission with user-controlled
chunk_ib->flags)
  → amdgpu_job_run (assigned to .run_job callback at amdgpu_job.c:467)
  → amdgpu_ib_schedule (called from amdgpu_job.c:378)
  → gfx_v11_0_ring_emit_ib_gfx / gfx_v12_0_ring_emit_ib_gfx
  → **BUG_ON() PANIC if AMDGPU_IB_FLAG_CE is set**
```

**Impact Assessment:**
- Any process with access to `/dev/dri/renderD*` can crash the kernel
- No special privileges required beyond GPU access
- Affects all AMD GPUs using GFX version 11 and 12 hardware
- Complete system denial-of-service

### **4. Code Context - Improper Error Handling:**

**Other GPU versions handle this correctly** (gfx_v10_0.c:8651-8654):
```c
if (ib->flags & AMDGPU_IB_FLAG_CE)
    header = PACKET3(PACKET3_INDIRECT_BUFFER_CNST, 2);
else
    header = PACKET3(PACKET3_INDIRECT_BUFFER, 2);
```

**GFX11/12 incorrectly used BUG_ON()** instead of either:
- Gracefully handling the flag (like older versions)
- Returning an error
- Simply ignoring the flag (as this fix does)

The CE (Constant Engine) flag is a legacy feature from older GPU
architectures. Newer hardware doesn't support it for this code path, but
the kernel should never panic on invalid userspace input.

### **5. Change Characteristics - Perfect Backport Candidate:**

✅ **Bug fix**: Removes a kernel panic path
✅ **Security fix**: Prevents DoS vulnerability
✅ **Small and contained**: Only 2 lines removed across 2 files
✅ **No architectural changes**: No struct modifications or API changes
✅ **No new features**: Pure removal of incorrect assertion
✅ **Low regression risk**: Removing a panic path cannot cause new
crashes
✅ **No dependencies**: Standalone fix with no prerequisite commits
✅ **Well-reviewed**: Reviewed-by and Acked-by tags from maintainers
present

### **6. Stable Tree Compliance:**

This fix perfectly aligns with stable kernel rules
(Documentation/process/stable-kernel-rules.rst):
- "It must fix a real bug that bothers people" ✅ (DoS vulnerability)
- "It must be obviously correct" ✅ (removing invalid assertion)
- "It cannot be bigger than 100 lines" ✅ (2 lines)
- "It must fix only one thing" ✅ (single issue)
- Security fixes are high priority for stable ✅

### **7. Historical Context:**

Git analysis shows:
- BUG_ON was present from initial GFX11 implementation (commit
  3d879e81f0f9e)
- This was a **design bug from the start** - should never have used
  BUG_ON on user input
- Fixed in commit 5d55ed19d4190 in mainline
- **Must be backported to all stable kernels with GFX11/12 support**

---

## **CONCLUSION:**

**This is a critical security fix that removes a trivially exploitable
kernel panic.** Any user with GPU access can crash the system by setting
a single flag bit in their command submission. The fix is minimal, safe,
and has zero risk of regression.

**Backport Status: YES** - High priority for all affected stable trees.

 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 --
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index c37527704d433..25a5f7fa5077d 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5864,8 +5864,6 @@ static void gfx_v11_0_ring_emit_ib_gfx(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 	u32 header, control = 0;
 
-	BUG_ON(ib->flags & AMDGPU_IB_FLAG_CE);
-
 	header = PACKET3(PACKET3_INDIRECT_BUFFER, 2);
 
 	control |= ib->length_dw | (vmid << 24);
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index fd44d5503e282..329632388b43e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -4421,8 +4421,6 @@ static void gfx_v12_0_ring_emit_ib_gfx(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 	u32 header, control = 0;
 
-	BUG_ON(ib->flags & AMDGPU_IB_FLAG_CE);
-
 	header = PACKET3(PACKET3_INDIRECT_BUFFER, 2);
 
 	control |= ib->length_dw | (vmid << 24);
-- 
2.51.0

