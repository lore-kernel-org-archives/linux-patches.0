Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209E25B5867;
	Mon, 19 Oct 2026 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418442; cv=none; b=SyufBb36T/q7DsUlwsUnThTenLvee8XcUt0AsaPi67m6ilfCL323R29hbjSzxloMMnyTkpIK6ER1Lhy7QiYkQo2oBZF++gT8epbU+ZS4tjIpCX6mG0xq5Es58GubzQwACrG38Z+UvwbW+uExZe1EpYz4Rz+nBfG00k7W7whZ734=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418442; c=relaxed/simple;
	bh=KH1gZ0iSo8ZMkj7QxDbs2N6J7RnFZAXfj+bSqZteFPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/w1ehUYSYudyIGECAauFECRauDpX8g1MmOxB6P3ZM8u6GMiQY08WwxcaBiPFnXDOJRa/uRVW4dXGqm6dZG2OIDY9+09e/dhG6smWUcLnOgblfxFnWa4EJFcaoQw3Bgv3A6gOOPp1jrBKRcuKUuwMP6O0GsIhHZU4pP1xh0aTqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0Oe4IX2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0Oe4IX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AF41F000C8;
	Mon, 19 Oct 2026 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418440;
	bh=4Fr6kfWDp4dOvN1nv2z8jERPaky7/iIWciLiTwBsJ0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0Oe4IX2jzoiIWK7d7AmZdYtxXCT6Zsx60Nld666lsTfqLRHrfb4KWQWxdEVHjd7E
	 zgCoexYtOHU1C4dX51cMLtx+B1D4LkBtFjXVzj2McIx/2C9tAj21xq/pme1o7WPzYt
	 CsG3dVBDnPqBcGSpLcVOM2KC/vsNkzvRCAYzgfJ4YTHrrLShEOAhzqykiatZmXBtxi
	 uWmYF7P7Fcme4wwnthciE4b77Fp/iuTHQJc1nr2WLVbhoc+zk/BQVtJ5SNBEACbneL
	 zCHcxs8QQfAXEEk6bFu724OyZ68CKJpM8z3vj1iECYws407Dzu7tBuFW0KZGlzbWaX
	 r6Add9AfByKcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hverkuil@kernel.org,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: go7007: avoid undefined shifts in MPEG-4 headers
Date: Mon, 19 Oct 2026 09:49:01 -0400
Message-ID: <20261019135441.1420968-250-sashal@kernel.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 41f82777e547732460290ceb28fcc7c1b95ef192 ]

The byte-alignment paths can call CODE_ADD() with a zero bit
length.  The macro then shifts an int by name.b, which can be 32
after the preceding bit was flushed.

vti_bitlen() can likewise shift a signed int into its sign bit while
searching for the bit length, and the package mask construction can
shift by the full type width.

Make zero-length additions a no-op, derive the bit length with fls(),
and build the mask with GENMASK().

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject line**
Record: `[media/go7007] [avoid] undefined shifts in MPEG-4 header bit-
packing`. Subsystem is the WIS GO7007 USB MPEG encoder. “Avoid” is a
bug-fix verb: the patch stops C undefined behavior, not adding a
feature.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>` (author)
- `Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>` (media
  maintainer; applied)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable` (absence of Fixes/Cc-stable is expected
  for this review)

**Step 1.3 — Body**
Record:
- Bug: `CODE_ADD()` can be called with bit length 0; after a flush
  `name.b` can be 32, so `(val) << name.b` is a 32-bit shift of a 32-bit
  int (C UB).
- `vti_bitlen()` uses `(1 << i)` with signed `1` and `i` starting at 31
  (shift into the sign bit).
- Package mask `(1 << vop_time_increment_bitlength) - 1` can shift by
  the full type width.
- Symptoms: UBSAN shift diagnostics; wrong bitstream on arches that mask
  the shift count; possible hang in `vti_bitlen()` when `max_time_incr
  == 0`.
- No version range or crash log in the message.
- Root cause as stated: unguarded shift counts in the MPEG header
  bitpacker.

