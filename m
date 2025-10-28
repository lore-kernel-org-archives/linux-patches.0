Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238591D88B4;
	Tue, 28 Oct 2025 00:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612019; cv=none; b=P4tfrPAsdvwGVnhkbCQIfwdBdxDlts/XI4cPZAV21n0hZlJPnMu947qGmxQ9Rhe7NCtdwOqAxqj4UamnLA5N4P4NLOu+fV5zUKB4N6izUxk/jSn/HrS82KLB900so+beCaVIWUJWwQV58KoGa92ZviVW2Ng+7cPmEU5MLXDxo1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612019; c=relaxed/simple;
	bh=r2wXvo+P2AZeV+AzYgn8dHYZZMwWtNXLLHu+tj14hEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WSspvPa6IwFofXLYq2+iu+bS3EVc72HN1z/n8jrzDoSDF08KaSa94bwhh8hPSbzeIvNeZDKbzYwKSRTfrMw4t33/zW0IkYL+J8TV/hL/53KZ/aoVE8xCiDTEq7tmUOOQ3pUJTHsEaBW0073Wt8am7i08oBldFWkVu9l3DfPtGYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nNprggB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nNprggB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784B2C4CEF1;
	Tue, 28 Oct 2025 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761612018;
	bh=r2wXvo+P2AZeV+AzYgn8dHYZZMwWtNXLLHu+tj14hEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNprggB/AaFI7/4ktjQjMGh1iKeZZK3XOlquhyj0y0LmqMeDuluO2W8xTKTyKXm01
	 P1lU0Q5/sppv/5dnHRrykX/pHPw6c8SAZw949YmH6XAQcM7yhgQ2S2Hi2AQHlpLB6k
	 HP+KTS6HiXQkLsOCggWdU+WV76wrIsS7kLISfzNkFtJAxoVH0sLBqXELrXWI4uItHZ
	 PAIuob8QP8BzGKbFctDH7iwWYOo83KZGkw75V+wzdlQZYbZilKcYNUNpROZyF74M80
	 5IHfcrQ0CSd6taxfa5xqmWmUu4FWrIp8ZFbIhLgXS/6iw4GLQGCwYP8Opkj66Onj2y
	 HFTkqQ4HoTARA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sunil.khatri@amd.com,
	lijo.lazar@amd.com,
	alexandre.f.demers@gmail.com,
	chris@rudorff.com,
	boyuan.zhang@amd.com,
	mario.limonciello@amd.com
Subject: [PATCH AUTOSEL 6.17-6.1] drm/amd/pm: Disable MCLK switching on SI at high pixel clocks
Date: Mon, 27 Oct 2025 20:39:00 -0400
Message-ID: <20251028003940.884625-16-sashal@kernel.org>
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

[ Upstream commit 5c05bcf6ae7732da1bd4dc1958d527b5f07f216a ]

On various SI GPUs, a flickering can be observed near the bottom
edge of the screen when using a single 4K 60Hz monitor over DP.
Disabling MCLK switching works around this problem.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis using semantic code analysis tools
and examining the kernel repository, here is my assessment:

## **BACKPORT RECOMMENDATION: YES**

## Detailed Analysis:

### 1. **Semantic Code Analysis Findings:**

**Tool: mcp__semcode__find_function**
- Located function `si_apply_state_adjust_rules` in
  drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
- Function is part of AMD SI GPU power management infrastructure
- Called by `si_dpm_pre_set_power_state` which is registered as a power
  management callback

**Tool: mcp__semcode__find_callers**
- `si_apply_state_adjust_rules` has only 2 callers (appears to be
  duplicate entries)
- Call path: Power management system → `si_dpm_pre_set_power_state` →
  `si_apply_state_adjust_rules`
- The function is part of the standard DRM/power management callback
  chain

**Tool: mcp__semcode__grep_functions**
- Found that `disable_mclk_switching` already exists as a local variable
  in the function
- The change modifies existing logic flow rather than introducing new
  infrastructure
- There's an identical function in the legacy radeon driver
  (drivers/gpu/drm/radeon/)

**Tool: mcp__semcode__find_calls**
- Function calls standard helper functions:
  `btc_adjust_clock_combinations`, `btc_apply_voltage_dependency_rules`,
  etc.
- No new dependencies introduced
- Uses existing `high_pixelclock_count` variable that was already
  present

