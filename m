Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B3F573F13;
	Mon, 19 Oct 2026 13:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418310; cv=none; b=UGhIbZ6ZAUYgH4tiEd05mqVNV7O7OO9pDllDwWB6DIfXJXMkMSrtnJt6lpH7bflPdrFrGz1jcMdO0ZRjJ7G/FhXUxJvRiSK6kLDoCQjn8gyul/4N8526lFavfC1yuavXb2fFXmReAvrEX1dFApOqB5X90+ENaoxpp36jD47c+GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418310; c=relaxed/simple;
	bh=EcfB4S8cHgRRI8/EopipWAv8/CWTkWaa/D0AWHlrIXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpVtjq4jIq/X47V1hA2P+8H18c6y6gcHWODd9gZdPeIdBdodiVFZM4405cIxsbBPfS00JsBA2rlZD8312rdLj17kP4GhmSEOM27eboX+yIe0Pw3M+FdUWzNYo0yFq411yi6gINeFtjx+ob9xRY/xpa6IkQgYjduHGbkCXhS8ZE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgQe8SaG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgQe8SaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B6C1F000CB;
	Mon, 19 Oct 2026 13:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418308;
	bh=qHLwWFSJs0y+IsONzeddCss/34khrT/kFDkOgZsY3U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgQe8SaGPuvYfCfARrBJsombLTeY6WmZEyfq1xTzQuk/PPQfOGdVTiKy5BqGw8bOQ
	 Ernq8DRDEDDQ33XH+0iez4lv+pabqrEX1rdKiMAPfeY9HOLqaC0SOgbuQXeuyCZKoF
	 hq6DTw+SFQxoPHMOYSAcxQkbrkYNpiaQkQMN5ntACxChmAQzmYbQu7iL3wh4dsW3zZ
	 LEbOL9v4Pf0qnqM2SB08z1z0c2AK4bLILzOzeW2cUDVc6t8kvF+VHrxVnrMpcXKHUv
	 N+kpuBuW0wkiT/EtfuF28SKwioUYC+wcyOvM/LXH6qbqwGWYYZceujx0pWlM8Duvy+
	 tkLbiX1JYQYsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	bernie@plugable.com,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] fbdev: udlfb: validate vendor descriptor items
Date: Mon, 19 Oct 2026 09:47:26 -0400
Message-ID: <20261019135441.1420968-155-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3cc2fad376ac7360b4518277aa923752624db59c ]

dlfb_parse_vendor_descriptor() walks key-length-value items inside the
DisplayLink vendor descriptor.

Require each item to contain its key, length and declared value bytes
before reading item-specific fields such as max_area.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a USB descriptor bounds-check for `udlfb`. The buggy parser is
in this 6.12.111 tree, the patch applies cleanly, and the failure mode
is an out-of-bounds read from device-controlled data.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[fbdev/udlfb] [validate] [require each vendor-descriptor TLV
item to contain key, length, and declared value bytes before reading
fields such as max_area]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Pengpeng Hou \<pengpeng@iscas.ac.cn\> (author)
- Signed-off-by: Helge Deller \<deller@gmx.de\> (fbdev maintainer;
  applied)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable tags (absence is expected for this review)
- Ignore any pipeline “Upstream commit …” / Sasha Levin SOB markers;
  they are not evidence of selection

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `dlfb_parse_vendor_descriptor()` walks DisplayLink vendor-
  descriptor key-length-value items without checking that key, length,
  and value bytes are still inside the descriptor.
- Symptom/failure mode: out-of-bounds read of `max_area` (and of the
  next key/length) when the remaining buffer is shorter than the
  declared item.
- Version information: none in the message. The parser has been in this
  file for many years (see Phase 3).
- Root cause: missing remaining-length checks before reading item
  fields.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. “Validate” is an explicit bounds-check fix for a
USB descriptor parser. It is not cleanup, a new feature, or refactor-
only.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/video/fbdev/udlfb.c` — **+16 / −6** (22-line change)
- Function: `dlfb_parse_vendor_descriptor()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Current code in this tree (`drivers/video/fbdev/udlfb.c` around the
parse loop):

```1588:1612:drivers/video/fbdev/udlfb.c
                while (desc < desc_end) {
                        u8 length;
                        u16 key;

                        key = *desc++;
                        key |= (u16)*desc++ << 8;
                        length = *desc++;

                        switch (key) {
                        case 0x0200: { /* max_area */
                                u32 max_area = *desc++;
                                max_area |= (u32)*desc++ << 8;
                                max_area |= (u32)*desc++ << 16;
                                max_area |= (u32)*desc++ << 24;
                                ...
                        }
                        ...
                        desc += length;
                }
```

