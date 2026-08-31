Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C621C4EE841;
	Mon, 31 Aug 2026 13:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183643; cv=none; b=jpjmIiVjuHdIkUAz0RgeFd9WdhayIx1hrj9Ik5EEetYUx61LO44WNKKH4tGiYTEBf0ZUkIMxg6qe1FpC+ASw4TNxSpBZ5LIocGo9b9vgM/6gRaAFhyCSiNfhrgFTwxLcPnLy4o/b6ZBPTmIG8qQ9CwyZ1a64Bnad5F92lvImonE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183643; c=relaxed/simple;
	bh=azQwWZCqGTN20xijGibFqhDOiiyrv1F4YnbkYJ7WPfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urUiqXrReO7XccYwkWhHAYTBHqjoQReHS2ysBGpJH9W2jQ1x08gxRsGAFujWcXFSciX2lCh8GtyQh6Dl96ZapRRB2WkMX6/GdfhJCO/N+cLhDkTxue1Ebt1dCAW3kQx3ZOdP57fhm9uL/pt+9zB0BuJjsjTktz9vZwIzeAVNPJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VlFPWqfx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlFPWqfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAB91F000E9;
	Mon, 31 Aug 2026 13:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183640;
	bh=eHW04iVrIBNdytuxwg466nIlWzszNOWJnFQFON4ayFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlFPWqfxLWF/xwlrteqes56fwBXqN0+ug6hWst9mgB0GdCk4KIEZw7vY+UlME12DS
	 ICOrrpX563RY68/v2a4f+luCdrSyS0aNELWZ19djSZpBHmED8hhkQn4JuNaL55v41g
	 Q+fOnK2mVy5jMkHmnfMgbBxNjzQV2Jb+UWNAWUXc1MTEmR5nAqYgjYxllXxiVnj7Zt
	 SUE4LKdtFuDOfp6QkTUiqm3VucMbw9z0Yo5COcUGsRNl6SYBJQDe2BOHFBu1o7mFUq
	 dK8SLyzNnQHKHjOWhupZQxctzCX2tX2y4Pi5RX3xsskd88e3pQmEfJDcKgwyRyUsnK
	 KtpnFNBVflTgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	maciej.wieczor-retman@intel.com,
	pawel.chmielewski@intel.com,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: validate handler object type in two places
Date: Mon, 31 Aug 2026 09:24:02 -0400
Message-ID: <20260831133314.4125787-214-sashal@kernel.org>
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

From: ikaros <void0red@gmail.com>

[ Upstream commit c5296da2d516707862f8a2dbb4b515f777e5294f ]

ACPICA: validate handler object type in acpi_ev_has_default_handler()
and acpi_ev_find_region_handler().

Link: https://github.com/acpica/acpica/commit/f6fc648a1389
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/48111441.fMDQidcC6G@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ACPICA handler object type validation

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `make kernelversion`
= 6.18.44)
**Candidate commit (mainline):** `c5296da2d5167` — same diff as upstream
ACPICA `f6fc648a1389`
**Status in this tree:** Fix is **not** present; vulnerable code is
present.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ACPICA] [validate] validate handler object type in
acpi_ev_has_default_handler() and acpi_ev_find_region_handler()`

### Step 1.2: Tags
**Record:**
- **Link:** https://github.com/acpica/acpica/commit/f6fc648a1389
- **Link:**
  https://patch.msgid.link/48111441.fMDQidcC6G@rafael.j.wysocki
- **Signed-off-by:** ikaros \<void0red@gmail.com\>
- **Signed-off-by:** Rafael J. Wysocki \<rafael.j.wysocki@intel.com\>
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Reviewed-
  by:`, `Tested-by:`, or `Acked-by:` tags in the commit message
- Notable: upstream ACPICA issue #1132 documents an ASAN global-buffer-
  overflow; author is the issue reporter

### Step 1.3: Body text
**Record:**
- **Bug:** Handler linked lists walked via `common_notify.handler`
  assume every node is `ACPI_TYPE_LOCAL_ADDRESS_HANDLER`, but the list
  can contain objects of another type (corrupt/crafted ACPI state).
- **Symptom:** Out-of-bounds read when accessing
  `address_space.space_id` or `address_space.next` on a non-address-
  handler object (ASAN: global-buffer-overflow, 8-byte read in
  `AcpiEvFindRegionHandler`).
- **Root cause:** Missing type check before interpreting union members
  as `address_space` fields.
