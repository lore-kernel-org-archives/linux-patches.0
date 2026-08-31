Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C06A5AC202;
	Mon, 31 Aug 2026 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184368; cv=none; b=GBEMsrPdmMoMlpXA/px15EP0TLBTW9578JTCa+GUO5Uu4/XmmVmYEJ9OuX0Oe0nyT4nExjVvth0qpftrgs+qStJTU/CJXVp674+vjez15Wh1H2wK5xTJAurTeWZ6PTY23o+69DYUIBUULNNG839ZjM3OI8PJpKFnGo0u0ugzDj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184368; c=relaxed/simple;
	bh=fya5ovPIXdWGoo7GXPL7wh4frPbHmtlIq06TfhrZvCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sU2v+xzIHWvI3nok3RiBE8Ejmr1x0wMclVMJeJi1NLsIKiS3naip5zHj0UyGMVZB54ai8xuk6cc1cNmTC1X7ziC3JNxz84J2rHhNEJCs4z2lbRlRxr4syENVAnta5sltbfYUqC7DTtvYsb8Xqd3/zgw2RLyfNxEnbjq3shYmLds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PI9mxI0U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PI9mxI0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36081F000E9;
	Mon, 31 Aug 2026 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184366;
	bh=s178l3tkPg96XwYNrBInj4FHO81W0CKawlc0w3Q+fnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PI9mxI0UvKqzvIme+os3W/SVVIZkfEnf/vGhjiXFlXGTlX776+garPLXaILtRPnMY
	 V6Xjtpj3axQKYGe3KPuRNLjU//Tk4qeMubi17+jupV2VHzKszcetLL4hH/22BRuPPj
	 yQp3KgEMZg5mMPNaEyBIho5ag7UvZrWmtJ6rR04K2t7pt40XxJqCWVv7KWdISWv9K/
	 glhTlex2Q0T0c0JgcQ+xmS0DchVyvopEr1dlQxlLyp0qB6XGmMoG84YXlwZ6Q5dFcI
	 ANMH63SsHZCs2QjbSmERahYX2eIx+nb3HyJupma1vbrgWKhGlgkV6KEQVLJ/+InmUT
	 v+qIs1U8IDeIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	westeri@kernel.org,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] thunderbolt: Increase timeout for Configuration Ready bit
Date: Mon, 31 Aug 2026 09:31:19 -0400
Message-ID: <20260831133314.4125787-651-sashal@kernel.org>
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

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit ba2cc385110129d03cd0f18a1b5969a430b67a18 ]

After setting the Configuration Valid bit (ROUTER_CS_5.CV), the USB4
Connection Manager guide specifies a 500 ms timeout for the router to
set the Configuration Ready bit (ROUTER_CS_6.CR). The current timeout
is shorter than specified. While there, fix the kernel-doc typo.

Increase the timeout to match the CM guide recommendation.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[thunderbolt]` `[Increase]` — Increase timeout for
Configuration Ready bit after setting Configuration Valid on USB4
routers.

**Step 1.2 — Tags**

Record:
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none (in commit)
- **Acked-by:** none
- **Link:** none
- **Cc: stable:** none (expected for manual review)
- **Signed-off-by:** Gil Fine, Mika Westerberg (subsystem maintainer)

No syzbot, no user bug report tags.

**Step 1.3 — Body analysis**

Record:
- **Bug:** After setting `ROUTER_CS_5.CV`, the USB4 Connection Manager
  guide requires up to **500 ms** for the router to set `ROUTER_CS_6.CR`
  (Configuration Ready). The kernel waits only **50 ms**.
- **Symptom:** Premature timeout waiting for Configuration Ready;
  enumeration/tunnel setup may proceed before the router is actually
  ready.
- **Root cause:** Timeout value does not match the CM guide
  specification (present since initial USB4 support).
- **Also:** kernel-doc typo — “does nothing for the latter” should be
  “former” (host router, where `tb_route(sw)` is zero).

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Although the subject says “Increase timeout,” this is a
real correctness/timing bug, not cosmetic cleanup. The doc fix is
incidental.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/thunderbolt/usb4.c` (+2 / −2 lines)
- **Functions:** `usb4_switch_configuration_valid()` (timeout change);
  kernel-doc for same function (typo)
