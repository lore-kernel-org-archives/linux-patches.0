Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D474319ABD8;
	Tue, 10 Feb 2026 23:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766302; cv=none; b=bFC8hua7ESXkWgo4yZmE2p8My8WoWq5iNojwq72U5UaXt2l2zmQtMSbNnrmhWk4dazknP3bKGXCK4e3gQI6ZLbyOG8hlwE2orjDY4YMwDoAPBd40sJrbbnqGDAd+kceR4DXXZFbOJQrwG4eoCks70knT4PPHn8QIkMuMltp+O5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766302; c=relaxed/simple;
	bh=VtBXHm1FH+7ZRNbbiM5oMLqEPCFCwBIb93WPsRDBeCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYyxTKe+2qsqVJy41Kw7L3sHpkgY+V1uV0gbswy9/2HZGcsf9GqcZrki9YIFmeXybR3T/V//AQVi6tsIWjpttYAC31NyQVXUZMGoXraDw0yi7EMLrBGP7XuOpPsQfguAMv6SjxtsjB2/fRXhlvzQd0X1iepX+R97Ruzz5gzq0P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4hE3TH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4hE3TH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B236DC19423;
	Tue, 10 Feb 2026 23:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766302;
	bh=VtBXHm1FH+7ZRNbbiM5oMLqEPCFCwBIb93WPsRDBeCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4hE3TH85VY+Qy9yTBAcl62yuXk8XLDd5+NVxbVe9ovqozVC/B0Hkwl+eDMt2602V
	 I6gHFeVUhGe8EFPpEm8QwvBT1EoDsWlT7W9758l8a8Ioa52YaXIu55reRi0Shb+SG5
	 Ry66YmMNPaHm6Kaaa2zSe7SBkjMcWXeUcBl7lKdxWyQzkuGz/rmBvFhbHqIiItecTg
	 D8uTKcX0tb5id+8/kE3+ZbvMZ293r/+gsEpkEx9qFODoeSdK5CLC3AurCb68o9e51F
	 qSt0d8d3KpPKGYOnHk56lxb1FYzUb7LvKtwMrDpUQnmGH4Jxkl7h4/sbCBtMFSc7II
	 pJ7inOLAyF51g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Clint George <clintbgeorge@gmail.com>,
	Ming Lei <ming.lei@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	nathan@kernel.org,
	linux-block@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-6.18] kselftest/kublk: include message in _Static_assert for C11 compatibility
Date: Tue, 10 Feb 2026 18:30:56 -0500
Message-ID: <20260210233123.2905307-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260210233123.2905307-1-sashal@kernel.org>
References: <20260210233123.2905307-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Clint George <clintbgeorge@gmail.com>

[ Upstream commit 3e6ad272bb8b3199bad952e7b077102af2d8df03 ]

Add descriptive message in the _Static_assert to comply with the C11
standard requirement to prevent compiler from throwing out error. The
compiler throws an error when _Static_assert is used without a message as
that is a C23 extension.

[] Testing:
The diff between before and after of running the kselftest test of the
module shows no regression on system with x86 architecture

[] Error log:
~/Desktop/kernel-dev/linux-v1/tools/testing/selftests/ublk$ make LLVM=1 W=1
  CC       kublk
In file included from kublk.c:6:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
In file included from null.c:3:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
In file included from file_backed.c:3:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
In file included from common.c:3:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
In file included from stripe.c:3:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
In file included from fault_inject.c:11:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
make: *** [../lib.mk:225: ~/Desktop/kernel-dev/linux-v1/tools/testing/selftests/ublk/kublk] Error 1

Link: https://lore.kernel.org/r/20251215085022.7642-1-clintbgeorge@gmail.com
Signed-off-by: Clint George <clintbgeorge@gmail.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit fixes a C11/C23 compatibility issue in
`tools/testing/selftests/ublk/kublk.h`. The `_Static_assert()` macro is
used without a message string, which is only valid in C23. When
compiling with Clang/LLVM, this triggers the `-Wc23-extensions` warning,
which is promoted to a hard error by `-Werror`.

