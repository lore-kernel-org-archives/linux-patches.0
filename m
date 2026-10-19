Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA63565E40;
	Mon, 19 Oct 2026 13:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418258; cv=none; b=Y3kmtWowbKHgp0oGo7aZOtiVMntj+RSMuR2uhjxp7+TW7gBj1jgEzQYehy1d71rX3fsgmq5dDKaDP2dY05tVnDwznuaQRVUoKgohrAxzn8XJpc7Rukl1xw2F0lPXfW9vcbx5HBHZKTOVpaOpIyb5fdbbKY1bZmm1RIyS5SoAr2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418258; c=relaxed/simple;
	bh=M5XM9HaoQiGM9BZJH+jPgXy2su8hIgg6upvggy9PP5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQzUvCYw1cZeH8foTYqylV2fA5/twwelOFDL/q15OPe3N7cOVKFO+oqUWGBqqr7nW0scVKATRl0COBwZlUJW+e/IV8hKnU5Cl5npQQzzi3t8+oc93M9poWdIijH0HH8qBPOiUUzLipI6c9EpeQBAJa7oIArrJESMvwOswtIYrUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDoNx92P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDoNx92P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69FB1F000C8;
	Mon, 19 Oct 2026 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418255;
	bh=aMcfynlMOHxkyjhDuUZ8R9aOY86TSgCExMN0NKpOhlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDoNx92PDxyJlMtJaAEtWyx0DQcNk8BOPisLn1zZ91DLR9j8d4hvW77xqFRnxHdur
	 Van+w9MJF8QEhTz/4IK/K32IJNUeh12/TeHVvzG34Y1wJt5Cq1KdnIwG9mPXK3E5Fv
	 sHyb2iWG4+0l/CySFVwgzApXtcGW8XLPlKwBD1Moj9T43aPnDRBt2f0cJXQxqlwvD4
	 kZ+IcJ+2Huxu00zFDjdG/p8RdGuCagZY4Y9UN2MUkKe86mzxoOPDmd9xzEENFwdiXT
	 AygALZyLbMyRGNzqHoW2r8p07N04uzZdp5GVI2EcLtvnLQqgKrhj4qX+GfwkgRHtm6
	 oCBvaY5dhL1Fg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	xinpeng.sun@intel.com,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] HID: Intel-thc-hid: Intel-quicki2c: Fix buffer overflow
Date: Mon, 19 Oct 2026 09:46:54 -0400
Message-ID: <20261019135441.1420968-123-sashal@kernel.org>
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

From: Even Xu <even.xu@intel.com>

[ Upstream commit 5e5c3b9db1c5910d6a9175c97b76a95566e4dc32 ]

The input and output buffers are used to store complete HID-over-I2C
packets, including their protocol headers. However, their sizes are
currently calculated from the payload length only.

Allocate enough space for both the payload and the packet header to
prevent a buffer overflow when the payload reaches its maximum size.

Signed-off-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a two-line allocation-size fix for a real HID-over-I2C buffer
overflow in a driver that already exists on this 6.18.y tree. It should
be backported.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: **[HID / Intel-thc-hid / Intel-quicki2c] [Fix] [buffer
  overflow]**
