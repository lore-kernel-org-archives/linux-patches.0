Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FB4548571;
	Mon, 31 Aug 2026 13:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183988; cv=none; b=ZaID656pZtiaw9rUhNwkXc7qtVhyhZ1FFHSE1YRYcLqmD3Ks9fb8hFd7fVc10hlo8RGz060WS6Ev6wgSd5Z9piGA+qkDQTvqFnCbNNuEldiaJhUg59xSdUEA8hM6h5cG33w0q/+AtwuxaUfWW7GZIDiuYXsQp4Tc5y3YZmhuL98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183988; c=relaxed/simple;
	bh=cVZ7QEa6jUc7nJxxh5CxUQ4T3B7T/L9Jksl4XIGOjP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nze8nIk9k+eNmbCImaMKA+jWf2ECwkwlO+rg1JDAFiuYYCDZaQO3TGVMagEAxYh3yjU2zYax5UDpLoFvnS+uyszu8BpKXEVuivH2IqA157jHNW0Re3oQflU0Apvsg0p0OJOx3TekHNmTqavwWSXS9vLgOi6yl0vB/vKREAfPGC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmAO/iXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmAO/iXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CA21F01558;
	Mon, 31 Aug 2026 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183983;
	bh=beFY3W2U/zL1MNuJiPO6R55UvPAKdfIbCF/BE1eerSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmAO/iXX7IfqS9Mta7rjbGcEuRGrMzV8JTDv9tsHQHDbQEMS7ZExgOclOd/ES/iTZ
	 qmwX2JsCa8p97FVGnBRKuEBsqUaaa4MUnHlq0YiUaA+nnM2XGfj+P5PBQ4AbT/z+kj
	 BGDYnTJ9dkwRjNm4Wk0rf8xkkZ3KTnxHG8CoWxZ+ugotMx5gZkGH/Rp9mQbhu9DJFc
	 Dg2/Ee5d3yiU97QhwJrQpWEDcHfNReHaYYvDslxfVtWSI8bcUqnFWnRUe6Ai3NQ8eg
	 A+m8GwLHiyloIH8TSxf3SIFs/DRNjLt5ehySlTvjttUqT46LXgUCObaBMTjQMTrKDl
	 F/0O7ZUl6At6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amdgpu: harden FRU PIA parsing with bounded helpers
Date: Mon, 31 Aug 2026 09:27:28 -0400
Message-ID: <20260831133314.4125787-420-sashal@kernel.org>
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

From: "Stanley.Yang" <Stanley.Yang@amd.com>

[ Upstream commit c990c05eb6c74c98d1ff3acf67a19015312820b7 ]

Replace the open-coded TLV walk with fru_pia_advance()
and fru_pia_copy_field() helpers that bound every read
by the actual EEPROM data length, preventing out-of-bounds
reads on truncated or malformed FRU data.

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[drm/amdgpu]` `[harden]` — Harden FRU (Field Replaceable
Unit) Product Info Area (PIA) parsing by replacing open-coded TLV
walking with bounded helper functions.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Tao Zhou \<tao.zhou1@amd.com\>
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable@vger.kernel.org:** — absent (not a negative signal)
- **Signed-off-by:** Stanley.Yang \<Stanley.Yang@amd.com\>, Alex Deucher
  \<alexander.deucher@amd.com\> (ignore pipeline SOBs)

Notable: reviewed by AMD developer; no fuzzer or user bug reports cited.

### Step 1.3: ANALYZE COMMIT BODY
**Record:**
- **Bug described:** Open-coded TLV walk in FRU PIA parsing does not
  bound reads against actual EEPROM buffer length; truncated or
  malformed FRU data can cause out-of-bounds reads.
- **Symptom/failure mode:** Out-of-bounds kernel memory reads when
  parsing malformed/truncated FRU EEPROM TLV fields.
- **Version info:** none stated.
- **Root cause:** TLV cursor advancement (`addr += 1 + (pia[addr] &
  0x3F)`) and `memcpy()` use field-length bytes without ensuring the
  cursor and copy length stay within the allocated `pia` buffer (`len`).

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit memory-safety hardening
fix. "Harden" and "preventing out-of-bounds reads" clearly describe a
buffer over-read bug fix, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c` only (~37
  lines added helpers, ~43 lines changed in parsing loop; net ~+37/-6 in
  parsing region)
