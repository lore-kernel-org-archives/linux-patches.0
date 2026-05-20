Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355BE3EF0D7;
	Wed, 20 May 2026 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276036; cv=none; b=YNSC2EPM02qOWhLXND/bQUGsFe+VqJHXOVn+CvIZrh2pzjFiCFxmByZCjokALsH/qqytzihWZACcXZxRRgjqdEiUAH68ecaI6wmtCJ5RxL1fxvZJff5jf/SQENFgAZLHloXekCgvrvGkph1prXJRry3yct7JqsjdtuRsbHmdcwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276036; c=relaxed/simple;
	bh=n1kjMAH6n1QMvxL4tue2EW0MTKmqqXgsAPBhnmI6cDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt87yVpMTSwCo3KwyHABYo6yas0egSaC1nV54f/kGcZohlHI2x353deCZmlsQXTgw7G4KD1tqPUhgXtJlxGxDMWKyPnv6hmwZBQHGq7NzAIpnDI4klOeWJAkI4ip1TUHI3UXHCRcGWZ64p3fjoumetpv0i5j0hqv35AlKzzBYHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2yzupuq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2yzupuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F0B1F00893;
	Wed, 20 May 2026 11:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276035;
	bh=RHBeMpolU18H6R9xI+OllTBmCQa7/WTbYDEkch01KQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2yzupuqlhDYk0ELmJvw4WZiQAlQoU9Zkc5PzktTLANeyHydFOkXLoBdH6Jol/rKa
	 qQvjJE1VaH62EXFiFNfJvuVGE1M6XwtNBqo3JKQPJFHZdXSt0I5fldJSQEiazG4cP/
	 hYQRznDBUie9oJLZpI3Wuy+ucRkPkYG+tAYoS/iGKYF69f6GF8994um8CsX2q8hw9h
	 hPMvO35tKo3JD4AWWLbU9ufhQohtj0WKvv9NmqF815dkj+lKfMT0zmXKm2Pm9koiAA
	 JMkTSlNEamaF+HSPMgaDOxy1VAZ7dB0Tt7doe6Gk3+NDAP/4LdDl230rijkoJYuXhF
	 Yj7673rEc0tjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	david.rhodes@cirrus.com,
	perex@perex.cz,
	tiwai@suse.com,
	corbet@lwn.net,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] ALSA: doc: cs35l56: Update path to HDA driver source
Date: Wed, 20 May 2026 07:19:07 -0400
Message-ID: <20260520111944.3424570-35-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 74e8409821ac8cda70bf23eb593f2c7f6e3b5a2f ]

The HDA drivers were moved to sound/hda/... so update a Documentation
reference that still pointed to the old location.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260511104148.36382-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record 1.1: Subsystem `ALSA: doc: cs35l56`; action verb `Update`;
intent: correct a stale documentation path to the HDA driver source.

Record 1.2: Tags present in supplied message: `Signed-off-by: Richard
Fitzgerald <rf@opensource.cirrus.com>`, `Link: https://patch.msgid.link/
20260511104148.36382-1-rf@opensource.cirrus.com`, `Signed-off-by:
Takashi Iwai <tiwai@suse.de>`. No `Fixes:`, `Reported-by:`, `Tested-
by:`, `Reviewed-by:`, `Acked-by:`, or `Cc: stable`.

Record 1.3: The body says the HDA drivers moved to `sound/hda/...`,
leaving this documentation reference pointing at the old
`sound/pci/hda/...` location. Symptom is incorrect documentation only;
no runtime failure, crash, data corruption, or security impact is
described.

Record 1.4: This is not a hidden runtime bug fix. It is a direct
documentation correction.

## Phase 2: Diff Analysis
Record 2.1: One file changed: `Documentation/sound/codecs/cs35l56.rst`,
1 insertion and 1 deletion. No functions modified. Scope: single-file
documentation-only surgical change.

