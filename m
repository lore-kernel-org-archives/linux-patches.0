Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CEA3EBF2C;
	Sat, 14 Feb 2026 01:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031081; cv=none; b=oy6VPNtGpgmAtm4zFM9zxiDWoaQ4yzC094k/csW8GJKduMjn85FiNXs+n53A5dq3LU6ogabGDR9C5T8BLWVB9+Vk/MqmOwpB9QU2cY0NfEcTaYANrglJyHvjIzq9yVfwLbHz4PHwwPdk++BeTzh0zuKC96TrbkGLtvyzYINUhzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031081; c=relaxed/simple;
	bh=pxU4dhXgLPgfmO4ShUeJwUO8A6IEFL46pfkVTEyvM5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QEoNDdrzoTFODJE+G97RWQd+Z+yk5xfhnGAChkPhdHhH6vBxWY0ml2FwUnKNxzIB1kqOrYzui2jE2rYVAL3lmOGpNuSpJtt5GuPRhVCXIHZ2YR7//8NLWoxlZorPvaqRzuSNSA85OaC12U+LJj7BC7T5yhz28A9SKGa3GC692ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ka14I7F4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ka14I7F4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EEEC116C6;
	Sat, 14 Feb 2026 01:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031080;
	bh=pxU4dhXgLPgfmO4ShUeJwUO8A6IEFL46pfkVTEyvM5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ka14I7F4J58hQvQiWC6vZyMe9V4rTKVjHrbihcIRpjaEd2PdXosl2NvlRu8y+6TdN
	 mAR6amNSnYjG//kdV6Nc83gNws/qoGcv4ea1LSTnzlTYZV1nnUXJ8B7IxyxEDcdx3g
	 Xv5mhW4cFi2Ezp7gW7HfxtxXwU/drdCCRD3xBjAWZdtYIhWpKC+eOMnihCEuZ5qAEN
	 orIfv8YljgoRn4FyWS38PWGdltI1G1siLK7MYfg6OEbXIIzvVPg/15O5m95XfHrJRY
	 Ezb0V4SuLPt8twVfYbxNVNQrGpyn5ikb1/gYerfFPWRmQJcpIb7s8mgIGD+jXmSDq8
	 nMjLRVs6fxPTQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: YuBiao Wang <YuBiao.Wang@amd.com>,
	Victor Skvortsov <Victor.Skvortsov@amd.com>,
	Gavin Wan <gavin.wan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	yunru.pan@amd.com,
	Hawking.Zhang@amd.com,
	srinivasan.shanmugam@amd.com,
	lijo.lazar@amd.com,
	YiPeng.Chai@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	Tony.Yi@amd.com,
	bokun.zhang@amd.com,
	shaoyun.liu@amd.com
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amdgpu: Skip loading SDMA_RS64 in VF
Date: Fri, 13 Feb 2026 19:58:53 -0500
Message-ID: <20260214010245.3671907-53-sashal@kernel.org>
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

From: YuBiao Wang <YuBiao.Wang@amd.com>

[ Upstream commit 39c21b81112321cbe1267b02c77ecd2161ce19aa ]

VFs use the PF SDMA ucode and are unable to load SDMA_RS64.

Signed-off-by: YuBiao Wang <YuBiao.Wang@amd.com>
Signed-off-by: Victor Skvortsov <Victor.Skvortsov@amd.com>
Reviewed-by: Gavin Wan <gavin.wan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me compile my analysis.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and direct: "VFs use the PF SDMA ucode and
are unable to load SDMA_RS64." In SR-IOV (Single Root I/O
Virtualization), Virtual Functions (VFs) rely on the Physical Function
(PF) for SDMA firmware. The VF should never attempt to load SDMA
firmware itself. The commit adds `AMDGPU_UCODE_ID_SDMA_RS64` to the skip
list so VFs don't try to load it.

The commit is authored by AMD engineers (YuBiao Wang, Victor Skvortsov),
reviewed by an AMD engineer (Gavin Wan), and signed off by the amdgpu
subsystem maintainer (Alex Deucher).

### 2. CODE CHANGE ANALYSIS

The change is a **single line addition** in
`amdgpu_virt_fw_load_skip_check()`:

```1264:1264:drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
                    || ucode_id == AMDGPU_UCODE_ID_SDMA_RS64
```

This adds `AMDGPU_UCODE_ID_SDMA_RS64` to the `default` case's "legacy
blacklist" of firmware IDs that should be **skipped** when loading
firmware in a VF context. The existing blacklist already includes
`SDMA0` through `SDMA7`, `RLC_G`, `RLC_RESTORE_LIST_*`, and `SMC` — but
was missing the newer `SDMA_RS64` firmware type.

