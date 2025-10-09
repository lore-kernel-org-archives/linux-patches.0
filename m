Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99A12F3601;
	Thu,  9 Oct 2025 15:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025567; cv=none; b=cCnbb/pY2rvNcmBxZLgqyYc1TbBgJ9Hh0LXsIgw6xCK/uo3ePNsVUE9qRJB1eQ+YLJk7msLPB1W5HpfX76GMlm0o26o+cReO6j9edPgx6LttMZCul4RJTMKK+lthnL104lfm3vgGiCRZiDxG+uUxC+5YZibFey/y1n3pGfPMM/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025567; c=relaxed/simple;
	bh=3YpwRTuzmT94Iue3ShsfIYd3qkqteimIuLQhSwcdQ0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LlfHB/ejf/wveekjGZ84r3wr2nS/A1dS88kaO6aj4gbTfHrCozDDq1vF8ED8c5iiqcKZlT9d0RzSdUpNVdhUo+DlijINfcTRGNBLyBB/11Sns2wg95k/ifPVguOHeXL71MQPpUm1paGRiDOywOfb0rbtxY7x9n5XldBtoKzo6Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=roW6l21S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="roW6l21S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823E4C4CEE7;
	Thu,  9 Oct 2025 15:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025567;
	bh=3YpwRTuzmT94Iue3ShsfIYd3qkqteimIuLQhSwcdQ0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roW6l21SlOgpJxxzPBzlsrF5sGvdGGN5teSD/IgEdhWmpcyVgC0q7en9dae2cS21c
	 9YXAbZOB5bzKE6OjHyFcHuZFvebv3lqA0Q8rzmaXvz/6HdHAi5+Pt+lhjR35+2MvDz
	 blxvH+oN9mJVqfvIcaGj3p0e5FM5WfWjyz6KLR0C60ZgretrOjpD5+gMKwdhgXHKt1
	 A3jzkDJudQcf2UhMpGTxyXlTA8wRyeCikswEZuBpJcXDLBa3ZZkbDuGqKUUSd3crrB
	 WBtrSV2DQxVqeriSp5T5K1mWm16l14E2pgM7R26mp6wtkqR4G9vYHzChdVcvAFy26p
	 WeDhc5X/A2WyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	will@kernel.org,
	mark.rutland@arm.com,
	anshuman.khandual@arm.com,
	reddybalavignesh9979@gmail.com
Subject: [PATCH AUTOSEL 6.17] kselftest/arm64: tpidr2: Switch to waitpid() over wait4()
Date: Thu,  9 Oct 2025 11:55:16 -0400
Message-ID: <20251009155752.773732-50-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 61a3cf7934b6da3c926cd9961860dd94eb7192ba ]

wait4() is deprecated, non-standard and about to be removed from nolibc.

Switch to the equivalent waitpid() call.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20250821-nolibc-enosys-v1-6-4b63f2caaa89@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis of the commit and related changes,
here is my determination:

## Backport Status: YES (conditional)

### Analysis

**Commit Summary:**
This commit replaces `wait4()` with `waitpid()` in the ARM64 TPIDR2
selftest. The change is part of a coordinated nolibc cleanup series that
removes deprecated syscall wrappers.

**Code Changes Analysis:**
The commit makes a functionally equivalent substitution:
- **Before**: `wait4(ret, &status, __WCLONE, NULL)`
- **After**: `waitpid(ret, &status, __WCLONE)`

Since the `rusage` parameter to `wait4()` was NULL, this is semantically
identical to `waitpid()`. The man page explicitly states wait4() is
"nonstandard" and "deprecated," recommending waitpid() for new programs.

**Why This Should Be Backported:**

1. **Build Dependency**: This commit (61a3cf7934b6d) is patch 6/7 of the
   nolibc-enosys series, immediately followed by patch 7/7
   (4c2ef951cfe68) which removes wait4() from nolibc. Both commits are
   already backported to this 6.17 tree, indicating stable maintainers
   have decided to keep nolibc synchronized.

2. **Infrastructure Maintenance**: Without this change, the tpidr2 test
   will fail to compile once wait4() is removed from nolibc, breaking
   the ARM64 selftest suite.

3. **Low Risk**: The change is trivial, well-reviewed (Mark Brown,
   Catalin Marinas), and functionally equivalent. Only test code is
   affected, not kernel runtime code.

4. **No Regression Risk**: waitpid() with these arguments behaves
   identically to wait4() with NULL rusage parameter.

**Stable Tree Criteria:**
- ✓ Small and contained (5 lines changed)
- ✓ No side effects or architectural changes
- ✓ Minimal regression risk
- ✗ Not a traditional bug fix (no user-facing bug)
- ✗ No explicit Cc: stable tag
- ✓ Required for test infrastructure when nolibc is updated

**Conclusion:**
This is a **conditional YES** - it MUST be backported if and only if the
corresponding nolibc wait4() removal (commit 4c2ef951cfe68) is also
backported. The two commits form an inseparable pair for maintaining
build compatibility. Since both are already present in this 6.17 stable
tree, the backporting decision was correct for maintaining test
infrastructure alongside nolibc updates.

 tools/testing/selftests/arm64/abi/tpidr2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/arm64/abi/tpidr2.c b/tools/testing/selftests/arm64/abi/tpidr2.c
index f58a9f89b952c..3b520b7efa49e 100644
--- a/tools/testing/selftests/arm64/abi/tpidr2.c
+++ b/tools/testing/selftests/arm64/abi/tpidr2.c
@@ -182,16 +182,16 @@ static int write_clone_read(void)
 	}
 
 	for (;;) {
-		waiting = wait4(ret, &status, __WCLONE, NULL);
+		waiting = waitpid(ret, &status, __WCLONE);
 
 		if (waiting < 0) {
 			if (errno == EINTR)
 				continue;
-			ksft_print_msg("wait4() failed: %d\n", errno);
+			ksft_print_msg("waitpid() failed: %d\n", errno);
 			return 0;
 		}
 		if (waiting != ret) {
-			ksft_print_msg("wait4() returned wrong PID %d\n",
+			ksft_print_msg("waitpid() returned wrong PID %d\n",
 				       waiting);
 			return 0;
 		}
-- 
2.51.0

