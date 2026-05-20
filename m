Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40C5374E74;
	Wed, 20 May 2026 11:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779275992; cv=none; b=clv30t7mUnAEwYYDHHjVsG6ulFuXe8CexhSoACQfWQL50Cn6iMPv2Aj7HHOppo+PTgDBuBEMuZNeO3ID4VQP+3jhAMHt0GTKpKsStQ5Oe/TceJnR3qkJA/vD26JJFCD83+QCITC6YgW4ipeVre3lqcva5rP90jg7mN3JjjR/3r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779275992; c=relaxed/simple;
	bh=v3FKuA5Z3gNVdXGKkVpFozfT5lnuMlMV+Rq5LvGtlrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W1GI/7M1pJ069uT6q9416988i6Ec/Z//fGBh10Dkw0N4UE9Cgn6twZ/hJ6IdXtSfJOVyIJSDb2RQxGdNNJHba3uflxNDVlg8mY8lGpdgWdfZtkoEcZ+5PYEV3muSoa19ZLend5xzAxj0MFjxxdOzOrpfM/SmMR3HOjpLZs7DLo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=magWFse2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="magWFse2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A1B1F000E9;
	Wed, 20 May 2026 11:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779275989;
	bh=8cvAvGj8neK6YyKsg+560fJiR2EQIke/vlr1cLGylZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=magWFse2ozT+c84/kOOrDm9DfEFoP6DqrR4MWJj2f64AbVh+qaU1vEY+4jShuzArW
	 t7MbCbCvRkiUoXylznSYD+lsH1v7gcFdWRfZicWIDn2/TF5I7+gfHqUrbH2lNxhehv
	 YCxIYDe93sg+cmIDHHsI1I4ejFHq6gk1UcHIvDzxfiQkwWJhcHqXS1DvOh1026ZXc0
	 W5DB8PBPPMqAh+MD4kIhuSlOeyBG/DLjDc3Pln2SB5k/CyLwn0o0Ti7MaHQcySlh6R
	 YzwuVG8l9pSO/rZxzBQ2CUJhqNoe96FoTmgvlONSKSQIH9q8+Pi2YUD6/WczAtgLD6
	 mD4OuweDCFm6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ALSA: sparc/dbri: add missing fallthrough
Date: Wed, 20 May 2026 07:18:35 -0400
Message-ID: <20260520111944.3424570-3-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 2bcbb163162789d3488562073dbb99d9bd71a762 ]

Fixes compiler error with probably newer compilers:

sound/sparc/dbri.c:595:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
  595 |         case 1:
      |         ^
sound/sparc/dbri.c:595:2: note: insert 'break;' to avoid fall-through
  595 |         case 1:
      |         ^
      |         break;

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260506031854.780411-1-rosenp@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

Step 1.1 Record: Subsystem `ALSA: sparc/dbri`; action verb `add`; intent
is to add a missing `fallthrough` annotation in `reverse_bytes()`.

Step 1.2 Record: Tags present: `Signed-off-by: Rosen Penev
<rosenp@gmail.com>`, `Link:
https://patch.msgid.link/20260506031854.780411-1-rosenp@gmail.com`,
`Signed-off-by: Takashi Iwai <tiwai@suse.de>`. No `Fixes:`, `Reported-
by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc: stable`.

Step 1.3 Record: The commit body reports a concrete compiler error:
`-Werror,-Wimplicit-fallthrough` in `sound/sparc/dbri.c` at the
fallthrough from `case 2` to `case 1`. Symptom is a build failure for
this driver/config with a compiler that diagnoses this unannotated
fallthrough as an error. No kernel version is named. Root cause is an
intentional fallthrough lacking the kernel `fallthrough;` marker.

Step 1.4 Record: This is not a hidden runtime bug fix; it is an explicit
build fix. Build fixes are stable-acceptable when they repair
compilation of existing code.

## Phase 2: Diff Analysis

Step 2.1 Record: One file changed: `sound/sparc/dbri.c`, `+1/-0`. One
function modified: `reverse_bytes()`. Scope is a single-file, one-line
surgical build fix.

Step 2.2 Record: Before, `case 2` performed the final bit swap and
implicitly fell into `case 1`/`case 0`, which then `break`s. After, the
same fallthrough is explicitly annotated with `fallthrough;`. Runtime
control flow is unchanged.

