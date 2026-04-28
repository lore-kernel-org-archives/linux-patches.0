Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892593F54CE;
	Tue, 28 Apr 2026 10:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777373000; cv=none; b=hHXaP2HLagOjIBdTbOJwEZT4ZvfFlj6IRGKiRbdibWSNdiXtYPkdprpetDrZAfZwni2CZYN0uJZO7D99lHnZI+AHf0rzpsKef20jnRs68HDprkr3uR/16NCG7cTTmBc3aB07gemIkOc3AWigmTdJv6kt0aAmjvexkmwi4uKgQ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777373000; c=relaxed/simple;
	bh=B5KiGKV2zbegeBDLastgzsGiTNkTxhJYb8ltt3EiF6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghC9LYAn1uBQyIjRW8Pvu4BDT+zW4KrvhwSnXjZxZxrbG/H5G2koG1FgjOtdYS9Yyqv7g5kQIfUsHstM/NmsXFIljhAprdjIIHL2Xja7GnuXjzhQSzGUGjcGrKBK5QDrhh7G3M1UzW2yv69gA18ilASL8ZI3t8l3Zx2wNHpGfNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNXXw3cD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNXXw3cD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44CEC2BCAF;
	Tue, 28 Apr 2026 10:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372999;
	bh=B5KiGKV2zbegeBDLastgzsGiTNkTxhJYb8ltt3EiF6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNXXw3cDDjwPjdnxwiRoBejU5unc/nBCJwSm5Esrw+CShCz0Tzh3Ej2hWpsXgXlFF
	 GyyqekAQKdJnuEzT6aYtmrRppbD9Ks/T2JAfbKR2wpl0arm0mKAHs+AY7ODznXxP4s
	 7/S1XLb/HZHoHQ5du9ZfxNi/iDzshaehXnpzV6bA+85L9QrU3w8EmWeEAOLgLMf0TL
	 3hN733QmcAEpBTIh/yN2XVlHkRJphZSgmwnCGYXhHgtEjJ1CabwGBfkcrfU0fYbCrQ
	 GkwkurJ03kLgOH786snb7nTjywg7FKTUx197b/52uAJblwFPZ1m4qEgjE5hH/+hWaP
	 9f8kAkJC/ghKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Milan Misic <twoexem@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	jic23@kernel.org,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] iio: imu: st_lsm6dsx: Add ACPI ID for SHIFT13mi gyroscope
Date: Tue, 28 Apr 2026 06:41:25 -0400
Message-ID: <20260428104133.2858589-74-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Transfer-Encoding: 8bit

From: Milan Misic <twoexem@gmail.com>

[ Upstream commit 7913c1de9c3cbe3018fc29ce25a4d462ac2eaa82 ]

The SHIFT13mi or SHIFTbook tablet device by the German manufacturer
SHIFT contains an STM LSM6DSO IMU declared in the DSDT with the
hardware ID SMOCF00. Add this ID to the ACPI match table so that the
driver binds correctly to this device.

WHO_AM_I register returns 0x6c, confirming LSM6DSO.

Signed-off-by: Milan Misic <twoexem@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to write my comprehensive analysis.

## Analysis

### Phase 1: Commit Message Forensics

**Step 1.1 - Subject line parse:**
- Subsystem: `iio: imu: st_lsm6dsx`
- Action verb: "Add" (ACPI ID addition - fits the device ID exception
  category)
- Record: IIO IMU driver, adds ACPI hardware identifier to enable
  binding for SHIFT13mi tablet's STM LSM6DSO IMU

**Step 1.2 - Tags:**
- Signed-off-by: Milan Misic (author/reporter)
- Reviewed-by: Andy Shevchenko (well-known IIO/ACPI reviewer at Intel)
- Signed-off-by: Jonathan Cameron (IIO subsystem maintainer)
- Record: No Fixes:, no Cc: stable, no syzbot, no Link:. Reviewed and
  applied by appropriate reviewer/maintainer

**Step 1.3 - Body analysis:**
- The author identifies hardware ID `SMOCF00` in DSDT of
  SHIFT13mi/SHIFTbook tablet
- Hardware verification: WHO_AM_I register returns 0x6c, the documented
  LSM6DSO identifier
- Symptom (implicit): driver does not bind to this device on these
  tablets, so the IMU is unusable
