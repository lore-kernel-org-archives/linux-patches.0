Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BF156DCCC;
	Mon, 19 Oct 2026 13:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418286; cv=none; b=bVVCi79WI0CNj3x2pMcm+Ivf3vT7xpPPML54DEmtiIMtZ30vUJ9QDudB1Bk0rS+IFjXsv/r2WSQevYzh8zPWZqWXRCXk2qt1TKUgbYeVtNNF7OoqZO3ygYWc7KaZHr2rlGGZ7QQmQC7nyxuJvg3RQ+2mJWpLAiSxpoMQcaQ0Jr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418286; c=relaxed/simple;
	bh=3QGg+1T51XI+6ErIgq7haAN3iJcqq4509MpqRcj74Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIKSOvXSdJLL/6G3nWE5fVb03TCr2MFy7iiw0MtGbx1I4fbo2uqRGGijx/KrXUizy1os8JahicfCT0FlhkNjpj8Nknk80Bwe1w7jSAOCdseWAgoANLs3zwHqepqgw8i/evko4JO4gFAiK318TxWK9W1VFmNs9hyEUxu1DykiYbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2lWsD3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2lWsD3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C433F1F000C6;
	Mon, 19 Oct 2026 13:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418283;
	bh=Dv3twa7zYOB3knqGrwOntSkkwfPWGCbTt5dOVIhc7Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2lWsD3/9dHeUKkLyg+Z6WFUrxPIulOKlijIB69wU2fTw7mbnD0ceHmMy6CTOWqXv
	 NxpOM9SDBm/HUsSBGDXGfmn4WvoM6lDD7How7yVRn12lcb+uDb7p7tZd4z2NRvtvZu
	 IdQTJPqRcnHgPZZ7hzYOfphQGBgpkcwBwc6n9nyARAlswKmBmpC64+srtMQwJcXfsQ
	 Ahd7IyUCF9+sJnuHyrM7o8Wfnxgm2//KAjhAsPYPLJcKdRBpCkTRwFW60CV6rU6zMc
	 AUf1NEOc9VJ4SGbnBo695HH+pGwVBCHYH/vHxYr/f+7NTKXaMFpQbontv/0JZ0jN09
	 TgbTaxKq7SKyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jenson Johnathon Reggentin <mail@jregg.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>,
	axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] docs: block: fix dead http link in blk-mq.rst
Date: Mon, 19 Oct 2026 09:47:09 -0400
Message-ID: <20261019135441.1420968-138-sashal@kernel.org>
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

From: Jenson Johnathon Reggentin <mail@jregg.de>

[ Upstream commit b40a680ea4efe4ef2addada63e304a94d19500d1 ]

The current link http://kernel.dk/blk-mq.pdf leads to a 404 error page.
https://www.kernel.dk/blk-mq.pdf leads to the correct document.

v2 to add the missing www. prefix in the actual file change.

Signed-off-by: Jenson Johnathon Reggentin <mail@jregg.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260819192422.42189-1-mail@jregg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the tree identity, the dead URL in-tree, review history, and a
clean apply. Next I’ll finish call-site and stable-rule checks, then
give the backport verdict.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

Step 1.1: PARSE THE SUBJECT LINE
Record: `[docs: block:]` `[fix]` `[dead HTTP link in blk-mq.rst]` —
documentation URL correction in the block multi-queue overview.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Jenson Johnathon Reggentin `<mail@jregg.de>` (author)
- Acked-by: Randy Dunlap `<rdunlap@infradead.org>` (docs reviewer)
- Signed-off-by: Jonathan Corbet `<corbet@lwn.net>` (docs maintainer,
  applied it)
- Message-ID: `<20260819192422.42189-1-mail@jregg.de>` (v2 submission)
- No Fixes: tag (expected)
- No Reported-by / Tested-by / Reviewed-by on the committed form (v1 had
  Reviewed-by: Md Haris Iqbal; that tag was not carried to v2)
- No Cc: stable (expected; not a negative)
- Ignore any pipeline “Upstream commit” / “Signed-off-by: Sasha Levin”
  markers if present

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `http://kernel.dk/blk-mq.pdf` in the “Further reading” section
  returns 404.