Step 2.3 Record: Bug category is build fix / compiler diagnostic fix.
Specific mechanism: the kernel already annotates earlier intentional
fallthroughs in the same switch, but the `case 2` to `case 1`
fallthrough lacked the annotation, triggering `-Wimplicit-fallthrough`
as an error.

Step 2.4 Record: Fix quality is high: it is one line, uses the existing
kernel `fallthrough` pseudo-keyword, matches nearby code style in
current branches, and does not change APIs or runtime behavior.
Regression risk is very low.

## Phase 3: Git History Investigation

Step 3.1 Record: `git blame` on `2bcbb16316278^` attributes this code to
`c3c9a75ede23f`, but the repository is shallow/grafted there, so that is
not a reliable true introduction point. I verified the same missing
annotation exists in local stable-related branches `pending-5.4`,
`pending-5.10`, `pending-5.15`, `pending-6.1`, `pending-6.6`,
`pending-6.12`, `pending-6.19`, and `pending-7.0`.

Step 3.2 Record: No `Fixes:` tag is present, so there is no introducing
commit to follow from the message.

Step 3.3 Record: Recent `sound/sparc/dbri.c` history on `linux-
next/master` shows this commit, then `ALSA: sparc/dbri: Use guard() for
spin locks`, then the shallow boundary. The guard refactor is not a
semantic prerequisite for adding this annotation, although older stable
branches may have slightly different context.

Step 3.4 Record: Author Rosen Penev has this recent `sound/sparc` commit
in the checked history. The commit was applied by Takashi Iwai, and
`MAINTAINERS` lists Takashi Iwai and Jaroslav Kysela as SOUND
maintainers.

Step 3.5 Record: No dependent `reverse_bytes` commits were found by
subject search. The change can be applied standalone as an annotation.
For `pending-5.4`, context differs because earlier fallthroughs are
comments rather than `fallthrough;`, so that tree may need a trivial
backport adjustment.

## Phase 4: Mailing List And External Research

Step 4.1 Record: `b4 dig -c 2bcbb16316278` found the original submission
at the provided lore/patch URL. `b4 dig -a` found only v1; no later
revision. The saved mbox contains Takashi Iwai’s reply: “Applied now.
Thanks.” No NAKs or concerns were present in the fetched thread.

Step 4.2 Record: `b4 dig -w` shows recipients: Rosen Penev, `linux-
sound@vger.kernel.org`, Jaroslav Kysela, Takashi Iwai, and `linux-
kernel@vger.kernel.org`.

Step 4.3 Record: No separate bug report or `Reported-by` tag. The
reported failure is the compiler diagnostic included in the patch email
and commit message.

Step 4.4 Record: `b4 dig -a` shows this is a single-patch series, not
part of a multi-patch dependency chain.

Step 4.5 Record: WebFetch to lore/stable search was blocked by Anubis.
Local stable branch log searches did not find this exact fix or a
related `unannotated fall-through` fix already present in the checked
stable branches.

## Phase 5: Code Semantic Analysis

Step 5.1 Record: Modified function: `reverse_bytes()`.

Step 5.2 Record: Callers found in `sound/sparc/dbri.c`: `xmit_fixed()`
calls `reverse_bytes()` for MSB fixed-pipe transmit data;
`dbri_process_one_interrupt()` calls it for fixed-data receive
interrupts.

Step 5.3 Record: `reverse_bytes()` only performs bit manipulation and
may print an error for unsupported lengths; it does not allocate memory,
take locks, or call into external subsystems.

Step 5.4 Record: Runtime paths are reachable through DBRI/CS4215
initialization/control and interrupt handling on supported SPARC SBus
DBRI hardware. For this patch, runtime reachability is not the main
issue because the fix targets compilation and preserves runtime flow.

Step 5.5 Record: Nearby switch cases already had intentional fallthrough
annotations; this patch fills the only missing annotation in that chain.

## Phase 6: Stable Tree Analysis

Step 6.1 Record: The missing annotation exists in checked stable-related
branches from `pending-5.4` through `pending-7.0`. Therefore the
affected source is present in active stable-era trees available locally.

Step 6.2 Record: Expected backport difficulty is clean or trivial for
most branches. `pending-5.4` has older comment-style fallthrough context
before `case 2`, so it may require a small context adjustment, but the
same one-line semantic change applies.

Step 6.3 Record: No related fix with this subject or `unannotated fall-
through` in `sound/sparc/dbri.c` was found in the checked stable-related
branches.

## Phase 7: Subsystem And Maintainer Context