**Bug mechanism**: `AMDGPU_UCODE_ID_SDMA_RS64` is a newer SDMA firmware
format (v3 header) introduced in commit `807d90b5ef1da` ("drm/amdgpu:
support SDMA v3 struct fw front door load"), which landed in v6.11. It
is used by SDMA v7 hardware (IP version 7.0.0, 7.0.1). When this
firmware type was added, no one updated the VF skip check's default
blacklist.

**Call chain that triggers the bug**:
1. `psp_load_non_psp_fw()` iterates over all firmware entries
2. For each, it calls `fw_load_skip_check()` which checks
   `amdgpu_sriov_vf()` and then `amdgpu_virt_fw_load_skip_check()`
3. Without this fix, `amdgpu_virt_fw_load_skip_check()` returns `false`
   for `SDMA_RS64` in the `default` case (meaning "don't skip")
4. The VF then calls `psp_execute_ip_fw_load()` for SDMA_RS64
5. This fails because VFs cannot load SDMA firmware — the PF manages it
6. The error propagates back up, causing **VF initialization failure**

**Evidence of real SR-IOV usage on affected hardware**: `sdma_v7_0.c`
has extensive `amdgpu_sriov_vf()` checks throughout its code (at least 6
instances), confirming that SDMA v7 hardware does support and is used in
SR-IOV configurations.

### 3. CLASSIFICATION

This is a **bug fix** — specifically a missing entry in a firmware skip
list. It falls into the category of a hardware/virtualization quirk. The
`default` case is labeled "legacy blacklist" and the intent is clearly
to skip all SDMA firmware types in VFs. The omission of `SDMA_RS64` was
simply an oversight when the new firmware type was added.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1 line added
- **Files changed**: 1 file (`amdgpu_virt.c`)
- **Risk**: Extremely low. The change follows the exact same pattern as
  the 8 existing SDMA entries (SDMA0-7). It only affects VF behavior
  (SR-IOV virtual machines) and only for the specific firmware type
  SDMA_RS64.
- **Regression potential**: Essentially zero. Adding an entry to a
  blacklist to skip firmware loading in VF is the conservative, safe
  action. Not skipping it is what causes problems.

### 5. USER IMPACT

- **Affected users**: Anyone running AMD GPU SR-IOV virtualization on
  hardware that uses SDMA v7 (SDMA_RS64 firmware). This includes data
  center and cloud deployments using AMD GPU passthrough.
- **Severity**: HIGH — VF initialization failure means the GPU is
  unusable in the virtual machine.
- **Visibility**: GPU completely fails to initialize in the VM, making
  it a hard failure, not a subtle bug.

### 6. STABILITY AND VERSION ANALYSIS

- The `amdgpu_virt_fw_load_skip_check` function was introduced in v6.1
  (commit `d9d86d085fbc1`)
- `AMDGPU_UCODE_ID_SDMA_RS64` was introduced in v6.11 (commit
  `807d90b5ef1da`)
- Therefore, this fix is relevant for stable trees **v6.11 and later**
  (6.11.y, 6.12.y, etc.)
- The fix has been reviewed by AMD engineers and merged by the subsystem
  maintainer

### 7. DEPENDENCY CHECK

The fix has **no dependencies**. It simply adds one more enum value to
an existing `||` chain. The `AMDGPU_UCODE_ID_SDMA_RS64` enum already
exists in all kernels from v6.11 onward, and the function structure is
unchanged. The patch will apply cleanly to any kernel v6.11+.

### Summary

This is a textbook stable backport candidate:
- **One-line fix** adding a missing entry to a firmware skip list
- **Fixes a real, severe bug**: VF initialization failure on newer AMD
  GPUs with SR-IOV
- **Obviously correct**: SDMA_RS64 should be treated identically to
  SDMA0-7 in VF context
- **Zero regression risk**: Only adds a skip for VFs, following the
  exact existing pattern
- **Small and self-contained**: No dependencies, clean backport
- Authored, reviewed, and approved by AMD GPU engineers

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 47a6ce4fdc744..292e2706286a1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -1261,6 +1261,7 @@ bool amdgpu_virt_fw_load_skip_check(struct amdgpu_device *adev, uint32_t ucode_i
 		    || ucode_id == AMDGPU_UCODE_ID_SDMA5
 		    || ucode_id == AMDGPU_UCODE_ID_SDMA6
 		    || ucode_id == AMDGPU_UCODE_ID_SDMA7
+		    || ucode_id == AMDGPU_UCODE_ID_SDMA_RS64
 		    || ucode_id == AMDGPU_UCODE_ID_RLC_G
 		    || ucode_id == AMDGPU_UCODE_ID_RLC_RESTORE_LIST_CNTL
 		    || ucode_id == AMDGPU_UCODE_ID_RLC_RESTORE_LIST_GPM_MEM
-- 
2.51.0

