Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1264DB560;
	Mon, 11 May 2026 22:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778538010; cv=none; b=ewJzM/q6DWHWHkELq87gA8FiUx9OX3ZrXuEvzOshseGvBrSzUFBaArHDGyWZq800j6wmMpqqQzgw1XxDwu/7AMPLHo8SWxxfQZyXdA4tQo5Q0cAEa1KCnTjeOYCF4KfNeojacfXNo2suTM4OyD/8Y6VuffMEoz9ZNmUxuxanqmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778538010; c=relaxed/simple;
	bh=pP8iVAxF1FoMXalCFIkZlnb3QWBe+RsA4kTO38lVTnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pj6C90I5vDw8ds4WJ7vl7r46SP9z4N66pX1XMZ/YK7s1LuyY7Jfi70iKEzZp2R947d7pb245Q4pRzG9MKKpsV2E71dmYI64Jnmv/CRRmY+FNR2+p6CIY72ndkRLa0RoFGAy9oIIlMv3J8KDKAV6ScXe0nKJIlr96dv8YVjFOTXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDjTXQgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDjTXQgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0058CC2BCFB;
	Mon, 11 May 2026 22:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778538010;
	bh=pP8iVAxF1FoMXalCFIkZlnb3QWBe+RsA4kTO38lVTnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDjTXQgiVsLQN2umBM4iqidqhE64mx5qtWDlKxrFXIqo45MX+9APBg8fWwjKzhdkd
	 jcB+rmwP3qdhf+koN0OmJr1UKSb7JhY4gyMiFCooUS4zMuD1nS/S4jbb9RFFzeA/yx
	 uuyjXv7HxRTfsRRon7HI5J18AFQi8cNCwoNsCPUUQgbFlJz06WPhdyX9P6mbeCd/ue
	 IEAo2YSDL2j/7syZJa4PhKrE+OAUyb1zMT+zjCSUB/2wXoiD5rEvWxqGcWH018j6EZ
	 7j5hzGStRdr4gV8J367pzRknKpL4dlDaFCb+JPmSuJ6L3fAqJuXj8VGJfMjEfWIcJ0
	 HrQ4AB6BNitpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niels Franke <nielsfranke@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>,
	wsa@kernel.org,
	linux-i2c@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] i2c: acpi: Add ELAN0678 to i2c_acpi_force_100khz_device_ids
Date: Mon, 11 May 2026 18:19:25 -0400
Message-ID: <20260511221931.2370053-26-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511221931.2370053-1-sashal@kernel.org>
References: <20260511221931.2370053-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Niels Franke <nielsfranke@gmail.com>

[ Upstream commit 9998e388be9930c106eb5904c23ecf2162407527 ]

The ELAN0678 touchpad (04F3:3195) found in the Lenovo ThinkPad X13
exhibits excessive smoothing when the I2C bus runs at 400KHz, making
the touchpad feel sluggish when plugged into AC power. This is the
same issue previously fixed for ELAN06FA.

The device's ACPI table (Lenovo TP-R22) specifies 0x00061A80 (400KHz)
for the I2cSerialBusV2 descriptor. Forcing the bus to 100KHz eliminates
the sluggish behavior.

Signed-off-by: Niels Franke <nielsfranke@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
[wsa: kept the sorting]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

Step 1.1 - Subject:
Record: Subsystem `i2c: acpi`; action verb `Add`; intent is to add ACPI
HID `ELAN0678` to the existing 100 kHz forced-speed quirk table.

Step 1.2 - Tags:
Record: `Signed-off-by: Niels Franke <nielsfranke@gmail.com>`; `Acked-
by: Mika Westerberg <mika.westerberg@linux.intel.com>`; maintainer note
`[wsa: kept the sorting]`; `Signed-off-by: Wolfram Sang
<wsa+renesas@sang-engineering.com>`. No `Fixes:`, `Reported-by:`,
`Tested-by:`, `Link:`, or `Cc: stable@vger.kernel.org` tags.

Step 1.3 - Body:
Record: The bug is real hardware misbehavior: ELAN0678 touchpad
`04F3:3195` on Lenovo ThinkPad X13 becomes sluggish/excessively smoothed
when ACPI-described I2C speed is 400 kHz. The commit says forcing 100
kHz eliminates it. Root cause is a bad/not-working speed choice for this
device, matching the earlier ELAN06FA workaround.

Step 1.4 - Hidden bug fix:
Record: Yes. Although phrased as “Add”, this is a hardware
workaround/quirk for a user-visible input-device malfunction, not new
feature work.

## Phase 2: Diff Analysis

Step 2.1 - Inventory:
Record: One file changed: `drivers/i2c/i2c-core-acpi.c`, `+1/-0`. It
adds `{ "ELAN0678", 0 }` to `i2c_acpi_force_100khz_device_ids`. Scope is
a single-file, one-line hardware quirk.

