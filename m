Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BA250C2AD;
	Mon, 31 Aug 2026 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183764; cv=none; b=B/RYnkgnuC9L/P+KbdOJsc+K+adqtRh9V/T+UeTasLq6DlhZMaKttszRG7dhLNRbL2v9sugwPXYv3+LDK2MkYVRVcynD9O9UCmz0Sp3cDn9Y48kQSMZzsZsm3J7bhjGL3sPZvMABbaxKUoov29NvwIqpzFIqjUBmhDKeVlDk/vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183764; c=relaxed/simple;
	bh=0Tf6uhJfeSB6+Rue41VeQLWduisbu9Ahuh0AOeZQDnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urpX4RfEYdPpt75UBVsouLVHAW2JcE9NpOwSKLheNUgPnXmPkLQImfMKF1WzNNNFJv9IcIxEHjE97rAcjBOWXd6iP6YJjwuWjNrkMIu3czDswOzlk7VZlKavQP2hkXJMLvaG5NNQvxs/b6ft+R43/xw9V3J+bliWsJuiFZ+z91g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJaSNI8Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJaSNI8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377801F00ACF;
	Mon, 31 Aug 2026 13:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183762;
	bh=TEqT8nfaliQZ2yQoDW3IW20hrIH/QLWJ0fqQafAxDb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJaSNI8QsfkyDqng4vS7sw5RF4l5IvxBiORajgUeceHwNUvt6SYfs0UoG7pOhqs3G
	 Z5noyEtclh4affq+wWn6nhCTc/nxEO6Ypv4OZ0qLAkXl0gF0gMJKl+KtTwm5rlt6Nh
	 +rHU+WNVCw/kfdfBy9OtJXC6Xg6GT6IAGS+QxMq6cVTFqXQ/67OmnVtsIZHXSa3S54
	 AisYcPVuY8OMaKDbHho9cfsubQ6QITKBihVGUgk1uRLMkEKTitmGCouo6Aq11Lf0Pw
	 K6zpwEEWTau4tyfg36UY5LmezAJhzOwaiciJjwXeCEYfKDtU4AFBKSAvamP7oF5lXh
	 d/DzoCpOIDdnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] spi: core: Abort active target transfer on controller suspend
Date: Mon, 31 Aug 2026 09:25:17 -0400
Message-ID: <20260831133314.4125787-289-sashal@kernel.org>
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

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit c1bab046d4786c5b17aab7c5225bf0d4a2a2d19b ]

When an SPI controller operating in target mode has a transfer in
progress at the time of system suspend, the suspend path proceeds
without aborting the ongoing transfer. This can leave the hardware in
an inconsistent state, potentially causing the system to hang or fail
to resume cleanly.

Fix this by invoking the controller's target_abort callback from
spi_controller_suspend() when the controller is in target mode and the
callback is registered. This ensures any active target transfer is
cleanly terminated before the controller is suspended.

Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Link: https://patch.msgid.link/20260625-abort_active_transfer_duirng_s2r-v2-1-1d6f724406b6@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[spi: core]` `[Abort]` — abort active target transfer on
controller suspend during system suspend.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>`
  (author)
- `Link: https://patch.msgid.link/20260625-
  abort_active_transfer_duirng_s2r-v2-1-1d6f724406b6@oss.qualcomm.com`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (SPI maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or syzbot tags
- Notable: maintainer sign-off; v2 series (cur_msg check added after
  review)

**Step 1.3 — Body analysis**
Record:
- **Bug:** SPI controller in target (slave) mode with an in-progress
  transfer at system suspend is not aborted.
- **Symptom:** Hardware left inconsistent; system may hang or fail to
  resume cleanly (S2R).
- **Root cause:** `spi_controller_suspend()` proceeds without
  terminating the active transfer.
- **Fix:** Call the driver's existing `target_abort` callback from
  `spi_controller_suspend()` when appropriate.

**Step 1.4 — Hidden bug fix?**
Record: No — this is an explicit suspend/resume stability fix, not
disguised cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- `drivers/spi/spi.c`: +3 lines, 0 removed
- Function modified: `spi_controller_suspend()`
- Scope: single-file, surgical fix

**Step 2.2 — Code flow change**
Record:
- **Before:** Suspend path stops queued controllers and marks suspended;
  active target transfers are untouched.
- **After:** If `cur_msg` is set, controller is in target mode, and
  `target_abort` is registered, abort is invoked first, then existing
  suspend logic runs.
- **Path affected:** System suspend → driver PM suspend →
  `spi_controller_suspend()`.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Logic/correctness — missing cleanup on suspend path.
- **Mechanism:** Target-mode transfers can be mid-flight when suspend
  runs. Without `target_abort`, hardware/DMA state is not torn down,
  causing hang or broken resume.

**Step 2.4 — Fix quality**
Record:
- Fix is minimal and mirrors existing `spi_target_abort()` logic.
- `cur_msg` guard prevents calling drivers (e.g. pxa2xx) that assume an
  active message and dereference `cur_msg` unconditionally.
- Low regression risk: gated on `cur_msg`, `spi_controller_is_target()`,
  and `target_abort`; host-mode controllers unaffected.
- No new APIs or behavior changes for non-target controllers.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record:
- `spi_controller_suspend()` dates to 2012 (Linus Walleij); queue-stop
  logic from 2023 (Mark Hasemeyer, `bef4a48f4ef79`).
- Bug is longstanding: target mode existed since 2017 (`6c364062bfed3`);
  `target_abort` since 2022 (`b8d3b056a78dc`).
- Gap: suspend path never wired up `target_abort`.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related changes**
Record:
- `bef4a48f4ef79` ("spi: Fix null dereference on suspend") fixed a
  related host-mode suspend race; was `Cc: stable@kernel.org`.
- Standalone 1/1 patch; v2 is the final version after maintainer
  feedback.

**Step 3.4 — Author context**
Record: Praveen Talari — Qualcomm SPI contributor (GENI QuPv3 target
mode, `d7f74cc31a89a`). Mark Brown is SPI subsystem maintainer.

**Step 3.5 — Dependencies**
Record: No series dependencies. Requires `target_abort`,
`spi_controller_is_target()`, and `cur_msg` — all present in this tree.
`git apply --check` on the patch succeeds.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c c1bab046d478`: https://patch.msgid.link/20260625-
  abort_active_transfer_duirng_s2r-v2-1-1d6f724406b6@oss.qualcomm.com
