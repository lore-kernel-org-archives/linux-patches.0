Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81D330AAC8;
	Sat, 25 Oct 2025 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409498; cv=none; b=N+KhG5z8MizyZjt2ThjF5xoSP4X1TCZavybTg+hYQRN8pprf7jwZVjrL2O5kDQZahW6nh8yzZJIASwYifGy4reA882sy7e92YFLQQi4MsM0ghRpVuP77g4/MI0fzNw6je0ilJ19/PTVdjeiy+YszL3ZSw1UtQ+q/1ZOFuhhFKZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409498; c=relaxed/simple;
	bh=p/mdZYVhq0/E6BZT9IEr4WhxhL8Z131cny08++VMhsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d8A3codsM4mLKVQZg3hDjpHo/wAoEWdyx/0JGKq5gkrS4cPiU4H7bkLa6D4Qp94YYMR8H44DhY/R/CGdPhVjYNl1Fydn7Wjv5DShtNQHbOPlDNrfxERhWHYspQWioVH/qSL9Ke7cS3w6KRp7CLxzOU3iq1FO4HqBzMhcL4C8T/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WuE7tZPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WuE7tZPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DA9C4CEFF;
	Sat, 25 Oct 2025 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409498;
	bh=p/mdZYVhq0/E6BZT9IEr4WhxhL8Z131cny08++VMhsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuE7tZPIySha3aULJTz70z7q8X8XDDmeCm9MY+MjcnIs11k0lGg9mMkp/SrXmalaD
	 7t5InrJAY5yiBKj0FIZb8uGWk2anKM0zeEGZo2sbDPiv/xOgRMrrIZp/4xLs6uI/8X
	 H48wQPXXa3ZcaWtRLpup39QrD5XHea5S5fG1O9Ng18FfkiAmHEFY469vd7CzLB90+N
	 Ndx9ux7Lyaz36cl0OxTDKuQeaoNh77MciZlFXbQ3wxbYxJOzPhWp5O4jClKR1ZN7my
	 0xr/lw41CGx+cn0NtJJa7n4LtfjnuOGr23WTV7nvfM+o9sPky2mHs2BDOYBWDvJ443
	 AswDHLDyIetFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Clay King <clayking@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Wayne.Lin@amd.com,
	roman.li@amd.com,
	ray.wu@amd.com,
	PeiChen.Huang@amd.com,
	Dillon.Varone@amd.com,
	Charlene.Liu@amd.com,
	Sung.Lee@amd.com,
	alexandre.f.demers@gmail.com,
	Richard.Chiang@amd.com,
	ryanseto@amd.com,
	linux@treblig.org,
	mario.limonciello@amd.com
Subject: [PATCH AUTOSEL 6.17-6.6] drm/amd/display: ensure committing streams is seamless
Date: Sat, 25 Oct 2025 11:59:42 -0400
Message-ID: <20251025160905.3857885-351-sashal@kernel.org>
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

From: Clay King <clayking@amd.com>

[ Upstream commit ca74cc428f2b9d0170c56b473dbcfd7fa01daf2d ]

[Why]
When transitioning between topologies such as multi-display to single
display ODM 2:1, pipes might not be freed before use.

[How]
In dc_commit_streams, commit an additional, minimal transition if
original transition is not seamless to ensure pipes are freed.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Clay King <clayking@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Summary
- Fixes a real, user-visible bug where non‑seamless topology transitions
  can reuse pipes before they are freed, causing underflow/corruption or
  visible glitches.
- Small, localized change that mirrors an already‑used mitigation in
  other DC update paths.
- No new features or ABI changes; guarded by existing hwss hook; low
  regression risk if prerequisites are present.

What the commit does
- In dc_commit_streams, after building the new context and validating
  it, it inserts a guard:
  - If hwss indicates the pipe‑topology transition is not seamless,
    perform an intermediate “minimal transition” commit before
    committing the target state.
  - This frees up pipes cleanly and makes the final transition seamless.

