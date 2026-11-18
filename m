Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025691;
	b=ET0pewIvzWqZ0xfCJfqOXUKCaAbKv3ad4WOLljXgfr5d1CXPBzUOWj3PkOT2n6YUXz4h
	 6tXVIDHtHuBqvMZ1thwM4ktkz8/lPqcD8GCxP1qdUbckbrH+LyIr4sTmvTnTzjNjVc4jR
	 iUZRXA6YcC2krQi3TK1ewRq+oQYe9l20AnjboNfptIc+/5VzhKSDnCqgzy+klXrVVkyKD
	 f5ifjQY7pStuWtlgPLjnT7A7l+57Kkhh/MCNcvkz/sdJwGqKGdnaj4U63SNc5/nw1GyqF
	 IUSUlFIH5eOQvYjpJvRyqs1yS6So4CKA+EBV+4ZW4WHsUwevjYT3TVX0J0P4F/dKDSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HKF9pJrm7DdQRUPTqwDMA7q7dvfJhUg3IxkeGlg6tsI=;
	b=eWOyOYGFuwsegPj7WVApwYBQfLNj+71og8inJXI6sJrwf4N0DECS0riHPgZ5KjQ/uWEG
	 mks/F8TctO3vrnhtz9IaUyiQ8RvEwXeAlCXYPrxWJToDKmJFch9e4d+7scg2spvGOCTAg
	 pniPSUOhgSJwzG/xzcGuwkQEFHyPQyDIk1/+ogivl6DyPrvIOxaqHJmfEk1MwibuuRNXf
	 Ui0zR4vO4QOjCRpOua6yTZk4fadJceCBXeOfuKp9yBuThVi2cI3T/biVpMzP7i8TtdNRi
	 uLz0Z/dSU3fGv/drYajkFBpFcsjbYK7jcFZBi7SavCwhmy5hgOu+1DiuAeczRiq/M9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNHjFkow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ABE606A335;
	Wed, 18 Nov 2026 18:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNHjFkow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1951F000C4;
	Wed, 18 Nov 2026 18:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025691;
	bh=HKF9pJrm7DdQRUPTqwDMA7q7dvfJhUg3IxkeGlg6tsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNHjFkowEdGT6WputiUbBvno0/hjF/NuFiOuAxsRbK3uRcl8hsuHNVgqNMYRe2sbv
	 PHq9x11LGUIrjq09va1b2wuneGNvn/Nmwy+w+YBN6AqnLUXpDpCK2l6ZF8EXvyMSpy
	 nm6UlgJzjSHrtcmggfSWz3uW9TTDtFG5JJG31v2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1170/2151] selftests/cgroup: add test for zswap incompressible pages
Date: Wed, 18 Nov 2026 15:48:25 +0100
Message-ID: <20261118150204.753875837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 4e89004eebc559595e58d75fd7f7f8ecd5aa600d ]

Add test_zswap_incompressible() to verify that the zswap_incomp memcg stat
correctly tracks incompressible pages.

The test allocates memory filled with random data from /dev/urandom, which
cannot be effectively compressed by zswap.  When this data is swapped out
to zswap, it should be stored as-is and tracked by the zswap_incomp
counter.

The test verifies that:
1. Pages are swapped out to zswap (zswpout increases)
2. Incompressible pages are tracked (zswap_incomp increases)

test:
dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo Y > /sys/module/zswap/parameters/enabled

./test_zswap
 TAP version 13
 1..8
 ok 1 test_zswap_usage
 ok 2 test_swapin_nozswap
 ok 3 test_zswapin
 ok 4 test_zswap_writeback_enabled
 ok 5 test_zswap_writeback_disabled
 ok 6 test_no_kmem_bypass
 ok 7 test_no_invasive_cgroup_shrink
 ok 8 test_zswap_incompressible
 Totals: pass:8 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lkml.kernel.org/r/20260213071827.5688-3-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 0567c7eaefd7 ("selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 136 ++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 86a8930b47e3a..0d4f11384652c 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -5,6 +5,8 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <signal.h>
+#include <errno.h>
+#include <fcntl.h>
 #include <sys/sysinfo.h>
 #include <string.h>
 #include <sys/wait.h>
@@ -574,6 +576,139 @@ static int test_no_kmem_bypass(const char *root)
 	return ret;
 }
 
