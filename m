Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609126441EF;
	Mon, 19 Oct 2026 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418784; cv=none; b=BEB9aOrvgnHZ48Ri8IsJTmUN5H1JbrivboEKN21dkgffTHsBsX3aePAdOyFyhZ+OHJnwXh5GfLfBgZ4s+9/p0pHwE40SW3pQL2ibXddCgyaf6LPyF2sjsm82zFl3XVB4PPUMzWU0lGrSi15DwebxsvbpJDi3fubUCShNpCpwPDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418784; c=relaxed/simple;
	bh=ec4ghU6yfXjblR6fUDXDHkutpdBOFVRXJKmDCHcyQDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=APp/J+8XksfD0Y5g2J8vQy4fSgL3olq5msNUJrrMeN09FiHm7HEwPEwfVIyuP6AsraWa0p+DdV/aD0An4cKo2l8dABfYRHg/gRFv1mHONA7QNmMQvyiKndBTOir+ms/R7L5X42U2QqCOJsKFyo+gPGAzV444i4jtWWXfPgo2MQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPBKHXGs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPBKHXGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F66E1F000C9;
	Mon, 19 Oct 2026 14:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418782;
	bh=nkFJWPU1MK03QOAusoiniFX+wO1yecpInBwT2lN1yp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPBKHXGsSHFT3UK+FJkkLhMPIhpgVqPP64LVAxhenAWaiIofAwJkCQnalqujNSE5V
	 NUJ5OBo9XTfPwPvoIwadBrEkbg+wWr5YHNIToP4HhV1VOiLNUp9aa0s3DrzM5vCSIf
	 cEWKSPwLwtraCtr/y3eCcn/OkiJe5gL9W2Dc8Cj3j24Hcs7IEM+0gA6kx1FHUfOFwF
	 BPjPzPIGAcL4+AhNRUvLXIDlO5H6ZksEP0Ch1Od5Wa3IV7ZYNLWX+abpNow30ekVNd
	 A95isPXeFOXfPwSgVN4D/lej/f3gZ3+YkfLfGSUuJr8lsxK4XgyyCxHc6OzSuKGLqi
	 GvvkiX5Irna6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop
Date: Mon, 19 Oct 2026 09:53:03 -0400
Message-ID: <20261019135441.1420968-492-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a51cc8131214870af92abbceab64877b27e690c2 ]

The smart fifo is a feature in the firmware configured by the driver.
The driver keeps a state to remember what was the last configuration
sent to the firmware. Obviously, if the firmware stops, we need to
reconfigure the smart fifo. Since we didn't reset that state upon
firmware stop, we thought the firmware is already properly
configured and we didn't send the smart fifo configuration command
as part of the init sequence.

Reset the smart fifo state in iwl_mvm_stop_device() so that we
will properly send the command during the init that will come
later.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714165826.7d3c5efe2d1a.I16b23c328a677257257f695fa6f439e41fbcd081@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[iwlwifi/mvm] [reset] [clear cached smart-fifo state when
firmware is stopped]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none
- **Link:** `https://patch.msgid.link/20260714165826.7d3c5efe2d1a.I16b23
  c328a677257257f695fa6f439e41fbcd081@changeid`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Emmanuel Grumbach (author; Intel iwlwifi), Miri
  Korenblit (iwlwifi maintainer, committer)
- No syzbot, no CVE, no stack trace

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Driver caches last smart-fifo config in `mvm->sf_state`.
  Firmware stop does not clear that cache.
- **Symptom:** After firmware is stopped and started again, init skips
  `REPLY_SF_CFG_CMD` because the driver thinks firmware is already
  configured.
- **Version info:** none
- **Root cause:** Stale driver-side firmware-config cache after the
  firmware image is gone.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit correctness fix for
