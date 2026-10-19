Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594C66070A5;
	Mon, 19 Oct 2026 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418604; cv=none; b=K3VKgri3CXkM0s/bvU4vzjOlLaFIzEMYH7qvpcRFA1veDDkrOiO9D40zOPifLCbal27GNVkVnudARbwtxXYmu4lJraMAkKbPkMoD5lbATdbLqsxlk8gRKGhi+Fs+UePu8o+MduC2ZaWi3+21gzqkSl1o7Usn2edzkOJUsLBC5D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418604; c=relaxed/simple;
	bh=3d+R2fRa3OW+Zkp8CyMsE/7ThcYTa7R3wBuSDYkUiXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fgRC1iORdTkuvE1WC580CGXn2VeULvAjcj5Vt+CdypJ/MFdcwSFsG6pbDP8u2enzjP/hk23noniSi0TyqMmRRUItJy5lvNHymFpstY0lFGJXhtAnx4261IHXk15TolkzGH4YfFWGaJ4r4Q6FMNAmjVONp+awxbslnoafnbrQjGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5MUVN7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5MUVN7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6635A1F000C5;
	Mon, 19 Oct 2026 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418601;
	bh=bP+J9GRub/WGolF9AQfnB3bAynooGTPJfh9Ic4+8TPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5MUVN7+VgQnMmfOQbMuzXij6IEvxPcvcrkWvoRmZy6trmg0Jrkxc+KlZtMyLWPuD
	 A6wU2rYiFNo3MEbv8SwjOAiAbZ4a+G6CAsRtm/x/i6IDO+hN22WNiIC9RVx99gU2Gg
	 7dHvkOWJTkbEwHqsH5asl3LZ+j/7wX8X1Btcrpki7jV+2IkI9HMtIYLY+5rS8dIgur
	 E5VWVe8aGKu6zauUx4VZlVOgFFy2wgMzYYodCQUuJ4KxUWtdHa5mjY8jVyWfqrXTPP
	 053RSqDPaO2YZyqkRB2B6TWDiTBQBS3gu7iUMWV9meO1m2HbGJHdmgZZN9TEkHU+rN
	 gAa3AvD3IhTVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	johan@kernel.org,
	greybus-dev@lists.linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] greybus: manifest: validate string descriptor header
Date: Mon, 19 Oct 2026 09:50:55 -0400
Message-ID: <20261019135441.1420968-364-sashal@kernel.org>
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

[ Upstream commit 18b6510f642dbcb856c3af8be974d1600f3ba2d3 ]

identify_descriptor() computes a string descriptor size from
desc->string.length.