Record, per hunk:
- Before: if `desc` is within `desc_end`, it always consumes 3 bytes
  (key+length) and, for key `0x0200`, 4 more value bytes, with no
  remaining-length test. Then it still does `desc += length`.
- After: require at least 3 bytes left; parse key with
  `get_unaligned_le16()`; reject if `length` exceeds remaining bytes;
  for `max_area`, require `length >= 4` and read via
  `get_unaligned_le32(value)` without advancing past the value twice;
  then `desc += length`.
- Path: USB probe / firmware descriptor parse (initialization), not a
  hot path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: **memory safety / out-of-bounds read** of USB descriptor
  data (also a logic correction of the 2018 max_area pointer walk).
- Mechanism: a truncated or hostile descriptor can make `desc_end -
  desc` smaller than 3 (key+length) or smaller than `length` /
  `sizeof(u32)`. The old loop still reads `key`, `length`, and
  `max_area`. The fix stops at `unrecognized` instead of reading past
  the buffer. `unrecognized` already exists and still returns true
  (driver still loads with the default SKU limit).

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Quality: obviously correct TLV remaining-length checks;
  `get_unaligned_le16/le32` matches USB little-endian layout and the
  pre-2018 `le16_to_cpu`/`le32_to_cpu` reads. `linux/unaligned.h` is
  already included.
- Regression risk: low. Failures take the existing `unrecognized` path,
  which logs and still succeeds. The kernel is built with `-funsigned-
  char`, so switching from byte-or-shifts to `get_unaligned_le*` is not
  a signed-char behavior change. Restoring “read value, then `desc +=
  length`” matches the original 2010 parser and the DRM `udl` parser in
  this tree.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Loop introduced in `18dffdf8913ab9` (“staging: udlfb: enhance EDID and
  mode handling support”, 2010-09-05). Original max_area read did
  **not** advance `desc` before `desc += length`.
- Current byte-by-byte form introduced by `115e77597efcc9` (“video:
  udlfb: Fix unaligned access”, 2018-03-12), which is an ancestor of
  this HEAD. That commit replaced `le16_to_cpu`/`le32_to_cpu` with
  `*desc++` and accidentally advanced `desc` through the 4-byte value
  **and** still did `desc += length`.
- Bug class is old (2010 missing bounds; 2018 worse walk). Present in
  6.12.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Not applicable beyond that. The intended target
is the long-standing parser, last reshaped by `115e77597efcc9`, which
**is** in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent udlfb commits in this tree are independent (`add
vm_ops…`, `avoid divide-by-zero…`). This is a standalone v1 patch, not
“X/Y”. No prerequisite refactor is required.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou has no other udlfb commits in this tree. Helge
Deller (fbdev maintainer) applied it. Related DRM work: `df6dc12e5e6dd`
(“drm/udl: Validate length in vendor-descriptor parser”) on
`origin/master` is the sibling hardening of the same protocol; it is
**not** an ancestor of this HEAD.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `get_unaligned_le16`/`get_unaligned_le32`
from `include/linux/unaligned.h` (already included as
`<linux/unaligned.h>`). `git apply --check` of `3cc2fad376ac7` on this
tree succeeded. Standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Commit on `origin/master`: `3cc2fad376ac7360b4518277aa923752624db59c`
  (not in this HEAD).
- `b4 dig -c 3cc2fad376ac7`:
  https://patch.msgid.link/20260706093038.80131-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only** (no v2/v3). Applied version is that v1.
- Maintainer Helge Deller first asked whether LE reads were valid, then
  retracted: “Your patch is of course correct! The patch is now added to
  fbdev git tree.”
- No NAK. No reviewer request for Cc: stable (not a negative).
- An automated Sashiko note flagged a **pre-existing** `%11ph` 11-byte
  dump when `total_len` can be 6; that is **not** introduced or fixed
  here.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Pengpeng Hou; Bernie Thompson; Helge Deller;
