Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE245A5142;
	Mon, 31 Aug 2026 13:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184338; cv=none; b=kCNA/lb2dQZLJLyEJNg/Pc6O9MJyqjxcR+5Tlq6P6KjrLNuvv50CkO0kUAifMIsZKnU3yeY51y9b13RF3qA5GfT1TM2OAjwbHYPYjbEZODoLML3PFrdfBlNMRjsSanoDdavQHA2d3GxgG1aJtkRnlcutxFYhAO8MHyDqCpK/BiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184338; c=relaxed/simple;
	bh=YZIvxUQeoIWU+qk7vGIrjZ88RH6Sh3WqwfQAZmAWMmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YNOsAvZu0Uyd9fBhnFEtqqkc4vLjNoqcavmVHLoX6OPoI7+oAlOvgyw7IQQ99ycsouRrW0dmNSHstzQeSWXSoA50mqpkb70sHz6yP2X9ZpvM2FaibT1lq3IG3JhBF7jLngXNZRY/ZYL4ir7FUkaBQX2JCk4F4u7vKL7gDZaNJ/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jk+9XX0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jk+9XX0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294CD1F00A3F;
	Mon, 31 Aug 2026 13:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184336;
	bh=Nhwg4k6YpAqkSMc8ZUEpSURpmfGFhXWr3FMAzIJLWXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jk+9XX0N8WRFSva/EXbaIVa4ynScFuljqQcEZ86iAmryU1fqtRrvKX0a8YAiIItAp
	 RuIEBK97OweaYczv/dOcxd3Z2DUq7MQAWTa7DcHkgUyD/U79F3lC3A0bcZZugux+Jm
	 jGlBtmXK1jib3h00z/DeFRoJsS+yXw7Y0dqZIb1pD/bf/9DZjNRrhR+irYI8egl3SM
	 SeubfYZBh7Z4BOcUiVIoTxejJRDsY2k1Gf9thOJf5JVG3MM/liCg+Om06SEzyxhOM0
	 BMVsOdApZhXCbEUA5iXYOSMOCElX9OprY7fdBzFKLmtuhmAMuGdr0WNI/0zBidFZDb
	 7glgMjefORSWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.com>,
	zdi-disclosures@trendmicro.com,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] HID: hidpp: fix potential UAF in hidpp_connect_event()
Date: Mon, 31 Aug 2026 09:31:01 -0400
Message-ID: <20260831133314.4125787-633-sashal@kernel.org>
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

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 6df6b1f2c49678211f65647c300bc51dda02893b ]

If input_register_device() fails, we call input_free_device(), but keep
stale pointer to the old device in hidpp->input, which could potentially
lead to UAF. Fix that by resetting it to NULL before returning from
hidpp_connect_event().

Reported-by: zdi-disclosures@trendmicro.com
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: **[HID/hidpp] [fix] [potential UAF in hidpp_connect_event() when
input_register_device() fails]**

**Step 1.2 — Tags**

Record:
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** zdi-disclosures@trendmicro.com (Trend Micro Zero Day
  Initiative — security disclosure channel)
- **Tested-by:** — not present
- **Reviewed-by:** — not present
- **Acked-by:** — not present
- **Link:** — not present
- **Cc: stable:** — not present (expected)
- **Signed-off-by:** Jiri Kosina (author); ignore pipeline-added SOBs
  per instructions

Notable: ZDI disclosure is a strong security-relevant signal.

**Step 1.3 — Body analysis**

Record:
- **Bug:** On `input_register_device()` failure in
  `hidpp_connect_event()`, the driver calls `input_free_device()` but
  leaves a stale pointer in `hidpp->input`.
- **Symptom:** Potential use-after-free when later code dereferences
  `hidpp->input`.
- **Root cause:** `hidpp_populate_input()` sets `hidpp->input = input`
  before registration; the error path frees the device without clearing
  the pointer.
- **Version info:** Not specified in the message.

**Step 1.4 — Hidden bug fix?**

Record: **No — this is an explicit UAF fix**, not disguised cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **Files:** `drivers/hid/hid-logitech-hidpp.c` (+1 line)
- **Function:** `hidpp_connect_event()`
- **Scope:** Single-file, single-line surgical fix on an error path

**Step 2.2 — Code flow change**

Record:
- **Before:** On `input_register_device()` failure →
  `input_free_device(input)` → return, with `hidpp->input` still
  pointing at freed memory.
- **After:** On failure → `hidpp->input = NULL` →
  `input_free_device(input)` → return.
- **Path affected:** Delayed-init connect work item error path only
  (devices with `HIDPP_QUIRK_DELAYED_INIT`).

**Step 2.3 — Bug mechanism**