stale cached firmware state.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/intel/iwlwifi/mvm/ops.c` (+1 / −0)
- Function: `iwl_mvm_stop_device()`
- Scope: single-file, one-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `iwl_mvm_stop_device()` cleared
  `IWL_MVM_STATUS_FIRMWARE_RUNNING`, paused TCM, stopped the transport,
  and freed paging. `sf_state` was left as-is.
- **After:** Immediately after clearing FIRMWARE_RUNNING, set
  `mvm->sf_state = SF_UNINIT`.
- Path: every firmware stop (mac stop, restart cleanup, D3 switch, init-
  ucode teardown, load error paths). Not an error-only path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / correctness — stale cached firmware configuration**

Verified skip in `iwl_mvm_sf_config()`:

```183:188:drivers/net/wireless/intel/iwlwifi/mvm/sf.c
        /*
  - If an associated AP sta changed its antenna configuration, the state
  - will remain FULL_ON but SF parameters need to be reconsidered.
         */
        if (new_state != SF_FULL_ON && mvm->sf_state == new_state)
                return 0;
```

Init always tries to configure SF:

```1761:1763:drivers/net/wireless/intel/iwlwifi/mvm/fw.c
        ret = iwl_mvm_sf_update(mvm, NULL, false);
        if (ret)
                IWL_ERR(mvm, "Failed to initialize Smart Fifo\n");
```

With `changed_vif == NULL` and no active MACs, that becomes
`SF_INIT_OFF`. If `sf_state` is still `SF_INIT_OFF` from the previous
firmware life, the command is skipped and new firmware keeps reset
defaults.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: firmware is gone, cached config must be invalid.
- Minimal: one assignment under `mvm->mutex` (`lockdep_assert_held`).
- Regression risk: very low. On firmware with
  `IWL_UCODE_TLV_API_SMART_FIFO_OFFLOAD` (commit `ff04f78ce38d7`, 2024),
  `iwl_mvm_sf_update()` already returns 0 and never sends the command;
  resetting the cache is a no-op there.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Surrounding `iwl_mvm_stop_device()` body: `cf5b462768474` (2020, moved
  out of line).
- Smart FIFO and `sf_state` skip logic: `1f3b0ff8eccef` (“iwlwifi: mvm:
  Add Smart FIFO support”, 2013-12-17, contained in v3.14-rc1).
- Bug has been present for a long time; not recent code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy pattern is the original 2013 SF cache
plus the skip-if-same-state optimization, not a recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Nearby same-author series (same Change-Id date 20260714165826):
  - `0a00c3ec2db76` device_powered_off → `iwl_mvm_restart_cleanup()`
    (independent)
  - `71ac392d8b5c2` MLD analogue (different driver)
- This patch does not depend on those.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Emmanuel Grumbach is a long-time Intel iwlwifi core author. Miri
Korenblit is the listed iwlwifi maintainer. High confidence in the
diagnosis.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. Needs only `mvm->sf_state` and `SF_UNINIT`, both
present here. No new helpers or struct fields.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c a51cc81312148`: matched `[PATCH iwlwifi-next 13/15]`
- URL: `https://patch.msgid.link/20260714143119.7d3c5efe2d1a.I16b23c328a
  677257257f695fa6f439e41fbcd081@changeid`
- `b4 dig -a`: v1 (`20260714143119`) and v2 (`20260714165826`, the
  applied Link:). This hunk is identical in v1/v2.
- Series title: “wifi: iwlwifi: updates - 07-14-2026” (15 patches mixing
  features and fixes). This one is self-contained.
- Saved mbox had the series posts, no replies/NAKs on this patch. No
  `Cc: stable` in review.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Johannes Berg; Cc linux-
wireless@vger.kernel.org and Emmanuel Grumbach. Committed by maintainer
Miri Korenblit. No extra Reviewed-by on this patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, bugzilla, or syzbot. Failure mode is inferred
from code + commit text, not a user crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Patch 13/15. Follow-ups 14/15 and 15/15 are related
stop/recovery cleanup but not prerequisites. This line is independently
correct.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search blocked by anti-bot (403).
UNVERIFIED whether it was previously requested or rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `iwl_mvm_stop_device()` (modified). Related:
`iwl_mvm_sf_config()`, `iwl_mvm_sf_update()`, `iwl_mvm_up()`.

**Step 5.2: TRACE CALLERS**
Record: `iwl_mvm_stop_device()` is called from:
- `ops.c` NVM/init-ucode teardown
- `mac80211.c` `iwl_mvm_restart_cleanup()`, `__iwl_mvm_mac_start()`
  fast-resume fail, `__iwl_mvm_mac_stop()`
- `fw.c` `iwl_mvm_up()` / `iwl_mvm_load_d3_fw()` error paths
- `d3.c` `iwl_mvm_switch_to_d3()`

