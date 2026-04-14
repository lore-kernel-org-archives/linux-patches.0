Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B312D3DE45B;
	Tue, 14 Apr 2026 11:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165925; cv=none; b=lLeBEEWZiUTXT5ucKYjOJ0iFGSNuF4iC1xAHj/Nr6k89bT0s0O6i+aXxbWNYGJnAoQySwzivIST3+dMrMjbv5fXBz/jSBuiLx141KdBZCslRBl5+CT5f4xDw7NrJjfyHepYIz+9rPwbzUIzGrMEfStGtJMeEJTcn6PkEtgLGnRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165925; c=relaxed/simple;
	bh=8xv1b0sIQ8eCwo0ODJU3Epv00PcqmUKDKUUCzF1Pu6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jYXurT9PlMvc5nA3ziREpG5wgWo97kuwuBShndT89eVHP8V7PqzMzI8p2aN7sA7X1IBuiIRrimzTtFJZnvw5wnzenjFLp5WgeRjZGZvfg7benOnsmPngVAbY2eey9eEU18cB5OaBE9YnraTuhCI0Sdd9M4P/2guDQgM5l5Gt0Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KB2K3EOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KB2K3EOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6CCC19425;
	Tue, 14 Apr 2026 11:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776165925;
	bh=8xv1b0sIQ8eCwo0ODJU3Epv00PcqmUKDKUUCzF1Pu6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KB2K3EOOlhliof9FEWFOWMgP+mum11TwBTuWtnXWSbetiEl27l/9zMVXLGOwrEhOT
	 hp/4m5YIOOhz8YqBSZzvikJOOG/XZrsMvFoTXYpK8S0pO5QKUjxRsTkovGu9kp9W9i
	 NJKop/QywiPwD9GLVi2+92q6Gr3NF6SuTwh/KRaAG76IgEFmSIsBqfwkp0LVqJKr5s
	 vmdAIAXjnuIQSwWyDvbijzhQaA7pBXk0j1QnwYS9Dt9pve7bmGUtHoJ5YuDWsHiAk6
	 QjChOnDoRFgCfpKYVp46bH2qq1kV/LFchFOeBPRSZW1Ta8ediHMHwjwBK4TMXHoF7c
	 0E8BN9Qh2ZBZQ==
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
Subject: [PATCH AUTOSEL 6.19-6.18] HID: Intel-thc-hid: Intel-quickspi: Add NVL Device IDs
Date: Tue, 14 Apr 2026 07:25:06 -0400
Message-ID: <20260414112509.410217-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414112509.410217-1-sashal@kernel.org>
References: <20260414112509.410217-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.12
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Even Xu <even.xu@intel.com>

[ Upstream commit 48e91af0cbe942d50ef6257d850accdca1d01378 ]

Add Nova Lake THC QuickSPI device IDs to support list.

Signed-off-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear picture. Let me complete the formal analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `HID: Intel-thc-hid: Intel-quickspi`
- Action verb: "Add"
- Summary: Adding Nova Lake (NVL) THC QuickSPI PCI device IDs to the
  support list

**Step 1.2: Tags**
- `Signed-off-by: Even Xu <even.xu@intel.com>` — author, Intel engineer,
  regular THC driver contributor
- `Signed-off-by: Jiri Kosina <jkosina@suse.com>` — HID subsystem
  maintainer
- No Fixes: tag (expected — this is a device ID addition, not a bug fix)
- No Reported-by, Tested-by, Link tags

**Step 1.3: Body Text**
Simple: "Add Nova Lake THC QuickSPI device IDs to support list." No bug
described — this is hardware enablement.

**Step 1.4: Hidden Bug Fix?**
No. This is explicitly a device ID addition — it enables new hardware.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `pci-quickspi.c`: +6 lines (3 lines for `nvl` driver_data struct, 2
  lines for PCI table entries, 1 blank line)
- `quickspi-dev.h`: +2 lines (2 `#define` for PCI device IDs)
- Total: +8 lines, 0 removed
- Functions modified: None — only data structures/tables

**Step 2.2: Code Flow Changes**
- Adds `struct quickspi_driver_data nvl` with `.max_packet_size_value =
  MAX_PACKET_SIZE_VALUE_LNL` (same as LNL and PTL)
