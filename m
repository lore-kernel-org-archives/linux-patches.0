Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40455883C3;
	Mon, 31 Aug 2026 13:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184217; cv=none; b=MrYaOIGQfHgdwhYBz3TWjg23U9SjGESw9+3vtTsOle/DgUMJvbopcSLKIyxblyZjcIamp70o059TxB5ks0KQAix7t2xKSdG7+h1L1sxu9+rTqjdjsGNG5iQJMDZllKQH+YK5Keg89PjdZlKkEI97q1NeBypwPhiCpjmLCgrA7WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184217; c=relaxed/simple;
	bh=YCF+eNE6+T2D6QqWAcz1qWyE8sySlbHtUEAfsOBzrRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XPYzpqirDUB9qhrc2ZBzZwfn4IVa04VxJYmltz24DmsnA+S59yPrvQHjYN3xFodVBa2GkhgrTqzG4qkMbyM7t3rnCbGO5NkbWOSalQL+nNdUW6zWUlX6W/WcootJXLdTKWz1co3aTc1zsJUscN4eCmEqT4HUD9WKzGu3ECgcGCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTiAIGfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTiAIGfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6427E1F00ACF;
	Mon, 31 Aug 2026 13:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184214;
	bh=X5JSczIqqrXgLmX9GdYXKaTc+21EA5Z4/dPe2QB8BoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TTiAIGfPPRTZ8/JPHmhoWUrWlY8AR/pds2Bxsg9RoPikORVEKGmQE0Mw+ywZPxMhh
	 XT6uNOHJ/vtp1lbikRqs1HuAFLToEEEOI+HDOOqo0ifBkE2oI4bOjFDZrZppGTLZgG
	 JlgWhLONLHlW8GSjC3IouJBjHJ5mDeADN7+uUUD5XnezOpZGfYrNqcvEZoFfYRZjb+
	 U67CJx/Nc9bNNCSbXyoMHoKiteg+c308XzU7FBvVUii8pdtQVtIFwx7hUyhA8YCVlR
	 dRsnzOPHtUQrI2yxfM+HM69cOKYb+PcgiwVLWsWQgEEI4uN9SPOSg0S23iMNmqv5Dr
	 AGR6Mx7eC6bnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	James Lin <pinglei.lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amd/display: Find link encoder for flexible DIG mapping cases
Date: Mon, 31 Aug 2026 09:29:48 -0400
Message-ID: <20260831133314.4125787-560-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ovidiu Bunea <ovidiu.bunea@amd.com>

[ Upstream commit 74ef54e656e7006cfc215e960b0cf2720a7a3d48 ]

[why & how]
link->link_enc can only be used to identify the link's link encoder
when the link is not permitted to use flexible link encoder
assignments.

Use the correct function for identifying link encoder and add
function pointer guards before calling them.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: James Lin <pinglei.lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[drm/amd/display]` `[Find]` — Correct link-encoder lookup in
`power_down_encoders()` for flexible DIG mapping.

**Step 1.2 — Tags**
Record:
- Reviewed-by: Wenjing Liu \<wenjing.liu@amd.com\>
- Signed-off-by: Ovidiu Bunea, James Lin, Alex Deucher
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable tags

**Step 1.3 — Body**
Record:
- Bug: `link->link_enc` is only valid when the link does not use
  flexible link-encoder assignment.
- Symptom: Wrong encoder used (or dereferenced) during encoder power-
  down.
- Root cause: `power_down_encoders()` used `link->link_enc` instead of
  the dynamic lookup API.
- Fix: Use `link_enc_cfg_get_link_enc(link)` and guard function pointers
  before calling them.

**Step 1.4 — Hidden bug fix?**
Record: Yes. Although the subject does not say "fix", the body and diff
clearly address incorrect encoder identification and missing NULL guards
— a real correctness/crash bug, not cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c` (+7
  / -5)
- Function: `power_down_encoders()`
- Scope: Single-file, surgical fix