Record: **Category: use-after-free / memory safety**
- `hidpp_populate_input()` assigns `hidpp->input = input` (line 3810).
- Failure path frees `input` but does not NULL the stored pointer.
- Existing `if (!hidpp->input)` guards do not help — the pointer is non-
  NULL but dangling.

**Step 2.4 — Fix quality**

Record:
- **Obviously correct:** Yes — standard pattern: clear pointer before
  freeing referenced object.
- **Minimal:** One line, no unrelated changes.
- **Regression risk:** Very low — only affects the failure path;
  successful registration is unchanged.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- Delayed-init block in `hidpp_connect_event()`: `c39e3d5fc9dd` (2014,
  Benjamin Tissoires).
- `hidpp_populate_input()` before register: `e54abaf675ca76` (2019, Hans
  de Goede).
- `hidpp->input = input` in `hidpp_populate_input()`: `0610430e3dea`
  (2019).
- Error-path `return` without NULLing: `98d67f250472cd` (2022) fixed
  `delayed_input` assignment but missed `hidpp->input`.
- **Bug present since ~2019** when populate-before-register was
  introduced.

**Step 3.2 — Fixes: tag**

Record: **N/A** — no Fixes: tag in commit message.

**Step 3.3 — Related file history**

Record:
- Recent related fix in this tree: `b846fb0a73e99` — separate G920
  force-feedback UAF fix (already backported).
- `680ee411a98e8` — connect event race fix (2023).
- **Standalone fix** — not part of a multi-patch series.

**Step 3.4 — Author context**

Record: Jiri Kosina is the HID subsystem maintainer. Upstream commit:
`6df6b1f2c4967`; stable-format commit: `67eae1a739c6d`.

**Step 3.5 — Dependencies**

Record: **None.** Self-contained one-liner; no prerequisite commits
required.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- `b4 dig -c 6df6b1f2c4967`: https://patch.msgid.link/r7qq6043-p432-
  51o0-3s93-r9382q44n027@xreary.bet
- Single v1 submission (2026-06-12); no follow-up revisions found.
- Lore fetch blocked by Anubis bot protection — **could not read thread
  replies**.

**Step 4.2 — Reviewers (b4 dig -w)**

Record: CC'd to Jiri Kosina, Benjamin Tissoires (HID maintainer), linux-
kernel, linux-input.

**Step 4.3 — Bug report**

Record: **Reported-by: zdi-disclosures@trendmicro.com** — ZDI security
disclosure. No public syzbot/bugzilla link. ZDI typically reports
exploitable or high-severity kernel issues. Full ZDI advisory not
verified (no Link: tag).

**Step 4.4 — Related patches**

Record: **Standalone** — v1 only, no series dependencies.

**Step 4.5 — Stable list discussion**

Record: **Not searched** (no stable-specific thread found via b4). Not a
negative signal.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `hidpp_connect_event()`, `hidpp_populate_input()`,
`hidpp_allocate_input()`, `hidpp_raw_event()`, `m560_raw_event()`,
`wtp_raw_event()`

**Step 5.2 — Callers**

Record:
- `hidpp_connect_event()` — scheduled from `hidpp_raw_hidpp_event()` on
  connect events; also from `hidpp_probe()` via `schedule_work()` +
  `flush_work()`.
- `hidpp->input` used from raw event handlers (`m560_raw_event`,
  `wtp_raw_event`, wheel/button handlers, scroll counter).

**Step 5.3 — Callees**

Record: `hidpp_allocate_input()` → `devm_input_allocate_device()`;
`hidpp_populate_input()` → sets `hidpp->input`;
`input_register_device()` / `input_free_device()` on failure.

**Step 5.4 — Reachability**

Record:
- Affects devices with `HIDPP_QUIRK_DELAYED_INIT`: wireless touchpads
  (0x4011, 0x4101, T651) and M560 mouse (0x402d).
- Trigger: `input_register_device()` fails during delayed connect (e.g.
  memory pressure).
- After failure, device stays bound and continues receiving HID reports
  → `hidpp_raw_event()` → class-specific handlers use dangling
  `hidpp->input`.
- **Userspace-reachable** via device plug/connect; no special privileges
  needed to connect a HID device.

**Step 5.5 — Similar patterns**

Record: `b846fb0a73e99` fixed a different UAF in the same driver (G920
FF init). Same driver, same class of bug.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code in tree?**

Record: **YES.** Local tree is **6.18.44** (`git describe`:
`v6.18.44-1-g2736c32da98b9`). At lines 4279–4284:

```4279:4287:drivers/hid/hid-logitech-hidpp.c
        hidpp_populate_input(hidpp, input);

        ret = input_register_device(input);
        if (ret) {
                input_free_device(input);
                return;
        }

        hidpp->delayed_input = input;
```

Missing `hidpp->input = NULL`. Upstream fix `6df6b1f2c4967` is **not**
an ancestor of HEAD.

**Step 6.2 — Backport complications**