- **Functions added:** `fru_pia_advance()`, `fru_pia_copy_field()`
- **Functions modified:** `amdgpu_fru_get_product_info()`
- **Scope:** single-file, surgical fix within one parsing function

### Step 2.2: CODE FLOW CHANGE (per hunk)
**Record:**

1. **New helpers (before `amdgpu_fru_get_product_info`):**
   - *Before:* no shared TLV walking helpers.
   - *After:* `fru_pia_advance()` checks `*addr >= len` before reading
     `pia[*addr]`; `fru_pia_copy_field()` validates header presence and
     uses `min3(field_len, dst_size-1, len-addr-1)` for bounded
     `memcpy()`.

2. **Manufacturer/product/serial/fru_id field extraction:**
   - *Before:* `if (addr + 1 >= len) goto Out` then `memcpy(...,
     min_t(sizeof(dst), pia[addr] & 0x3F))`; advances via `addr += 1 +
     (pia[addr] & 0x3F)` often without prior bounds check.
   - *After:* each field uses `fru_pia_copy_field()` (bounded copy) and
     `fru_pia_advance()` (bounded advance); failure jumps to `Out`.

3. **Skip fields (Product Version, Asset Tag):**
   - *Before:* unconditional `addr += 1 + (pia[addr] & 0x3F)` with no
     bounds check (lines 251, 254, 262, 265 in current tree).
   - *After:* `fru_pia_advance()` returns false on overrun, triggering
     `goto Out`.

### Step 2.3: BUG MECHANISM
**Record:** **Category:** buffer over-read / out-of-bounds access.

**Specific mechanisms in current 6.18.44 code:**

1. **Unchecked TLV advance** — e.g. at lines 251–254:
```250:255:drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
        /* Go to the Product Version field. */
        addr += 1 + (pia[addr] & 0x3F);

        /* Go to the Product Serial Number field. */
        addr += 1 + (pia[addr] & 0x3F);
```
   If `addr` is near `len` or a prior field length is inflated,
`pia[addr]` reads past the kmalloc buffer.

2. **Unbounded memcpy** — e.g. at lines 227–229:
```227:229:drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
        memcpy(fru_info->manufacturer_name, pia + addr + 1,
               min_t(size_t, sizeof(fru_info->manufacturer_name),
                     pia[addr] & 0x3F));
```
   Copy length is capped by destination size and TLV length byte, but
**not** by remaining buffer bytes (`len - addr - 1`). A field claiming
63 bytes with only a few bytes remaining causes OOB read.

Checksum validation (lines 211–217) does not prevent structurally
inconsistent TLV lengths within a checksum-valid PIA.

### Step 2.4: FIX QUALITY
**Record:**
- Fix is obviously correct: every read/advance is bounded by `len`.
- Minimal scope: adds two static helpers, replaces inline parsing.
- Low regression risk: same parsing logic, stricter bounds; failure
  paths already go to `Out` and return 0.