- Adds two `#define` for NVL PCI IDs: `0xD349` (Port1) and `0xD34B`
  (Port2)
- Adds two entries to `quickspi_pci_tbl[]` PCI device table linking
  those IDs to the `nvl` driver_data

**Step 2.3: Bug Mechanism**
N/A — this is not a bug fix. It's a device ID addition.

**Step 2.4: Fix Quality**
The pattern is identical to every other device ID addition in the same
file (MTL, LNL, PTL, WCL, ARL). Trivially correct. Zero regression risk
— the new PCI IDs will only match on Nova Lake hardware.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame** — The PCI table and driver_data structs follow a
clear, consistent pattern established at driver creation.

**Step 3.2: Fixes tag** — N/A, no Fixes: tag.

**Step 3.3: File History** — Recent additions of WCL (`cc54ed51c7617`)
and ARL (`50f1f782f8d62`) IDs follow the exact same pattern. This commit
is standalone.

**Step 3.4: Author** — Even Xu is a regular Intel THC driver contributor
(co-author of the driver itself). The commit was signed off by HID
maintainer Jiri Kosina.

**Step 3.5: Dependencies** — This commit is fully self-contained. It
only adds new entries to existing data structures.

## PHASE 4: MAILING LIST RESEARCH

Skipping deep lore investigation — device ID additions are a well-
established exception category that doesn't require mailing list
analysis to determine stable suitability.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.5:** The change is purely data-driven. No functions are
modified. The PCI ID table is used by the PCI subsystem's device
matching infrastructure, which is well-tested and unchanged. The `nvl`
driver_data struct uses the same `MAX_PACKET_SIZE_VALUE_LNL` as LNL/PTL,
so behavior for NVL devices follows an already-proven code path.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable?**
The Intel THC QuickSPI driver was first introduced in the v6.13→v6.14
cycle. It does NOT exist in LTS trees (6.12.y, 6.6.y, 6.1.y, etc.). It
would only be applicable to stable trees v6.14.y and later.

**Step 6.2: Backport Complications**
For trees where the driver exists, this should apply cleanly. The WCL
and ARL IDs were added after v6.15, so depending on the target stable
tree, those entries may or may not be present, but device ID table
entries are independent and ordering doesn't matter functionally.

**Step 6.3: Related fixes in stable** — No related fixes needed.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** HID subsystem, specifically Intel THC (Touch Host
Controller) for SPI-connected input devices. Criticality: PERIPHERAL —
affects Intel Nova Lake laptop/platform users with THC-connected touch
devices.

**Step 7.2:** The driver is actively developed (new platform IDs being
added regularly).

## PHASE 8: IMPACT AND RISK

**Step 8.1: Affected Users** — Users with Intel Nova Lake hardware with
THC QuickSPI touch devices. Without this patch, touch input devices
won't be recognized on NVL platforms.

**Step 8.2: Trigger** — Device probe at boot or PCI hotplug. Without the
IDs, the device simply won't bind to the driver.

**Step 8.3: Severity** — Without the IDs: touch device doesn't work at
all on NVL hardware. With the IDs: device works normally. This is
hardware enablement, not crash prevention.

**Step 8.4: Risk-Benefit**
- **Benefit**: Enables touch input devices on Nova Lake hardware —
  essential for users of that platform.
- **Risk**: Essentially zero. New PCI IDs only match on new hardware.
  Existing systems are completely unaffected. The driver_data values
  mirror already-proven configurations.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Classic device ID addition — a well-established stable exception
  category
- Trivially small (8 lines added), obviously correct
- Follows identical pattern to all other platform ID additions in the
  same driver
- Zero regression risk — only matches on Nova Lake hardware
- Written by the driver's co-author, signed off by HID maintainer
- Enables real hardware for real users

AGAINST backporting:
- Driver is very new (v6.14), so it's only applicable to recent stable
  trees
- Nova Lake hardware may not be widely deployed yet
- Not fixing a bug — pure hardware enablement