**Step 1.4 — Hidden bug fix?**
Record: Not disguised. It is an explicit UB/correctness fix. The `fls()`
rewrite is equivalent for every nonzero value and also stops an unsigned
wrap / infinite loop when `max_time_incr == 0`.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/media/usb/go7007/go7007-fw.c` (+15 / −13)
- Functions/macros: `CODE_ADD`, `vti_bitlen()`, `seqhead_to_package()`;
  plus `#include <linux/bitops.h>`
- Scope: single-file surgical fix

**Step 2.2 — Flow change**
Record:
1. `CODE_ADD`: previously always did `name.b -= length; name.a |= (val)
   << name.b`. After: `if (length)` wraps the body, so length-0 is a no-
   op.
2. `vti_bitlen`: previously a countdown from 31 with `(1 << i) - 1`
   masks. After: `fls(max_time_incr)` with `bitlen ?: 1`.
3. `seqhead_to_package`: `(1 << vop_time_increment_bitlength) - 1` →
   `GENMASK(vop_time_increment_bitlength - 1, 0)`.

Affected path is firmware-image construction at MPEG-4 stream start
(`go7007_start_encoder()`), not a generic hot path.

**Step 2.3 — Bug mechanism**
Record: **Type / undefined-shift (UBSAN class)**, with a logic/hang side
effect.

Verified zero-length `CODE_ADD` in `mpeg4_frame_header()` /
`mpeg4_sequence_header()`:

```758:761:drivers/media/usb/go7007/go7007-fw.c
        /* Byte-align with a zero followed by ones */
        i = 8 - (CODE_LENGTH(c) % 8);
        CODE_ADD(c, 0, 1);
        CODE_ADD(c, (1 << (i - 1)) - 1, i - 1);
```

When `CODE_LENGTH % 8 == 7`, `i == 1`, so the second call is
`CODE_ADD(..., 0, 0)`. After the 1-bit add, `name.b` can be 32, then
`(val) << 32` is UB.

Pre-fix `vti_bitlen`:

```c
for (i = 31; (max_time_incr & ((1 << i) - 1)) == max_time_incr; --i)
    ;
return i + 1;
```

`1 << 31` is a signed shift into the sign bit (UB) on every call. If
`max_time_incr == 0`, the condition is always true, `i` is `unsigned
int`, `--i` wraps, and the loop does not terminate.

**Step 2.4 — Fix quality**
Record: Obviously correct and minimal.
- `fls(x)` matches the old loop for all `x > 0` (spot-checked 1, 2,
  30000, 0x80000000).
- `fls(0) ?: 1` returns 1 instead of hanging.
- `GENMASK(n-1, 0)` is the defined way to build an n-bit mask;
  `vti_bitlen()` never returns 0 after the `?: 1` guard, so `GENMASK(-1,
  0)` cannot happen.
- Regression risk is low: no locking, no API, no data-structure change.
  Residual UB not in this patch: `(1 << (i - 1))` in the same padding
  path is safe because `i` is in 1..8.

---

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Buggy `CODE_ADD` / `vti_bitlen` / mask come from
`866b8695d67e83` (“Staging: add the go7007 video driver”, 2008-10-10).
Driver left staging in `7955f03d18d14`. The bug is ~18 years old, not
recent churn.

**Step 3.2 — Fixes: tag**
Record: No `Fixes:` tag. Introducer is the 2008 staging add above. `git
merge-base --is-ancestor 41f82777e5477 HEAD` is true: this snapshot
already contains the fix.

**Step 3.3 — File history**
Record: Recent `go7007-fw.c` commits are unrelated (min/max macros,
SPDX, KASAN frame warning, sparse). Standalone, not `N/M`.

**Step 3.4 — Author**
Record: Yousef Alhouseen is not the media maintainer; nearby work is a
series of small correctness patches. Weight comes from Hans Verkuil’s
SOB (applied to media tree).

**Step 3.5 — Dependencies**
Record: Needs `fls()` and `GENMASK()`, both long-standing
(`<linux/bitops.h>` / `<linux/bits.h>`). No prerequisite series. Can
apply standalone to any tree that still has this file.

