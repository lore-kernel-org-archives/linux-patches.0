Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D155F1D88B4;
	Tue, 28 Oct 2025 00:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612012; cv=none; b=MZjneHz+yYXiTPNvgCQHC6b18kMxdz5qpIpdApW9OJYAmt5ID+T4sxiECh4SOpIAyLMYysw5yRxn5liBfh+X0O8uSSywr5byWpjq1b4dWimXfJpkM+N3oAV0s0KiMbd5pD2OuX0UybkRlmwsQNP+3LZQRG7TEmYie4kQH9j2+OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612012; c=relaxed/simple;
	bh=CzG6Uymt0CzEfY0VhQZt0JwAL4Jxm9yelE9yo5V7xX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eYIfBIlRHA3TsvTMFiqqmHhW9v14dofghKqbWmZIr8S3PnH6w9JQZYNvYFhiMetXOQiJjRI0f0kkQClzeNFI4l3QRnrUqgGE/v6WnOojRXJVcRHN5mpoJbE24vzAhjsGkZAhzO7dk9i4gWGPiYbnW5VbznZ7+ekh500HulGUX9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AOD65IuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AOD65IuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85268C4CEF1;
	Tue, 28 Oct 2025 00:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761612012;
	bh=CzG6Uymt0CzEfY0VhQZt0JwAL4Jxm9yelE9yo5V7xX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOD65IuXNomiDSWIKiQe3gsc9IfjZb59eqUh7YzHxJMj0es0SeW7gXxX4BDh/S8qo
	 4B03t55MqnvLV4y4VVE/HbQJqjsBGUSXf+SjaruR7NX1kstSCKOsOG90rl+p+kGGCJ
	 ynErY11kXvdBVN3HWS4n2QqhC++5VA4LMt+2pqQD6NXGwjkZPcvSU/AEtwHLT0//ht
	 WnaKjFUE9gABPPlXpWdZJYEZRClRObSyuNdmDWFQoTTkw7Y092P+zDkyf14mmfpvhk
	 zbkNMrhEg2IEiGwme9GZ1jzCvst5uNoCbqL42HIZKH61ZPIiBGLU7f2gvxekMlkN5t
	 W6MPInw03UsYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	lijo.lazar@amd.com,
	christian.koenig@amd.com,
	Hawking.Zhang@amd.com,
	mario.limonciello@amd.com,
	alexandre.f.demers@gmail.com,
	cesun102@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amd: Disable ASPM on SI
Date: Mon, 27 Oct 2025 20:38:58 -0400
Message-ID: <20251028003940.884625-14-sashal@kernel.org>
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

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 7bdd91abf0cb3ea78160e2e78fb58b12f6a38d55 ]

Enabling ASPM causes randoms hangs on Tahiti and Oland on Zen4.
It's unclear if this is a platform-specific or GPU-specific issue.
Disable ASPM on SI for the time being.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive semantic analysis of this commit, here is my
assessment:

## **RECOMMENDATION: YES**

This commit should be backported to stable kernel trees.

---

## **DETAILED ANALYSIS**

### **1. Semantic Code Analysis Performed**

**Tools Used:**
- `mcp__semcode__find_function`: Located the modified
  `amdgpu_device_aspm_support_quirk()` function
- `mcp__semcode__find_callers`: Traced the impact scope through the call
  graph
- `mcp__semcode__find_callchain`: Analyzed complete call chains to
  understand initialization paths
- Git history analysis: Examined related ASPM commits and patterns

**Key Findings:**

**Call Graph Analysis:**
```
amdgpu_device_aspm_support_quirk() [MODIFIED]
  ↓ called by
amdgpu_device_should_use_aspm() [1 caller]
  ↓ called by (9 callers across multiple GPU generations)
  ├─ si_program_aspm() [SI generation - directly affected]
  ├─ vi_program_aspm() [VI generation]
  ├─ cik_program_aspm() [CIK generation]
  ├─ nv_program_aspm() [Navi generation]
  ├─ soc15_program_aspm() [SoC15 generation]
  └─ ... and 4 more hardware initialization functions
```

The change adds an early return when `adev->family == AMDGPU_FAMILY_SI`,
which specifically targets Southern Islands GPUs (Tahiti, Oland, Verde,
Pitcairn, Hainan from ~2012).

### **2. Code Changes Analysis**

**Change Size:** Minimal - only 7 lines added (6 code + 1 blank)
- Lines added: `+6`
- Lines removed: `0`
- Files modified: `1`
  (drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:1883-1889)

**Change Type:** Conservative quirk addition
- Uses existing quirk infrastructure (function already handles Intel
  Alder Lake/Raptor Lake quirks)
- No refactoring or architectural changes
- Simply adds hardware-specific condition at function entry

### **3. Bug Impact Assessment**

