Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E335E3CEB95;
	Mon, 20 Apr 2026 13:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691760; cv=none; b=MB9VnjW5KPRRajj9CxgXHLpTlSlyy4XEvBSTjvHS9kTfzjq6oT11vf8nwmYVCbz4VSqXE3Rg2HtWJn4BfHBoIAXMhEABtfZ0XDzLpC4P1NyExiKXpvkoKpjIMzD2S9TJfN8yCZjyL6CUaN0IbW/to0V+7hV3/H/25sl53VC6SYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691760; c=relaxed/simple;
	bh=fAIl7Oa60rYsXXpRjcp6tby5iEceDeFC2+fvbHkx/fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/FD4Xdxbk4ItgyUB78+qFvfJ6NcOAii3EtJKMnrXgLWWi8Syp1TuLtvsMtNX8SOobQil6bcbREVtFyIADnYTe/8u74/OR823zmOVWVbMN/sQeVZ7S5AyAM5ImjVYnXKJwLKsUf0lOQ59iiuNPUB0Uih4+NLsAnnF//JAJpcweo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNIuA3J5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNIuA3J5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7565C2BCB7;
	Mon, 20 Apr 2026 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691759;
	bh=fAIl7Oa60rYsXXpRjcp6tby5iEceDeFC2+fvbHkx/fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNIuA3J5i7Bogg0cGQpEF3bopw0ALXTeIigMHK7mImUtJVtA6tIm2Z5X9D30iylAf
	 xG6wedRGcbI9VchTrL5pz4y8zaGiun3GRDViMFK6QGCg82MEsOk9p8BWWAxMha7fU8
	 zg7Sq26B+xgDantYRGBu5R+v9f5Yk88IgtoIIKvufWXRHDcZXT/GBlkOPEU9t8c/Y3
	 ylxG0P4XsKdcUUne0dmp6IaXT/Y6KaGphVik0PX36NlgxpscwqophrmcT5J8snNgIK
	 XUgmtPg7CIyY97S9BhfAoL4Dxm75P7mtInq6TpLlkCCPJENFWUMfgPXDQw1ZKDVK8Y
	 7q+fu7IiMIWzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sizhe Liu <liusizhe5@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	mahesh@linux.ibm.com,
	linuxppc-dev@lists.ozlabs.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] PCI/DPC: Hold pci_dev reference during error recovery
Date: Mon, 20 Apr 2026 09:19:31 -0400
Message-ID: <20260420132314.1023554-177-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Sizhe Liu <liusizhe5@huawei.com>

[ Upstream commit a1ed752bc7cb77b740cee671567d9508ae74becd ]

The AER and EDR error handling paths hold a reference on the pci_dev during
recovery.  Hold a reference during the DPC recovery path as well.

Signed-off-by: Sizhe Liu <liusizhe5@huawei.com>
[bhelgaas: split to separate patch]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
https://patch.msgid.link/20260214081130.1878424-1-liusizhe5@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me write the complete
analysis.

---

## Complete Analysis: PCI/DPC: Hold pci_dev reference during error
recovery

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `PCI/DPC` (PCI Express Downstream Port Containment)
- Action verb: "Hold" - implies adding a missing safety measure
- Summary: Hold a pci_dev reference during error recovery to prevent
  potential use-after-free
- Record: [PCI/DPC] [Hold] [Add missing reference counting for pci_dev
  during DPC recovery path]

**Step 1.2: Tags**
- `Signed-off-by: Sizhe Liu <liusizhe5@huawei.com>` - Original author
- `[bhelgaas: split to separate patch]` - Bjorn Helgaas (PCI subsystem
  maintainer) split this from a larger patch
- `Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>` - Committed by
  the PCI subsystem maintainer
- `Link: https://patch.msgid.link/20260214081130.1878424-1-
  liusizhe5@huawei.com` - Original submission

No Fixes: tag, no Reported-by, no Cc: stable (expected for a candidate).

Record: Signed by author and PCI maintainer. Split from a larger patch
by Bjorn Helgaas. No Fixes: tag.

**Step 1.3: Commit Body**
The message states: "The AER and EDR error handling paths hold a
reference on the pci_dev during recovery. Hold a reference during the
DPC recovery path as well." This is a clear statement of a reference
counting inconsistency between the three error recovery paths.

Record: Bug = missing pci_dev reference during DPC error recovery.
Symptom = potential use-after-free if device is freed during recovery.
Root cause = reference counting inconsistency between DPC, AER, and EDR
paths.

**Step 1.4: Hidden Bug Fix Detection**
Yes - this is a reference counting bug fix. The word "Hold" implies
adding a missing reference, aligning DPC with AER and EDR behavior. This
fixes a potential use-after-free.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file modified: `drivers/pci/pcie/dpc.c`
- +2 lines added, 0 removed
- Function modified: `dpc_handler()`
- Classification: single-file surgical fix (2 lines)