### 2. **Critical Context Discovery:**

Through git log examination, I discovered a **related commit
(63499c7ed46f9)** that was **already backported** by the autosel
process. This commit:
- Added the `high_pixelclock_count` infrastructure and detection logic
- Fixed flickering when **TWO** 4K 60Hz displays are connected to
  **Oland specifically**
- Has "Fixes: 841686df9f7d" tag and was signed off by Sasha Levin
- Commit message includes "[ Upstream commit
  7009e3af0474aca5f64262b3c72fb6e23b232f9b ]"

The current commit (5c05bcf6ae773) is a **companion fix** that:
- Uses the **same infrastructure** already backported
- Fixes flickering for **ANY SINGLE** high-resolution display on **all
  SI GPUs**
- Addresses a **more common scenario** than the previously backported
  fix

### 3. **Code Changes Analysis:**

The change adds only **5 lines** in one location:
```c
if (high_pixelclock_count) {
    /* Work around flickering lines at the bottom edge
     - of the screen when using a single 4K 60Hz monitor.
     */
    disable_mclk_switching = true;  // <-- NEW LINE

    /* On Oland, we observe some flickering when two 4K 60Hz... */
    if (high_pixelclock_count > 1 && adev->asic_type == CHIP_OLAND)
        disable_sclk_switching = true;
}
```

This is extremely localized and low-risk.

### 4. **Impact Assessment:**

- **User Impact**: HIGH - Fixes visible display corruption (flickering
  at bottom of screen)
- **Hardware Scope**: SI generation AMD GPUs (Tahiti, Pitcairn, Cape
  Verde, Oland, Hainan ~2012-2013)
- **Risk Level**: LOW - Conservative workaround that disables a power-
  saving feature
- **Side Effect**: Slightly higher power consumption with high pixel
  clock displays, but fixes critical visual bug
- **Regression Risk**: MINIMAL - Only affects power state selection
  logic, doesn't change core GPU functionality

### 5. **Backport Justification:**

✅ **Bug Fix**: Fixes user-visible display corruption
✅ **Small & Contained**: 5 lines added to one function
✅ **No New Features**: Pure bug fix workaround
✅ **No Architectural Changes**: Uses existing infrastructure
✅ **Completes a Series**: Related fix already backported
✅ **Common Scenario**: Single 4K 60Hz monitor more common than dual
monitors
✅ **Low Risk**: Conservative change that disables a feature to fix a bug
✅ **Reviewed**: Reviewed-by Alex Deucher (AMD maintainer)
✅ **Hardware Specific**: Only affects legacy SI GPUs, isolated impact

### 6. **Notable Points:**

- **Missing Stable Tags**: The commit lacks "Cc: stable@vger.kernel.org"
  or "Fixes:" tags, likely an oversight
- **Part of Fix Series**: This completes the SI DPM flickering
  workaround series
- **Infrastructure Already Backported**: The `high_pixelclock_count`
  detection logic is already in stable trees
- **Active Maintenance**: Author has made multiple fixes to SI DPM code
  recently
- **Broader Applicability**: Previous fix was Oland-specific, this helps
  **all SI GPUs**

### 7. **Conclusion:**

This commit should **definitely be backported** to stable kernel trees.
It fixes a user-visible bug (display flickering) affecting users with 4K
60Hz monitors on SI generation AMD GPUs. The fix is small, safe, and
complements a related fix that was already backported. The lack of
explicit stable tags appears to be an oversight rather than an
intentional exclusion. Users who received the previous backport
(63499c7ed46f9) may still experience flickering with a single 4K
monitor—this commit addresses that scenario.

**Backport Status: YES** - High priority for stable trees to complete
the SI DPM flickering workaround series.

 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index 4236700fc1ad1..9281aca0e64af 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3504,6 +3504,11 @@ static void si_apply_state_adjust_rules(struct amdgpu_device *adev,
 	 * for these GPUs to calculate bandwidth requirements.
 	 */
 	if (high_pixelclock_count) {
+		/* Work around flickering lines at the bottom edge
+		 * of the screen when using a single 4K 60Hz monitor.
+		 */
+		disable_mclk_switching = true;
+
 		/* On Oland, we observe some flickering when two 4K 60Hz
 		 * displays are connected, possibly because voltage is too low.
 		 * Raise the voltage by requiring a higher SCLK.
-- 
2.51.0