Record: **`git apply --check` passes cleanly** — no conflicts expected.

**Step 6.3 — Related fixes already present?**

Record: G920 FF UAF fix (`b846fb0a73e99`) is present. **This specific
`hidpp_connect_event()` UAF fix is not.**

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**

Record: **drivers/hid** (Logitech HID++ driver). Criticality:
**IMPORTANT** — common consumer peripherals (mice, touchpads).

**Step 7.2 — Activity**

Record: Actively maintained; multiple recent fixes in `hid-logitech-
hidpp.c`.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users of Logitech HID++ devices with delayed input registration
— wireless touchpads (T650/T651/4011) and M560 mouse on Unifying
receivers.

**Step 8.2 — Trigger conditions**

Record:
- Device connects with `HIDPP_QUIRK_DELAYED_INIT`.
- `input_register_device()` fails (uncommon but possible under resource
  pressure).
- Device continues operating at the HID layer; subsequent input events
  hit stale `hidpp->input`.
- **Unprivileged users** can trigger by connecting affected hardware.

**Step 8.3 — Failure mode**

Record: **Use-after-free** on `struct input_dev` via `input_report_*()`
/ `input_event()` / `input_sync()`. Severity: **HIGH** (kernel memory
corruption; potential security impact given ZDI disclosure).

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** HIGH — prevents UAF on a reachable path for common
  hardware.
- **Risk:** VERY LOW — one-line NULL assignment on error path only.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR:**
- Real UAF with clear mechanism (stale pointer after free).
- ZDI security disclosure.
- Small, obviously correct fix.
- Buggy code confirmed in 6.18.44 tree.
- Patch applies cleanly.
- Affects common Logitech peripherals.
- HID maintainer-authored fix.

**AGAINST:**
- `input_register_device()` failure is uncommon.
- No public crash reproducer verified in this analysis.
- Lore thread content unverified (bot protection).

**UNRESOLVED:**
- Full ZDI advisory details and exploitability assessment not retrieved.
- No reviewer Ack/Tested-by in commit message.

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** (logic is trivial; no Tested-
   by)
2. Fixes a real bug? **PASS**
3. Important issue? **PASS** — UAF / potential security (ZDI)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified with `git apply --check`

**Step 9.3 — Exception category**

Record: **N/A** — standard bug fix, not a quirk/ID/DT exception.

**Step 9.4 — Decision rationale**

For the **6.18.44** tree checked out here, the buggy code exists and the
fix is absent. The commit closes a real UAF on an error path where
`hidpp->input` becomes a dangling pointer. Existing NULL checks do not
protect against this. The fix is minimal, maintainer-authored, security-
disclosed, and applies cleanly. This meets all stable kernel criteria.

---

## Verification

- [Phase 1] Parsed commit `6df6b1f2c4967`: subject, body, Reported-by
  ZDI
- [Phase 2] Read diff: +1 line `hidpp->input = NULL` in error path
- [Phase 2] Read `hidpp_populate_input()`: sets `hidpp->input = input`
  at line 3810
- [Phase 3] `git blame` on lines 4269–4287: bug path dates to 2014–2019
  code
- [Phase 3] `git log -1 -S "hidpp->input = input"`: introduced in
  `0610430e3dea` (2019)
- [Phase 3] `git show 98d67f250472cd`: fixed `delayed_input` on failure,
  missed `hidpp->input`
- [Phase 3] `git merge-base --is-ancestor 6df6b1f2c4967 HEAD`: exit 1 —
  fix NOT in tree
- [Phase 4] `b4 dig -c 6df6b1f2c4967`: lore URL found
- [Phase 4] `b4 dig -w`: CC to HID maintainers
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] UNVERIFIED: Lore thread replies (Anubis blocked fetch)
- [Phase 5] Grep `hidpp->input`: multiple uses in raw event paths; NULL
  checks insufficient for dangling pointer
- [Phase 5] Read `hidpp_raw_event()`: dispatches to `wtp_raw_event` /
  `m560_raw_event` for affected quirks
- [Phase 5] Grep `HIDPP_QUIRK_DELAYED_INIT`: touchpads + M560 mouse
- [Phase 6] `git describe HEAD`: v6.18.44-1-g2736c32da98b9 / kernel
  6.18.44
- [Phase 6] Read lines 4279–4287: buggy code present
- [Phase 6] `git apply --check` on upstream patch: applies cleanly
- [Phase 8] ZDI Reported-by: security-relevant disclosure channel

**YES**

 drivers/hid/hid-logitech-hidpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 4ba652ae54765..83d625f361f49 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4280,6 +4280,7 @@ static void hidpp_connect_event(struct work_struct *work)
 
 	ret = input_register_device(input);
 	if (ret) {
+		hidpp->input = NULL;
 		input_free_device(input);
 		return;
 	}
-- 
2.53.0

