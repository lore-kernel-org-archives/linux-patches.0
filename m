Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79F259C97E;
	Mon, 19 Oct 2026 13:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418134; cv=none; b=nAPAHotlRJhh4PikSnYh9NWa+pxxVWsY0HHFlQPDIr50hPbtl8Q1ikQsV3eSw6XMiLZNukLjRpukl45it6KqipSmRFLPBiQtHOl/IsS9yD47jxYL+dtXhvczZRag8REdV+yOb3j4Sg3XMEFM+0KSYSbxYaPa9Hjg5fAGnFaqJBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418134; c=relaxed/simple;
	bh=JWY5s0NzcznvEVRMUF3g5WOssud80Rtf+A6mv0FrZqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WmGgbotuz7RQLjS9LBXRdz3z/jVDJ8aeWx6yHpWtlwhcuX6ut/BtsmnbI+chQ/wg3tFXWQy+8rtKcWKCbNHz3D4rKkx540j3PDspVZgij5IAOPHuvIIbctnNfYMP/DP8eDwWDNRmfx5ixiTC+1pDt/ETf6fYoZjemJjyPpdhq5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0UIiDn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0UIiDn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52791F000C5;
	Mon, 19 Oct 2026 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418131;
	bh=C1vYIvOtaEKvoC6yTdxbg6zObEHO1NwVmzi4NAD+J+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0UIiDn/V5DKMckg1Y+rTrf/FMbOX36IRZsVpVaL/uuEqFy64agi8nRSSzH6grmuH
	 7wap1AatCcC/QFVAggO/50JOWAkgWI0GGRD3J8W2pRUJAbxYNtYSJlS6PNa3cWVuAj
	 rRbkNMdFAPth6eJpnrMq53DHTPk4o9jG8WDmM7DlBkatWgFOut7yWN4fq+rV3HsTOr
	 f2WEt5Qp4C9begWbKGht93kNNdERm8mxEukB++csUXtpRgMZsYBFu+UfxbnZktwZxr
	 DoNOa6KXzSfEVorSSMZcImv8PBFN4JRSGuvRyHeq9tn9jrNoQzjZoSbCO2ZRVQ7kLw
	 jVqAMxA3dHcYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ACPI: FPDT: validate table and record lengths
Date: Mon, 19 Oct 2026 09:45:25 -0400
Message-ID: <20261019135441.1420968-34-sashal@kernel.org>
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

[ Upstream commit 458b40fcdd04a9a0334830de5a536d8425454e4b ]

FPDT records are supplied by firmware and are walked through
length fields stored in the table itself.

Check the main-table entry length before reading an entry, check
the mapped subtable length before remapping it, and check each
record length before saving a typed record pointer for sysfs.

This keeps malformed firmware records from being interpreted as
complete resume, suspend, or boot records when the current item
is shorter than the structure consumed by the driver.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706094141.82438-1-pengpeng@iscas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough verified history, diff, and review context to judge this
against the local 7.3-rc4 tree.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[ACPI / FPDT] [validate] check firmware-supplied FPDT
table/record lengths before walking them or exposing typed records via
sysfs**

**Step 1.2: Tags**
Record:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Link:
  https://patch.msgid.link/20260706094141.82438-1-pengpeng@iscas.ac.cn`
- `Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>` (ACPI
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence expected here)
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  ...]` markers

**Step 1.3: Body**
Record:
- **Bug:** FPDT entries/records are walked using length fields supplied
  by firmware. The driver previously trusted those lengths.
- **Symptom:** A truncated/malformed record can be treated as a full
  resume, suspend, or boot record. Sysfs then consumes a larger C struct
  than the firmware item actually occupies.
- **Root cause:** Missing bounds checks before mapping the subtable,
  before advancing the walker, and before storing typed pointers.
- **Versions:** none stated. Introduced with FPDT support, not by a
  later feature.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. It is an explicit firmware bounds-check plus a
signature-mismatch unmap. That is a real OOB/leak fix, not style
cleanup.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/acpi/acpi_fpdt.c` only (`+47 / -6`)
- Functions: `fpdt_process_subtable()`, `acpi_init_fpdt()`
- Scope: single-file surgical fix