+struct incomp_child_args {
+	size_t size;
+	int pipefd[2];
+	int madvise_ret;
+	int madvise_errno;
+};
+
+static int allocate_random_and_wait(const char *cgroup, void *arg)
+{
+	struct incomp_child_args *values = arg;
+	size_t size = values->size;
+	char *mem;
+	int fd;
+	ssize_t n;
+
+	close(values->pipefd[0]);
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		return -1;
+
+	/* Fill with random data from /dev/urandom - incompressible */
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd < 0) {
+		munmap(mem, size);
+		return -1;
+	}
+
+	for (size_t i = 0; i < size; ) {
+		n = read(fd, mem + i, size - i);
+		if (n <= 0)
+			break;
+		i += n;
+	}
+	close(fd);
+
+	/* Touch all pages to ensure they're faulted in */
+	for (size_t i = 0; i < size; i += PAGE_SIZE)
+		mem[i] = mem[i];
+
+	/* Use MADV_PAGEOUT to push pages into zswap */
+	values->madvise_ret = madvise(mem, size, MADV_PAGEOUT);
+	values->madvise_errno = errno;
+
+	/* Notify parent that allocation and pageout are done */
+	write(values->pipefd[1], "x", 1);
+	close(values->pipefd[1]);
+
+	/* Keep memory alive for parent to check stats */
+	pause();
+	munmap(mem, size);
+	return 0;
+}
+
+static long get_zswap_incomp(const char *cgroup)
+{
+	return cg_read_key_long(cgroup, "memory.stat", "zswap_incomp ");
+}
+
+/*
+ * Test that incompressible pages (random data) are tracked by zswap_incomp.
+ *
+ * The child process allocates random data within memory.max, then uses
+ * MADV_PAGEOUT to push pages into zswap. The parent waits on a pipe for
+ * the child to finish, then checks the zswap_incomp stat before the child
+ * exits (zswap_incomp is a gauge that decreases on free).
+ */
+static int test_zswap_incompressible(const char *root)
+{
+	int ret = KSFT_FAIL;
+	struct incomp_child_args *values;
+	char *test_group;
+	long zswap_incomp;
+	pid_t child_pid;
+	int child_status;
+	char buf;
+
+	values = mmap(0, sizeof(struct incomp_child_args), PROT_READ |
+			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (values == MAP_FAILED)
+		return KSFT_FAIL;
+
+	if (pipe(values->pipefd)) {
+		munmap(values, sizeof(struct incomp_child_args));
+		return KSFT_FAIL;
+	}
+
+	test_group = cg_name(root, "zswap_incompressible_test");
+	if (!test_group)
+		goto out;
+	if (cg_create(test_group))
+		goto out;
+	if (cg_write(test_group, "memory.max", "32M"))
+		goto out;
+
+	values->size = MB(4);
+	child_pid = cg_run_nowait(test_group, allocate_random_and_wait, values);
+	if (child_pid < 0)
+		goto out;
+
+	close(values->pipefd[1]);
+
+	/* Wait for child to finish allocating and pageout */
+	read(values->pipefd[0], &buf, 1);
+	close(values->pipefd[0]);
+
+	zswap_incomp = get_zswap_incomp(test_group);
+	if (zswap_incomp <= 0) {
+		long zswpout = get_zswpout(test_group);
+		long zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
+		long zswap_b = cg_read_key_long(test_group, "memory.stat", "zswap ");
+
+		ksft_print_msg("zswap_incomp not increased: %ld\n", zswap_incomp);
+		ksft_print_msg("debug: zswpout=%ld zswapped=%ld zswap_b=%ld\n",
+			       zswpout, zswapped, zswap_b);
+		ksft_print_msg("debug: madvise ret=%d errno=%d\n",
+			       values->madvise_ret, values->madvise_errno);
+		goto out_kill;
+	}
+
+	ret = KSFT_PASS;
+
+out_kill:
+	kill(child_pid, SIGTERM);
+	waitpid(child_pid, &child_status, 0);
+out:
+	cg_destroy(test_group);
+	free(test_group);
+	munmap(values, sizeof(struct incomp_child_args));
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct zswap_test {
 	int (*fn)(const char *root);
@@ -586,6 +721,7 @@ struct zswap_test {
 	T(test_zswap_writeback_disabled),
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
+	T(test_zswap_incompressible),
 };
 #undef T
 
-- 
2.53.0



