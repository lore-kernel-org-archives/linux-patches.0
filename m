Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8791E36C9CD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302247; cv=none; b=pISyUnvX2eGILez5y0WeR6OV8pmX2UegCjZP9ie5Sr4S+L3kq6vWaetFcK4w4M8y1x3eu51S8lDSNJHYoGMCC2POX1fOgO1x8HW3saxCj2tdkZ2oYjPL9GCHkhlfFHMqO717UN+rJQuMU9YWPGuUvBcuNw+2UgezZvCvtLAhv68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302247; c=relaxed/simple;
	bh=m8FsHa8KUUsNYSv8WaD0s3G8QHnzZrbui/62K3Dglt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqHpIvJGfa+tHQpfSGOoe2Ml9Fhs9lBftdGWhF7+kZ+y3CSlc6OQV7DRix8VwCeWkkAlg9bYNlD/00tZZiQ2lXa3BbxjfN252vf2rNbGb6+Y289ioUJ06xQcVmKEAk3OEZbLgXfbIi/Vi/De35JF6j7h/AxQAdvyjASWjdtEFJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hs8bVbS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hs8bVbS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802CFC116D0;
	Sat, 28 Feb 2026 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302247;
	bh=m8FsHa8KUUsNYSv8WaD0s3G8QHnzZrbui/62K3Dglt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hs8bVbS15PUNNt0U5DbTno3eG9N3h+lqsXzN9hHZhKky0JvPgsVRP0Y60WMs8ONNL
	 f4CI7zmLfDewbAvjc2FC8iJWmAgI5FlbKV8kHf7CKEUhqgJnBALuSzwu3NJniw4Q7D
	 ieA5/8H7DEOPJBMS+4NZf62d3vegvuqxPxPVroVcXaiQlwB+Q4EEolS3XYvxxtpSB7
	 Xz6iOa1E0xf2FYME+VpKeiSXl/zj0sjx4/GnVoRA0BKOYe3FB0nqNeyqAvRwOPPjo/
	 KQC6Gk2h+vCM/JzPZJY7fzyNhma+IPdAKtZKz8BNurlXtPhFR8f3Xm7ksCbuLT0FCg
	 6o/mnxxkL7eLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Greg Thelen <gthelen@google.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Daniel Verkamp <dverkamp@chromium.org>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/283] selftests/memfd: delete unused declarations
Date: Sat, 28 Feb 2026 13:06:42 -0500
Message-ID: <20260228180709.1583486-260-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Thelen <gthelen@google.com>

[ Upstream commit a9117b4d7f178ea36e8d256f8ab3752839e245b2 ]

Commit 32d118ad50a5 ("selftests/memfd: add tests for F_SEAL_EXEC"):
- added several unused 'nbytes' local variables

Commit 6469b66e3f5a ("selftests: improve vm.memfd_noexec sysctl tests"):
- orphaned 'newpid_thread_fn2()' forward declaration
- orphaned 'join_newpid_thread()' forward declaration
- added unused 'pid' local in sysctl_simple_child()
- orphaned 'fd' local in sysctl_simple_child()
- added unused 'fd' in sysctl_nested_child()

Delete the unused locals and forward declarations.

Link: https://lkml.kernel.org/r/20240118095057.677544-1-gthelen@google.com
Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b24335521de9 ("selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/memfd/memfd_test.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 9c9c82fd18a7e..da88dbe37dda9 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -45,8 +45,6 @@
  */
 static size_t mfd_def_size = MFD_DEF_SIZE;
 static const char *memfd_str = MEMFD_STR;
-static int newpid_thread_fn2(void *arg);
-static void join_newpid_thread(pid_t pid);
 
 static ssize_t fd2name(int fd, char *buf, size_t bufsize)
 {
@@ -195,7 +193,6 @@ static unsigned int mfd_assert_get_seals(int fd)
 static void mfd_assert_has_seals(int fd, unsigned int seals)
 {
 	char buf[PATH_MAX];
-	int nbytes;
 	unsigned int s;
 	fd2name(fd, buf, PATH_MAX);
 
@@ -715,7 +712,6 @@ static void mfd_assert_mode(int fd, int mode)
 {
 	struct stat st;
 	char buf[PATH_MAX];
-	int nbytes;
 
 	fd2name(fd, buf, PATH_MAX);
 
@@ -734,7 +730,6 @@ static void mfd_assert_mode(int fd, int mode)
 static void mfd_assert_chmod(int fd, int mode)
 {
 	char buf[PATH_MAX];
-	int nbytes;
 
 	fd2name(fd, buf, PATH_MAX);
 
@@ -750,7 +745,6 @@ static void mfd_fail_chmod(int fd, int mode)
 {
 	struct stat st;
 	char buf[PATH_MAX];
-	int nbytes;
 
 	fd2name(fd, buf, PATH_MAX);
 
@@ -1297,9 +1291,6 @@ static void test_sysctl_set_sysctl2(void)
 
 static int sysctl_simple_child(void *arg)
 {
-	int fd;
-	int pid;
-
 	printf("%s sysctl 0\n", memfd_str);
 	test_sysctl_set_sysctl0();
 
@@ -1364,7 +1355,6 @@ static void test_sysctl_sysctl2_failset(void)
 
 static int sysctl_nested_child(void *arg)
 {
-	int fd;
 	int pid;
 
 	printf("%s nested sysctl 0\n", memfd_str);
-- 
2.51.0