- Series: v1 → v2; committed version is v2 (latest).

**Step 4.2 — Reviewers**
Record (`b4 dig -w`): Mark Brown, bjorn.andersson, Konrad Dybcio, linux-
arm-msm, linux-spi, linux-kernel CC'd.

**Step 4.3 — Bug report**
Record: No formal bugzilla/syzbot report. Qualcomm-internal S2R testing
implied by change-id and author affiliation. Mark Brown review comment
documents concrete NULL-deref risk in pxa2xx without `cur_msg` check.

**Step 4.4 — Related patches**
Record: Standalone; no other patches required.

**Step 4.5 — Stable list**
Record: No stable-list discussion found. Absence of `Cc: stable` is
expected for manual review.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `spi_controller_suspend()` (modified); `ctlr->target_abort()`
(callee).

**Step 5.2 — Callers**
Record: `spi_controller_suspend()` called from many SPI driver suspend
handlers (e.g. `spi-slave-mt27xx.c`, `spi-rockchip.c`, `spi-pxa2xx.c`,
`spi-omap2-mcspi.c`, etc.) during system suspend.

**Step 5.3 — Callees**
Record: `target_abort` implemented in 13 drivers (imx, rockchip, pxa2xx,
omap2-mcspi, fsl-dspi, fsl-lpspi, stm32, cadence, etc.). Example pxa2xx
path calls `int_error_stop()` which sets `cur_msg->status` and finalizes
the transfer.

**Step 5.4 — Reachability**
Record: Triggered during system suspend (S2R) on platforms with
`CONFIG_SPI_SLAVE` and a target-capable controller with an active
transfer. Common on embedded/ARM (Qualcomm MSM). Requires suspend
capability, not arbitrary userspace.

**Step 5.5 — Similar patterns**
Record: `spi_target_abort()` already exposes the same callback for
protocol drivers (`spidev`, `spi-slave-time`, `spi-slave-system-
control`). Suspend path was the missing caller.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**
Record:
- Local tree: **v6.18.44** (`git describe HEAD` →
  `v6.18.44-1-g2736c32da98b9`).
- `spi_controller_suspend()` at line 3496 lacks the abort call — bug
  present.
- Fix commit `c1bab046d478` exists in repo but is **not** an ancestor of
  HEAD.

**Step 6.2 — Backport complications**
Record: `git apply --check` passes cleanly. Expected apply: clean.

**Step 6.3 — Related fixes already present?**
Record: `bef4a48f4ef79` (host-mode suspend NULL deref) is in tree. No
duplicate fix for target-mode abort.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
Record: `drivers/spi` — SPI core. Criticality: **IMPORTANT** (core
driver infrastructure; affects all SPI target controllers on suspend).

