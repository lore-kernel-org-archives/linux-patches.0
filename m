Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5659E27280E;
	Sat, 25 Oct 2025 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408680; cv=none; b=kL46j1hyDcExoaoAl2yDkbtNJ3HX0uChCz7IipYx5QhDZ6pqEcM7fFD9e9QmxkPTgN/FtncC2GvlFJTVnHBibgN+CwD16Fib3+GXSC7z+EF36vXtTnaQVfolax6ehzzmGym8uA0Fng5aUasFoafEMJZ8ngrKDHJwx20lE1ybZCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408680; c=relaxed/simple;
	bh=4+I2SgbV66gYdnHhZDym/lRBWMyijSK0LO6evPJk2A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o8x/5E4HF3YhUBgQsFdZA8nKG3qp4C3TD2v71tC5/Eja9U/H3ICTwNBB+hI655mjYhC7t3ea3Ky11IGMhj/a3YXpmi/nNAnHcuN3SBojB60f6IluvL41slH2m0HZzifhVEJA5P6yH0FuPxrrWYDpLY51JD8xr5Lulo/MhLgXDH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgtVWsMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgtVWsMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAD4C4CEF5;
	Sat, 25 Oct 2025 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408680;
	bh=4+I2SgbV66gYdnHhZDym/lRBWMyijSK0LO6evPJk2A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgtVWsMHQukA/hyW4G4tIpgXEN48B0pWpa21P4QAqF+7EtMsekvxyRgtY+riW6wF+
	 1FVdVJns774nn2XERt1E0I+HiHLAkH1yBO2iuj1fyk97IACDXviPK78XXmRNCNHMZB
	 p4GidzCTzYhnVOfkH3E1hkxXv5VR4UqkCO2asrf5VyjK/BdT/Ox9JAXw21YWwShEby
	 hVBNTwAlJoEo1IKD5VkcBu4kyi/Orr+/BrXdPO2zqk8X6uYbJyFezpEhofFMKRhv0I
	 08I1ngiwX8JtnsauONtT7Trgu+qGH4n/OVi9s0KhLEFgZuUtuS8F/5r4G7WJtGDh/x
	 E5qdWr9wY8sxA==
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
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Correct info field of bad page threshold exceed CPER
Date: Sat, 25 Oct 2025 11:54:30 -0400
Message-ID: <20251025160905.3857885-39-sashal@kernel.org>
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

[ Upstream commit f320ed01cf5f2259e2035a56900952cb3cc77e7a ]

Correct valid_bits and ms_chk_bits of section info field for bad page
threshold exceed CPER to match OOB's behavior.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes incorrect CPER section info for “bad page threshold exceeded”
  events by explicitly marking the MS_CHECK subfield valid and setting
  the key status bits:
  - Sets `valid_bits.ms_chk = 1` so MS_CHECK content is defined for
    consumers: drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c:222
  - Marks error type presence and value: `ms_chk_bits.err_type_valid =
    1` and `ms_chk_bits.err_type = 1`:
    drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c:223-224
  - Marks processor context corrupted: `ms_chk_bits.pcc = 1`:
    drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c:225
  - Without these, decoders can treat MS_CHECK as invalid/unknown,
    leading to misclassification or ignoring of the event.

- Corrects CPER header validity flags by removing an invalid assertion
  that a reserved field is present:
  - Drops `hdr->valid_bits.partition_id = 1` (the field is reserved in
    this format), preventing consumers from assuming a valid partition
    ID when none is provided:
    drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c:70-71 (absence of the old
    assignment)
  - The header explicitly documents `partition_id` as reserved:
    drivers/gpu/drm/amd/include/amd_cper.h:118

- Scope and risk:
  - Small, contained change in one driver file:
    drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c.
  - No API/ABI or architectural changes; only corrects record formatting
    bits.
  - Runtime behavior of the GPU or the kernel isn’t affected; this only
    alters metadata in generated CPER records written to the AMDGPU CPER
    ring.
  - Extremely low regression risk; improves compatibility with OOB
    tooling by matching expected CPER semantics.

- User impact:
  - Fixes a real correctness bug in error reporting: previously,
    MS_CHECK data was not flagged valid and key semantics (error type,
    PCC) were not asserted for the bad-page-threshold CPER, causing
    potential misinterpretation by diagnostics/management tools.
  - Aligns driver-generated records with out-of-band behavior as stated
    in the commit message.

- Stable criteria:
  - Important bugfix in a confined subsystem (AMDGPU RAS/CPER
    formatting).
  - Minimal change set, no feature additions, no cross-subsystem
    fallout.
  - Suitable for all stable trees that include AMDGPU CPER generation
    (e.g., where `amdgpu_cper_generate_bp_threshold_record()` is
    present: drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c:323-341).

Given the above, this is a low-risk correctness fix that improves error
record fidelity and should be backported.

 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
index 6c266f18c5981..12710496adae5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
@@ -68,7 +68,6 @@ void amdgpu_cper_entry_fill_hdr(struct amdgpu_device *adev,
 	hdr->error_severity		= sev;
 
 	hdr->valid_bits.platform_id	= 1;
-	hdr->valid_bits.partition_id	= 1;
 	hdr->valid_bits.timestamp	= 1;
 
 	amdgpu_cper_get_timestamp(&hdr->timestamp);
@@ -220,7 +219,10 @@ int amdgpu_cper_entry_fill_bad_page_threshold_section(struct amdgpu_device *adev
 	section->hdr.valid_bits.err_context_cnt = 1;
 
 	section->info.error_type = RUNTIME;
+	section->info.valid_bits.ms_chk = 1;
 	section->info.ms_chk_bits.err_type_valid = 1;
+	section->info.ms_chk_bits.err_type = 1;
+	section->info.ms_chk_bits.pcc = 1;
 	section->ctx.reg_ctx_type = CPER_CTX_TYPE_CRASH;
 	section->ctx.reg_arr_size = sizeof(section->ctx.reg_dump);
 
-- 
2.51.0

