Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DFF31DD82;
	Mon,  3 Nov 2025 18:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762193008; cv=none; b=pLgRkpMa+6IJPabLNdBEJndrduA363IVighpBSaRNshudSWuCOkEB3IuaqDxMrl9oKrJhRTMTjXbk4hvyS7ZS5W6zMuMD8dJFc/LAVThqS82YrfWkiQy4pZBoSfvj0R5pHCeSttx7WSkrFsqEEued1bvMns8nqdTIlxoKSW9B/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762193008; c=relaxed/simple;
	bh=YOjQBkrOvTLYl9O3qPNqMbiCs0u056QzurwCIfKrTaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=defltxglzNvUPv+7ZITqB94jWwi7tfj+O7TtqKxKwqdmtxia9BIiK/f3wDkSxGf8akc8N9MXjb/yFeBDlAS8xI+ChmaMNOuq1uekVhX3uifhmUgT8s3pDqeNl+c4afqdASY6vs8PPBCR6MGjOO0rA8H9PXJTHTOHkk5vk4N/r0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F736mNZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F736mNZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55759C4CEE7;
	Mon,  3 Nov 2025 18:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762193008;
	bh=YOjQBkrOvTLYl9O3qPNqMbiCs0u056QzurwCIfKrTaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F736mNZ4enqmL1CdoNBgCseU/Rb6cT+mn8V/+4DdA2zn6krYSoi32FImyJgsY5Mmq
	 eS2xkqfvGanND5uHf/4K0l6HgNDFKrt4Sbq9QDK/9qsyASgGQw2/8EueQUJO3CX4Ct
	 O17hWlY4l5npThOxsCldovbc/heH0Hyk4cI+99epdadY7F9qiIfbjZaO8G20UxmoUm
	 q17JewytWt5tlGPBlWk7Lb1m6NwqICEprcRCI+iX8K4JL9jIyTysjFiYpTfDK+3x0H
	 7Ot70mZ4DBIZUgtcZs7HmW79Rv5vJw8SwQSHsr/WCaOnt7/j7tk9LvenVG+2pGDdtu
	 kznpX5MOOcY3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sidharth Seela <sidharthseela@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	wang lian <lianux.mm@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	hannes@cmpxchg.org,
	nathan@kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17] selftests: cachestat: Fix warning on declaration under label
Date: Mon,  3 Nov 2025 13:02:33 -0500
Message-ID: <20251103180246.4097432-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103180246.4097432-1-sashal@kernel.org>
References: <20251103180246.4097432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sidharth Seela <sidharthseela@gmail.com>

[ Upstream commit 920aa3a7705a061cb3004572d8b7932b54463dbf ]

Fix warning caused from declaration under a case label. The proper way
is to declare variable at the beginning of the function. The warning
came from running clang using LLVM=1; and is as follows:

-test_cachestat.c:260:3: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
  260 |                 char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
      |

Link: https://lore.kernel.org/r/20250929115405.25695-2-sidharthseela@gmail.com
Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let me compile my comprehensive analysis based on all the data
gathered:

## Analysis Summary

**ANSWER: YES**

This commit should be backported to stable kernel trees (specifically
6.17.y and any newer stable branches that contain the buggy code).

### Detailed Analysis

#### 1. **Code Context and Bug Identification**

Using semantic code analysis tools and git history examination, I
identified:

- **Function analyzed**: `run_cachestat_test()` in
  tools/testing/selftests/cachestat/test_cachestat.c (lines 222-295)
- **Bug introduced**: Commit d6a511dea45ce (July 2025) - "selftests:
  cachestat: add tests for mmap"
- **Affected versions**: v6.17 and later (confirmed via `git tag
  --contains d6a511dea45ce`)
- **Bug confirmed in v6.17.7**: Using `git show
  v6.17.7:tools/testing/selftests/cachestat/test_cachestat.c`, I
  verified the problematic code exists:
  ```c
  case FILE_MMAP:
  char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,  //
  VIOLATION: declaration after label
  ```

#### 2. **Semantic Analysis Used**

- **mcp__semcode__find_function**: Located `run_cachestat_test()`
  function and confirmed the bug exists at line 260
- **mcp__semcode__find_callers**: Identified that this is a test
  function called from main
- **Git history analysis**: Traced bug introduction and verified no
  prior fix exists

#### 3. **Nature of the Fix**

The fix is **minimal and safe**:
- **Changed**: Variable `char *map` declaration moved from line 260
  (under case label) to line 229 (with other variable declarations)
- **Lines modified**: Only 2 lines changed (declaration location)
- **Risk level**: Zero - pure code style fix with no behavioral changes
- **Compiler warning**: `-Wc23-extensions` when building with clang
  LLVM=1

#### 4. **Backporting Precedent**

I found strong precedent for backporting selftest build fixes:
- **Commit 90c1ffd1347f3** (bc4d5f5d2debf upstream): "selftests:
  cachestat: Fix build warnings on ppc64"
  - Similar warning fix for the same test file
  - **WAS backported to stable** (shows "Signed-off-by: Sasha Levin"
    indicating automated stable backport)
  - Establishes that cachestat selftest build fixes ARE appropriate for
    stable trees

#### 5. **Impact Assessment**

- **Scope**: Affects only userspace selftest code, not kernel runtime
- **User Impact**: Developers building selftests with clang will get
  warnings without this fix
- **Build Impact**: Does NOT break builds (warning, not error), but
  reduces noise and follows best practices
- **Testing Impact**: Enables cleaner CI/CD pipelines that treat
  warnings as errors

#### 6. **Stable Tree Compliance**

✅ **Fixes a real issue**: Violates C language standards (pre-C23)
✅ **Small and contained**: 2-line change, single file
✅ **No architectural changes**: Pure variable declaration movement
✅ **No new features**: Maintains existing functionality
✅ **Well-reviewed**: Multiple Reviewed-by, Acked-by tags from
maintainers
✅ **Precedent exists**: Similar fixes were backported before

#### 7. **Commit Quality**

The commit has proper maintainer approval:
- Signed-off-by: Shuah Khan (selftest maintainer)
- Reviewed-by: SeongJae Park
- Reviewed-by: wang lian
- Reviewed-by: Dev Jain
- Acked-by: Shuah Khan
- Acked-by: Nhat Pham

### Conclusion

This is a **low-risk, high-value** backport candidate that:
1. Fixes legitimate C standards compliance issue
2. Improves developer experience when building with clang
3. Has precedent for similar backports in the same file
4. Contains zero functional changes
5. Has strong maintainer approval

The commit follows all stable kernel rules and should be backported to
6.17.y and any other stable trees containing the buggy code introduced
in d6a511dea45ce.

 tools/testing/selftests/cachestat/test_cachestat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
index c952640f163b5..ab838bcb9ec55 100644
--- a/tools/testing/selftests/cachestat/test_cachestat.c
+++ b/tools/testing/selftests/cachestat/test_cachestat.c
@@ -226,7 +226,7 @@ bool run_cachestat_test(enum file_type type)
 	int syscall_ret;
 	size_t compute_len = PS * 512;
 	struct cachestat_range cs_range = { PS, compute_len };
-	char *filename = "tmpshmcstat";
+	char *filename = "tmpshmcstat", *map;
 	struct cachestat cs;
 	bool ret = true;
 	int fd;
@@ -257,7 +257,7 @@ bool run_cachestat_test(enum file_type type)
 		}
 		break;
 	case FILE_MMAP:
-		char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
+		map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
 				 MAP_SHARED, fd, 0);
 
 		if (map == MAP_FAILED) {
-- 
2.51.0