**Step 9.2: Stable Rules Checklist**
1. Obviously correct? **YES** — identical pattern to all other IDs
2. Fixes a real bug? **N/A** — but falls under device ID exception
3. Important issue? **YES** — hardware doesn't work without it
4. Small and contained? **YES** — 8 lines, 2 files, data only
5. No new features/APIs? **YES** — no new interfaces, just enables
   existing driver on new hardware
6. Can apply to stable? **YES** — for trees that contain the driver
   (v6.14+)

**Step 9.3: Exception Category**
**YES — Device ID addition to existing driver.** This is explicitly
listed as a permitted exception in stable kernel rules.

## Verification

- [Phase 1] Parsed tags: SOBs from Even Xu (Intel, driver co-author) and
  Jiri Kosina (HID maintainer). No Fixes/Reported-by tags (expected for
  device ID addition).
- [Phase 2] Diff analysis: +8 lines total. 2 PCI ID defines, 1
  driver_data struct (3 lines + blank), 2 PCI table entries. Data-only
  change, no function modifications.
- [Phase 3] git log: Driver first appeared in v6.14 cycle (commit
  c8f3027dd2a5b). WCL and ARL IDs added after v6.15 with identical
  patterns.
- [Phase 3] git log --author: Even Xu has 15+ commits to THC driver, is
  co-author of the driver.
- [Phase 5] No functions modified — change is purely data
  structures/tables.
- [Phase 6] Driver does NOT exist in LTS trees 6.12.y and earlier. Only
  applicable to v6.14.y+ stable trees.
- [Phase 8] Risk: zero (new PCI IDs only match NVL hardware). Benefit:
  enables touch input on Nova Lake platforms.

This is a textbook device ID addition — small, safe, data-only,
following an established pattern, enabling hardware support on a new
Intel platform. It meets the well-known stable exception for new device
IDs added to existing drivers.

**YES**

 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c | 6 ++++++
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
index ad6bd59963b28..b6a69995692cb 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -37,6 +37,10 @@ struct quickspi_driver_data arl = {
 	.max_packet_size_value = MAX_PACKET_SIZE_VALUE_MTL,
 };
 
+struct quickspi_driver_data nvl = {
+	.max_packet_size_value = MAX_PACKET_SIZE_VALUE_LNL,
+};
+
 /* THC QuickSPI ACPI method to get device properties */
 /* HIDSPI Method: {6e2ac436-0fcf-41af-a265-b32a220dcfab} */
 static guid_t hidspi_guid =
@@ -982,6 +986,8 @@ static const struct pci_device_id quickspi_pci_tbl[] = {
 	{PCI_DEVICE_DATA(INTEL, THC_WCL_DEVICE_ID_SPI_PORT2, &ptl), },
 	{PCI_DEVICE_DATA(INTEL, THC_ARL_DEVICE_ID_SPI_PORT1, &arl), },
 	{PCI_DEVICE_DATA(INTEL, THC_ARL_DEVICE_ID_SPI_PORT2, &arl), },
+	{PCI_DEVICE_DATA(INTEL, THC_NVL_H_DEVICE_ID_SPI_PORT1, &nvl), },
+	{PCI_DEVICE_DATA(INTEL, THC_NVL_H_DEVICE_ID_SPI_PORT2, &nvl), },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, quickspi_pci_tbl);
diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
index c30e1a42eb098..bf5e18f5a5f42 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
@@ -23,6 +23,8 @@
 #define PCI_DEVICE_ID_INTEL_THC_WCL_DEVICE_ID_SPI_PORT2 	0x4D4B
 #define PCI_DEVICE_ID_INTEL_THC_ARL_DEVICE_ID_SPI_PORT1 	0x7749
 #define PCI_DEVICE_ID_INTEL_THC_ARL_DEVICE_ID_SPI_PORT2 	0x774B
+#define PCI_DEVICE_ID_INTEL_THC_NVL_H_DEVICE_ID_SPI_PORT1	0xD349
+#define PCI_DEVICE_ID_INTEL_THC_NVL_H_DEVICE_ID_SPI_PORT2	0xD34B
 
 /* HIDSPI special ACPI parameters DSM methods */
 #define ACPI_QUICKSPI_REVISION_NUM			2
-- 
2.53.0

