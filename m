Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBAA42980C;
	Mon, 20 Apr 2026 13:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691776; cv=none; b=HYv8Tr1ZGey2UtjjzITPRgTEfz1MuUiklmtCDWo1X5oWfm6Y3+Eg9ReT/GkbkYKTgqXYabfEV33cSrV/PuwNOxyHAvElcfFSuz9MFFpDwnIurNuYTMAST9rtHY7bu16S/1kRwPGjUZcWJ+XSWnuvjhGoghj4EcXMOVMcEIiaTeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691776; c=relaxed/simple;
	bh=EUQvfoHTyphRGiu49M/mNXYExgyeJft98e5BXxPZICE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qX1D8ah4Hbf76rjl0/1lfqK8SpdjtNZ8Wld/R1XgYNU7/gAHfIaKhIUbSiEcp0tpyXt/WvSNmbyYA/ZR9wSCWUCELlXV6vB6bovx37A1rwanwm3DxjFvSwxlKUyTA2Fu60ksIF/lEgc3JGZB8t1sxRRo9aV6iVhq6k2L7kvlJFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DWX/9d2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DWX/9d2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81835C2BCB9;
	Mon, 20 Apr 2026 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691776;
	bh=EUQvfoHTyphRGiu49M/mNXYExgyeJft98e5BXxPZICE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWX/9d2qKPMOUFhmH2QNMPwtnJi73G/hdV3HWzv7+6EMfyrZnUzEC0k04z/KtAxH1
	 5/kRw8XYnkLH21mzWx1u2qO4kgmp2a4f8r6OrJyyJR/TExHRqfPXzE8D3Jmyov3eH7
	 UzmSGv9nekRUlpjW92oNjNSJs0Tv1WOOpEDb6dqgJjGQk5ltsb5bvTfg5WJFnR0t21
	 mkhUlzQkUYYrOfcTkwYz6wyP8MUoYFNqZfJw9DueFvXBNDJoyq/KqAR53BOkBjKWBG
	 T9J6gR6oTfXGkqe4CR90AAFFLLfU1htPivOzM40yQtFifEeX5zmNH5FqANAbXGF+gi
	 5Vc4ZezVH2RZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] hexagon: uapi: Fix structure alignment attribute
Date: Mon, 20 Apr 2026 09:19:41 -0400
Message-ID: <20260420132314.1023554-187-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 47bca1cbf692b89defbf4db27495813f82d5e3ff ]

__aligned() is a kernel macro, which is not available in UAPI headers.

Use the compiler-provided alignment attribute directly.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Tested-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260227-kbuild-uapi-libc-v1-1-c17de0d19776@weissschuh.net
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [hexagon/uapi] [Fix] Fix structure alignment attribute -
replacing kernel-internal `__aligned()` macro with compiler
`__attribute__((aligned(8)))` in a UAPI header.

**Step 1.2: Tags**
- Signed-off-by: Thomas Weißschuh (author, prolific UAPI header cleaner)
- Acked-by: Arnd Bergmann (ARM/arch maintainer, respected cross-
  subsystem reviewer)
- Reviewed-by: Nathan Chancellor (kbuild/clang maintainer)
- Reviewed-by: Nicolas Schier
- Tested-by: Nicolas Schier
- Link: https://patch.msgid.link/20260227-kbuild-uapi-
  libc-v1-1-c17de0d19776@weissschuh.net
- Signed-off-by: Nicolas Schier (committer)

No Fixes: tag, no Cc: stable, no Reported-by. Strong review lineage
(Arnd Bergmann + Nathan Chancellor).

**Step 1.3: Body Text**
The commit states: `__aligned()` is a kernel macro not available in UAPI
headers. Uses the compiler-provided alignment attribute directly. This
is a build fix - the UAPI header cannot be compiled by userspace
programs.

