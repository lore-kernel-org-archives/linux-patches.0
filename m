Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394AD3F1673;
	Tue, 24 Mar 2026 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351191; cv=none; b=ORLM8EP4ZvhBP5A9i1GTmWP/ljNbuKNzHnSaY0ZehV4JIndRQ+NZuI30sXqhvbtCplBUGJMygk0wg9um6mRDY+ZxFk71AvySebDDmlKRYOc0uCZEd8LItQB+WTudqoZqYNoSXfwZbubmzGwGQQImpBRfI9OjrwR30pqY0iBc7PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351191; c=relaxed/simple;
	bh=TYIvXi33vtcU8lj78uAqidjQegpZ4kOuUi8+f+Vp8JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGJOjrmiIbw/MGFGmKIUGKEhsjVAdiMi9wplXT9HyzQzH/Gosi87E57IyO5wR4eJKBuGLwo7VGoP7mL3PNPtD7QetCm4+aknDI315Yci6iAJAPXahuioCZ/qi1oUEAPrzr0613YuOEJYflkQNhbqfZQAdjpNaEky0NvKJgJYsis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cuE8AJLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cuE8AJLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E36C2BCB1;
	Tue, 24 Mar 2026 11:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351190;
	bh=TYIvXi33vtcU8lj78uAqidjQegpZ4kOuUi8+f+Vp8JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuE8AJLZZk1Z1eFakS6UVoo/M7uAKgFt3odt31XvGiaYwGPlIiLbu2Td/lc9J060s
	 o7D+2nsaC0BH8uJHwG3xPeTXt5SjS6LDY1eeilVUQxgU+vmTNDFDkc5iMeWicJjpiN
	 Yz29qdXBXjMA9uk7c94ciqt/0appLEHhReqmqw8yMqHGxopE5GH0Iqv4JgS+kO3IZ+
	 ooaBmeZYGW03ZaD0XkTu0h5ZqXqU34mOj02CSslLJWsr1FTEsq+DwiDkAjmDa9LOTH
	 DS0FiahvM1zdAgrOrnZsp5kkaSR9WEu34Swubrf2cB3XnhMVn6o4b9WuysxqFDQpSQ
	 hg1MHa7Q4Oi3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peterz@infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] objtool/klp: fix mkstemp() failure with long paths
Date: Tue, 24 Mar 2026 07:19:22 -0400
Message-ID: <20260324111931.3257972-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Transfer-Encoding: 8bit

From: Joe Lawrence <joe.lawrence@redhat.com>

[ Upstream commit 28e367a969b0c54c87ca655ec180715fe469fd14 ]

The elf_create_file() function fails with EINVAL when the build directory
path is long enough to truncate the "XXXXXX" suffix in the 256-byte
tmp_name buffer.

Simplify the code to remove the unnecessary dirname()/basename() split
and concatenation.  Instead, allocate the exact number of bytes needed for
the path.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Link: https://patch.msgid.link/20260310203751.1479229-3-joe.lawrence@redhat.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
**CRITICAL FINDING**: The `elf_create_file()` function was introduced in
commit `03c19a99ee69f` which first appeared in **v6.19-rc1**. It does
NOT exist in v6.12, v6.13, v6.14, or v6.15.

The only stable tree that could contain this code is **6.19.y** (the
current stable tree from which this kernel is tagged as 6.19.9).

Record: The buggy code only exists in v6.19+. It does NOT exist in any
older stable trees (6.12.y, 6.6.y, 6.1.y, 5.15.y, etc.).

### Step 6.2: BACKPORT COMPLICATIONS
For 6.19.y: The patch should apply cleanly since the code is new and
there are no intervening changes to this specific function.
Record: Clean apply expected for 6.19.y. Not applicable to any older
stable tree.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
- **Subsystem**: tools/objtool - a build-time tool, not runtime kernel
  code
- **Criticality**: PERIPHERAL - only affects users building kernels with
  livepatch (CONFIG_LIVEPATCH) using the new `objtool klp-diff` feature
- This is a userspace build tool, not kernel code that runs at runtime
Record: [tools/objtool] [PERIPHERAL - build tool for livepatch users
only]

### Step 7.2: SUBSYSTEM ACTIVITY
The objtool subsystem is actively developed with many recent commits
related to klp/livepatch support.
Record: Active development, new feature area.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
- Only users of `objtool klp-diff` with build paths longer than ~248
  characters
- This is a brand new feature in v6.19, so the user base is small
- Primarily affects enterprise livepatch build systems (Red Hat, SUSE,
  etc.) with deep directory hierarchies
Record: Very narrow audience - livepatch builders with long paths on
6.19+.

### Step 8.2: TRIGGER CONDITIONS
- Requires: building livepatch modules with objtool klp-diff AND having
  a build path > ~248 chars
- Long paths are common in CI/build systems (Jenkins, corporate build
  farms)
- Trigger is deterministic (not a race) - if your path is long enough,
  it always fails
Record: Deterministic failure in specific path-length conditions. Common
in enterprise CI.

### Step 8.3: FAILURE MODE SEVERITY
- **Failure mode**: Build failure - mkstemp returns EINVAL, objtool
  exits with error