**Step 2.2: Code Flow Change**
Before: `dpc_handler()` uses `pdev` throughout `dpc_process_error()` and
`pcie_do_recovery()` without holding a reference.
After: `pci_dev_get(pdev)` before processing, `pci_dev_put(pdev)` after
recovery completes. Ensures the `pci_dev` object lives through the
entire recovery.

**Step 2.3: Bug Mechanism**
Category: **Reference counting fix**
- `pci_dev_get()` is ADDED (this fixes a potential use-after-free /
  missing reference hold)
- AER path: uses `pci_dev_get()` in `add_error_device()` at `aer.c:992`
  and `pci_dev_put()` in `handle_error_source()` at `aer.c:1202`
- AER APEI path: uses `pci_get_domain_bus_and_slot()` (returns with ref)
  at `aer.c:1226` and `pci_dev_put()` at `aer.c:1253`
- EDR path: uses `pci_dev_get()` in `acpi_dpc_port_get()` at
  `edr.c:89,94` and `pci_dev_put()` at `edr.c:218`
- DPC path: **no reference held** before this fix

**Step 2.4: Fix Quality**
- Obviously correct: balanced get/put pair wrapping the usage
- Minimal/surgical: exactly 2 lines
- No regression risk: adding reference counting cannot cause deadlock or
  data corruption
- No red flags

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The `dpc_handler()` function was authored by Kuppuswamy Sathyanarayanan
in commit `aea47413e7ceec` (2020-03-23), present since v5.15. The core
structure with `dpc_process_error()` + `pcie_do_recovery()` has been
stable since then. The surprise removal check was added later by
`2ae8fbbe1cd42` (2024, first in v6.12).

