Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B52400DEE;
	Wed, 20 May 2026 11:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276076; cv=none; b=eQb9pYBLvfbKLexTRsIM3XHp63VyJ7GAW1id2uhrfZHRhZckoFCXv/0zb4ThNW2yhZVHiTk4Z0gVFvEVQoVW6oXvvAtVbudMJBURZr3KUAPytuaawk/uJK+iXVfqge84zah60mIXuBSstNdoI8Fj2yIQ3ukVeCdIAXTutFGs9z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276076; c=relaxed/simple;
	bh=y30KC3srFv+XseZMDrzuM4GMU5XpEdlU5cHxgx2MAqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VU3llZibhX8YIeMBt9bcIRRj4whH1YIg4UK74qGtomT04xXBBayxVprgQiccIgmobNHOYXsFla+Ly8ty1kKffFskSFjmRfouUsvbO2xakFltkA7cR+9pqcTuakqhxVUwjN8QTe8YLch4oHeNwOneSrfFp6+RFtbNCv9I8MGJFzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqXB+1CB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqXB+1CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5AC1F00898;
	Wed, 20 May 2026 11:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276074;
	bh=vVYITuU5ayYDZ6nr6e6Lv1gWsOSA/WdMxHpJrzkPSpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqXB+1CBA9UEm3EDO1dw0mOgboAG4qsRV/vwMX6Ci93oXY6kk0dSdPeBNtlP5TGnq
	 8mrCIAV4I8BNEuGxjDJqVt2bqfrFNgRCWqhRknw19DAQDJtcMKCVk68RroNrohtr9/
	 poImP4Uvn8qyVOv8y68012RUGCIeKkYScg8ABiZeQhGqTZNTArpCsd/uRQggV/rp4M
	 k7HOSWUe2mKZVmzs+/j1r+xXxtLieCC5L/LhMLVi61s1WfJSh4p1F85y8Q+aCHz5Sr
	 X/eipuXtcVMu0g+p3/jg8K8mDuDW2WnixwH43dRcIdcYGTx0HyrmcxKh0vIM7SyRNU
	 eII3d91VR1cMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>,
	Greg KH <gregkh@linuxfoundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>,
	security@kernel.org,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] Documentation: security-bugs: do not systematically Cc the security team
Date: Wed, 20 May 2026 07:19:35 -0400
Message-ID: <20260520111944.3424570-63-sashal@kernel.org>
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

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit aed3c3346765e4317bb2ec6ff872e1c952e128ab ]

With the increase of automated reports, the security team is dealing
with way more messages than really needed. The reporting process works
well with most teams so there is no need to systematically involve the
security team in reports.

Let's suggest to keep it for small lists of recipients and new reporters
only. This should continue to cover the risk of lost messages while
reducing the volume from prolific reporters.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Leon Romanovsky <leon@kernel.org>
Reviewed-by: Leon Romanovsky <leon@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260509094755.2838-2-w@1wt.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record 1.1: Subsystem `Documentation/process/security-bugs`; action verb
`do not`; intent is to update security bug reporting instructions so
reporters do not always Cc the security team.

Record 1.2: Tags present: `Cc: Greg KH <gregkh@linuxfoundation.org>`,
`Cc: Leon Romanovsky <leon@kernel.org>`, `Reviewed-by: Leon Romanovsky
<leon@kernel.org>`, `Reviewed-by: Greg Kroah-Hartman
<gregkh@linuxfoundation.org>`, `Signed-off-by: Willy Tarreau
<w@1wt.eu>`, `Signed-off-by: Jonathan Corbet <corbet@lwn.net>`,
`Message-ID: <20260509094755.2838-2-w@1wt.eu>`. No `Fixes:`, no
`Reported-by:`, no `Tested-by:`, no `Cc: stable`.

Record 1.3: The body describes a process/documentation problem:
increased automated reports create more mail to the security team than
needed. Symptom is excess security-team involvement, not a kernel
runtime crash or data corruption. No affected kernel versions are named.

Record 1.4: This is not a hidden code bug fix. It is an explicit
documentation/process update that corrects now-overbroad guidance.

## Phase 2: Diff Analysis
Record 2.1: One file changed: `Documentation/process/security-bugs.rst`,
9 insertions and 1 deletion in the submitted patch. No functions are
modified. Scope is single-file documentation-only.

Record 2.2: Before: reports “must” be sent to maintainers with the
security team in Cc. After: reports still go to maintainers, but
security-team Cc is mandatory only for two-or-fewer recipients, advised
for early reports or specific help, and no longer necessary for
comfortable reporters sending to large teams.

Record 2.3: Bug category is documentation/process correctness. No
resource leak, race, memory safety, refcount, initialization, endian, or
hardware quirk mechanism exists.

