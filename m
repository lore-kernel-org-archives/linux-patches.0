Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC2B52B1FE;
	Mon, 31 Aug 2026 13:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183883; cv=none; b=RYRt5MCoeL0gWb/MIHzVyiIrYIR3XK88cngZRAp5HzDRTMK/rrrNQyZDkM4Pg9/JqMXNB85a36uCMvWaUYid6oj9ncYASaDoeHsI1zrOzDN0oEvgS54auWpKu85WbLtD7u1Rl/QFLlxZg4QxlnWL+Ifjqrpm8eKisNGv84HMWTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183883; c=relaxed/simple;
	bh=QbMQzexjY/XOShu7dBxYDv/eYbYozd7dnLbuUTfgWUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gvG6HLYx02iAXCRdJ6dwCXfyzfvxHxSIaxikODJiv1csS6U6C31bpvHrKuEuNYU46k37GGnJ4wkIkgMU1DWBFxmBpJP4qfHcJtaluSqu8W0lUcwUxFEEsW37iCLiyluGsm9L9bGx3LuPcletkTyK8Waneg/7fjUkccCsPBzJzGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlALr4SA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlALr4SA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA011F00ADE;
	Mon, 31 Aug 2026 13:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183880;
	bh=XdGz328xTlkQ6Cul4SWgdJ/Sm6sjC60Xa8F08i/Exa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UlALr4SA4jGFugjpSB8q4EHP0Ob8AGB4G4DqdhsnizlC/XBxrA5yVo5DuR64UIc5n
	 N++xK6wWsMXZCVVaHXPR8mPjcM2gJO4d9cIMWdS5F3sUP+hmaX/852W8MN7F+KvwVw
	 xAwSi7RYS8cnAsja40Gw/okR6X+9w3vh+GyqIYFD7vocFZkAapNb1EvhQLFamtee+u
	 EGvE6ERnB0KW3/MWPv+57VUGIPiNEiL+nunq/ZqbAakUpVWNO7zyMFsTSqmNuR+Owr
	 8eGZGTUoHFvg8HU27Rrq6LhjlvO79zl7I+bmxytgO6GpFPLli7lt6mRCO23Jxmo5Dh
	 nu604xaPAS6Eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sudeep Holla <sudeep.holla@kernel.org>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	arm-scmi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] firmware: arm_scmi: Validate SENSOR_UPDATE payload size
Date: Mon, 31 Aug 2026 09:26:26 -0400
Message-ID: <20260831133314.4125787-358-sashal@kernel.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 32bc5496b48174dbca1f187f710955ee4d9527a1 ]

SENSOR_UPDATE carries one or more sensor readings after the fixed
notification header. The parser derives the expected reading count
from the sensor description, but it did not verify that the received
payload contains those entries before parsing them.

Reject truncated update notifications before reading the variable
array.