**Step 3.2: Fixes Tag Context**
The original v3 patch had `Fixes: a57f2bfb4a58` ("PCI/AER: Ratelimit
correctable and non-fatal error logging") which was first in v6.16-rc1.
However, the reference counting bug existed earlier - the DPC path has
been missing the reference since `aea47413e7ceec` (2020, v5.15+). Bjorn
split the reference counting part into its own patch.

**Step 3.3: File History**
Recent commits to `dpc.c` are mostly cleanup/improvement (FIELD_GET,
defines, TLP log). No other reference counting fixes.

**Step 3.4: Author Context**
Sizhe Liu (Huawei) identified the issue. Bjorn Helgaas (PCI subsystem
maintainer) reviewed, suggested the reference counting addition, and
committed the fix.

**Step 3.5: Dependencies**
This commit is fully standalone. It adds `pci_dev_get()`/`pci_dev_put()`
around existing code. No new functions, no API changes, no dependencies.

### PHASE 4: MAILING LIST RESEARCH

The complete discussion was found. Key findings:
1. Sizhe Liu submitted v1/v2/v3 of "PCI/AER: Fix missing AER logs in DPC
   and EDR paths"
2. On v2 review, **Bjorn Helgaas himself identified** the missing
   reference: "I don't see a similar pci_dev_get() anywhere in the DPC
   path ... holding that reference on the device is important."
3. Sizhe Liu agreed and added it in v3
4. Bjorn then split the v3 patch into two separate patches: the AER log
   fix and this reference counting fix
5. Shiju Jose reviewed v3 with minor formatting comments
6. The patch was applied by Bjorn Helgaas

### PHASE 5: CODE SEMANTIC ANALYSIS

**Callers of affected code:**
- `dpc_handler()` is a threaded IRQ handler registered in `dpc_probe()`
  via `devm_request_threaded_irq()`
- Triggered by `dpc_irq()` (hardirq handler) returning `IRQ_WAKE_THREAD`
- `pcie_do_recovery()` is a long-running function that walks the PCI
  bus, calls driver error handlers, resets links, and waits for
  secondary bus readiness

**Call chain:** Hardware DPC trigger -> `dpc_irq()` -> `dpc_handler()`
-> `dpc_process_error()` + `pcie_do_recovery()` -> `dpc_reset_link()` ->
`pcie_wait_for_link()` + `pci_bridge_wait_for_secondary_bus()`

The recovery process can take seconds (waiting for links, bus resets).
During this time, the `pci_dev` must remain valid.

### PHASE 6: STABLE TREE ANALYSIS

The buggy code (`dpc_handler()` without reference) exists in all stable
trees from v5.15 onwards. The function was introduced in
`aea47413e7ceec` (v5.15). For trees older than v6.12, the surprise
removal block won't be present, but the patch context for the
`pci_dev_get`/`pci_dev_put` addition is around the `dpc_process_error()`
+ `pcie_do_recovery()` calls which are present in all trees. Minor
conflicts may be needed for trees without the surprise removal check.

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- Subsystem: PCI Express (drivers/pci/pcie/) - IMPORTANT subsystem
  affecting all PCIe users
- DPC is a standard PCIe feature for error containment
- Maintainer: Bjorn Helgaas - he personally identified and committed
  this fix
- Criticality: IMPORTANT - affects all systems with PCIe DPC support

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Who is affected:** All systems with PCIe DPC support (most modern x86
systems, some ARM)

**Trigger conditions:** A DPC containment event (PCIe fatal error)
concurrent with device removal. While the specific race may be hard to
trigger, DPC events are not uncommon (hardware errors, NVMe removal
under load).

**Failure mode:** Potential use-after-free - accessing freed `pci_dev`
during recovery. Severity: **HIGH** (crash, potential security issue)

**Benefit:** Fixes a reference counting correctness bug, aligns DPC with
AER/EDR behavior, prevents potential UAF during error recovery.

**Risk:** **Very low** - 2 lines, balanced get/put, obviously correct,
no behavioral change.

### PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
1. Fixes a reference counting bug (missing `pci_dev_get` in DPC handler)
2. Potential use-after-free during error recovery
3. Only 2 lines added - minimal risk
4. PCI subsystem maintainer (Bjorn Helgaas) personally identified the
   issue and committed the fix
5. Consistent with how AER and EDR paths already work
6. `pcie_do_recovery()` is a long-running function making the window
   non-trivial
7. Buggy code present since v5.15
8. Standalone fix with no dependencies

**Evidence AGAINST backporting:**
1. No concrete crash report or syzbot finding (theoretical)
2. Race requires specific timing (DPC + hot-removal)

**Stable Rules Checklist:**
1. Obviously correct? **YES** - balanced get/put, trivially verifiable
2. Fixes a real bug? **YES** - reference counting inconsistency,
   potential UAF
3. Important issue? **YES** - potential crash/UAF during error recovery
4. Small and contained? **YES** - 2 lines in 1 file
5. No new features/APIs? **YES** - pure bug fix
6. Can apply to stable? **YES** - standalone, clean apply expected for
   v7.0

### Verification

- [Phase 1] Parsed tags: Signed-off-by Sizhe Liu + Bjorn Helgaas, Link
  to lore
- [Phase 2] Diff analysis: +2 lines in `dpc_handler()`, adds
  `pci_dev_get()`/`pci_dev_put()` around error recovery
- [Phase 3] git blame: `dpc_handler()` introduced in commit
  `aea47413e7ceec` (2020), present since v5.15
- [Phase 3] git show a57f2bfb4a58: confirmed the ratelimit commit is in
  v6.16-rc1, first in v7.0 tree
- [Phase 4] Found full thread via yhbt.net mirror of lore: v1/v2/v3
  progression, Bjorn requested ref counting in v2 review
- [Phase 4] Bjorn Helgaas (PCI maintainer) explicitly said "holding that
  reference on the device is important"
- [Phase 4] Bjorn split original 3-file patch into separate patches,
  this is the DPC ref-counting portion
- [Phase 5] `pcie_do_recovery()` walks bus, resets links, waits for
  secondary bus - long-running operation
- [Phase 5] Verified AER (aer.c:992/1202), AER APEI (aer.c:1226/1253),
  EDR (edr.c:89/218) all hold references
- [Phase 5] Verified DPC path has NO reference holding in current 7.0
  tree
- [Phase 6] Buggy code exists since v5.15 (aea47413e7ceec present in
  v5.15, v6.1, v6.6, v6.12, v7.0)
- [Phase 6] Surprise removal block (2ae8fbbe1cd42) is in v6.12+ only, so
  older trees may need context adjustment
- [Phase 7] PCI/DPC is an important subsystem; fix committed by
  subsystem maintainer
- [Phase 8] Failure mode: potential UAF during DPC recovery, severity
  HIGH
- UNVERIFIED: Whether the `devm_request_threaded_irq` + `free_irq`
  synchronization fully prevents the race (it synchronizes handler
  completion but doesn't prevent refcount drops during handler
  execution)

The fix is a 2-line, obviously correct reference counting addition that
aligns the DPC error recovery path with the AER and EDR paths. The PCI
subsystem maintainer identified and committed it. The potential
consequence of the missing reference is a use-after-free, and the fix
carries essentially zero regression risk.

**YES**

 drivers/pci/pcie/dpc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index fc18349614d7c..f028bc795f197 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -372,11 +372,13 @@ static irqreturn_t dpc_handler(int irq, void *context)
 		return IRQ_HANDLED;
 	}
 
+	pci_dev_get(pdev);
 	dpc_process_error(pdev);
 
 	/* We configure DPC so it only triggers on ERR_FATAL */
 	pcie_do_recovery(pdev, pci_channel_io_frozen, dpc_reset_link);
 
+	pci_dev_put(pdev);
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0

