Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EBA5087E5;
	Mon, 19 Oct 2026 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418164; cv=none; b=jVNEkJ1XYFviT1i5miU5tT1RdIxSpLR0A2UPc9TaWdktWqqNTQX8jd4gFREbGkAar5s2aX/IbtimD77wwhz958N0cQYIBKq4gpfa1ruikUiknfFNwlEw7txJiDYL2Zr8cQ/M5HeLdUk0iqyOOJbv+1f7FUaBi1pPTiiyfNaJ2n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418164; c=relaxed/simple;
	bh=mE4c5XPQP0gPoUCFzwEGDU+ClOrOyyVumsH/AkoQ/N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YgpNgqw8pUIhpdeVrmMzaymXXRlsmBozwoytMS1qo4feCZlRhchuarnALFw5VeXbzOWV7v3e5HpZmrk/JCwJoAwxULKAJ1NL6eqC0khMNG8ZRHvw7oJMzbIpDNHJwOVrkGK2kmqKu4QtPDzlUOdosf48opeW/euMjqNyYyHJ3Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rf/SFJOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rf/SFJOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6651F000C5;
	Mon, 19 Oct 2026 13:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418161;
	bh=VXIqA+vWM+D/a4jO+k80ffaFziKi9uGiLkkJ5W3CfWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rf/SFJOnQzhr7Z92zQubZNQOnEnLUA7g3+eBm5PVlTAQSKKvX7ScbjYPvN/cw2V2e
	 8x3LXbc2pH2phJck3v5Y4fy9fMVm1Y3Pqu8fw4MD5+rCMROU7Qgbkk261esWZ5IpDE
	 6H+SOaTgGKK8drPvsixDJRuLfttTQLohVsdVExIVPzbwhWTtxx+6hKJQh6D6BnHl/T
	 Gy0uZKqCdLKy/obLnus+OAnzwC+dtLXaLlERmlmAlrxR+fNE9ojvlFQ22DPWf/iJl7
	 KXXfDAlQtjJk05kHz955Am+zWt5I/5QTlhODoMrcgkiXcfbOAYgCqY/C4n0ypRxYpW
	 HkHRnVsrfIahg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amdgpu: Validate ATIF buffer length before use
Date: Mon, 19 Oct 2026 09:45:46 -0400
Message-ID: <20261019135441.1420968-55-sashal@kernel.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit b978b7d43963bbb3e2d850288f7c21ac11c3b751 ]

Add a min_size parameter to amdgpu_atif_call() to validate that the
returned ACPI buffer is of type ACPI_TYPE_BUFFER, holds at least a u16
size field, does not claim more data than was actually returned, and
meets the minimum size required by the calling function. Each caller
passes its required minimum via sizeof() or offsetof() of the expected
output struct and drops its own size check.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Assisted-by: Claude Sonnet (Cursor AI)
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a firmware-buffer bounds check in `amdgpu_atif_call()`. On this
6.18.53 tree the buggy path is still present, the patch is small, and it
closes a real out-of-bounds read.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[drm/amdgpu] [Validate] Validate ATIF buffer length before use`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>` (author)
- `Assisted-by: Claude Sonnet (Cursor AI)`
- `Acked-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable`, or syzbot
  tags (absence expected)
- Upstream SHA from the candidate wrapper:
  `b978b7d43963bbb3e2d850288f7c21ac11c3b751` (ignored as a selection
  marker; used only to find the original discussion)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: ACPI ATIF responses are used without checking that the returned
  buffer actually contains the `u16` size field, that the BIOS-reported
  size does not exceed the ACPI object length, or that the payload meets
  the caller’s minimum.
- Symptom/failure mode: out-of-bounds read (and possible oops) when
  firmware returns a short or lying buffer, then callers `memcpy()`
  using the claimed size.
- Version info: none in the message. The pattern dates to `d38ceaf99ed0`
  (“drm/amdgpu: add core driver (v4)”, 2015).
- Root cause: callers trusted `*(u16 *)info->buffer.pointer` and copied
  that many bytes without comparing it to `obj->buffer.length`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: This is an explicit memory-safety fix, not cleanup. Centralizing