linux-fbdev; dri-devel; linux-kernel. Subsystem maintainer was on Cc and
applied the patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla tag. Same bug class as DRM udl: Thomas
Zimmermann’s `drm/udl` series (lore, April 2025) states the current
parser “might read more bytes than available” / “out-of-bounds reads of
the allocated buffer.” That is independent confirmation of the protocol
bug, not a userspace crash report for udlfb.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone single patch. No later origin/master follow-up on
`udlfb.c` after `3cc2fad376ac7`. DRM equivalent is a larger 2025
refactor (`udl_parse_key_value_pair`); not a dependency of this fbdev
patch.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: WebFetch of lore.kernel.org/stable returned 403. **UNVERIFIED**
whether stable@ discussed this subject. No in-tree evidence of a prior
rejection. The commit is simply not in this 6.12 checkout.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `dlfb_parse_vendor_descriptor()` only.

**Step 5.2: TRACE CALLERS**
Record: Sole caller is `dlfb_usb_probe()`
(`drivers/video/fbdev/udlfb.c`). Bound via `.probe = dlfb_usb_probe` for
USB VID `0x17e9` + vendor-specific interface. Context: process-context
USB probe, not IRQ.

**Step 5.3: TRACE CALLEES**
Record: `usb_get_descriptor()`, `usb_get_extra_descriptor()`,
`dev_info`/`dev_warn`/`dev_err`, `kfree`. New: `get_unaligned_le16`,
`get_unaligned_le32`. No new locks or allocations.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Plug in / enumerate a DisplayLink USB device (or a device
spoofing VID `0x17e9`) → `dlfb_usb_probe` → parser. Reachable without
extra syscalls beyond USB enumeration. Unprivileged userspace cannot
call it directly, but a physical USB device can.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `drivers/gpu/drm/udl/udl_main.c` `udl_parse_vendor_descriptor()`
in this tree still has the unbounded walk (`desc += length` with no
remaining-length check). Same protocol bug. That does not block this
udlfb-only fix.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Tree is **6.12.111** (`git describe HEAD` →
`p-6.12-3-gc504cf0baa3d8`; `VERSION/PATCHLEVEL/SUBLEVEL` 6.12.111).
Parser at `dlfb_parse_vendor_descriptor()` lines 1588–1612. `git merge-
base --is-ancestor 3cc2fad376ac7 HEAD` → **not in this tree**. Bug
present since 2010 / 2018, well before 6.12.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** `git show 3cc2fad376ac7 --
drivers/video/fbdev/udlfb.c | git apply --check` exit 0. Surrounding
function matches the patch context. `<linux/unaligned.h>` already
present.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `git log --grep='validate vendor descriptor' --
drivers/video/fbdev/udlfb.c` empty. DRM `Validate length in vendor-
descriptor parser` is not in this HEAD. No alternate udlfb bounds fix
present.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **fbdev USB framebuffer driver** (`CONFIG_FB_UDL`,
`drivers/video/fbdev/udlfb.c`). Criticality: **PERIPHERAL / driver-
specific**, but USB descriptor parsing is a standard untrusted-input
path. DisplayLink USB 2.0 adapters are real hardware; the Kconfig help
still describes this as the fbdev driver for those devices.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature. Parser largely unchanged since 2018 aside from later
mmap/div-by-zero fixes. Low churn favors a small bounds-check backport.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Users with `CONFIG_FB_UDL` and a DisplayLink USB 2.0 device (or
a spoofed `0x17e9` device). Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Honest device with a well-formed descriptor: loop stays in-bounds
  (typical path).
- Truncated/malformed descriptor: OOB read of key/length/`max_area`.
- Malicious USB device matching the VID/class: can set `bLength` up to
  `MAX_VENDOR_DESCRIPTOR_SIZE` (256) so `desc_end` sits at the `kzalloc`
  edge, then emit a TLV `length` that walks off the buffer.
- Extra-descriptor fallback: `__usb_get_extra_descriptor()` bounds
  `bLength` to the extra blob, but item `length` can still push reads
  past that descriptor.
- Trigger is probe-time, not a timing race. Unprivileged software cannot
  hit it without USB device control.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **OOB read** of kernel memory during USB probe. Can KASAN-splat
or oops if the read crosses an allocation/page boundary (`total_len ==
256` is the sharp heap case). Severity: **HIGH** (crash / infoleak from
untrusted USB descriptor). Not a confirmed write, panic-on-boot for good
hardware, or filesystem corruption.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: stops USB-descriptor OOB in a driver that is in this LTS
  tree; fail-open `unrecognized` path already exists.
- Risk: very low (16 insertions, existing helpers, existing error label,
  clean apply).
- Ratio: **favorable**.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB read of device-controlled USB descriptor data
- Same class already called out for DRM udl (“out-of-bounds reads of the
  allocated buffer”)