- `min3()` exists in this tree (`include/linux/minmax.h`).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- Buggy TLV walk introduced in `0dbf2c5626253` ("drm/amdgpu: Interpret
  IPMI data for product information (v2)", 2022-11-17) by Luben Tuikov.
- Field additions in `ac6b1f275f17b` and `8a2b51392ac4a` (2023-10-04)
  retained the same unchecked advance pattern.
- Prior OOB-related FRU fix: `02b865f88b4e4` (2021), `00b14ce075732`
  (2022) — shows this subsystem has a history of bounds fixes.
- Bug present since ~6.2; confirmed present in this 6.18.44 tree.

### Step 3.2: FOLLOW Fixes: TAG
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: FILE HISTORY FOR RELATED CHANGES
**Record:** Recent FRU commits in tree include `fd0c6bd82d19c` (increase
FRU File Id buffer), `25907304cfce5` (fetch FRU for smu_v13_0_12),
`a8558fce7ad0c` (avoid FRU on APU). No existing bounded-TLV fix found.
Standalone fix, not part of a multi-patch series in this tree.

### Step 3.4: AUTHOR'S OTHER COMMITS
**Record:** Stanley.Yang has multiple amdgpu commits (RAS, VCN, eeprom
fixes) but is not the original FRU author. Reviewed by Tao Zhou; signed
off by Alex Deucher (amdgpu maintainer).

### Step 3.5: DEPENDENT/PREREQUISITE COMMITS
**Record:** No prerequisites identified. Commit not in this tree
(candidate only). Diff context shows `kzalloc_obj()` on mainline; local
tree uses `kzalloc(sizeof(*adev->fru_info), GFP_KERNEL)` — PIA parsing
portion applies independently. No dependency on missing code structures.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: ORIGINAL PATCH DISCUSSION
**Record:** Commit hash not in local tree; `b4 dig -c` cannot be run.
`b4 dig -S` is not supported. Lore.kernel.org search blocked by anti-bot
page. **UNVERIFIED:** original submission thread, series revisions,
reviewer stable nominations.

### Step 4.2: REVIEWERS
**Record:** **UNVERIFIED** via b4 -w. Commit message lists Reviewed-by:
Tao Zhou, Signed-off-by: Alex Deucher.

### Step 4.3: BUG REPORT
**Record:** No Reported-by, Link, or syzbot reference. No external bug
report to follow.

### Step 4.4: RELATED PATCHES/SERIES
**Record:** Appears standalone. Related historical fixes in same file
(`02b865f`, `00b14ce`) addressed similar OOB concerns in older FRU
parsing code.

### Step 4.5: STABLE MAILING LIST
**Record:** **UNVERIFIED** — lore search unavailable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
**Record:** `fru_pia_advance()`, `fru_pia_copy_field()` (new);
`amdgpu_fru_get_product_info()` (modified).

### Step 5.2: TRACE CALLERS
**Record:**
- `amdgpu_fru_get_product_info()` called from `amdgpu_device_init()` at
  line 3307 of `amdgpu_device.c`.
- `amdgpu_device_init()` called from `amdgpu_driver_load_kms()` in
  `amdgpu_kms.c` line 148.
- **Context:** GPU driver probe/load path during PCI/DRM device
  initialization.
- `amdgpu_fru_sysfs_init()` at line 4873 exposes sysfs attributes but
  does not re-parse FRU data.

### Step 5.3: TRACE CALLEES
**Record:** `is_fru_eeprom_supported()`, `amdgpu_eeprom_read()`,
`kzalloc()`, `kfree()`, `memcpy()`, `sprintf()` (default serial),
`dev_err()`.

### Step 5.4: CALL CHAIN / REACHABILITY
**Record:** PCI probe → `amdgpu_driver_load_kms()` →
`amdgpu_device_init()` → `amdgpu_fru_get_product_info()` → PIA TLV
parse. Triggered on every boot for supported AMD server GPUs with
accessible FRU EEPROM. Not directly userspace-syscall reachable, but
runs automatically on driver load when hardware matches (Vega20 server
SKUs, D603, Aldebaran, SMU v13.0.6/v13.0.14, etc.).

### Step 5.5: SIMILAR PATTERNS
**Record:** Same unchecked `addr += 1 + (pia[addr] & 0x3F)` pattern
repeated 6+ times in current code. AMD previously fixed similar FRU OOB
issues in `02b865f88b4e4` and `00b14ce075732`.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: DOES BUGGY CODE EXIST?
**Record:** **YES.** Local tree is **v6.18.44 / 6.18.44**.
`amdgpu_fru_eeprom.c` lines 220–270 contain the vulnerable unchecked TLV
walk. Bug introduced November 2022 (`0dbf2c5626253`), well before 6.18
branch.

### Step 6.2: BACKPORT COMPLICATIONS
**Record:** Expected **clean apply** for the PIA parsing helpers and
loop replacement. Minor context difference: mainline diff shows
`kzalloc_obj()` but local tree uses `kzalloc()` — unrelated to the fix
hunks. No significant refactoring conflicts in recent file history
(`a3e510fd69c31` dev_* conversion is already present).

### Step 6.3: RELATED FIXES ALREADY PRESENT?
**Record:** No `fru_pia_advance`/`fru_pia_copy_field` or "harden FRU
PIA" commit in tree. `git log --grep='harden FRU'` returned empty. Fix
not yet applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
**Record:** **Subsystem:** `drm/amdgpu` driver — FRU EEPROM parsing for
AMD server GPUs. **Criticality:** PERIPHERAL (hardware-specific,
server/datacenter GPUs only), but touches kernel memory safety during
probe.

### Step 7.2: SUBSYSTEM ACTIVITY
**Record:** File actively maintained — 20+ commits since 2022, most
recent in 2025 (dev_* conversion, SMU v13.0.12 support).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
**Record:** Users of AMD server GPUs with FRU EEPROM support (Vega20
D161/D163, Instinct MI D603, Aldebaran, SMU v13.0.6/v13.0.14, etc.). Not
APUs, not VF, not all consumer cards. Config/hardware-specific, but real
production datacenter hardware.

### Step 8.2: TRIGGER CONDITIONS
**Record:** Malformed, truncated, or internally inconsistent FRU Product
Info Area TLV data in on-card EEPROM. Occurs during driver probe
(boot/module load). Not userspace-triggerable directly; requires
corrupt/tampered EEPROM or hardware/firmware fault. Moderately rare but
plausible (manufacturing errors, EEPROM corruption, physical tampering
on servers).

### Step 8.3: FAILURE MODE SEVERITY
**Record:** Out-of-bounds read from kmalloc'd PIA buffer during GPU
init. Potential KASAN splat, kernel oops during probe, or information
leak from adjacent heap data. Severity: **HIGH** for affected hardware
(memory safety during init); **MEDIUM** overall due to narrow
hardware/trigger scope. Does not cause silent data corruption of user
files.

### Step 8.4: RISK-BENEFIT
**Record:**
- **Benefit:** MEDIUM — closes real OOB read in server GPU probe path;
  aligns with prior FRU bounds fixes AMD has shipped.
- **Risk:** LOW — small, reviewed, behavior-preserving with stricter
  bounds.
- **Ratio:** Benefit outweighs risk for 6.18.y.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILED

**FOR backport:**
- Real, verifiable OOB read bug in current 6.18.44 code (unchecked TLV
  advance + unbounded memcpy).
- Fixes memory safety during GPU driver probe on affected server
  hardware.
- Small, single-file, obviously correct bounded helpers.
- Reviewed by AMD developer; signed off by amdgpu maintainer (Alex
  Deucher).
- Same file had prior OOB fixes backported historically.
- Bug present since 2022; code exists in this tree.
- `min3()` available; patch should apply cleanly.

**AGAINST backport:**
- No syzbot report, no user bug report, no CVE cited.
- Very limited hardware population (AMD server GPUs with FRU EEPROM).
- Requires malformed EEPROM data — not commonly triggered.
- Not directly exploitable from userspace.
- Mailing list review context unverified.

**UNRESOLVED:**
- Original lore discussion and whether reviewers nominated for stable.
- Whether any production incident motivated this fix.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — logic is clear; reviewed by
   AMD; no Tested-by but mechanism is verifiable by inspection.
2. Fixes a real bug affecting users? **PASS** — OOB read on server GPU
   probe with malformed FRU data.
3. Important issue? **PASS** — kernel memory safety / potential oops
   during init (HIGH for affected systems).
4. Small and contained? **PASS** — one file, ~40 lines of meaningful
   change.
5. No new features or APIs? **PASS** — parsing hardening only.
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   clean apply expected.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None directly (not device ID, quirk, DT, build fix, or
docs). Standard memory-safety bug fix.

### Step 9.4: DECISION RATIONALE

For **linux-6.18.y** (this checkout): the vulnerable FRU PIA parsing
code is present and has been since the 2022 IPMI rewrite. The fix
addresses a concrete out-of-bounds read that can occur when TLV length
fields in FRU EEPROM data are inconsistent with the actual buffer size —
a scenario checksum validation does not prevent. While the affected
hardware base is narrow (AMD server GPUs), memory-safety fixes in probe
paths are appropriate stable material, especially given AMD's prior
history of backporting similar FRU bounds fixes. The patch is small,
reviewed, and low-risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body: hardening fix for OOB reads;
  Reviewed-by Tao Zhou; no Reported-by/syzbot.
- [Phase 2] Read full diff and current `amdgpu_fru_eeprom.c`: confirmed
  unchecked advances at lines 251, 254, 262, 265 and unbounded memcpy at
  227–229, 237–238, etc.
- [Phase 2] Verified `min3` exists in `include/linux/minmax.h`.
- [Phase 3] `git blame -L 220,270`: buggy walk from `0dbf2c5626253`
  (2022-11-17).
- [Phase 3] `git log --oneline -20 -- amdgpu_fru_eeprom.c`: no existing
  bounded-helper fix.
- [Phase 3] `git log --grep='harden FRU'`: empty (commit not in tree).
- [Phase 3] `git show 00b14ce075732`, `git show 02b865f88b4e4`: prior
  FRU OOB fixes confirmed.
- [Phase 4] `b4 dig -c`: **UNVERIFIED** — commit not in tree.
- [Phase 4] Lore search: **UNVERIFIED** — blocked by anti-bot page.
- [Phase 5] `grep amdgpu_fru_get_product_info`: callers in
  `amdgpu_device.c:3307`, init via `amdgpu_kms.c:148`.
- [Phase 6] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44.
- [Phase 6] Read `amdgpu_fru_eeprom.c` lines 220–270: buggy code
  confirmed present.
- [Phase 6] `git merge-base --is-ancestor 0dbf2c5626253 HEAD`: buggy
  code ancestor in tree.
- [Phase 8] Failure mode: OOB kernel read during probe; severity HIGH
  (affected hw) / MEDIUM (overall).

**YES**The background search finished: `git log --grep='harden FRU'`,
`--grep='bounded helpers'`, and `--grep='fru_pia'` all returned nothing,
so this fix is not in the local **6.18.44** tree yet.

That matches what we saw in the file — `amdgpu_fru_eeprom.c` still has
the unchecked TLV walk (e.g. unguarded `addr += 1 + (pia[addr] & 0x3F)`
around lines 251–265).

**Verdict for linux-6.18.y: YES** — real out-of-bounds read on malformed
FRU EEPROM data during server GPU probe; small, reviewed hardening fix
that should apply cleanly.

 .../gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c    | 95 ++++++++++++-------
 1 file changed, 63 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
index b0082aa7f3c61..2875627dce8e9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
@@ -114,6 +114,43 @@ static bool is_fru_eeprom_supported(struct amdgpu_device *adev, u32 *fru_addr)
 	}
 }
 
