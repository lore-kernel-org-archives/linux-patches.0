Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168BE407566;
	Tue, 28 Apr 2026 10:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372955; cv=none; b=UbGf/iBL6cznSL3tQXkX/rIdOKfsYqlKL6UHBBMAi1wRVvxr+J43biouUn/HOvAoQZ6tDHQbkhxs+8k0g3BElyMdHSAAWshobLmWgmV0VcvKJarQXz/0N/wGuqUbzXEgylS1jpdb8l4itMF+WsaTnuvEYRnxdWUTki2reGqHOUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372955; c=relaxed/simple;
	bh=zuMi5mnJWZBycMArFZW4PIa8AMsyzx125Jd1rs5wJP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qyJKNxma4NSzwAbUFmDrVuU2WQxGP0tLXoiGaS2sVn2RfzgO5fJvmN1D1XaUbA6aPThtfBfWPCfwXILp2QW7iEF5FVUsNAymZ9VZJLo2qU9o7VOISVRHO3FfQNmSeu2kn890usIbcTZ40N+T6r65P38gH05nyxaAZ2STtCviDRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJFlHS+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJFlHS+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BA8C2BCB8;
	Tue, 28 Apr 2026 10:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372954;
	bh=zuMi5mnJWZBycMArFZW4PIa8AMsyzx125Jd1rs5wJP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJFlHS+eoMCmFyi/6o2mZqipousP3tHB+o5xbLntdn/zSN27RRAJvlRPtci8eReum
	 jnTIaBi48bWHWdDqQPOjQkAh2S5pAJYSDyBPthu3HI3LJjaavPpgEOcfFTN3bHbCsq
	 S/eKIP/rSe4vdujGjCu19WTEgVw5hGSKpqRy8W18YpKsGvTK2SpzF6s/aTnJ/6nnUe
	 yiCM+8g0QBrshaEcilXjBuedw0Ya9+4txj8/vqRZXjikrkjLmDQtZ627uyMINQgyYI
	 F3oOiROjdxIR2VnpGx7xfdluKHgKwoVDCuI3WKMwqDJ5OF4vvp25EAto9bk7rgkJgI
	 Eg8EeIKcEVIKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	jic23@kernel.org,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] iio: ABI: fix current_trigger description
Date: Tue, 28 Apr 2026 06:40:54 -0400
Message-ID: <20260428104133.2858589-43-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

[ Upstream commit 04bb8d0e5d1c8d5a9079b35b4e6f0868f734698b ]

Triggers exist under /sys/bus/iio/devices/, not under /sys/class/iio.
/sys/class/iio does not even exist. Use the current path.

Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough to complete the analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line**
- Subsystem: `iio: ABI:` (Industrial I/O subsystem ABI documentation)
- Action verb: "fix"
- Record: iio: ABI: fix → corrects the documented sysfs path for
  current_trigger

**Step 1.2: Tags**
- `Signed-off-by: Cosmin Tanislav` (author)
- `Signed-off-by: Jonathan Cameron` (subsystem maintainer who applied
  it)
- No Reported-by, no Link, no Cc: stable, no Fixes: tag
- Record: Minimal tags. Only author SOB + maintainer SOB. No external
  reports/link.

**Step 1.3: Commit body analysis**
- Bug: documentation references `/sys/class/iio/triggerY/name`, which
  does not exist
- Correction: triggers actually live at `/sys/bus/iio/devices/`
- Symptom: a developer/user reading the ABI doc is told to look at a
  path that does not exist
- Record: pure documentation correction; no code or runtime behavior is
  affected.

**Step 1.4: Hidden bug fix?**
- Record: Not a hidden code fix. This is a documentation-only
  correction.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `Documentation/ABI/testing/sysfs-bus-iio`
- +1/-1 line. Single-line change.
- Record: trivial scope, surgical edit.

**Step 2.2: Code flow change**
- Before: doc text said "as per string given in
  /sys/class/iio/triggerY/name."
- After: doc text says "as per string given in
  /sys/bus/iio/devices/triggerY/name."
- No execution path is changed.

**Step 2.3: Bug mechanism**
- Category: documentation/comment fix (no runtime effect).
- Record: Stale path - `/sys/class/iio` was the path used during early
  IIO staging days; the subsystem moved to `/sys/bus/iio/devices/` long
  ago.