Record 2.4: Fix quality is high for its scope: small, reviewed,
documentation-only, no runtime behavior. Regression risk is limited to
possibly changing reporter behavior; no kernel runtime regression is
possible from the diff itself.

## Phase 3: Git History Investigation
Record 3.1: `git blame` shows the replaced sentence was introduced by
`a72b832a482372` (“Documentation: explain how to find maintainers
addresses for security reports”), first contained by `v7.0-rc7~8^2~2`.

Record 3.2: No `Fixes:` tag is present, so there is no Fixes target to
follow.

Record 3.3: Recent history of `Documentation/process/security-bugs.rst`
shows a series of security-reporting documentation updates by Willy
Tarreau, including contact/process clarifications and typo fixes. This
patch is standalone at the diff level but part of a three-patch
documentation series.

Record 3.4: The author has multiple recent commits in
`Documentation/process/security-bugs.rst`. Maintainer lookup identifies
`Security Officers <security@kernel.org>` and `Jonathan Corbet
<corbet@lwn.net>` for this file.

Record 3.5: No code dependencies or functions exist. The exact patch
depends on the newer rewritten security-bugs document layout present in
`7.0.y`; older stable branches do not contain `a72b832a482372`.

## Phase 4: Mailing List And External Research
Record 4.1: `b4 dig -c` could not be used because no candidate commit
SHA was available locally or in the prompt, and local `master`, `docs-
next`, and `all-next` searches did not find the commit object. Using the
supplied Message-ID, `b4 am` found the original submission at
`https://patch.msgid.link/20260509094755.2838-1-w@1wt.eu`.

Record 4.2: `b4 am` and the mbox show v3 of a 3-patch series, 33 thread
messages, sent to Greg KH, Leon Romanovsky, Jonathan Corbet, Shuah Khan,
`security@kernel.org`, `workflows@vger.kernel.org`, `linux-
doc@vger.kernel.org`, and `linux-kernel@vger.kernel.org`.

Record 4.3: No bug report link, syzbot report, Bugzilla report, or user
crash report exists. Lore WebFetch was blocked by Anubis, but `b4`
successfully fetched the mbox.

Record 4.4: Series context: patch 1/3 is this Cc guidance change; patch
2/3 adds security-bug/threat-model documentation; patch 3/3 clarifies
AI-assisted reports. Cover letter says v2 reworded the “when to Cc” part
based on Greg’s feedback; v3 included wording/structure feedback and
added reviews.

Record 4.5: I found no stable-specific discussion or stable nomination
in the fetched thread. Jonathan Corbet said he applied the series to
`docs-fixes` after short linux-next exposure.

## Phase 5: Code Semantic Analysis
Record 5.1: No functions modified; documentation only.

Record 5.2: No callers; affected audience is readers of
`Documentation/process/security-bugs.rst`.

Record 5.3: No callees or side effects.

Record 5.4: Reachability is not runtime reachability. The path is
“reporter reads stable-tree documentation and follows reporting
instructions.”

Record 5.5: `rg` found the old mandatory-Cc sentence only in
`Documentation/process/security-bugs.rst`; related security-team
references remain elsewhere in the same document.

## Phase 6: Cross-Referencing And Stable Tree Analysis
Record 6.1: `a72b832a482372` is an ancestor of `stable/linux-7.0.y` but
not of local `stable/linux-5.15.y`, `stable/linux-6.1.y`,
`stable/linux-6.6.y`, `stable/linux-6.12.y`, `stable/linux-6.18.y`, or
`stable/linux-6.19.y`. So this exact buggy/obsolete sentence is
confirmed in `7.0.y`; older local stable trees have older document
layouts.

Record 6.2: `b4` reports the series base applies cleanly to the current
tree, which is `stable/linux-7.0.y`. Older stable trees would need a
different documentation backport if maintainers wanted equivalent
guidance there.

Record 6.3: No related stable fix for this exact wording was found in
local history.

## Phase 7: Subsystem And Maintainer Context
Record 7.1: Subsystem is documentation/process, specifically security
bug reporting. Criticality is process-important, not runtime
core/driver/filesystem criticality.

Record 7.2: The file has active recent development, with several
2025-2026 security-reporting documentation updates.

## Phase 8: Impact And Risk Assessment
Record 8.1: Affected population is documentation readers: security bug
reporters, maintainers, and the kernel security team. No running kernel
users are directly affected.

Record 8.2: Trigger is following the stable tree’s security-bug
reporting documentation. This can be done by any reporter, but it is not
a syscall or kernel execution path.

Record 8.3: Failure mode severity is low for runtime stability, but
medium for security-process efficiency: the old wording can
unnecessarily add the private security team to large-team reports.