- **Version info:** None in commit message; upstream ACPICA fix dated
  2026-03-20.

### Step 1.4: Hidden bug fix?
**Record:** Yes — although the subject says “validate,” this is a
memory-safety fix preventing buffer overflow on handler-list traversal,
not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/acpi/acpica/evhandler.c` (+11 lines, 0 removed)
- **Functions modified:** `acpi_ev_has_default_handler()`,
  `acpi_ev_find_region_handler()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (`acpi_ev_has_default_handler`):** Before — walked handler
  list unconditionally using `address_space` fields. After — breaks loop
  if `handler_obj->common.type != ACPI_TYPE_LOCAL_ADDRESS_HANDLER`.
- **Hunk 2 (`acpi_ev_find_region_handler`):** Same type check added
  before `space_id` comparison and `next` pointer chase.
- **Paths affected:** Normal ACPI handler lookup during region
  initialization, handler installation, and namespace walks.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Memory safety / buffer overflow (out-of-bounds read)
- **Mechanism:** `union acpi_operand_object` is accessed as
  `address_space` without verifying `common.type`. Wrong type → wrong
  union layout → read past valid object memory via
  `address_space.space_id` (1 byte + padding) or `address_space.next`
  (8-byte pointer read per ASAN report).

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and obviously correct: `common_notify.handler` is
  documented as the address-space handler list; only
  `ACPI_TYPE_LOCAL_ADDRESS_HANDLER` objects belong there.
- **Regression risk:** Very low. On type mismatch, loop terminates (same
  as list end). Worst case: handler not found where list was already
  corrupt — far safer than OOB read.
- No API changes, no locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `acpi_ev_has_default_handler` walk loop: `42f8fb75c43cc6` (Bob Moore,
  2013-01-11) — long-standing code
- `acpi_ev_find_region_handler`: `7b73806485ada` (Bob Moore,
  2015-12-29), introduced by `f31a99cefd05f` “Deploys
  acpi_ev_find_region_handler()”
- Bug predates 6.18.y branch by many years

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Upstream ACPICA references GitHub
issue #1132 (ASAN global-buffer-overflow in `AcpiEvFindRegionHandler`).

### Step 3.3: Related file history
**Record:**
- Recent `evhandler.c` changes in this tree are copyright updates and
  unrelated fixes (e.g. `c27f3d011b085` I2C/GPIO race).
- `aa6abd2be1cc7` (2015) moved address handlers to
  `common_notify.handler` — architectural context, not the bug
  introducer.
- Fix is **standalone**; patch 18/27 in the ACPICA sync series but does
  not depend on patches 1–17.

### Step 3.4: Author context
**Record:** ikaros reported the upstream ACPICA bug and authored 14
hardening patches in the same series. Rafael J. Wysocki (ACPI
maintainer) signed off and committed to mainline.

### Step 3.5: Dependencies
**Record:** None. Uses `ACPI_TYPE_LOCAL_ADDRESS_HANDLER` (defined in
`include/acpi/actypes.h` as `0x18` in this tree). No prerequisite
commits required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/48111441.fMDQidcC6G@rafael.j.wysocki
- **Series:** `[PATCH v1 18/27]` in “ACPI: ACPICA 20260408” series by
  Rafael Wysocki
- **Revisions:** v1 only found via `b4 dig -a`
- No explicit stable nomination or NAK found in thread grep
- Cover letter groups this with other ikaros buffer-overflow / memory-
  safety hardening patches

### Step 4.2: Reviewers
**Record:** CC’d: Rafael J. Wysocki, linux-acpi, LKML, Saket Dumbre,
Pawel Chmielewski (Intel ACPICA maintainers). Signed-off-by from Rafael
J. Wysocki.

### Step 4.3: Bug report
**Record:**
- **GitHub issue #1132:** ASAN global-buffer-overflow, READ of 8 bytes
  in `AcpiEvFindRegionHandler`
- **Reproducer:** `./acpiexec -m issue26.aml` (crafted AML)
- **Severity:** Memory safety bug with concrete ASAN proof

### Step 4.4: Related patches
**Record:** Part of 27-patch ACPICA sync; 13 other ikaros hardening
patches in same series. This patch is independently applicable.

### Step 4.5: Stable list discussion
**Record:** No stable@vger.kernel.org discussion found for this specific
patch (lore blocked for web fetch; mbox grep found no “Cc: stable”).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `acpi_ev_has_default_handler()`,
`acpi_ev_find_region_handler()`

