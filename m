Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813E53E3C43;
	Mon, 20 Apr 2026 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691480; cv=none; b=fP1VmP1sVhGSySYE7oeSxhSxO7nZe7w2G8zRUbJHjKsobF8C3BJvsOdcCKSxsLW7G0QfPfEwrjgbkd+AEZZ/48vIF5+yIIr9+2lvaChT+71u9/63wcMyjgiXnkANpScBBDCmCOMC89cJoLcEdulwVfkAhBiXS8vdLD7Sp/YoDlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691480; c=relaxed/simple;
	bh=w8K/tZlqQwMPYqrPVD/IH2QC1A0Enp6MoO/vwdr036I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EDlKID77cFCKiwU2dJAOyB5GUlW+Q6Mhq6uQqm3xGEOKP5japL8M2GmE5S7rlY6SN39zFdLNDQN2rNzF1YET5YGBU7+T8mUPY5zj3Vx463Xms1+THyiVG+PnB947N+MZ5e0lxheCr5FfTCjrJwujfsd+HELQAITviroZyF9w3v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXn23EuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXn23EuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1D1C2BCB6;
	Mon, 20 Apr 2026 13:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691480;
	bh=w8K/tZlqQwMPYqrPVD/IH2QC1A0Enp6MoO/vwdr036I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXn23EuJNWWGqH2UOGUdKjhqpxdtLcOIsakltvZInJhewBIbUIMPoeF83FinH9sf+
	 ieBIh6ZL/Z8r6wRtBd+YE9BniU1K4CsQlGjNZuYHremnMC7ay8rs4wJOSp8QkGbj6m
	 AmFdLlJp7nC+MsykDrrw42xN+4KxyV6nHsqGcvZAyP03EaxJxYWoPBuzM0ctuf/aYO
	 8R8Fzxl7tOtn6dWUNDwyifuk/Nk4Q0HiNK70I2xVXerFG/yAAcZN+7hCPoB3FzBicS
	 m9C1MAfjCor1BofrqMqG/W4daRU5+FsEBZoRwP+yshUKbh2KKrUDt+Eg2Qs1F/N7wY
	 UNZZFPLmFA1Aw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arun T <arun.t@intel.com>,
	Vadillo Miguel <miguel.vadillo@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	israel.a.cepeda.lopez@intel.com,
	hansg@kernel.org,
	linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] i2c: usbio: Add ACPI device-id for NVL platforms
Date: Mon, 20 Apr 2026 09:17:28 -0400
Message-ID: <20260420132314.1023554-54-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arun T <arun.t@intel.com>

[ Upstream commit e43f2df330a1b87c97235e4faade860d15787735 ]

Add device IDs of Nova Lake into i2c-usbio support list

Signed-off-by: Arun T <arun.t@intel.com>
Reviewed-by: Vadillo Miguel <miguel.vadillo@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260410080408.562311-1-arun.t@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have all the information needed. Let me now provide my structured
analysis.

# Analysis: i2c: usbio: Add ACPI device-id for NVL platforms

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Parse subject line**
Record: Subsystem = `i2c: usbio:` (Intel USBIO I2C driver). Action verb
= "Add". Summary = add an ACPI device-id for Nova Lake (NVL) platforms.

**Step 1.2 — Parse all tags**
Record:
- Signed-off-by: Arun T (Intel author)
- Reviewed-by: Vadillo Miguel (Intel)
- Reviewed-by: Sakari Ailus (linux.intel.com — media/imaging area
  maintainer)
- Signed-off-by: Andi Shyti (kernel.org — i2c host drivers maintainer
  who committed it)
- Link: lore.kernel.org posting URL
- No Fixes:, Cc: stable, Reported-by:, or syzbot tags (expected — that's
  why manual review).

**Step 1.3 — Commit body analysis**
Record: Body is a single sentence: "Add device IDs of Nova Lake into
i2c-usbio support list." The change enables the `i2c-usbio` auxbus
driver to bind on Intel Nova Lake laptops where the USBIO USB IO-
expander enumerates with ACPI HID `INTC1118`. Without this, the I2C
child of USBIO won't probe on NVL systems, so MIPI cameras hanging off
the I2C bus become non-functional. No kernel versions explicitly
mentioned, no stack trace — symptom is purely "hardware not supported"
on a new CPU generation.