Record 8.4: Benefit is moderate for keeping security reporting guidance
current and reducing unnecessary private-list traffic. Risk is very low
because the patch is documentation-only and reviewed.

## Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: documentation-only; zero runtime
regression risk; corrects overbroad/obsolete reporting guidance;
reviewed by Leon Romanovsky and Greg Kroah-Hartman; applied by
documentation maintainer Jonathan Corbet; relevant to security reporting
workflow; clean for `7.0.y`.

Evidence against: it does not fix a kernel runtime bug, crash, security
vulnerability, corruption, or deadlock; older stable trees do not
contain the exact rewritten section, so this exact patch is mainly
applicable to `7.0.y`.

Unresolved: I could not run `b4 dig -c` without a commit SHA, and
WebFetch of lore was blocked by Anubis. The `b4` Message-ID fetch
supplied the needed thread content.

Record 9.2: Stable rules: obviously correct and reviewed: yes. Fixes
real user-visible runtime bug: no. Important
crash/security/corruption/deadlock: no. Small and contained: yes, one
documentation file. No new feature/API: yes. Applies to stable: yes for
`7.0.y`; older branches need separate handling.

Record 9.3: Exception category: documentation fix/update. This is the
reason it qualifies despite not being a runtime bug.

Record 9.4: Decision: backport where the affected documentation exists,
especially `7.0.y`. The runtime benefit is nonexistent, but the risk is
also nonexistent, and stable policy exceptions allow documentation fixes
that correct obsolete guidance.

## Verification
- Phase 1: Parsed supplied commit tags and b4 patch headers; confirmed
  no `Fixes:`, `Reported-by:`, `Tested-by`, or `Cc: stable`.
- Phase 2: Read supplied diff and b4 patch; confirmed one documentation
  file, 9 insertions/1 deletion, no code.
- Phase 3: Ran `git blame -L 148,152 -- Documentation/process/security-
  bugs.rst`; old sentence introduced by `a72b832a482372`.
- Phase 3: Ran `git describe --contains a72b832a482372`; first contained
  around `v7.0-rc7~8^2~2`.
- Phase 3: Ran file and author history commands; confirmed recent
  related docs updates by Willy Tarreau.
- Phase 4: Local `git log` searches on current history, `master`, `docs-
  next`, and `all-next` did not find the candidate commit object.
- Phase 4: `b4 am -o /tmp/security-bugs-b4
  20260509094755.2838-2-w@1wt.eu` found a v3 3-patch series, 33
  messages, and reported clean apply to current tree.
- Phase 4: `b4 mbox` saved the thread mbox; `rg` found no stable
  nomination or NAK for this patch.
- Phase 4: WebFetch of lore URLs was blocked by Anubis; not used for the
  final decision.
- Phase 5: `rg` over `Documentation` confirmed the exact mandatory-Cc
  sentence appears in `Documentation/process/security-bugs.rst`.
- Phase 6: `git merge-base --is-ancestor a72b832a482372
  stable/linux-7.0.y` returned true; checks for `5.15.y`, `6.1.y`,
  `6.6.y`, `6.12.y`, `6.18.y`, and `6.19.y` returned false.
- Phase 7: `./scripts/get_maintainer.pl` identified Security Officers
  and Jonathan Corbet for the file; `MAINTAINERS` confirms
  `DOCUMENTATION PROCESS`, `SECURITY CONTACT`, and `STABLE BRANCH`
  entries.
- Phase 8: Failure mode verified from commit text and diff only:
  documentation/process burden, not runtime failure.

**YES**

 Documentation/process/security-bugs.rst | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/process/security-bugs.rst b/Documentation/process/security-bugs.rst
index 27b028e858610..6dc525858125e 100644
--- a/Documentation/process/security-bugs.rst
+++ b/Documentation/process/security-bugs.rst
@@ -148,7 +148,15 @@ run additional tests.  Reports where the reporter does not respond promptly
 or cannot effectively discuss their findings may be abandoned if the
 communication does not quickly improve.
 
-The report must be sent to maintainers, with the security team in ``Cc:``.
+The report must be sent to maintainers.  If there are two or fewer
+recipients in your message, you must also always Cc: the Linux kernel
+security team who will ensure the message is delivered to the proper
+people, and will be able to assist small maintainer teams with processes
+they may not be familiar with.  For larger teams, Cc: the Linux kernel
+security team for your first few reports or when seeking specific help,
+such as when resending a message which got no response within a week.
+Once you have become comfortable with the process for a few reports, it is
+no longer necessary to Cc: the security list when sending to large teams.
 The Linux kernel security team can be contacted by email at
 <security@kernel.org>.  This is a private list of security officers
 who will help verify the bug report and assist developers working on a fix.
-- 
2.53.0