---

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record: `b4 dig -c 41f82777e5477` → https://patch.msgid.link/20260630105
257.54757-1-alhouseenyousef@gmail.com
`b4 dig -a`: **v1 only**, one revision.
Saved mbox: single message, no replies. Hans applied it without public
review comments. No NAK, no reviewer `Cc: stable`.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Hans Verkuil, Mauro Chehab, linux-media, linux-kernel. Right
maintainers were on the To/Cc list.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla/Reported-by. Inspection/UBSAN-style fix, not
a user crash report.

**Step 4.4 — Series**
Record: Standalone v1. Same-day sibling `media: go7007: s2250: propagate
control I/O failures` is a different bug.

**Step 4.5 — Stable list**
Record: lore.kernel.org/stable fetch returned 403. Web search for this
subject on stable found **no** discussion. UNVERIFIED beyond that
search.

---

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
Record: `CODE_ADD` (macro), `vti_bitlen()`, `seqhead_to_package()`. No
semcode MCP in this environment; used grep.

**Step 5.2 — Callers**
Record:
- `vti_bitlen()` ← `mpeg4_frame_header()`, `mpeg4_sequence_header()`,
  `seqhead_to_package()`
- those ← `gen_mpeg4hdr_to_package()` / `do_special(SPECIAL_SEQHEAD)`
  when `go->format == V4L2_PIX_FMT_MPEG4`
- `go7007_construct_fw_image()` ← `go7007_start_encoder()` ←
  `go7007_start_streaming()` (vb2 `start_streaming`)

**Step 5.3 — Callees**
Record: After the patch, `fls()` and `GENMASK()` only. No alloc/lock in
the changed lines.

**Step 5.4 — Reachability**
Record: Yes, from userspace: open the V4L2 node, `VIDIOC_S_FMT` MPEG-4,
`VIDIOC_STREAMON`. Firmware construction runs with `hw_lock` held.

`VIDIOC_S_PARM` can make `fps_scale` huge:

```485:491:drivers/media/usb/go7007/go7007-v4l2.c
        n = go->sensor_framerate *
                parm->parm.capture.timeperframe.numerator;
        d = 1001 * parm->parm.capture.timeperframe.denominator;
        if (n != 0 && d != 0 && n > d)
                go->fps_scale = (n + d/2) / d;
        else
                go->fps_scale = 1;
```

If `fps_scale > sensor_framerate` (~25025–30030), `max_time_incr == 0`
and the old loop hangs while holding `hw_lock`. Needs device node access
(typically `video` group), not a random unprivileged syscall on machines
without the hardware.

**Step 5.5 — Similar patterns**
Record: MPEG-1 byte-align already skips `CODE_ADD` when `j == 8`. MPEG-4
padding is the length-0 case. No sibling drivers share this macro.

---

## Phase 6: This checkout

**Step 6.1 — Does the buggy code exist here?**
Record: Local tree is **v7.3-rc4** (`7.3.0-rc4`, `f0100363d8c37`). The
driver is present. Current `go7007-fw.c` already has the fix (`#include
<linux/bitops.h>`, `if (length)`, `fls()`, `GENMASK()`). Pre-fix code
lived in this file from 2008 until `41f82777e5477` (2026-07-15). Any
stable kernel that still has unfixed `go7007-fw.c` has the bug.

**Step 6.2 — Backport difficulty**
Record: Clean apply. The bitpacker has been stable since 2008; the hunks
match the historical file. Only extra include is `<linux/bitops.h>`.

**Step 6.3 — Related fixes already here**
Record: This *is* the fix. No earlier alternate fix in the file history.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: `drivers/media/usb/go7007` — USB V4L2 MPEG encoder (WIS GO7007 /
Sensoray 2250, Plextor, etc.). Criticality: **PERIPHERAL** (specific old
capture dongles), but not staging.

**Step 7.2**
Record: Low churn. Recent commits are small leak/error-path fixes.
Mature, rarely touched encoder header generator.

---

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: Users of `CONFIG_VIDEO_GO7007` with MPEG-4 encode. Hardware IDs
include Sensoray 2250/2251 (`0x1943:0xa250`) and several WIS/Plextor USB
IDs. Not universal.

