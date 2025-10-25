Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4511F1306;
	Sat, 25 Oct 2025 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408593; cv=none; b=OP/a8nmAPPMNsUakk2qZSMYp4Gutf02t8s7KqIc0Z0CanepOZ6mT6VtnSu+qD3hsK0j6dZnRlO9JzfdlXTUye6IDBQ3zJkkzIutdEG0NV/iK4LrASTOXCgGkvWdbg2KJY/KC8ioX2gXt6C72Trwtf9C+P/tlmJnt/JIWMtoEaaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408593; c=relaxed/simple;
	bh=OdZA1HiWmkqu4807gPzRUy10prSohL7QPKQXIED9hgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oboxrFdqbLkLT8eX2DB95dPSe+fUfaX/7QW+39Wl8o9oZOSgOYXJo5w86qb/eBJKuXeWMSLvvGAGu61mqzRXZuHfJGAgb26TRpn5/MvFlMR9uaDMMHJVgQUA0TlhYjiDd9jZmqyUgPJ3c/jM0nfNMms0ZFFLWUSTrArj/gn0g0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zv5pjKuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zv5pjKuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFF4C4CEF5;
	Sat, 25 Oct 2025 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408592;
	bh=OdZA1HiWmkqu4807gPzRUy10prSohL7QPKQXIED9hgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zv5pjKuoZcN/NuT+kcWcX8uzvQTmkP9sVUnGN4rWoBXqOf9cMQytCckje2GQ3xcQO
	 8I4DvO8mHiK4DTXx29Cy1rnJAaCPDSuIvRBToxj7Cg9vC9nQ5I74hKScdgwitmzlih
	 wAYfmZkWoaQ6un3A1k/knp8Bt3WDmOJSQk6oGBoLj2+TrFalQU/662z9Z4k4mg3ZiT
	 ZI3uY09OXDNHgOaPqoX6+D1JS7Tlg3lg8MyX/0jPxPcdxLgK3tLBYK/fjL5fnvC1SL
	 uwSL/7Euz6B31++rvQXLkqWF1CbPFT+OY0En06PpgEk5uQzUSRSLK8jBJwn1vJvngr
	 MwnHsbxrPpj3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yunxiang Li <Yunxiang.Li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	lijo.lazar@amd.com,
	christian.koenig@amd.com,
	Hawking.Zhang@amd.com,
	mario.limonciello@amd.com,
	alexandre.f.demers@gmail.com,
	cesun102@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: skip mgpu fan boost for multi-vf
Date: Sat, 25 Oct 2025 11:54:06 -0400
Message-ID: <20251025160905.3857885-15-sashal@kernel.org>
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

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit ba5e322b2617157edb757055252a33587b6729e0 ]

On multi-vf setup if the VM have two vf assigned, perhaps from two
different gpus, mgpu fan boost will fail.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

- What changed and where:
  - The condition in `amdgpu_device_enable_mgpu_fan_boost()` now skips
    enabling MGPU fan boost when running in SR-IOV multi-VF mode by
    adding `amdgpu_sriov_multi_vf_mode(adev)` to the exclusion check:
    - Old: only skips APUs
    - New: also skips multi-VF VFs
    - File: drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:3373
  - This function is invoked during late init:
    - File: drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:3455

- Why the change is needed (bug context and behavior today):
  - In SR-IOV multi-VF mode, the SMU power management is intentionally
    disabled:
    - File: drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c:1868
      - In `smu_hw_init()`: `if (amdgpu_sriov_multi_vf_mode(adev)) {
        smu->pm_enabled = false; return 0; }`
  - Consequently, attempting to enable MGPU fan boost from a VF returns
    `-EOPNOTSUPP`:
    - File: drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c:3668
      - In `smu_enable_mgpu_fan_boost()`: returns `-EOPNOTSUPP` when
        `!smu->pm_enabled || !smu->adev->pm.dpm_enabled`
  - Today, `amdgpu_device_enable_mgpu_fan_boost()` breaks out of its
    loop on the first failure (`if (ret) break;`), which:
    - Spams the logs with “enable mgpu fan boost failed” messages.
    - Can prevent enabling MGPU fan boost for other eligible GPUs in
      mixed setups because it stops at the first error.
    - File: drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:3373

- Why this is safe and suitable for stable:
  - Small and contained: one conditional update, no API or structural
    changes; uses existing and widely used macro
    `amdgpu_sriov_multi_vf_mode()`:
    - Macro: drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h:27
  - Matches established pattern: AMDGPU already disables many PM
    features in multi-VF mode and guards calls on `pm_enabled`.
  - Prevents a known failure path and avoids breaking out early in the
    loop, improving behavior without changing functionality for
    supported cases.
  - No behavioral change for PFs or single-VF (“PP_ONE_VF”)
    environments; only avoids unsupported operations for multi-VF VFs.

- Stable tree criteria assessment:
  - Fixes a user-visible bug (failed MGPU fan boost attempts and log
    noise; prevents premature loop exit from blocking other devices).
  - Minimal risk and scope; no architectural changes; confined to
    AMDGPU.
  - No new features; purely defensive fix to avoid unsupported
    operations.
  - While there’s no explicit “Fixes:” or “Cc: stable” tag, it is a low-
    risk, clear bug-avoidance change acked by AMD maintainers.

Conclusion: This commit is a good candidate for backport to stable
kernels that have the MGPU fan boost path and
`amdgpu_sriov_multi_vf_mode()` available.

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index dfa68cb411966..097ceee79ece6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3389,7 +3389,7 @@ static int amdgpu_device_enable_mgpu_fan_boost(void)
 	for (i = 0; i < mgpu_info.num_dgpu; i++) {
 		gpu_ins = &(mgpu_info.gpu_ins[i]);
 		adev = gpu_ins->adev;
-		if (!(adev->flags & AMD_IS_APU) &&
+		if (!(adev->flags & AMD_IS_APU || amdgpu_sriov_multi_vf_mode(adev)) &&
 		    !gpu_ins->mgpu_fan_enabled) {
 			ret = amdgpu_dpm_enable_mgpu_fan_boost(adev);
 			if (ret)
-- 
2.51.0

