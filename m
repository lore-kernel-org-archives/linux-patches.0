Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7731E2312;
	Mon,  4 Aug 2025 00:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267854; cv=none; b=FQQAbAQxsoQIkflFdQ551+Mjr2qiJjN7OhhazQjehXoAZaCQxyA86OUdvM4lZzukFByPUTEGdzeZ6F6h+XTCT7DUW15ZgSdujk24KMfe260mGGmL1EvIoA0Y6QyX+jMMp2dj5Em2CUdmVWhgHBObBX3mLu+Ymp9a6a4jjzL2ta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267854; c=relaxed/simple;
	bh=W+PRbtbPnTzXG7tuyl6D0vdO7SIw853bgOwQRTxjMYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ly/BBpp4rMJ3kFQ0T9sg4/C5N0FNnshj4MZHqm+Hfr0iOBk2N0Uuuy2krcpCG3xOOEope/HCrIt0WzI334eAO5V68FH/xK4gyjXU00T80QQFQ6d+RbMeosAtTpuj6gsWY0KTfCrKNIhcwfRJue8wEu+ENFnAFEc5JEY4tN4FmS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbd1H9p2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbd1H9p2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C271C4CEF0;
	Mon,  4 Aug 2025 00:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267854;
	bh=W+PRbtbPnTzXG7tuyl6D0vdO7SIw853bgOwQRTxjMYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbd1H9p2+T1cc5ahBaD8hUflMkzTHb43RFq+sJsDGV0TLJqVeI6Axhs4uQJkaA8tp
	 avFBfAFtVSBfowHgrK1X4AXmNtpMjdLXfje3VQEKDvXZp4nPBuU5gJ2JBChYL3uvuZ
	 JZ5V125sbL3DefN20hFaBQItRdmD7SwzEk0g5YUDmZu12ZuPvbysI591yGzwjfpVeW
	 h8DjHUIsZms73kIgAea+jht/UuNSb0llzQNO9fmaFYBiZWFG8ADKe8YFlJQHEJixB4
	 uBOmw+pn8xIkSVrLyLcMeQFgLP7FuyXJFKR5PoZTFAxNwlNb9QezQegoWdRLCyjJCg
	 OgBp5mwwv/mDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 22/51] selftests: tracing: Use mutex_unlock for testing glob filter
Date: Sun,  3 Aug 2025 20:36:14 -0400
Message-Id: <20250804003643.3625204-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003643.3625204-1-sashal@kernel.org>
References: <20250804003643.3625204-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.147
Content-Transfer-Encoding: 8bit

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit a089bb2822a49b0c5777a8936f82c1f8629231fb ]

Since commit c5b6ababd21a ("locking/mutex: implement
mutex_trylock_nested") makes mutex_trylock() as an inlined
function if CONFIG_DEBUG_LOCK_ALLOC=y, we can not use
mutex_trylock() for testing the glob filter of ftrace.

Use mutex_unlock instead.

Link: https://lore.kernel.org/r/175151680309.2149615.9795104805153538717.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Status: YES

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a test regression**: The commit c5b6ababd21a changed
   mutex_trylock() from being a regular function to an inline macro when
   CONFIG_DEBUG_LOCK_ALLOC=y. This broke the ftrace glob filter selftest
   that was trying to match functions with the pattern `mutex*try*`.
   Since mutex_trylock is no longer a regular function symbol in certain
   configurations, the test would fail.

2. **Simple and contained fix**: The change is minimal - it simply
   replaces the test pattern from `mutex*try*` to `mutex*unl*` on line
   32. This is a one-line change that:
   - Changes the glob pattern from matching mutex_trylock functions to
     mutex_unlock functions
   - Maintains the same test logic and purpose (testing glob pattern
     matching)
   - mutex_unlock remains a regular function symbol regardless of
     CONFIG_DEBUG_LOCK_ALLOC

3. **No functional changes to kernel code**: This only affects a
   selftest, not any kernel functionality. The risk of regression is
   zero for normal kernel operation.

4. **Test reliability**: Without this fix, the ftrace selftest suite
   would fail on kernels built with CONFIG_DEBUG_LOCK_ALLOC=y after
   commit c5b6ababd21a is applied. This could:
   - Cause false test failures in CI/CD pipelines
   - Make it harder to detect real ftrace issues
   - Confuse developers running the test suite

5. **Clear dependency**: The commit message explicitly states this is
   needed "Since commit c5b6ababd21a" which indicates this is a direct
   fix for a known regression introduced by that specific commit.

The change is exactly the type that stable rules recommend: it fixes a
clear bug (test regression), is minimal in scope, has no risk of
breaking functionality, and maintains test coverage for an important
kernel feature (ftrace glob filtering).

 .../testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
index 4b994b6df5ac..ed81eaf2afd6 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
@@ -29,7 +29,7 @@ ftrace_filter_check 'schedule*' '^schedule.*$'
 ftrace_filter_check '*pin*lock' '.*pin.*lock$'
 
 # filter by start*mid*
-ftrace_filter_check 'mutex*try*' '^mutex.*try.*'
+ftrace_filter_check 'mutex*unl*' '^mutex.*unl.*'
 
 # Advanced full-glob matching feature is recently supported.
 # Skip the tests if we are sure the kernel does not support it.
-- 
2.39.5