**Step 7.2 — Activity**
Record: SPI subsystem actively maintained; target-mode support expanded
across multiple drivers since 6.12.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Systems with `CONFIG_SPI_SLAVE` and SPI controllers operating in
target mode with `target_abort` registered (13 drivers in tree).
Qualcomm ARM platforms are a primary audience.

**Step 8.2 — Trigger conditions**
Record: System suspend while an SPI target transfer is in progress
(`ctlr->cur_msg` set). Timing-dependent but realistic on always-on slave
interfaces. Not unprivileged-userspace triggered; PM-initiated.

**Step 8.3 — Failure mode severity**
Record: System hang or failed resume → **CRITICAL** for affected
platforms.

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** HIGH for SPI-target embedded/mobile users — prevents S2R
  hangs.
- **Risk:** VERY LOW — 3 lines, triple-gated, maintainer-reviewed, uses
  existing callback.
- **Ratio:** Strong benefit, minimal risk.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Fixes real suspend/resume hang on SPI target hardware
- Small (3 lines), surgical, applies cleanly to v6.18.44
- SPI maintainer reviewed and applied (v2 with `cur_msg` guard)
- All prerequisites (`target_abort`, `spi_controller_is_target`,
  `cur_msg`) present since before 6.18
- Same class of issue as `bef4a48f4ef79`, which was stable material
- 13 drivers already implement `target_abort` and benefit immediately

**AGAINST backport:**
- Only affects `CONFIG_SPI_SLAVE` configurations (narrower than core
  MM/net)
- No syzbot/CVE report
- No explicit `Cc: stable` tag (expected for manual review)

**Unresolved:** No public crash log; impact inferred from maintainer
review and Qualcomm S2R context.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is straightforward;
   maintainer reviewed; v2 addresses NULL-deref concern.
2. Fixes a real bug? **PASS** — suspend without abort leaves hardware
   inconsistent.
3. Important issue? **PASS** — hang / failed resume (CRITICAL for
   affected users).
4. Small and contained? **PASS** — 3 lines, one function.
5. No new features or APIs? **PASS** — uses existing `target_abort`
   callback.
6. Can apply to local tree? **PASS** — verified with `git apply
   --check`.

**Step 9.3 — Exception categories**
Record: N/A (not device ID, quirk, DT, build, or docs — standard bug
fix).

**Step 9.4 — Decision rationale**
This is a conservative, maintainer-reviewed fix for a suspend/resume
hang affecting SPI target controllers. The bug exists in v6.18.44, the
patch applies cleanly, and the failure mode (system hang on suspend)
meets stable criteria. The `CONFIG_SPI_SLAVE` scope limits breadth but
not importance for affected embedded and mobile platforms.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no syzbot/Fixes/Cc:stable tags
- [Phase 2] Diff: +3 lines in `spi_controller_suspend()`; verified
  pxa2xx `int_error_stop()` uses `cur_msg` unconditionally (line 619)
- [Phase 3] `git describe HEAD`: v6.18.44; `git blame` on suspend
  function; `b8d3b056a78dc` (target helpers) and `bef4a48f4ef79` (prior
  suspend fix) are ancestors
- [Phase 3] `c1bab046d478` NOT in HEAD history; bug present in current
  `spi_controller_suspend()`
- [Phase 4] `b4 dig -c c1bab046d478`: lore URL found; v1→v2 series; Mark
  Brown applied patch
- [Phase 4] `b4 dig -w`: Mark Brown, linux-spi, linux-arm-msm CC'd
- [Phase 4] openwall mirror: Mark Brown required `cur_msg` check for
  pxa2xx safety
- [Phase 5] `grep target_abort`: 13 drivers register callback;
  `spi_target_abort()` exists at spi.c:2930
- [Phase 5] `grep spi_controller_suspend`: many driver suspend paths
  call it
- [Phase 6] `git apply --check` on patch: **clean apply**
- [Phase 6] Current `spi_controller_suspend()` at lines 3496–3508 lacks
  abort logic
- [Phase 8] Failure mode: hang/failed resume; severity CRITICAL for SPI-
  target + S2R scenarios

**YES**

 drivers/spi/spi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index abb9e873e3f9f..c9b1a8fad5bdd 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3501,6 +3501,9 @@ int spi_controller_suspend(struct spi_controller *ctlr)
 {
 	int ret = 0;
 
+	if (ctlr->cur_msg && spi_controller_is_target(ctlr) && ctlr->target_abort)
+		ctlr->target_abort(ctlr);
+
 	/* Basically no-ops for non-queued controllers */
 	if (ctlr->queued) {
 		ret = spi_stop_queue(ctlr);
-- 
2.53.0

