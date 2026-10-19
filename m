Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67845B9219;
	Mon, 19 Oct 2026 14:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418467; cv=none; b=kkln8Ke5wXk8faeaWvNs/QntAmXSOdXJQN3AcqpTodJz/ZPuuh/qF1Mfe0QvRdViP8tSv5nIjva+Sc+3heXR5mkgxDe4jUMpqXk954R2oVCi7X4Lmcc6P4E7XPFNTvmzDTgICHJiftZRdl1TLTOCD46A1yiT2g68WDaBny4rCUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418467; c=relaxed/simple;
	bh=3O+2p/byA5q5+JM2GdHGKj30mIYDY/saB/4wzZrmHp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C47aPB8Dp5TDVo0zbQppmIKXsNgvlzDBLi2Vna0T3sVMoVwWbEn/FaFCecyMT8+bSCJPG+CeJtDfwpOjJ1rPw3n27+Gxt5kU48IXI6uAH5dd9TPe59tXTIIEurWhWxBeXW/H1ovi5VuCFN7ImcnraEPUmH0tN/TU4mrM7YKpY38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXr9DrRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXr9DrRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743E61F000C6;
	Mon, 19 Oct 2026 14:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418464;
	bh=U0IYCG9nCxFnocbQjEcAd92W3Xn3u7y92lU7IboXoQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXr9DrRuRHgwZxeXh9IjolW+j5slb5di00jah7JDYfDAYGLb6PWNMizDgb8KdJTr5
	 R1QGCxmeHtev/v7r7qQY+edbDFz57cdmPFeFnrHkSpnz4iTJneTIlmAlPqxM/0iUfU
	 W9apSVBifEjCWA9/4nFmVC0BWDb5Jn2XcCeNqy5Aazr7f7ny69Dd+2GwOzoVxBMYCh
	 f2BAJTJz5vRQPRZm3YNxLHPjkp0HO2iVLN+2alVDE4EkWxO8MkVQ9j2HsT0iat3QN6
	 5FHCE2FfANIFdX6kTn5209u/TBaLdCI+2Q/tElS9KS+4mR4Ah6ECxRFpUwLDBsOsY9
	 9DThsjzS9r5xg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Griffin Kroah-Hartman <griffin@kroah.com>,
	David Heidelberg <david@ixit.cz>,
	Carl Lee <carl.lee@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Ian Ray <ian.ray@gehealthcare.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	oe-linux-nfc@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] nfc: nxp-nci: Add remove on IRQ error
Date: Mon, 19 Oct 2026 09:49:18 -0400
Message-ID: <20261019135441.1420968-267-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Griffin Kroah-Hartman <griffin@kroah.com>

[ Upstream commit 56345cea6a30dc7a1b036d5fb7900434b4a4c5e8 ]

Add a call to nxp_nci_remove() in nxp_nci_i2c_probe() when the
request_threaded_irq() fails.
Previously, IRQ resources were not being freed upon error.

Assisted-by: gkh_clanker_2000
Cc: David Heidelberg <david@ixit.cz>
Cc: Carl Lee <carl.lee@amd.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: Ian Ray <ian.ray@gehealthcare.com>
Cc: "Uwe Kleine-König (The Capable Hub)" <u.kleine-koenig@baylibre.com>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Ian Ray <ian.ray@gehealthcare.com>
Link: https://patch.msgid.link/2026070726-observer-fang-9716@gregkh
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the probe error path is in this 6.12 tree, the
leftover NCI device is a real leak, and the three-line cleanup applies
here.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[nfc / nxp-nci]` `[Add]` `call nxp_nci_remove() when IRQ
  registration fails in I2C probe`

**Step 1.2: Tags**
- Record:
  - `Assisted-by: gkh_clanker_2000` (AI-assisted)
  - `Cc: David Heidelberg`, `Carl Lee`, `Jakub Kicinski`, `Krzysztof
    Kozlowski`, `Ian Ray`, `Uwe Kleine-König`
  - `Signed-off-by: Griffin Kroah-Hartman` (author)
  - `Signed-off-by: Greg Kroah-Hartman`
  - `Reviewed-by: Ian Ray <ian.ray@gehealthcare.com>`
  - `Link: https://patch.msgid.link/2026070726-observer-
    fang-9716@gregkh`
  - `Signed-off-by: David Heidelberg` (NFC maintainer)
  - No `Fixes:`, no `Reported-by:`, no `Cc: stable` (absence expected)
  - Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
    ...]` markers

**Step 1.3: Body**
- Record: Claimed bug is that `request_threaded_irq()` failure in
  `nxp_nci_i2c_probe()` does not clean up. Symptom described as “IRQ
  resources were not being freed.” Root cause stated as missing
  `nxp_nci_remove()` after a failed IRQ request. No stack trace, no
  reproducer, no version range.
