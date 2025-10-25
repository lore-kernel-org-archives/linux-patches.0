Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3DE205AB6;
	Sat, 25 Oct 2025 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408574; cv=none; b=RSJZkc8wkt1ImmwPw6A0hFmeLlgqSkmwQtWU7rUQPIxhnWGyi5wwXIzWmJHrEp763QzeZqL/sq1nS8lsGVEH/CwSsTCz3/crRPNlKFUlGnNIN7NlcGkjVh52HJe2MyyPzmOcSE3JhCJM38NwTqCkd/4xIy/cZux5aO10vyjEHX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408574; c=relaxed/simple;
	bh=GlLpGMADaZvuf4+FJmhokAYc5ZoXqan5EcarXq450wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQmSUyBjSQCJ+lcDa3aaN2It0BixrThR7e3iGi4pIvOHdfmFNwpxmVCoeu41GbfjVUZZCPqdXO2FjU4q/3l32tbUw2kclEcc3QRkq0TooaqI2hBcEh3OfavC9oDLinwciy0fekXr9BD/seGCQHCBzfJq7xZEbJOJtMQLtEZk0Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRqtLvNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRqtLvNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15947C4CEFB;
	Sat, 25 Oct 2025 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408571;
	bh=GlLpGMADaZvuf4+FJmhokAYc5ZoXqan5EcarXq450wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRqtLvNnC++mhTCvWPhsXy/KhixZOq9Gzbe3a8YqgQhYEqsoZtzMJACHtHCZq1uWn
	 4MDDJMeaxAEpfjOFLlO2ol/9ggwizlVC5wAap08tL9edt4ghd7GQ1rdiP6Dtqe+Ibr
	 57cDRVl39jInULbms11lPEwAn0DaY28oprYsk2c2oX7gHYguSmeTT5PC/84EGCB3Ad
	 Kboz/dQ8g5IFg0wza7MMKZb67ov6DXlBtWvLcQdcXy51HBAH99G0UBcPqxPAp0xMs1
	 RIBXZJG/1ZhGVMNLUfH1+EoVwvYxllYYI4O4zaY7P15vRHOb5KX1UHvqhi91GjvHgu
	 hCOvWZuLHdMmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ostrowski Rafal <rostrows@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Alvin.Lee2@amd.com,
	nicholas.kazlauskas@amd.com,
	dillon.varone@amd.com,
	alex.hung@amd.com,
	okuzhyln@amd.com,
	leo.chen@amd.com,
	alexandre.f.demers@gmail.com,
	Ovidiu.Bunea@amd.com,
	peterson.guo@amd.com,
	joshua.aberback@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: Update tiled to tiled copy command
Date: Sat, 25 Oct 2025 11:54:00 -0400
Message-ID: <20251025160905.3857885-9-sashal@kernel.org>
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

From: Ostrowski Rafal <rostrows@amd.com>

[ Upstream commit 19f76f2390be5abe8d5ed986780b73564ba2baca ]

[Why & How]
Tiled command rect dimensions is 1 based, do rect_x/y - 1 internally

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Ostrowski Rafal <rostrows@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

- What changed
  - In `drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c`, function
    `dmub_lsdma_send_tiled_to_tiled_copy_command`, the fields `rect_x`
    and `rect_y` are now encoded as `params.rect_x - 1` and
    `params.rect_y - 1` instead of passing the values through
    unmodified.
  - The rest of the command payload remains unchanged, including the
    existing “minus-one” encoding for dimensions:
    - `src_width = params.src_width - 1`
    - `dst_width = params.dst_width - 1`
    - `src_height = params.src_height - 1`
    - `dst_height = params.dst_height - 1`

- Why it matters
  - The commit message explicitly states that the “tiled command rect
    dimensions is 1 based,” so the command fields must be encoded as N-1
    before being sent to the LSDMA controller. Prior to this change,
    `rect_x`/`rect_y` were not adjusted, creating an off-by-one error
    relative to the hardware’s expected encoding.
  - This bug would cause the copied rectangle to be shifted by one unit
    (tile/element) in both X and Y, leading to incorrect or corrupted
    copies. Near edges, it could also risk out-of-bounds accesses by the
    DMA engine (a correctness and potential stability issue).
  - The fix makes `rect_x`/`rect_y` consistent with the already-correct
    “minus-one” encoding used for width and height fields in the same
    command packet, aligning all rectangle-related fields with the LSDMA
    protocol.

- Scope and risk
  - Change is minimal and fully localized to two assignments in a single
    function that builds the DMUB LSDMA “tiled-to-tiled copy” command.
  - No architectural changes, no new features, and no behavior changes
    outside this specific command payload.
  - The driver-side `params.rect_x/rect_y` are documented/assumed as
    1-based in this path (consistent with the commit message);
    subtracting 1 before writing the command field is the correct, low-
    risk fix.
  - Potential regression risk is low: the only hazard would be if any
    caller had incorrectly pre-applied the minus-one encoding already,
    which is unlikely given the commit rationale and the inconsistency
    that previously existed only for rect_x/rect_y (while width/height
    were already encoded as -1).

- Stable backport considerations
  - Fixes a real, user-visible bug (off-by-one in copy origin) that can
    cause display corruption and possibly out-of-bounds DMA on edge
    cases.
  - The patch is simple, small, and self-contained with minimal
    regression risk.
  - No API or ABI changes; no dependencies on other changes.
  - Although the commit message lacks a “Fixes:” or “Cc: stable” tag, it
    squarely fits stable criteria.
  - Practical applicability: Only relevant for stable branches that
    already include `dmub_lsdma_send_tiled_to_tiled_copy_command` and
    use the LSDMA tiled-to-tiled copy path. For branches without this
    code path, the patch is not applicable.

- Conclusion
  - This is a straightforward, correctness fix for an off-by-one error
    in the DMUB LSDMA tiled-to-tiled copy command encoding. It should be
    backported to all stable kernels that contain this functionality.

 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index f5ef1a07078e5..714c468c010d3 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -2072,8 +2072,8 @@ bool dmub_lsdma_send_tiled_to_tiled_copy_command(
 	lsdma_data->u.tiled_copy_data.dst_swizzle_mode = params.swizzle_mode;
 	lsdma_data->u.tiled_copy_data.src_element_size = params.element_size;
 	lsdma_data->u.tiled_copy_data.dst_element_size = params.element_size;
-	lsdma_data->u.tiled_copy_data.rect_x           = params.rect_x;
-	lsdma_data->u.tiled_copy_data.rect_y           = params.rect_y;
+	lsdma_data->u.tiled_copy_data.rect_x           = params.rect_x - 1;
+	lsdma_data->u.tiled_copy_data.rect_y           = params.rect_y - 1;
 	lsdma_data->u.tiled_copy_data.dcc              = params.dcc;
 	lsdma_data->u.tiled_copy_data.tmz              = params.tmz;
 	lsdma_data->u.tiled_copy_data.read_compress    = params.read_compress;
-- 
2.51.0