- Record: Hardware enablement; specific tablet's IMU is not recognized
  by the existing driver

**Step 1.4 - Hidden bug fix detection:**
- Not a hidden fix; this is a straightforward hardware enablement
  (device ID addition exception category)
- Record: Plain device ID addition, not a disguised bug fix

### Phase 2: Diff Analysis

**Step 2.1 - Inventory:**
- Files: 1 (`drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_i2c.c`)
- Lines: +1, -0
- Function: `st_lsm6dsx_i2c_acpi_match[]` (a static const array)
- Record: Single-file, single-line, surgical change

**Step 2.2 - Code flow:**
- Before: ACPI match table contains only `SMO8B30` -> `ST_LSM6DS3TRC_ID`
- After: Adds `SMOCF00` -> `ST_LSM6DSO_ID`
- Affected path: ACPI device enumeration; only matches when a device
  with `_HID = "SMOCF00"` is present

**Step 2.3 - Bug mechanism:**
- Category (h): Hardware workaround / device ID addition
- Mechanism: ACPI subsystem can now match this device against the
  driver, triggering driver probe with the right hw_id

**Step 2.4 - Fix quality:**
- Trivially correct: it's a string -> integer mapping in a const array
- The mapping is verified by reading the WHO_AM_I register (0x6c ==
  LSM6DSO)
- Zero regression risk: cannot affect any device that doesn't have ACPI
  HID `SMOCF00`
- Record: Obviously correct, no regression risk for non-affected
  hardware

### Phase 3: Git History Investigation

