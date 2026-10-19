Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AB7608489;
	Mon, 19 Oct 2026 14:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418607; cv=none; b=UwC+RS7s2reEHUOU12m/tV0kJdtkgAJvnRxdqewMIIae7nKPJySFLMxMkjp4n3Zjd4nz2wg+e/lxApqv0W33/q7zJ9nFt4GPCaQVq+mGz4g8jsfy8K8/rLvikzzhrAJ+PTW5+uMAP14qFufo9zexYMreTsyz+A50dMathNZYB6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418607; c=relaxed/simple;
	bh=rUaMveUNmO2qn+Sw5dS+CFEUZFGzwaqcK7xbYqBhYQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t9AH9uROe18QTDib8hi0gsDxLxfvrsBhZcNOFh8pa+4YWCtP/VdguzRVAm32eHfD3HO4xAp7UfIzVju1uizUfes5mgS6az2mZjbzC9Gh0Z3OxRMSM3hd2zadCY0vPBhRRPZnS8ypLQVPzhupV7djOo7jzfkNWu9iCD2d/vOJjoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErzTiZrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErzTiZrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0575C1F000C8;
	Mon, 19 Oct 2026 14:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418603;
	bh=/0gwJu5gsMlNiTiFTASzDK7gtbb0uh1Ih6HDMskhJ94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ErzTiZrq0v4kPJiRfQGFP0nPnzBFPGEKIoFMp8y9iwF6HoLb9+DGIiFY1J/xxWmSA
	 1H0aE+i61Bd9zUvPgRRLkJRlHSau9nPi9HoNmiCB520PEHwRGu9fDWWP02wdD0cpBd
	 RPLIyrQpJ8xu65jutmC71jA4SZBX867zIQa56cL8TPYzPJ7p++zUJCUct/z5tbezmg
	 L7XRsNNV9WVqyq8MdzvV/Uv06XQbFduXZjZcPVLdcsVxmZ3HibMgWY398SZs5uB1Bb
	 AU3dNpgKKkGAsrzSRxudFIZsWIJuF4+YNV9QAK69SDL3lft1Ie0VmS/3lxJ2yqy0K6
	 l0SVvVRMCFwtw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Youth Cao <cocoh2os08@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] HID: i2c-hid: Add i2c-hid-quirk-bad-input-size quirk for 0911:5288 device
Date: Mon, 19 Oct 2026 09:50:57 -0400
Message-ID: <20261019135441.1420968-366-sashal@kernel.org>
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

From: Youth Cao <cocoh2os08@gmail.com>

[ Upstream commit 58d97b45f3f43af0afd9c74e8480d22d36fd3f72 ]

I have recently acquired a cheap Apollo Lake-based laptop that uses a
Hynitron CST128-A touchpad controller. While booting from a Debian LiveCD,
the kernel log is flooded with the following error (though the touchpad
works well):

  i2c_hid_acpi i2c-ALPS0001:00: i2c_hid_get_input: incomplete report (27/42405)

The CST128-A was identified via ACPI as ALPS0001:00, and the I2C HID
device ID (0911:5288) was shared with the Hantick 5288.

Add the I2C_HID_QUIRK_BAD_INPUT_SIZE quirk option to the existing Hantick
5288 quirk entry to suppress the kernel log flood.

Signed-off-by: Youth Cao <cocoh2os08@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.18.57** (`v6.18.57-155-gcdf239ca885b2`). This is a
one-line HID i2c-hid hardware quirk for device `0911:5288`. The quirk
table, `I2C_HID_QUIRK_BAD_INPUT_SIZE`, and the Hantick 5288 entry are
all already in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[HID/i2c-hid] [Add] hardware quirk
`I2C_HID_QUIRK_BAD_INPUT_SIZE` for I2C HID ID 0911:5288 (Hantick 5288 /
Hynitron CST128-A)**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none (author is the reporter: “I have recently
  acquired…”)
- **Tested-by:** none
- **Reviewed-by:** none on the commit
- **Acked-by:** none
- **Link:** none on the commit; lore thread recovered via `b4 dig`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Youth Cao (author); Jiri Kosina (HID maintainer,
  applied it)
- Ignore pipeline SOBs/Upstream markers as instructed

Notable: HID maintainer SOB. Single reporter, real hardware.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** Hynitron CST128-A touchpad (ACPI `ALPS0001:00`, I2C HID ID
  `0911:5288`) reports a bogus input length.
- **Symptom:** kernel log flooded with `i2c_hid_get_input: incomplete
  report (27/42405)`. Touchpad still works.
- **Root cause:** device writes an invalid HID input length (42405 =
  `0xA5A5`) while `wMaxInputLength` is 27.