### Step 5.2: Callers
**Record:**
- `acpi_ev_has_default_handler()` ← `acpi_ev_initialize_op_regions()` in
  `evregion.c` (boot-time `_REG` method execution)
- `acpi_ev_find_region_handler()` ←
  - `acpi_ev_install_handler()` (namespace walk during handler install)
  - `acpi_ev_install_space_handler()` (handler installation)
  - `acpi_ev_region_init()` path in `evrgnini.c` (region attachment
    during init)
  - `dbdisply.c` (debug only, `CONFIG_ACPI_DEBUG`)

### Step 5.3: Callees
**Record:** Functions read `obj_desc->common_notify.handler`, then walk
list accessing `address_space.space_id`, `handler_flags`, `next`. No
allocation in the fixed loops.

### Step 5.4: Reachability
**Record:**
- **Boot path:** `tbxfload.c` → `acpi_ev_install_region_handlers()`;
  `nsinit.c` → `acpi_ev_initialize_op_regions()`
- **Runtime:** `acpi_install_address_space_handler()` used by EC, GPIO,
  I2C, PMIC, PCC, and platform drivers
- **Trigger:** Corrupt/crafted ACPI AML that leaves non-address-handler
  objects on the handler list
- **Userspace:** Not directly syscall-reachable, but ACPI tables are
  firmware-controlled; root can override tables on some systems

### Step 5.5: Similar patterns
**Record:** Other ACPICA code validates `common.type` before union
access (e.g. `exdump.c`, `utdecode.c`, `nsobject.c`). `evxfregn.c` and
`dbdisply.c` still walk handler lists without type checks — fix is
partial but addresses the two functions named in the ASAN stack trace.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `evhandler.c` lines 132–141 and 294–305
lack type validation. Bug present since at least 2013/2015.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Mainline diff applies identically
to this tree’s `evhandler.c` (verified via `git show c5296da2d5167`
against current file).

### Step 6.3: Related fixes already present?
**Record:** **No.** `git grep 'validate handler object type'` returns
nothing in this tree. Fix exists on `all-next` as `c5296da2d5167` but
not on `stable/linux-6.18.y` at `v6.18.44`.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** **ACPI / ACPICA events subsystem** — **CORE** (affects all
ACPI-enabled x86/ARM systems at boot and during device operation).

### Step 7.2: Activity
**Record:** Actively maintained; periodic ACPICA upstream syncs. Long-
standing handler-list code with recent hardening focus from fuzzing.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** All systems with `CONFIG_ACPI` during ACPI table load,
operation-region initialization, and address-space handler installation.