**Step 1.4 — Hidden bug fix detection**
Record: Not a disguised bug fix. It's a straightforward new-hardware-
enablement ID addition — this category is covered by the stable-rules
"new device IDs" exception rather than the bug-fix rules.

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record: One file, `drivers/i2c/busses/i2c-usbio.c`, +1/-0 line. Single
hunk inside the `usbio_i2c_acpi_hids[]` ACPI match table. Scope =
minimal, single-file, single-line.

**Step 2.2 — Code flow change**
Record: Before: the ACPI match table contained MTL/ARL/LNL/MTL-CVF/PTL
HIDs; a device with HID `INTC1118` would fail to bind the driver. After:
`INTC1118` is listed as NVL, enabling `acpi_device_id` matching and
driver probe. No logic, locking, allocation or control flow is altered.

**Step 2.3 — Bug mechanism category**
Record: Category (h) — hardware enablement (ACPI device ID addition).
Not a memory-safety, synchronization, refcount, or logic fix — just a
new HID table entry so the existing driver binds to a newly shipping
SoC.

**Step 2.4 — Fix quality**
Record: Obviously correct. The change follows the exact pattern of
earlier HID additions (`INTC10D2` for MTL-CVF was added the same way in
72f437e674e54). Zero regression risk — the added entry is only consulted
when ACPI enumerates a device with that specific HID; existing platforms
are unaffected.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame / file age**
Record: File was introduced by `daf161343a39` ("i2c: Add Intel USBIO I2C
driver") which `git describe --contains` resolves to
`v6.18-rc1~76^2~32`, i.e., the driver first landed in v6.18. The HID
table has been touched exactly once since then (MTL-CVF addition
`72f437e674e5`, v6.18-rc2).

**Step 3.2 — Follow Fixes:**
Record: No Fixes: tag — not applicable. This is hardware enablement, not
a regression fix.

**Step 3.3 — File history / related changes**
Record: `git log --oneline -- drivers/i2c/busses/i2c-usbio.c` shows only
three commits total: driver introduction, MTL-CVF HID, and this NVL HID.
Companion patch `gpio: usbio: Add ACPI device-id for NVL platforms` is
1/2 of the same v2 series (confirmed via b4 dig). The two patches are
independent at the file level (different drivers) but conceptually
paired.

**Step 3.4 — Author context**
Record: Author Arun T @intel.com — Intel platform enablement engineer
submitting for new silicon. Committed by Andi Shyti (i2c host drivers
maintainer). Reviewed by Sakari Ailus (co-maintainer of adjacent Intel
IPU/camera code) and Miguel Vadillo (Intel). Appropriate review chain
for a trivial HID addition.

**Step 3.5 — Dependencies**
Record: Standalone at the i2c-usbio.c level. The companion `gpio:
usbio:` patch adds `INTC1118` to the GPIO driver's table; on a real NVL
system both would normally be wanted for full USBIO functionality, but
this i2c patch will apply and function on its own where I2C is needed.

## PHASE 4: MAILING LIST / EXTERNAL RESEARCH

**Step 4.1 — b4 dig original submission**
Record: `b4 dig -c e43f2df330a1b` matched patch-id `48bf0630a4b4c3...`
and located the thread at
`https://lore.kernel.org/all/20260410141038.585760-2-arun.t@intel.com/`
(v2). `b4 dig -a` shows two revisions: v1 (Apr 10) and v2 (Apr 10).
Applied version is the latest v2.

**Step 4.2 — Reviewers**
Record: `b4 dig -w` shows recipients = Arun T,
israel.a.cepeda.lopez@intel.com, hansg@kernel.org (Hans de Goede, MIPI
camera / x86 platforms), andi.shyti@kernel.org (i2c maintainer),
sakari.ailus@linux.intel.com, miguel.vadillo@intel.com,
linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org. The right
maintainers and lists were CC'd.

**Step 4.3 — Bug reports**
Record: Not applicable — no bug report; the patch is proactive hardware
enablement.

**Step 4.4 — Series context**
Record: Series is `[PATCH v2 0/2] Add Nova Lake (NVL) ACPI device IDs to
the usbio GPIO and I2C drivers.` Only two trivial patches, one per
driver, each standalone.

**Step 4.5 — Stable-list discussion**
Record: Saved thread to `/tmp/nvl_thread.mbox`. Only reply from Andi
Shyti on v2 was: "This patch has already been merged." No stable
nomination and no concerns raised. v1→v2 difference was purely cosmetic
(commit message trailing period + Reviewed-by from Sakari).

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: No functions modified. Only the static `usbio_i2c_acpi_hids[]`
table is extended.

**Step 5.2 — Callers**
Record: The table is referenced by the auxiliary driver registration
machinery in `usbio_i2c_driver`; the HID match is consulted during ACPI
device probe. Callers are kernel auxiliary_bus + ACPI matching; trigger
is a device with that HID being enumerated.

**Step 5.3 — Callees**
Record: N/A — data-only change.

**Step 5.4 — Reachability**
Record: The match path runs at boot/device enumeration on any Intel Nova
Lake system that exposes the USBIO ACPI device. Straightforward
reachability, no syscall/fuzzing considerations.

**Step 5.5 — Similar patterns**
Record: Identical pattern previously applied for MTL-CVF
(`72f437e674e5`, merged for v6.18-rc2). Pattern is standard for Intel
platform enablement.

## PHASE 6: CROSS-REFERENCING / STABLE TREE ANALYSIS

**Step 6.1 — Driver presence in stable**
Record: Driver exists in v6.18.y (introduced v6.18-rc1). No earlier
stable tree (6.12.y, 6.6.y, 6.1.y, etc.) contains
`drivers/i2c/busses/i2c-usbio.c`, so backport is only relevant to
v6.18.y and newer stable branches.

**Step 6.2 — Backport complications**
Record: The relevant hunk context in v6.18.y differs by one line (the
MTL-CVF `INTC10D2` entry, added in v6.18-rc2, is present in v6.18.y).
Applying this patch to v6.18.y should be clean: `git show
e43f2df330a1b:drivers/i2c/busses/i2c-usbio.c` shows the full post-patch
table matches v6.18-rc2+ content plus the single NVL line. Trivial
apply.

**Step 6.3 — Related fixes already in stable**
Record: `72f437e674e5` (MTL-CVF) is a sibling enablement commit; it
landed in v6.18-rc2. No conflicting or overlapping NVL change is present
in stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem criticality**
Record: `drivers/i2c/busses/` — I2C bus driver; specifically USBIO
auxbus child. PERIPHERAL criticality by itself, but this is in the path
needed by MIPI cameras on new Intel laptops, so the practical user
impact (camera non-functional without it) is meaningful.

**Step 7.2 — Subsystem activity**
Record: i2c-usbio.c is a very young file (first commit Sep 2025). Only 3
commits total. Highly stable code that is only extended with new HIDs.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Affected users**
Record: Users of Intel Nova Lake platforms (upcoming consumer/mobile
CPUs) that carry the USBIO IO-expander and use it as an I2C bus
(primarily for MIPI cameras / webcams).

**Step 8.2 — Trigger conditions**
Record: Boot of an NVL laptop with USBIO. Deterministic and common on
affected hardware. Cannot be triggered on non-NVL hardware.

**Step 8.3 — Failure mode without the fix**
Record: On NVL hardware, the I2C portion of USBIO does not bind;
consequences are functional (e.g., built-in camera and other
I2C-attached sensors fail to work) rather than crash/corruption.
Severity = FUNCTIONAL/LOW for the kernel itself, but user-visible
feature regression on new hardware. Matches the standard "device ID
addition" exception category.

**Step 8.4 — Benefit/risk**
Record: Benefit = enables hardware for every NVL laptop user on v6.18.y
(and later stable trees). Risk = effectively zero — 1-line addition to a
read-only match table that cannot affect any existing supported
platform. Ratio strongly favors inclusion.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence**
FOR: one-line addition, identical pattern to the already-merged MTL-CVF
HID commit, reviewed by appropriate maintainers, applies cleanly to
v6.18.y, enables working hardware for end users, zero regression risk.
AGAINST: no explicit stable tag, NVL is upcoming hardware (but this is
exactly the common "enable new SoC on an existing driver" case stable
trees routinely accept).
Unresolved: whether `Documentation/process/stable-kernel-rules.rst`
considers pre-release Intel SoC enablement as out-of-scope —
historically analogous additions (e.g., Raptor Lake IDs to i915) are
accepted.

**Step 9.2 — Rules checklist**
1. Obviously correct & tested? Yes — trivial, reviewed by two Intel
   engineers and committed by the i2c maintainer.
2. Fixes a real bug that affects users? Yes in the practical sense —
   hardware is non-functional without it on NVL systems.
3. Important issue? Low-severity, but standard hardware-enablement
   exception applies.
4. Small and contained? Yes — 1 line.
5. No new features/APIs? Correct — no new API, just a new matching
   entry.
6. Applies to stable trees? Yes — trivial apply to v6.18.y.

**Step 9.3 — Exception category**
Record: Matches exception #1 (NEW DEVICE IDs) exactly: ACPI HID added to
an existing driver already present in stable (v6.18.y).

**Step 9.4 — Decision**
The commit is a textbook "add device ID to existing driver" change. The
driver already lives in v6.18.y stable and an identical companion HID
was added one release earlier. There is essentially no risk and a clear
benefit for NVL hardware users on stable kernels.

## Verification
- [Phase 1] Parsed tags from commit message: Signed-off-by Arun T + Andi
  Shyti, Reviewed-by Vadillo + Sakari Ailus, Link to lore; no Fixes:/Cc:
  stable/syzbot.
- [Phase 2] Diff analysis: `git show e43f2df330a1b --stat` confirmed
  exactly 1 file / 1 line changed; only the `usbio_i2c_acpi_hids[]`
  table extended.
- [Phase 3] `git log --follow -- drivers/i2c/busses/i2c-usbio.c` shows
  only 3 commits; `git describe --contains daf161343a390` =
  `v6.18-rc1~76^2~32` confirms driver first shipped in v6.18.
- [Phase 3] `git describe --contains 72f437e674e54` = `v6.18-rc2~23^2~1`
  confirms sibling MTL-CVF addition is in v6.18.
- [Phase 4] `b4 dig -c e43f2df330a1b` located thread at
  `lore.kernel.org/all/20260410141038.585760-2-arun.t@intel.com/`.
- [Phase 4] `b4 dig -a` lists only v1 and v2 revisions; applied commit
  matches v2.
- [Phase 4] `b4 dig -w` confirmed the i2c maintainer Andi Shyti and
  linux-i2c list were addressed; proper recipients.
- [Phase 4] Saved thread in `/tmp/nvl_thread.mbox`; only reply is Andi
  Shyti noting the patch was already merged; no NAKs or stable-related
  discussion.
- [Phase 6] `git show e43f2df330a1b:drivers/i2c/busses/i2c-usbio.c`
  compared vs current HEAD file confirms only the NVL line differs, so
  backport context is clean.
- [Phase 8] Failure mode verified by reading the file and observing that
  `usbio_i2c_acpi_hids[]` is the sole binding gate for the I2C auxbus
  child — without a match, the driver simply won't bind.
- UNVERIFIED: Precise set of stable branches currently open that contain
  i2c-usbio — confirmed only that v6.18 is the introduction release; did
  not independently enumerate every active stable branch, but the logic
  is unambiguous (any stable branch ≥ v6.18.y is a candidate; earlier
  trees do not have the driver and are not affected).

**YES**

 drivers/i2c/busses/i2c-usbio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-usbio.c b/drivers/i2c/busses/i2c-usbio.c
index e7799abf67877..259754e5fd05b 100644
--- a/drivers/i2c/busses/i2c-usbio.c
+++ b/drivers/i2c/busses/i2c-usbio.c
@@ -29,6 +29,7 @@ static const struct acpi_device_id usbio_i2c_acpi_hids[] = {
 	{ "INTC10B6" }, /* LNL */
 	{ "INTC10D2" }, /* MTL-CVF */
 	{ "INTC10E3" }, /* PTL */
+	{ "INTC1118" }, /* NVL */
 	{ }
 };
 
-- 
2.53.0