Require the descriptor to contain the fixed string descriptor header
before reading the variable string length. The existing descriptor-size
check then reports the short descriptor.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706091935.78020-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (mainline 7.3.0-rc4). Greybus manifest
parsing exists here, the two-line size check is already the current
code, and the same parser has been in the kernel since v4.9. The rest of
this write-up is whether that fix is stable-worthy for this lineage.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[greybus/manifest] [validate] [require the fixed string-
descriptor header before reading `desc->string.length`]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` — none (expected for this review path)
- `Reported-by:` — none
- `Tested-by:` — none
- `Reviewed-by:` — none
- `Acked-by:` — none
- `Link:`
  https://patch.msgid.link/20260706091935.78020-1-pengpeng@iscas.ac.cn
- `Cc: stable@vger.kernel.org` — none (expected)
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
  (greybus maintainer; ignore any Sasha Levin SOB — none present)
Notable pattern: no user/syzbot report; maintainer still took the patch.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `identify_descriptor()` uses `desc->string.length` to compute
  expected size before the descriptor is known to contain the two-byte
  string header (`length` + `id`).
- **Symptom:** out-of-bounds / out-of-object read of `length` on a
  truncated `GREYBUS_TYPE_STRING` descriptor.
- **Failure mode:** malformed hardware manifest; heap OOB when remaining
  buffer is only the 4-byte generic header.
- **Version info:** none in the message.
- **Root cause (author):** read variable length before the fixed string
  header is present; the existing `desc_size < expected_size` path then
  reports the short descriptor.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not disguised.** Subject/body describe a bounds check. It *is*
a real memory-safety fix, not cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/greybus/manifest.c` — **+2 / -0**
- Function: `identify_descriptor()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before, `GREYBUS_TYPE_STRING` did `expected_size +=
sizeof(struct greybus_descriptor_string)` then immediately
`expected_size += desc->string.length`. After, if `desc_size <
expected_size` (header + 2-byte string header), it `break`s into the
existing “descriptor too small” `-EINVAL` path and never reads `length`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Memory safety / OOB read]**. `greybus_descriptor_header` is 4
bytes; `greybus_descriptor_string` is 2 bytes plus a flexible array. A
descriptor with `size==4` and `type==STRING` is accepted by `desc_size >
size` (4 is not greater than remaining size) but `desc->string.length`
sits at offset 4. Manifest memory is `kmalloc(size)` in
`gb_interface_enable()`, so when remaining length is 4 this is a
**1-byte heap OOB read**.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct and minimal.** Valid string descriptors
already have `desc_size >= 6 + length` (then 4-byte aligned); the new
check cannot fire on them. `break` (not `return`) reuses the existing
error log. Regression risk is **very low**.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: The `length` access comes from **b09c94a1b71c82** (“greybus:
start improving manifest parsing”, 2014-10-01, **v4.9-rc1**).
Padding/`ALIGN` later: fa2fbf16f6aaaa (Viresh Kumar, 2015). The two new
lines are this commit (**18b6510f642dbc**, Pengpeng Hou, 2026-07-06).
Long-lived bug, not new code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No `Fixes:` tag.** The introducing commit is b09c94a1b71c82,
in this tree (`git merge-base --is-ancestor 18b6510f642db HEAD`
succeeded). No intermediate fix of this specific hole.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `manifest.c` history is alloc-style churn plus the 2019
staging move (`8465def499c70`, **v5.4-rc1**). Older related work:
fa2fbf16f6aaa (padding), cbd0fd7b9b6fd (length field type).
**Standalone**, not patch N/M.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is not a Greybus maintainer. Other Greybus work:
`1214bf28965ce` and `cbc96a916b1a3` (BeaglePlay RX bounds). Pattern of
bounds checks, not a prerequisite series for this hunk.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **No dependencies.** Uses existing `desc_size`, `expected_size`,
and the existing too-small check. Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 18b6510f642db` →
  https://patch.msgid.link/20260706091935.78020-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only** (2026-07-06)
- Thread (mbox): author patch + Greg KH: “Nice, but how was this tested?
  How was it found?”
- **No author reply found** on LKML, greybus-dev (Linaro), or the saved
  mbox.
- Greg still applied it (commit date 2026-07-17).
- No NAK. No reviewer `Cc: stable`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc Johan Hovold, Alex Elder, Greg Kroah-
Hartman, greybus-dev, linux-kernel — the GREYBUS SUBSYSTEM maintainers.
Greg applied it; no Reviewed-by from Johan/Alex.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No bugzilla/syzbot/CVE.** Discovery method unanswered (likely
static review). Severity is from code, not a user report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: **Standalone v1.** Other Hou Greybus patches are BeaglePlay RX
bounds, not needed here.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable/ returned **403**. No stable-thread hit
via web search. **UNVERIFIED** whether stable@ discussed this.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `identify_descriptor()` (modified). Callers/helpers:
`gb_manifest_parse()`, `gb_interface_enable()`,
`gb_control_get_manifest_*()`.

