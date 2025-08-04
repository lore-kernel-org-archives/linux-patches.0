Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEA835957;
	Mon,  4 Aug 2025 00:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267578; cv=none; b=JLqvbEUdxOopjeCzyDgYQGr4vlEpIrLxCfo/wbvq9mgg9t7OibGrwC0IKfKY+9aXa5DWwJObB+RpeRKkkTTVH6MZf8IEjPjlcdX+2Nted9FTynG7U38pIA4i0afuKT9v8kGIgJmn7ud4A4UJhpvTjZcpoAIzkuVREAHEs6M++/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267578; c=relaxed/simple;
	bh=nc0GlFSDATH8sVj1eJgpNU/mOdF2nC52mzR120WkNPI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u/S32Sso7dnO/r8GNKrcqmAXoIeSl3F+Y8MvrMhJyOb52pVer7pLS46PczXMgRDa2rFQDYb6PEdODZP2fCGpDzsaYE7OJsAtA79sXxJVzF1Q8OGMsbU0Vp9kMxbEDZj2491M5plqlad8fahPe496k95UySjzgHFnkZPhL2Y1b6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcaSDJGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcaSDJGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF799C4CEEB;
	Mon,  4 Aug 2025 00:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267578;
	bh=nc0GlFSDATH8sVj1eJgpNU/mOdF2nC52mzR120WkNPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcaSDJGCj05z/6NBlzln3hV2rqzcgsAQUpXsRrwR2/mkzKgH9W+yETXjPAzoGrehH
	 qALMEZszzLUyrzZFJlijRD8m7SdbTOK44MUx6g2DOZ+1bwJT3Y8ShER3R14BkAXNwS
	 9yuhSkvklXe+kaxO67ok/JMJ37+0uHFwqXUn3c+iIJB1o9dCrbKCMnwwXWd2MhoVoF
	 n6du79WuF5gpeWEk/RQoLxFnaM13jW39aLNBffc4dzuOs6R/Yd2y/0ltlxxTJ6mN5V
	 j2vD9tBDVdOzyEvYKc/rPKsVdwAK4NV+fuBg5H+mKCykdUKdo7p3EsBH/Vpx6YcibM
	 432qeThddFT+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	luto@kernel.org,
	vincenzo.frascino@arm.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 41/69] selftests: vDSO: vdso_test_getrandom: Always print TAP header
Date: Sun,  3 Aug 2025 20:30:51 -0400
Message-Id: <20250804003119.3620476-41-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 1158220b24674edaf885433153deb4f0e5c7d331 ]

The TAP specification requires that the output begins with a header line.
If vgetrandom_init() fails and skips the test, that header line is missing.

Call vgetrandom_init() after ksft_print_header().

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/all/20250611-selftests-vdso-fixes-v3-8-e62e37a6bcf5@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of the Commit

### 1. Bug Description
The commit fixes a test output formatting bug in the vDSO getrandom
selftest. Looking at the code changes in
`tools/testing/selftests/vDSO/vdso_test_getrandom.c`:

**Before the fix (lines 239-245 and 296-298 in the original file):**
```c
static void kselftest(void)
{
    // ... variables ...
    ksft_print_header();
    ksft_set_plan(2);
    // ... test code ...
}

int main(int argc, char *argv[])
{
    vgetrandom_init();  // This was called BEFORE ksft_print_header()

    if (argc == 1) {
        kselftest();
        return 0;
    }
    // ...
}
```

**After the fix:**
```c
static void kselftest(void)
{
    // ... variables ...
    ksft_print_header();
    vgetrandom_init();  // Moved AFTER ksft_print_header()
    ksft_set_plan(2);
    // ... test code ...
}

int main(int argc, char *argv[])
{
    if (argc == 1) {
        kselftest();
        return 0;
    }

    // ...
    vgetrandom_init();  // Called here for non-test modes
    // ...
}
```

### 2. Why This is a Bug

The TAP (Test Anything Protocol) specification requires that test output
begins with a version header line (`TAP version 13`). The
`ksft_print_header()` function prints this required header.

Looking at `vgetrandom_init()` (lines 113-131), it contains multiple
`ksft_exit_skip()` calls that can terminate the test early:
- Line 121: If `AT_SYSINFO_EHDR` is not present
- Line 125: If the vDSO symbol is missing
- Line 128: If the CPU doesn't have runtime support

When `vgetrandom_init()` was called before `ksft_print_header()`, these
skip conditions would exit the test without printing the TAP header,
violating the TAP specification and potentially breaking test harnesses
that parse the output.

### 3. Stable Backport Criteria Assessment

✓ **Fixes a bug that affects users**: Yes, this fixes incorrect test
output that can break automated test systems and CI/CD pipelines that
parse TAP output.

✓ **Relatively small and contained**: Yes, the fix is minimal - it just
reorders two function calls to ensure proper TAP header output.

✓ **No major side effects**: The change only affects test output
ordering, not functionality. The test logic remains identical.

✓ **No architectural changes**: This is a simple reordering of existing
calls with no structural changes.

✓ **Minimal risk**: The change is confined to the selftest code and
cannot affect kernel runtime behavior.

✓ **Important for testing infrastructure**: Correct TAP output is
crucial for test automation systems used in continuous integration and
validation of stable kernels.

### 4. Additional Considerations

- The commit message clearly describes the problem and solution
- The fix follows established kselftest patterns (header before any
  potential exits)
- This is a test-only change with zero impact on production kernel code
- The bug could cause false test results in automated systems that
  expect valid TAP output

This is an ideal candidate for stable backporting as it fixes a real bug
in test infrastructure with minimal risk and clear benefits for kernel
testing and validation.

 tools/testing/selftests/vDSO/vdso_test_getrandom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vDSO/vdso_test_getrandom.c b/tools/testing/selftests/vDSO/vdso_test_getrandom.c
index 95057f7567db..ff8d5675da2b 100644
--- a/tools/testing/selftests/vDSO/vdso_test_getrandom.c
+++ b/tools/testing/selftests/vDSO/vdso_test_getrandom.c
@@ -242,6 +242,7 @@ static void kselftest(void)
 	pid_t child;
 
 	ksft_print_header();
+	vgetrandom_init();
 	ksft_set_plan(2);
 
 	for (size_t i = 0; i < 1000; ++i) {
@@ -295,8 +296,6 @@ static void usage(const char *argv0)
 
 int main(int argc, char *argv[])
 {
-	vgetrandom_init();
-
 	if (argc == 1) {
 		kselftest();
 		return 0;
@@ -306,6 +305,9 @@ int main(int argc, char *argv[])
 		usage(argv[0]);
 		return 1;
 	}
+
+	vgetrandom_init();
+
 	if (!strcmp(argv[1], "bench-single"))
 		bench_single();
 	else if (!strcmp(argv[1], "bench-multi"))
-- 
2.39.5