Why it matters
- Without this, transitions like multi‑display → single‑display ODM 2:1
  can leave pipes allocated and immediately reuse them, which risks
  corruption/glitches.
- The “minimal transition” sequence is the established way to safely
  reconfigure pipes to a minimal configuration before the final state.

Code context and references
- Current dc_commit_streams validates the new state then commits it
  directly:
  - Validation: drivers/gpu/drm/amd/display/dc/core/dc.c:2177
  - Commit: drivers/gpu/drm/amd/display/dc/core/dc.c:2183
- It only special‑cases ODM 2:1 exit before validation:
  - ODM 2:1 handling: drivers/gpu/drm/amd/display/dc/core/dc.c:2155-2169
- The proposed patch adds a seamlessness check between validation and
  commit:
  - Calls hwss.is_pipe_topology_transition_seamless(dc, current_state,
    context), and if false, performs commit_minimal_transition_state(dc,
    context).
- This aligns dc_commit_streams with update_planes paths, which already
  perform the same seamlessness guard and minimal transition:
  - Seamless check and minimal transition in update path:
    drivers/gpu/drm/amd/display/dc/core/dc.c:4957-4961
- The seamlessness predicate hook was introduced earlier and implemented
  for DCN32:
  - Hook declaration:
    drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h:410+
  - Implementation example:
    drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c (function
    dcn32_is_pipe_topology_transition_seamless)

Stability and regression risk
- Change is confined to the AMD DC commit path and only triggers when
  the hwss hook reports a non‑seamless transition.
- Uses an existing, widely used helper (commit_minimal_transition_state)
  that already has many refinements:
  - E.g., skipping forced ODM during minimal transition to keep it
    seamless (b04c21abe21ff), and generic non‑seamless detection and
    handling (d2dea1f140385, related v3 sequence work).
- No architectural changes; behavior mirrors already‑trusted logic in
  plane/stream update.
- Potential minor performance impact (an extra, minimal intermediate
  commit) only when necessary; functional correctness/glitch avoidance
  outweighs this.

Prerequisites and backport considerations
- Requires the hwss.is_pipe_topology_transition_seamless hook and its
  implementation (added by “drm/amd/display: add seamless pipe topology
  transition check”). Stable trees lacking this will need that
  prerequisite backported first.
- In some branches dc_validate_with_context signature differs:
  - In this tree it takes a `bool fast_validate`
    (drivers/gpu/drm/amd/display/dc/dc.h:1570-1574).
  - The patch snippet shows a newer enum mode
    (DC_VALIDATE_MODE_AND_PROGRAMMING). When backporting, keep using the
    existing boolean call pattern.
- commit_minimal_transition_state return type varies by branch (bool vs
  enum in the snippet). In this tree it returns bool
  (drivers/gpu/drm/amd/display/dc/core/dc.c:4551). Adapt the return
  check accordingly during backport.

Conclusion
- This is a targeted bug fix that prevents visible glitches and
  underflow by ensuring a seamless intermediate transition in
  dc_commit_streams. It aligns commit behavior with other DC update
  paths and is guarded by a capability hook. With prerequisites present,
  it is a strong candidate for stable backport.

 drivers/gpu/drm/amd/display/dc/core/dc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index bb189f6773397..bc364792d9d31 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2413,6 +2413,18 @@ enum dc_status dc_commit_streams(struct dc *dc, struct dc_commit_streams_params
 		goto fail;
 	}
 
+	/*
+	 * If not already seamless, make transition seamless by inserting intermediate minimal transition
+	 */
+	if (dc->hwss.is_pipe_topology_transition_seamless &&
+			!dc->hwss.is_pipe_topology_transition_seamless(dc, dc->current_state, context)) {
+		res = commit_minimal_transition_state(dc, context);
+		if (res != DC_OK) {
+			BREAK_TO_DEBUGGER();
+			goto fail;
+		}
+	}
+
 	res = dc_commit_state_no_check(dc, context);
 
 	for (i = 0; i < params->stream_count; i++) {
-- 
2.51.0

