Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D880B470858;
	Mon, 19 Oct 2026 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418550; cv=none; b=OqKRIa9zFEGF2i7LI7z910gt8suOK51qR1MrzpMNJiF0oJARSg9lHNC6v5UUJz5pUkMxqWd1Upl4I0C44gxckJMIdW09FeD5wu5XKBMaYSn7fZby5L/QQHT3whXiEaT7+w+cbHwjLkXA0BA/xL16KYbT2WSrBjUQRA7NT2ZkO68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418550; c=relaxed/simple;
	bh=CGw/LoqxySi4y3ucj0pSd1ASJG726CFLpKjg3irJQuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=twnh+5SQPIoydFABN5Wn2DHeNbbyCJ9LgOyEnisag/jMRjcPgeFKmGzY6luuM0d8/oxW9QrBxH0537T924cRKild9Msd93eJkjkOadmJYJf3Fwq7BOP34G/Y7L5pqGeP13mMclTV2eDN6bUFtc5ePbZvNPdu2DOf5KPyQ1yaXZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGb48cUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGb48cUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2011F000C9;
	Mon, 19 Oct 2026 14:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418547;
	bh=yVfznEcOE2PnCJM60afoSwR6xdh678dLhjRPRccI0NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGb48cUIJGdKBRrPoHydKYKwYQcYO74XpSukoQj0B9N1VOvEViLHHBi+e6gKMthxF
	 KYjMwf14+Og0yXQcu1kqqaKT7q0gApvj0P5WJWAP0lBYB6yde5/6+LbnK1ZAYg3aAE
	 APVsl0ayBDCzjyC2HkOren0JgMC5Ewk8wmh/wwkHWeScaXNN8KAe/pBsYiD89Xg5iR
	 WEGgLUC9wm/3uGG6V2P9aqrEr3NQG1ReBfcgQw5tm4YosbZc2es5g8OuKD1DW5S6v7
	 AS+OEhvv6zjBuXpDmyhm43hEsfqGQayQ4SxsDO+mzxCJ94jSq0QAAeGxAsHs0M8IX9
	 vNqQKcbXsProA==
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
Subject: [PATCH AUTOSEL 6.18] HID: Intel-thc-hid: Intel-quickspi: Fix buffer overflow
Date: Mon, 19 Oct 2026 09:50:17 -0400
Message-ID: <20261019135441.1420968-326-sashal@kernel.org>
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

[ Upstream commit a1cdd72371270640bd357bd3e3b2ec0be17c9536 ]

The input buffers are used to store complete HID-over-SPI packets,
including their protocol headers. However, their sizes are
currently calculated from the payload length only.

Allocate enough space for both the payload and the packet header to
prevent a buffer overflow when the payload reaches its maximum size.

Signed-off-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real heap overflow in Intel QuickSPI HID input, and the local
6.18.57 tree still has the undersized `input_buf` allocation, so it
should be backported.

Local tree: **v6.18.57** (`6.18.57`, HEAD `cdf239ca885b2`). The buggy
allocation is present at `v6.18.57`; `HIDSPI_INPUT_BODY_SIZE` already
exists here. The patch applies cleanly.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[HID/intel-thc-hid/intel-quickspi] [fix] [prevent input_buf
overflow by including HIDSPI packet header in allocation]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Even Xu <even.xu@intel.com>` (author; INTEL THC
  maintainer)
- `Signed-off-by: Jiri Kosina <jkosina@suse.com>` (HID maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable` (absence is expected)
- Pipeline-only markers ignored: `[Upstream commit
  a1cdd72371270640bd357bd3e3b2ec0be17c9536]`, `Signed-off-by: Sasha
  Levin`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `input_buf` is sized from HID payload length only, but stores a
  full HID-over-SPI packet (header + payload).
- Symptom: buffer overflow when the payload is at its maximum size.
- Root cause: size uses `max_input_len` / `rep_desc_len` and omits
  `HIDSPI_INPUT_BODY_HEADER_SIZE` (4 bytes).