**Step 2.2: Code flow**
Record (verified against parent `458b40fcdd04a^`):

1. **Signature mismatch:** mapped header was returned without unmap →
   now unmaps (fixes ioremap leak).
2. **Subtable remap:** `length` from firmware was passed to
   `acpi_os_map_memory()` with no lower bound → reject if `length <
   sizeof(*subtable_header)`.
3. **Record walk:** header was read and `offset +=
   record_header->length` before checking remaining space; only zero
   length was rejected (`a83c68a3bf7c4`) → require a full header,
   `length >= sizeof(header)`, and `length <= remaining`; zero is still
   rejected because `sizeof(*record_header)` is 4.
4. **Typed records:** `RECORD_S3_RESUME` / `SUSPEND` / `BOOT` stored
   pointers used by sysfs (`sizeof` 24 / 20 / 48) with no size check →
   reject if the firmware length is smaller than the struct.
5. **Main FPDT table:** walker did `offset += sizeof(*subtable)` with no
   leftover-bytes check → reject truncated/invalid entry lengths, then
   advance by `subtable->length` (spec length field).

**Step 2.3: Bug mechanism**
Record:
- **Category:** memory safety (OOB read) + resource leak
- **Mechanism:** firmware-controlled lengths were used as cursor and as
  justification to treat a short blob as a full
  `resume_performance_record` / `suspend_performance_record` /
  `boot_performance_record`. Sysfs `*_show` helpers then read fields
  past the real record. Truncated headers could also read past the
  mapped subtable.

**Step 2.4: Fix quality**
Record: Obviously correct, localized, no API/feature change. Regression
risk is low. The one behavioral change is walking the main table by
`subtable->length` instead of a fixed 16-byte stride. Spec pointer
records are 16 bytes (`struct fpdt_subtable_entry` /
`acpi_fpdt_boot_pointer`). Firmware with a garbage non-zero length in an
otherwise packed 16-byte table could now skip or fail FPDT init instead
of parsing later entries; that fails closed (no FPDT sysfs), not a
kernel crash. No follow-up on this file after `458b40fcdd04a`.

## Phase 3: Git history

**Step 3.1: Blame**
Record: Buggy walker comes from `d1eb86e59be09` (“ACPI: tables:
introduce support for FPDT table”, 2021-01-29), first in **v5.12-rc1**.
Zero-length hang was later fixed by `a83c68a3bf7c4` (2023), which did
**not** check truncated non-zero lengths or typed-struct size.

**Step 3.2: Fixes: tag**
Record: none. The incomplete predecessor is `a83c68a3bf7c4` (`Fixes:
d1eb86e59be0`, `Cc: stable`). That confirms the class (malformed FPDT
firmware) is real; this commit finishes the length checks.

**Step 3.3: File history**
Record (newest first):
- `458b40fcdd04a` this commit
- `8dcb4485e7672` expose FBPT/S3PT via sysfs (already in this tree;
  ancestor of the fix)
- `a83c68a3bf7c4` zero-length / invalid subtables
- `211391bf04b3c` invalid phys address
- `d1eb86e59be09` introduce driver

Standalone length-validation patch, not `N/M`.

**Step 3.4: Author**
Record: Pengpeng Hou; same period also `2c50ffdc73f3a` “ACPI: processor:
validate MADT IOAPIC entry bounds” (same firmware-table bounds pattern).
Not the ACPI maintainer; Rafael applied it.

**Step 3.5: Dependencies**
Record: No extra helpers. Needs the FPDT driver (`d1eb86e59be09`),
present here. `8dcb4485e7672` is already an ancestor (`git merge-base
--is-ancestor` succeeded). Can apply in this tree; it is already an
ancestor of HEAD.

## Phase 4: Mailing list / external

