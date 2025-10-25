Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDDC1F12F8;
	Sat, 25 Oct 2025 16:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408961; cv=none; b=k2MvqC41KCayFjvF8lTvRl+oT+uzlS9WtggzZlOcsfyoMSGhj+wVuyALknKg3sCNBNFULLze5acZq+Mkndpp3DE8TC6Watlx1+jUtO8MrnpHAjyrUkRILfoAHLSy5p2hcNxvGyhYJNoBV8hxw38kuiE/eo3iu4ipcrd+402Y3E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408961; c=relaxed/simple;
	bh=Se7CXFL4Uo48W3u+DbvFoo9vM8Z1l1NSp4MNKr/bUtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AsE7YRBxD0Lb/hr+Sj2waI9KSsEiMdGnAj6f5OhHtp9FlLIVtM+YzDGqnStMdNpRdn4JeqWiUpzYTiRO/uO71XLgQ/MyJ21Dx4ds7G9y3s8NHDePxmRje82npuZCqyuMqF2wKrE25F8FotWLTUwNv3dYpqDPG2OMwyikXPJsPjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FldUiHH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FldUiHH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D38C4CEFF;
	Sat, 25 Oct 2025 16:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408960;
	bh=Se7CXFL4Uo48W3u+DbvFoo9vM8Z1l1NSp4MNKr/bUtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FldUiHH/ZjvoIdFLwa7hZQiT1BJ4idQqcLyDtDJ67L3B8DBezzPzkTS2rDxL6pOK7
	 QmdeTatv1epJSwWUs7UJjxEZwM7Ubw5rSWnnI7lBDHnjFJ6wF1GXRY+3nzOm1Z/Ebf
	 V+pgKxP8A4AEwDMTXfrcy0QUNQQh1yLwwraSulgQgPy/cydd/Y5Bani1vK3qwQoGKs
	 oEIoTQS9FCaWYlOGqqXsym38qk4nPXrYWRYrf+7F4QQawLY9IdkGlG7svFQNhCY+vF
	 Z+/g8uw/NZJEOkkU1ELXuGx7/OBP1fVnJMwQcNTRdwsRvl3oLy1rni5bV+qQjz+Vsa
	 0qn5Aehhub1eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Strauss <michael.strauss@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	PeiChen.Huang@amd.com,
	meenakshikumar.somasundaram@amd.com,
	zhikai.zhai@amd.com,
	Brendan.Tam@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.6] drm/amd/display: Increase AUX Intra-Hop Done Max Wait Duration
Date: Sat, 25 Oct 2025 11:56:23 -0400
Message-ID: <20251025160905.3857885-152-sashal@kernel.org>
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

[ Upstream commit e3419e1e44b87d4176fb98679a77301b1ca40f63 ]

[WHY]
In the worst case, AUX intra-hop done can take hundreds of milliseconds as
each retimer in a link might have to wait a full AUX_RD_INTERVAL to send
LT abort downstream.

[HOW]
Wait 300ms for each retimer in a link to allow time to propagate a LT abort
without infinitely waiting on intra-hop done.
For no-retimer case, keep the max duration at 10ms.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - In `drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
    :1011`, `dpcd_exit_training_mode()` previously polled the sink for
    “intra‑hop AUX reply indication” clearing with a fixed 10 ms window
    using `for (i = 0; i < 10; i++) ... fsleep(1000);` (see `drivers/gpu
    /drm/amd/display/dc/link/protocols/link_dp_training.c:1024` and
    `:1027`).
  - The patch computes a per‑topology maximum wait based on the number
    of LTTPR retimers and changes the loop bound accordingly:
    - Introduces `lttpr_count = dp_parse_lttpr_repeater_count(link-
      >dpcd_caps.lttpr_caps.phy_repeater_cnt)` and
      `intra_hop_disable_time_ms = (lttpr_count > 0 ? lttpr_count * 300
      : 10)` so the poll waits up to 300 ms per retimer, defaulting to
      10 ms if none are present.
    - Changes the loop counter type from `uint8_t` to `uint32_t` to
      safely support multi‑second waits without overflow.
  - The poll still checks `DP_SINK_STATUS` for
    `DP_INTRA_HOP_AUX_REPLY_INDICATION` to go low and sleeps 1 ms per
    iteration via `fsleep(1000)`.