- Symptom: readers of blk-mq documentation cannot open the canonical
  blk-mq paper.
- Fix: switch to `https://www.kernel.dk/blk-mq.pdf`.
- v2 note: v1 used `https://kernel.dk/blk-mq.pdf` (missing `www.`),
  which still 404’d / had a bad cert; v2 adds `www.`.
- No kernel version range given; no crash/trace.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a hidden runtime fix. It is exactly what it says: a
documentation hyperlink correction. Not a leak/race/UAF disguised as
cleanup.

---

## PHASE 2: DIFF ANALYSIS

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `Documentation/block/blk-mq.rst` — 1 line changed (`-1/+1`)
- Functions: none
- Scope: single-file, surgical documentation edit

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: RST link target `http://kernel.dk/blk-mq.pdf`
- After: RST link target `https://www.kernel.dk/blk-mq.pdf`
- Path affected: documentation “Further reading” only; no execution path

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: Not a memory-safety/locking/refcount bug. Category:
documentation correctness (dead external URL). Mechanism: site now
requires HTTPS + `www.` hostname.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct once v2 uses the working URL.
- Minimal; no unrelated edits.
- Regression risk: none at runtime. Residual risk is only that the
  remote host could move again (same class of risk as any external
  link).
- v1 was wrong (Randy Dunlap reported continued 404 / bad SSL);
  committed v2 addresses that.

Verified live:
- `http://kernel.dk/blk-mq.pdf` → 404
- `https://www.kernel.dk/blk-mq.pdf` → PDF retrieved (51.5 KB)

---

## PHASE 3: GIT HISTORY INVESTIGATION

Step 3.1: BLAME THE CHANGED LINES
Record:
- Introduced in `46e906144c3f4b` (“docs: block: Create blk-mq
  documentation”, André Almeida, 2020-06-19)
- First appeared: `v5.9-rc1` (`git describe --contains` →
  `v5.9-rc1~150^2~141`)
- Present in this tree for the entire 6.12 lifetime

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. The introducing commit is the original
documentation add, not a later regression in C code.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record (this tree, `-- Documentation/block/blk-mq.rst`):
- `41bd33df4e180` docs: correct places → place
- `c19430eec84f7` Fix small typo
- `2bc602cb0e0d9` correct drive → driver
- `8ac867340bd8c` / `9303c9d5e9883` Sphinx `:c:type` cleanup
- `46e906144c3f4b` create the file
No later URL rewrite in this checkout. Standalone; not patch X/Y of a
functional series.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: `git log --author="Jenson Johnathon Reggentin"` /
`mail@jregg.de` on this tree: no hits. One-off docs contributor, not the
block maintainer. Applied by Jonathan Corbet; Acked-by Randy Dunlap.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No new helpers, structs, or APIs. The hunk matches the current
file byte-for-byte. Can apply standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 mbox 20260819192422.42189-1-mail@jregg.de` saved 12-message thread
  (lore HTTP 403 from WebFetch; b4 succeeded).
- v1: `https://kernel.dk/blk-mq.pdf` (no www)
- v2 (applied): `https://www.kernel.dk/blk-mq.pdf`
- Randy Dunlap: v1 still 404 + invalid SSL; confirmed `www.` works;
  Acked-by on v2; asked changelog-after-`---` nit
- Haris Iqbal: Reviewed-by on v1; spotted missing `www.`
- Jonathan Corbet: asked for a version that actually works; applied v2
  (“Applied, thanks.”)
- No NAK. No reviewer asked for Cc: stable.
- Included in Corbet’s `[GIT PULL] Documentation stragglers for 7.3`
  (`docs-7.3-2`), described as late-arriving docs fixes, not a stable-
  critical runtime fix.
- Syzbot CI skipped both versions: “AI determined the patch has no
  functional impact”

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (syzbot CI Cc + thread):
- To/Cc: Jens Axboe, Jonathan Corbet, linux-block, linux-doc
- Reviewers who spoke: Randy Dunlap (ack), Md Haris Iqbal (v1 r-b),
  Jonathan Corbet (applied)