**Step 8.2 — Trigger**
Record:
- Common: every MPEG-4 `STREAMON` can hit length-0 `CODE_ADD` depending
  on header bit length (UBSAN / UB). Typical `val` is 0, so x86 often
  still produces a no-op.
- Uncommon but real: `VIDIOC_S_PARM` with a large time-per-frame →
  `max_time_incr == 0` → old `vti_bitlen` infinite loop under `hw_lock`.
- Typical `sensor_framerate` is 25025/30000/30030, so `(1 << vti_bitlen)
  - 1` is a ~15-bit shift and not the 32-bit case; the GENMASK change is
  defensive for that site.

**Step 8.3 — Failure mode**
Record:
- Length-0 shift: UBSAN / undefined; functional impact usually none
  because `val == 0`. Severity **MEDIUM** (UBSAN), not a proven oops.
- `vti_bitlen` hang: driver stuck with `hw_lock` held → STREAMON never
  finishes. Severity **HIGH** for that device, not a machine-wide panic.
- Overall: **MEDIUM–HIGH**, not core-kernel CRITICAL.

**Step 8.4 — Risk vs benefit**
Record: Benefit medium for go7007 users (defined behavior, no hang).
Risk **very low** (~15 lines, equivalent `fls()`, maintainer-applied).
Ratio favors backport.

---

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Real C undefined shifts in reachable MPEG-4 header generation
- Old `vti_bitlen()` can livelock when `fps_scale` is large
- 15/13 lines, one file, obviously correct
- `fls()` is equivalent for all nonzero inputs
- Hans Verkuil signed off
- Bug present since 2008; applies cleanly
- No new API/feature

Against:
- Niche USB encoder, few systems
- No user/syzbot report
- Common-path length-0 add is `val==0`, often a practical no-op
- GENMASK site is not a 32-bit shift with real framerates
- No public review beyond maintainer apply

Unresolved:
- Could not read lore.kernel.org/stable (403)
- No sanitizer log attached to the commit (whether UBSAN actually fired
  is unverified)

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — equivalent rewrite;
   maintainer applied v1.
2. Real bug that affects users? **PASS** — UB on MPEG-4 start; hang if
   `max_time_incr==0`.
3. Important (crash/security/corruption/deadlock)? **PASS** — hang under
   `hw_lock` plus UBSAN-class UB. Not a core panic, but a real driver
   DoS/UB, not style cleanup.
4. Small and contained? **PASS** — one file, ~28 lines.
5. No new features/APIs? **PASS**.
6. Applies to this tree’s go7007 code? **PASS** — same file/macros;
   include is standard.

**Step 9.3 — Exception category**
Record: None (not a device ID/quirk/DT/build/docs). It is a normal small
correctness fix.

**Step 9.4 — Decision**
This checkout is mainline 7.3-rc4, which already contains the commit;
the question is whether the fix has stable technical merit for trees
that still have the 2008 bitpacker. It does: small, correct, no
dependencies, fixes defined-behavior bugs and a reachable livelock in
`go7007_start_encoder()`. Risk of regression is negligible.

### What the commit solves for stable users
On MPEG-4 stream start the GO7007 firmware generator packes headers with
`CODE_ADD()`. Padding can request a 0-bit add after a flush (`name.b ==
32`), which is an illegal shift. `vti_bitlen()` always does `1 << 31`
and, if userspace sets a very large frame interval, can spin forever
with `hw_lock` held so `VIDIOC_STREAMON` never returns. The patch skips
zero-length adds, uses `fls()`, and builds the mask with `GENMASK()`.

### Risk vs benefit
Benefit is defined behavior and no encoder-start hang for remaining
GO7007/Sensoray users. Risk is a few lines in a dormant driver with no
API change.

### Concerns
Obscure hardware and no field report. That lowers urgency, not
correctness. No backport rework needed.

---

Verification:
- [Phase 1] Parsed subject/body/tags: only author + Hans Verkuil SOBs;
  no Fixes/Reported-by/Link/Cc-stable
- [Phase 2] `git show --numstat 41f82777e5477`: 15/13, one file; read
  current and `41f82777e5477^` `CODE_ADD` / `vti_bitlen` / mask