existing per-caller `size < N` checks is incidental; the new `actual >=
sizeof(u16)` and `actual >= claimed` tests are the real fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c` (+34/−34)
- Functions: `amdgpu_atif_call`, `amdgpu_atif_verify_interface`,
  `amdgpu_atif_get_notification_params`,
  `amdgpu_atif_query_backlight_caps`, `amdgpu_atif_get_sbios_requests`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record (v6.18.53 before → after):
- `amdgpu_atif_call()`: after confirming `ACPI_TYPE_BUFFER`, return the
  object. After: reject length `< sizeof(u16)`, claimed size `> actual`
  length, or claimed size `< min_size`.
- Callers: pass `sizeof()` / `offsetof()` as `min_size` and drop their
  own `size < 12/10/10/0xd` checks. `memcpy` still uses
  `min(sizeof(struct), claimed_size)`, now only after those checks.

Verified struct sizes in `drivers/gpu/drm/amd/include/amd_acpi.h`
(`__packed`):
- `sizeof(atif_verify_interface)` = 12 (replaces `size < 12`)
- `offsetof(atif_system_params, command_code)` = 10 (replaces `size <
  10`; the `size < 11` command_code path remains)
- `offsetof(atif_qbtc_output, data_points)` = 10 (replaces `size < 10`)
- `sizeof(atif_sbios_requests)` = 13 = `0xd` (replaces `size < 0xd`)

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[Memory safety / OOB] [Firmware-controlled size used as memcpy
length]`

v6.18.53 callers still do:

```
size = *(u16 *)info->buffer.pointer;
size = min(sizeof(output), size);
memcpy(&output, info->buffer.pointer, size);
```

If `obj->buffer.length` is 0 or 1, the `u16` load is already OOB. If
claimed size is 12 and actual length is 4, `memcpy` copies 12 bytes from
a 4-byte ACPI payload (heap OOB read). `c9b7c809b89f2` only checked
object type, not length; that hole is still in this tree.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. Rejecting `claimed > actual` can disable ATIF
on a BIOS that lies about size but still returned enough bytes; that is
malformed firmware, and the fallback is “ATIF unused” rather than a
crash. Error codes change from `-EINVAL` to `-EIO` on undersized
buffers; callers only test `if (ret)` / disable the feature. Low
regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Size-then-memcpy logic is from `d38ceaf99ed0` (Alex Deucher,
2015, “drm/amdgpu: add core driver (v4)”). Type check added by
`c9b7c809b89f2` (2024). NULL-on-`AE_NOT_FOUND` fixed by `91c9e221fe255`
(2024). Length vs claimed size was never checked.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The bug is in original ATIF parsing, present
since 2015. Both `d38ceaf99ed0` and `c9b7c809b89f2` are ancestors of
`v6.18.53`.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `c9b7c809b89f2` “Guard against bad data for ATIF ACPI method” — real
  oops in `amdgpu_atif_query_backlight_caps`; later tagged
  CVE-2024-50117; already in this tree.
- `91c9e221fe255` — NULL deref if ATIF missing; already in this tree.
- Sibling `9d367fab451d9` “Validate ATPX buffer length before use” is
  patch 2/2 on a different file; not a prerequisite.
