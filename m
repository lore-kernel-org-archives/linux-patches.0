Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF33B305953;
	Sat, 25 Oct 2025 16:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408985; cv=none; b=BNyLWtzOboPbAOuRNF4Fjn4OQoQAG2/kLb1R6MR9AwS1SVCMxnEEa3cUCabiFThkkZ/rPkcqMydloHZrfYXX++kL/fOP+gJriY61/yI8DDqkO6a4nATlTaaNMausr7yO3lfxsGW8DXU4EY4SaDtkBDTjHpkiC6h5M8YfyZ+BzKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408985; c=relaxed/simple;
	bh=CGjjwZOGUgCKH1Ga50Ie8dlSNKHBsRez9e+JEdxD4Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lskFrKODtfe9ASiDO5ON8HVWqqXg/Vuj/r3xR7gNfgqgEXIZR3dHnPl0jrSAjOtOu6bDExK3yezybjafM2YaxRyiRm/Uo0mzmXdgy6m/QR1UNjp5R+CAFiUFJ4A4Ucc9mDgOQuH6MwSxvjTa4O2vohVS1N8jOK2MHoyGU+zmvhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vBoXNLMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBoXNLMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280C0C4CEF5;
	Sat, 25 Oct 2025 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408985;
	bh=CGjjwZOGUgCKH1Ga50Ie8dlSNKHBsRez9e+JEdxD4Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBoXNLMHca5gDZqWT0IXUqafJ0HAKQRYcFSt39a097XLBAvd+i8TSmAQ2x3U2yDNz
	 Ob+qzxbj6ji/vACBrm6BRXo4U2AuCwo0xeTL5OEzkTrkVbQ/NMLWta8ld1lG96Gl0a
	 8xxARnUQ2To/pUAnlNaOp00Cx3GGTmsdzkp1NecCa6p5+bQAA8Om5Fb4OXBZANOODx
	 K1giejj46in/U8BGn0RavxFja84m0ufeKrDdWjoi1uRB0Vru0XfcexQdfM26hBpUaX
	 O+qO7ENhFfyl4LX2W7zHVDhx8gh33+J/2UV1Lx7L3j52ABYVgQp7SGN2BXjfuduNGQ
	 T7qujTtIuDZcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sathishkumar.sundararaju@amd.com,
	leo.liu@amd.com,
	lijo.lazar@amd.com,
	Stanley.Yang@amd.com,
	alexandre.f.demers@gmail.com,
	FangSheng.Huang@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Avoid jpeg v5.0.1 poison irq call trace on sriov guest
Date: Sat, 25 Oct 2025 11:56:33 -0400
Message-ID: <20251025160905.3857885-162-sashal@kernel.org>
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

From: Mangesh Gadre <Mangesh.Gadre@amd.com>

[ Upstream commit 01152c30eef972c5ca3b3eeb14f2984fa48d18c2 ]

Sriov guest side doesn't init ras feature hence the poison irq shouldn't
be put during hw fini

Signed-off-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The patch adds a virtualization guard so
  `jpeg_v5_0_1_hw_fini()` only releases the JPEG RAS poison interrupt on
  bare-metal, not on an SR-IOV VF. Concretely, it changes the condition
  to include `!amdgpu_sriov_vf(adev)` before calling `amdgpu_irq_put()`
  in `drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:318`.

- The bug: On SR-IOV guests, the RAS feature for JPEG isn’t initialized
  and the poison IRQ is never enabled (no matching amdgpu_irq_get).
  Unconditionally calling `amdgpu_irq_put()` during fini triggers a
  WARN/call trace because the IRQ isn’t enabled.
  - `amdgpu_irq_put()` explicitly warns and returns an error if the
    interrupt wasn’t enabled:
    `drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:639`.
  - The guest doesn’t enable this IRQ: `jpeg_v5_0_1_ras_late_init()`
    only calls `amdgpu_irq_get()` if RAS is supported and the source has
    funcs: `drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:1075-1080`. On VFs,
    this path typically isn’t taken, so there is no prior “get”.
  - Compounding this, `amdgpu_ras_is_supported()` can return true via
    the “poison mode” special-case even without full RAS enablement (and
    in absence of proper init), which is why the old check was
    insufficient on VFs: see logic enabling GFX/SDMA/VCN/JPEG by
    mask/poison mode,
    `drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:4806-4821`.

- Why the new guard is correct and low risk:
  - It prevents the mismatched put on VFs by requiring
    `!amdgpu_sriov_vf(adev)` at the point of `amdgpu_irq_put()` in
    `jpeg_v5_0_1_hw_fini()`
    `drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:318-319`.
  - It matches established patterns in adjacent IPs/versions:
    - VCN v5.0.1 already gates the poison IRQ put with `&&
      !amdgpu_sriov_vf(adev)`:
      `drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c:351-352`.
    - JPEG v4.0.3 does the same:
      `drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c:447-449`.
  - `jpeg_v5_0_1_hw_fini()` already treats SR-IOV specially for power
    gating with `if (!amdgpu_sriov_vf(adev)) ...`:
    `drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:313-316`. Extending the
    same guard to the RAS IRQ put maintains consistency.
  - On bare-metal paths, behavior is unchanged: RAS init
    (`jpeg_v5_0_1_ras_late_init`) gets the IRQ (`amdgpu_irq_get()` in
    `drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:1077`), and fini puts it,
    preserving correct pairing.

- User impact: This fixes a real bug that causes kernel WARN/call traces
  on SR-IOV guests when the JPEG block is torn down (e.g., during
  suspend, driver unload, or GPU reset via `jpeg_v5_0_1_suspend()` which
  calls `hw_fini`: `drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c:331-335`).
  Avoiding such call traces is important for stability and clean logs in
  virtualized environments.

- Scope and risk: The change is a one-line conditional refinement in a
  single driver file, touches only the SR-IOV VF path, and avoids an
  unpaired interrupt disable. No architectural changes, no API changes,
  minimal regression risk.

- Stable criteria:
  - Fixes an important bug (mismatched IRQ put leading to WARN call
    trace).
  - Small, self-contained change in DRM/amdgpu JPEG v5.0.1 block.
  - No new features or architectural changes.
  - Consistent with existing code in similar IP blocks/versions.

Given the direct bug fix, minimal blast radius, and alignment with
existing patterns in the driver, this is a good candidate for stable
backporting.

 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
index 8d74455dab1e2..7731ef262d39f 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -315,7 +315,7 @@ static int jpeg_v5_0_1_hw_fini(struct amdgpu_ip_block *ip_block)
 			ret = jpeg_v5_0_1_set_powergating_state(ip_block, AMD_PG_STATE_GATE);
 	}
 
-	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__JPEG))
+	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__JPEG) && !amdgpu_sriov_vf(adev))
 		amdgpu_irq_put(adev, &adev->jpeg.inst->ras_poison_irq, 0);
 
 	return ret;
-- 
2.51.0