Step 2.2 - Code flow:
Record: Before, ELAN0678 used the normal ACPI/min-speed path and could
run at the 400 kHz speed from firmware. After, when
`i2c_acpi_lookup_speed()` sees an ACPI device matching `ELAN0678`, it
sets `lookup->force_speed = I2C_MAX_STANDARD_MODE_FREQ`, causing
`i2c_acpi_find_bus_speed()` to return 100 kHz.

Step 2.3 - Bug mechanism:
Record: Hardware workaround. The broken condition is a known-not-working
I2C bus speed for a specific ACPI HID. The fix reuses the existing
forced-100-kHz mechanism.

Step 2.4 - Fix quality:
Record: Obviously correct and minimal. It only affects machines exposing
ACPI HID `ELAN0678`. Regression risk is very low: affected devices will
run slower I2C, intentionally matching the verified workaround; all
other devices are unchanged.

## Phase 3: Git History

Step 3.1 - Blame:
Record: `git blame` on `origin/master` shows the new line is commit
`9998e388be993`; the 100 kHz table and `ELAN06FA` handling came from
`bfd74cd1fbc026`, first contained around `v6.14-rc1`; `DLL0945` came
from `0b7c9528facdb5`, first contained around `v6.17-rc1`.

Step 3.2 - Fixes tag:
Record: Not applicable; no `Fixes:` tag is present.

Step 3.3 - File history:
Record: Recent file history shows related quirks `ELAN06FA` and
`DLL0945`, plus unrelated treewide allocation conversions. No
prerequisite structural change is needed where the 100 kHz table already
exists.

Step 3.4 - Author context:
Record: Local history shows Niels Franke has this one I2C commit on
`origin/master`. The patch was acked by Mika Westerberg, listed in
`MAINTAINERS` as I2C ACPI maintainer, and committed by Wolfram Sang.

Step 3.5 - Dependencies:
Record: Standalone for stable branches that already have
`i2c_acpi_force_100khz_device_ids`. For branches lacking the table, it
depends on the earlier ELAN06FA forced-100-kHz infrastructure.

## Phase 4: Mailing List And External Research

Step 4.1 - Original discussion:
Record: `b4 dig -c 9998e388be993` found the original submission at
`https://patch.msgid.link/20260418053719.15766-1-nielsfranke@gmail.com`.
The mirror thread shows v1 only, Mika Westerberg acked it, and Wolfram
Sang applied it to `for-current` while keeping sort order. No objections
or NAKs found.

Step 4.2 - Reviewers/recipients:
Record: `b4 dig -w` shows recipients included Niels Franke,
`westeri@kernel.org`, Wolfram Sang, `linux-i2c`, `linux-acpi`, and
`linux-kernel`. This reached the relevant I2C ACPI maintainer and lists.

Step 4.3 - Bug report:
Record: No separate `Reported-by` or bug tracker link in the commit. The
commit message itself documents affected hardware, ACPI table speed, and
the tested workaround. Web search also found unrelated ELAN0678 user
reports, but I did not rely on those for the final decision.

Step 4.4 - Series context:
Record: `b4 dig -a` shows a single v1 patch, not a multi-patch series.

Step 4.5 - Stable discussion:
Record: Direct lore stable fetch was blocked by Anubis; web search found
no specific stable-list discussion for ELAN0678. Stable branch git logs
sampled do not yet contain ELAN0678.

## Phase 5: Code Semantic Analysis

Step 5.1 - Key functions:
Record: The diff changes only the ACPI ID table, but behavior flows
through `i2c_acpi_lookup_speed()` and `i2c_acpi_find_bus_speed()`.

Step 5.2 - Callers:
Record: `i2c_acpi_find_bus_speed()` is called by multiple I2C bus
drivers, including DesignWare, USBIO, SynQuacer, LS2X, Zhaoxin, and AMD
MP2. For DesignWare, `dw_i2c_plat_probe()` and PCI probe paths call
`i2c_dw_fw_parse_and_configure()`, which calls the ACPI speed lookup
during controller setup.

Step 5.3 - Callees:
Record: The relevant code calls `acpi_walk_namespace()`,
`i2c_acpi_do_lookup()`, and `acpi_match_device_ids()`; if matched, it
returns the forced speed to bus-driver timing configuration.

Step 5.4 - Reachability:
Record: Reachable during I2C adapter/controller initialization on ACPI
systems. On affected Lenovo hardware, this path controls the bus speed
used for the touchpad.

Step 5.5 - Similar patterns:
Record: Verified sibling quirks `ELAN06FA` and `DLL0945` in the same
table, both addressing touchpad sluggishness at higher I2C speed.

## Phase 6: Stable Tree Analysis

Step 6.1 - Buggy code in stable:
Record: Sampled stable branches `5.10.y`, `5.15.y`, `6.6.y`, `6.12.y`,
`6.15.y` through `7.0.y` already contain the 100 kHz quirk table with
`ELAN06FA`/`DLL0945`, but not `ELAN0678`. `5.4.y` has ACPI speed lookup
but not the forced-100-kHz table in the sampled state.

