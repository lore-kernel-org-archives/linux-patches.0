Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4A13F1661;
	Wed, 20 May 2026 11:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276043; cv=none; b=MzbOVfnhdMm1Wwg9yMO2gjaF25jsP+k3oeQKSRo/nSJzXF5MCw2kPw3cmxwVcZDPDTYBFHEJhug0e5gWkaddZWaHQKjk7++6nvPhfKtAHJnTSJVijagOt2Hw3Fd2oyl0BqOqMJvXztY+dvGWYAHnZvEsqtXYMDkLOAd1oJ6nEBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276043; c=relaxed/simple;
	bh=8/YBaicmIR+/koRGrveQQ2zETy5i6mDtlV4qssVhNng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RBhALZXJimtkfo7ikNeONQmV6N+Akj9xmSoZV/g85FB6E88B6T4xYeI/UAGcGhM1UljmlVlYQumxXvz3FOejn6XZWG0d7AJoOGXqAhVUPNODhXdtMvubdngg5b95C5WqwkT9Oj/i9RDr44qWCHWgewBT16JqF8MxvfMkrg8WIec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTd8vY28; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTd8vY28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCC11F000E9;
	Wed, 20 May 2026 11:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276042;
	bh=4r0b79gth2S7r/zdOPKesNo2Nh2lUQWQHcWgM+q4up4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTd8vY28SVhBKkXI16aOGse33gu+o57QrMcpA8ROuKjq7hT52SYZb8c9e/4D7ycFS
	 Qi1YNSz+yzXUwinhe+d/BjIWWcYjelzMbzPLYH5AP4y0kFCEZJzzzoW2ZKsrEloxXT
	 eAWwk8x5cXqLRmWS9wdzfsmxeEovbpGLz0FTEfRl3B4M9oSNnaoAhwTRrs4M7ftDzC
	 UeUQzBbHYHyC+HlI94qWG1UrAhivz1ObJTplqL4tMyNosvyYdEGLWoBW3kP9uVgbq+
	 ba+mnFTQZt8Oj0gc+CHssFxfyl4Bac3DpFiHCFyv11FKLa5pDcb8s5tx0X6/0sKnad
	 UY0DwTsQoZzMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Linus Walleij <linusw@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] powerpc/g5: Enable all windfarms by default
Date: Wed, 20 May 2026 07:19:12 -0400
Message-ID: <20260520111944.3424570-40-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 8d57bb61734b23f6342e9de781173f1d83f90d3a ]

The G5 defconfig is clearly intended for the G5 Powermac
series, and that should enable all the available
windfarm drivers, or the machine will overheat a short
while after booting and shut itself down, which is
annoying.

Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260505-powermac-g5-config-v3-1-7747bf72f874@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record 1.1: Subsystem `powerpc/g5`; action verb `Enable`; intent: enable
all existing windfarm thermal drivers in `g5_defconfig`.

Record 1.2: Tags found: `Signed-off-by: Linus Walleij
<linusw@kernel.org>`, `Signed-off-by: Madhavan Srinivasan
<maddy@linux.ibm.com>`, `Link: https://patch.msgid.link/20260505-
powermac-g5-config-v3-1-7747bf72f874@kernel.org`. No `Fixes:`,
`Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc:
stable`.

Record 1.3: The body says G5 machines using this defconfig may overheat
shortly after boot and shut down if not all windfarm drivers are
enabled. Root cause: the G5 defconfig enables some, but not all, G5
windfarm thermal control drivers.

Record 1.4: This is a hidden bug fix despite “Enable” wording: it
changes default configuration to include missing existing thermal-
management drivers, preventing hardware overheat shutdown.

## Phase 2: Diff Analysis
Record 2.1: One file changed: `arch/powerpc/configs/g5_defconfig`,
`+2/-0`. No functions modified. Scope: single-file surgical defconfig
fix.

Record 2.2: Before: `g5_defconfig` enabled `WINDFARM_PM81`, `PM91`,
`PM112`, and `PM121`, but omitted `PM72` and `RM31`. After: it also
enables `CONFIG_WINDFARM_PM72=y` and `CONFIG_WINDFARM_RM31=y`.

Record 2.3: Bug category: hardware/default-config correctness fix.
Mechanism: builds in already-existing thermal control drivers for
PowerMac7,2/7,3 and RackMac3,1 systems.

Record 2.4: Fix quality is high: two config lines, no API change, no
code refactor. Regression risk is low because the enabled drivers check
machine compatibility and return `-ENODEV` on nonmatching hardware.

## Phase 3: Git History Investigation
Record 3.1: Blame shows surrounding windfarm entries came from
`2c39bf49fd0530` in 2012, while PM72/RM31 drivers were introduced by
`6cd320996746` and are present from v3.5. Checked v3.5, v3.6, v4.0,
v5.4, v5.10: the defconfig omitted PM72/RM31.

Record 3.2: No `Fixes:` tag, so no Fixes target to follow.

Record 3.3: Recent `g5_defconfig` history is mostly defconfig
maintenance and symbol removals; no prerequisite patch was identified.
The mailed patch is a one-patch series.

Record 3.4: Linus Walleij is an established kernel
maintainer/contributor, though not listed as PowerPC maintainer. The
patch was acked by Michael Ellerman in-thread and applied by Madhavan
Srinivasan, both PowerPC maintainers per `MAINTAINERS`.

Record 3.5: Dependencies are existing Kconfig symbols and are satisfied.
`make ARCH=powerpc g5_defconfig` on the candidate produced
`CONFIG_WINDFARM_PM72=y`, `CONFIG_WINDFARM_RM31=y`, and `CONFIG_I2C=y`.