The commit message includes the full error log showing compilation
failure across 6 source files that include `kublk.h`. The fix is
reviewed by Ming Lei (ublk maintainer) and signed off by Shuah Khan
(kselftest maintainer).

### 2. Code Change Analysis

The change is a single-line modification:

```diff
- _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
+       _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7,
"UBLK_MAX_QUEUES_SHIFT must be <= 7");
```

This is the most trivial kind of fix possible - adding a string literal
parameter to comply with C11 standard syntax. The runtime behavior is
completely unchanged since `_Static_assert` is a compile-time construct
that generates zero code.

### 3. Impact Assessment

**The build failure is worse than the error log suggests.** The ublk
selftest Makefile includes `-Werror` **by default** (`ifneq
($(WERROR),0)` means it's always on unless explicitly disabled). This
means **any user building the ublk selftest with Clang/LLVM will hit a
hard build error** - they don't need `W=1` to trigger it; that just adds
additional warning flags.

### 4. Affected Stable Trees

The buggy `_Static_assert` line was introduced by commit `bf098d72696db`
("selftests: ublk: kublk: plumb q_id in io_uring user_data") which first
appeared in the 6.16 cycle. The unfixed line exists in:
- **6.16.y** (line 252)
- **6.17.y** (line 223)
- **6.18.y** (line 223)
- **6.19.y** (line 226)

It does NOT exist in 6.15.y or earlier (6.12.y LTS, 6.6.y LTS, etc.).

### 5. Stable Criteria Evaluation

| Criterion | Assessment |
|-----------|-----------|
| Obviously correct and tested | YES - trivially obvious, tested by
author |
| Fixes a real bug | YES - hard compilation error |
| Important issue | YES - **build fix** (explicitly listed exception
category) |
| Small and contained | YES - one line, one file |
| No new features | YES - purely a build fix |
| Can apply cleanly | Likely YES with minor context adjustment per tree
|

### 6. Risk Assessment

**Risk: Essentially zero.** `_Static_assert` is a compile-time
construct. Adding a message string parameter cannot change runtime
behavior. The assertion condition itself is unchanged. This is the
safest possible type of change.

### 7. Dependency Check

No dependencies. The fix is entirely self-contained - it only modifies
the syntax of an existing assertion. No new includes, no new functions,
no changed behavior.

### 8. Classification

This is a **build fix** for a kselftest. Build fixes are explicitly
listed as an allowed exception category for stable ("These are critical
for users who need to build the kernel"). While this specifically
affects selftest infrastructure rather than the kernel itself, selftests
are integral to verifying stable kernel correctness, and CI systems
(KernelCI, 0-day) regularly run these tests on stable trees.

The fix prevents a **hard build failure** with the Clang/LLVM toolchain
(widely used, especially in Android and ChromeOS kernel development).
The `-Werror` flag is enabled by default in the ublk selftest Makefile,
making this a default-configuration failure, not an edge case.

### Conclusion

This is a trivial, zero-risk build fix that prevents a default-
configuration compilation error in the ublk kselftest when using
Clang/LLVM. It meets all stable kernel criteria: obviously correct,
fixes a real build failure, is tiny and self-contained, and introduces
no new features. The only limitation is that it only applies to stable
trees 6.16.y and later where the buggy `_Static_assert` line exists.

**YES**

 tools/testing/selftests/ublk/kublk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ublk/kublk.h b/tools/testing/selftests/ublk/kublk.h
index 8a83b90ec603a..cae2e30f0cdd5 100644
--- a/tools/testing/selftests/ublk/kublk.h
+++ b/tools/testing/selftests/ublk/kublk.h
@@ -223,7 +223,7 @@ static inline __u64 build_user_data(unsigned tag, unsigned op,
 		unsigned tgt_data, unsigned q_id, unsigned is_target_io)
 {
 	/* we only have 7 bits to encode q_id */
-	_Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
+	_Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7, "UBLK_MAX_QUEUES_SHIFT must be <= 7");
 	assert(!(tag >> 16) && !(op >> 8) && !(tgt_data >> 16) && !(q_id >> 7));
 
 	return tag | (op << 16) | (tgt_data << 24) |
-- 
2.51.0