Step 6.2 - Backport difficulty:
Record: Clean or trivial for branches with both `DLL0945` and `ELAN06FA`
adjacent. Branches lacking `DLL0945` or the table may need a trivial
context adjustment or dependency backport.

Step 6.3 - Related fixes already stable:
Record: Stable branches sampled already carry related ELAN06FA/DLL0945
quirks, but no ELAN0678 equivalent.

## Phase 7: Subsystem Context

Step 7.1 - Subsystem:
Record: `drivers/i2c/i2c-core-acpi.c`, I2C ACPI support. Criticality is
important for affected ACPI laptop hardware, but not universal/core.

Step 7.2 - Activity:
Record: File history shows active maintenance and recent hardware quirk
additions. The patch was accepted through the I2C maintainer path.

## Phase 8: Impact And Risk

Step 8.1 - Affected users:
Record: Users of systems exposing the ELAN0678 ACPI touchpad,
specifically verified by commit message for Lenovo ThinkPad X13.

Step 8.2 - Trigger:
Record: Triggered when the I2C bus is configured at 400 kHz for this
device, including via the Lenovo TP-R22 ACPI `I2cSerialBusV2`
descriptor. This is normal boot/device setup, not an obscure manual
path.

Step 8.3 - Severity:
Record: Medium severity user-visible hardware malfunction: sluggish
touchpad/input behavior. Not a crash, security issue, or data
corruption.

Step 8.4 - Risk-benefit:
Record: Benefit is high for affected laptops because it restores usable
touchpad behavior. Risk is very low because it is a one-line ACPI HID-
specific quirk using existing logic.

## Phase 9: Final Synthesis

Step 9.1 - Evidence:
Record: For backporting: real hardware bug, existing quirk mechanism,
one-line scoped change, maintainer ack, accepted by I2C maintainer,
stable branches already carry analogous quirks. Against backporting: no
explicit stable tag, no separate bug report link, not a critical
crash/security fix. Unresolved: exact applicability to every older
stable branch; `5.4.y` would need more than this one-line context.

Step 9.2 - Stable rules:
Record: Obviously correct: yes. Tested: commit states forcing 100 kHz
eliminates the issue, though no `Tested-by` tag. Real bug: yes, touchpad
sluggishness. Important enough: yes under hardware quirk/workaround
practice. Small/contained: yes, one line. No new APIs/features: yes.
Applies to stable: yes for branches with the existing table; trivial
adjustment/dependency for older divergent branches.

Step 9.3 - Exception:
Record: This falls squarely under the stable hardware quirk/workaround
exception.

Step 9.4 - Decision:
Record: Backport. The risk is tiny and the fix is exactly the sort of
targeted hardware workaround stable trees routinely carry.

## Verification

- Phase 1: Parsed `git show --format=fuller --stat --patch
  9998e388be993`; confirmed subject, body, tags, and one-line diff.
- Phase 2: Read `drivers/i2c/i2c-core-acpi.c`; confirmed
  `i2c_acpi_force_100khz_device_ids` is checked by
  `i2c_acpi_lookup_speed()` and returns 100 kHz through
  `i2c_acpi_find_bus_speed()`.
- Phase 3: Ran `git blame` on the relevant lines; confirmed commits for
  `ELAN06FA`, `DLL0945`, and `ELAN0678`.
- Phase 3: Ran `git describe --contains`; confirmed first-containing
  release positions for related mainline commits.
- Phase 4: Ran `b4 dig -c`, `b4 dig -a`, and `b4 dig -w`; found original
  v1 submission, no later revisions, and relevant recipients.
- Phase 4: Fetched the public mirror thread; confirmed Mika Westerberg’s
  ack and Wolfram Sang’s application note.
- Phase 5: Used semantic search, `rg`, and file reads; confirmed
  DesignWare and other I2C bus drivers call `i2c_acpi_find_bus_speed()`.
- Phase 6: Used `git grep` and stable branch logs; confirmed sampled
  stable branches contain related forced-speed quirks but not ELAN0678.
- Phase 8: Failure mode is verified from the commit message and lore
  thread: sluggish/excessively smoothed touchpad at 400 kHz, fixed by
  100 kHz.
- UNVERIFIED: Direct `lore.kernel.org/stable` content was blocked by
  Anubis, so I could not independently inspect stable-list discussion
  there.

**YES**

 drivers/i2c/i2c-core-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 2cbd31f77667a..28c0e4884a7f2 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -371,6 +371,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 * a 400KHz frequency. The root cause of the issue is not known.
 	 */
 	{ "DLL0945", 0 },
+	{ "ELAN0678", 0 },
 	{ "ELAN06FA", 0 },
 	{}
 };
-- 
2.53.0