**Step 5.2: TRACE CALLERS**
Record: `identify_descriptor` is static; only called from
`gb_manifest_parse()` while walking descriptors. `gb_manifest_parse` is
called from `gb_interface_enable()` (`drivers/greybus/interface.c`).
That is used from `gb_module_register_interface()` and other
enable/resume paths in `interface.c`. **Device enable**, not a syscall.

**Step 5.3: TRACE CALLEES**
Record: `le16_to_cpu`, `dev_err`/`dev_warn`, `kzalloc_obj`,
`list_add_tail`. No new locks/allocs in the patch.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Greybus module/interface enable → control `GET_MANIFEST_SIZE` /
`GET_MANIFEST` over the Greybus control CPort → `kmalloc(size)` →
`gb_manifest_parse`. Trigger is **attached Greybus hardware**
(BeaglePlay SVC, ES2 USB host, etc.), not unprivileged syscalls.
Manifest bytes are **device-supplied**.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other descriptor types only add a fixed `sizeof()` and do not
read extra fields before the later size check. This hole is **string-
specific**. `gb_string_get()` copies `desc_string->length` after
identify; that path is only reached if identify accepted the descriptor.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `drivers/greybus/manifest.c` `identify_descriptor()`;
structs in `include/linux/greybus/greybus_manifest.h`. Bug since
**v4.9**; core moved out of staging in **v5.4**. This checkout already
contains **18b6510f642db**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** — two lines in an unchanged `switch` arm.
Surrounding code matches the pre-image (aside from later `kzalloc_obj`).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier equivalent check. No later `manifest.c` commits after
this one.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **Greybus core parser** (`drivers/greybus/`). Criticality:
**PERIPHERAL/IMPORTANT** — not mm/VFS, but in-tree (not staging) core
used by BeaglePlay and ES2. Parser of untrusted device blobs is the same
class as USB descriptor parsing.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature; `manifest.c` is low-churn since the 2019 move. Bug is
old, not a new-API refactor.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Config-specific + driver-specific** (`CONFIG_GREYBUS`, plus a
module that supplies a manifest). Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Malformed string descriptor during interface enable. Needs
Greybus hardware (or an equivalent host). **Not** a normal unprivileged
syscall. Timing-independent. Commonness: rare (buggy/malicious module).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **1-byte (typical) slab OOB read.** After the bad read,
`expected_size` is still `>= 8` when `desc_size < 6`, so the existing
check still returns `-EINVAL` — the OOB does not accept the descriptor.
Production effect is usually KASAN/syz-style detection, not a guaranteed
panic. Severity: **HIGH** as memory safety on untrusted device data;
practical crash risk **MEDIUM**.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** stops a real OOB in a device-blob parser; tiny; long-
  present bug.
- **Risk:** very low (2 lines, error path only, valid manifests
  unchanged).
- **Ratio:** **favorable**.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB read of `desc->string.length` before the 2-byte string header
  is known to be in-bounds.
- Manifest is kmalloc’d to the device-reported size; last truncated
  STRING descriptor with `desc_size == remaining == 4` is a heap OOB.
- Two-line, obviously correct check; valid descriptors unaffected.
- Bug in this tree’s lineage since ~2014 (v4.9).
- Maintainer Greg KH applied v1 after listing maintainers on CC.
- No new API/feature; applies cleanly; no prerequisites.

AGAINST:
- No `Reported-by` / syzbot / crash log.
- Author did not answer Greg’s “how tested / how found”.
- Greybus is niche; trigger needs hardware.
- OOB value is not used to accept the descriptor (still `-EINVAL`).

UNRESOLVED:
- lore.kernel.org HTTP 403; stable@ search not completed on lore.
- No public answer on how the bug was found.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** on correctness by inspection;
   testing story is thin, but the change is too small to need a complex
   repro.
2. Fixes a real bug that affects users? **PASS** — OOB on device-
   supplied manifests for `CONFIG_GREYBUS` users.
3. Important issue? **PASS** — memory-safety / OOB on untrusted hardware
   data (same bar as USB descriptor checks), not a style nit.
