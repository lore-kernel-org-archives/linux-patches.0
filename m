Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1653112AD;
	Sat, 25 Oct 2025 16:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409704; cv=none; b=RzxO57RvRHoma1ujfIj5oL0s8c4mtkts++IFhuj9TC/f1qDvQ3s5cMm9r0DHcIrsWYot/eLlhCzcpDvQ0Kwxb511e67bxE0Qy63L1MYi9F1gtVAj2RJeDTuu+YdtEhGwV9ZQL504Wfpl5CZSbtZWdgRcFYfNDnc/s3MEyufIqhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409704; c=relaxed/simple;
	bh=hUP2nf8nrPQPADEcx5EXZpaXsVUTOU8KNJl+oUapSe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V9QiHhCIgNgqtGAMNmgQvvzoW1Ia28//JY2Xv+JlwDpwp/BF/i9Q7ar9v9Sjw/Q5tckch+XufN6P4EpFOXdcqytpkejhe36dDe+FSM1n39cmYOkFn5kI5gdRHOq2vKfSsqPD3V8awIcI/bpDb/GYbFxmEMKcApq8/NlPs2fCKkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqXTMpqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqXTMpqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5662BC4CEF5;
	Sat, 25 Oct 2025 16:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409703;
	bh=hUP2nf8nrPQPADEcx5EXZpaXsVUTOU8KNJl+oUapSe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqXTMpqFg0VkghAUDdS1vAg4NzLuhetYXYvMl+X5yQYLRvOj9CuOUzD9sSc1olDe3
	 Cv++v+y6suTBEXYMbrMpZ9B6nxq2ET06pzJGHx3mwwYH203X2Oea5273oYLXcq5gZU
	 k9fq5+pO7ECu2+jJ8ExAbnmbjPxk4vgJSszVYzpM27xeg19uZY41WgprOba2xbgIC1
	 qzdCfvcbJhh2LMhYXqqY/agUXp8UNOO6mZ4S+A/JKfBoJDuyBDQe8TV3OOEOrp1b9J
	 zGlpwslr1FVJcIatYJMw7wKWCkHKpr4/IKLWjdYIFD9idx4qwkjHmy08zp2jURHfdn
	 hyyn1bBZmQ+Sg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	christian.koenig@amd.com,
	lijo.lazar@amd.com,
	Prike.Liang@amd.com,
	alexandre.f.demers@gmail.com,
	vitaly.prosyak@amd.com,
	arnd@arndb.de
Subject: [PATCH AUTOSEL 6.17-5.15] drm/amd: add more cyan skillfish PCI ids
Date: Sat, 25 Oct 2025 12:00:58 -0400
Message-ID: <20251025160905.3857885-427-sashal@kernel.org>
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

[ Upstream commit 1e18746381793bef7c715fc5ec5611a422a75c4c ]

Add additional PCI IDs to the cyan skillfish family.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: Adds five new CYAN_SKILLFISH PCI device IDs to the
  amdgpu match table, all flagged as APU: 0x13DB, 0x13F9, 0x13FA,
  0x13FB, 0x13FC. See `drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:2175`–`dr
  ivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:2181`. The existing IDs 0x13FE
  and 0x143F remain. No logic changes beyond the match table.
- Fix/user impact: Without explicit entries, these boards may only match
  the generic AMD vendor+class fallback entries (e.g.,
  `CHIP_IP_DISCOVERY`) that do not carry the `AMD_IS_APU` flag. Early
  initialization relies on that flag:
  - `amdgpu_device_init_apu_flags()` returns immediately if `AMD_IS_APU`
    is not set, so APU-specific sub-flags (e.g., CSF2 detection) would
    never be set in that path (call site:
    `drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:4488`; early return and
    APU case handling at `drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:205
    1`–`drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:2090`).
  - Firmware load selection uses both `CHIP_CYAN_SKILLFISH` and APU sub-
    flags (e.g., CSF2) to choose the correct path (see
    `amdgpu_ucode_get_load_type()` handling for `CHIP_CYAN_SKILLFISH` in
    `drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c:560`–`drivers/gpu/drm/amd
    /amdgpu/amdgpu_ucode.c:586`). Ensuring `AMD_IS_APU` is set at match
    time avoids incorrect early behavior.
- Containment and risk: The change is a small, table-only extension
  confined to the AMDGPU driver’s PCI ID list. It does not alter core or
  architectural code. For existing devices, behavior is unchanged. For
  these additional devices, it enables already-existing code paths for
  `CHIP_CYAN_SKILLFISH|AMD_IS_APU`. The CSF2 sub-flag remains restricted
  to known IDs (0x13FE, 0x143F) as per `drivers/gpu/drm/amd/amdgpu/amdgp
  u_device.c:2065`–`drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:2088`, so
  the new IDs won’t be misclassified.
- Cross-component consistency: The display stack already lists these
  device IDs (e.g., `drivers/gpu/drm/amd/display/include/dal_asic_id.h:2
  06`–`drivers/gpu/drm/amd/display/include/dal_asic_id.h:227`),
  indicating broader support is in place and minimizing integration
  risk.
- Stable policy fit: This is a classic “add device IDs” enablement: it
  fixes real user-visible issues (proper binding and early APU handling
  for new boards), is narrowly scoped, low risk, and does not introduce
  features or architectural changes.

Given the above, this is a suitable and low-risk backport candidate to
stable trees.

 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 5e81ff3ffdc3f..e60043ac9841e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2172,6 +2172,11 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x7410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ALDEBARAN},
 
 	/* CYAN_SKILLFISH */
+	{0x1002, 0x13DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13F9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13FA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13FB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
+	{0x1002, 0x13FC, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
 	{0x1002, 0x13FE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
 	{0x1002, 0x143F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYAN_SKILLFISH|AMD_IS_APU},
 
-- 
2.51.0