- No later commits on this file after the candidate that rework the same
  logic.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Lijo Lazar is a regular AMD amdgpu contributor (ATPX/ATRM/XCP
bounds checks in the same wave). Maintainer Acked-by/SOB from Alex
Deucher.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. `amdgpu_atif_call` is static with four local
callers, all updated. No new helpers. ATPX 2/2 is independent.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c b978b7d43963...` failed (lore.kernel.org returned errors).
- Original submission: `[PATCH 1/2] drm/amdgpu: Validate ATIF buffer
  length before use`, 14 Jun 2026, https://www.mail-archive.com/amd-
  gfx@lists.freedesktop.org/msg145004.html
- Series: 1/2 ATIF, 2/2 ATPX. No v2 found.
- No NAKs found. Merged via Alex Deucher’s `drm-next-7.3` pull; Dave
  Airlie acked the pull.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Posted to amd-gfx. Acked/signed by Alex Deucher. Recipients from
`b4 dig -w` could not be retrieved (lore 403).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: This commit has no new user report. The related 2024 ATIF bad-
data oops (`c9b7c809b89f2`) was hit on at least one system and became
CVE-2024-50117. That earlier fix did not validate lengths.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 1/2 of ATIF+ATPX ACPI buffer validation. ATRM buffer checks in
the same author batch. ATIF is self-contained.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403. No verified stable-
list discussion. Prior ATIF guard *was* taken into stable
(CVE-2024-50117).

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `amdgpu_atif_call` plus the four callers listed above. No
semcode tools available.

**Step 5.2: TRACE CALLERS**
Record:
- `amdgpu_atif_verify_interface` ← `amdgpu_atif_pci_probe_handle` ←
  `amdgpu_acpi_detect` ← `amdgpu_drv.c` (driver load)
- `amdgpu_atif_get_notification_params` /
  `amdgpu_atif_query_backlight_caps` ← `amdgpu_acpi_detect`
- `amdgpu_atif_get_sbios_requests` ← `amdgpu_atif_handler` ← ACPI
  notifier (`amdgpu_acpi_event`) on brightness/hotplug-style events

**Step 5.3: TRACE CALLEES**
Record: `acpi_evaluate_object`, then `memcpy` of firmware bytes into
stack structs.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reached on every amdgpu load when the GPU’s ACPI node has ATIF
(common on AMD laptops/APUs). SBIOS request path runs on ACPI video
notifies. Unprivileged userspace cannot call ATIF directly; a guest/VM
with a crafted ACPI table can. Firmware bugs have already crashed this
path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same claimed-size-then-memcpy pattern remains in
`amdgpu_atcs_call` callers in this file and in `radeon_acpi.c`. This
patch does not touch those; not a reason to reject the ATIF fix.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Local tree is **6.18.53** (`v6.18.53-5049-g0f0bdc2b0dffb`,
branch `autosel`). `git merge-base --is-ancestor c8373721c3e54 v6.18.53`
is false. `v6.18.53:drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c` still has
the unvalidated `*(u16 *)` / `memcpy` sequence. Bug introduced in 2015
(`d38ceaf99ed0`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: `git diff v6.18.53 c8373721c3e54 --
drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c` is exactly this commit
(+34/−34). Mainline `noinline_for_stack` is not in 6.18; the candidate
as it exists here already matches 6.18. Clean apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Type/NULL guards (`c9b7c809b89f2`, `91c9e221fe255`) are in
6.18.53. Length validation is not. No alternate fix.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `[drm/amdgpu ACPI/ATIF] [IMPORTANT]` — not core mm/net, but a
widely used GPU driver on AMD laptops.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively developed; this ATIF parsing has been stable since 2015
aside from the 2024 type/NULL guards.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: AMD GPU systems whose ACPI provides ATIF (typical AMD
laptop/APU). Config: `CONFIG_DRM_AMDGPU`.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Driver probe always; ACPI notifies for SBIOS requests. Needs a
short or lying ATIF buffer. Unprivileged userspace cannot trigger it on
bare metal; firmware/VM ACPI can. Prior ATIF bad-data crashes were seen
in the wild.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: `[OOB read → possible oops / info leak] [HIGH]` Same class as
CVE-2024-50117, remaining hole.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit high (closes firmware OOB on a common driver). Risk low
(~30-line single-file change, fail-closed). Ratio favors backport.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB: claimed ATIF size used as `memcpy` length without comparing
  to ACPI buffer length.
- Same subsystem already produced a stable/CVE oops from unvalidated
  ATIF data (`c9b7c809b89f2` / CVE-2024-50117); that patch did not check
  lengths.
- Buggy code is in this 6.18.53 tree since 2015.
- Small, contained, no new API; maintainer Acked-by.
- Applies cleanly here.
- Failure is crash/OOB, not a feature change.

AGAINST:
- No dedicated report for *this* length mismatch (hardening of a known-
  bad path).
- Undersized-buffer errno changes `-EINVAL` → `-EIO` (callers treat both
  as failure).
- Sibling ATPX patch is separate and not required.

UNRESOLVED:
- `b4 dig` / lore.kernel.org returned errors; discussion recovered from
  mail-archive.
- No stable@ thread found (lore 403).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — checks match existing
   minima; maintainer merged.
2. Fixes a real bug that affects users? **PASS** — OOB on malformed
   ATIF; ATIF bad data already crashed systems.
3. Important issue? **PASS** — HIGH: OOB read / oops from firmware data.
4. Small and contained? **PASS** — one file, +34/−34.
5. No new features or APIs? **PASS** — static helper only.
6. Can apply to the local tree? **PASS** — identical to `v6.18.53` file
   plus this diff.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs exception. Ordinary memory-safety
bug fix.

**Step 9.4: MAKE YOUR DECISION**
Backport. It closes a leftover ATIF buffer-length hole on this 6.18 tree
with a small, fail-closed change.

### What the commit solves for stable users
On 6.18, `amdgpu_atif_call()` only rejects non-buffer ACPI objects.
Callers then trust a BIOS `u16` size and `memcpy` that many bytes. A
short or inflated ATIF payload over-reads kernel heap and can oops — the
same ATIF path that already oopsed in 2024. This patch requires actual
length ≥ 2, actual ≥ claimed, and claimed ≥ caller minimum before any
copy.

### Risk vs benefit
Benefit is preventing oops/OOB on AMD systems with ATIF. Risk is
disabling ATIF on lying firmware instead of crashing. That is the right
stable tradeoff.

### Concerns
ATPX 2/2 is not required. ATCS/radeon still have the old pattern; out of
scope. No extra 6.18 prerequisites.

Verification:
- [Phase 1] Tags: author SOB, Claude Assisted-by, Alex Deucher Acked-
  by/SOB; no Fixes/Reported-by/syzbot
- [Phase 2] Diff: +34/−34 in `amdgpu_acpi.c`; length checks in
  `amdgpu_atif_call`; callers pass sizeof/offsetof
- [Phase 2] Struct sizes: 12, offsetof 10, offsetof 10, 13 match old
  magic constants
- [Phase 3] blame: size/memcpy from `d38ceaf99ed0` (2015); type check
  `c9b7c809b89f2` (in 6.18.53)
- [Phase 3] `git merge-base --is-ancestor d38ceaf99ed0 v6.18.53` true;
  `c9b7c809b89f2` true; this commit false
- [Phase 3] ATPX sibling `9d367fab451d9` is a different file; not a
  dependency
- [Phase 4] `b4 dig` failed (lore error). Thread: mail-archive
  msg145004, series 1/2. Pulled in drm-next-7.3
- [Phase 4] lore/stable 403; UNVERIFIED whether stable@ discussed this
  SHA
- [Phase 5] Callers: probe via `amdgpu_acpi_detect`, ACPI notify via
  `amdgpu_atif_handler`
- [Phase 6] `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`;
  Makefile 6.18.53
- [Phase 6] `git diff v6.18.53 <commit> -- amdgpu_acpi.c` equals this
  patch (clean apply)
- [Phase 8] Failure mode: heap OOB read / oops; severity HIGH
- UNVERIFIED: exact To/Cc list (`b4 dig -w` unavailable)

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 68 ++++++++++++------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 36f429e7f2027..5a04c20a5fd15 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -138,13 +138,15 @@ static struct amdgpu_acpi_priv {
  * @atif: atif structure
  * @function: the ATIF function to execute
  * @params: ATIF function params
+ * @min_size: minimum size of the expected output buffer in bytes
  *
  * Executes the requested ATIF function (all asics).
  * Returns a pointer to the acpi output buffer.
  */
 static union acpi_object *amdgpu_atif_call(struct amdgpu_atif *atif,
 					   int function,
-					   struct acpi_buffer *params)
+					   struct acpi_buffer *params,
+					   size_t min_size)
 {
 	acpi_status status;
 	union acpi_object *obj;
@@ -187,6 +189,28 @@ static union acpi_object *amdgpu_atif_call(struct amdgpu_atif *atif,
 		return NULL;
 	}
 
+	if (obj->buffer.length < sizeof(u16)) {
+		DRM_DEBUG_DRIVER("ATIF buffer too small to hold size field: %u\n",
+				 obj->buffer.length);
+		kfree(obj);
+		return NULL;
+	}
+
+	if (obj->buffer.length < *(u16 *)obj->buffer.pointer) {
+		DRM_DEBUG_DRIVER("ATIF buffer length mismatch: reported %u, actual %u\n",
+				 *(u16 *)obj->buffer.pointer,
+				 obj->buffer.length);
+		kfree(obj);
+		return NULL;
+	}
+
+	if (*(u16 *)obj->buffer.pointer < min_size) {
+		DRM_DEBUG_DRIVER("ATIF buffer too small: expected %zu, got %u\n",
+				 min_size, *(u16 *)obj->buffer.pointer);
+		kfree(obj);
+		return NULL;
+	}
+
 	return obj;
 }
 
@@ -248,19 +272,14 @@ static int amdgpu_atif_verify_interface(struct amdgpu_atif *atif)
 	size_t size;
 	int err = 0;
 
-	info = amdgpu_atif_call(atif, ATIF_FUNCTION_VERIFY_INTERFACE, NULL);
+	info = amdgpu_atif_call(atif, ATIF_FUNCTION_VERIFY_INTERFACE, NULL,
+				sizeof(output));
 	if (!info)
 		return -EIO;
 
 	memset(&output, 0, sizeof(output));
 
-	size = *(u16 *) info->buffer.pointer;
-	if (size < 12) {
-		DRM_INFO("ATIF buffer is too small: %zu\n", size);
-		err = -EINVAL;
-		goto out;
-	}
-	size = min(sizeof(output), size);
+	size = min(sizeof(output), (size_t)*(u16 *)info->buffer.pointer);
 
 	memcpy(&output, info->buffer.pointer, size);
 
@@ -270,7 +289,6 @@ static int amdgpu_atif_verify_interface(struct amdgpu_atif *atif)
 	amdgpu_atif_parse_notification(&atif->notifications, output.notification_mask);
 	amdgpu_atif_parse_functions(&atif->functions, output.function_bits);
 
-out:
 	kfree(info);
 	return err;
 }
@@ -295,20 +313,14 @@ static int amdgpu_atif_get_notification_params(struct amdgpu_atif *atif)
 	int err = 0;
 
 	info = amdgpu_atif_call(atif, ATIF_FUNCTION_GET_SYSTEM_PARAMETERS,
-				NULL);
+				NULL, offsetof(struct atif_system_params, command_code));
 	if (!info) {
 		err = -EIO;
 		goto out;
 	}
 
-	size = *(u16 *) info->buffer.pointer;
-	if (size < 10) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	memset(&params, 0, sizeof(params));
-	size = min(sizeof(params), size);
+	size = min(sizeof(params), (size_t)*(u16 *)info->buffer.pointer);
 	memcpy(&params, info->buffer.pointer, size);
 
 	DRM_DEBUG_DRIVER("SYSTEM_PARAMS: mask = %#x, flags = %#x\n",
@@ -371,20 +383,14 @@ static int amdgpu_atif_query_backlight_caps(struct amdgpu_atif *atif)
 
 	info = amdgpu_atif_call(atif,
 		ATIF_FUNCTION_QUERY_BRIGHTNESS_TRANSFER_CHARACTERISTICS,
-		&params);
+		&params, offsetof(struct atif_qbtc_output, data_points));
 	if (!info) {
 		err = -EIO;
 		goto out;
 	}
 
-	size = *(u16 *) info->buffer.pointer;
-	if (size < 10) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	memset(&characteristics, 0, sizeof(characteristics));
-	size = min(sizeof(characteristics), size);
+	size = min(sizeof(characteristics), (size_t)*(u16 *)info->buffer.pointer);
 	memcpy(&characteristics, info->buffer.pointer, size);
 
 	atif->backlight_caps.caps_valid = true;
@@ -422,24 +428,18 @@ static int amdgpu_atif_get_sbios_requests(struct amdgpu_atif *atif,
 	int count = 0;
 
 	info = amdgpu_atif_call(atif, ATIF_FUNCTION_GET_SYSTEM_BIOS_REQUESTS,
-				NULL);
+				NULL, sizeof(*req));
 	if (!info)
 		return -EIO;
 
-	size = *(u16 *)info->buffer.pointer;
-	if (size < 0xd) {
-		count = -EINVAL;
-		goto out;
-	}
 	memset(req, 0, sizeof(*req));
 
-	size = min(sizeof(*req), size);
+	size = min(sizeof(*req), (size_t)*(u16 *)info->buffer.pointer);
 	memcpy(req, info->buffer.pointer, size);
 	DRM_DEBUG_DRIVER("SBIOS pending requests: %#x\n", req->pending);
 
 	count = hweight32(req->pending);
 
-out:
 	kfree(info);
 	return count;
 }
-- 
2.53.0