Step 7.1 Record: Subsystem is ALSA SPARC sound driver, specifically Sun
DBRI. Criticality is peripheral/platform-specific, not core kernel-wide.

Step 7.2 Record: Recent `sound/sparc` history is sparse and mostly
maintenance/refactoring/build-style changes, indicating a mature low-
churn driver area.

## Phase 8: Impact And Risk Assessment

Step 8.1 Record: Affected users are config/platform-specific: SPARC/SBus
builds with `SND_SUN_DBRI`.

Step 8.2 Record: Trigger is building this driver with a
compiler/configuration that treats the unannotated fallthrough warning
as an error. I did not independently reproduce the compiler failure
locally.

Step 8.3 Record: Failure mode is build failure, not runtime crash or
data corruption. Severity is high for affected builders because the
kernel/module cannot be built successfully under that toolchain/config.

Step 8.4 Record: Benefit is meaningful for affected stable users because
it restores buildability of an existing driver. Risk is very low: one
annotation line, no feature, no API change, no runtime logic change.
Risk-benefit ratio favors backporting.

## Phase 9: Final Synthesis

Step 9.1 Record: Evidence for backporting: concrete compiler error,
existing driver code in stable branches, one-line obviously-correct fix,
maintainer-applied patch, no runtime behavior change, and build fixes
are valid stable material. Evidence against: platform-specific impact
and no independent local build reproduction. Unresolved: exact true
historical introduction predates the shallow boundary; lore stable
search via WebFetch was blocked.

Step 9.2 Record: Stable rules checklist:
1. Obviously correct and tested: yes for correctness by inspection;
   maintainer applied it. No local build test performed.
2. Fixes a real bug: yes, reported compiler error in existing code.
3. Important issue: yes for affected stable builds, because it can stop
   compilation.
4. Small and contained: yes, one line in one function.
5. No new features/APIs: yes.
6. Can apply to stable trees: yes with at most trivial context
   adjustment, especially for older comment-style fallthrough branches.

Step 9.3 Record: Exception category applies: build fix.

Step 9.4 Record: Decision is to backport. This is exactly the kind of
low-risk build fix stable trees should carry.

## Verification

- [Phase 1] Parsed `git show --format=fuller --stat --patch
  2bcbb16316278`: confirmed subject, tags, compiler-error body, and one-
  line patch.
- [Phase 2] Read `sound/sparc/dbri.c`: confirmed `reverse_bytes()` has
  annotated fallthroughs except the candidate-added `case 2` annotation.
- [Phase 3] Ran `git blame 2bcbb16316278^ -L 578,598 --
  sound/sparc/dbri.c`: confirmed changed area, with shallow/grafted
  limitation.
- [Phase 3] Ran branch snippet checks on `pending-5.4` through
  `pending-7.0`: confirmed the missing annotation exists in all checked
  stable-related branches.
- [Phase 3] Ran recent file history and author history checks: found
  only related maintenance/refactor commits, no dependency series.
- [Phase 4] Ran `b4 dig -c`, `-a`, `-w`, and saved the mbox: confirmed
  single v1 patch, proper ALSA recipients, and maintainer “Applied now”
  reply.
- [Phase 5] Searched `reverse_bytes(` call sites: confirmed callers are
  `xmit_fixed()` and `dbri_process_one_interrupt()`.
- [Phase 6] Searched stable branch logs: no existing backport or
  duplicate fix found locally.
- [Phase 7] Checked `MAINTAINERS`: confirmed SOUND maintainers include
  Jaroslav Kysela and Takashi Iwai.
- [Phase 8] Checked `include/linux/compiler_attributes.h`: confirmed
  `fallthrough` is the intended kernel pseudo-keyword and is available
  in checked stable branches.
- UNVERIFIED: I did not reproduce the compiler error with a local
  SPARC/SBus DBRI build.
- UNVERIFIED: The exact original introduction before the repository’s
  shallow/grafted boundary could not be determined.
- UNVERIFIED: WebFetch could not read lore/stable search results because
  Anubis blocked the page.

**YES**

 sound/sparc/dbri.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 75f82a92ff44f..2f5f62079fa4a 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -592,6 +592,7 @@ static __u32 reverse_bytes(__u32 b, int len)
 		fallthrough;
 	case 2:
 		b = ((b & 0xaaaaaaaa) >> 1) | ((b & 0x55555555) << 1);
+		fallthrough;
 	case 1:
 	case 0:
 		break;
-- 
2.53.0

