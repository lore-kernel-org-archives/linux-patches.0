Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315B93168EB;
	Sat, 25 Oct 2025 16:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409570; cv=none; b=dnRpc4R2aCQ9iNvfcIiq79Wnko5ad63cI1FjPizeVzh9vk6gRQbe3t4U/9znI7aMviaP82ZnWTIMAc9KhIgCbRhcV4Rxl+OX3sOnVIOENQc5nODU5T2QJV/v9Q68BD+BXbTubfO8s3Dlj2HOY7LNISF6GbjyiOMgSrFzMVnWDjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409570; c=relaxed/simple;
	bh=3wFnE5u5gjdPk8nPhbRK0CGa5vHpiIaUYHaLegwhwlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YtkclGj8TwtGfLQnRTgEWQfH+nwySHB9kWoKhutp6QRlbfNBM1gFITqV7bu6H7H1TUDutnfQv4eLlYHQ1jQOTA2I4EXoadBFZfLetEsReYtjWjYn7xGl+9k8BSGoo48NFgJBTLajxcTLi4NmsgF6e6rITkdDKn11+ShL5L9o1p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebIqzVU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebIqzVU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AD2C4CEF5;
	Sat, 25 Oct 2025 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409570;
	bh=3wFnE5u5gjdPk8nPhbRK0CGa5vHpiIaUYHaLegwhwlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebIqzVU3R7HMpI1CmzwWzz3bGhUgPvsf0sf/5yVMSIUW7yVoq8GyCdw36tlewK5Ma
	 5AapAnWbgm0jnHQzUpKx3GE8E7FDt1XZt8GMEIMSIRQLiOF4ZIfwxlgtmaezVYfSo/
	 oBY9nYjDXFvo+BUbkYVczDRzEgkXiFLa6QzI8+FG994oqWugFboEGx66UtVYYokkHD
	 qALh0X7wl1bl2Dme3DwFCL9W2uWKXiwaAsmYbTqZ8jfqQ5r/v42Wqn3IYZFTGI+vbs
	 w5L8NUjNL0HByU5rOyGS7XL+IxIyMtLEdXhSF40iM2ZohZeH6wgcHKUZzIgHWfUw93
	 D3zGbAqw5RvjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dillon Varone <Dillon.Varone@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Wenjing Liu <Wenjing.Liu@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	bhavin.sharma@siliconsignals.io,
	alexandre.f.demers@gmail.com,
	Jerry.Zuo@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: Consider sink max slice width limitation for dsc
Date: Sat, 25 Oct 2025 12:00:02 -0400
Message-ID: <20251025160905.3857885-371-sashal@kernel.org>
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

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 6b34e7ed4ba583ee77032a4c850ff97ba16ad870 ]

[WHY&HOW]
The sink max slice width limitation should be considered for DSC, but
was removed in "refactor DSC cap calculations".
This patch adds it back and takes the valid minimum between the sink and
source.

Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real regression: The change restores enforcement of the sink’s
  maximum slice-width constraint when selecting the number of DSC
  slices, which was lost during a prior refactor. Without this, the
  driver can select too few slices and later fail the final width check,
  incorrectly concluding “DSC not possible” or programming an invalid
  configuration that can cause display failures for affected sinks.

- Precise change and rationale: The patch adds an explicit lower bound
  on the horizontal slice count based on the sink’s maximum slice width:
  - New logic: `drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c:1161`
    - `min_slices_h = dc_fixpt_ceil(dc_fixpt_max(dc_fixpt_div_int(dc_fix
      pt_from_int(pic_width), dsc_common_caps.max_slice_width),
      dc_fixpt_from_int(min_slices_h)));`
    - This enforces `min_slices_h >= ceil(pic_width / max_slice_width)`,
      i.e., each slice width ≤ sink/source capability.
  - This is then snapped to a supported slice count:
    `drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c:1165`
    - `min_slices_h = fit_num_slices_up(dsc_common_caps.slice_caps,
      min_slices_h);`
  - Throughput and divisibility constraints are applied after this in
    existing code: `drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c:1168`,
    `drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c:1177`.

- Why it matters: The final validation still checks `slice_width <=
  dsc_common_caps.max_slice_width` at
  `drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c:1236`. Before this patch,
  `min_slices_h` could be too low (because width wasn’t considered),
  leading to late failure and no attempt to raise the slice count if
  `policy.use_min_slices_h` is active (set to true in policy defaults:
  `drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c:1373`). By raising
  `min_slices_h` early to meet the width constraint, the algorithm
  avoids that false “not possible” outcome and finds a valid
  configuration when one exists.

- Correct intersection of caps: The code uses
  `dsc_common_caps.max_slice_width`, which is already the minimum
  between sink and encoder capabilities (intersection):
  `drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c:753`. This matches the
  commit’s intent to “take the valid minimum between the sink and
  source.”

- Consistent with existing logic elsewhere: A similar max-slice-width
  constraint is already considered when computing ODM-related minimum
  slices (`get_min_dsc_slice_count_for_odm`) via a width-based term:
  `drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c:664`. This patch brings
  the main DSC setup path into alignment with that established
  reasoning.

- Scope and risk:
  - Small and contained (a few lines in one function, one file).
  - No API/ABI changes, no architectural shifts.
  - Targets a correctness issue in AMD DC DSC slice selection.
  - Low risk of regression: it only increases the minimum slices to
    satisfy an already-known sink limitation; subsequent
    throughput/divisibility checks remain unchanged.

- User impact: Prevents display failures or inability to enable DSC on
  sinks that enforce max slice width, especially for high
  resolutions/refresh rates where DSC is required.

Given it’s a targeted regression fix, minimal risk, and improves
correctness for real hardware, this is a good candidate for stable
backporting.

 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
index 1f53a9f0c0ac3..e4144b2443324 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
@@ -1157,6 +1157,11 @@ static bool setup_dsc_config(
 	if (!is_dsc_possible)
 		goto done;
 
+	/* increase miniumum slice count to meet sink slice width limitations */
+	min_slices_h = dc_fixpt_ceil(dc_fixpt_max(
+			dc_fixpt_div_int(dc_fixpt_from_int(pic_width), dsc_common_caps.max_slice_width), // sink min
+			dc_fixpt_from_int(min_slices_h))); // source min
+
 	min_slices_h = fit_num_slices_up(dsc_common_caps.slice_caps, min_slices_h);
 
 	/* increase minimum slice count to meet sink throughput limitations */
-- 
2.51.0