- Block maintainer was copied; no Axboe reply in the 12-message thread

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot crash. Author observed a 404. Confirmed
independently in this analysis.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone. v1→v2 only to correct the hostname. No sibling
functional patches required.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable WebFetch returned 403. UNVERIFIED that
stable@ discussed this specific URL. No evidence in the docs thread of a
stable nomination or of a reason to exclude it.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

Step 5.1: KEY FUNCTIONS
Record: None. Only an RST hyperlink.

Step 5.2: TRACE CALLERS
Record: N/A — not callable kernel code. Consumers are humans (and Sphinx
HTML on kernel.org / distro doc packages).

Step 5.3: TRACE CALLEES
Record: N/A.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Not reachable from syscalls. User impact is documentation-only.
kernel.org `v6.12` HTML is built from this tree, so the 404 is user-
visible for people reading 6.12 docs.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: `kernel.dk/blk-mq` appears only in `Documentation/block/blk-
mq.rst` in this tree. Other `kernel.dk` hits are emails/copyrights, not
this PDF.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`
- `make kernelversion` / Makefile → **6.12.111**, branch `pending-6.12`
- Line 142 of `Documentation/block/blk-mq.rst` still has
  `http://kernel.dk/blk-mq.pdf`
- `git merge-base --is-ancestor 46e906144c3f4b HEAD` → yes
- Bug introduced v5.9-rc1 (2020); present here

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Surrounding hunk is identical to the patch context. Expected
apply: **clean**. `git log v6.12..HEAD -- Documentation/block/blk-
mq.rst` is empty (no conflicting stable edits).

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Replacement URL not present. No alternate rewrite of this link.
Comparable docs-link backports **do** exist after v6.12 in this tree,
e.g.:
- `b23111ec50d86` `docs: hwmon: fix link to g762 devicetree binding`
- `a7f28636da6f9` `docs: media: update location of the media patches`
  (explicit Cc: stable)

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

Step 7.1: SUBSYSTEM AND CRITICALITY
Record:
- Subsystem: Documentation for the block layer (`Documentation/block/`,
  MAINTAINERS: BLOCK LAYER, Jens Axboe; docs tree via Corbet)
- Criticality of **blk-mq itself**: IMPORTANT (common block I/O)
- Criticality of **this change**: documentation-only, not the I/O path

Step 7.2: SUBSYSTEM ACTIVITY
Record: `Documentation/block/` is mature; this file’s last change in-
tree is a 2023 typo fix. The URL has been wrong/stale for years; the
site layout change is what made `http://kernel.dk/...` a hard 404.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

Step 8.1: WHO IS AFFECTED
Record: Anyone reading in-tree or generated blk-mq docs (developers,
distro doc packages, kernel.org HTML for 6.12). Not a
runtime/driver/config population.

Step 8.2: TRIGGER CONDITIONS
Record: Opening the “Further reading” PDF link. Common for people
studying blk-mq; never triggered by unprivileged syscalls. Not a race.

Step 8.3: FAILURE MODE SEVERITY
Record:
- Failure: HTTP 404 / cannot open the referenced paper
- Severity: **LOW** (incorrect documentation, no crash/corruption/hang)
- No kernel oops, leak, or security effect

Step 8.4: RISK-BENEFIT RATIO
Record:
- Benefit: working further-reading link in 6.12 docs; small but real for
  doc users
- Risk: **very low** (one RST URL; no code, locks, APIs)
- Ratio: favorable *if* documentation corrections are in scope; not a
  stability win

---

## PHASE 9: FINAL SYNTHESIS

Step 9.1: COMPILE THE EVIDENCE

FOR backporting:
- Dead link is real (404 verified); replacement URL works
- One-line, obviously correct v2 after review
- Docs maintainer applied it; Randy Dunlap Acked-by
- Buggy line exists in this 6.12.111 tree since v5.9; applies cleanly
- User-facing exception: documentation/comment fixes with zero runtime
  regression
- This same 6.12 tree already took other documentation link-location
  fixes