**Step 4.1:** `b4 dig -c 458b40fcdd04a` →
https://patch.msgid.link/20260706094141.82438-1-pengpeng@iscas.ac.cn
`b4 dig -a`: **v1 only**. Thread saved to mbox (2 messages).
Rafael: **“Applied as 7.3 material, thanks!”** No NAK, no requested
respin, no `Cc: stable` in review.

**Step 4.2:** `b4 dig -w` recipients: Pengpeng Hou, Rafael J. Wysocki,
Len Brown, linux-acpi, linux-kernel. Maintainer was on To/Cc and merged
it.

**Step 4.3:** No bugzilla/syzbot/Reported-by. No extra crash report
beyond the commit text. Related real hardware: `a83c68a3bf7c4` already
documented buggy FPDT BIOS tables (zero-length S3PT record, duplicated
FBPT signature).

**Step 4.4:** Not a multi-patch series.

**Step 4.5:** lore.kernel.org/stable search returned HTTP 403.
**UNVERIFIED:** whether stable@ discussed this hash.

## Phase 5: Semantic / reachability

**Step 5.1:** `fpdt_process_subtable`, `acpi_init_fpdt`.

**Step 5.2:** `acpi_init_fpdt` is `fs_initcall`; only caller of
`fpdt_process_subtable` is that init function. Boot path, not
interrupt/hot path.

**Step 5.3:** `acpi_get_table` / `acpi_os_map_memory` /
`acpi_os_unmap_memory` / `sysfs_create_group`. Records are later read by
sysfs `*_show` using `record_boot` / `record_suspend` / `record_resume`.

**Step 5.4:** Reachable when `CONFIG_ACPI_FPDT=y` and firmware publishes
FPDT. Userspace cannot craft the ACPI table on a locked-down platform;
VMs and broken BIOS can. Sysfs is the consumer of the typed pointers.

**Step 5.5:** Same pattern as the author’s MADT IOAPIC length checks.
Prior FPDT fix only handled length==0.

## Phase 6: This checkout

