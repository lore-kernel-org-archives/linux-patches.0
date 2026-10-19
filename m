Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2792583DA7;
	Mon, 19 Oct 2026 13:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418331; cv=none; b=cKPuHBqin7xRZC05hcOmwBzgM0pe4RtZbd6JxnYOz3bcz/iTO1ZbVf3dISKeaP8DYwzC0oxDhmkFB63D86lAX0f2AY6J+Tcr6Qis6okW7YUs3VkJC0AfFnQ+5uF7fXOqV2QPVpaR8+wjM9ecy3jcBqJPQLu3JJKXMMYnJrc2hNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418331; c=relaxed/simple;
	bh=milrIlVUbZashnMkcKN4rMuCglSG3pnEANrftBe7vUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lw6wnKKeI6RiDCpcx1jpriDzPHoylDekZuw7GNYBXlIc4LA2Sb3/VXaCe3k+jqqz94a02/yRBJYmZerHAzZbOzB03B32PHcZ3xtl++T4/sqv3o01gOha/SmZtrdh+7VaO8QGCHjRfyZqNCbNrQrmNsCdpwpnNVDA+MCGa2oWq0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KADB6xss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KADB6xss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11791F000CB;
	Mon, 19 Oct 2026 13:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418328;
	bh=0W9+MtI0CaOH9WUkG/Dmpf/F+iFgVr1uPGP3BHDkQrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KADB6xss+UXgyWgobYHYivrGi6MUOJa4WqlGF3UJIyPsOjxaYrchP6oEkhJpQdwwL
	 Q+ZB8b1Qh+7c0Cd6HPSulPIwA9FQK+tfPiOUjHHJyb9hSeqnsk1HwpkUekT20dzhTx
	 CWI6/PoC5gXiQBuJwvWtz07vYYXkWk8Pcl3G8Ba34uxnV/GoNwk9XilIkDfplS/sc4
	 b1vq0tPyvv+9FuwhfIgQMST7uSSYN5JA8bQM8vSEvNQZ1uqyEYcltNl3hKpddZIZBV
	 HeZfjkI+R0BPHKf61NfT9ySGdMqX9sgPfCNLb9hBDsBIJ6JjjsDGaacn8nB8pCbDbL
	 uvjbq53V3IhYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: validate D3_END notif size
Date: Mon, 19 Oct 2026 09:47:41 -0400
Message-ID: <20261019135441.1420968-170-sashal@kernel.org>
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

[ Upstream commit 4e777dcdfe70d9b3ddf38cb49de9e30306889b18 ]

Check D3_END_NOTIFICATION payload length before reading notif->flags.
On short payloads, mark notif handling as failed.
Avoid out-of-bounds reads from malformed notifications.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714165826.db2df8b6b6bb.I6163bbdf433379bf1dbf9eb46fb9562892217bd7@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
iwlwifi MLD D3 resume path is present here, and this is a small bounds
check that stops an out-of-bounds read of firmware notification data.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: **[iwlwifi/mld]** **[validate]** Check `D3_END_NOTIFICATION`
payload size before reading `notif->flags`.

**Step 1.2 — Tags**
Record:
- `Assisted-by: GitHubCopilot:gpt-5.3-codex`
- `Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>`
  (author)