**Step 1.4: Hidden Bug Fix Detection**
This IS a real bug fix. `__aligned()` is defined only in
`include/linux/compiler_attributes.h` (line 33), which is NOT exported
to userspace. Any userspace program including `<asm/sigcontext.h>` on
hexagon will get a compilation error because `__aligned` is undefined.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `arch/hexagon/include/uapi/asm/sigcontext.h`
- 1 line changed (s/__aligned(8)/__attribute__((aligned(8)))/)
- Single-file, single-line surgical fix

**Step 2.2: Code Flow**
- Before: `} __aligned(8);` — uses kernel-only macro
- After: `} __attribute__((aligned(8)));` — uses compiler-native
  attribute
- Functionally identical within the kernel; fixes compilation for
  userspace

**Step 2.3: Bug Mechanism**
This is a build fix (category h: hardware workarounds/build fixes). The
UAPI header uses a macro that only exists in kernel-internal headers.
The macro `__aligned` is defined in
`include/linux/compiler_attributes.h` as
`__attribute__((__aligned__(x)))`. Since `compiler_attributes.h` is NOT
exported to userspace, this header is broken for userspace compilation.

**Step 2.4: Fix Quality**
- Obviously correct: exact same pattern as the s390 fix (commit
  `bae0aae2f8f97`) from 2019
- Minimal/surgical: single character-level substitution
- Zero regression risk: the replacement is semantically identical
- Reviewed by 3 expert reviewers including Arnd Bergmann and Nathan
  Chancellor

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
The buggy line (`__aligned(8)`) was introduced in commit `cd5b61d6f4f07`
("Hexagon: Add signal functions") by Richard Kuo on 2011-10-31. This was
first included in v3.2-rc1. The bug has existed since the very first
version of this file — over 14 years and ALL stable trees.

**Step 3.2: Fixes Tag**
No Fixes: tag present. The implicit fix target is `cd5b61d6f4f07` from
v3.2.

**Step 3.3: File History**
The file has had only 3 commits since creation (all trivial: copyright
changes, SPDX, UAPI disintegration). No conflicting changes exist.

**Step 3.4: Author**
Thomas Weißschuh is a prolific contributor to UAPI header cleanups. He
authored a major series adding UAPI header build validation (`kbuild:
uapi: validate that headers do not use libc`), and has systematically
fixed many UAPI header issues across multiple architectures.

**Step 3.5: Dependencies**
This is a standalone fix. No prerequisites needed. The file is trivially
simple and unchanged across all stable trees.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.2:** Lore.kernel.org was unreachable (anti-bot protection).
The commit has strong review signals: Acked-by Arnd Bergmann, Reviewed-
by Nathan Chancellor and Nicolas Schier, Tested-by Nicolas Schier.

**Step 4.3:** The Link: message-id suggests this is patch 1 of series
"kbuild-uapi-libc-v1", which is Thomas's UAPI cleanup work. This
specific fix is self-contained.

**Step 4.4-4.5:** Cannot verify stable mailing list discussion due to
lore access restrictions.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4:** The change is to a structure definition in a header
file. `struct sigcontext` is used in signal handling code for the
hexagon architecture. The fix only changes the macro used for the
alignment attribute — it does not change the structure layout,
alignment, or any runtime behavior. This is purely a compile-time fix
for userspace consumers of the header.