**Severity:** **CRITICAL** - Random system hangs
- Symptom: Random hangs on Tahiti and Oland GPUs
- Platform: Zen4 (AMD Ryzen 7000 series)
- Affected Hardware: SI family GPUs (AMDGPU_FAMILY_SI)

**User Exposure:**
From call chain analysis, the code path is triggered during:
- Hardware initialization (`si_common_hw_init` at
  drivers/gpu/drm/amd/amdgpu/si.c:2640)
- Executed automatically when SI GPU is present in system
- No special user action required to trigger the bug

**Impact Scope:**
- **Narrow hardware scope**: Only SI family GPUs (12+ year old hardware,
  but still in use)
- **Platform-specific trigger**: Issues observed on Zen4 platforms
- **Well-contained fix**: Isolated to ASPM quirk handling code

### **4. Backport Suitability - Positive Indicators**

✅ **Fixes Critical Stability Bug**: Random system hangs are severe
issues affecting system usability

✅ **Minimal Change Size**: Only 7 lines added, zero lines removed -
extremely low complexity

✅ **No Dependencies**: Uses existing code infrastructure
(`AMDGPU_FAMILY_SI` constant, quirk pattern)

✅ **Conservative Fix**: Disables problematic feature rather than
attempting complex behavior changes

✅ **Low Regression Risk**:
- Only affects SI generation GPUs
- Disabling ASPM is safe (may slightly increase power consumption but
  prevents hangs)
- No code path changes for other GPU families

✅ **Follows Established Pattern**:
From git history analysis, found similar ASPM quirk commits:
- `c770ef19673fb` - "disable ASPM in some situations"
- `d9b3a066dfcd3` - "Exclude dGPUs in eGPU enclosures from DPM quirks"
- `2757a848cb0f1` - "Explicitly disable ASPM when dynamic switching
  disabled"

✅ **Clear Hardware Scope**: Specifically targets well-defined hardware
(SI family)

✅ **Stable Tree Compliant**:
- Pure bug fix, not a feature addition
- No architectural changes
- Fixes user-visible problem

### **5. Backport Suitability - Considerations**

⚠️ **No Explicit Cc: stable Tag**: Commit lacks `Cc:
stable@vger.kernel.org` tag
- This may be intentional (let it bake in mainline first)
- Or could be an oversight given the severity

⚠️ **Root Cause Uncertainty**: Comment states "unclear if platform-
specific or GPU-specific issue"
- However, the conservative fix (disable ASPM) is appropriate regardless
- This uncertainty doesn't affect fix correctness

⚠️ **Affects Legacy Hardware**: SI GPUs from 2012
- But users still run this hardware on modern Zen4 platforms
- Hangs make systems unusable, so fix is valuable

### **6. Technical Correctness**

**Function Behavior:**
- `amdgpu_device_aspm_support_quirk()` returns `true` when ASPM should
  be **disabled** (quirk detected)
- Adding SI family check causes function to return `true` early
- This propagates through `amdgpu_device_should_use_aspm()` which
  returns `false` when quirk detected
- Result: `si_program_aspm()` exits early without programming ASPM
  registers

**Semantic Verification:**
Checked the function at commit `7a899fb4de29c` (before this change) - it
only handled Intel Alder Lake/Raptor Lake quirks. The new SI quirk
follows identical pattern.

### **7. Historical Context**

From git log analysis:
- First appeared in v6.18-rc2 (October 2025)
- Part of ongoing ASPM quirk management in AMD GPU driver
- Follows 2+ year history of ASPM-related fixes in this subsystem
- Reviewed by Alex Deucher (AMD maintainer)

### **8. Final Assessment**

**BACKPORT: YES**

**Justification:**
1. **Critical stability fix** resolving random system hangs
2. **Minimal risk** due to small, contained change
3. **Clear benefit** for users with SI GPUs on Zen4 platforms
4. **Proper technical approach** using established quirk infrastructure
5. **No side effects** on other hardware generations
6. **Conservative solution** that safely disables problematic feature

**Recommendation:** This commit should be backported to all active
stable kernel trees that support SI generation AMD GPUs (likely 5.x and
6.x stable series). The fix is low-risk and provides significant
stability improvements for affected users.

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c8459337fcb89..e01264d644701 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1879,6 +1879,13 @@ static bool amdgpu_device_pcie_dynamic_switching_supported(struct amdgpu_device
 
 static bool amdgpu_device_aspm_support_quirk(struct amdgpu_device *adev)
 {
+	/* Enabling ASPM causes randoms hangs on Tahiti and Oland on Zen4.
+	 * It's unclear if this is a platform-specific or GPU-specific issue.
+	 * Disable ASPM on SI for the time being.
+	 */
+	if (adev->family == AMDGPU_FAMILY_SI)
+		return true;
+
 #if IS_ENABLED(CONFIG_X86)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 
-- 
2.51.0

