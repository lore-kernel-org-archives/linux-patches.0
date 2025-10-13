Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE4E28D83E;
	Mon, 13 Oct 2025 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369235; cv=none; b=aaFo6htfKU6NgSX49qT+DgHk0GRQaEY+TzG2t9Z+VkqWnrDi+a7zgtHbOdhoJ3cMqvXyOKGKuNTwbZfHautZm64QqYYs4GdUp9NrhYmUXtJqn42JvB0lYCT9tFmjnDwI7PLilHDKrn6GAYnfYhmoVSdRNU9s4Q4lJXEOBgNXY1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369235; c=relaxed/simple;
	bh=OiUM+tk5Jfd3BChCxDjczN8PHMIoIIBuwU/SnJJTJhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qhN3la3zEhPE3iDHBy1BDokFj7e7uh1qUYPWqkJuAHP6vhaVQbTMGiqToOwXsBcN5Nhvsk927VhQb8bGoNQLYUoVA16a6+8CZDjg3CxZ4F272hyLXpDOcER9UnXGUSELSaMlmo/VMIIF/i8hyXdGybSyj3y5Kv4X7pcSpMWeGXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0V4+9bW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0V4+9bW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014B6C4CEFE;
	Mon, 13 Oct 2025 15:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369235;
	bh=OiUM+tk5Jfd3BChCxDjczN8PHMIoIIBuwU/SnJJTJhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0V4+9bWdAkF0u/ngo5aRCFvAgKVVBrsxrk5vFa2V6Kcy+Ykw659Ad1wClKM3zckK
	 dAASZk09eQUHaxJjdJ5QuEPN48mhb5dJRHgcdb42ydyQPe2UQhD4SOgyPT5zr6qNXh
	 WGm8c0K/1sbNiNwv+zR2qFi4A2mF3kY861xIeCaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 176/563] selftest/futex: Make the error check more precise for futex_numa_mpol
Date: Mon, 13 Oct 2025 16:40:37 +0200
Message-ID: <20251013144417.662589499@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Almeida <andrealmeid@igalia.com>

[ Upstream commit c1c863457780adfb2e29fa9a85897179ad3903e6 ]

Instead of just checking if the syscall failed as expected, check as
well if the returned error code matches the expected error code.

[ bigeasy: reword the commmit message ]

Signed-off-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Stable-dep-of: ed323aeda5e0 ("selftest/futex: Compile also with libnuma < 2.0.16")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../futex/functional/futex_numa_mpol.c        | 36 +++++++++++--------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/futex_numa_mpol.c b/tools/testing/selftests/futex/functional/futex_numa_mpol.c
index 802c15c821906..dd7b05e8cda45 100644
--- a/tools/testing/selftests/futex/functional/futex_numa_mpol.c
+++ b/tools/testing/selftests/futex/functional/futex_numa_mpol.c
@@ -77,7 +77,7 @@ static void join_max_threads(void)
 	}
 }
 
-static void __test_futex(void *futex_ptr, int must_fail, unsigned int futex_flags)
+static void __test_futex(void *futex_ptr, int err_value, unsigned int futex_flags)
 {
 	int to_wake, ret, i, need_exit = 0;
 
@@ -88,11 +88,17 @@ static void __test_futex(void *futex_ptr, int must_fail, unsigned int futex_flag
 
 	do {
 		ret = futex2_wake(futex_ptr, to_wake, futex_flags);
-		if (must_fail) {
-			if (ret < 0)
-				break;
-			ksft_exit_fail_msg("futex2_wake(%d, 0x%x) should fail, but didn't\n",
-					   to_wake, futex_flags);
+
+		if (err_value) {
+			if (ret >= 0)
+				ksft_exit_fail_msg("futex2_wake(%d, 0x%x) should fail, but didn't\n",
+						   to_wake, futex_flags);
+
+			if (errno != err_value)
+				ksft_exit_fail_msg("futex2_wake(%d, 0x%x) expected error was %d, but returned %d (%s)\n",
+						   to_wake, futex_flags, err_value, errno, strerror(errno));
+
+			break;
 		}
 		if (ret < 0) {
 			ksft_exit_fail_msg("Failed futex2_wake(%d, 0x%x): %m\n",
@@ -106,12 +112,12 @@ static void __test_futex(void *futex_ptr, int must_fail, unsigned int futex_flag
 	join_max_threads();
 
 	for (i = 0; i < MAX_THREADS; i++) {
-		if (must_fail && thread_args[i].result != -1) {
+		if (err_value && thread_args[i].result != -1) {
 			ksft_print_msg("Thread %d should fail but succeeded (%d)\n",
 				       i, thread_args[i].result);
 			need_exit = 1;
 		}
-		if (!must_fail && thread_args[i].result != 0) {
+		if (!err_value && thread_args[i].result != 0) {
 			ksft_print_msg("Thread %d failed (%d)\n", i, thread_args[i].result);
 			need_exit = 1;
 		}
@@ -120,14 +126,14 @@ static void __test_futex(void *futex_ptr, int must_fail, unsigned int futex_flag
 		ksft_exit_fail_msg("Aborting due to earlier errors.\n");
 }
 
-static void test_futex(void *futex_ptr, int must_fail)
+static void test_futex(void *futex_ptr, int err_value)
 {
-	__test_futex(futex_ptr, must_fail, FUTEX2_SIZE_U32 | FUTEX_PRIVATE_FLAG | FUTEX2_NUMA);
+	__test_futex(futex_ptr, err_value, FUTEX2_SIZE_U32 | FUTEX_PRIVATE_FLAG | FUTEX2_NUMA);
 }
 
-static void test_futex_mpol(void *futex_ptr, int must_fail)
+static void test_futex_mpol(void *futex_ptr, int err_value)
 {
-	__test_futex(futex_ptr, must_fail, FUTEX2_SIZE_U32 | FUTEX_PRIVATE_FLAG | FUTEX2_NUMA | FUTEX2_MPOL);
+	__test_futex(futex_ptr, err_value, FUTEX2_SIZE_U32 | FUTEX_PRIVATE_FLAG | FUTEX2_NUMA | FUTEX2_MPOL);
 }
 
 static void usage(char *prog)
@@ -184,16 +190,16 @@ int main(int argc, char *argv[])
 
 	/* FUTEX2_NUMA futex must be 8-byte aligned */
 	ksft_print_msg("Mis-aligned futex\n");
-	test_futex(futex_ptr + mem_size - 4, 1);
+	test_futex(futex_ptr + mem_size - 4, EINVAL);
 
 	futex_numa->numa = FUTEX_NO_NODE;
 	mprotect(futex_ptr, mem_size, PROT_READ);
 	ksft_print_msg("Memory, RO\n");
-	test_futex(futex_ptr, 1);
+	test_futex(futex_ptr, EFAULT);
 
 	mprotect(futex_ptr, mem_size, PROT_NONE);
 	ksft_print_msg("Memory, no access\n");
-	test_futex(futex_ptr, 1);
+	test_futex(futex_ptr, EFAULT);
 
 	mprotect(futex_ptr, mem_size, PROT_READ | PROT_WRITE);
 	ksft_print_msg("Memory back to RW\n");
-- 
2.51.0



