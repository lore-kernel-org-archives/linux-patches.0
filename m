Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054338;
	b=gMhXyJ9gXR0HTmAj0uZRXQs9NaxPTEgmybTPye51TyVbN+jT7Z5upOF6Jf1ks5ggQo6d
	 weQsHXsnrA++M6cYUUPzTpRWE4rXhp8arjLmZa7xCGRepyOquXuMk1x+bmDIGIr9cYDIU
	 E8M/ts6M23bdg3I3mAaE2GtEYJm9SSM2U72sGEUv9CMufuuB6sfOdWqkAnwis8M/+WIa/
	 5Zb/qw9xKIpK7GMahiYyYj8JYYa4Jdb3Q1MbZ6qhhKURiyaf826RgDbnLcmwCSXgwyNrm
	 nKwPbV/ixNw6I0eX9eeFLJ8pPwQ6zSCxaMyMaM/QNJaOqEva2qW1CR5fLpXJJf89E1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Y1VN2u6YdaU90uVlnaCPCVt0L3cC6qvKBDJaP+5Jxg=;
	b=oUTp7LjMzvLKrWNwo8moefgKPWo60zzChybIK3d1HM7Soj76/KeqjJ+inJovckvYzY9g
	 vfSQhLdfSt0qovhiD/OOnim5xwiYnDmwSVu85pPQrTp6/+/cmwzsaCiyssw10PQgDINbH
	 r3IQPF/n4QwfqrfCOpWHhgq60Xp/mNnkjfmaS4GbJUl9LqZR3EtmY13iOPwITIQaTOJo7
	 KmjF4+9vSicPLmW3pwaYl5kaucL3d8sLDfLTchHWu3hSyEPJ8PUrx6weIWshzSFCq8dM4
	 aWb/1H6TcdmJWZ+sZvk6Sd9efjN4dHO6pc9A2uS9J2x004lOi8zc2VuPrhrK/75WnWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1k39ayul;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4956F606A320;
	Thu, 19 Nov 2026 02:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1k39ayul
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ECA1F000C4;
	Thu, 19 Nov 2026 02:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054338;
	bh=4Y1VN2u6YdaU90uVlnaCPCVt0L3cC6qvKBDJaP+5Jxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1k39ayulBRdVfb41Jr6v5UhpK1KkmNAp6eRFax0Nu9+fKT3l+nSn3kYv6ehSS4X7q
	 Rrq8RLmAzdND+AIRdRxP4FB5pbEo9jWfZwAAExiJkEetiInDUGVGTrd9nt1imPdEmX
	 7BsEZGTpgl8q4IALhAq+2DCYS9YEffifKSOWiIlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1238/2214] selftests:core: test coverage for dup_fd() failure handling in unshare_fd()
Date: Wed, 18 Nov 2026 15:48:34 +0100
Message-ID: <20261118150101.256792454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 611fbeb44a777e5ab54ab3127ec85f72147911d8 ]

At some point there'd been a dumb braino during the dup_fd()
calling conventions change; caught by smatch and immediately fixed.
The trouble is, there had been no test coverage for the dup_fd() failure
handling - neither in kselftests nor in LTP.  Fortunately, it can be
triggered on stock kernel - ENOMEM would require fault injection, but
EMFILE can be had with sysctl alone (fs.nr_open).

Add a test for dup_fd() failure.
Fixed up commit log and short log - Shuah Khan

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: df0b7e0ea59c ("selftests/core: fix unshare_test with large fs.nr_open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/core/Makefile       |  2 +-
 tools/testing/selftests/core/unshare_test.c | 94 +++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/core/unshare_test.c

diff --git a/tools/testing/selftests/core/Makefile b/tools/testing/selftests/core/Makefile
index f6f2d6f473c6a..8cc2b79dfa4c8 100644
--- a/tools/testing/selftests/core/Makefile
+++ b/tools/testing/selftests/core/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -g -I../../../../usr/include/
 
-TEST_GEN_PROGS := close_range_test
+TEST_GEN_PROGS := close_range_test unshare_test
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/core/unshare_test.c b/tools/testing/selftests/core/unshare_test.c
new file mode 100644
index 0000000000000..7fec9dfb1b0e3
--- /dev/null
+++ b/tools/testing/selftests/core/unshare_test.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/kernel.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <sys/resource.h>
+#include <linux/close_range.h>
+
+#include "../kselftest_harness.h"
+#include "../clone3/clone3_selftests.h"
+
+TEST(unshare_EMFILE)
+{
+	pid_t pid;
+	int status;
+	struct __clone_args args = {
+		.flags = CLONE_FILES,
+		.exit_signal = SIGCHLD,
+	};
+	int fd;
+	ssize_t n, n2;
+	static char buf[512], buf2[512];
+	struct rlimit rlimit;
+	int nr_open;
+
+	fd = open("/proc/sys/fs/nr_open", O_RDWR);
+	ASSERT_GE(fd, 0);
+
+	n = read(fd, buf, sizeof(buf));
+	ASSERT_GT(n, 0);
+	ASSERT_EQ(buf[n - 1], '\n');
+
+	ASSERT_EQ(sscanf(buf, "%d", &nr_open), 1);
+
+	ASSERT_EQ(0, getrlimit(RLIMIT_NOFILE, &rlimit));
+
+	/* bump fs.nr_open */
+	n2 = sprintf(buf2, "%d\n", nr_open + 1024);
+	lseek(fd, 0, SEEK_SET);
+	write(fd, buf2, n2);
+
+	/* bump ulimit -n */
+	rlimit.rlim_cur = nr_open + 1024;
+	rlimit.rlim_max = nr_open + 1024;
+	EXPECT_EQ(0, setrlimit(RLIMIT_NOFILE, &rlimit)) {
+		lseek(fd, 0, SEEK_SET);
+		write(fd, buf, n);
+		exit(EXIT_FAILURE);
+	}
+
+	/* get a descriptor past the old fs.nr_open */
+	EXPECT_GE(dup2(2, nr_open + 64), 0) {
+		lseek(fd, 0, SEEK_SET);
+		write(fd, buf, n);
+		exit(EXIT_FAILURE);
+	}
+
+	/* get descriptor table shared */
+	pid = sys_clone3(&args, sizeof(args));
+	EXPECT_GE(pid, 0) {
+		lseek(fd, 0, SEEK_SET);
+		write(fd, buf, n);
+		exit(EXIT_FAILURE);
+	}
+
+	if (pid == 0) {
+		int err;
+
+		/* restore fs.nr_open */
+		lseek(fd, 0, SEEK_SET);
+		write(fd, buf, n);
+		/* ... and now unshare(CLONE_FILES) must fail with EMFILE */
+		err = unshare(CLONE_FILES);
+		EXPECT_EQ(err, -1)
+			exit(EXIT_FAILURE);
+		EXPECT_EQ(errno, EMFILE)
+			exit(EXIT_FAILURE);
+		exit(EXIT_SUCCESS);
+	}
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+TEST_HARNESS_MAIN
-- 
2.53.0