4. Small and contained? **PASS** — +2 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — file and function exist;
   patch is already the current code here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs exception. Ordinary small bugfix.

**Step 9.4: MAKE YOUR DECISION**
This is a classic stable backport: a long-standing bounds hole in a
parser of device-provided descriptors, fixed in two lines with no
behavioral change for valid input. Niche hardware lowers blast radius
but does not make an OOB read unworthy of stable; USB-style descriptor
checks are backported for the same reason. Greg’s unanswered testing
question is a quality nit, not a reason to withhold a correct 2-line
guard.

### What the commit solves for stable users
A Greybus interface enable path copies a hardware manifest into a
`kmalloc` buffer and walks descriptors. For `GREYBUS_TYPE_STRING` it
used to read `desc->string.length` as soon as the generic 4-byte header
was present. If the descriptor claimed only those 4 bytes, that read is
past the object (and past the allocation when this is the last remaining
bytes). The fix refuses that descriptor via the existing “too small”
path.

### Stable rules / risk vs benefit
Meets the stable bar: real bug, important (OOB), tiny, no features,
applies here. Benefit is closing a memory-safety hole; risk is
negligible.

### Concerns
No in-the-wild report; discovery method unknown. No extra backport glue
needed on this tree.

Verification:
- [Phase 1] Parsed tags: author SOB, Greg KH SOB, Link to msgid; no
  Fixes/Reported-by/stable Cc
- [Phase 2] Diff: +2 in `identify_descriptor()` STRING case; `break`
  into existing `desc_size < expected_size`
- [Phase 2] Struct sizes from `greybus_manifest.h`: header 4, string
  fixed 2; `length` at offset 4
- [Phase 2] Pre-image via `git show
  18b6510f642db^:drivers/greybus/manifest.c`: length read with no
  header-size gate
- [Phase 3] `git describe HEAD` / Makefile: **v7.3-rc4**, VERSION
  7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor 18b6510f642db HEAD`: yes
- [Phase 3] blame: length use from b09c94a1b71c82 (v4.9-rc1); new lines
  from 18b6510f642dbc
- [Phase 3] No Fixes tag; introducing commit in this history
- [Phase 3] File log: standalone; later history has no further
  manifest.c fixes
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; maintainers CC’d; Greg asked
  how found; no NAK; applied 2026-07-17
- [Phase 4] lore.kernel.org WebFetch: **403**; used mbox +
  openwall/Linaro/lkml.iu.edu
- [Phase 4] No author reply to Greg found
- [Phase 5] Callers: `gb_manifest_parse` ← `gb_interface_enable` ←
  module/interface enable; manifest from
  `gb_control_get_manifest_operation` into `kmalloc(size)`
- [Phase 5] semcode: **unavailable**; used grep/read
- [Phase 6] Buggy parser present in this tree; apply would be clean
- [Phase 7] GREYBUS SUBSYSTEM maintainers: Hovold, Elder, Greg KH
- [Phase 8] Failure: heap OOB read, severity HIGH memory-safety / MEDIUM
  practical crash
- UNVERIFIED: stable@ lore discussion (403); exact discovery method
  (unanswered)

**YES**

 drivers/greybus/manifest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/greybus/manifest.c b/drivers/greybus/manifest.c
index dd7040697bde9..469da3f39afb4 100644
--- a/drivers/greybus/manifest.c
+++ b/drivers/greybus/manifest.c
@@ -122,6 +122,8 @@ static int identify_descriptor(struct gb_interface *intf,
 	switch (desc_header->type) {
 	case GREYBUS_TYPE_STRING:
 		expected_size += sizeof(struct greybus_descriptor_string);
+		if (desc_size < expected_size)
+			break;
 		expected_size += desc->string.length;
 
 		/* String descriptors are padded to 4 byte boundaries */
-- 
2.53.0