**Step 6.1:** `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**.
`make kernelversion` → **7.3.0-rc4**.
`git merge-base --is-ancestor 458b40fcdd04a HEAD` → yes.
Current `drivers/acpi/acpi_fpdt.c` already contains the new checks
(lines 190–219, 223–226, 243–246, 262–265, 347–360, 374).
Buggy walker has existed in this lineage since v5.12.

**Step 6.2:** Backport difficulty **clean apply** here (already merged).
No later conflicting edits on this file.

**Step 6.3:** Related fix `a83c68a3bf7c4` is present (zero-length only).
It does not replace this patch.

## Phase 7: Subsystem

**Step 7.1:** ACPI FPDT driver under `drivers/acpi/`. **IMPORTANT**
(common x86_64/ARM64/LOONGARCH firmware table), not mm/core.
`CONFIG_ACPI_FPDT` is opt-in (`bool`, not `default y`); local `.config`
has it unset. Not staging.

**Step 7.2:** File is mature (2021–2026, few commits). This is hardening
of long-standing parse code, not a brand-new subsystem.

## Phase 8: Impact and risk

**Step 8.1:** Users who enable `CONFIG_ACPI_FPDT` on
x86_64/ARM64/LOONGARCH and whose firmware exposes FPDT. Not universal.

**Step 8.2:** Trigger is boot-time FPDT parse (`fs_initcall`) with a
malformed table. Unprivileged userspace cannot normally inject ACPI
tables; broken BIOS and untrusted VM firmware can. Real malformed FPDT
firmware is already documented.

**Step 8.3:** Failure mode:
- Read past mapped subtable → possible oops during boot
  (**HIGH/CRITICAL** if it faults)
- Short record accepted → sysfs reads adjacent firmware bytes (wrong
  data / info leak, **HIGH** memory-safety)
- Signature-mismatch ioremap leak at init (**LOW**, one-shot)

Severity: **HIGH** (firmware-controlled OOB on an enabled driver).

**Step 8.4:** Benefit high for FPDT-enabled systems with bad tables;
risk low (47 lines, fail closed, maintainer-acked, no revert).

## Phase 9: Synthesis

**For backporting**
- Firmware-supplied lengths used as walk cursor and as struct size:
  classic OOB.
- Completes a known FPDT firmware-bug class (`a83c68a3bf7c4` already
  proved bad BIOSes and was sent to stable).
- Also fixes a real `acpi_os_map_memory` leak on signature mismatch.
- Small, single-file, obviously correct; Rafael merged it.
- Driver and buggy code exist in this tree; no missing prerequisites.

**Against**
- No crash log / syzbot / `Fixes:` / explicit stable nomination.
- `CONFIG_ACPI_FPDT` is opt-in, not defconfig.
- Rafael labeled it “7.3 material,” not stable, but that is merge-window
  wording, not a NAK of the bug.
- Main-table walk-by-length could hide later entries if firmware lies
  about length; fail-closed.

**Unresolved**
- UNVERIFIED: stable@ thread (lore 403).
- UNVERIFIED: which distros set `CONFIG_ACPI_FPDT=y`.

**Stable rules**
1. Obviously correct and tested? **PASS** (v1 applied as-is by ACPI
   maintainer; in 7.3-rc4 with no follow-up revert).
2. Real user-affecting bug? **PASS** (OOB + leak on firmware tables;
   prior FPDT BIOS bugs in the wild).
3. Important (crash/security/corruption/deadlock)? **PASS** (OOB read
   from firmware lengths; possible oops or sysfs leak).
4. Small/contained? **PASS** (`+47/-6`, one file).
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS**.

**Exception category:** none required (not a device-
ID/quirk/DT/build/doc exception). It is a straightforward memory-safety
fix.

This tree is **7.3.0-rc4**. The FPDT walker has been here since v5.12,
so the bug is in this lineage. The patch is small, correct, and prevents
firmware-controlled out-of-bounds reads (and an ioremap leak) in
`acpi_init_fpdt`. That meets stable criteria for this checkout.

### Verification
- [Phase 1] Parsed tags: author SOB, Rafael SOB, msgid Link; no
  Fixes/Reported-by/Cc stable
- [Phase 2] `git show 458b40fcdd04a`: +47/-6 in
  `drivers/acpi/acpi_fpdt.c`; parent walker lacked remaining/size
  checks; signature path leaked the map
- [Phase 2] Struct sizes: header 4, resume 24, suspend 20, boot 48,
  subtable entry 16
- [Phase 3] `git blame`: checks from `458b40fcdd04a`; original walker
  `d1eb86e59be09` (v5.12-rc1)
- [Phase 3] `git merge-base --is-ancestor 458b40fcdd04a HEAD` → 0
  (present)
- [Phase 3] `a83c68a3bf7c4` only handled zero length; `Cc: stable` on
  that older hang fix
- [Phase 3] `8dcb4485e7672` is ancestor; no later commits on this file
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; Rafael “Applied as 7.3
  material, thanks!”; lists linux-acpi + Rafael + Len Brown
- [Phase 4] lore.kernel.org WebFetch/curl → 403; stable@ discussion
  UNVERIFIED
- [Phase 5] `acpi_init_fpdt` is `fs_initcall`; only caller of
  `fpdt_process_subtable`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; current
  file already has the validation
- [Phase 7] `CONFIG_ACPI_FPDT` depends on X86_64||ARM64||LOONGARCH, not
  default y
- [Phase 8] Failure mode: firmware OOB on FPDT parse / sysfs typed reads
- UNVERIFIED: distro `CONFIG_ACPI_FPDT` defaults; stable@ mailing-list
  history

**YES**

 drivers/acpi/acpi_fpdt.c | 53 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_fpdt.c b/drivers/acpi/acpi_fpdt.c
index 271092f2700a1..058d1ad47699a 100644
--- a/drivers/acpi/acpi_fpdt.c
+++ b/drivers/acpi/acpi_fpdt.c
@@ -165,7 +165,7 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 	struct fpdt_subtable_header *subtable_header;
 	struct fpdt_record_header *record_header;
 	char *signature = (subtable_type == SUBTABLE_FBPT ? "FBPT" : "S3PT");
-	u32 length, offset;
+	u32 length, offset, remaining;
 	int result;
 
 	if (!fpdt_address_valid(address)) {
@@ -179,10 +179,17 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 
 	if (strncmp((char *)&subtable_header->signature, signature, 4)) {
 		pr_info(FW_BUG "subtable signature and type mismatch!\n");
+		acpi_os_unmap_memory(subtable_header, sizeof(*subtable_header));
 		return -EINVAL;
 	}
 
 	length = subtable_header->length;
+	if (length < sizeof(*subtable_header)) {
+		pr_err(FW_BUG "Invalid FPDT subtable length %u.\n", length);
+		acpi_os_unmap_memory(subtable_header, sizeof(*subtable_header));
+		return -EINVAL;
+	}
+
 	acpi_os_unmap_memory(subtable_header, sizeof(*subtable_header));
 
 	subtable_header = acpi_os_map_memory(address, length);
@@ -191,17 +198,29 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 
 	offset = sizeof(*subtable_header);
 	while (offset < length) {
-		record_header = (void *)subtable_header + offset;
-		offset += record_header->length;
+		remaining = length - offset;
+		if (remaining < sizeof(*record_header)) {
+			pr_err(FW_BUG "Truncated FPDT record header.\n");
+			result = -EINVAL;
+			goto err;
+		}
 
-		if (!record_header->length) {
-			pr_err(FW_BUG "Zero-length record found in FPTD.\n");
+		record_header = (void *)subtable_header + offset;
+		if (record_header->length < sizeof(*record_header) ||
+		    record_header->length > remaining) {
+			pr_err(FW_BUG "Invalid FPDT record length %u.\n",
+			       record_header->length);
 			result = -EINVAL;
 			goto err;
 		}
+		offset += record_header->length;
 
 		switch (record_header->type) {
 		case RECORD_S3_RESUME:
+			if (record_header->length < sizeof(*record_resume)) {
+				result = -EINVAL;
+				goto err;
+			}
 			if (subtable_type != SUBTABLE_S3PT) {
 				pr_err(FW_BUG "Invalid record %d for subtable %s\n",
 				     record_header->type, signature);
@@ -218,6 +237,10 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 				goto err;
 			break;
 		case RECORD_S3_SUSPEND:
+			if (record_header->length < sizeof(*record_suspend)) {
+				result = -EINVAL;
+				goto err;
+			}
 			if (subtable_type != SUBTABLE_S3PT) {
 				pr_err(FW_BUG "Invalid %d for subtable %s\n",
 				     record_header->type, signature);
@@ -233,6 +256,10 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 				goto err;
 			break;
 		case RECORD_BOOT:
+			if (record_header->length < sizeof(*record_boot)) {
+				result = -EINVAL;
+				goto err;
+			}
 			if (subtable_type != SUBTABLE_FBPT) {
 				pr_err(FW_BUG "Invalid %d for subtable %s\n",
 				     record_header->type, signature);
@@ -289,7 +316,21 @@ static int __init acpi_init_fpdt(void)
 	}
 
 	while (offset < header->length) {
+		if (header->length - offset < sizeof(*subtable)) {
+			pr_err(FW_BUG "Truncated FPDT subtable entry.\n");
+			result = -EINVAL;
+			goto err_subtable;
+		}
+
 		subtable = (void *)header + offset;
+		if (subtable->length < sizeof(*subtable) ||
+		    subtable->length > header->length - offset) {
+			pr_err(FW_BUG "Invalid FPDT subtable entry length %u.\n",
+			       subtable->length);
+			result = -EINVAL;
+			goto err_subtable;
+		}
+
 		switch (subtable->type) {
 		case SUBTABLE_FBPT:
 		case SUBTABLE_S3PT:
@@ -302,7 +343,7 @@ static int __init acpi_init_fpdt(void)
 			/* Other types are reserved in ACPI 6.4 spec. */
 			break;
 		}
-		offset += sizeof(*subtable);
+		offset += subtable->length;
 	}
 	return 0;
 err_subtable:
-- 
2.53.0