## Phase 4: Mailing List And External Research
Record 4.1: `b4 am` found the v3 submission and three revisions: v1, v2,
v3. `b4 dig` matched the patch-id and found lore/patch.msgid links.
Direct `WebFetch` to lore was blocked by Anubis, but `b4 mbox`
downloaded the full v3 thread.

Record 4.2: `b4 dig -w` showed the patch was sent to Madhavan
Srinivasan, Michael Ellerman, Nicholas Piggin, Christophe Leroy,
`linuxppc-dev`, and `linux-kernel`.

Record 4.3: No separate bug report link was present. Thread evidence
confirms impact: Segher Boessenkool wrote that affected machines boot
but “won’t run for even a minute”; Linus said Debian likely works by
having the driver in initramfs/rootfs and that built-in is safer.

Record 4.4: Series context: same two-line patch rebased from v1 to v3,
no multi-patch dependency.

Record 4.5: Web search found no stable-list discussion for this exact
patch. No known stable objection found.

## Phase 5: Code Semantic Analysis
Record 5.1: No functions changed. Relevant enabled init functions are
`wf_pm72_init()` and `wf_rm31_init()`.

Record 5.2: These init functions are run at boot/module init when built.
`windfarm_core_init()` registers the `windfarm` platform device.

Record 5.3: `wf_pm72_init()` checks `PowerMac7,2`/`PowerMac7,3`;
`wf_rm31_init()` checks `RackMac3,1`; both register a platform driver
only after compatibility checks.

Record 5.4: Reachability is boot-time on affected hardware using
`g5_defconfig`, not syscall-triggered. The failure mode is hardware
thermal shutdown, not userspace API behavior.

Record 5.5: Similar pattern already exists in the same defconfig for
other G5 windfarm drivers (`PM81`, `PM91`, `PM112`, `PM121`).

## Phase 6: Stable Tree Analysis
Record 6.1: Checked v5.10, v5.15, v6.1, v6.6, v6.12, v6.18, v6.19, and
v7.0 tags: the buggy omission exists and the PM72/RM31 Kconfig symbols
exist.

Record 6.2: Generated patch applied cleanly to all checked tags: v5.10
through v7.0.

Record 6.3: Checked those tags for the exact subject; no related fix
already present.

## Phase 7: Subsystem Context
Record 7.1: Subsystem: PowerPC defconfig / Power Macintosh thermal
management. Criticality: platform-specific but important for affected
hardware because thermal control is required for safe operation.

Record 7.2: `drivers/macintosh` has low-to-moderate activity, mostly
treewide cleanups and small fixes; PowerMac is marked orphan, while
broader PowerPC is supported.

## Phase 8: Impact And Risk
Record 8.1: Affected users: PowerMac G5 AGP systems (`PowerMac7,2`,
`PowerMac7,3`) and Xserve G5 (`RackMac3,1`) using kernels built from
`g5_defconfig`.

Record 8.2: Trigger: booting affected hardware with the default G5
config lacking the built-in thermal driver. Not unprivileged-user-
triggered.

Record 8.3: Failure mode: overheating followed by shutdown shortly after
boot. Severity: CRITICAL for affected hardware availability and hardware
safety.

Record 8.4: Benefit is high for affected stable users; risk is very low:
two defconfig lines, existing drivers, clean applies, machine-specific
init guards.

## Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: fixes real hardware thermal
shutdown; two-line contained patch; existing drivers; dependencies
verified; applies cleanly to checked stable tags; maintainer
ack/application in PowerPC fixes. Evidence against: affects only niche
old hardware; no explicit `Cc: stable` or `Tested-by`. No unresolved
technical blockers.

Record 9.2: Stable rules: obviously correct: yes; tested: config
generation verified, no runtime `Tested-by`; real bug: yes; important
issue: yes, overheating/shutdown; small/contained: yes; no new
API/features: yes, only enables existing drivers in defconfig; applies
to stable: yes for checked tags.

Record 9.3: Exception category: closest match is hardware-support/config
fix for existing drivers, not new driver code.

Record 9.4: Decision: backport. This is a small, low-risk default-config
fix for a severe hardware failure mode.

## Verification
- Phase 1: Parsed tags from supplied commit and b4-fetched mbox.
- Phase 2: Verified diff is `+2/-0` in
  `arch/powerpc/configs/g5_defconfig`.
- Phase 3: Used `git blame`, `git log`, and `git show`; found PM72/RM31
  drivers introduced by `6cd320996746`, present since v3.5.
- Phase 4: Used `b4 am`, `b4 dig`, `b4 dig -w`, `b4 mbox`; full thread
  shows Michael Ellerman ack and Madhavan Srinivasan applied it to
  `powerpc/fixes`.
- Phase 5: Read `drivers/macintosh/Kconfig`, `Makefile`,
  `windfarm_pm72.c`, `windfarm_rm31.c`, and `windfarm_core.c`; verified
  machine-specific guards and boot/init path.
- Phase 6: Checked v5.10, v5.15, v6.1, v6.6, v6.12, v6.18, v6.19, v7.0
  for symbol presence and clean patch application.
- Phase 8: Failure mode verified from commit text and mailing-list
  thread; no independent runtime test performed here.

**YES**

 arch/powerpc/configs/g5_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index 428f17b455132..2fe8ca266b5f6 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -85,6 +85,8 @@ CONFIG_PMAC_SMU=y
 CONFIG_MAC_EMUMOUSEBTN=y
 CONFIG_WINDFARM=y
 CONFIG_WINDFARM_PM81=y
+CONFIG_WINDFARM_PM72=y
+CONFIG_WINDFARM_RM31=y
 CONFIG_WINDFARM_PM91=y
 CONFIG_WINDFARM_PM112=y
 CONFIG_WINDFARM_PM121=y
-- 
2.53.0

