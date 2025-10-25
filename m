Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863E3304BD3;
	Sat, 25 Oct 2025 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409065; cv=none; b=dmzOt2/mXN8sY10WDeTQXKxn6Mnwguj0cKUp2BSGQJEs4WjELHSHl3PV7Sm8MkMcTN5786sw77BHoDelZP8IT4J6ZprvFxx8brZBz0U2cixG69IwtksjYv9FU441YWmpghA0NLzHrIM0Mx1hgTDCd6bZT95YbSEMYMBk52bIeGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409065; c=relaxed/simple;
	bh=xLEAGpUA+6njCZ72uMJ35SEDyaVEMEzRvt81Q0Ta1ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oBAz4JWD+bWfRLJkey1TcxDeB67XWKmYIHHafAlIIouNTJIyYqcf+zXZ8FNbiF2a2FjHMaAyShbYoIgx6/C4zgkr8tRKdWAuIknRCz3GF68+jFf6JGuu93KzEDXRJjm5guAnOlSV3b7v3elvX5pbTT3Azj/mW/xkkvwKyk09gFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PHfv7cHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PHfv7cHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796E2C4CEFB;
	Sat, 25 Oct 2025 16:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409065;
	bh=xLEAGpUA+6njCZ72uMJ35SEDyaVEMEzRvt81Q0Ta1ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHfv7cHWbSlklMl9qVwXjySolfln8K/sRGfa+RJtLOYberULz8H6Xc4yC7/TS12kk
	 CcW9x/uxnLvgiRNwRUDiU1n2UELQmhJXGLM/WcM0hm0dAN9n20AesVl+jzThxKKExz
	 troYMSbkVyd2GQQEL2+Fu8EaKsqgmTK9V2hJAMinOiMbGda/FvTBnuU9SPaLd/P9Bo
	 9MPvxK81T983ay3e6yVnkehSbPFJZj2oyVxvdkuEZkUmPpEbDUkbbenaWBfzmVJYLJ
	 3eWntnyNQZjpHX0LSUn4aGPw8Qthw3BnjPM3Na4WmUm9IKlR2YhT2BDSMUeZj3RFIO
	 zlJBs8RMsxrrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yang Wang <kevinyang.wang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/amd/pm: refine amdgpu pm sysfs node error code
Date: Sat, 25 Oct 2025 11:57:00 -0400
Message-ID: <20251025160905.3857885-189-sashal@kernel.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit cf32515a70618c0fb2319bd4a855f4d9447940a8 ]

v1:
Returns different error codes based on the scenario to help the user app understand
the AMDGPU device status when an exception occurs.

v2:
change -NODEV to -EBUSY.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - The function `amdgpu_pm_dev_state_check()` now returns `-EBUSY`
    instead of `-EPERM` when the device is in GPU reset or system
    suspend:
    - `drivers/gpu/drm/amd/pm/amdgpu_pm.c:112`: `if
      (amdgpu_in_reset(adev)) return -EBUSY;` (was `-EPERM`)
    - `drivers/gpu/drm/amd/pm/amdgpu_pm.c:115`: `if (adev->in_suspend &&
      !runpm_check) return -EBUSY;` (was `-EPERM`)
  - This function gates access in `amdgpu_pm_get_access()` and
    `amdgpu_pm_get_access_if_active()`:
    - `drivers/gpu/drm/amd/pm/amdgpu_pm.c:133`: `ret =
      amdgpu_pm_dev_state_check(adev, true);`
    - `drivers/gpu/drm/amd/pm/amdgpu_pm.c:153`: `ret =
      amdgpu_pm_dev_state_check(adev, false);`
  - Numerous PM-related sysfs show/store handlers directly return the
    `ret` from these helpers (e.g., `amdgpu_get_power_dpm_state()`
    returns `ret` on failure), so the errno visible to userspace changes
    from `-EPERM` to `-EBUSY` when the device is resetting or suspended
    (example call and return: `drivers/gpu/drm/amd/pm/amdgpu_pm.c:217`
    onward in the `amdgpu_get_power_dpm_state` path shows the pattern of
    `ret = ...; if (ret) return ret;`).

- Why it’s a bug fix suitable for stable
  - Correctness/semantics: `-EPERM` indicates a permissions problem,
    which is misleading here; the device is temporarily unavailable due
    to reset or suspend. `-EBUSY` accurately communicates a transient
    busy state and invites retry, which aligns better with userspace
    expectations and error handling.
  - Scope and risk: The change is tiny and localized to return codes in
    a single helper. It does not alter call sequences, state checks, PM
    flows, or locking. No ABI or uAPI additions, no
    structural/architectural changes.
  - Impacted surface: Only sysfs PM nodes’ errno in specific exceptional
    states. In-kernel callers are not affected (the helpers are
    `static`). Userspace seeing `-EBUSY` instead of `-EPERM` is an
    improvement for diagnostics and retry logic. AMDGPU already returns
    `-EBUSY` in analogous busy conditions elsewhere, so this aligns with
    existing patterns.
  - Stability: No performance, functional, or security regression
    vectors are introduced. The remaining `-EPERM` usage in
    `amdgpu_pm_get_access_if_active()` when the device is not active
    (`drivers/gpu/drm/amd/pm/amdgpu_pm.c:163`) is untouched, keeping
    behavior consistent for that distinct case.

- Backport considerations
  - The patch is self-contained and minimal. If the target stable trees
    already have `amdgpu_pm_dev_state_check()` and the access helpers,
    this applies cleanly. If older trees did the checks inline in each
    sysfs op, the backport would require equivalent one-line
    replacements at those sites; still trivial and low risk.
  - No user-visible feature change; only corrected errno in exceptional
    conditions, which is a common and acceptable class of stable fixes.

Given the small, precise nature of the change, its correctness benefit,
and minimal regression risk, this is a good candidate for stable
backporting.

 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 5fbfe7333b54d..1fca183827c7c 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -110,9 +110,10 @@ static int amdgpu_pm_dev_state_check(struct amdgpu_device *adev, bool runpm)
 	bool runpm_check = runpm ? adev->in_runpm : false;
 
 	if (amdgpu_in_reset(adev))
-		return -EPERM;
+		return -EBUSY;
+
 	if (adev->in_suspend && !runpm_check)
-		return -EPERM;
+		return -EBUSY;
 
 	return 0;
 }
-- 
2.51.0