Record 2.2: Before: HDA users were pointed to
`sound/pci/hda/cs35l56_hda.c`. After: they are pointed to
`sound/hda/codecs/side-codecs/cs35l56_hda.c`.

Record 2.3: Bug category: documentation correctness fix. Verified
current tree has `sound/hda/codecs/side-codecs/cs35l56_hda.c`;
`sound/pci/hda` does not exist in this checkout.

Record 2.4: Fix quality is obvious and minimal. Regression risk is
runtime zero, but backport targeting matters: applying it to older trees
where the driver is still under `sound/pci/hda` would make the
documentation wrong.

## Phase 3: Git History Investigation
Record 3.1: `git blame` shows the stale documentation line was
introduced by `088fb4ee17fc4` (`ALSA: doc: cs35l56: Add information
about Cirrus Logic CS35L54/56/57`). The line became stale when
`6014e9021b28e` moved HDA codec drivers into `sound/hda/codecs`.

Record 3.2: No `Fixes:` tag is present, so there was no Fixes target to
follow.

Record 3.3: Recent file history shows only CS35L56 documentation
updates. Related source movement is `6014e9021b28e`, which renamed
`sound/pci/hda/cs35l56_hda.c` to `sound/hda/codecs/side-
codecs/cs35l56_hda.c`.

Record 3.4: Author Richard Fitzgerald has multiple recent CS35L56/HDA-
related commits in this subsystem, including documentation and HDA
driver fixes.

Record 3.5: Dependency identified: this patch is correct only in trees
that already contain the HDA move commit `6014e9021b28e`.

## Phase 4: Mailing List And External Research
Record 4.1: `b4 am` using message ID
`20260511104148.36382-1-rf@opensource.cirrus.com` found a single patch
submission and reported no newer revision. Direct `WebFetch` to
lore/patch.msgid.link was blocked by Anubis, but `b4` retrieved the
mbox.

Record 4.2: `b4 dig -c` could not be run for the candidate commit
because no candidate commit hash was supplied and the commit was not
found on checked named branches searched. `b4 am` verified author DKIM
signatures and the patch metadata. `b4 dig -c 6014e9021b28e -w` verified
the prerequisite move patch was an ALSA HDA series sent to `linux-sound`
and relevant HDA/Cirrus recipients.

Record 4.3: No bug report, syzbot report, crash report, or user report
is linked.

Record 4.4: Candidate is standalone as a documentation update, but
semantically depends on the prior source-tree move.

Record 4.5: Web searches and local pending branch searches found no
stable-specific discussion for this exact documentation patch.

## Phase 5: Code Semantic Analysis
Record 5.1: No functions modified; documentation text only.

Record 5.2: No callers; this is not runtime code.

Record 5.3: No callees; no allocations, locks, I/O, or side effects.

Record 5.4: No userspace-triggerable kernel execution path. Impact is
limited to readers of the documentation.

Record 5.5: Search found the old path only in
`Documentation/sound/codecs/cs35l56.rst` among `.rst` files checked.

## Phase 6: Stable Tree Analysis
Record 6.1: Tag containment shows the documentation exists from
`v6.13+`; the HDA move exists from `v6.17+`. Therefore the stale-path
documentation issue exists only in trees containing both, i.e.
approximately `v6.17+` and later.

Record 6.2: `git apply --check` confirms the patch applies cleanly to
the current `7.0.y` tree. Backport difficulty is trivial for affected
trees, but it must not be applied to trees where the HDA driver still
lives under `sound/pci/hda`.

Record 6.3: No related stable fix for this exact path correction was
found in local pending branches.

## Phase 7: Subsystem And Maintainer Context
Record 7.1: Subsystem is ALSA sound documentation for Cirrus CS35L56
HDA/SoundWire amplifiers. Criticality: peripheral/documentation, not
runtime core.

Record 7.2: Sound documentation and HDA side-codec areas are actively
maintained; recent logs show multiple CS35L56/HDA commits.

