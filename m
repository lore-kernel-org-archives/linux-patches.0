Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2675D3C4D;
	Mon, 19 Oct 2026 14:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418501; cv=none; b=cxFIYVEuDeNyYaXxXI6+l9iDlfen3NJgainygQFBPn+7w3hBCpRlA6FJUKAvRoN8dfpxopbFCuqeIIohBNk0n10DLrhnff3l/jG64FFqHxy+Oj6abLg7K8SBt5WVccTaqa3O90/KwULAOCAMSIURZ2CbLkOv9NDtPT3Qi6D/tSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418501; c=relaxed/simple;
	bh=PDp5LZvazXyrNB/2aonb8uKGUSGUhcRxBgOuvMtx82k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQpnbSj2dm+6UvX5a3CzN5vvHbqi1IkhwUiCT91EAH5cp9YXIPZYAMCCx9OZraiLL2G4Xq7SlhUQpScc33J5yvL0kf/uNuTgIH6aeMyKBzP8Ln+2pqB3F7LstJ7Rmu9INgEMZh1szxy7BBHiMMrQeYQZEO0D9Z4LGVTJY39I1Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KnFOqkf4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KnFOqkf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F19F1F000C4;
	Mon, 19 Oct 2026 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418498;
	bh=cTneUewtWVKH46JGXVd6T4WZqiHe8a2SZhide+W0/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnFOqkf46yHJzpOCGy0Oj5WgjLCbWHnll4uXk9qMu/KdTqnt9gZD6AngmeHGXAKEF
	 hK6jtSpHRO9Mlw1jeilSnrr8Brt2OOqKk9CZAvC/cIpUeORhlBDgSwZgjIEGLuoJbw
	 ULAfPJVLub0QFrhA7Zlulj28EgTjJE6ziPHLK63aHLSnW24ojLmr6z8qhlYvvwRYJq
	 OK0S1nH9R9GBbfcrm6WOXyvJMuh5ZK1lCqprecJRGD1CsYbCQp2rOmiQZjmFBVjnp6
	 fPkQXs4kZ7i4k7ov/GRAV7gdiOF1Dzo4pzbkBPLhU92RYrLUr7j+4mBVbhsz3taYFL
	 Mpw2TfCgLo3fQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Griffin Kroah-Hartman <griffin@kroah.com>,
	David Heidelberg <david@ixit.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	oe-linux-nfc@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] nfc: mrvl: spi: Unregister dev on allocation fail
Date: Mon, 19 Oct 2026 09:49:42 -0400
Message-ID: <20261019135441.1420968-291-sashal@kernel.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

[ Upstream commit d832b95697384a2b67f20b35106bbf925358cde9 ]

Call nfcmrvl_nci_unregister_dev() if nci_spi_allocate_spi() fails,
unwrapping the previous call to nfcmrvl_nci_register_dev() during the
nfcmrvl_spi_probe() function.

Assisted-by: gkh-clanker-2000
Cc: David Heidelberg <david@ixit.cz>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026070716-crucial-slouchy-b8a9@gregkh
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a four-line probe error-path fix for a real NULL-deref in the
Marvell NFC-over-SPI driver. The buggy code is in this 6.12 tree and has
been there since v4.4.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [nfc: mrvl: spi:] [Unregister] [On `nci_spi_allocate_spi()`
failure, unregister the NCI device previously registered in probe]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record: Tags from `d832b95697384` (`git show --format=fuller`):
- Assisted-by: gkh-clanker-2000 (AI-assisted)
- Cc: David Heidelberg <david@ixit.cz>
- Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com> (author)
- Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
- Link: https://patch.msgid.link/2026070716-crucial-slouchy-b8a9@gregkh
- Signed-off-by: David Heidelberg <david@ixit.cz> (applied)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence expected)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `nfcmrvl_spi_probe()` calls `nfcmrvl_nci_register_dev()`, then
  `nci_spi_allocate_spi()`, and ignores a NULL return.
- Symptom: probe still returns 0, so the SPI driver binds with
  `drv_data->nci_spi == NULL`. The NCI device stays registered.
  IRQ/`nci_send` then dereference NULL.
- Version info: none in the message. Introducer is `caf6e49bf6d02e`
  ("NFC: nfcmrvl: add spi driver"), first in v4.4-rc1.
- Root cause: missing failure check after `nci_spi_allocate_spi()`. The
  unregister is required because returning `-ENOMEM` skips
  `nfcmrvl_spi_remove()`.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. It is an explicit error-path fix: missing