- No stack traces, versions, or syzbot IDs.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Subject and body state a buffer overflow. The one-
line change matches that claim.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c`
  (+2/-1)
- Function: `quickspi_alloc_report_buf()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before (`v6.18.57`): `qsdev->input_buf = devm_kzalloc(...,
  max_input_len, ...)` where `max_input_len = max(rep_desc_len,
  max_input_len)`.
- After: allocate `HIDSPI_INPUT_BODY_SIZE(max_input_len)` = payload +
  `sizeof(struct input_report_body_header)` (packed 4 bytes).
- Path: probe-time allocation; used later on every RX DMA completion.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[BUFFER OVERFLOW / OUT-OF-BOUNDS]`
Mechanism verified in this tree:
1. IRQ thread `quickspi_irq_thread_handler()` calls `thc_rxdma_read(...,
   qsdev->input_buf, &input_len, ...)`.
2. `read_dma_buffer()` does `sg_copy_to_buffer(sg, nent, read_buff,
   mes_len)` with **no check against `input_buf` allocation size**.
3. The only bound is `mes_len > read_config->max_packet_size`, and
   `max_packet_size` is `ALIGN(max_input_len, SZ_4K)`, so a packet of
   `max_input_len + 4` is allowed for typical HID sizes.
4. `quickspi_handle_input_data()` treats `input_buf` as `struct
   input_report_body` (4-byte header + content).
5. Output path already accounts for the header via
   `HIDSPI_OUTPUT_REPORT_SIZE` (from `6fcefe71aeb52`, already in
   `v6.18.57`). Input was left inconsistent.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. Uses an existing macro. 4 extra
`devm_kzalloc` bytes. No locking, API, or ABI change. Regression risk is
very low (slightly larger probe allocation).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Buggy alloc introduced in `4138f21115aec` ("HID: intel-thc-hid:
intel-quickspi: Complete THC QuickSPI driver", Xinpeng Sun, 2025-01-06).
Present since at least **v6.15**. Present in this 6.18.y tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introducer is `4138f21115aec`, which **is** an
ancestor of `v6.18.57`.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (on this tree, limited to the file):
- `6fcefe71aeb52` — already in `v6.18.57`; sized **output** `report_buf`
  with `HIDSPI_OUTPUT_REPORT_SIZE` and added a copy bound. That made the
  remaining input undersize obvious.
- `b2301bdb4b3ed`, `c2854af5774b0`, device-ID commits — unrelated.
- Sibling `4bda3254e7b4f` (QuickI2C overflow) is a parallel independent
  fix, not a prerequisite.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Even Xu is listed in MAINTAINERS as `INTEL TOUCH HOST CONTROLLER
(THC) DRIVER` co-maintainer. Related work in-tree includes DMA safety
checks and device IDs. This is a maintainer-authored fix.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. Needs only `HIDSPI_INPUT_BODY_SIZE` in
`include/linux/hid-over-spi.h`, present at `v6.18.57:91`. Series is
`[PATCH 2/2]` with QuickI2C; the two files do not depend on each other.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c a1cdd72371270640bd357bd3e3b2ec0be17c9536` →
  https://patch.msgid.link/20260922024638.932865-3-even.xu@intel.com
- Cover: `[PATCH 0/2] HID: Intel-thc-hid: Fix potential buffer overflow`
  (`20260922024638.932865-1`)
- `b4 dig -a`: **v1 only** (no later revisions)
- Thread saved via `b4 dig -m`; lore.kernel.org HTTP fetch returned
  **403**
- Jiri Kosina: “Applied to hid.git#for-7.3/upstream-fixes, thanks.” No
  NAK, no requested changes on the SPI patch.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc `bentiss@kernel.org` (Benjamin Tissoires),
`jikos@kernel.org` (Jiri Kosina), `srinivas.pandruvada@linux.intel.com`,
`linux-input@vger.kernel.org`. HID maintainers were on the original
mail. Kosina applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / syzbot / bugzilla. Found by the subsystem
maintainer as a size mismatch. Cover letter calls it a **potential**
overflow; the DMA copy path confirms it is reachable, not theoretical.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Independent 2-patch set (QuickI2C + QuickSPI). Sashiko AI
comment was about the **I2C** patch (`report_len` vs
`HIDI2C_PACKET_LEN`), not this SPI change. SPI `report_buf` is already
header-sized in this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: `curl` to lore.kernel.org/stable also returned 403. UNVERIFIED
whether stable@ discussed this specifically. No local evidence it was
rejected.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `quickspi_alloc_report_buf()`