Link: https://patch.msgid.link/20260517-scmi_fixes-v1-3-d86daec4defd@kernel.org
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[firmware: arm_scmi]` `[Validate]` — Validate SENSOR_UPDATE
  notification payload size before parsing variable-length sensor
  readings.

**Step 1.2 — Tags**
- Record:
  - `Link:` https://patch.msgid.link/20260517-scmi_fixes-v1-3-
    d86daec4defd@kernel.org
  - `Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>` (ARM SCMI
    maintainer)
  - `Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>` (SCMI
    maintainer)
  - No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or syzbot
    tags
  - Part of `[PATCH 3/4]` in series `firmware: arm_scmi: Fix protocol
    parsing and validation`

**Step 1.3 — Body analysis**
- Record:
  - **Bug:** `SCMI_EVENT_SENSOR_UPDATE` notifications carry a fixed
    header plus a variable array of readings. The parser derives
    `readings_count` from the sensor description but never checks that
    `payld_sz` covers those entries.
  - **Symptom:** Truncated notifications are parsed anyway; readings
    beyond the valid payload are read and forwarded to handlers.
  - **Root cause:** Missing minimum and expected payload size validation
    before accessing `p->readings[]`.
  - **Version info:** None in commit message; code has existed since
    SCMI v3.0 sensor notifications (2020).

**Step 1.4 — Hidden bug fix?**
- Record: **Yes.** Despite the neutral “validate” wording, this is a
  real parsing bug fix, not cosmetic cleanup. It prevents out-of-spec
  payload processing.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record:
  - `drivers/firmware/arm_scmi/sensors.c`: +9 / -1 lines
  - Function modified: `scmi_sensor_fill_custom_report()`
  - Scope: single-file, surgical fix in one `switch` case

**Step 2.2 — Code flow change**
- Record:
  - **Hunk 1 (minimum header check):** Before → reads `p->sensor_id`
    immediately. After → returns early if `payld_sz < sizeof(*p)` (8
    bytes).
  - **Hunk 2 (expected size check):** Before → loops `readings_count`
    times over `p->readings[i]` unconditionally. After → computes
    `expected_sz = sizeof(*p) + readings_count * sizeof(p->readings[0])`
    and breaks if `payld_sz < expected_sz`.
  - **Failure path:** `break` leaves `rep = NULL`; caller logs and skips
    notification handlers.

**Step 2.3 — Bug mechanism**
- Record:
  - **Category:** Memory safety / bounds validation (out-of-bounds read
    of notification payload).
  - **Mechanism:** `scmi_notify()` only enforces an upper bound (`len >
    max_payld_sz`). For `SENSOR_UPDATE`, `max_payld_sz` allows up to 63
    axis readings, but a shorter payload is accepted. The handler then
    reads 16-byte `scmi_sensor_reading_resp` entries beyond the copied
    `payld_sz` bytes. The scratch buffer (`pd->eh`) is pre-allocated to
    max size, so this typically reads stale buffer contents rather than
    faulting — but wrong sensor values are still delivered to consumers.

**Step 2.4 — Fix quality**
- Record:
  - Fix is obviously correct; mirrors the existing fixed-size check on
    `SCMI_EVENT_SENSOR_TRIP_POINT_EVENT` and the variable-size pattern
    in `system.c`.
  - Minimal, no API changes.
  - Regression risk: very low — only rejects malformed/truncated
    notifications that were already being mishandled.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record: `SCMI_EVENT_SENSOR_UPDATE` handler introduced in
  `e3811190acf85` (Cristian Marussi, 2020-11-19, “Add SCMI v3.0 sensor
  notifications”). Bug present since introduction. Present in this tree
  at `drivers/firmware/arm_scmi/sensors.c:1074-1101`.

**Step 3.2 — Fixes: tag**
- Record: Not applicable — no `Fixes:` tag.

**Step 3.3 — Related file history**
- Record:
  - Recent related hardening: `76f89c9547887` (“Harden accesses to the
    sensor domains”), `3b0041f6e10e5` (“Validate
    BASE_DISCOVER_LIST_PROTOCOLS response”) — same class of “don’t trust
    SCMI payload sizes.”
  - Patch 1/4 of the same series is already in this tree:
    `bac3e70c2fb10` (“Read sensor config as 32-bit value”).
  - Patches 2/4 and 4/4 of the series are not yet in this tree; patch
    3/4 is standalone.

**Step 3.4 — Author context**
- Record: Sudeep Holla is the SCMI maintainer. Cristian Marussi is the
  primary SCMI protocol author and reviewed this patch.

**Step 3.5 — Dependencies**
- Record: **Standalone.** Only touches existing
  `SCMI_EVENT_SENSOR_UPDATE` path. No prerequisite commits required
  beyond code already in `linux-6.18.y`.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record:
  - Lore URL: https://lore.kernel.org/linux-arm-
    kernel/20260517-scmi_fixes-v1-3-d86daec4defd@kernel.org/
  - Series cover (patch 0/4) explains: “The next two patches harden
    notification parsing for variable-sized payloads. BASE_ERROR_EVENT
    and SENSOR_UPDATE both carry counted trailing arrays…”
  - “No functional change is intended for well-formed SCMI responses.”
  - Review reply from Cristian Marussi on patch 3/4 exists in thread
    (Reviewed-by in final commit).

**Step 4.2 — Reviewers**
- Record: CC’d to `Cristian Marussi`, `arm-scmi@vger.kernel.org`,
  `linux-arm-kernel@lists.infradead.org`. Subsystem maintainers were
  included.

**Step 4.3 — Bug report**
- Record: No external bug report or syzbot link. Issue found during
  spec-compliance review per series cover letter.

**Step 4.4 — Series context**
- Record: 4-patch series; patch 3 is independent of patches 2 and 4.
  Patch 1 already backported to this tree, indicating stable maintainers
  already consider the series appropriate for `6.18.y`.

**Step 4.5 — Stable list history**
- Record: No explicit `Cc: stable` nomination found in thread. Not a
  negative signal per instructions.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: `scmi_sensor_fill_custom_report()`,
  `scmi_parse_sensor_readings()`

**Step 5.2 — Callers**
- Record:
  - `REVT_FILL_REPORT()` macro in `notify.c:495` called from
    `scmi_process_event_payload()`
  - `scmi_process_event_payload()` called from
    `scmi_events_dispatcher()` workqueue handler
  - Context: process context, SCMI notification worker path

**Step 5.3 — Callees**
- Record: `le32_to_cpu()`, `scmi_parse_sensor_readings()` (reads 16-byte
  unaligned LE64 pairs per axis)

**Step 5.4 — Reachability**
- Record:
  - Triggered when platform firmware sends `SCMI_EVENT_SENSOR_UPDATE`
    notifications
  - Affects ARM/ARM64 systems using SCMI (Juno, NXP i.MX, STM32 MP,
    Neoverse, etc.)
  - Not directly userspace-triggerable, but firmware bugs, transport
    corruption, or spec violations can deliver truncated payloads
  - Downstream consumers include
    `drivers/iio/common/scmi_sensors/scmi_iio.c` (registers for
    `SCMI_EVENT_SENSOR_UPDATE` and copies `readings[]` into IIO buffers)

**Step 5.5 — Similar patterns**
- Record:
  - `SCMI_EVENT_SENSOR_TRIP_POINT_EVENT` already validates `sizeof(*p)
    != payld_sz`
  - `scmi_system_fill_custom_report()` validates `payld_sz !=
    expected_sz`
  - `scmi_reset_fill_custom_report()`,
    `scmi_power_fill_custom_report()`, `scmi_perf_fill_custom_report()`
    all validate payload sizes
  - `SENSOR_UPDATE` was the outlier missing validation

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code exists?**
- Record: **Yes.** Local tree is `stable/linux-6.18.y` at `v6.18.44`.
  Buggy code confirmed at `sensors.c:1082-1098` — no payload size
  validation before parsing readings.

**Step 6.2 — Backport complications**
- Record: **Clean apply expected.** File is present and structure
  matches the diff context exactly. No conflicting refactors in this
  area.

**Step 6.3 — Related fixes already present?**
- Record: Patch 1/4 of same series already backported (`bac3e70c2fb10`).
  This specific SENSOR_UPDATE validation is **not** yet present. No
  duplicate fix found.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
- Record: `firmware/arm_scmi` — **IMPORTANT** for ARM embedded/server
  platforms. Sensor notifications feed hwmon/IIO/thermal subsystems.

**Step 7.2 — Subsystem activity**
- Record: Actively maintained; recent commits include protocol
  versioning, sensor domain hardening, and the first patch of this same
  fix series.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: ARM platforms using SCMI sensor continuous-update
  notifications — embedded, mobile, server BMC paths. Config-dependent
  on `CONFIG_ARM_SCMI` and sensor notification registration.

**Step 8.2 — Trigger conditions**
- Record: Truncated or malformed `SENSOR_UPDATE` notification from SCMI
  firmware. Uncommon in normal operation but possible with buggy
  firmware or corrupted messages. Not unprivileged-userspace-
  triggerable.

**Step 8.3 — Failure mode severity**
- Record:
  - **Failure mode:** Reads beyond valid payload into stale scratch-
    buffer data; incorrect sensor readings propagated to IIO/hwmon
    notifiers.
  - **Severity:** **MEDIUM-HIGH** — data integrity issue in sensor
    reporting path; could affect thermal/power decisions on affected
    platforms. Unlikely to panic (buffer is pre-allocated to max size),
    but wrong data is a real bug.

**Step 8.4 — Risk vs benefit**
- Record:
  - **Benefit:** Prevents bogus sensor data from truncated
    notifications; aligns with existing SCMI validation patterns; same
    series already partially backported.
  - **Risk:** Very low — 9-line validation-only change on error path.
  - **Ratio:** Strong benefit, minimal risk.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

*For backporting:*
- Real bounds-check bug in notification parser since 2020
- Incorrect sensor readings possible on truncated payloads
- Small, obviously correct, maintainer-reviewed fix
- Consistent with prior SCMI validation backports in this tree
  (`3b0041f6e10e5`)
- Patch 1/4 of same series already in `linux-6.18.y`
- Standalone, clean apply to this tree

*Against backporting:*
- No user crash report or syzbot finding
- Requires malformed firmware notification (trusted path)
- Part of a series where patches 2 and 4 are not yet backported (but
  patch 3 is independent)

*Unresolved:*
- No explicit stable nomination in lore thread (not required)

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is straightforward;
   reviewed by SCMI maintainer; series patch 1 already in tree with
   multiple Tested-by tags on series.
2. Fixes a real bug? **PASS** — truncated payloads parsed without bounds
   check.
3. Important issue? **PASS** — data integrity in sensor notification
   path (MEDIUM-HIGH).
4. Small and contained? **PASS** — 9 lines, one function, one file.
5. No new features/APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected.

**Step 9.3 — Exception categories**
- Record: Not a device ID/quirk/DT/build/doc exception. Standard bug
  fix.

**Step 9.4 — Decision rationale**

For `linux-6.18.y` at `v6.18.44`, this commit should be backported. The
`SCMI_EVENT_SENSOR_UPDATE` handler has been missing payload size
validation since 2020, allowing truncated notifications to produce
incorrect sensor readings that flow into IIO consumers. The fix is
minimal, matches established patterns elsewhere in the same driver, was
reviewed by the SCMI maintainer, and belongs to a series whose first
patch is already in this stable tree.

---

## Verification

- [Phase 1] `git describe HEAD` → `v6.18.44`; parsed commit message tags
  and body
- [Phase 2] Read diff and `sensors.c:1050-1108`; confirmed
  `scmi_sensor_reading_resp` is 16 bytes; `sizeof(*p)` is 8 bytes
- [Phase 3] `git blame -L 1074,1101 sensors.c` → bug from
  `e3811190acf85` (2020-11-19)
- [Phase 3] `git show e3811190acf85` → introduced SCMI v3.0 sensor
  notifications
- [Phase 3] `git log --oneline -20 --
  drivers/firmware/arm_scmi/sensors.c` → recent activity confirmed
- [Phase 3] `git log --oneline -1 bac3e70c2fb10` → patch 1/4 already in
  tree
- [Phase 4] Fetched lore thread via `curl .../t.mbox.gz`; confirmed
  series context and Reviewed-by
- [Phase 4] `b4 am 20260517-scmi_fixes-v1-3-d86daec4defd@kernel.org` →
  found thread on lore.kernel.org
- [Phase 5] `grep fill_custom_report notify.c` → call chain through
  `scmi_process_event_payload()`
- [Phase 5] Read `scmi_iio.c:39-55` → consumer copies
  `sensor_update->readings[]` to IIO buffers
- [Phase 5] Read `notify.c:598-611, 759-789` → upper-bound-only check in
  `scmi_notify()`; scratch buffer sized to max
- [Phase 6] Confirmed buggy code at `sensors.c:1082-1098` without fix
- [Phase 6] `git branch` shows `HEAD detached at stable/linux-6.18.y`
- [Phase 6] No existing SENSOR_UPDATE validation fix in tree
- [Phase 8] Assessed failure as stale-data reads → incorrect sensor
  values, not kmalloc overflow (scratch buffer pre-allocated to
  `max_payld_sz`)

**YES****Verdict: YES** — backport to `linux-6.18.y`.

The `SCMI_EVENT_SENSOR_UPDATE` handler in
`drivers/firmware/arm_scmi/sensors.c` parses variable-length sensor
readings without checking that the notification payload is large enough.
Truncated messages can produce incorrect readings that reach IIO/hwmon
consumers.

The fix is small (9 lines), reviewed by SCMI maintainer Cristian
Marussi, and matches validation patterns already used elsewhere in the
driver. Patch 1/4 of the same series is already in this tree; this one
is standalone and should apply cleanly.

 drivers/firmware/arm_scmi/sensors.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/sensors.c b/drivers/firmware/arm_scmi/sensors.c
index 1be0f89fc2c4b..99233742714c9 100644
--- a/drivers/firmware/arm_scmi/sensors.c
+++ b/drivers/firmware/arm_scmi/sensors.c
@@ -1074,12 +1074,15 @@ scmi_sensor_fill_custom_report(const struct scmi_protocol_handle *ph,
 	case SCMI_EVENT_SENSOR_UPDATE:
 	{
 		int i;
+		size_t expected_sz;
 		struct scmi_sensor_info *s;
 		const struct scmi_sensor_update_notify_payld *p = payld;
 		struct scmi_sensor_update_report *r = report;
 		struct sensors_info *sinfo = ph->get_priv(ph);
 
-		/* payld_sz is variable for this event */
+		if (payld_sz < sizeof(*p))
+			break;
+
 		r->sensor_id = le32_to_cpu(p->sensor_id);
 		if (r->sensor_id >= sinfo->num_sensors)
 			break;
@@ -1093,6 +1096,11 @@ scmi_sensor_fill_custom_report(const struct scmi_protocol_handle *ph,
 		 * readings defined for this sensor or 1 for scalar sensors.
 		 */
 		r->readings_count = s->num_axis ?: 1;
+		expected_sz = sizeof(*p) + r->readings_count *
+			      sizeof(p->readings[0]);
+		if (payld_sz < expected_sz)
+			break;
+
 		for (i = 0; i < r->readings_count; i++)
 			scmi_parse_sensor_readings(&r->readings[i],
 						   &p->readings[i]);
-- 
2.53.0