+/*
+ * IPMI FRU Product Info Area fields are TLV: one type/length byte
+ * (low 6 bits = data length) followed by that many data bytes. These
+ * helpers walk the cursor and copy a single field while bounding all
+ * accesses to the actual buffer length read from the EEPROM.
+ */
+#define FRU_FIELD_LEN(p, a)	((p)[a] & 0x3F)
+
+/* Advance cursor past the current TLV. Returns false if no more data. */
+static bool fru_pia_advance(u32 *addr, const unsigned char *pia, int len)
+{
+	if (*addr >= (u32)len)
+		return false;
+	*addr += 1 + FRU_FIELD_LEN(pia, *addr);
+	return true;
+}
+
+/*
+ * Copy the current TLV's data into dst (NUL-terminated). Returns false if
+ * the TLV header or data would read past the end of pia.
+ */
+static bool fru_pia_copy_field(char *dst, size_t dst_size,
+			       const unsigned char *pia, u32 addr, int len)
+{
+	size_t fl;
+
+	if (addr + 1 >= (u32)len)
+		return false;
+
+	fl = min3((size_t)FRU_FIELD_LEN(pia, addr),
+			  dst_size - 1,
+			  (size_t)(len - addr - 1));
+	memcpy(dst, pia + addr + 1, fl);
+	dst[fl] = '\0';
+	return true;
+}
+
 int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 {
 	struct amdgpu_fru_info *fru_info;
@@ -222,52 +259,46 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 	 * Read Manufacturer Name field whose length is [3].
 	 */
 	addr = 3;
-	if (addr + 1 >= len)
+	if (!fru_pia_copy_field(fru_info->manufacturer_name,
+				sizeof(fru_info->manufacturer_name),
+				pia, addr, len))
 		goto Out;
-	memcpy(fru_info->manufacturer_name, pia + addr + 1,
-	       min_t(size_t, sizeof(fru_info->manufacturer_name),
-		     pia[addr] & 0x3F));
-	fru_info->manufacturer_name[sizeof(fru_info->manufacturer_name) - 1] =
-		'\0';
 
 	/* Read Product Name field. */
-	addr += 1 + (pia[addr] & 0x3F);
-	if (addr + 1 >= len)
+	if (!fru_pia_advance(&addr, pia, len) ||
+	    !fru_pia_copy_field(fru_info->product_name,
+				sizeof(fru_info->product_name),
+				pia, addr, len))
 		goto Out;
-	memcpy(fru_info->product_name, pia + addr + 1,
-	       min_t(size_t, sizeof(fru_info->product_name), pia[addr] & 0x3F));
-	fru_info->product_name[sizeof(fru_info->product_name) - 1] = '\0';
 
 	/* Go to the Product Part/Model Number field. */
-	addr += 1 + (pia[addr] & 0x3F);
-	if (addr + 1 >= len)
+	if (!fru_pia_advance(&addr, pia, len) ||
+	    !fru_pia_copy_field(fru_info->product_number,
+				sizeof(fru_info->product_number),
+				pia, addr, len))
 		goto Out;
-	memcpy(fru_info->product_number, pia + addr + 1,
-	       min_t(size_t, sizeof(fru_info->product_number),
-		     pia[addr] & 0x3F));
-	fru_info->product_number[sizeof(fru_info->product_number) - 1] = '\0';
 
-	/* Go to the Product Version field. */
-	addr += 1 + (pia[addr] & 0x3F);
+	/* Skip the Product Version field. */
+	if (!fru_pia_advance(&addr, pia, len))
+		goto Out;
 
-	/* Go to the Product Serial Number field. */
-	addr += 1 + (pia[addr] & 0x3F);
-	if (addr + 1 >= len)
+	/* Read the Product Serial Number field. */
+	if (!fru_pia_advance(&addr, pia, len) ||
+	    !fru_pia_copy_field(fru_info->serial,
+				sizeof(fru_info->serial),
+				pia, addr, len))
 		goto Out;
-	memcpy(fru_info->serial, pia + addr + 1,
-	       min_t(size_t, sizeof(fru_info->serial), pia[addr] & 0x3F));
-	fru_info->serial[sizeof(fru_info->serial) - 1] = '\0';
 
-	/* Asset Tag field */
-	addr += 1 + (pia[addr] & 0x3F);
+	/* Skip the Asset Tag field. */
+	if (!fru_pia_advance(&addr, pia, len))
+		goto Out;
 
 	/* FRU File Id field. This could be 'null'. */
-	addr += 1 + (pia[addr] & 0x3F);
-	if ((addr + 1 >= len) || !(pia[addr] & 0x3F))
+	if (!fru_pia_advance(&addr, pia, len) ||
+	    !fru_pia_copy_field(fru_info->fru_id,
+				sizeof(fru_info->fru_id),
+				pia, addr, len))
 		goto Out;
-	memcpy(fru_info->fru_id, pia + addr + 1,
-	       min_t(size_t, sizeof(fru_info->fru_id), pia[addr] & 0x3F));
-	fru_info->fru_id[sizeof(fru_info->fru_id) - 1] = '\0';
 
 Out:
 	kfree(pia);
-- 
2.53.0