- [Phase 2] Confirmed length-0 path: `i = 8 - (CODE_LENGTH % 8)` then
  `CODE_ADD(..., i-1)` when `i==1`
- [Phase 2] Confirmed `fls` equivalence for 1, 2, 30000, 0x80000000;
  `fls(0)?:1` vs old wrap
- [Phase 3] `git blame` / `git log -1 866b8695d67e83`: introduced 2008
  with staging driver
- [Phase 3] `git merge-base --is-ancestor 41f82777e5477 HEAD` → yes
  (already in this 7.3-rc4 snapshot)
- [Phase 3] `git log --oneline --author="Yousef Alhouseen"`: standalone
  vs nearby s2250 patch
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; To Hans/Mauro/linux-media;
  mbox has no replies
- [Phase 4] lore.kernel.org 403; lkml.iu.edu shows the same v1 patch
  text
- [Phase 4] WebSearch stable archive: no hit for this subject
- [Phase 5] grep callers: `vti_bitlen` → MPEG-4 headers → `do_special` →
  `go7007_construct_fw_image` → `go7007_start_encoder` →
  `go7007_start_streaming`
- [Phase 5] Read `vidioc_s_parm`: `fps_scale` unbounded when `n > d`
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] Current file already has the fix; parent file has the old
  loop/mask
- [Phase 7] Kconfig `VIDEO_GO7007`; USB IDs include Sensoray 2250
- [Phase 8] Failure: UB on padding; hang if `max_time_incr==0` under
  `hw_lock`
- UNVERIFIED: whether UBSAN actually reported this in a boot/log;
  stable-list archives beyond web search (403)

**YES**

 drivers/media/usb/go7007/go7007-fw.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-fw.c b/drivers/media/usb/go7007/go7007-fw.c
index 86ce593e0c546..8cf959c20e30c 100644
--- a/drivers/media/usb/go7007/go7007-fw.c
+++ b/drivers/media/usb/go7007/go7007-fw.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/bitops.h>
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/device.h>
@@ -58,14 +59,16 @@ struct code_gen {
 #define CODE_GEN(name, dest) struct code_gen name = { dest, 0, 32, 0 }
 
 #define CODE_ADD(name, val, length) do { \
-	name.b -= (length); \
-	name.a |= (val) << name.b; \
-	while (name.b <= 24) { \
-		*name.p = name.a >> 24; \
-		++name.p; \
-		name.a <<= 8; \
-		name.b += 8; \
-		name.len += 8; \
+	if (length) { \
+		name.b -= (length); \
+		name.a |= (val) << name.b; \
+		while (name.b <= 24) { \
+			*name.p = name.a >> 24; \
+			++name.p; \
+			name.a <<= 8; \
+			name.b += 8; \
+			name.len += 8; \
+		} \
 	} \
 } while (0)
 
@@ -707,11 +710,10 @@ static int gen_mpeg1hdr_to_package(struct go7007 *go,
 
 static int vti_bitlen(struct go7007 *go)
 {
-	unsigned int i, max_time_incr = go->sensor_framerate / go->fps_scale;
+	unsigned int max_time_incr = go->sensor_framerate / go->fps_scale;
+	int bitlen = fls(max_time_incr);
 
-	for (i = 31; (max_time_incr & ((1 << i) - 1)) == max_time_incr; --i)
-		;
-	return i + 1;
+	return bitlen ?: 1;
 }
 
 static int mpeg4_frame_header(struct go7007 *go, unsigned char *buf,
@@ -1209,7 +1211,7 @@ static int seqhead_to_package(struct go7007 *go, __le16 *code, int space,
 		0xbf08,		fps,
 		0xbf09,		0,
 		0xbff2,		vop_time_increment_bitlength,
-		0xbff3,		(1 << vop_time_increment_bitlength) - 1,
+		0xbff3,		GENMASK(vop_time_increment_bitlength - 1, 0),
 		0xbfe6,		0,
 		0xbfe7,		(fps / 1000) << 8,
 		0,		0,
-- 
2.53.0

