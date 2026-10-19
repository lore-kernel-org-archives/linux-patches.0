Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E5E51DAE6;
	Mon, 19 Oct 2026 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418275; cv=none; b=K7GGNfWSLJsXrJ7FMgdC6r0t+M2U3BbyqTrjgrD1DcxAxwOCdXdW5HGasVLbqUC1I1O/pzLc2EAX1ny5mn+Bwg/426JC2vy0EPKrY8bkdeWUP+5tRhCmyv4RtoMexMY0lH5hlNPnkOI3nw+OREy01FZAipauyDt0seeBfJEgWw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418275; c=relaxed/simple;
	bh=/2QsdZrQw6MaWt8XpDNT/BUn8JYRSyPukblrlpCyfyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u0nJMcb47onwHl4guHSgne6/FrJQni+9AcVRhZb8VfgQkxL+rk0f3ylrev68FdLkE0/GpL/qqDnJ2446dcNIaoICELd3erIeRPsxufgRyHS2B6kE+oTHD3W2l0gN8JmHdJLMsBIoJOI6EVCKIcG5mBzngYM21m1AQU/4jap9H6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kL6LJNmo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kL6LJNmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECC31F000C4;
	Mon, 19 Oct 2026 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418274;
	bh=wip6XPwDneigQDF7SAoedelkf/KRqwI5pF0/L9cxoek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kL6LJNmoUo8wuH2Kkb6JcWxlPubpYVnNQBv/MTugyE4Q34HuQ0XzSTACQBWODIEnp
	 8o9F/qxqdtsGuYO+KyCL5jIpRtGV5gpNMl5lDBzl7PHLSU2YJstmTUCH11FLrl1REn
	 ngbhKTJEesnYCuUqWckdqJp4nKi8xFeaVO5zQouHBo3JDoghoQtue7cNiGWiH99nWT
	 fYPVYOxymDfQORfD/cvb+k8dunHfs96V3LkQ9BGDnPz3a4pyyFlnSQqGfrLJFDnBpM
	 J+TbLZuv4Z3M+sa9fj3s9QiOfkfarxWnBJJu5ZrTC7KmQnBZwZX2NDf1Na104tXmnn
	 +XRwuO7lg3ChA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hverkuil@kernel.org,
	mchehab@kernel.org,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	linux-tegra@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: cec: tegra_cec: don't break off msg on NACK
Date: Mon, 19 Oct 2026 09:47:02 -0400
Message-ID: <20261019135441.1420968-131-sashal@kernel.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit be627f257ce283c95fd2988080dc0db3a20d0d2a ]

The Tegra CEC hardware has a bug where, if the first attempt
to transmit a message is NACKed so the transmit is aborted,
then the second attempt can contain corrupt data.

Ensure that the full message is always transmitted to avoid hitting
this bug.

I suspect some internal state is not reset in the case of aborting
a message due to a NACK.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a hardware-quirk workaround in the Tegra HDMI CEC driver: after
a NACK abort, the next transmit can be corrupt. The local tree is
**v7.3-rc4** (`7.3.0-rc4`). The driver and
`TEGRA_CEC_HWCTRL_TX_NAK_MODE` bit have been here since the original
2017 driver, so the fix belongs in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [media: cec: tegra_cec] [don't break off] [keep transmitting a
CEC message after NACK so Tegra HW does not corrupt the retry]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Hans Verkuil \<hverkuil+cisco@kernel.org\> (author; CEC
  and Tegra CEC maintainer)
- Reviewed-by: Mikko Perttunen \<mperttunen@nvidia.com\> (NVIDIA)
- Signed-off-by: Mauro Carvalho Chehab \<mchehab+huawei@kernel.org\>
  (media maintainer)
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable (absence
  expected)
- Ignored: any Sasha Levin SOB / Upstream-commit markers (none present
  on the real commit)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: Tegra CEC silicon bug. If the first transmit is NACKed and
  aborted, the second attempt can contain corrupt data. Author suspects
  internal HW state is not reset on NACK abort.
- Symptom: corrupt HDMI-CEC frames on retry after NACK (wrong bytes on
  the CEC bus).