## Phase 8: Impact And Risk Assessment
Record 8.1: Affected population: developers, maintainers, integrators,
and users consulting this CS35L56 documentation in kernels where the HDA
source has moved.

Record 8.2: Trigger condition: reading the documentation. Not
triggerable as a kernel runtime fault.

Record 8.3: Failure mode: stale documentation path. Severity LOW, but
documentation fixes are explicitly acceptable stable material due zero
runtime risk.

Record 8.4: Benefit is modest but real for affected trees; risk is very
low if limited to trees with `6014e9021b28e`, but negative for older
trees where the old path is still correct.

## Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: fixes an objectively wrong
documentation reference, one-line contained patch, no runtime regression
risk, applies cleanly to current `7.0.y`, documentation/comment fixes
are an accepted stable exception. Evidence against: no runtime bug, no
important crash/security/corruption impact, and it must be branch-
limited. Unresolved: exact upstream candidate commit hash was not
available locally.

Record 9.2: Stable rules: obviously correct: yes; tested: `b4` says
applies cleanly and local `git apply --check` passed; fixes a real bug:
yes, documentation bug; important runtime issue: no; small and
contained: yes, 1 line; no new feature/API: yes; applies to affected
stable trees: yes, for trees after the HDA move.

Record 9.3: Exception category: documentation fix.

Record 9.4: Decision: backport is appropriate, but only to stable trees
that already contain the HDA source move to `sound/hda/codecs/side-
codecs`. Do not apply to older stable trees where
`sound/pci/hda/cs35l56_hda.c` remains the correct path.

## Verification
- [Phase 1] Parsed supplied commit message and downloaded mbox:
  confirmed subject, author, message ID, and one-line documentation
  rationale.
- [Phase 2] Read `Documentation/sound/codecs/cs35l56.rst`: confirmed old
  path is present.
- [Phase 2] Checked filesystem: confirmed `sound/hda/codecs/side-
  codecs/cs35l56_hda.c` exists and `sound/pci/hda` does not in current
  tree.
- [Phase 3] `git blame -L 35,45`: confirmed stale line came from
  `088fb4ee17fc4`.
- [Phase 3] `git show 6014e9021b28e`: confirmed HDA codecs, including
  `cs35l56_hda.c`, were moved from `sound/pci/hda` to
  `sound/hda/codecs/side-codecs`.
- [Phase 4] `b4 am`: retrieved the patch, found one patch, no newer
  revision, DKIM signed.
- [Phase 4] `b4 dig -c <msgid>`: failed because `b4 dig` requires a
  commit-ish, not a message ID.
- [Phase 4] WebFetch to lore/patch.msgid.link: blocked by Anubis.
- [Phase 6] `git tag --contains`: documentation starts at `v6.13+`; HDA
  move starts at `v6.17+`.
- [Phase 6] `git apply --check`: candidate patch applies cleanly to
  current tree.
- [Phase 6] `git ls-tree`: `v6.6`/`v6.12` have old HDA source path and
  no affected doc; `v6.18` has both affected doc and new HDA source
  path.
- UNVERIFIED: Candidate final upstream commit hash, because it was not
  found on searched local named branches and was not provided.

**YES**

 Documentation/sound/codecs/cs35l56.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/sound/codecs/cs35l56.rst b/Documentation/sound/codecs/cs35l56.rst
index d5363b08f5152..b3f8c1c238518 100644
--- a/Documentation/sound/codecs/cs35l56.rst
+++ b/Documentation/sound/codecs/cs35l56.rst
@@ -40,7 +40,7 @@ There are two drivers in the kernel
 
 *For systems using SoundWire*: sound/soc/codecs/cs35l56.c and associated files
 
-*For systems using HDA*: sound/pci/hda/cs35l56_hda.c
+*For systems using HDA*: sound/hda/codecs/side-codecs/cs35l56_hda.c
 
 Firmware
 ========
-- 
2.53.0