- The “IRQ resources” wording is inaccurate: a failed
  `request_threaded_irq()` never acquired an IRQ, so there is nothing to
  `free_irq()`. The real leak is the NCI/NFC device created by the
  earlier `nxp_nci_probe()` success.

**Step 1.4: Hidden bug fix?**
- Record: Yes. This is error-path cleanup framed as “Add remove”. It is
  a real leak/UAF fix, not a feature. The AI-written message understates
  (and mislabels) the actual leftover object.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: `drivers/nfc/nxp-nci/i2c.c` only. ~3 lines added, 1 line
  changed. Function: `nxp_nci_i2c_probe()`. Surgical single-file error-
  path change.

**Step 2.2: Code flow**
- Record: Before: `nxp_nci_probe()` registers an NCI/NFC device, then
  `request_threaded_irq()`; on failure the driver logs and returns the
  error. I2C core does **not** call `.remove()`. After: same log, plus
  `nxp_nci_remove(phy->ndev)` before returning. Only the IRQ-request
  failure path changes.

**Step 2.3: Bug mechanism**
- Record: `[Error path / resource leak]` with a follow-on UAF.
  `nxp_nci_probe()` does `nci_allocate_device()` +
  `nci_register_device()` (`nfc_register_device()`, three workqueues,
  rfkill, LLCP, genl “device added”). Those objects are not
  `devm`-backed. `phy` and `info` **are** `devm_kzalloc`. On probe
  failure, `really_probe()` → `device_unbind_cleanup()` →
  `devres_release_all()` frees `info`/`phy` while the registered
  `nci_dev` still holds `driver_data` pointing at `info`. Opening that
  leftover NFC device reaches `nxp_nci_open()` → `nci_get_drvdata()` on
  freed memory.

**Step 2.4: Fix quality**
- Record: Obviously correct and matches `s3fwrn5_i2c_probe()` in this
  tree (`goto s3fwrn5_remove` → `s3fwrn5_remove()`). Does not
  `free_irq()` (correct: IRQ was never taken). Uses the same
  `nxp_nci_remove()` as `.remove`. On this path `NCI_UP` is unset, so
  `nci_close_device()` does not call `nxp_nci_close()`; no new deadlock.
  Regression risk is very low.

## Phase 3: Git history

**Step 3.1: Blame**
- Record: Missing cleanup is original I2C probe code from
  `6be88670fc59d5` (“NFC: nxp-nci_i2c: Add I2C support to NXP NCI
  driver”, Clément Perrochaud, 2015-03-09). `git describe --contains` →
  `v4.1-rc1~...`. Present for the entire life of this 6.12 tree.

**Step 3.2: Fixes: tag**
- Record: None. Buggy commit is `6be88670fc59d5`, and `git merge-base
  --is-ancestor 6be88670fc59d5 HEAD` succeeds.

**Step 3.3: File history**
- Record: Recent local history is IRQ-trigger work (`78ac2b2f981f6`,
  `42c445f8dab95`), GPIO sleep, unaligned.h move. No prior fix for this
  IRQ-fail cleanup. Not a multi-patch series that needs later nxp-nci
  commits.

**Step 3.4: Author**
- Record: Griffin Kroah-Hartman; no other nxp-nci commits in this tree.
  Greg KH SOB. Ian Ray Reviewed-by. David Heidelberg (NFC) took it.
  Driver is `S: Orphan` in MAINTAINERS.