- **Scope:** Single-file, surgical fix

**Step 2.2 — Code flow change**

Record:
- **Hunk 1 (doc):** “latter” → “former” — documents that the function is
  a no-op on the **host** router (`!tb_route(sw)` early return).
- **Hunk 2 (timeout):** `tb_switch_wait_for_bit(..., ROUTER_CS_6_CR,
  ..., 50)` → `..., 500)`.
- **Before:** Wait at most 50 ms for CR after writing CV.
- **After:** Wait up to 500 ms per USB4 CM guide.
- **Path:** USB4 device-router hotplug enumeration and resume restore
  (via `tb_switch_configuration_valid()`).

**Step 2.3 — Bug mechanism**

Record: **Logic / timing correctness fix.** The wait can expire at 50 ms
while hardware is still within spec (up to 500 ms).
`tb_switch_wait_for_bit()` then returns `-ETIMEDOUT`. Callers currently
ignore that return value, but the function still returns to callers only
after the (too-short) wait completes, so tunnel/retimer work may start
before CR is set.

**Step 2.4 — Fix quality**

Record:
- **Obviously correct:** Aligns with spec; other waits in the same file
  already use 500 ms (e.g. `ROUTER_CS_26` at line 79).
- **Minimal:** Two-line functional change.
- **Regression risk:** Very low — only lengthens a poll loop; worst case
  adds ~450 ms on genuine timeout paths.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: 50 ms timeout introduced in `1639664fb74f30` (Dec 2021, “Move
usb4_switch_wait_for_bit() to switch.c”); originally in `b04079837b209`
(Dec 2019, “Add initial support for USB4”). Bug has existed since USB4
support landed.

**Step 3.2 — Fixes: tag**

Record: N/A — no Fixes: tag.

**Step 3.3 — Related file history**

Record:
- Part of upstream 5-patch series “CM fixes to follow CM guide more
  closely” (Jan 2026).
- Related upstream-only commits on same files: `062023c4364ff` (Router
  Ready wait in `usb4_switch_setup()`), `69a7b98770b7e` (PCIe adapter
  detect check).
- **This patch is standalone** — only changes CR timeout and doc; does
  not depend on RR verification or other series patches.

**Step 3.4 — Author context**

Record: Gil Fine (Intel thunderbolt contributor); committed by Mika
Westerberg (subsystem maintainer).

**Step 3.5 — Dependencies**

Record: **None required.** `ROUTER_CS_6_CR` and
`tb_switch_wait_for_bit()` exist in this tree. Patch applies cleanly
(`git apply --check` passed). `ROUTER_CS_6_RR` from patch 3/5 is **not**
in 6.18.y and is **not** needed for this change.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- **b4 dig:** https://patch.msgid.link/20260126220606.3476657-5-
  gil.fine@linux.intel.com
- **Series:** v1 only (5 patches, Jan 27 2026)
- **Stable nomination:** None found in thread
- **NAKs:** None

**Step 4.2 — Reviewers**

Record: **b4 dig -w:** Mika Westerberg, Andreas Noever, Yehezkel
Shapira, linux-usb@vger.kernel.org, Lukas Wunner. Mika reviewed patches
2/5 and 3/5; **no reply specifically on patch 4/5**.

**Step 4.3 — Bug reports**

Record: No Reported-by, syzbot, or bugzilla links. Spec-compliance fix
without a public user report.

**Step 4.4 — Series context**

Record: Patch 4/5 of 5; independently valuable. Other patches address
separate CM-guide gaps.

**Step 4.5 — Stable list**

Record: Not searched separately; no stable@vger discussion found in mbox
thread.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `usb4_switch_configuration_valid()`,
`tb_switch_configuration_valid()`, `tb_switch_wait_for_bit()`.

