Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77E2304BCC;
	Sat, 25 Oct 2025 16:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408748; cv=none; b=eVJurFeXjaGyzLEgvzx8R2JmCcIHIKBjUC5oNDQaApjCeAFW0YT93SONldRetPlD8+5dgR6jQEHd2LgEqiy/Ds/QfhtUxUISwH+cbp9ZGJfJ19qUT9MP2RvF6hEybNZ9i1GqrcRRqIXOKv8FzRC6Q4Gh00aCxbocXhr8PHE2BNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408748; c=relaxed/simple;
	bh=sAosseFIqyn79GZQOpJO8ZSLGhCkYL74cLZQbx3HAXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oP/txK6iS2YIotrKcKIULKKZoitMkTVvQT76VtFtCLItSAsucxAvTZRYjcbynQdXRJnrtY9/B7NFqsWVEN0enlnigL7Qdo2MC3r0ngyjQvoTIvLSTypVZuizg5TJLoAjaDnDtp0zfmBJyAG/C2XIh3qM6oF14JC1jI2i1ZOUhCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mx4GGTyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mx4GGTyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB26C4CEFF;
	Sat, 25 Oct 2025 16:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408748;
	bh=sAosseFIqyn79GZQOpJO8ZSLGhCkYL74cLZQbx3HAXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mx4GGTyrIIOWeday2welugZDbwVLMzfbaehy9XEuEaplx6mFodl6uvnUxWhMvTF56
	 l2IqAUEJ+OYZuO0F7r+uTeLnehCf7r+I0SaoOPfzy1QdSkvN/mUy5QtUTXXDrPZThb
	 8KYn0vZvG1evf+pQvc5UvTowmAkqMBrfJo3tFyL3J6TZfiuX4yh7hUMz4D8NO9whfd
	 g9UMKlGCR2NRVFyAO6p8eVbUNLVKYElkQZF9xJFaX3H5FScSxJVAlK2BGXGwj+JCO3
	 TG5hWNigMiUosemvkPLDuM+5qLfYbUWVWmGXLsirKyLqqAJGft6btHfdKT/j9i+Q7b
	 uWi6jVumYy1Ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	tao.zhou1@amd.com,
	kevinyang.wang@amd.com,
	alexandre.f.demers@gmail.com,
	victor.skvortsov@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Update IPID value for bad page threshold CPER
Date: Sat, 25 Oct 2025 11:54:52 -0400
Message-ID: <20251025160905.3857885-61-sashal@kernel.org>
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

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 8f0245ee95c5ba65a2fe03f60386868353c6a3a0 ]

Update the IPID register value for bad page threshold CPER according to
the latest definition.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: In the bad page threshold CPER builder, the IPID fields
  are no longer hardcoded; they are computed from the GPU’s socket ID
  per the “latest definition.”
  - Previous behavior: `IPID_LO = 0x0` and `IPID_HI = 0x96`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c:237-238).
  - New behavior: Introduces `socket_id` and sets:
    - `IPID_LO = (socket_id / 4) & 0x01`
    - `IPID_HI = 0x096 | (((socket_id % 4) & 0x3) << 12)`
    These replace the constants, encoding the socket information in IPID
per the updated spec.

- Scope and containment:
  - The change is confined to one function:
    `amdgpu_cper_entry_fill_bad_page_threshold_section()` in
    drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c.
  - It only affects construction of CPER records for “bad page
    threshold” events; normal runtime, CE/DE/UE CPERs still use real ACA
    bank IPID values (drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c:391-404).

- Rationale and user impact:
  - This corrects CPER content by encoding the GPU socket in IPID,
    improving RAS diagnostics. Previously, CPERs for this event carried
    a fixed, misleading IPID, which can misidentify the device/location
    and hamper triage and RMA workflows.
  - The commit message aligns with this: “Update … according to the
    latest definition,” i.e., a spec-compliance fix rather than a
    feature.

- Dependencies and compatibility:
  - It uses `adev->smuio.funcs->get_socket_id` if available, otherwise
    falls back to 0, preserving prior behavior on ASICs without socket
    ID support. This same pattern is already used elsewhere in this file
    for `record_id` and FRU text
    (drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c:73-81, 123-131), so there
    is no new dependency risk.
  - No API/ABI changes; no headers or structures changed; no
    architectural changes.

- Risk assessment:
  - Minimal risk: pure data-field fix inside a CPER payload builder; no
    control flow or subsystem behavior changes.
  - Side effects are limited to CPER contents produced when bad page
    threshold is exceeded (trigger path in
    drivers/gpu/drm/amd/pm/amdgpu_dpm.c:764-778).

- Stable backport criteria:
  - Fixes a real (though non-crashing) bug affecting users of RAS/CPER
    reporting in multi-GPU or multi-socket environments.
  - Small, localized change with clear intent and low regression risk.
  - No new features or architectural changes; adheres to stable rules.

- Practical note for backporting:
  - Backport to stable trees that already contain CPER generation for
    bad page threshold and the `smuio.get_socket_id` plumbing. Where
    `get_socket_id` is absent, the fallback keeps behavior identical to
    pre-fix.

 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
index 25252231a68a9..6c266f18c5981 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
@@ -206,6 +206,7 @@ int amdgpu_cper_entry_fill_bad_page_threshold_section(struct amdgpu_device *adev
 {
 	struct cper_sec_desc *section_desc;
 	struct cper_sec_nonstd_err *section;
+	uint32_t socket_id;
 
 	section_desc = (struct cper_sec_desc *)((uint8_t *)hdr + SEC_DESC_OFFSET(idx));
 	section = (struct cper_sec_nonstd_err *)((uint8_t *)hdr +
@@ -224,6 +225,9 @@ int amdgpu_cper_entry_fill_bad_page_threshold_section(struct amdgpu_device *adev
 	section->ctx.reg_arr_size = sizeof(section->ctx.reg_dump);
 
 	/* Hardcoded Reg dump for bad page threshold CPER */
+	socket_id = (adev->smuio.funcs && adev->smuio.funcs->get_socket_id) ?
+				adev->smuio.funcs->get_socket_id(adev) :
+				0;
 	section->ctx.reg_dump[CPER_ACA_REG_CTL_LO]    = 0x1;
 	section->ctx.reg_dump[CPER_ACA_REG_CTL_HI]    = 0x0;
 	section->ctx.reg_dump[CPER_ACA_REG_STATUS_LO] = 0x137;
@@ -234,8 +238,8 @@ int amdgpu_cper_entry_fill_bad_page_threshold_section(struct amdgpu_device *adev
 	section->ctx.reg_dump[CPER_ACA_REG_MISC0_HI]  = 0x0;
 	section->ctx.reg_dump[CPER_ACA_REG_CONFIG_LO] = 0x2;
 	section->ctx.reg_dump[CPER_ACA_REG_CONFIG_HI] = 0x1ff;
-	section->ctx.reg_dump[CPER_ACA_REG_IPID_LO]   = 0x0;
-	section->ctx.reg_dump[CPER_ACA_REG_IPID_HI]   = 0x96;
+	section->ctx.reg_dump[CPER_ACA_REG_IPID_LO]   = (socket_id / 4) & 0x01;
+	section->ctx.reg_dump[CPER_ACA_REG_IPID_HI]   = 0x096 | (((socket_id % 4) & 0x3) << 12);
 	section->ctx.reg_dump[CPER_ACA_REG_SYND_LO]   = 0x0;
 	section->ctx.reg_dump[CPER_ACA_REG_SYND_HI]   = 0x0;
 
-- 
2.51.0