- **Severity**: MEDIUM - prevents building livepatch modules, but no
  kernel crash or data corruption
- This is a build-time failure, not a runtime kernel issue
Record: Build failure only. Severity: MEDIUM (prevents livepatch module
creation).

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit**: Fixes a real build failure for livepatch users with long
  paths. Deterministic bug.
- **Risk**: Very low. The fix simplifies code (removes complexity), is
  obviously correct, and only affects a build tool.
- **Ratio**: Favorable - low risk fix for a real bug, but limited
  audience.
Record: Low risk, moderate benefit for the narrow audience affected.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**Evidence FOR backporting:**
- Fixes a real, deterministic bug (mkstemp EINVAL with long paths)
- Obviously correct fix (exact allocation vs fixed 256-byte buffer)
- Small and contained (single function, net code reduction)
- Acked by livepatch maintainer, committed by objtool maintainer
- Merged via objtool/urgent branch
- Also fixes memory leaks in the old code (strdup results not freed)

**Evidence AGAINST backporting:**
- The buggy code (`elf_create_file()`) only exists in v6.19+ - it was
  introduced in v6.19-rc1
- Very narrow audience (livepatch builders with long paths)
- Build tool fix, not runtime kernel code
- Part of a 12-patch series (though this patch is self-contained)
- No Cc: stable tag
- The entire klp-diff feature is brand new in v6.19

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** - simple, obviously correct
   allocation fix
2. Fixes a real bug? **YES** - build failure with long paths
3. Important issue? **MODERATE** - build failure, not
   crash/security/corruption
4. Small and contained? **YES** - single function, net code reduction
5. No new features? **YES** - pure bug fix
6. Can apply to stable? **Only to 6.19.y** - code doesn't exist in older
   trees

### Step 9.3: EXCEPTION CATEGORIES
No exception category applies - this is a straightforward bug fix.

### Step 9.4: DECISION

This is a legitimate bug fix that is obviously correct and low risk. It
fixes a real build failure in objtool's klp-diff feature for users with
long build directory paths. The fix is small, surgical, and simplifies
the code.

However, the critical factor is that the buggy code was only introduced
in v6.19-rc1. It only applies to the 6.19.y stable tree. For that
specific tree, this is a reasonable backport - it's a build fix for a
new feature, it's low risk, and it prevents a deterministic failure.

For the 6.19.y stable tree specifically, this meets the criteria. The
fix is small, obviously correct, and prevents a real build failure.

## Verification

- [Phase 1] Parsed tags: Acked-by Song Liu (livepatch maintainer),
  Signed-off-by Josh Poimboeuf (objtool maintainer), Link to
  patch.msgid.link
- [Phase 2] Diff analysis: Removes ~16 lines of dirname/basename/fixed-
  buffer code, adds ~4 lines with exact-size allocation. Net
  simplification.
- [Phase 3] git blame: All buggy lines from commit 03c19a99ee69f
  (2025-09-17), first in v6.19-rc1
- [Phase 3] git merge-base: Confirmed 03c19a99ee69f NOT in v6.12, v6.13,
  v6.14, v6.15 - only in v6.19+
- [Phase 4] lore.kernel.org: Found patch is v4 02/12 in series, merged
  via objtool/urgent branch. No explicit stable nomination found.
- [Phase 5] grep elf_create_file: Single caller in klp-diff.c:1732 with
  user-provided path argument
- [Phase 6] Code only exists in v6.19.y stable tree; not applicable to
  older stable trees
- [Phase 7] tools/objtool is a build-time tool, PERIPHERAL criticality
- [Phase 8] Failure mode: deterministic build failure (EINVAL from
  mkstemp), severity MEDIUM

**YES**

 tools/objtool/elf.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 3da90686350d7..2ffe3ebfbe37c 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -16,7 +16,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <errno.h>
-#include <libgen.h>
 #include <ctype.h>
 #include <linux/align.h>
 #include <linux/kernel.h>
@@ -1189,7 +1188,7 @@ struct elf *elf_open_read(const char *name, int flags)
 struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 {
 	struct section *null, *symtab, *strtab, *shstrtab;
-	char *dir, *base, *tmp_name;
+	char *tmp_name;
 	struct symbol *sym;
 	struct elf *elf;
 
@@ -1203,29 +1202,13 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 
 	INIT_LIST_HEAD(&elf->sections);
 
-	dir = strdup(name);
-	if (!dir) {
-		ERROR_GLIBC("strdup");
-		return NULL;
-	}
-
-	dir = dirname(dir);
-
-	base = strdup(name);
-	if (!base) {
-		ERROR_GLIBC("strdup");
-		return NULL;
-	}
-
-	base = basename(base);
-
-	tmp_name = malloc(256);
+	tmp_name = malloc(strlen(name) + 8);
 	if (!tmp_name) {
 		ERROR_GLIBC("malloc");
 		return NULL;
 	}
 
-	snprintf(tmp_name, 256, "%s/%s.XXXXXX", dir, base);
+	sprintf(tmp_name, "%s.XXXXXX", name);
 
 	elf->fd = mkstemp(tmp_name);
 	if (elf->fd == -1) {
-- 
2.51.0