allocation check plus missing rollback of `nfcmrvl_nci_register_dev()`.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/nfc/nfcmrvl/spi.c` (+4 / -0)
- Function: `nfcmrvl_spi_probe()`
- Scope: single-file surgical error-path fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record: Current local probe (lines 160–174 of
`drivers/nfc/nfcmrvl/spi.c`):

```160:174:drivers/nfc/nfcmrvl/spi.c
        drv_data->priv = nfcmrvl_nci_register_dev(NFCMRVL_PHY_SPI,
                                                  drv_data, &spi_ops,
                                                  &drv_data->spi->dev,
                                                  pdata);
        if (IS_ERR(drv_data->priv))
                return PTR_ERR(drv_data->priv);

        drv_data->priv->support_fw_dnld = true;

        drv_data->nci_spi = nci_spi_allocate_spi(drv_data->spi, 0, 10,
                                                 drv_data->priv->ndev);

        /* Init completion for slave handshake */
        init_completion(&drv_data->handshake_completion);
        return 0;
```

Before: NULL from `nci_spi_allocate_spi()` is ignored; probe returns 0.
After: if NULL, call `nfcmrvl_nci_unregister_dev(drv_data->priv)` and
return `-ENOMEM`.
Path: probe error path only, after a successful
`nfcmrvl_nci_register_dev()`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: (a) error-path resource leak + (d) memory safety (NULL
  deref)
- Mechanism: `nci_spi_allocate_spi()` (`net/nfc/nci/spi.c:124-143`) is
  `devm_kzalloc()` and returns NULL on failure. The only caller is this
  probe. IRQ thread `nfcmrvl_spi_int_irq_thread_fn` does
  `nci_spi_read(drv_data->nci_spi)` with no NULL check;
  `__nci_spi_read()` then uses `nspi->acknowledge_mode`.
  `nfcmrvl_spi_nci_send()` / `nfcmrvl_spi_nci_update_config()` likewise
  dereference `nci_spi`. Returning `-ENOMEM` without unregister would
  leak the NCI device, GPIO, fw_dnld state, and `kzalloc`'d
  `nfcmrvl_private` (not devm-managed).

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct and minimal. Same
`nfcmrvl_nci_unregister_dev()` already used in `nfcmrvl_spi_remove()`.
IRQ is `devm_request_threaded_irq`, so it is released on probe failure.
Regression risk is low. Residual window: IRQ can still fire between
unregister and devm unwind (same pattern as remove). That is better than
binding with a permanent NULL `nci_spi`.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: `git blame` on `drivers/nfc/nfcmrvl/spi.c` lines 160–174: all
from `caf6e49bf6d02e` (Vincent Cuissard, 2015-10-26), "NFC: nfcmrvl: add
spi driver". First tagged in v4.4-rc1. Present and unchanged in this
tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Introducer identified by blame: `caf6e49bf6d02e`.
`git merge-base --is-ancestor caf6e49bf6d02e HEAD` → in this tree. `git
merge-base --is-ancestor d832b95697384 HEAD` → not in this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent local history of `spi.c` is style/DT/SPI-remove-void only
(`e3c95d56190c9`, `5a478a653b4cc`, `a0386bba70934`). No prior attempt to
check `nci_spi_allocate_spi()`. Standalone; not patch X/Y. Follow-ups on
origin/master after this commit are only ID-table style (`777fd2dab4460`
etc.), not corrections of this fix.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Griffin Kroah-Hartman is not the NFC maintainer. Same-day
sibling: `56345cea6a30d` "nfc: nxp-nci: Add remove on IRQ error" (same
AI assist, same applier). This 6.12 MAINTAINERS NFC entry is Krzysztof
Kozlowski. The commit landed via `Merge tag 'nfc-net-next-20260817'`
from codeberg.org/linux-nfc (David Heidelberg SOB).

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Uses only `nfcmrvl_nci_unregister_dev()` and
`nci_spi_allocate_spi()`, both present here. `git apply --check` of
`d832b95697384` on this tree succeeded. Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record: `b4 dig -c d832b95697384` →
https://patch.msgid.link/2026070716-crucial-slouchy-b8a9@gregkh
- `b4 dig -a`: v1 only, 2026-07-07, from Greg Kroah-Hartman
- Saved mbox: only the original patch email; no replies, NAKs, or
  reviewer-requested Cc: stable
- Applied as submitted

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: `b4 dig -w` recipients: Greg Kroah-Hartman, oe-linux-
nfc@lists.linux.dev, linux-kernel@vger.kernel.org, Griffin Kroah-
Hartman, David Heidelberg. No Reviewed-by. David Heidelberg's SOB is the
maintainer apply. Krzysztof Kozlowski was not on this patch's To/Cc (he
was on the sibling nxp-nci patch).

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by, bugzilla, or syzbot. No user-filed report found.
Bug is from code inspection.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Same-day Griffin/Greg NFC error-path patch `56345cea6a30d` for
nxp-nci. Not a functional dependency. `nci_spi_allocate_spi()` has no
other callers.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED. lore.kernel.org/stable is behind Anubis (bot
challenge). No stable discussion in the b4 mbox.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `nfcmrvl_spi_probe()` only. Calls added:
`nfcmrvl_nci_unregister_dev()`.

Step 5.2: TRACE CALLERS
Record:
- `nfcmrvl_spi_probe` ← `spi_driver.probe` (`nfcmrvl_spi_driver`),
  device enumeration for `marvell,nfc-spi` / `nfcmrvl_spi`
- `nfcmrvl_nci_unregister_dev` already called from `nfcmrvl_spi_remove`,
  and from uart/i2c/usb counterparts
- IRQ `nfcmrvl_spi_int_irq_thread_fn` is the crash path if `nci_spi` is
  NULL after a “successful” probe

Step 5.3: TRACE CALLEES
Record: `nfcmrvl_nci_unregister_dev()` (`main.c:182-197`) calls
`nci_unregister_device`, optional `nfcmrvl_fw_dnld_abort`,
`nfcmrvl_fw_dnld_deinit`, GPIO free, `nci_free_device`, `kfree(priv)`.
Appropriate after a successful register.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Probe of DT/SPI Marvell NFC (8897-class). Not a syscall. After a
buggy successful probe, NFC netlink/userspace I/O and the falling-edge
IRQ are live. Unprivileged trigger of the OOM itself: no. Crash after
bind: yes, if the chip asserts SPI_INT or userspace talks to the NFC
device.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: i2c/usb/uart register last in probe, so they do not have this
post-register allocation. This SPI path is unique. Same class of NFC
error-path leaks already in this tree: `8a4d480702b71`, `e204ead35401a`,
`bb55dc2ae4367`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Tree is 6.12.111 (`p-6.12-3-gc504cf0baa3d8`). Buggy
sequence is in `drivers/nfc/nfcmrvl/spi.c:169-174`. Introduced v4.4-rc1.
Fix `d832b95697384` is not an ancestor of HEAD (landed in v7.3-rc1).

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. `git apply --check` succeeded. Later mainline ID-
table style commits do not touch this hunk.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No equivalent check. `git log --grep` on this path found no
prior “nci_spi_allocate_spi fails” fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drivers/nfc/nfcmrvl] [PERIPHERAL] — Marvell NFC-over-SPI
(`CONFIG_NFC_MRVL_SPI`), DT compatible `marvell,nfc-spi`. Not core
mm/net, but a shipped production driver.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature/low-churn. Driver added 2015; 6.12 changes are mostly
style and small fixes. Bug is long-standing, not a new-code race.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / config-specific: `CONFIG_NFC_MRVL_SPI` users
with Marvell NFC SPI hardware (embedded/ARM boards using `marvell,nfc-
spi`).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: `devm_kzalloc(sizeof(struct nci_spi))` failure during probe
(GFP_KERNEL). Rare except under memory pressure. Not unprivileged-OOM-
as-exploit in the usual sense; once bound, IRQ or NFC I/O oopses.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure: kernel oops (NULL `nci_spi` in
  IRQ/`nci_spi_send`/`nci_spi_read`)
- Secondary: if probe were failed without unregister, leaked registered
  NCI device + GPIO + `priv`
- Severity: HIGH on trigger (oops); trigger likelihood LOW

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: medium for affected hardware (prevents oops and a leftover
  NFC device); population is small
- Risk: very low (4 lines, established unregister helper, error path
  only)
- Ratio: favorable — cheap, obviously correct crash/leak fix

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real bug in this tree: ignored NULL from `nci_spi_allocate_spi()`,
  probe returns 0
- Verified crash path: IRQ and send dereference `nci_spi` with no NULL
  check
- Unregister is required once probe fails, matching `remove()`
- 4 lines, applies cleanly, no new API, no prerequisites
- Bug present since v4.4
- Same unregister helper already in this tree (`d270453a0d9ec`
  reordering already applied)

AGAINST:
- Niche SPI NFC driver
- Trigger is a small GFP_KERNEL alloc failure
- No Reported-by / syzbot / Tested-by
- AI-assisted; mailing list thread has no review replies
- Not a hot path for most 6.12 users

UNRESOLVED:
- No stable-list discussion (lore Anubis)
- No public user report of this oops

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — logic matches `remove()`;
   applied upstream by the NFC tree. No extra runtime test evidence.
2. Fixes a real bug that affects users? PASS — missing alloc check
   leaves a bound driver with NULL `nci_spi`.
3. Important issue? PASS — kernel oops on IRQ/send after a failed alloc;
   also a registered-device leak if probe is failed without rollback.
   Severity HIGH on trigger, rare.
4. Small and contained? PASS — +4 lines, one function.
5. No new features or APIs? PASS
6. Can apply to the local tree? PASS — `git apply --check` clean; buggy
   code present

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not an ID/quirk/DT/build/docs exception). Qualifies as a
normal small bugfix.

Step 9.4: MAKE YOUR DECISION
This is a small, obviously correct error-path fix for a NULL dereference
that exists in 6.12. Rarity of the alloc failure does not make the oops
fictional, and the rollback is the same path `remove()` already uses.
Benefit outweighs risk.

What it solves for stable users: if `nci_spi_allocate_spi()` fails
during Marvell NFC SPI probe, 6.12 currently treats probe as success.
The IRQ thread and NCI send path then oops on NULL. The patch fails
probe with `-ENOMEM` and unregisters the NCI device so
`priv`/GPIO/`nci_dev` are not left behind.

Risk vs benefit: four lines on an error path; apply is clean; no locking
or API change. Niche hardware, but the failure mode is a crash, which
stable is meant to take.

Verification:
- [Phase 1] `git show d832b95697384 --format=fuller`: tags listed above;
  no Fixes/Reported-by/Cc stable
- [Phase 1] `make kernelversion` / Makefile: 6.12.111; `git describe
  HEAD`: p-6.12-3-gc504cf0baa3d8
- [Phase 2] Read `drivers/nfc/nfcmrvl/spi.c` probe/IRQ/send; confirmed
  no NULL check on `nci_spi`
- [Phase 2] Read `net/nfc/nci/spi.c` `nci_spi_allocate_spi`: only
  failure is `devm_kzalloc` → NULL
- [Phase 2] Read `nci_spi_read`/`__nci_spi_read`: dereference
  `nspi->acknowledge_mode` with no NULL guard
- [Phase 2] Read `nfcmrvl_nci_register_dev`/`unregister_dev`: priv is
  `kzalloc`, not devm; unregister is the correct rollback
- [Phase 3] `git blame -L 140,200 drivers/nfc/nfcmrvl/spi.c`: introducer
  `caf6e49bf6d02e` (2015)
- [Phase 3] `git describe --contains caf6e49bf6d02e`: v4.4-rc1
- [Phase 3] `git merge-base --is-ancestor caf6e49bf6d02e HEAD`: yes;
  `d832b95697384 HEAD`: no
- [Phase 3] `git describe --contains --match 'v*' d832b95697384`:
  v7.3-rc1~133^2~2^2~15
- [Phase 3] `git log origin/master --oneline --grep="Unregister dev on
  allocation fail" -- drivers/nfc/nfcmrvl/spi.c`: found `d832b95697384`
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1-only thread, no replies in mbox
- [Phase 4] lore.kernel.org/stable via curl: Anubis challenge,
  UNVERIFIED
- [Phase 5] `git grep nci_spi_allocate_spi`: sole caller is this probe
- [Phase 6] `git show d832b95697384 -- drivers/nfc/nfcmrvl/spi.c | git
  apply --check`: clean
- [Phase 6] `git diff HEAD origin/master -- drivers/nfc/nfcmrvl/spi.c`:
  only this hunk plus later ID-table style
- [Phase 8] Failure mode: NULL deref → oops after probe “succeeds”;
  severity HIGH, trigger LOW
- UNVERIFIED: whether this SHA was discussed on stable@; no user-visible
  oops report found

**YES**

 drivers/nfc/nfcmrvl/spi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index 9c8cde1250fb5..dad07c8e13b84 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -168,6 +168,10 @@ static int nfcmrvl_spi_probe(struct spi_device *spi)
 
 	drv_data->nci_spi = nci_spi_allocate_spi(drv_data->spi, 0, 10,
 						 drv_data->priv->ndev);
+	if (!drv_data->nci_spi) {
+		nfcmrvl_nci_unregister_dev(drv_data->priv);
+		return -ENOMEM;
+	}
 
 	/* Init completion for slave handshake */
 	init_completion(&drv_data->handshake_completion);
-- 
2.53.0