- **Fix:** OR `I2C_HID_QUIRK_BAD_INPUT_SIZE` onto the existing Hantick
  5288 quirk so the driver uses max input length instead of dropping the
  report and calling unratelimited `dev_err()`.
- **Version info:** none in the message. Hardware is cheap Apollo Lake
  laptops; driver support for this ID dates to 2017.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. Explicit hardware quirk. Same class as
USB/PCI/codec quirks that stable already takes.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/hid/i2c-hid/i2c-hid-core.c` — 1 insertion, 1
  deletion
- **Function / data:** `i2c_hid_quirks[]` table, Hantick 5288 entry
- **Scope:** single-file, one-line surgical quirk

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** `0911:5288` only has `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET`.
  In `i2c_hid_get_input()`, if `ret_size > size || ret_size <
  sizeof(__le16)`, the IRQ path logs `incomplete report` via `dev_err()`
  (not ratelimited) and **returns without delivering the HID report**.
- **After:** same ID also has `I2C_HID_QUIRK_BAD_INPUT_SIZE`. On a bad
  size, the driver overwrites the length prefix with `size`
  (`min(wMaxInputLength, bufsize)`) and continues into
  `hid_safe_input_report()`.
- **Path:** IRQ handler (`i2c_hid_irq` → `i2c_hid_get_input`), not
  probe/error-init. Only this VID/PID.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** hardware workaround (quirk table)
- **Mechanism:** device reports garbage length (`0xA5A5` / 42405).
  Without the quirk, every such IRQ logs and drops the report. The quirk
  is the existing BAD_INPUT_SIZE path added in 2019 for Lenovo Y720.

Verified BAD_INPUT_SIZE handler in this tree:

```561:570:drivers/hid/i2c-hid/i2c-hid-core.c
        if (ret_size > size || ret_size < sizeof(__le16)) {
                if (ihid->quirks & I2C_HID_QUIRK_BAD_INPUT_SIZE) {
                        *(__le16 *)ihid->inbuf = cpu_to_le16(size);
                        ret_size = size;
                } else {
                        dev_err(&ihid->client->dev,
                                "%s: incomplete report (%d/%d)\n",
                                __func__, size, ret_size);
                        return;
```

`size` is already capped to `ihid->bufsize`, so forcing `ret_size =
size` does not overflow the input buffer.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: one flag on an existing table entry; handler
  already used by Lenovo Y720 (`USB_VENDOR_ID_ITE` / Legion Y720) in
  this tree.
- Minimal, no API/refactor.
- **Regression risk:** low. Quirk only runs when the length is already
  invalid. Well-formed reports for other 0911:5288 boards (Cube Thinker,
  EZBook 3 Pro, T-bao, etc. from Hans de Goede’s 2017 commit) are
  unchanged. Worst case on a truly truncated packet is processing a
  padded report instead of dropping it — same as Y720 since 2019.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Hantick 5288 table entry introduced by **402946a8ef71e** (Hans de
  Goede, 2017-11-07): `HID: i2c-hid: Add no-irq-after-reset quirk for
  0911:5288 device`. Present in **v6.18.57**.
- `I2C_HID_QUIRK_BAD_INPUT_SIZE` introduced by **fd09137687016** (Pavel
  Balan, 2019-11-27) for Lenovo Y720 incomplete-report flood. Present in
  **v6.18.57**.
- Buggy combination (Hantick ID without BAD_INPUT_SIZE) has been in-tree
  for years.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. Not applicable. The “broken” state is hardware,
not a recent kernel regression.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Same-file relatives: `fd09137687016` (Y720 BAD_INPUT_SIZE),
  `402946a8ef71e` (Hantick NO_IRQ_AFTER_RESET), `fb6acf76c3fdd` (Raydium
  incomplete-report flood).
- Not a numbered series. Standalone v1.
- Prerequisite code (quirk bit + table entry + handler) is in this tree.
  No missing helpers.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Youth Cao has only this commit under `drivers/hid/i2c-hid/`
here. Not the maintainer. Applied by Jiri Kosina, HID maintainer.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None beyond 2017/2019 infrastructure already in 6.18.57.
Standalone one-liner.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 58d97b45f3f43af0afd9c74e8480d22d36fd3f72` →
  https://patch.msgid.link/20260903161444.786-1-cocoh2os08@gmail.com
- `b4 dig -a`: **v1 only** (2026-09-04). Applied as submitted.
- Thread: author submission; sashiko-bot flag of an **unrelated pre-
  existing DMA** issue in `i2c_hid_fetch_hid_descriptor()`; Jiri Kosina
  “Applied, thanks.” (2026-09-11).
- No NAK, no request for v2, no stable nomination in review.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc included Jiri Kosina, Benjamin Tissoires,
linux-input, linux-kernel. Maintainer applied it. No extra Reviewed-by.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: The patch *is* the bug report. One user, Debian LiveCD, Apollo
Lake + CST128-A. Concrete log line. Author says the touchpad “works
well” aside from the flood.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone. Not 2/N. No sibling patches required.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: Web search of lore.kernel.org/stable for this subject/ID found
no prior stable discussion (lore HTTP 403 from this environment;
openwall/lkml used instead). **UNVERIFIED** that nobody requested it on
stable@, but nothing found arguing against it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body changed. Data only: `i2c_hid_quirks[]`. Runtime
effect is in `i2c_hid_lookup_quirk()` and `i2c_hid_get_input()`.

Step 5.2: TRACE CALLERS
Record:
- `i2c_hid_lookup_quirk()` called from `__i2c_hid_core_probe()`
  (`ihid->quirks = ...`) — device probe, once per device.
- `i2c_hid_get_input()` called from `i2c_hid_irq()` — interrupt context,
  every input IRQ.
- Impact surface: only VID/PID 0911:5288.

Step 5.3: TRACE CALLEES
Record: After the quirk, path continues to `hid_safe_input_report()`
(present in v6.18.57). Input buffer already sized; length forced to
`size ≤ bufsize`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: ACPI I2C HID enumeration (`i2c-hid-acpi`) → probe → IRQ on
touchpad activity. Reachable on real laptops without special syscalls.
`CONFIG_I2C_HID` is `default y`; `I2C_HID_ACPI` is the usual x86 laptop
path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same quirk already used for Lenovo Legion Y720. Same “incomplete
report” flood class previously fixed (Y720, Raydium). Pattern is
established, not experimental.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** At v6.18.57:

```
{ I2C_VENDOR_ID_HANTICK, I2C_PRODUCT_ID_HANTICK_5288,
    I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
```

IDs in `drivers/hid/hid-ids.h`: `I2C_VENDOR_ID_HANTICK 0x0911`,
`I2C_PRODUCT_ID_HANTICK_5288 0x5288`. BAD_INPUT_SIZE bit and handler
exist. Bug introduced with this hardware + the 2017 ID match, not after
6.18 branched.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Minor context only.** `git apply --check` of the stored hunk
onto v6.18.57 fails because context includes the later Yoga Slim 7x
keyboard quirk line
(`I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_G11_KEYBOARD`), which is **not**
in v6.18.57. The Hantick line itself matches. A 1-line context tweak
applies cleanly. Not a semantic rework.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Y720 BAD_INPUT_SIZE is present. Nothing else already adds
BAD_INPUT_SIZE for 0911:5288 at v6.18.57. No alternate fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **HID / i2c-hid** (`drivers/hid/i2c-hid/`). **IMPORTANT** for
laptop input (touchpads/touchscreens), not core mm/fs. Peripheral in the
sense of one cheap-laptop ID, but i2c-hid itself is common.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained (Dell S4, Elan panel, QTEC, Goodix, buffer
overflow fixes in recent 6.18 history). Quirk table is a mature, long-
lived mechanism.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver/hardware-specific. Users of I2C HID `0911:5288` (Hantick
5288 clones, Hynitron CST128-A on cheap Apollo Lake laptops).
`CONFIG_I2C_HID` / `I2C_HID_ACPI`.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Touchpad IRQs that carry a bogus length. Author saw it at boot
on a Debian LiveCD, so it is not rare-on-error-only for this hardware.
Unprivileged users generate IRQs by using the pad; they cannot change
the VID/PID. Not a security trigger.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- **Failure mode:** unratelimited `dev_err()` from IRQ context →
  dmesg/journal flood; those reports are dropped.
- **Severity:** **MEDIUM** as a log flood; can still hurt (console spam,
  log wrap, hiding other messages). Not oops/deadlock/corruption. Author
  says the pad still works, so some reports are valid.
- Hardware-quirk exception still applies.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** medium for affected hardware (stops flood; may deliver
  reports that were dropped). Low for everyone else (no code path
  change).
- **Risk:** very low (1 line, existing quirk, ID-matched).
- **Ratio:** favorable. Classic stable quirk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR:**
- Real hardware, real user log, concrete `incomplete report (27/42405)`.
- Existing quirk infrastructure in 6.18.57; same pattern as Y720 (2019).
- One line, ID-scoped, no new API.
- HID maintainer applied v1 with no objections.
- Unratelimited `dev_err` in IRQ is a real nuisance on these machines.
- Stable exception: hardware quirk on an existing driver.

**AGAINST:**
- Not a crash, UAF, or data-corruption fix; author says the touchpad
  already works.
- Applies to every 0911:5288, not only CST128-A/ALPS0001 (mitigated:
  quirk inert on valid lengths).
- Naive apply onto bare v6.18.57 needs a tiny context tweak (Yoga Slim
  line).

**UNRESOLVED:**
- Could not fetch lore.kernel.org (HTTP 403); used `b4 dig` mbox +
  Openwall/LKML.
- No stable@ thread found; absence not treated as a negative.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — one flag; author tested on
   the laptop; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — log flood + dropped
   bad-size reports on real hardware.
3. Important issue? **PASS** under the hardware-quirk exception;
   severity MEDIUM, not CRITICAL.
4. Small and contained? **PASS** — 1 line, one table entry.
5. No new features or APIs? **PASS** — reuses
   `I2C_HID_QUIRK_BAD_INPUT_SIZE`.
6. Can apply to the local tree? **PASS** — code exists in 6.18.57; at
   most a context-line adjustment.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk/workaround** on an existing i2c-hid quirk
table. Explicitly in-scope for stable.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.18.y tree. The buggy Hantick entry
and BAD_INPUT_SIZE handler are already here. The change is the standard
way this driver papers over broken input-length hardware.

What it solves for stable users: cheap Apollo Lake machines with
0911:5288 (Hynitron CST128-A / Hantick clones) stop flooding the log on
every bad-sized HID IRQ, matching the Y720 precedent.

Risk vs benefit: very low risk, localized benefit, no prerequisites
missing.

Concerns: trivial hunk-context conflict with the Yoga Slim quirk line if
applying the mainline diff onto unmodified v6.18.57; the Hantick line
itself does not need rework.

Verification:
- [Phase 1] Parsed subject/tags/body from `git show 245d6017beff2` /
  upstream `58d97b45f3f4`; no Fixes/Reported-by/Cc:stable; SOB Youth Cao
  + Jiri Kosina
- [Phase 2] Diff is 1 line in `i2c_hid_quirks[]`; handler at
  `i2c_hid_get_input()` lines 561–570 verified; `size` capped to
  `bufsize` at 532–533
- [Phase 2] 42405 == 0xA5A5 verified arithmetically
- [Phase 3] `git merge-base --is-ancestor 402946a8ef71e v6.18.57` YES;
  `fd09137687016` YES; this commit NOT in v6.18.57
- [Phase 3] `git blame -L 120,145 v6.18.57 --
  drivers/hid/i2c-hid/i2c-hid-core.c`: Hantick entry from 402946a8ef71e
  / 67b18dfb8cfc6d
- [Phase 3] Author `git log --author='Youth Cao'` only this i2c-hid
  commit
- [Phase 4] `b4 dig -c 58d97b45f3f4` → msgid 20260903161444.786-1; `-a`
  v1 only; `-w` Kosina + Tissoires + linux-input; `-m` 3-message mbox
- [Phase 4] Openwall: Jiri Kosina “Applied, thanks.”; sashiko-bot pre-
  existing DMA note unrelated
- [Phase 4] lore.kernel.org WebFetch 403; stable@ search found no
  discussion of this ID
- [Phase 5] `git grep` callers: lookup at probe 1073; get_input from
  `i2c_hid_irq` 592
- [Phase 5] `hid_safe_input_report` ancestor of v6.18.57: YES
- [Phase 6] `make kernelversion` / Makefile: 6.18.57; Hantick IDs in
  v6.18.57 `hid-ids.h` 646–647
- [Phase 6] `git apply --check` of the stored hunk onto v6.18.57 fails
  on Yoga Slim context line; Hantick source line identical
- [Phase 7] Kconfig: `I2C_HID` default y; `I2C_HID_ACPI` for this ACPI
  path
- [Phase 8] Failure mode: IRQ `dev_err` flood + dropped reports; not
  oops
- UNVERIFIED: full lore.kernel.org HTML thread (403); whether any
  0911:5288 unit is harmed by processing bad-size frames (no reports
  found)

**YES**

 drivers/hid/i2c-hid/i2c-hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 29c4f624f3c5c..e5a4c7deba502 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -123,7 +123,7 @@ static const struct i2c_hid_quirks {
 	__u32 quirks;
 } i2c_hid_quirks[] = {
 	{ I2C_VENDOR_ID_HANTICK, I2C_PRODUCT_ID_HANTICK_5288,
-		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET | I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ I2C_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_VOYO_WINPAD_A15,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ I2C_VENDOR_ID_RAYDIUM, I2C_PRODUCT_ID_RAYDIUM_3118,
-- 
2.53.0