**Step 2.4: Fix quality**
- Obviously correct: I verified the path is the only stale reference
  left in `Documentation/`, and the file uses `/sys/bus/iio/devices/...`
  everywhere else (including the same `What:` header).
- Zero regression risk - no code change.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- `git blame -L 1430,1432`: the buggy line was introduced by
  `f386caa3cd7423` ("staging: iio: documentation rewrite and cleanup of
  sysfs documetation") by Jonathan Cameron in **November 2010**, when
  IIO was still in staging.
- Record: stale path has been wrong in tree for ~15 years; present in
  every stable branch.

**Step 3.2: Fixes: tag**
- No Fixes: tag in the patch.
- Record: not applicable; verified by reading commit message.

**Step 3.3: File history**
- `git log --oneline -5 -- Documentation/ABI/testing/sysfs-bus-iio`:
  recent activity is unrelated additions (ad7173 filters, mag_referenced
  docs, pressure event attributes).
- Record: no series dependency, standalone fix.

**Step 3.4: Author's other commits**
- Cosmin Tanislav has multiple other IIO ABI doc commits
  (`06a4a0cf69847`, `89d185848633d`).
- Patch was applied by Jonathan Cameron (the IIO maintainer).
- Record: legitimate IIO contributor + applied by maintainer.

**Step 3.5: Dependencies**
- None - single line doc change.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: b4 dig**
- `b4 dig -c 04bb8d0e5d1c8`: matched at
  https://lore.kernel.org/all/20260204180202.515393-1-cosmin-
  gabriel.tanislav.xa@renesas.com/
- `b4 dig -a`: only v1 of the patch (no revisions), applied as
  submitted.
- mbox content shows:
  - David Lechner (reviewer) commented on triggerX vs triggerY naming.
    Author defended `triggerY` (since `iio:deviceX` is used right
    above).
  - David replied "Fair point."
  - Jonathan Cameron: "Agreed and applied." - applied the patch as-is.
- Record: minimal review, no NAKs, no objections, applied unchanged.

**Step 4.2: Reviewers**
- `b4 dig -w`: included Jonathan Cameron (maintainer), David Lechner,
  Nuno Sá, Andy Shevchenko, linux-iio list.
- Record: appropriate maintainer and reviewers were included.

**Step 4.3 / 4.4 / 4.5:** No bug reports, no series dependencies, no
stable mailing list discussion.

## PHASE 5: CODE SEMANTIC ANALYSIS

- N/A: documentation-only change. No functions modified, no
  callers/callees, no call chain.
- Verified: `git grep "/sys/class/iio" Documentation/` shows the patched
  line was the only remaining stale reference.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy code in stable**
- The stale doc text has been in tree since 2010 (v2.6.37 era) and is
  present in every active stable branch.
- Record: applies to all stable trees.

**Step 6.2: Backport complications**
- Trivial 1-line text replacement; the surrounding doc structure has
  been the same for years. Should apply cleanly.
- Record: no backport conflicts expected.

**Step 6.3: Related fixes in stable**
- None found.

## PHASE 7: SUBSYSTEM CONTEXT

- Subsystem: IIO ABI documentation under `Documentation/`.
- Criticality: PERIPHERAL - this is documentation, not runtime code.
- Active subsystem (IIO) but file is just human-readable docs.

## PHASE 8: IMPACT AND RISK

**Step 8.1: Affected users**
- Anyone reading the IIO ABI documentation (developers, users writing
  tools).

**Step 8.2: Trigger conditions**
- "Trigger" is reading the doc; the wrong path is always shown.

**Step 8.3: Failure mode severity**
- Failure mode: user looks at wrong (nonexistent) sysfs path. No kernel
  impact whatsoever.
- Severity: LOW (documentation only, no crashes, no security, no data
  loss).

**Step 8.4: Risk vs benefit**
- Benefit: low (corrects misleading documentation that has been wrong
  for 15 years - users have either figured it out or filed bugs).
- Risk: essentially zero (text-only change in `Documentation/`).

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
- FOR: 1-line, trivial, obviously-correct documentation correction; zero
  regression risk; applied cleanly by the maintainer.
- AGAINST: Stable kernel rules require fixing an "important issue
  (security bug, data corruption, serious crash, deadlock, etc.)". A
  purely cosmetic doc path fix does not meet that bar. No reporter, no
  Link, no user complaint cited. The wrong text has been in the kernel
  for ~15 years with nobody pushing it as urgent.

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? Yes (text edit verified by inspection).
2. Fixes a real bug? It fixes a documentation bug, not a runtime bug.
3. Important issue (crash, security, corruption, deadlock)? **No** -
   none of these.
4. Small/contained? Yes (1 line).
5. No new features/APIs? Correct - it's a doc edit.
6. Applies to stable? Yes, trivially.

**Step 9.3: Exception category check**
- Documentation fixes are listed as an exception category in the
  framework's "DOCUMENTATION and COMMENT FIXES" section (zero risk of
  runtime regression). The framework lists "Documentation fix" as an
  automatic-YES exception in step 9.3.