**Step 5.2: TRACE CALLERS**
Record: Only `quickspi_probe()` at `pci-quickspi.c:660`, after
`reset_tic()`, before `quickspi_dma_init()` /
`quickspi_get_report_descriptor()` / `quickspi_hid_probe()`. Standard
PCI probe. `input_buf` is then written from the IRQ thread on
`THC_RXDMA2_INT` (touch input).

**Step 5.3: TRACE CALLEES**
Record: `devm_kzalloc()` only. Consumers: `thc_rxdma_read()` →
`sg_copy_to_buffer()`; `quickspi_handle_input_data()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: `quickspi_probe` → IRQ `THC_RXDMA2_INT` →
`thc_rxdma_read(input_buf)` → `quickspi_handle_input_data`. Reachable
whenever an Intel THC HID-over-SPI touch device delivers a max-sized
input or report-descriptor packet. Not a userspace-crafted syscall
overflow; it is device-driven heap overflow on a common input path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same class of bug in QuickI2C (`HIDI2C_PACKET_LEN`). Output SPI
buffer already fixed by `6fcefe71aeb52`. No other `input_buf` alloc in
this driver.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes, at `v6.18.57`:

```
qsdev->input_buf = devm_kzalloc(qsdev->dev, max_input_len, GFP_KERNEL);
```

Driver exists from v6.15 through this 6.18.y tree. Bug introduced with
the completed driver (`4138f21115aec`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply**. `patch -p1 --dry-run` against the `v6.18.57`
file succeeded. Surrounding function matches. Macro already present.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Output-side header sizing (`6fcefe71aeb52`) is already in
`v6.18.57`. Input-side overflow is **not** fixed at `v6.18.57`. No
alternate input_buf fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `[HID / Intel THC QuickSPI]` `[IMPORTANT]` — not core mm/net,
but the HID-over-SPI path for Intel touch on MTL/LNL/PTL/ARL/WCL/NVL.
Crash/overflow there takes down input on those machines.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (device IDs, PM, DMA bounds). Still a small,
contained driver, not a refactoring minefield.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / config-specific (`CONFIG_INTEL_QUICKSPI`,
`X86_64 && PCI && ACPI`). Users of Intel THC HID-over-SPI touch (Meteor
Lake through Nova Lake PCI IDs in this tree).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Device sends a HID-over-SPI body whose content length equals
`max_input_len` or `rep_desc_len`. That is a normal max-size touch
report / report-descriptor response, not an exotic error path.
Unprivileged userspace cannot directly size the DMA packet; a
malicious/buggy touch controller can. Trigger likelihood: **realistic on
real hardware**.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Heap buffer overflow via `sg_copy_to_buffer` into `devm_kzalloc`
memory. Typical overrun is 4 bytes; DMA `max_packet_size` is 4K-aligned,
so a larger `mes_len` could copy more. Failure mode: heap corruption →
oops/panic or memory corruption. Severity: **HIGH** (not a WARN-only
issue).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit **high** (stops heap overflow on touch RX). Risk **very
low** (2 lines, +4 bytes, existing macro). Ratio strongly favors
backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real heap overflow: DMA copies header+payload into a payload-only
  buffer.
- Bug exists in this 6.18.57 tree; driver has been in-tree since v6.15.
- Important: kernel memory corruption / crash on a production Intel
  touch path.
- Tiny, obviously correct, uses `HIDSPI_INPUT_BODY_SIZE` already in this
  tree.
- Output buffer already got the analogous header sizing here; this
  completes the same invariant.
- Author is THC maintainer; HID maintainer applied v1 with no
  objections.
- Applies cleanly; no prerequisites missing.

AGAINST:
- No public crash report / syzbot (maintainer-found “potential”
  overflow).
- Affects only Intel THC QuickSPI, not all machines.
- Cover letter wording is “potential”; DMA copy confirms it is real.

UNRESOLVED:
- lore.kernel.org HTTP 403; discussion recovered via `b4 dig -m`.
- Stable list search unverified for the same 403 reason.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 4-byte header included via
   existing macro; applied by HID maintainer.
2. Fixes a real bug that affects users? **PASS** — undersized
   `input_buf` vs DMA copy of full packets.
3. Important issue? **PASS** — heap overflow / memory corruption, HIGH.
4. Small and contained? **PASS** — +2/-1, one function, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — clean apply to `v6.18.57`;
   macro present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not an ID/quirk/DT/build/docs exception. It is a normal memory-
safety fix.

**Step 9.4: MAKE YOUR DECISION**
Backport. The bug is in this tree, the fix is surgical, and the failure
mode is heap overflow on the Intel QuickSPI input path.

---

## What the commit solves for this tree

On 6.18.57, `quickspi_alloc_report_buf()` sizes `input_buf` to the HID
payload only. RX DMA later copies a full HIDSPI body (`struct
input_report_body_header` + content) into that buffer. At max payload
(or max report descriptor), that is at least a 4-byte heap overflow, and
the DMA length check cannot catch it because hardware buffers are
4K-aligned. Touch IRQ handling is a normal path on Intel THC HID-over-
SPI laptops.

The change allocates `HIDSPI_INPUT_BODY_SIZE(max_input_len)` instead.
That matches how this tree already sizes the output buffer. No new API,
no extra locking, no missing prerequisites.

Risk vs benefit: four extra bytes at probe vs heap corruption on input.
Benefit dominates.

---

## Verification
- [Phase 1] Tags: Even Xu + Jiri Kosina SOBs; no Fixes/Reported-by/Cc:
  stable (expected).
- [Phase 2] Diff: `quickspi_alloc_report_buf()` switches `devm_kzalloc`
  from `max_input_len` to `HIDSPI_INPUT_BODY_SIZE(max_input_len)`
  (+2/-1).
- [Phase 2] `include/linux/hid-over-spi.h`: `HIDSPI_INPUT_BODY_SIZE` =
  content + packed 4-byte header.
- [Phase 2] `read_dma_buffer()` copies `mes_len` into `input_buf` with
  only `max_packet_size` (`ALIGN(..., SZ_4K)`) as a cap.
- [Phase 3] `git blame` at v6.18.57: alloc from `4138f21115aec`
  (v6.15+); still payload-only.
- [Phase 3] `git merge-base --is-ancestor 4138f21115aec v6.18.57` → yes;
  `6fcefe71aeb52` already in v6.18.57 (output only).
- [Phase 3] Author Even Xu is MAINTAINERS THC driver maintainer.
- [Phase 4] `b4 dig -c a1cdd72371270640bd357bd3e3b2ec0be17c9536`: v1
  series; Kosina applied to hid.git#for-7.3/upstream-fixes.
- [Phase 4] `b4 dig -w`: jikos, bentiss, linux-input CCd.
- [Phase 4] UNVERIFIED: live lore.kernel.org pages (HTTP 403); thread
  recovered from mbox.
- [Phase 5] Caller: `quickspi_probe()` → IRQ RXDMA2 →
  `thc_rxdma_read(input_buf)`.
- [Phase 6] `git describe HEAD` / Makefile: **6.18.57**. Buggy line
  present at v6.18.57; `HIDSPI_INPUT_BODY_SIZE` present; `patch --dry-
  run` clean.
- [Phase 8] Failure mode: heap overflow on max-size HID-over-SPI input,
  severity HIGH.
- UNVERIFIED: whether this was already discussed on stable@ (lore 403).

**YES**

 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
index 1c96d1d85845c..48387a7341604 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -549,7 +549,8 @@ static int quickspi_alloc_report_buf(struct quickspi_device *qsdev)
 	max_input_len = max(le16_to_cpu(qsdev->dev_desc.rep_desc_len),
 			    le16_to_cpu(qsdev->dev_desc.max_input_len));
 
-	qsdev->input_buf = devm_kzalloc(qsdev->dev, max_input_len, GFP_KERNEL);
+	qsdev->input_buf = devm_kzalloc(qsdev->dev,
+					HIDSPI_INPUT_BODY_SIZE(max_input_len), GFP_KERNEL);
 	if (!qsdev->input_buf)
 		return -ENOMEM;
 
-- 
2.53.0