- Subsystem prefix: `HID: Intel-thc-hid: Intel-quicki2c`
- Action verb: **Fix**
- Claimed intent: prevent overflow of HID-over-I2C input/output buffers

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - `Signed-off-by: Even Xu <even.xu@intel.com>` (author; listed
    maintainer of INTEL THC)
  - `Signed-off-by: Jiri Kosina <jkosina@suse.com>` (HID maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
    by:`, `Link:`, or `Cc: stable` (absence of those tags is expected
    for this review)
  - Pipeline-only tags ignored per instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** `input_buf` and `report_buf` hold complete HID-over-I2C
    packets (`__le16 len` + payload), but they are allocated from
    payload length only (`max_input_len` / `max_output_len`, floored at
    4K).
  - **Symptom/failure mode:** buffer overflow when the payload reaches
    that maximum (2 bytes past the end: `HIDI2C_LENGTH_LEN ==
    sizeof(__le16)`).
  - **Version info:** none in the message.
  - **Root cause:** allocation size omitted the 2-byte HID-over-I2C
    length header.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: Not a hidden fix. The subject and body state a buffer overflow
  and the diff matches that claim.

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
- Record:
  - File: `drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c` (+4
    / −2; net +2)
  - Function: `quicki2c_alloc_report_buf()`
  - Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record:
  - **Hunk 1 (input_buf):** `devm_kzalloc(..., max_report_len)` →
    `devm_kzalloc(..., HIDI2C_PACKET_LEN(max_report_len))`
  - **Hunk 2 (report_buf):** same change
  - Path: probe-time allocation (`quicki2c_probe` →
    `quicki2c_alloc_report_buf`). Runtime use of those buffers is
    unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record:
  - **Category:** memory safety / buffer overflow (out-of-bounds write)
  - **Mechanism:** packets are `struct hidi2c_report_packet { __le16
    len; u8 data[]; }`. `HIDI2C_PACKET_LEN(data_len)` is `(data_len) +
    HIDI2C_LENGTH_LEN`. Allocation used payload size only.
  - Verified consumers:
    - `handle_input_report()` DMA-copies into `input_buf` via
      `thc_rxdma_read()` → `sg_copy_to_buffer(..., read_buff, mes_len)`
      with **no destination-size argument**.
    - `quicki2c_get_report()` SWDMA-reads into `input_buf`.
    - `quicki2c_init_write_buf()` / `write_cmd_to_txdma()` build framed
      packets in `report_buf` (length field + payload, plus command
      bytes).
  - This is **not** a lock/refcount/init/API change.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record:
  - **Quality:** obviously correct. Uses an existing macro from
    `include/linux/hid-over-i2c.h` that this tree already has.
  - **Minimal:** two allocation sizes in one function.
  - **Regression risk:** very low. Extra 2 bytes per buffer; no API,
    locking, or control-flow change.
  - **Caveat (not a reason to reject):** `qcdev->report_len` is still
    set to `max_report_len`, not `HIDI2C_PACKET_LEN(max_report_len)`.
    The write-side bound check (`if (buf_len > write_buf_len) return
    -EINVAL`) can still reject a max-sized SET_REPORT. That is fail-safe
    (no overflow), pre-existing, and not a regression. Command framing
    can need more than +2 bytes; this commit only claims the 2-byte
    packet length header, which is what `HIDI2C_PACKET_LEN` adds.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: buggy allocations introduced by `66b59bfce6d93` (“HID: intel-
  thc-hid: intel-quicki2c: Complete THC QuickI2C driver”, Even Xu,
  2025-01-06). Present since the driver became functional. Driver
  skeleton: `61bb2714dc3a1`. First appeared around **v6.13**, so it is
  in this 6.18 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: no `Fixes:` tag. Not applicable. The introducing commit is in
  this tree (`git merge-base --is-ancestor 66b59bfce6d93 v6.18.57`
  succeeded).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record: recent work on this file is driver completion, ACPI, PM,
  device IDs, WOT. Related but distinct: `d08a1049659aa` (ACPI u16
  truncation, not this overflow). Sibling series patch: `HID: Intel-thc-
  hid: Intel-quickspi: Fix buffer overflow` (different file). This
  commit is **standalone**; it does not need the QuickSPI patch.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Even Xu is listed in MAINTAINERS as maintainer of `INTEL TOUCH
  HOST CONTROLLER (THC) DRIVER` (`drivers/hid/intel-thc-hid/`). This is
  a maintainer fix, not drive-by.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: `HIDI2C_PACKET_LEN` was added in `6fc761385bcf6` (“Add HIDI2C
  protocol implementation”) and is present on **v6.18.57** in
  `include/linux/hid-over-i2c.h`. No missing helpers. Patch applies
  cleanly to the v6.18.57 blob (`patch --dry-run` exit 0).

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record:
  - `b4 dig -c 5e5c3b9db1c5910d6a9175c97b76a95566e4dc32` →
    https://patch.msgid.link/20260922024638.932865-2-even.xu@intel.com
  - Cover: `[PATCH 0/2] HID: Intel-thc-hid: Fix potential buffer
    overflow` (`20260922024638.932865-1`)
  - `b4 dig -a`: **v1 only** (no v2/v3). Applied as submitted.
  - Jiri Kosina (2026-09-23): “Applied to hid.git#for-7.3/upstream-
    fixes, thanks.” No NAK.
  - No human reviewer asked for `Cc: stable`. An automated review noted
    `report_len` not updated and SET_REPORT framing possibly needing
    more than 2 bytes. HID maintainer applied the series as-is.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record (`b4 dig -w`): To/Cc `bentiss@kernel.org`, `jikos@kernel.org`,
  `srinivas.pandruvada@linux.intel.com`, `linux-input@vger.kernel.org`.
  HID maintainers were on the original mail. Jiri applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: no `Reported-by` / syzbot / bugzilla. Author-found from code
  inspection (“potential buffer overflow”). No user crash log in the
  thread.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: 2/2 is the QuickSPI analogue (`HIDSPI_INPUT_BODY_SIZE`).
  Independent file; this I2C patch does not depend on it.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org HTTP fetch returned 403. **UNVERIFIED**
  whether linux-stable discussed this SHA. Decision does not rely on
  that.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Record: `quicki2c_alloc_report_buf()` only.

**Step 5.2: TRACE CALLERS**
- Record: single caller, `quicki2c_probe()` (after reading the HID-
  over-I2C device descriptor). Probe of Intel THC I2C-port PCI devices
  (Lunar Lake, Panther Lake, Wildcat Lake IDs in `quicki2c_pci_tbl`).
  Not a hot path, but every successful probe allocates these buffers,
  then IRQ/DMA/HID traffic uses them.

**Step 5.3: TRACE CALLEES**
- Record: `devm_kzalloc()`, `le16_to_cpu()`, `HIDI2C_PACKET_LEN()`. No
  new callees.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: PCI probe → descriptor read → alloc → DMA init → HID
  registration → `handle_input_report()` on IRQ. Reachable on machines
  with Intel THC + HID-over-I2C touch. Unprivileged HID input does not
  size the kernel buffer; overflow is on kernel DMA/copy into an
  undersized `input_buf` when the device sends a max-sized packet.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: same author applied the same header-vs-payload fix to
  QuickSPI. Confirms a systematic off-by-header bug, not a one-off typo.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: **Yes.** Local tree is **6.18.57** (`git describe HEAD` →
  `v6.18.57-155-gcdf239ca885b2`; Makefile `VERSION=6 PATCHLEVEL=18
  SUBLEVEL=57`).
- On **v6.18.57** (this series’ base), `quicki2c_alloc_report_buf()`
  still does:
  - `input_buf = devm_kzalloc(..., max_report_len)`
  - `report_buf = devm_kzalloc(..., max_report_len)`
- `HIDI2C_PACKET_LEN` already exists in this tree’s header. Driver is
  `CONFIG_INTEL_QUICKI2C` under `INTEL_THC_HID` (`X86_64 && PCI &&
  ACPI`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: **clean apply** on the v6.18.57 file. Surrounding function
  matches the patch. No refactor in the way.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: no other commit on this file in 6.18.y enlarges these two
  allocations. The 4K floor (`max(..., SZ_4K)`) is a workaround for
  devices that under-declare max length; it does **not** add the 2-byte
  header. When `max_input_len`/`max_output_len` is ≥ 4K (HID max buffer
  is 16K), that floor provides no slack.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: **HID Intel THC QuickI2C** (`drivers/hid/intel-thc-hid/`).
  **IMPORTANT** for Intel laptops/tablets with THC touch (LNL/PTL/WCL),
  not core mm/VFS. Still production input hardware.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: actively maintained through 6.18 (device IDs, WOT, ACPI
  advanced features). Bug is in original 2025 driver completion, not
  brand-new 7.x-only code.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: **driver-specific / config-specific:** `CONFIG_INTEL_QUICKI2C`
  on x86_64 with Intel THC HID-over-I2C devices.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record: HID-over-I2C input/feature/output packet whose payload equals
  the allocated max (`max(declared max, 4K)`). Typical small touch
  reports may not hit it; max-sized reports and devices that declare
  large `wMaxInputLength` can. Not a userspace-crafted syscall overflow;
  it is device-facing DMA/copy. Still a kernel memory-safety bug on a
  standard probe/IRQ path.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: **buffer overflow (2 bytes) into heap** via
  `sg_copy_to_buffer` / packet construction. **HIGH** (memory
  corruption; crash or worse). Not a panic on every boot, but it is a
  real overflow, not a warning.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record:
  - **Benefit:** high for THC HID-over-I2C users — closes a heap
    overflow the driver author and HID maintainer treated as real.
  - **Risk:** very low — +2 bytes on two `devm_kzalloc`s, existing
    macro, no behavior change except not writing past the buffer.
  - **Ratio:** strongly favors backport.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real buffer overflow: complete HID-over-I2C packets stored in buffers
  sized from payload only
- DMA copy into `input_buf` has no dest-size check
- Small, obviously correct (+2 bytes via existing `HIDI2C_PACKET_LEN`)
- Driver and macro exist in this 6.18.57 tree; introducing commit is in
  this tree
- Applies cleanly
- Written by the THC maintainer; applied by HID maintainer
- Same class of bug independently fixed in QuickSPI

AGAINST:
- No public reproducer / syzbot report (author-found “potential”)
- 4K floor hides the overflow for devices with small `max_input_len`
- `report_len` not updated; write path may still `-EINVAL` at max size
  (fail-safe, not a new bug)
- Affects only Intel THC QuickI2C, not all machines

UNRESOLVED:
- Could not query lore.kernel.org/stable (HTTP 403)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — two allocation sizes; HID
   maintainer applied v1; macro already in tree
2. Fixes a real bug that affects users? **PASS** — overflow on max-sized
   HID-over-I2C packets in a shipping Intel touch driver
3. Important issue? **PASS** — heap buffer overflow / memory corruption
   (**HIGH**)
4. Small and contained? **PASS** — one function, two sites, ~4 lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean on v6.18.57;
   `HIDI2C_PACKET_LEN` already present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: none needed. This is a normal memory-safety bug fix, not a
  device-ID/quirk/DT/build/docs exception.

**Step 9.4: MAKE YOUR DECISION**
Backport. The bug is in this 6.18.y driver, the fix is surgical, and
leaving a 2-byte heap overflow in a HID DMA path is worse than adding
two bytes to the buffers.

## What the commit solves for this tree

On 6.18.57, QuickI2C still allocates `input_buf`/`report_buf` as
`max(payload, 4K)` and then stores HID-over-I2C packets that include a
2-byte length header. When the payload is that maximum,
`thc_rxdma_read()` / SWDMA copies past the end of the kmalloc buffer.
The fix allocates `HIDI2C_PACKET_LEN(max_report_len)` instead.

That matches stable rules: real overflow, tiny diff, no new API, applies
cleanly, no missing prerequisites.

Risk vs benefit: +2 bytes of allocation vs heap corruption on Intel THC
HID-over-I2C devices (Lunar Lake / Panther Lake / Wildcat Lake). Benefit
dominates. The unfixed `report_len` bound is conservative, not a
regression.

## Verification
- [Phase 1] Parsed subject/body/tags: overflow fix; Even Xu + Jiri
  Kosina SOBs; no Fixes/Reported-by
- [Phase 2] Diff: two `devm_kzalloc` sizes in
  `quicki2c_alloc_report_buf()` wrap `HIDI2C_PACKET_LEN`
- [Phase 2] `include/linux/hid-over-i2c.h`: `HIDI2C_PACKET_LEN(data_len)
  = data_len + sizeof(__le16)`
- [Phase 2] `handle_input_report()` / `read_dma_buffer()`:
  `sg_copy_to_buffer` into `input_buf` without dest capacity
- [Phase 3] `git blame` on v6.18.57: allocations from `66b59bfce6d93`
  (2025-01, driver completion)
- [Phase 3] `git merge-base --is-ancestor 66b59bfce6d93 v6.18.57`:
  introducing commit is in this tree
- [Phase 3] `HIDI2C_PACKET_LEN` added in `6fc761385bcf6`; present on
  v6.18.57
- [Phase 3] Author Even Xu is MAINTAINERS owner of `drivers/hid/intel-
  thc-hid/`
- [Phase 4] `b4 dig -c 5e5c3b9db1c5910d6a9175c97b76a95566e4dc32`: lore
  thread found; v1 only
- [Phase 4] mbox: Jiri Kosina applied to hid.git#for-7.3/upstream-fixes;
  no NAK
- [Phase 4] `b4 dig -w`: HID maintainers on original To/Cc
- [Phase 4] UNVERIFIED: lore.kernel.org/stable HTTP 403
- [Phase 5] Single caller `quicki2c_probe()`; PCI IDs LNL/PTL/WCL THC
  I2C ports
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.18.57
- [Phase 6] `git show v6.18.57:drivers/hid/intel-thc-hid/intel-
  quicki2c/pci-quicki2c.c`: buggy sizes still present
- [Phase 6] `patch --dry-run` of this commit onto the v6.18.57 file:
  exit 0
- [Phase 8] Failure mode: 2-byte heap overflow on max-sized HID-over-I2C
  packets; severity HIGH

**YES**

 drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c b/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
index c6ba6886072ad..4588c55cf255d 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
@@ -586,7 +586,8 @@ static int quicki2c_alloc_report_buf(struct quicki2c_device *qcdev)
 	 */
 	max_report_len = max(le16_to_cpu(qcdev->dev_desc.max_input_len), SZ_4K);
 
-	qcdev->input_buf = devm_kzalloc(qcdev->dev, max_report_len, GFP_KERNEL);
+	qcdev->input_buf = devm_kzalloc(qcdev->dev,
+					HIDI2C_PACKET_LEN(max_report_len), GFP_KERNEL);
 	if (!qcdev->input_buf)
 		return -ENOMEM;
 
@@ -596,7 +597,8 @@ static int quicki2c_alloc_report_buf(struct quicki2c_device *qcdev)
 	max_report_len = max(le16_to_cpu(qcdev->dev_desc.max_output_len),
 			     max_report_len);
 
-	qcdev->report_buf = devm_kzalloc(qcdev->dev, max_report_len, GFP_KERNEL);
+	qcdev->report_buf = devm_kzalloc(qcdev->dev,
+					 HIDI2C_PACKET_LEN(max_report_len), GFP_KERNEL);
 	if (!qcdev->report_buf)
 		return -ENOMEM;
 
-- 
2.53.0