**Step 3.5: Prerequisites**
- Record: Needs `nxp_nci_probe()` / `nxp_nci_remove()` / `phy->ndev`,
  all present in `drivers/nfc/nxp-nci/core.c` here. Standalone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: Lore `patch.msgid.link` and `lore.kernel.org` fetches returned
  403. Recovered from Openwall/LKML:
  - https://lists.openwall.net/linux-kernel/2026/07/07/1891
  - https://lkml.iu.edu/hypermail/linux/kernel/2607.0/13842.html
  - Single `[PATCH]` (not v2/v3). Posted 2026-07-07 to `oe-linux-nfc` /
    LKML.
  - Ian Ray: “Nice improvement!” + `Reviewed-by`
    (https://lkml.iu.edu/hypermail/linux/kernel/2607.0/14256.html). No
    NAK.

**Step 4.2: Recipients**
- Record: `oe-linux-nfc`, LKML, David Heidelberg, Carl Lee, Jakub
  Kicinski, Krzysztof Kozlowski, Ian Ray, Uwe Kleine-König. NFC list +
  net maintainer CC’d.

**Step 4.3: Bug report**
- Record: No user/syzbot/bugzilla report. Found as AI-assisted error-
  path audit.

**Step 4.4: Series / merge**
- Record: David Heidelberg’s NFC net-next PR 2026-08-17 lists it under
  **Improvements**, not Fixes: https://lists.openwall.net/linux-
  kernel/2026/08/17/1882 (based on 7.2-rc7). Sibling Griffin patch:
  `nfc: mrvl: spi: Unregister dev on allocation fail`. Taken for
  mainline, not as a `-net` hotfix.

**Step 4.5: Stable list**
- Record: No stable-thread hit for this subject. UNVERIFIED that nobody
  later nominated it; lore.kernel.org/stable search was not usable (403
  / unrelated hits).

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
- Record: `nxp_nci_i2c_probe()`; calls `nxp_nci_remove()`.

**Step 5.2: Callers**
- Record: I2C `.probe` via `module_i2c_driver(nxp_nci_i2c_driver)`.
  Device enumeration / bind / module load. Not IRQ/hot path except that
  this *is* the IRQ-setup failure arm.

**Step 5.3: Callees**
- Record: `nxp_nci_remove()` → `nci_unregister_device()` +
  `nci_free_device()`; optional FW work cancel; `set_mode(COLD)`.

**Step 5.4: Reachability**
- Record: Yes, from device probe (init/userspace bind). The leftover NFC
  device is userspace-visible: `nfc_register_device()` does
  `device_add()` and `nfc_genl_device_added()`. A daemon that opens it
  after a failed probe hits the UAF. Trigger is `request_threaded_irq()`
  failure (bad/busy IRQ, ENOMEM), not every boot.

**Step 5.5: Similar patterns**
- Record: `drivers/nfc/s3fwrn5/i2c.c` already unwinds with
  `s3fwrn5_remove()` on IRQ failure. `drivers/nfc/st-nci/i2c.c` has the
  same missing unwind (`devm_request_threaded_irq` fail just logs).
  `pn533/i2c.c` uses `goto irq_rqst_err`. This is a known probe-pattern
  bug, not unique to nxp-nci.

## Phase 6: This tree (6.12.111)

**Step 6.1: Buggy code present?**
- Record: Yes. `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → **6.12.111**. Current `nxp_nci_i2c_probe()` still
  returns on IRQ failure without `nxp_nci_remove()` (`drivers/nfc/nxp-
  nci/i2c.c` around the `request_threaded_irq()` call). Introduced v4.1,
  long before 6.12.

**Step 6.2: Backport difficulty**
- Record: Clean/trivial. The hunk matches this tree (including Carl Lee
  ACPI IRQ context already backported as `42c445f8dab95`). Candidate
  later tree uses `{ .name = "nxp-nci_i2c" }` vs `{ "nxp-nci_i2c" }`
  here; that is unused context, not the fix.

**Step 6.3: Related fixes already here?**
- Record: No `git log --grep` hit for “Add remove on IRQ” or
  `nxp_nci_remove` on the error path. No alternate unwind.

## Phase 7: Subsystem context

**Step 7.1**
- Record: `[drivers/nfc/nxp-nci]` NXP NCI I2C (PN547/PN548/PN7150).
  **IMPORTANT/PERIPHERAL**: not core mm/net, but this driver is on real
  laptops (Lenovo T14s IRQ-storm traffic in 2026). Kconfig:
  `NFC_NXP_NCI` / `NFC_NXP_NCI_I2C`.

**Step 7.2**
- Record: Mature (2015); recent churn is IRQ polarity/ACPI, not a
  rewrite. Orphan.

## Phase 8: Impact and risk

**Step 8.1: Who**
- Record: Users with NXP NCI over I2C (`CONFIG_NFC_NXP_NCI_I2C`), and
  only when IRQ request fails during probe.

**Step 8.2: Trigger**
- Record: Failed `request_threaded_irq()` after successful
  `nxp_nci_probe()`. Uncommon on healthy firmware, but deterministic
  when it happens. Unprivileged userspace can then talk to the genl-
  announced leftover NFC device.

**Step 8.3: Failure mode**
- Record: Leaked `nci_dev`/`nfc_dev`, three workqueues, rfkill, LLCP;
  registered NFC node after a failed bind; UAF of `devm` `info`/`phy` if
  the leftover device is opened. Severity: **HIGH** if hit (UAF/oops),
  **LOW–MEDIUM** likelihood.

**Step 8.4: Benefit vs risk**
- Record: Benefit medium for affected hardware (prevents leak + UAF on a
  failed probe). Risk very low (3 lines, existing teardown, only the
  already-failed path). Ratio is favorable.

## Phase 9: Synthesis

**Evidence FOR**
- Real probe error-path leak of a registered NFC/NCI device and
  associated workqueues.
- Verified UAF: `device_unbind_cleanup()` frees `devm` `info` while
  `nci_dev->driver_data` still points at it; `nfc_genl_device_added()`
  can pull userspace in.
- Bug present since v4.1; in this 6.12.111 tree unchanged.
- 3-line, obviously correct unwind; same pattern as `s3fwrn5` here.
- Reviewed-by Ian Ray; merged by David Heidelberg.
- Applies cleanly (or with trivial context).

**Evidence AGAINST**
- Maintainer filed it as a net-next **Improvement**, reviewer said “Nice
  improvement!” — not treated as a crash fix.
- Commit message is wrong about “IRQ resources”.
- AI-assisted, no user/syzbot report in 11 years.
- Trigger is rare; driver is orphan; NFC is not core.
- No `Fixes:` (expected, not a veto).

**Unresolved**
- Could not fetch lore.kernel.org (403). Used Openwall/LKML instead.
- No usable stable-list discussion found.

**Stable rules**
1. Obviously correct and tested? **PASS** — 3 lines, existing
   `nxp_nci_remove()`, Reviewed-by, in NFC pull.
2. Real bug affecting users? **PASS** — leftover registered NFC device +
   leak; UAF if opened.
3. Important (crash/security/corruption/deadlock)? **PASS** — UAF/oops
   on leftover device; not a hot-path crash, but still a serious failure
   mode.
4. Small and contained? **PASS** — one file, ~3 lines.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS**.

**Exception category:** none (not a device ID/quirk/DT/build/doc
exception). It is a normal error-path leak/UAF fix.

The inaccuracy of the commit message and the “improvement” label do not
change the code: without `nxp_nci_remove()`, a failed IRQ request leaves
an NFC device registered after `devm` teardown. That is exactly the
class of probe-path leak stable trees take, and the patch is safe on
6.12.111.

### What this solves for 6.12 users
If `nxp_nci_i2c_probe()` fails at `request_threaded_irq()`, 6.12
currently keeps the NCI/NFC device from `nxp_nci_probe()` and then frees
the `devm` private data. Userspace can still see that NFC device. The
patch unregisters and frees it, matching `.remove`.

### Risk vs benefit
Benefit is avoiding a leak and a reachable UAF on that failure path.
Risk is negligible: the new call is the same teardown already used on
unbind, and the device was never brought up (`NCI_UP` clear).

### Concerns
None that block a backport. Context around ACPI IRQ flags is already in
this tree. No extra commits required.

Verification:
- [Phase 1] Parsed tags: AI-assisted; Reviewed-by Ian Ray; David
  Heidelberg SOB; no Fixes/Reported-by/Cc:stable
- [Phase 1] Body claims “IRQ resources” leak; code actually cleans the
  NCI device, not an IRQ
- [Phase 2] Diff: 3 lines in `nxp_nci_i2c_probe()` adding
  `nxp_nci_remove(phy->ndev)` on IRQ failure
- [Phase 2] `nxp_nci_probe()` registers via `nci_register_device()` →
  `nfc_register_device()` (`device_add`, genl); `nci_allocate_device()`
  is `kzalloc`, not `devm`
- [Phase 2] `phy`/`info` are `devm_kzalloc`; `really_probe()` failure
  path calls `device_unbind_cleanup()` → `devres_release_all()`
  (verified in `drivers/base/dd.c`)
- [Phase 2] On this path `nci_close_device()` skips `ops->close` when
  `NCI_UP` is clear (verified in `net/nfc/nci/core.c`)
- [Phase 3] Blame: `6be88670fc59d5` (v4.1-rc1); ancestor of HEAD
- [Phase 3] No existing unwind for this path in this tree
- [Phase 4] Openwall 2026-07-07 submission; Ian Ray “Nice improvement!”;
  NFC PR 2026-08-17 lists it under Improvements
- [Phase 4] UNVERIFIED: lore.kernel.org 403; no stable-list thread found
- [Phase 5] Sibling `s3fwrn5` already calls remove on IRQ failure; `st-
  nci` still does not
- [Phase 6] Local tree 6.12.111; buggy `if (r < 0) nfc_err(...); return
  r;` still present; `nxp_nci_remove()` exists
- [Phase 7] Orphan nxp-nci I2C driver; used on real PCs (ACPI IRQ work
  already in this tree)
- [Phase 8] Failure: leak + leftover NFC device + UAF if opened; trigger
  uncommon; fix risk very low

**YES**

 drivers/nfc/nxp-nci/i2c.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index a6c08175d9dd9..213d3eea7dd04 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -326,8 +326,10 @@ static int nxp_nci_i2c_probe(struct i2c_client *client)
 				 nxp_nci_i2c_irq_thread_fn,
 				 irqflags | IRQF_ONESHOT,
 				 NXP_NCI_I2C_DRIVER_NAME, phy);
-	if (r < 0)
+	if (r < 0) {
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
+		nxp_nci_remove(phy->ndev);
+	}
 
 	return r;
 }
-- 
2.53.0