AGAINST backporting:
- Not a crash, deadlock, corruption, UAF, or security bug
- Official rule 3 (“important issue”) is not met in the runtime sense
- No functional kernel impact (syzbot CI skipped it for that reason)
- No Cc: stable; landed as docs-7.3 stragglers, not a hotfix
- Stable rules also discourage purely trivial edits; this is adjacent to
  that class
- Benefit is only to documentation readers, not production uptime

UNRESOLVED:
- Could not fetch lore.kernel.org or lore stable search via WebFetch
  (403); thread recovered via b4
- Commit SHA is not in this checkout’s `master` (that tip is ~7.2; patch
  went in docs-7.3-2)

Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — v2 URL verified; Acked-by +
   maintainer apply
2. Fixes a real bug that affects users? **PASS** — 404 in
   shipped/generated docs, not a runtime bug
3. Important issue (crash, security, corruption, deadlock)? **FAIL** as
   runtime severity; **LOW** doc defect only
4. Small and contained? **PASS** — 1 line, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — context identical, URL still
   old

Step 9.3: EXCEPTION CATEGORIES
Record: **Documentation fix** (incorrect/obsolete external link). That
exception is why a LOW-severity, zero-runtime patch can still be
appropriate for this tree.

Step 9.4: DECISION
The change does not stabilize running 6.12 systems, but it is a
contained, verified correction of documentation this tree still ships,
with no regression surface and with precedent for similar doc-link
backports here. That matches the documentation exception, not a “new
feature” or refactor.

What it solves for stable users: kernel.org / distro HTML for 6.12
currently points “Further reading” at a 404; after backport it points at
Jens Axboe’s actual blk-mq PDF.

Risk vs benefit: negligible risk, modest doc benefit. No dependencies or
backport rework.

---

## Verification
- [Phase 1] Tags: author SOB, Randy Dunlap Acked-by, Jonathan Corbet
  SOB, Message-ID v2; no Fixes/Reported-by/Cc-stable
- [Phase 2] Diff: single RST URL `http://kernel.dk/blk-mq.pdf` →
  `https://www.kernel.dk/blk-mq.pdf`
- [Phase 2] WebFetch: old URL 404; new URL returns the PDF
- [Phase 3] `git blame` line 142: `46e906144c3f4b` (2020); `git describe
  --contains` → v5.9-rc1
- [Phase 3] `git merge-base --is-ancestor 46e906144c3f4b HEAD` succeeded
- [Phase 3] Author has no other commits in this tree; file history is
  typo/Sphinx-only
- [Phase 4] `b4 mbox`: 12-message v1/v2 thread; Randy caught v1 404/SSL;
  Corbet applied v2
- [Phase 4] LKML pull: included in Documentation stragglers for 7.3
- [Phase 4] Syzbot CI: skipped, no functional impact
- [Phase 4] UNVERIFIED: lore.kernel.org/stable search (HTTP 403)
- [Phase 5] No functions/callers; only docs consumers
- [Phase 6] `git describe HEAD` = p-6.12-3-gc504cf0baa3d8; kernelversion
  6.12.111; dead URL still at blk-mq.rst:142
- [Phase 6] Apply would be clean; no post-v6.12 edits to this file
- [Phase 6] Precedent: `docs: hwmon: fix link to g762...` and `docs:
  media: update location...` already in this 6.12 tree
- [Phase 8] Failure mode: documentation 404, severity LOW; runtime risk
  none

**YES**

 Documentation/block/blk-mq.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/block/blk-mq.rst b/Documentation/block/blk-mq.rst
index fc06761b6ea90..2798761efe0d6 100644
--- a/Documentation/block/blk-mq.rst
+++ b/Documentation/block/blk-mq.rst
@@ -139,7 +139,7 @@ completed.
 Further reading
 ---------------
 
-- `Linux Block IO: Introducing Multi-queue SSD Access on Multi-core Systems <http://kernel.dk/blk-mq.pdf>`_
+- `Linux Block IO: Introducing Multi-queue SSD Access on Multi-core Systems <https://www.kernel.dk/blk-mq.pdf>`_
 
 - `NOOP scheduler <https://en.wikipedia.org/wiki/Noop_scheduler>`_
 
-- 
2.53.0

