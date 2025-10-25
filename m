Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810B8205AB6;
	Sat, 25 Oct 2025 16:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408684; cv=none; b=mt6AiUMRmLyl+494cyrnI6dARHWWlH4yyV8WAQ+xyqnCZ6Qv6KowKghlphkWB3sO4Ut1I3CkU7bEWzi3u3K8a9L+YkFoXkAADadjurMEnz//4JmvlOZUJqnmvr84XTQfSSm4Pl85850FOaJBDmmOOikyFuCYXKOMK+RavZAxJn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408684; c=relaxed/simple;
	bh=vBIAmnhwhGHbrOsu0i0u2AZyabxCLaeqJK7dlKoQKCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6SoJ56jfV3N8qxlxied/u7TT+WdmxOyWvrSX9pHNDs9l1AcolrVdeEXoVpagrWYGYVi6a9KBFF5ZR8DnbEE2cdorRMcIHHOcNYT5+LPqWITeM6EsvGSYLV8w7zwxifCocRm5qbYwJKCeKyvE/RI9EHkbIKKMJuDTAK/xsWwOKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYoko64r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYoko64r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3880C4CEFB;
	Sat, 25 Oct 2025 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408684;
	bh=vBIAmnhwhGHbrOsu0i0u2AZyabxCLaeqJK7dlKoQKCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYoko64rD7qUUBqdIyiMAKhqidm6bdQytR/JeNchZclsy11/iN9wGD6lzVkFZyiyl
	 lfQ1U/rXbIlfVzSHVbThIFUy+6TVeyUhT8cTu+xSdOJKmuTV52TTDJBH/gqKxhdLes
	 LPskPDXKh88MXWKROTyek8iXJsR/Y7PTDFT3rTf/xrCpi4Sv5/oVdZQYdzPC//Xeer
	 Cjqi+IkWs6VGveep5MMGyZnMLdP4Q6SD0r1ix1QltYqAng0N/bjVm9sKH10UIOis/Y
	 UqivQTJ7Ul0Ay+sgVsW/topQekZNPCUPY+WshJdppCpP75rbvIr9oOumvCNyJ+UBCu
	 6HUpgZW0Q5tlg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	lijo.lazar@amd.com,
	Hawking.Zhang@amd.com,
	yifan1.zhang@amd.com,
	tim.huang@amd.com,
	le.ma@amd.com,
	Mangesh.Gadre@amd.com,
	alexandre.f.demers@gmail.com,
	mario.limonciello@amd.com,
	flora.cui@amd.com
Subject: [PATCH AUTOSEL 6.17-6.1] drm/amdgpu: don't enable SMU on cyan skillfish
Date: Sat, 25 Oct 2025 11:54:31 -0400
Message-ID: <20251025160905.3857885-40-sashal@kernel.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 94bd7bf2c920998b4c756bc8a54fd3dbdf7e4360 ]

Cyan skillfish uses different SMU firmware.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - `drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:2113` adds a
    dedicated switch case for `IP_VERSION(11, 0, 8)` and only enables
    the SMU when `adev->apu_flags & AMD_APU_IS_CYAN_SKILLFISH2` is set,
    otherwise it does nothing (no SMU block added) at
    `drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:2134-2137`.
  - In the same function, `IP_VERSION(11, 0, 8)` has been removed from
    the generic v11.0.x list that unconditionally enabled
    `smu_v11_0_ip_block` (now absent from the list at
    `drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:2123-2133`). Net
    effect: “cyan skillfish” (original) no longer gets SMU enabled; only
    “cyan skillfish2” does.

- Why this fixes a real bug
  - The commit message states “Cyan skillfish uses different SMU
    firmware.” Enabling the v11.0 SMU driver on original cyan skillfish
    (MP1 11.0.8) mismatches firmware/driver and can lead to init
    failures or instability. The new gating prevents that by not adding
    the SMU IP block unless the device is the “cyan skillfish2” variant.
  - The rest of the driver already treats cyan skillfish variants
    differently, which corroborates this fix:
    - APU flag detection:
      `drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:2076-2080` sets
      `AMD_APU_IS_CYAN_SKILLFISH2` based on PCI IDs.
    - Firmware load path: for `CHIP_CYAN_SKILLFISH`, non-2 defaults to
      direct firmware loading rather than PSP
      (`drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c:563-568`), indicating
      a different bring-up path than typical SMU/PSP-managed devices.
    - PSP specialization: PSP functions for `IP_VERSION(11, 0, 8)` are
      only set for cyan skillfish2, with other behavior toggled for the
      non-2 variant (`drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c:235-241`).
    - IP version assignments for cyan skillfish explicitly set MP1 to
      11.0.8 on non-2
      (`drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:2774-2776`), so
      the new SMU gating precisely targets that case.

- Impact and risk
  - Scope is narrowly limited to SMU enablement for MP1 `11.0.8`; it
    gates SMU only for `AMD_APU_IS_CYAN_SKILLFISH2`. Original cyan
    skillfish devices will no longer load the v11.0 SMU driver, avoiding
    firmware/driver mismatch.
  - No architectural changes; the patch only adjusts the discovery-time
    IP block selection in one function
    (`amdgpu_discovery_set_smu_ip_blocks` at
    `drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:2111-2172`).
  - Minimal regression risk: devices incorrectly receiving SMU before
    this patch were at risk; after the patch, those devices simply won’t
    enable SMU, which aligns with the existing PSP/ucode paths for cyan
    skillfish and prevents crashes or misbehavior. Other SKUs and IP
    versions are unaffected.

- Stable backport criteria
  - Fixes a hardware-specific bug that affects users with cyan skillfish
    (original) hardware.
  - Change is small and contained to a single switch-case; no new
    features.
  - No broad side effects or architectural shifts; consistent with
    existing variant handling in PSP/ucode.
  - Although the commit message lacks “Fixes:”/stable tags, it clearly
    qualifies as a correctness/stability fix with low risk.

Note: Ensure the target stable trees already have the
`AMD_APU_IS_CYAN_SKILLFISH2` flag and detection logic
(`drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:2076-2080`). If not, those
prerequisites should be included for a clean backport.

 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index e814da2b14225..dd7b2b796427c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -2126,7 +2126,6 @@ static int amdgpu_discovery_set_smu_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(11, 0, 5):
 	case IP_VERSION(11, 0, 9):
 	case IP_VERSION(11, 0, 7):
-	case IP_VERSION(11, 0, 8):
 	case IP_VERSION(11, 0, 11):
 	case IP_VERSION(11, 0, 12):
 	case IP_VERSION(11, 0, 13):
@@ -2134,6 +2133,10 @@ static int amdgpu_discovery_set_smu_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(11, 5, 2):
 		amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
 		break;
+	case IP_VERSION(11, 0, 8):
+		if (adev->apu_flags & AMD_APU_IS_CYAN_SKILLFISH2)
+			amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
+		break;
 	case IP_VERSION(12, 0, 0):
 	case IP_VERSION(12, 0, 1):
 		amdgpu_device_ip_block_add(adev, &smu_v12_0_ip_block);
-- 
2.51.0

