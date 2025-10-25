Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EA42FF168;
	Sat, 25 Oct 2025 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408736; cv=none; b=QTQRVw9hJ+RFEarHMSLXaHTDtBQmjQtFkdbIZ5mQbRhSkfhVBB1qL9khju01TIafqiairdbvcWFn41epiCRRX1fKO/DxqT42xLGTV41N9tp9k3ze8qB20cqPLFDiaCilWLlc5TByIpobmMaDad/zcmPd3ZPctqclGr/vAVnTrY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408736; c=relaxed/simple;
	bh=dCp69jAFQvKApclgseswChTp6mqPlgHZfhBGgv7mBX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ozq6sFFabZ3nyjY0/3pfoFDWg1JARYiE2m/xpQFzf90vyhAekQ5pQ05bHs2VdNT5lEylFaZWJA7D/A84PtvOSBczkVWtqPnK7XodSjVdr5HhurU4mSKOhn3X5opcaxPI4L0FZum1qUq14aPD/GEwrAjAf9jUHQIXsLZV619TPUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jehu+COs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jehu+COs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9CEC4CEF5;
	Sat, 25 Oct 2025 16:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408736;
	bh=dCp69jAFQvKApclgseswChTp6mqPlgHZfhBGgv7mBX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jehu+COsfrDnI4g7R4WZ4pIF9r6BcD3yfV+oTL0+oSS30nr4S1Cv3q8nRj6u93KDc
	 SvCTNmOHROE86ELOzGU+t9HaT0YFCVHOcbgfiHhCkM1vC30GfeRcuY+C+ytub6n6Rl
	 jYfle8D+JtnasMsK3tCjn8t8pHZKbDINJx8MQhyE+s5QKhmjtauLfcQnP5EatJwK1c
	 Q8Vys98w2YtKffR+dehQD2SYVEYQ6j/EQ5tFpcSKOaHYxWdhUjGDIv5pOGofBWFeKg
	 pVtyJFIWLXsLvQu8zoRHr0iz4sFWyZly38Cx7HzZG7b3RNcMFWpOekA+LLJw9C/ecw
	 XZlqX0KknzT9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Strauss <michael.strauss@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	ray.wu@amd.com,
	alexandre.f.demers@gmail.com,
	srinivasan.shanmugam@amd.com,
	Martin.Leung@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: Cache streams targeting link when performing LT automation
Date: Sat, 25 Oct 2025 11:54:49 -0400
Message-ID: <20251025160905.3857885-58-sashal@kernel.org>
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

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit f5b69101f956f5b89605a13cb15f093a7906f2a1 ]

[WHY]
Last LT automation update can cause crash by referencing current_state and
calling into dc_update_planes_and_stream which may clobber current_state.

[HOW]
Cache relevant stream pointers and iterate through them instead of relying
on the current_state.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

- Fixes a real crash: The commit addresses a crash during DisplayPort
  Link Training (LT) automation caused by iterating over
  `dc->current_state->streams` while calling
  `dc_update_planes_and_stream()`, which can swap and free the current
  DC state. The risk comes from referencing `state->streams[i]` after
  the call may invalidate `state`. The existing code does exactly this
  in the DPMS-on path:
  drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c:141 and
  again dereferences in the update call at
  drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c:145.

- Root cause validated in core DC: Inside
  `dc_update_planes_and_stream()`, the driver may allocate a new state
  and swap it in as `dc->current_state`, then release the old one:
  drivers/gpu/drm/amd/display/dc/core/dc.c:4695 and
  drivers/gpu/drm/amd/display/dc/core/dc.c:4696 (also in the v2 flow at
  drivers/gpu/drm/amd/display/dc/core/dc.c:5311). This exactly matches
  the commit’s WHY: “calling into dc_update_planes_and_stream … may
  clobber current_state.”

- Minimal, targeted change: The patch caches stream pointers that match
  the target link before any updates, then iterates over that cached
  list, avoiding any reliance on the possibly-invalidated
  `current_state`. Specifically, it:
  - Adds a local `struct dc_stream_state *streams_on_link[MAX_PIPES];`
    and `int num_streams_on_link = 0;`.
  - First loop: scans `state->streams` (bounded by `MAX_PIPES`) and
    stores streams whose `stream->link == link`.
  - Second loop: performs the DPMS-on `dc_update_planes_and_stream()`
    using the cached `streams_on_link[i]` instead of indexing
    `state->streams[i]`.
  - This removes the usage pattern that could dereference freed or
    reshuffled `state->streams`.