- `Link: https://patch.msgid.link/20260714165826.db2df8b6b6bb.I6163bbdf4
  33379bf1dbf9eb46fb9562892217bd7@changeid`
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
  (iwlwifi maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable` (absence of Fixes/Cc-stable is expected for this review)
- Sasha Levin SOB ignored per pipeline rules

**Step 1.3 — Body**
Record: Firmware `D3_END_NOTIFICATION` payload length is not checked
before `le32_to_cpu(notif->flags)`. A short payload is an out-of-bounds
read. On failure, handling is marked failed (`notif_handling_err`).
Symptom: OOB read of firmware RX data during D3/WoWLAN resume. No stack
trace, reproducer, or version range in the message. Root cause: missing
length check vs `sizeof(struct iwl_d3_end_notif)`.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. The subject/body state a bounds check to avoid OOB
reads. Copilot assistance does not change that.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/net/wireless/intel/iwlwifi/mld/d3.c` (+9 / −1)
- Function: `iwl_mld_handle_d3_notif()`
- Scope: single-file, one `switch` case (`WIDE_ID(PROT_OFFLOAD_GROUP,
  D3_END_NOTIFICATION)`)

**Step 2.2 — Control flow**
Record: Before, the handler always did `resume_data->d3_end_flags =
le32_to_cpu(notif->flags)` from `pkt->data` with no length check, then
set `IWL_D3_NOTIF_D3_END_NOTIF`. After, it computes `len =
iwl_rx_packet_payload_len(pkt)` and uses `IWL_FW_CHECK(mld, len <
sizeof(*notif), ...)`. Short payload: log, set `notif_handling_err =
true`, skip the flags read. Valid payload: same flags assignment as
before. In both cases it still sets `IWL_D3_NOTIF_D3_END_NOTIF` so the
wait completes. Error path only for truncated firmware notifications.

**Step 2.3 — Bug mechanism**
Record: **Memory safety / out-of-bounds read.** `struct
iwl_d3_end_notif` is a packed `__le32 flags` (4 bytes). Reading
`notif->flags` when `payload_len < 4` reads past the declared RX
payload. Same class of check already used in `mvm/d3.c`.

**Step 2.4 — Fix quality**
Record: Obviously correct: compare payload length to `sizeof(*notif)`
before dereference, using existing `IWL_FW_CHECK` /
`iwl_rx_packet_payload_len`. Surgical, no API change. Regression risk is
low: valid 4-byte notifications behave as before. Truncated ones fail
resume with `-EIO` via `notif_handling_err` instead of using garbage
`d3_end_flags` (which can spuriously set or miss
`IWL_D0I3_RESET_REQUIRE`). The API struct always includes `flags`; MVM
already rejects short D3_END payloads, so empty notifications are not a
valid firmware contract.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Unchecked `notif->flags` read was introduced with
`d1e879ec600f9` (`wifi: iwlwifi: add iwlmld sub-driver`, 2025-02-16).
`git describe --tags d1e879ec600f9` → `v6.14-rc4-1062-gd1e879ec600f9`
(iwlmld landed for ~6.15). The bug has been in this driver since it was
added.

**Step 3.2 — Fixes: tag**
Record: No `Fixes:` tag. Introducing commit is `d1e879ec600f9`, which
**is** an ancestor of this tree (`git merge-base --is-ancestor`
succeeded).

**Step 3.3 — Related file history**
Record: Same-day MVM sibling `c1a1dc162870a` (`wifi: iwlwifi: mvm: d3:
validate D3 resume notification payloads`) documents “buffer underread
on malformed or truncated notifications.” Later MLD D3 checks (`validate
WoWLAN notif header`, wake-packet reads) are independent siblings, not
prerequisites. Follow-up `4f5384b58b483` disconnects on D3 resume
failure; this patch does not depend on it.

**Step 3.4 — Author**
Record: Emmanuel Grumbach is a long-time iwlwifi developer. Applied by
maintainer Miri Korenblit. Same author wrote the MVM D3 payload
validation.

**Step 3.5 — Dependencies**
Record: Standalone. Uses existing `iwl_rx_packet_payload_len` (`iwl-
trans.h`), `IWL_FW_CHECK` (`fw/dbg.h`, included by `d3.c`; macro since
`568db7fd27fad` / ~v6.5), `notif_handling_err`, and `struct
iwl_d3_end_notif`. No new helpers. It was **09/15** in an iwlwifi-next
bundle of mixed fixes/features; this hunk has no code dependency on the
other 14 patches.

## Phase 4: Mailing list / external research

**Step 4.1 — Original discussion**
Record: `b4 dig -c 4e777dcdfe70d` → https://patch.msgid.link/20260714165
826.db2df8b6b6bb.I6163bbdf433379bf1dbf9eb46fb9562892217bd7@changeid
`b4 dig -a`: v1 and **v2**; applied version is **v2** `[PATCH v2
iwlwifi-next 09/15]`. Cover letter: “Usual fixed, cleanups and features
from our internal tree.” v2 only resends after `iwlwifi-next` contained
an unrelated compile-time hcmd-size check. No NAK, no reviewer concern,
no `Cc: stable` on this patch. Direct lore.kernel.org fetch returned
**403**; thread recovered via `b4 dig -m`.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: To Johannes Berg (`johannes@sipsolutions.net`); Cc `linux-
wireless@vger.kernel.org`, Emmanuel Grumbach. Correct wireless/iwlwifi
audience. This patch itself has no extra `Reviewed-by` (unlike some
series mates). Maintainer SOB is present.

**Step 4.3 — Bug report**
Record: No `Reported-by`, syzbot, or bugzilla. Firmware-malformed-
notification hardening, not a user crash report.

**Step 4.4 — Series**
Record: 15-patch iwlwifi-next dump. This patch is an isolated length
check in one case of `iwl_mld_handle_d3_notif`. Other patches add device
IDs, LARI v14, TCM removal, etc. Not a multi-step refactor of this
function.

**Step 4.5 — Stable list**
Record: lore.kernel.org/stable WebFetch returned **403**. No stable
discussion in the saved mbox. **UNVERIFIED:** whether anyone already
nominated this on stable@.

## Phase 5: Code semantic analysis

**Step 5.1 — Functions**
Record: `iwl_mld_handle_d3_notif()` only.

**Step 5.2 — Callers**
Record: Registered as the notification-wait callback from
`iwl_mld_wait_d3_notif()`, itself called by:
- `iwl_mld_no_wowlan_resume()` → `iwl_mld_mac80211_start()` when
  `fw_status.in_d3` (`mac80211.c`)
- `iwl_mld_wowlan_resume()` → `iwl_mld_resume()` mac80211 resume op

Context: process context, suspend/resume, `CONFIG_PM_SLEEP`
(`mld/Makefile`: `iwlmld-$(CONFIG_PM_SLEEP) += d3.o`).

**Step 5.3 — Callees**
Record: `iwl_rx_packet_payload_len()`, `IWL_FW_CHECK` → `IWL_ERR_LIMIT`,
`le32_to_cpu()`. No allocation, no new locks.

**Step 5.4 — Reachability**
Record: Yes, from userspace via suspend/resume (S3/WoWLAN) on Intel Wi-
Fi 7 / MLD (`CONFIG_IWLMLD`). Unprivileged users typically cannot inject
firmware RX payloads; trigger is firmware (or a compromised device).
Still a real kernel OOB if firmware truncates the notif.

**Step 5.5 — Similar patterns**
Record: MVM `iwl_mvm_wait_d3_notif` already checks `len <
sizeof(*notif)` before `notif->flags`. Other iwlwifi handlers use
`IWL_FW_CHECK(..., pkt_len < sizeof(...))`. This closes a gap in the
newer MLD copy of D3 resume.

## Phase 6: Local tree (7.3.0-rc4)

**Step 6.1 — Buggy code here?**
Record: Yes. `drivers/net/wireless/intel/iwlwifi/mld/d3.c` exists;
`iwl_mld_handle_d3_notif` handles `D3_END_NOTIFICATION`. Pre-patch
parent shows the unguarded `le32_to_cpu(notif->flags)`. Bug introduced
with iwlmld (`d1e879ec600f9`), ancestor of HEAD.

**Step 6.2 — Backport difficulty**
Record: Clean apply. Surrounding case statement matches the candidate
diff. `IWL_FW_CHECK` and `notif_handling_err` are already in this tree.

**Step 6.3 — Related fixes already here?**
Record: No earlier MLD D3_END size check. MVM has its own check
(`c1a1dc162870a`); that does not cover MLD.

## Phase 7: Subsystem / maintainer

**Step 7.1**
Record: **iwlwifi MLD** (`drivers/net/wireless/intel/iwlwifi/mld/`).
**IMPORTANT** (not core mm/fs, but a widely used Intel Wi-Fi driver on
current hardware). D3.c is only built with `CONFIG_PM_SLEEP`.

**Step 7.2**
Record: Active (frequent iwlwifi-next dumps). D3_END handling itself has
been stable since the sub-driver was added.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: Users of Intel Wi-Fi MLD (`CONFIG_IWLMLD`) who suspend/resume or
use WoWLAN. Driver- and config-specific, not universal.

**Step 8.2 — Trigger**
Record: D3 resume when firmware delivers `D3_END_NOTIFICATION` with
payload &lt; 4 bytes. Uncommon if firmware is healthy; realistic on
firmware bugs. Not a normal userspace syscall; firmware-sourced.

**Step 8.3 — Failure mode**
Record: Out-of-bounds read of RX buffer / declared payload. Can be KASAN
OOB, garbage `d3_end_flags` (wrong reset-on-resume), or a crash if the
buffer is tightly sized. **Severity: HIGH** (OOB; resume correctness).
Not a guaranteed panic on every resume.

**Step 8.4 — Risk vs benefit**
Record: **Benefit: high** for MLD laptop suspend/resume — prevents OOB
and acting on garbage reset flags. **Risk: very low** — 9 lines, error
path only, same pattern as MVM. Ratio favors backport.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Real OOB read of firmware notification payload
- Small, obviously correct check (`len < sizeof(*notif)`)
- Matches established iwlwifi/`IWL_FW_CHECK` and MVM D3 handler
- D3/WoWLAN resume is a common path on laptops
- Garbage flags can mis-handle `IWL_D0I3_RESET_REQUIRE`
- Maintainer-applied; Johannes/linux-wireless were CCed
- Applies cleanly; no prerequisites missing in 7.3-rc4
- iwlmld and the buggy handler exist in this tree

Against:
- No user/syzbot report; Copilot-assisted
- Trigger needs truncated firmware, not a normal station
- Mixed 15-patch “updates” series, not explicitly Cc: stable
- No extra `Reviewed-by` on this patch

Unresolved:
- lore.kernel.org HTTP 403; stable@ search not confirmed beyond the mbox

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — length check before
   dereference; applied to iwlwifi-next by the maintainer.
2. Real bug affecting users? **PASS** — OOB on truncated D3_END; MLD D3
   resume is a real path.
3. Important (crash/security/corruption/deadlock)? **PASS** — OOB read /
   possible bad resume flags; HIGH, not theoretical style-only.
4. Small and contained? **PASS** — +9/−1, one function, one case.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — files, macros, and structures
   exist.

**Step 9.3 — Exceptions**
Record: Not a device-ID/quirk/DT/build/docs exception. It is a
straightforward memory-safety fix.

**Step 9.4 — Decision**
This tree is 7.3-rc4 and contains iwlmld D3 resume. The patch is a
9-line firmware notification bounds check that stops an OOB read and
avoids using garbage `d3_end_flags`. It meets stable criteria for this
checkout.

### What it solves for this tree
On Intel MLD Wi-Fi, D3/WoWLAN resume handled `D3_END_NOTIFICATION` by
reading a 4-byte `flags` field without checking payload length. A short
firmware notification reads past valid RX data and can drive wrong
reset-on-resume behavior. The fix logs via `IWL_FW_CHECK`, sets
`notif_handling_err` (resume returns `-EIO`), and only then skips the
flags read.

### Risk vs benefit
Benefit is preventing OOB and incorrect D3 resume on `CONFIG_IWLMLD` +
`CONFIG_PM_SLEEP`. Risk is negligible: valid notifications are
unchanged.

## Verification
- [Phase 1] Parsed tags: author Grumbach, maintainer Korenblit SOB,
  msgid.link; no Fixes/Reported-by/Cc-stable
- [Phase 2] Diff: +9/−1 in `iwl_mld_handle_d3_notif` D3_END case; length
  check then optional `le32_to_cpu(notif->flags)`
- [Phase 2] `struct iwl_d3_end_notif` is `__le32 flags` only
  (`fw/api/d3.h`)
- [Phase 2] `IWL_FW_CHECK` defined in `fw/dbg.h`; included from
  `mld/d3.c`
- [Phase 2] `notif_handling_err` forces `ret = -EIO` in
  `iwl_mld_wait_d3_notif`
- [Phase 2] `d3_end_flags & IWL_D0I3_RESET_REQUIRE` used in no-wowlan
  and wowlan resume
- [Phase 3] `git describe HEAD` / `make kernelversion`: **7.3.0-rc4**
- [Phase 3] Blame: unguarded read from `d1e879ec600f9` (iwlmld add,
  ~v6.15)
- [Phase 3] `git merge-base --is-ancestor d1e879ec600f9 HEAD`: yes
- [Phase 3] Pre-patch: `git show 4e777dcdfe70d^:.../mld/d3.c` shows
  unguarded flags read
- [Phase 3] MVM sibling `c1a1dc162870a` same-day D3 payload validation
- [Phase 3] `IWL_FW_CHECK` from `568db7fd27fad` (~v6.5)
- [Phase 4] `b4 dig -c/-a/-w/-m`: v2 09/15, linux-wireless + Johannes;
  no NAK in mbox
- [Phase 4] Cover letter: mixed iwlwifi-next updates; this patch listed
  under Grumbach fixes
- [Phase 4] UNVERIFIED: lore.kernel.org and stable@ HTTP 403
- [Phase 5] Callers: `iwl_mld_no_wowlan_resume` /
  `iwl_mld_wowlan_resume` from mac80211 start/resume
- [Phase 5] `mld/Makefile`: `d3.o` only with `CONFIG_PM_SLEEP`;
  `CONFIG_IWLMLD`
- [Phase 6] Buggy handler present; apply would be clean
- [Phase 8] Failure mode: OOB read of D3_END payload / garbage reset
  flags, severity HIGH

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index 0cb7bfcd6420e..73fd4c69357ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -1326,8 +1326,16 @@ static bool iwl_mld_handle_d3_notif(struct iwl_notif_wait_data *notif_wait,
 	}
 	case WIDE_ID(PROT_OFFLOAD_GROUP, D3_END_NOTIFICATION): {
 		struct iwl_d3_end_notif *notif = (void *)pkt->data;
+		u32 len = iwl_rx_packet_payload_len(pkt);
+
+		if (IWL_FW_CHECK(mld, len < sizeof(*notif),
+				 "Invalid D3_END notification (expected=%zu got=%u)\n",
+				 sizeof(*notif), len)) {
+			resume_data->notif_handling_err = true;
+		} else {
+			resume_data->d3_end_flags = le32_to_cpu(notif->flags);
+		}
 
-		resume_data->d3_end_flags = le32_to_cpu(notif->flags);
 		resume_data->notifs_received |= IWL_D3_NOTIF_D3_END_NOTIF;
 		break;
 	}
-- 
2.53.0