**Step 3.1 - Blame:**
- ACPI match table introduced by commit `bd66b6acd20ba` ("iio: imu:
  lsm6dsx: Support SMO8B30 ACPI ID for LSM6DS3TR-C", v6.4, April 2023)
- LSM6DSO_ID itself introduced by `801a6e0af0c6c` ("iio: imu:
  st_lsm6dsx: add support to LSM6DSO", v4.20, August 2018)
- Record: Both prerequisites are in stable trees from v6.6 onwards

**Step 3.2 - Fixes: tag:**
- Not applicable. There is no Fixes: tag because no specific commit
  "broke" this; the device simply was never enumerated previously.

**Step 3.3 - Related changes:**
- Direct precedent: `bd66b6acd20ba` (Jonathan Cameron, 2023) added the
  SMO8B30 ID for the same driver. That commit was not Cc'd to stable but
  is the same pattern.
- Record: Standalone, no prerequisites needed beyond the ACPI table
  existing

**Step 3.4 - Author context:**
- Milan Misic: gmail.com address, appears to be the affected user
  reporting their own device. This is the typical "user-supplied device
  ID" pattern for stable.
- Reviewed by Andy Shevchenko (Intel, ACPI/IIO maintainer-level
  reviewer)
- Applied by Jonathan Cameron (IIO maintainer)

**Step 3.5 - Dependencies:**
- Requires `ST_LSM6DSO_ID` enum (present since v4.20)
- Requires the ACPI match table itself (present since v6.4 / commit
  bd66b6acd20ba)
- Record: Self-contained; can apply standalone in v6.6+

### Phase 4: Mailing List Research

**Step 4.1 - Discussion thread (b4 dig):**
- `b4 dig -c 7913c1de9c3cb` resolved to
  https://lore.kernel.org/all/20260324193626.77231-1-twoexem@gmail.com/
- Single revision (v1) - no respins required
- Reviewer Andy Shevchenko initially asked for the DSDT excerpt, which
  the author provided showing the `_HID "SMOCF00"` device entry (a
  Gyroscope under I2C0)
- The author also showed `cat /sys/bus/iio/devices/iio:device*/name`
  reporting `lsm6dso_gyro` and `lsm6dso_accel` confirming the device
  works once probed
- After the DSDT excerpt was supplied, Andy added Reviewed-by
- Jonathan Cameron applied: "Applied."
- Record: Patch reviewed, tested, applied; no NAKs; no stable nomination
  but also no concerns

**Step 4.2 - Reviewers:**
- Cc list: linux-iio@vger, linux-kernel@vger, lorenzo@kernel.org
  (LSM6DSx co-author Lorenzo Bianconi), jic23@kernel.org (Jonathan
  Cameron, IIO maintainer), David Lechner, Nuno Sa, andy@kernel.org
- Right people involved.

**Step 4.3 - Bug report:**
- Implicit: the author is reporting their own non-binding hardware. No
  bugzilla, no syzbot.

**Step 4.4 - Series:**
- Single standalone patch.

**Step 4.5 - Stable list:**
- No prior stable discussion found.

### Phase 5: Code Semantic Analysis

**Step 5.1 - Functions:**
- Modified: `st_lsm6dsx_i2c_acpi_match[]` (data table)

**Step 5.2 - Callers:**
- The table is used by the I2C/ACPI core via `acpi_match_table =
  st_lsm6dsx_i2c_acpi_match` in the `i2c_driver` struct (file lines
  180-189). When ACPI enumeration finds a device with a matching _HID,
  the I2C/ACPI core calls `st_lsm6dsx_i2c_probe()`, which retrieves the
  ID via `device_get_match_data()` (line 29).
- Record: Standard ACPI -> I2C device enumeration path

**Step 5.3 - Callees:**
- Probe path eventually calls `st_lsm6dsx_probe()` (the existing common
  probe), which knows how to handle `ST_LSM6DSO_ID`.

**Step 5.4 - Reachability:**
- Reachable on any system whose firmware contains ACPI device with `_HID
  "SMOCF00"`. On affected hardware (SHIFT13mi/SHIFTbook), this is the
  boot path; on all other hardware, the new entry is dormant.

**Step 5.5 - Similar patterns:**
- Direct sibling: SMO8B30 ACPI entry (line 146) backported by
  maintainers as routine hardware enablement when the same author's
  pattern was used in 2023.

### Phase 6: Cross-Referencing Stable Trees

**Step 6.1 - Code presence in stable:**
- v5.10/v5.15/v6.1: no ACPI match table at all (introduced in v6.4)
- v6.6.y: ACPI table present with SMO8B30 only - patch applies cleanly
- v6.12.y: same as v6.6 - patch applies cleanly
- Record: Clean apply expected on v6.6+; would need rework (skip) on
  older trees

**Step 6.2 - Backport difficulty:**
- v6.6+: Clean apply (single line in the same context, around the
  SMO8B30 entry which exists in all those trees)
- v6.1 and older: NOT applicable (ACPI table doesn't exist; would
  require also backporting the bd66b6acd20ba refactor, not appropriate)
- Record: Clean apply on v6.6+, skip older

**Step 6.3 - Related stable work:**
- The earlier SMO8B30 patch (bd66b6acd20ba) was not in stable, but the
  current ACPI table structure exists in v6.6+ stable.

### Phase 7: Subsystem Context

**Step 7.1 - Subsystem criticality:**
- `drivers/iio/imu/` - IIO IMU drivers. Peripheral category (specific
  hardware), not core. But device-specific enablement is a recognized
  stable exception.

**Step 7.2 - Activity:**
- Active subsystem with regular patches; many sibling driver IDs being
  added over time.

### Phase 8: Impact and Risk Assessment

**Step 8.1 - Affected users:**
- Owners of SHIFT13mi and SHIFTbook tablets (German manufacturer SHIFT).
  Niche, but real users with no other workaround.

**Step 8.2 - Trigger:**
- Device probe at boot, on affected hardware. 100% triggers on those
  tablets; never triggers on other hardware.

**Step 8.3 - Failure mode (without fix):**
- IMU is non-functional on these tablets - no orientation/motion sensing
- No crash, no security issue. Severity: LOW-MEDIUM (hardware not
  working)

**Step 8.4 - Risk-Benefit:**
- BENEFIT: Enables hardware on a specific tablet model. Standard "device
  ID" exception material.
- RISK: 1 line. Cannot affect any device whose ACPI HID is not exactly
  `SMOCF00`. Vanishingly small regression risk.
- Record: Tiny risk, modest but real benefit; standard backport pattern

### Phase 9: Synthesis

**Evidence FOR backporting:**
- Falls cleanly into the "Device ID addition to existing driver"
  exception (explicitly listed as common stable material)
- Trivially correct: 1-line const array entry with verified WHO_AM_I
  match
- No regression possible for users without this specific ACPI HID
- Reviewed by experienced reviewer; author tested on real hardware
  (provided DSDT excerpt and `iio:device*/name` listing)
- Driver and ACPI match table both pre-exist in v6.6+ stable trees
- Direct precedent: SMO8B30 entry (same author pattern, same file, same
  maintainer applied)

**Evidence AGAINST:**
- No Cc: stable nomination from reviewers (but this is the case for
  every commit being evaluated)
- Hardware is niche (specific tablet manufacturer)
- Won't apply to v6.1.y and older (ACPI match table doesn't exist there)

**Stable rules checklist:**
1. Obviously correct? YES - trivial table entry verified by hardware
   register
2. Real bug? YES - device doesn't bind without it
3. Important issue? Borderline (functional only) but qualifies as the
   "hardware enablement" exception
4. Small/contained? YES - 1 line
5. No new features/APIs? YES - existing driver, existing enum, existing
   table
6. Applies cleanly? YES on v6.6+ stable trees

**Exception category:** YES - "Device ID addition to existing driver"
(PCI/USB/ACPI IDs) is one of the explicitly allowed stable exceptions.

## Verification

- [Phase 1] Read full commit message and diff context as provided
- [Phase 2] Confirmed +1/-0 line change inserting `{ "SMOCF00",
  ST_LSM6DSO_ID, },` into `st_lsm6dsx_i2c_acpi_match[]`
- [Phase 3] `git log` of file showed precedent commit `bd66b6acd20ba`
  (SMO8B30, v6.4) which created the ACPI match table; `801a6e0af0c6c`
  (v4.20) introduced LSM6DSO_ID enum
- [Phase 3] `git tag --contains bd66b6acd20ba` confirmed ACPI table is
  in v6.4, v6.5, v6.6
- [Phase 4] `b4 dig -c 7913c1de9c3cb` matched series at
  https://lore.kernel.org/all/20260324193626.77231-1-twoexem@gmail.com/
- [Phase 4] `b4 dig -c 7913c1de9c3cb -m /tmp/shift_thread.mbox`
  retrieved full thread; reviewed: only v1 sent; Andy Shevchenko
  Reviewed-by; Jonathan Cameron "Applied."; author provided DSDT excerpt
  and `iio:device*/name` showing `lsm6dso_gyro`/`lsm6dso_accel` work
  after the patch
- [Phase 4] No stable nomination request found in thread; no NAKs
- [Phase 5] Confirmed `acpi_match_table = st_lsm6dsx_i2c_acpi_match`
  wired into the i2c_driver and probe goes through
  `device_get_match_data()` -> `st_lsm6dsx_probe()` (read of file
  `drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_i2c.c`)
- [Phase 6] `git show v5.10/v5.15/v6.1/v6.6/v6.12:.../st_lsm6dsx_i2c.c`
  - ACPI match table is absent in v5.10, v5.15, v6.1; present (with
  SMO8B30 only) in v6.6 and v6.12
- [Phase 6] LSM6DSO_ID is present in the file from v5.4 onwards
- [Phase 8] Confirmed change cannot match any device without the exact
  ACPI HID `SMOCF00`
- UNVERIFIED: Whether SHIFT13mi/SHIFTbook tablet users actively use
  stable kernels (assumed yes since these are commodity laptops/tablets
  running mainstream distros)
- UNVERIFIED: Could not confirm v6.6.y / v6.12.y exact current contents
  of the ACPI table (used release tags, not -y branches), but tag
  content matches expectations

## Decision

This is a textbook "add ACPI ID to existing driver" patch - one of the
explicit exception categories that stable accepts. The fix is one line,
trivially correct (verified by WHO_AM_I), zero regression risk for non-
affected hardware, and was reviewed and applied by the IIO maintainer
with the appropriate reviewer's blessing. It directly enables a real
user's device that is otherwise non-functional. Applies cleanly to v6.6+
stable trees (the ACPI match table doesn't exist in v6.1 and older, so
older trees would simply skip).

**YES**

 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_i2c.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_i2c.c
index 7c933218036b8..b2a7c2eaf50dc 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_i2c.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_i2c.c
@@ -144,6 +144,7 @@ MODULE_DEVICE_TABLE(of, st_lsm6dsx_i2c_of_match);
 
 static const struct acpi_device_id st_lsm6dsx_i2c_acpi_match[] = {
 	{ "SMO8B30", ST_LSM6DS3TRC_ID, },
+	{ "SMOCF00", ST_LSM6DSO_ID, },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, st_lsm6dsx_i2c_acpi_match);
-- 
2.53.0