**Step 5.2 — Callers**

Record:
- `tb_switch_configuration_valid()` →
  `usb4_switch_configuration_valid()` for USB4 switches
  (`switch.c:2673-2677`)
- Called from `tb.c:1407` (hotplug/discovery path after TMU enable)
- Called from `tb.c:3095` (`tb_restore_children()` on resume)
- **Return value not checked** at either call site.

**Step 5.3 — Callees**

Record: `tb_sw_read()`, `tb_sw_write()`, `tb_switch_wait_for_bit()`
(poll loop with `usleep_range(50,100)`).

**Step 5.4 — Reachability**

Record: Triggered on USB4/Thunderbolt device-router hotplug and system
resume — common paths for dock/peripheral users with
`CONFIG_USB4`/`CONFIG_THUNDERBOLT`.

**Step 5.5 — Similar patterns**

Record: Other thunderbolt timeout increases in this tree use 500 ms
(`usb4.c:79`). Stable tree already contains `b6d572aeb58a5` (“Increase
DisplayPort Connection Manager handshake timeout”) — precedent for
backporting thunderbolt timing fixes.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.y)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **v6.18.44** (`stable/linux-6.18.y`).
`usb4_switch_configuration_valid()` still uses **50 ms** at
`usb4.c:329-330`. Upstream fix `ba2cc38511012` is **not** an ancestor of
HEAD.

**Step 6.2 — Backport complications**

Record: **Clean apply** — `git format-patch -1 ba2cc38511012 | git apply
--check` succeeded with no conflicts.

**Step 6.3 — Related fixes already present?**

Record: No equivalent timeout change in 6.18.y. Router Ready
verification (`062023c4364ff`) is also absent — separate issue.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: **drivers/thunderbolt** — IMPORTANT (USB4/Thunderbolt docks,
peripherals, resume).

**Step 7.2 — Activity**

Record: Actively maintained; recent stable-relevant fixes include dock
connection issues (`bd646c768a934`) and retimer enumeration timing
(`75749d2c1d8ce`).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: USB4/Thunderbolt users with downstream device routers that need
>50 ms to assert Configuration Ready after Configuration Valid — docks,
hubs, chained routers.

**Step 8.2 — Trigger conditions**

Record: Device connect or resume restore on USB4 topology. Not every
router (only those slower than 50 ms). Not a security issue;
unprivileged users cannot directly trigger this register sequence.

**Step 8.3 — Failure mode severity**

Record: **MEDIUM–HIGH** — intermittent enumeration failures, tunnels not
established, peripherals/docks failing to work until replug/reboot. Not
a kernel oops, but a real functional failure on affected hardware.

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** Prevents premature proceed-before-ready on slow-but-spec-
  compliant routers; aligns with CM guide.
- **Risk:** Very low (2-line change, longer wait only on this specific
  bit poll).
- **Ratio:** Favorable for stable.

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Real spec mismatch bug since USB4 support (2019/2021)
- Buggy code confirmed in v6.18.44
- Small, obviously correct, applies cleanly
- Standalone (no series dependencies)
- Maintainer-authored/committed
- Precedent: other thunderbolt timeout increases are in 6.18.y
- Can cause user-visible dock/peripheral failures

**Evidence AGAINST:**
- No explicit user bug report or syzbot report
- Callers ignore return value (mitigates crash risk but not functional
  impact)
- Part of broader CM-guide compliance series (though this hunk is
  independent)

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — spec-aligned; maintainer
   SOB; no Tested-by but change is trivial
2. Fixes a real bug? **PASS** — timeout too short vs USB4 CM guide
3. Important issue? **PASS** — functional failures on USB4 hardware
   (MEDIUM–HIGH)
4. Small and contained? **PASS** — 2 lines functional change, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean apply

**Exception category:** Hardware timing workaround / spec-compliance fix
for existing USB4 driver (similar to prior thunderbolt timeout
backports).

---