- Small, surgical, obviously correct remaining-length checks
- Code and bug exist in this 6.12.111 tree; fix is not in it
- Applies cleanly; `get_unaligned_*` already available
- Maintainer applied v1 after confirming LE reads are correct
- `unrecognized` still allows probe (low chance of breaking real
  adapters)
- No new API/feature

AGAINST:
- Driver-specific (DisplayLink fbdev), not core MM/VFS
- No syzbot/CVE/user oops in the commit message
- Honest devices with valid descriptors do not hit the bug
- Pre-existing `%11ph` dump issue is unfixed (not a reason to reject
  this)

UNRESOLVED:
- lore.kernel.org/stable search HTTP 403
- Exact TLV `length` byte on every DisplayLink SKU was not captured from
  a live device in this session; parser semantics match 2010 + current
  DRM udl, which is enough

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — bounds checks are local and
   reviewable; maintainer applied after LE confirmation.
2. Fixes a real bug that affects users? **PASS** — OOB read of USB
   descriptor memory; probe path for this driver.
3. Important issue? **PASS** — HIGH: crash/infoleak from untrusted USB
   descriptor (not a style cleanup).
4. Small and contained? **PASS** — one function, +16/−6.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check` clean on
   6.12.111

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. It qualifies as a
normal small security/robustness fix.

**Step 9.4: DECISION**
Backport to **this** tree. The buggy parser is here; the fix is small
and applies; the impact is a USB OOB read.

Verification:
- [Phase 1] Parsed tags: author + Helge Deller SOB only; no
  Fixes/syzbot/Cc stable
- [Phase 2] Diff: +16/−6 in `dlfb_parse_vendor_descriptor()`; remaining-
  length checks + `get_unaligned_le16/le32`
- [Phase 2] Confirmed current 6.12 code still does unbounded `*desc++`
  key/length/max_area reads
- [Phase 3] Blame: loop from `18dffdf8913ab9` (2010); byte-walk from
  `115e77597efcc9` (2018), both ancestors of HEAD
- [Phase 3] `git merge-base --is-ancestor 3cc2fad376ac7 HEAD` → not
  present
- [Phase 3] `git apply --check` of `3cc2fad376ac7` → clean
- [Phase 4] `b4 dig -c 3cc2fad376ac7` → lore msgid
  `20260706093038.80131-1-pengpeng@iscas.ac.cn`; v1 only
- [Phase 4] Thread: Helge questioned LE, then “patch is of course
  correct” and applied; no NAK
- [Phase 4] Sibling DRM commit `df6dc12e5e6dd` documents the same OOB;
  not in this HEAD
- [Phase 5] Only caller: `dlfb_usb_probe` / VID `0x17e9`
- [Phase 5] `include/linux/unaligned.h` provides
  `get_unaligned_le16/le32`; already included
- [Phase 6] `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` = 6.12.111
- [Phase 8] Failure mode: USB descriptor OOB read at probe; severity
  HIGH
- [Phase 8] Makefile has `-funsigned-char` (no signed-char regression
  from byte reads)
- UNVERIFIED: stable@ lore discussion (HTTP 403)

**YES**

 drivers/video/fbdev/udlfb.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index 70ff38f35096a..1c82ee6984c8d 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1586,19 +1586,29 @@ static int dlfb_parse_vendor_descriptor(struct dlfb_data *dlfb,
 		desc += 5; /* the fixed header we've already parsed */
 
 		while (desc < desc_end) {
+			char *value;
 			u8 length;
 			u16 key;
 
-			key = *desc++;
-			key |= (u16)*desc++ << 8;
+			if (desc_end - desc < sizeof(key) + sizeof(length))
+				goto unrecognized;
+
+			key = get_unaligned_le16(desc);
+			desc += sizeof(key);
 			length = *desc++;
 
+			if (length > desc_end - desc)
+				goto unrecognized;
+
+			value = desc;
 			switch (key) {
 			case 0x0200: { /* max_area */
-				u32 max_area = *desc++;
-				max_area |= (u32)*desc++ << 8;
-				max_area |= (u32)*desc++ << 16;
-				max_area |= (u32)*desc++ << 24;
+				u32 max_area;
+
+				if (length < sizeof(max_area))
+					goto unrecognized;
+
+				max_area = get_unaligned_le32(value);
 				dev_warn(&intf->dev,
 					 "DL chip limited to %d pixel modes\n",
 					 max_area);
-- 
2.53.0