- Version info: none in the message. Driver dates to v4.15-rc1.
- Root cause (author): abort-on-NACK leaves HW in a bad state;
  workaround is to always send the full message (`TX_NAK_MODE`).

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. Cover letter calls it “a fix” / HW-bug
workaround. Not cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/media/cec/platform/tegra/tegra_cec.c` (+12 / -1)
- Function: `tegra_cec_adap_enable()`
- Scope: single-file surgical change; one functional OR of an existing
  HW bit plus a comment

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: enable path wrote `TEGRA_CEC_HW_CONTROL =
  TEGRA_CEC_HWCTRL_TX_RX_MODE` only. Hardware aborted TX on NACK.
- After: same write also sets `TEGRA_CEC_HWCTRL_TX_NAK_MODE` so the full
  frame is sent even if bytes are NACKed.
- Path: adapter enable (normal init), not an error path.
- `tegra_cec_adap_log_addr()` and `tegra_cec_adap_monitor_all_enable()`
  RMW `HW_CONTROL`, so they keep the bit. `tegra_cec_error_recovery()`
  saves/restores `hw_ctrl`, so it keeps the bit too.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Hardware workaround] Default abort-on-NACK leaves Tegra CEC TX
state unrestored; retry can emit corrupt data. Setting `TX_NAK_MODE`
avoids the abort path. IRQ still reports NACK via
`TX_FRAME_OR_BLOCK_NAKD` when `TX_FRAME_TRANSMITTED` fires.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: one existing register bit, documented in-tree since
  2017, unused until now.
- Minimal: one OR plus comment.
- Regression risk: low. Bus is occupied a bit longer after NACK (author
  notes this). NVIDIA reviewed. Software still reports
  `CEC_TX_STATUS_NACK`. POLL (the usual NACK) is one byte, so extra bus
  time is negligible.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Buggy write is from `9d2d60687c9a` (“media: tegra-cec: add Tegra
HDMI CEC driver”, 2017-07-15, contained in v4.15-rc1).
`TEGRA_CEC_HWCTRL_TX_NAK_MODE` was defined in that same commit (`(1 <<
24)`), later rewritten as `BIT(24)` in `cce8ccca80d838` (2019). Bug has
been in this driver for the entire mainline life of the driver.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. N/A. Introduced by original driver, not a later
regression.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Same-day series 1/2. 2/2 is `bce7236c16c2c` (“keep track of
number of Rx Low Drives”) — debug counter, not a prerequisite. Later
`a45a81a790b96` is an unrelated `dev_err` cleanup. Standalone.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Hans Verkuil is listed in MAINTAINERS for both CEC FRAMEWORK and
ARM/TEGRA HDMI CEC. NVIDIA’s Mikko Perttunen reviewed. High confidence.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Uses `TEGRA_CEC_HWCTRL_TX_NAK_MODE` already in
`tegra_cec.h` in this tree. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Lore: https://patch.msgid.link/7e50d6027e1676650d52905cd20eb212c01cd3e
  5.1783677198.git.hverkuil+cisco@kernel.org
- Cover: `[PATCH 0/2] media: tegra_cec: a fix and an enhancement` — “the
  first works around a HW bug where, if a transmit was NACKed, the
  retransmit would contain corrupt data.”
- Only v1; committed as submitted.
- No NAK, no stable nomination, no reviewer risk flags.
- Included in “[GIT PULL FOR v7.3] media: CEC fixes/improvements”.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To linux-media; Cc Thierry Reding and linux-tegra. Reviewed-by
Mikko Perttunen (NVIDIA). Right maintainers.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Author-discovered HW bug, confirmed by
NVIDIA review. No user-count in the thread.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 1/2 of 2. 2/2 is an enhancement (Rx low-drive debugfs), not
required. Do not pull 2/2 as a dependency.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No stable-list discussion found for this NACK workaround. linux-
media search for “tegra_cec stable” did not hit this patch.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `tegra_cec_adap_enable()`

Step 5.2: TRACE CALLERS
Record: Wired as `cec_adap_ops.adap_enable`. Called from
`cec_adap_enable()` in `drivers/media/cec/core/cec-adap.c`
(open/configure `/dev/cecX`, logical-address setup, enable/disable).
Userspace-reachable on Tegra HDMI.

Step 5.3: TRACE CALLEES
Record: `cec_write()` → `writel()` of `TEGRA_CEC_HW_CONTROL`. No alloc,
no new locks.

Step 5.4: FOLLOW THE CALL CHAIN
Record: userspace CEC ioctl/open → CEC core `cec_adap_enable()` →
`tegra_cec_adap_enable()`. Transmit path `tegra_cec_adap_transmit()`
fills TX FIFO; NACK is handled in `tegra_cec_irq_handler()`.
Unprivileged users with `/dev/cecX` can trigger TX, including
NACK+retry.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: `TX_NAK_MODE` is only used in this driver. No sibling-driver
copy of this workaround.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Tree is v7.3-rc4. File
`drivers/media/cec/platform/tegra/tegra_cec.c` and header bit
`TEGRA_CEC_HWCTRL_TX_NAK_MODE` are present. Pre-fix enable path wrote
only `TX_RX_MODE` (blame to 2017). Bug introduced in v4.15-era driver,
long before this branch.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Context in the candidate is the INT_MASK block
without later `RX_BUS_ERROR_DETECTED` (that line is from 2/2). Against
this tree the hunk is already the intended enable write. No data-
structure or API change.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No earlier alternate fix for NACK-abort corruption. This is the
first use of `TX_NAK_MODE` in C code.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drivers/media/cec/platform/tegra] [PERIPHERAL / platform
driver, but real Tegra HDMI product path]. CONFIG_CEC_TEGRA, depends on
ARCH_TEGRA.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature. Driver since 2017; low churn. This is an old HW bug, not
new-code churn.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Tegra HDMI-CEC users (Jetson and other Tegra boards with CEC).
Config- and platform-specific, not universal.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Transmit a message that is NACKed, then retry. Common for POLL
during logical-address allocation (1 byte; author says that case is
cheap). Multi-byte NACK+retry is less common but real (absent follower,
follower busy). Userspace with CEC device access can trigger it.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [Corrupt CEC frame on retry] [MEDIUM functionally, HIGH for that
hardware’s CEC reliability]. Not a kernel oops. Puts garbage on the CEC
bus, which can break TV/AVR control after a NACK. That is user-visible
protocol corruption.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for Tegra CEC — stops corrupt retries on a long-standing
  silicon bug.
- Risk: very low — one register bit, NVIDIA Reviewed-by, CEC maintainer
  authored it.
- Ratio: strongly favors applying the workaround.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real Tegra CEC hardware bug: NACK abort → corrupt retransmit
- Hardware quirk/workaround (stable exception)
- Tiny: +12/-1, one bit OR
- Bit defined since original 2017 driver; no new API
- Authored by CEC/Tegra-CEC maintainer; Reviewed-by NVIDIA
- Standalone; 2/2 of the series is unrelated debug
- Applies to this tree: driver and define exist
- IRQ path still reports NACK correctly

AGAINST:
- Not a kernel crash, UAF, or security bug
- Tegra-only
- Slightly longer bus occupancy after NACK (documented, accepted)
- No Fixes:/Cc: stable (not a negative here)
- No public multi-user bugzilla/syzbot report

UNRESOLVED:
- lore.kernel.org WebFetch returned 403; thread recovered via `b4 dig
  -m` and gnuweeb/ratatoskr mirrors
- No stable@ discussion found
- HW “internal state not reset” is the author’s suspicion; NVIDIA did
  not contradict it

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — one documented HW bit; NVIDIA
   Reviewed-by
2. Fixes a real bug that affects users? PASS — corrupt CEC retries after
   NACK
3. Important issue? PASS as hardware workaround / protocol corruption on
   HDMI-CEC, not as a kernel panic
4. Small and contained? PASS — 13-line hunk, one function
5. No new features or APIs? PASS — enables an existing unused control
   bit
6. Can apply to the local tree? PASS — file, function, and
   `TEGRA_CEC_HWCTRL_TX_NAK_MODE` are here

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware quirk/workaround. Qualifies even without a panic.

Step 9.4: MAKE YOUR DECISION
This is a small, reviewed workaround for a real Tegra CEC silicon bug
that corrupts the next transmit after a NACK abort. The driver and
register bit exist in this v7.3-rc4 tree and have since v4.15. Risk is a
single enable-time bit. That meets stable rules via the hardware-quirk
exception.

What it solves for users of this tree: Tegra HDMI-CEC retries after NACK
can put corrupt bytes on the bus; setting `TX_NAK_MODE` avoids the abort
path that triggers that bug.

Risk vs benefit: one-bit enable flag, NVIDIA-reviewed, vs broken CEC
after NACK. Benefit wins.

===============================================================
Verification:
- [Phase 1] Parsed be627f257ce283c95fd2988080dc0db3a20d0d2a: no
  Fixes/Reported-by/Cc:stable; SOB Hans Verkuil + Mauro; Reviewed-by
  Mikko Perttunen
- [Phase 1] Cover letter (mbox): “works around a HW bug” / corrupt
  retransmit after NACK
- [Phase 2] Diff: `tegra_cec_adap_enable()` OR
  `TEGRA_CEC_HWCTRL_TX_NAK_MODE` into HW_CONTROL (+12/-1)
- [Phase 2] Confirmed RMW of HW_CONTROL in `tegra_cec_adap_log_addr`,
  `tegra_cec_adap_monitor_all_enable`, `tegra_cec_error_recovery`
  preserves the bit
- [Phase 2] IRQ still sets `CEC_TX_STATUS_NACK` on
  `TX_FRAME_TRANSMITTED` + `TX_FRAME_OR_BLOCK_NAKD`
- [Phase 3] git blame parent: HW_CONTROL write from 9d2d60687c9a
  (v4.15-rc1); TX_NAK_MODE in original header
- [Phase 3] git merge-base --is-ancestor 9d2d60687c9a HEAD: yes
- [Phase 3] No Fixes: tag; follow-up bce7236c16c2c is debug-only, not a
  prereq
- [Phase 4] b4 dig -c: https://patch.msgid.link/7e50d6027e1676650d52905c
  d20eb212c01cd3e5.1783677198.git.hverkuil+cisco@kernel.org
- [Phase 4] b4 dig -a: v1 only
- [Phase 4] b4 dig -w: linux-media, linux-tegra, Thierry Reding
- [Phase 4] b4 dig -m: NVIDIA Reviewed-by; no NAK; no Cc:stable in
  thread
- [Phase 4] lore.kernel.org WebFetch: 403; used mbox + gnuweeb/ratatoskr
  instead
- [Phase 5] Callers: cec-adap.c `cec_adap_enable()` → ops->adap_enable;
  userspace `/dev/cecX`
- [Phase 5] grep TX_NAK_MODE: only tegra_cec.c/.h
- [Phase 6] git describe HEAD: v7.3-rc4-27-gf0100363d8c37; make
  kernelversion 7.3.0-rc4
- [Phase 6] Header bit present; enable function present; clean single-
  hunk change
- [Phase 7] MAINTAINERS: Hans Verkuil maintains ARM/TEGRA HDMI CEC and
  CEC FRAMEWORK
- [Phase 8] Failure mode: corrupt CEC retry after NACK, not oops;
  severity MEDIUM/HIGH for that hardware
- UNVERIFIED: no TRM quote confirming “internal state not reset”; author
  suspicion only, not used as the sole reason

**YES**

 drivers/media/cec/platform/tegra/tegra_cec.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index fe66336e734f8..f8ffaeb78118d 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -243,7 +243,18 @@ static int tegra_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		  TEGRA_CEC_INT_MASK_RX_REGISTER_FULL |
 		  TEGRA_CEC_INT_MASK_RX_START_BIT_DETECTED);
 
-	cec_write(cec, TEGRA_CEC_HW_CONTROL, TEGRA_CEC_HWCTRL_TX_RX_MODE);
+	/*
+	 * TX_NAK_MODE ensures that the whole message is transmitted even
+	 * if each byte is NACKed. Without this flag the retransmit of the
+	 * messages after a NACK can be corrupt. This is a bug in the hardware.
+	 *
+	 * While less efficient, in practice you rarely transmit messages
+	 * that can be NACKed, with the exception of POLL messages which
+	 * are just one byte anyway.
+	 */
+	cec_write(cec, TEGRA_CEC_HW_CONTROL,
+		  TEGRA_CEC_HWCTRL_TX_RX_MODE |
+		  TEGRA_CEC_HWCTRL_TX_NAK_MODE);
 	return 0;
 }
 
-- 
2.53.0