### Step 8.2: Trigger conditions
**Record:** Handler list containing a
non-`ACPI_TYPE_LOCAL_ADDRESS_HANDLER` object — demonstrated with crafted
AML (`issue26.aml`). Uncommon in the field but plausible with
malicious/corrupt ACPI tables or interpreter bugs. Requires ACPI
processing context (boot or module load), not arbitrary unprivileged
syscall.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds **read** (8 bytes) → kernel oops/crash or
information leak. **Severity: HIGH** (memory safety in core boot path).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents OOB read in widely used ACPI core code
- **Risk:** VERY LOW — 11-line defensive check, ACPI maintainer-reviewed
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- ASAN-confirmed global-buffer-overflow (upstream issue #1132)
- Buggy code present in 6.18.44 since 2013/2015
- Small, surgical, standalone fix (+11 lines, one file)
- ACPI maintainer signed off
- Affects boot-time and runtime ACPI handler paths
- Consistent with ACPICA hardening pattern (type check before union
  access)

**AGAINST backport:**
- Reproducer uses crafted AML via `acpiexec` — field trigger frequency
  uncertain
- Fix does not cover all similar walks (`evxfregn.c`, `dbdisply.c`) —
  incomplete hardening
- Part of larger 27-patch series (though this patch is independent)

**Unresolved:**
- No kernel-runtime reproducer confirmed (only upstream `acpiexec` tool)
- No explicit stable nomination in mailing list thread

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   ASAN-tested upstream; maintainer SOB
2. Fixes a real bug affecting users? **PASS** — ASAN OOB read with
   concrete reproducer
3. Important issue? **PASS** — memory safety in ACPI core (HIGH
   severity)
4. Small and contained? **PASS** — 11 lines, one file, two functions
5. No new features or APIs? **PASS** — defensive validation only
6. Can apply to local tree? **PASS** — clean apply to 6.18.44

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
as a core memory-safety bug fix.

### Step 9.4: Decision rationale
For **this** 6.18.y tree, the vulnerable handler-list walk code exists
and is reachable during ACPI initialization and handler management. The
fix prevents a demonstrated out-of-bounds read with negligible
regression risk. Incomplete coverage of similar walks elsewhere does not
diminish the value of fixing the two functions implicated in the ASAN
report.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from commit `c5296da2d5167`
  and user-provided message
- **[Phase 1]** Fetched upstream ACPICA commit and issue #1132 from
  GitHub — confirmed ASAN global-buffer-overflow
- **[Phase 2]** Analyzed diff: +11 lines in `evhandler.c`, two type-
  check hunks
- **[Phase 3]** `git blame`: buggy loops from 2013 and 2015
- **[Phase 3]** `git show aa6abd2be1cc7`: `common_notify.handler` used
  for address-space handlers since 2015
- **[Phase 3]** No `Fixes:` tag to follow
- **[Phase 3]** Fix not in stable tree; present on `all-next` as
  `c5296da2d5167`
- **[Phase 4]** `b4 dig -c c5296da2d5167`: found lore thread at
  patch.msgid.link
- **[Phase 4]** `b4 dig -a`: v1, patch 18/27 in ACPICA 20260408 series
- **[Phase 4]** `b4 dig -w`: Rafael Wysocki, linux-acpi, Intel
  maintainers CC’d
- **[Phase 4]** Downloaded mbox; grep found no stable nomination or NAK
  for this patch
- **[Phase 5]** `grep` callers: `evregion.c`, `evrgnini.c`,
  `evhandler.c`, `dbdisply.c`
- **[Phase 5]** Traced boot path: `tbxfload.c` →
  `acpi_ev_install_region_handlers()`, `nsinit.c` →
  `acpi_ev_initialize_op_regions()`
- **[Phase 5]** `grep acpi_install_address_space_handler`: used by EC,
  GPIO, I2C, PMIC, platform drivers
- **[Phase 6]** `git describe HEAD`: v6.18.44 on `stable/linux-6.18.y`
- **[Phase 6]** Read current `evhandler.c`: vulnerable code confirmed at
  lines 132–141, 294–305
- **[Phase 6]** `git show c5296da2d5167`: diff applies cleanly to
  current file
- **[Phase 6]** `grep 'validate handler object type'`: no match in tree
- **[Phase 8]** GitHub issue #1132: ASAN READ 8 bytes, reproducer
  `acpiexec -m issue26.aml`

---

**YES**The background `git log --grep` search timed out on this repo, so
I killed it and used targeted lookups instead (`b4 dig`, `git show
c5296da2d5167`, direct file reads). That was enough to finish the
analysis.

**Verdict for 6.18.44:** backport **YES** — the fix prevents an ASAN-
confirmed out-of-bounds read when walking ACPI address-space handler
lists, and it applies cleanly as an 11-line change to `evhandler.c`.

 drivers/acpi/acpica/evhandler.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/acpica/evhandler.c b/drivers/acpi/acpica/evhandler.c
index 5a35dae945e20..f16c1148e602e 100644
--- a/drivers/acpi/acpica/evhandler.c
+++ b/drivers/acpi/acpica/evhandler.c
@@ -130,6 +130,14 @@ acpi_ev_has_default_handler(struct acpi_namespace_node *node,
 		/* Walk the linked list of handlers for this object */
 
 		while (handler_obj) {
+
+			/* Validate handler object type before accessing fields */
+
+			if (handler_obj->common.type !=
+			    ACPI_TYPE_LOCAL_ADDRESS_HANDLER) {
+				break;
+			}
+
 			if (handler_obj->address_space.space_id == space_id) {
 				if (handler_obj->address_space.handler_flags &
 				    ACPI_ADDR_HANDLER_DEFAULT_INSTALLED) {
@@ -292,6 +300,9 @@ union acpi_operand_object *acpi_ev_find_region_handler(acpi_adr_space_type
 	/* Walk the handler list for this device */
 
 	while (handler_obj) {
+		if (handler_obj->common.type != ACPI_TYPE_LOCAL_ADDRESS_HANDLER) {
+			break;
+		}
 
 		/* Same space_id indicates a handler is installed */
 
-- 
2.53.0