- Safety of array bounds: Using `MAX_PIPES` is correct for
  `dc_state->streams[]`, which is declared as `streams[MAX_PIPES]` with
  `stream_count` as a separate count field:
  drivers/gpu/drm/amd/display/dc/inc/core_types.h:598 and
  drivers/gpu/drm/amd/display/dc/inc/core_types.h:616.

- Scope and side effects:
  - The change is confined to a single function in one file:
    drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c, used
    by DP CTS automation and debugfs-triggered training routines (see
    call sites at
    drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c:591
    and drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c:321,
    :335, :455, :470, :3451, :3466).
  - No architectural changes. No new features. It’s a non-invasive
    correctness fix that avoids iterating over a state that may be
    swapped out mid-loop.
  - Risk of regression is low: logic mirrors existing behavior, only
    replacing “live read from `state->streams`” with a pre-cached
    snapshot. The link-matching predicate is unchanged.

- Impact to users:
  - Prevents kernel crashes during DP LT automation and the debugfs
    paths that adjust preferred link settings/training. While not a
    typical end-user path, it is a valid in-kernel path and a kernel
    crash is a serious bug.

- Alignment with stable rules:
  - Important bugfix that prevents a crash.
  - Small, well-contained, no new features, no architectural
    refactoring.
  - Touches a specific subsystem (AMDGPU DC DP accessory/CTS code) with
    minimal blast radius.
  - No explicit “Cc: stable” tag in the message, but the fix is
    straightforward and clearly justified.

Notes

- The patch still calls
  `dc_update_planes_and_stream(state->clk_mgr->ctx->dc, ...)`. Given the
  state swapping, using `link->dc` instead of `state->clk_mgr->ctx->dc`
  would be even more robust. However, the primary crash cause was
  iterating `state->streams` after the swap; caching streams resolves
  that. The rest of the code’s use of `state` is unchanged from pre-
  patch and has not been reported as problematic in this path.

Conclusion

- This is a clear, minimal crash fix in AMD DC’s DP LT automation path.
  It should be backported to stable trees where the affected code is
  present.

 .../display/dc/link/accessories/link_dp_cts.c  | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
index b12d61701d4d9..23f41c99fa38c 100644
--- a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
+++ b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
@@ -76,6 +76,9 @@ static void dp_retrain_link_dp_test(struct dc_link *link,
 	uint8_t count;
 	int i;
 
+	struct dc_stream_state *streams_on_link[MAX_PIPES];
+	int num_streams_on_link = 0;
+
 	needs_divider_update = (link->dc->link_srv->dp_get_encoding_format(link_setting) !=
 	link->dc->link_srv->dp_get_encoding_format((const struct dc_link_settings *) &link->cur_link_settings));
 
@@ -138,12 +141,19 @@ static void dp_retrain_link_dp_test(struct dc_link *link,
 		pipes[i]->stream_res.tg->funcs->enable_crtc(pipes[i]->stream_res.tg);
 
 	// Set DPMS on with stream update
-	for (i = 0; i < state->stream_count; i++)
-		if (state->streams[i] && state->streams[i]->link && state->streams[i]->link == link) {
-			stream_update.stream = state->streams[i];
+	// Cache all streams on current link since dc_update_planes_and_stream might kill current_state
+	for (i = 0; i < MAX_PIPES; i++) {
+		if (state->streams[i] && state->streams[i]->link && state->streams[i]->link == link)
+			streams_on_link[num_streams_on_link++] = state->streams[i];
+	}
+
+	for (i = 0; i < num_streams_on_link; i++) {
+		if (streams_on_link[i] && streams_on_link[i]->link && streams_on_link[i]->link == link) {
+			stream_update.stream = streams_on_link[i];
 			stream_update.dpms_off = &dpms_off;
-			dc_update_planes_and_stream(state->clk_mgr->ctx->dc, NULL, 0, state->streams[i], &stream_update);
+			dc_update_planes_and_stream(state->clk_mgr->ctx->dc, NULL, 0, streams_on_link[i], &stream_update);
 		}
+	}
 }
 
 static void dp_test_send_link_training(struct dc_link *link)
-- 
2.51.0