**Step 2.2 — Code flow**
Record:
- Hunk 1: `link->link_enc` → `link_enc_cfg_get_link_enc(link)` — uses
  dynamically assigned encoder for flexible-mapping links.
- Hunk 2: `disable_output` only called when `link_enc` is non-NULL.
- Hunk 3: FEC disable wrapped in checks for `link_enc`,
  `fec_set_enable`, and `fec_set_ready`.

**Step 2.3 — Bug mechanism**
Record:
- Category: Logic/correctness + NULL pointer dereference.
- For `is_dig_mapping_flexible` links (USB4/DPIA), `link->link_enc` is
  not the assigned encoder; DPIA link construction even has `/* TODO:
  Create link encoder */` and never sets `link->link_enc`.
- FEC disable added by commit `5f0c5775d4eeb` calls
  `link_enc->funcs->...` without NULL checks on a potentially NULL/wrong
  encoder.

**Step 2.4 — Fix quality**
Record: Obviously correct; matches the pattern already used at line 1163
in the same file and throughout the DC subsystem. Minimal regression
risk — for non-flexible links, `link_enc_cfg_get_link_enc()` returns
`link->link_enc`.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Lines 1734–1748 introduced/modified by `5f0c5775d4eeb` ("Disable
FEC when powering down encoders", Jan 2026). Earlier
`power_down_encoders()` structure dates to `19eef1d98eeda`. The FEC
addition created the vulnerable path in this tree.

**Step 3.2 — Fixes: tag**
Record: N/A — no Fixes: tag present.

**Step 3.3 — Related file history**
Record: FEC commit `5f0c5775d4eeb` (upstream `8cee62904caf9`) is in this
6.18.y tree and is the direct prerequisite/introducer of the buggy code.
`link_enc_cfg_get_link_enc()` and `is_dig_mapping_flexible`
infrastructure are present.

**Step 3.4 — Author context**
Record: Ovidiu Bunea also authored the FEC power-down commit. Alex
Deucher is AMD DRM maintainer. Patch is standalone within a 17-patch AMD
DC batch series.

**Step 3.5 — Dependencies**
Record: No code dependencies on other patches in the series. Uses
existing `link_enc_cfg_get_link_enc()` from `link_enc_cfg.h`, which is
already included in `dce110_hwseq.c`. Standalone backport.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record: [PATCH 12/17] on amd-gfx, Apr 29 2026 —
https://lists.freedesktop.org/archives/amd-gfx/2026-April/143792.html.
Part of "DC Patches May 4 2026" series
(https://lists.freedesktop.org/archives/amd-gfx/2026-April/143780.html).
No replies or stable nominations found in the thread.

**Step 4.2 — Reviewers**
Record: Reviewed-by Wenjing Liu (AMD display). Signed-off-by Alex
Deucher (maintainer). `b4 dig -c 8cee62904caf9` found no lore match for
the related FEC commit.

**Step 4.3 — Bug report**
Record: No external bug report. Related FEC commit describes "no light
up" when FEC disable targets the wrong DIG encoder — same underlying
class of failure.

**Step 4.4 — Series context**
Record: Patch 12/17 in a 17-patch AMD internal batch (121 files total).
This patch alone touches one function in one file and is independent of
the larger series changes.

**Step 4.5 — Stable list**
Record: lore.kernel.org/stable search blocked by bot protection; no
stable discussion found.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `power_down_encoders()`, `link_enc_cfg_get_link_enc()`,
`dce110_power_down()`.

**Step 5.2 — Callers**
Record: `power_down_encoders()` ← `power_down_all_hw_blocks()` ← display
mode-commit path (~line 2013) and `dce110_power_down()` (~line 2678).
`dce110_power_down` is the `.power_down` hook for all DCN generations
(dcn10 through dcn401).

**Step 5.3 — Callees**
Record: `link_enc_cfg_get_link_enc()`, `blank_dp_stream()`,
`disable_output()`, `fec_set_enable()`, `fec_set_ready()`.

**Step 5.4 — Reachability**
Record: Triggered on display mode changes, suspend/resume, and DC power-
down — common user-visible paths. Affects systems with USB4/DPIA or
other flexible DIG-mapping links.

**Step 5.5 — Similar patterns**
Record: Same file line 1163, `link_dp_phy.c` lines 149–187, and many
other DC paths already use `link_enc_cfg_get_link_enc()` with NULL
guards. `power_down_encoders()` was an outlier.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

**Step 6.1 — Buggy code present?**
Record: Yes. Current tree at lines 1734–1748 still uses `link->link_enc`
without NULL guards. `is_dig_mapping_flexible`,
`link_enc_cfg_get_link_enc()`, and FEC power-down code are all present.

**Step 6.2 — Backport difficulty**
Record: Clean apply expected. `link_enc_cfg.h` already included; no
structural conflicts.

**Step 6.3 — Related fixes already present?**
Record: FEC power-down commit `5f0c5775d4eeb` is present; this follow-up
fix is not.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem/criticality**
Record: `drivers/gpu/drm/amd/display` — IMPORTANT (AMD GPU display
driver, affects display output on affected hardware).

**Step 7.2 — Activity**
Record: Actively maintained; recent FEC power-down commit in this tree.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: AMD GPU users with flexible DIG link-encoder mapping (USB4/DPIA
links confirmed; `is_dig_mapping_flexible` set in `construct_dpia()`).
All DCN-based AMD GPUs use `dce110_power_down`.

**Step 8.2 — Trigger conditions**
Record: Display power-down during mode changes, suspend/resume, or DC
teardown when FEC was enabled or a flexible-mapping link needs encoder
operations. Moderately common on affected hardware.

**Step 8.3 — Failure mode**
Record:
- Wrong encoder → FEC not disabled on correct DIG → display fails to
  light up (documented in related FEC commit).
- NULL `link_enc` on DPIA links → kernel oops from
  `link_enc->funcs->...`.
- Severity: HIGH (display failure or crash).

**Step 8.4 — Risk/benefit**
Record: Benefit HIGH for affected hardware. Risk LOW — 12-line change,
follows established API, backward-compatible for fixed-mapping links.

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Fixes real display bug and potential NULL dereference
- Small, surgical, obviously correct
- Prerequisites (`link_enc_cfg_get_link_enc`, FEC power-down) exist in
  6.18.y
- Reviewed by AMD display engineer; signed off by maintainer
- Follow-up to an already-backported FEC fix (`5f0c5775d4eeb`)
- Matches established patterns throughout the same subsystem

**Evidence AGAINST:**
- Only affects flexible DIG-mapping hardware (primarily USB4/DPIA), not
  all AMD users
- Part of a large AMD batch series (but this patch is self-contained)

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** (code review by AMD; pattern
   used elsewhere; no runtime test tag)
2. Fixes a real bug? **PASS**
3. Important issue? **PASS** (display failure / possible oops)
4. Small and contained? **PASS** (one function, one file)
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS**

**Exception category:** Not applicable (hardware quirk/workaround
category does not apply; this is a driver logic fix).

---

## Problem Summary

Commit `5f0c5775d4eeb` added FEC disable logic to
`power_down_encoders()` using `link->link_enc` directly. For links with
flexible DIG encoder assignment, that field is not the currently
assigned encoder — and for USB4/DPIA links it is never created at all
(`construct_dpia()` has a "TODO: Create link encoder" comment). The
result is either operating on the wrong hardware block (display does not
light up) or dereferencing NULL (kernel oops). This commit corrects the
lookup and adds the guards that other DC code paths already use.

For the 6.18.y tree specifically: the buggy code and all prerequisites
are present, the FEC fix is already backported, and this small follow-up
completes that fix for flexible-mapping cases.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  lore page
- [Phase 2] Read current `power_down_encoders()` at lines 1728–1753 in
  `dce110_hwseq.c`
- [Phase 3] `git blame -L 1734,1748`: FEC commit `5f0c5775d4eeb`
  introduced vulnerable lines
- [Phase 3] `git show 5f0c5775d4eeb` and `git show 8cee62904caf9`: FEC
  commit present in tree
- [Phase 3] `git log --oneline -5 -- dce110_hwseq.c`: confirmed FEC
  commit is most recent change to this function
- [Phase 4] Fetched amd-gfx lore pages for patch 12/17 and series cover
  letter
- [Phase 4] `b4 dig -c 8cee62904caf9`: no lore match (tool limitation,
  not analysis blocker)
- [Phase 5] `grep
  power_down_encoders/power_down_all_hw_blocks/dce110_power_down`:
  traced call chain
- [Phase 5] `grep link_enc_cfg_get_link_enc`: confirmed widespread use
  of correct API in subsystem
- [Phase 5] Read `construct_dpia()` in `link_factory.c` lines 760–827:
  DPIA links set `is_dig_mapping_flexible = true`, no `link_enc` created
- [Phase 5] Read `link_enc_cfg_get_link_enc()` in `dc_link_enc_cfg.c`
  lines 550–568: flexible vs fixed logic verified
- [Phase 5] Read `dp_set_fec_enable()` in `link_dp_phy.c` lines 180–188:
  NULL guard pattern confirmed
- [Phase 6] `git describe HEAD`: v6.18.43-1-gc7f0dac02d232 (6.18.y
  stable tree)
- [Phase 6] Confirmed fix not yet applied (line 1734 still uses
  `link->link_enc`)
- [Phase 6] Confirmed `link_enc_cfg.h` included at line 49 of
  `dce110_hwseq.c`
- [Phase 6] `grep .power_down = dce110_power_down`: all DCN init files
  use this path
- [Phase 8] Read FEC commit message: "no light up" failure mode
  documented for wrong DIG encoder

**YES****Verdict: YES** — this commit should be backported to the 6.18.y
tree.

It fixes a real bug in `power_down_encoders()` where `link->link_enc` is
used directly instead of `link_enc_cfg_get_link_enc()`. On flexible DIG-
mapping links (notably USB4/DPIA), that can mean the wrong encoder is
targeted or a NULL pointer is dereferenced during power-down — causing
display failures or a kernel oops. The fix is small, self-contained, and
the prerequisite FEC power-down commit (`5f0c5775d4eeb`) is already in
this tree.

 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c    | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 8f86177de48dc..0841b1d0b7775 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1731,20 +1731,22 @@ static void power_down_encoders(struct dc *dc)
 
 	for (i = 0; i < dc->link_count; i++) {
 		struct dc_link *link = dc->links[i];
-		struct link_encoder *link_enc = link->link_enc;
+		struct link_encoder *link_enc = link_enc_cfg_get_link_enc(link);
 		enum signal_type signal = link->connector_signal;
 
 		dc->link_srv->blank_dp_stream(link, false);
 		if (signal != SIGNAL_TYPE_EDP)
 			signal = SIGNAL_TYPE_NONE;
 
-		if (link->ep_type == DISPLAY_ENDPOINT_PHY)
+		if (link->ep_type == DISPLAY_ENDPOINT_PHY && link_enc)
 			link_enc->funcs->disable_output(link_enc, signal);
 
 		if (link->fec_state == dc_link_fec_enabled) {
-			link_enc->funcs->fec_set_enable(link_enc, false);
-			link_enc->funcs->fec_set_ready(link_enc, false);
-			link->fec_state = dc_link_fec_not_ready;
+			if (link_enc && link_enc->funcs->fec_set_enable && link_enc->funcs->fec_set_ready) {
+				link_enc->funcs->fec_set_enable(link_enc, false);
+				link_enc->funcs->fec_set_ready(link_enc, false);
+				link->fec_state = dc_link_fec_not_ready;
+			}
 		}
 
 		link->link_status.link_active = false;
-- 
2.53.0