Reachable from interface down, rfkill/stop, suspend (non-fast), firmware
restart, and probe/init teardown. Common laptop WiFi paths.

**Step 5.3: TRACE CALLEES**
Record: Stop path tears down firmware/transport. The new line only
writes a field; no new I/O.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace `ip link set wlan0 down/up`, rfkill, suspend/resume,
and mac80211 restart all hit this. Bug is reachable without special
debug options.

Nuance (verified): `SF_FULL_ON` is never skipped, so association still
sends SF config. The missed command is the init/unassociated
`SF_INIT_OFF` after a stop that left `sf_state == SF_INIT_OFF` (typical
after disconnect then ifdown, or never-associated then wifi toggle).
During `IWL_MVM_STATUS_IN_HW_RESTART`, `iwl_mvm_sf_update()` returns
early anyway; this reset still makes post-restart updates send when
restart completes.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same series resets other driver state after firmware death
(`device_powered_off`, MLD recovery). `sf_state` was the one cache not
cleared on stop. No duplicate fix already present besides this commit.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Local tree: `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**;
  `make kernelversion` → **7.3.0-rc4**
- `sf_state`, skip-if-same-state, and `iwl_mvm_up()` SF init all exist
- Bug introduced with Smart FIFO in 2013 (`1f3b0ff8eccef`); ancestor of
  this HEAD

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Pre-fix `iwl_mvm_stop_device()` already has the
insertion point next to `clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING,
...)`. Expected difficulty: clean apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier equivalent reset of `sf_state` on stop. Only the
start-time `mvm->sf_state = SF_UNINIT` in `iwl_op_mode_mvm_start()`
(probe), which does not cover later stop/start cycles.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **wifi / iwlwifi mvm**. **IMPORTANT** — Intel WiFi is one of the
most common laptop NICs. Not core mm/VFS, but far from
peripheral/staging.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Very active. This patch came in an iwlwifi-next 15-patch update
dump, then was taken by the maintainer.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: Intel iwlwifi **mvm** users whose firmware does **not**
advertise `IWL_UCODE_TLV_API_SMART_FIFO_OFFLOAD`. Driver-specific /
firmware-version-specific. Still a large installed base of 22000-and-
older-class chips plus any newer FW without that TLV.

**Step 8.2: TRIGGER CONDITIONS**
Record: Firmware stop then start while cached state is `SF_INIT_OFF` or
`SF_UNINIT`. Common: wifi radio toggle, interface down/up, some suspend
paths. Not a race. Unprivileged users can toggle wifi and hit it.

**Step 8.3: FAILURE MODE SEVERITY**
Record: Firmware left without host `REPLY_SF_CFG_CMD` after reload
(wrong RX FIFO watermarks/timers in unassociated/init). Not an oops,
deadlock, or filesystem corruption.
**Severity: MEDIUM** (wrong firmware config / power and RX-FIFO
behavior; associated `SF_FULL_ON` still sent).

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** Restores a required init-time firmware command after
  every firmware stop on a very common driver. Low-to-medium user-
  visible benefit (no crash report), but the broken path is not rare.
- **Risk:** Very low (one store under existing mutex).
- **Ratio:** Favorable for a 1-line obviously-correct fix.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, verified stale-cache bug; init explicitly tries to send SF
  config and can skip it
- One line, obviously correct, mutex-protected
- Bug present since 2013; code exists in this tree
- No prerequisites; applies cleanly
- Intel iwlwifi mvm is widely deployed
- Author/maintainer-originated; no NAKs found

AGAINST:
- Not a crash, UAF, deadlock, corruption, or security issue
- No user/syzbot report; impact is firmware defaults vs host SF_INIT_OFF
- `SF_FULL_ON` still always sent, so associated operation is less
  affected
- Newer firmware with SMART_FIFO_OFFLOAD never needed the command
- Submitted as iwlwifi-next “updates” 13/15, not a -fixes/stable
  nomination

UNRESOLVED:
- lore.kernel.org WebFetch/stable search blocked (403 / anti-bot)
- Exact user-visible symptom (power vs missed RX vs none) not documented

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one assignment; merged by
   iwlwifi maintainer
2. Fixes a real bug that affects users? **PASS** — stale cache skips a
   real firmware command on wifi stop/start
3. Important issue (crash/security/corruption/deadlock)? **PASS** with
   MEDIUM severity — wrong device firmware configuration after stop is a
   functional bug on a common driver, not a panic. Conservative reading
   could FAIL this bar; the 1-line nature and common trigger keep it a
   PASS.
4. Small and contained? **PASS** — +1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `iwl_mvm_stop_device()`,
   `sf_state`, and `SF_UNINIT` are all here

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk table, DT, build, or docs fix).

**Step 9.4: DECISION**
This is a real, long-standing iwlwifi correctness bug: after firmware
stop the driver keeps believing smart-fifo is already programmed, so
`iwl_mvm_up()` skips `REPLY_SF_CFG_CMD`. The local 7.3-rc4 tree has the
buggy cache and skip logic. The fix is a single `sf_state = SF_UNINIT`
in the existing stop path, with no API change and negligible regression
risk. That meets stable rules for a small, obviously correct driver
bugfix even without a crash report.

---

### What the commit solves for this tree
On this checkout, `iwl_mvm_sf_config()` refuses to send smart-fifo
config when `new_state` matches `mvm->sf_state` (except `SF_FULL_ON`).
`sf_state` was only initialized at op-mode start, not when firmware
actually stopped. After a normal mac stop / restart / D3 firmware swap,
the next `iwl_mvm_up()` therefore omits `REPLY_SF_CFG_CMD`. Stable users
hitting wifi toggle, rfkill, or non-fast suspend on Intel mvm hardware
then run reloaded firmware without the host SF init the driver intends.

### Risk vs benefit
Benefit is restoring firmware RX-FIFO configuration after a common
stop/start cycle. Risk is essentially nil: one field write under
`mvm->mutex`, harmless on offload firmware. Backport needs no extra
commits.

---

Verification:
- [Phase 1] Parsed tags: SOB Emmanuel Grumbach + Miri Korenblit; Link to
  msgid; no Fixes/Reported-by/stable Cc
- [Phase 2] Diff: +1 line `mvm->sf_state = SF_UNINIT` in
  `iwl_mvm_stop_device()`
- [Phase 2] Confirmed skip in `iwl_mvm_sf_config()` and init call in
  `iwl_mvm_up()`
- [Phase 3] `git show a51cc81312148`: 1 file, +1; parent `974cbad4c86d6`
- [Phase 3] Original SF: `1f3b0ff8eccef` (2013-12-17), ancestor of HEAD;
  `git merge-base --is-ancestor` succeeded
- [Phase 3] Blame: new line is this commit; rest of stop_device from
  `cf5b462768474` (2020)
- [Phase 3] Follow-up `0a00c3ec2db76` is independent, not required
- [Phase 4] `b4 dig -c a51cc81312148`: lore match; patch 13/15 of
  iwlwifi-next updates
- [Phase 4] `b4 dig -a`: v1 and v2; committed Link is v2; hunk unchanged
- [Phase 4] `b4 dig -w`: Johannes Berg + linux-wireless; no NAK in saved
  mbox
- [Phase 4] UNVERIFIED: stable list discussion (lore 403/anti-bot);
  WebFetch of lore URLs also 403
- [Phase 5] Callers of `iwl_mvm_stop_device()`: mac80211 stop/restart,
  d3, fw error, NVM init
- [Phase 5] `IWL_UCODE_TLV_API_SMART_FIFO_OFFLOAD` added in
  `ff04f78ce38d7` (2024); offload path ignores SF commands
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4
- [Phase 6] Pre-fix `iwl_mvm_stop_device()` at parent matches insertion
  context; clean apply
- [Phase 7] MAINTAINERS: INTEL WIRELESS WIFI LINK, Miri Korenblit
- [Phase 8] Failure mode: skipped firmware SF init after stop; severity
  MEDIUM, not oops/deadlock
- UNVERIFIED: concrete user-visible packet-loss vs power-only impact
  (not stated in commit or mail)

**YES**

 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d6a13174b5617..3e7c620821069 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1535,6 +1535,7 @@ void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	iwl_fw_cancel_timestamp(&mvm->fwrt);
 
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+	mvm->sf_state = SF_UNINIT;
 
 	iwl_mvm_pause_tcm(mvm, false);
 
-- 
2.53.0