**Step 5.5: Similar Patterns**
The exact same bug was fixed for s390 in commit `bae0aae2f8f97` ("s390:
fix unrecognized __aligned() in uapi header", 2019). That fix used the
same approach: replacing `__aligned()` with `__attribute__`. The hexagon
instance is the LAST remaining bare `__aligned()` in any UAPI header
(confirmed by grep).

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The buggy code exists in ALL stable trees (v3.2+, since
2011). Every stable tree that supports hexagon is affected.

**Step 6.2:** The patch will apply cleanly to all stable trees — the
file has been unchanged (except for trivial metadata) since creation.

**Step 6.3:** No related fixes already in stable for this specific file.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** Architecture-specific (hexagon) UAPI header. Hexagon is a
niche architecture (Qualcomm DSP), so this is PERIPHERAL criticality.
However, UAPI header correctness affects anyone building userspace tools
for that architecture.

**Step 7.2:** Very low activity — file unchanged since 2017 (SPDX
addition).

## PHASE 8: IMPACT AND RISK

**Step 8.1:** Affects: hexagon userspace developers who include
`<asm/sigcontext.h>`.

**Step 8.2:** Triggered whenever a userspace program includes this
header on hexagon. Always reproducible.

**Step 8.3:** Failure mode: compilation error. Severity: MEDIUM (build
breakage, not runtime).

**Step 8.4:**
- BENEFIT: Low-medium (niche architecture, but fixes a real build
  breakage)
- RISK: Extremely low (1-line change, semantically identical, well-
  reviewed, proven pattern from s390 fix)
- Ratio: Favorable — virtually zero risk for a real fix

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real UAPI header compilation breakage
- One-line, trivially correct change
- Proven fix pattern (identical to s390 fix from 2019)
- Reviewed by 3 experts (Arnd Bergmann, Nathan Chancellor, Nicolas
  Schier)
- Tested by Nicolas Schier
- Bug exists in all stable trees since v3.2
- Will apply cleanly with zero conflicts
- Falls into "build fix" exception category

**Evidence AGAINST backporting:**
- Hexagon is a niche architecture with limited userbase
- No Fixes: tag or Cc: stable (expected, not a negative signal)
- Not a runtime bug — only affects userspace compilation

**Stable Rules Checklist:**
1. Obviously correct and tested? **YES** — reviewed by 3 experts,
   tested, identical to proven s390 fix
2. Fixes a real bug? **YES** — UAPI header is broken for userspace
   compilation
3. Important issue? **MEDIUM** — build fix (compilation error)
4. Small and contained? **YES** — 1 line changed in 1 file
5. No new features or APIs? **YES** — no new features
6. Can apply to stable? **YES** — clean apply guaranteed (file unchanged
   since 2017)

**Exception Category:** Build fix — these are explicitly called out as
stable-worthy.

## Verification

- [Phase 1] Parsed tags: Acked-by Arnd Bergmann, Reviewed-by Nathan
  Chancellor + Nicolas Schier, Tested-by Nicolas Schier
- [Phase 2] Diff analysis: 1 line changed, `__aligned(8)` ->
  `__attribute__((aligned(8)))` in UAPI header
- [Phase 3] git blame: buggy code introduced in `cd5b61d6f4f07`
  (v3.2-rc1, 2011), present in all stable trees
- [Phase 3] git log: file has only 3 commits total (all trivial
  metadata), no conflicts possible
- [Phase 3] Author: Thomas Weißschuh is a prolific UAPI header
  maintainer with 20+ related commits
- [Phase 4] b4 dig: commit not yet in tree (candidate), lore blocked by
  anti-bot protection
- [Phase 5] grep: confirmed this is the ONLY remaining bare
  `__aligned()` in all UAPI headers
- [Phase 5] Verified `__aligned` defined only in
  `include/linux/compiler_attributes.h` (line 33), not exported to
  userspace
- [Phase 6] File unchanged since 2017, will apply cleanly to all stable
  trees
- [Phase 6] Precedent: identical s390 fix (commit `bae0aae2f8f97`) was
  applied in v5.3 for the same bug pattern
- [Phase 8] Failure mode: userspace compilation error; severity MEDIUM;
  risk extremely low

**YES**

 arch/hexagon/include/uapi/asm/sigcontext.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/include/uapi/asm/sigcontext.h b/arch/hexagon/include/uapi/asm/sigcontext.h
index 7171edb1b8b71..179a97041b593 100644
--- a/arch/hexagon/include/uapi/asm/sigcontext.h
+++ b/arch/hexagon/include/uapi/asm/sigcontext.h
@@ -29,6 +29,6 @@
  */
 struct sigcontext {
 	struct user_regs_struct sc_regs;
-} __aligned(8);
+} __attribute__((aligned(8)));
 
 #endif
-- 
2.53.0