## Problem Summary for Stable Users

On v6.18.44, after marking a USB4 device router’s configuration valid,
the kernel waits only 50 ms for the Configuration Ready bit. The USB4
Connection Manager guide allows up to 500 ms. Routers that need between
50–500 ms can hit a premature timeout; enumeration then continues before
the router is ready, which can manifest as flaky or failed
Thunderbolt/USB4 dock and peripheral bring-up. The fix is a minimal
timeout increase plus a documentation typo correction.

---

## Verification

- [Phase 1] Parsed commit `ba2cc38511012`: subject, body, tags (only
  SOBs)
- [Phase 2] Read diff: 50→500 ms in `usb4_switch_configuration_valid()`,
  doc typo fix
- [Phase 2] Read `tb_switch_wait_for_bit()` at `switch.c:1720-1739`
- [Phase 3] `git blame` lines 329-330: introduced 2021, 50 ms since USB4
  bring-up
- [Phase 3] `git log -S "ROUTER_CS_6_CR, 50"`: original in
  `b04079837b209`
- [Phase 3] `git merge-base --is-ancestor b04079837b209 HEAD`: USB4 code
  in tree
- [Phase 3] `ba2cc38511012` not ancestor of HEAD: fix not yet in 6.18.44
- [Phase 4] `b4 dig -c ba2cc38511012`: lore URL found
- [Phase 4] `b4 dig -a`: v1 series, patch 4/5
- [Phase 4] `b4 dig -w`: maintainers CC’d
- [Phase 4] `b4 dig -m /tmp/tb_timeout.mbx`: no stable Cc, no NAKs, Mika
  replied on patches 2–3 only
- [Phase 5] `grep usb4_switch_configuration_valid`: callers in
  `switch.c`, `tb.c`
- [Phase 5] Read `tb.c:1407`, `tb.c:3095`: return value not checked
- [Phase 5] Read `usb4.c:311-330`: early return for host
  (`!tb_route(sw)`)
- [Phase 5] `usb4.c:79`: other 500 ms timeout precedent in same file
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] `git format-patch -1 ba2cc38511012 | git apply --check`:
  clean apply
- [Phase 6] `grep ROUTER_CS_6_RR tb_regs.h`: not in 6.18.y (unrelated to
  this patch)
- [Phase 7] `git log --grep="DisplayPort Connection Manager handshake
  timeout" stable/linux-6.18.y`: precedent commit present
- [Phase 8] Assessed severity: functional USB4 enumeration failures, not
  kernel crash

**YES****Verdict: YES** — backport to this tree (v6.18.44 /
`stable/linux-6.18.y`).

The commit fixes a real USB4 timing bug: after setting Configuration
Valid, the kernel waits only **50 ms** for Configuration Ready, but the
USB4 CM guide allows **500 ms**. On slower routers, enumeration can
proceed too early and cause flaky dock/peripheral bring-up. The change
is two lines in `drivers/thunderbolt/usb4.c`, applies cleanly, is
standalone (doesn't need the other patches in the series), and matches
precedent for thunderbolt timeout fixes already in 6.18.y.

 drivers/thunderbolt/usb4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 276c25c7d37e6..9430bed07c468 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -304,7 +304,7 @@ int usb4_switch_setup(struct tb_switch *sw)
  * Sets configuration valid bit for the router. Must be called before
  * any tunnels can be set through the router and after
  * usb4_switch_setup() has been called. Can be called to host and device
- * routers (does nothing for the latter).
+ * routers (does nothing for the former).
  *
  * Return: %0 on success, negative errno otherwise.
  */
@@ -327,7 +327,7 @@ int usb4_switch_configuration_valid(struct tb_switch *sw)
 		return ret;
 
 	return tb_switch_wait_for_bit(sw, ROUTER_CS_6, ROUTER_CS_6_CR,
-				      ROUTER_CS_6_CR, 50);
+				      ROUTER_CS_6_CR, 500);
 }
 
 /**
-- 
2.53.0