**Step 9.4: Decision**
This is a tiny, obviously-correct documentation fix. It does not fix a
crash, security bug, data corruption, or deadlock. However, the
framework explicitly classifies "Documentation and comment fixes" as a
stable-acceptable exception category specifically because they have zero
runtime regression risk. The patch was applied by the maintainer with
zero objections, and applies trivially to every stable tree. While the
priority is low, the cost is essentially nothing and it improves
documentation accuracy for users referencing the IIO ABI in stable
kernels.

## Verification

- [Phase 1] Parsed message: only Signed-off-by tags from author +
  maintainer; no Reported-by, no Link, no Fixes:, no Cc: stable.
- [Phase 2] Read full diff: 1 line changed in
  `Documentation/ABI/testing/sysfs-bus-iio`, replacing
  `/sys/class/iio/triggerY/name` → `/sys/bus/iio/devices/triggerY/name`.
- [Phase 3] `git log --oneline --author="Cosmin Tanislav" --
  Documentation/ABI/testing/sysfs-bus-iio` confirms author is a regular
  IIO doc contributor; commit `04bb8d0e5d1c8` exists in tree.
- [Phase 3] `git blame` on adjacent lines: stale path text introduced by
  `f386caa3cd7423` (Jonathan Cameron, 2010-11-22, IIO staging era).
- [Phase 3] `git show f386caa3cd7423`: confirmed it was a doc-rewrite
  commit while IIO was in staging.
- [Phase 4] `b4 dig -c 04bb8d0e5d1c8`: matched submission at lore (URL
  above); single revision (v1).
- [Phase 4] `b4 dig -a`: only v1 of patch.
- [Phase 4] `b4 dig -w`: Jonathan Cameron (IIO maintainer), David
  Lechner, Nuno Sá, Andy Shevchenko, linux-iio CC'd.
- [Phase 4] mbox of thread shows: maintainer Jonathan Cameron stated
  "Agreed and applied"; David Lechner had a side comment about triggerX
  vs triggerY but accepted the author's reasoning ("Fair point."); no
  NAKs.
- [Phase 5] `git grep "/sys/class/iio" Documentation/` returns only the
  line being fixed in the pre-patch tree - confirms there's no further
  occurrence to worry about.
- [Phase 6] File exists in all stable branches (this Documentation file
  pre-dates all current stable trees). Trivial text patch applies
  cleanly.
- [Phase 8] Failure mode: user reads incorrect path in documentation. No
  kernel runtime impact. Severity: LOW.
- UNVERIFIED: Did not directly check whether each individual stable tree
  (5.10, 5.15, 6.1, 6.6, 6.12) has the exact same line context, but the
  surrounding documentation block has not been restructured in many
  years, so a clean apply is overwhelmingly likely.

The patch is a benign documentation correction with zero regression risk
that has been wrong since 2010 and was accepted by the IIO maintainer
without changes. It fits the framework's "Documentation fixes" exception
category despite not fixing a crash or security issue.

**YES**

 Documentation/ABI/testing/sysfs-bus-iio | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 5f87dcee78f76..4fc9f6bd42812 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -1428,7 +1428,7 @@ KernelVersion:	2.6.35
 Contact:	linux-iio@vger.kernel.org
 Description:
 		The name of the trigger source being used, as per string given
-		in /sys/class/iio/triggerY/name.
+		in /sys/bus/iio/devices/triggerY/name.
 
 What:		/sys/bus/iio/devices/iio:deviceX/bufferY/length
 KernelVersion:	5.11
-- 
2.53.0