- Why it matters (bug being fixed)
  - For DP 2.0 (128b/132b), when exiting link training the source must
    wait for intra‑hop AUX reply indication to clear. With retimers,
    each hop may wait up to a full AUX_RD_INTERVAL to propagate the
    link‑training abort downstream; worst case can be “hundreds of
    milliseconds” per hop.
  - The prior fixed 10 ms total window can be too short, causing
    premature exit while retimers are still active. That can lead to
    spurious failures or retries after training, affecting users with
    LTTPR chains.
  - The new logic scales the wait to the actual retimer count,
    eliminating timeouts without risking indefinite waits.

- Context and correctness
  - The helper `dp_parse_lttpr_repeater_count()` already exists and is
    used elsewhere in DC to scale timeouts (e.g.,
    `link_dp_training_128b_132b.c:248` sets `cds_wait_time_limit` from
    the same count), so this change aligns with existing design
    patterns.
  - `lttpr_caps.phy_repeater_cnt` is populated during capability
    discovery (`link_dp_capability.c:1500+`), and invalid counts are
    handled (including forcing 1 in certain fixed‑VS cases), so the new
    wait computation is robust.
  - The change affects only the DP 2.0 path (`if (encoding ==
    DP_128b_132b_ENCODING)` in `dpcd_exit_training_mode()`), leaving DP
    1.x behavior untouched.
  - The loop counter upgrade to `uint32_t` is necessary to avoid
    overflow for waits >255 ms (a latent bug if the bound is raised).

- Risk assessment
  - Behavioral changes are confined to a small, well‑scoped polling loop
    in AMD DC’s DP training teardown. No architectural changes, no ABI
    changes, no new features.
  - Regression risk is low: non‑retimer systems keep the 10 ms max;
    retimer topologies get longer but finite waits (worst case ~2.4 s
    for 8 retimers).
  - The i915 driver also waits for the same intra‑hop indication to
    clear (up to 500 ms total; see
    `drivers/gpu/drm/i915/display/intel_dp_link_training.c:1119`), so
    waiting here is consistent with cross‑driver practice.

- Stable backport criteria
  - Fixes a real user‑visible reliability issue (training teardown races
    on DP 2.0 with retimers).
  - Small, contained change with clear rationale and no dependency on
    new infrastructure.
  - No feature enablement; minimal regression surface; targeted to a
    single function in AMD DC.

- Recommendation
  - Backport to stable trees that include AMD DC DP 2.0 (128b/132b)
    support. This improves link‑training robustness for LTTPR topologies
    with negligible risk for others.

 .../drm/amd/display/dc/link/protocols/link_dp_training.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
index 2dc1a660e5045..134093ce5a8e8 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -1018,7 +1018,12 @@ static enum link_training_result dpcd_exit_training_mode(struct dc_link *link, e
 {
 	enum dc_status status;
 	uint8_t sink_status = 0;
-	uint8_t i;
+	uint32_t i;
+	uint8_t lttpr_count = dp_parse_lttpr_repeater_count(link->dpcd_caps.lttpr_caps.phy_repeater_cnt);
+	uint32_t intra_hop_disable_time_ms = (lttpr_count > 0 ? lttpr_count * 300 : 10);
+
+	// Each hop could theoretically take over 256ms (max 128b/132b AUX RD INTERVAL)
+	// To be safe, allow 300ms per LTTPR and 10ms for no LTTPR case
 
 	/* clear training pattern set */
 	status = dpcd_set_training_pattern(link, DP_TRAINING_PATTERN_VIDEOIDLE);
@@ -1028,7 +1033,7 @@ static enum link_training_result dpcd_exit_training_mode(struct dc_link *link, e
 
 	if (encoding == DP_128b_132b_ENCODING) {
 		/* poll for intra-hop disable */
-		for (i = 0; i < 10; i++) {
+		for (i = 0; i < intra_hop_disable_time_ms; i++) {
 			if ((core_link_read_dpcd(link, DP_SINK_STATUS, &sink_status, 1) == DC_OK) &&
 					(sink_status & DP_INTRA_HOP_AUX_REPLY_INDICATION) == 0)
 				break;
-- 
2.51.0

