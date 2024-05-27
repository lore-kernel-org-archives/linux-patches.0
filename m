Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC96117E90E;
	Mon, 27 May 2024 19:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837091; cv=none; b=RKMCBpjt+Xbsgq4Q1yoN9Af/wtVd52eft0rlYROunJtURzDSJc++P/yzxKVjk6S/CW8qIt841EPuXq+/GuDO/HVoYfWv0uPtRoTz2xIJVRq09d+qUOVU0d8e40fQmlXKvNsnMQuOi2mqX9VudBpcJ4kHhKvNurInPvJ6zGoaJLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837091; c=relaxed/simple;
	bh=zFT6lpRI0FFIwl4UfvmGcY0LWseXZ2lprbjtQJIqF44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLn5xQFdJ2jEQKDvHvgx+9KmohYj5lGNpY8GZvWtfZAlBCzxjZJQXcfvhtKr+iM6Evq7uBKf9QWBLNGbz1y9HvzjguoZg28TcNPNJ3ypbvdYtMl5YKjjkxyixrshb3bhZBBGn0XgBoY8ZclkpO2gNAl+8f5owYRlVqQu08vW1FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2pSppcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2pSppcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA0FC2BBFC;
	Mon, 27 May 2024 19:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837091;
	bh=zFT6lpRI0FFIwl4UfvmGcY0LWseXZ2lprbjtQJIqF44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2pSppcQzZw4NpxBWQ13f80Ma+W4DcMu3HJ8diScp+qlJWuDAXH+fmNmrMcNI47VP
	 IydOgAksvsDRRVol2bVCr5i4nzd5qzRwmIXaL6vbuyvZjU+AFtdzRD7kgvO95Jhezs
	 cJj+NnpdiYTWWCB9nZ7YCCc11AkBEdSrWlsjB2m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 306/427] selftests: cgroup: skip test_cgcore_lesser_ns_open when cgroup2 mounted without nsdelegate
Date: Mon, 27 May 2024 20:55:53 +0200
Message-ID: <20240527185630.602169049@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit 4793cb599b1bdc3d356f0374c2c99ffe890ae876 ]

The test case test_cgcore_lesser_ns_open only tasks effect when cgroup2
is mounted with "nsdelegate" mount option. If it misses this option, or
is remounted without "nsdelegate", the test case will fail. For example,
running bpf/test_cgroup_storage first, and then run cgroup/test_core will
fail on test_cgcore_lesser_ns_open. Skip it if "nsdelegate" is not
detected in cgroup2 mount options.

Fixes: bf35a7879f1d ("selftests: cgroup: Test open-time cgroup namespace usage for migration checks")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c        | 8 +++++---
 tools/testing/selftests/cgroup/cgroup_util.h        | 2 +-
 tools/testing/selftests/cgroup/test_core.c          | 7 ++++++-
 tools/testing/selftests/cgroup/test_cpu.c           | 2 +-
 tools/testing/selftests/cgroup/test_cpuset.c        | 2 +-
 tools/testing/selftests/cgroup/test_freezer.c       | 2 +-
 tools/testing/selftests/cgroup/test_hugetlb_memcg.c | 2 +-
 tools/testing/selftests/cgroup/test_kill.c          | 2 +-
 tools/testing/selftests/cgroup/test_kmem.c          | 2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c    | 2 +-
 tools/testing/selftests/cgroup/test_zswap.c         | 2 +-
 11 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 0340d4ca8f51c..432db923bced0 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -195,10 +195,10 @@ int cg_write_numeric(const char *cgroup, const char *control, long value)
 	return cg_write(cgroup, control, buf);
 }
 
-int cg_find_unified_root(char *root, size_t len)
+int cg_find_unified_root(char *root, size_t len, bool *nsdelegate)
 {
 	char buf[10 * PAGE_SIZE];
-	char *fs, *mount, *type;
+	char *fs, *mount, *type, *options;
 	const char delim[] = "\n\t ";
 
 	if (read_text("/proc/self/mounts", buf, sizeof(buf)) <= 0)
@@ -211,12 +211,14 @@ int cg_find_unified_root(char *root, size_t len)
 	for (fs = strtok(buf, delim); fs; fs = strtok(NULL, delim)) {
 		mount = strtok(NULL, delim);
 		type = strtok(NULL, delim);
-		strtok(NULL, delim);
+		options = strtok(NULL, delim);
 		strtok(NULL, delim);
 		strtok(NULL, delim);
 
 		if (strcmp(type, "cgroup2") == 0) {
 			strncpy(root, mount, len);
+			if (nsdelegate)
+				*nsdelegate = !!strstr(options, "nsdelegate");
 			return 0;
 		}
 	}
diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing/selftests/cgroup/cgroup_util.h
index 1df7f202214af..89e8519fb2719 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/cgroup_util.h
@@ -21,7 +21,7 @@ static inline int values_close(long a, long b, int err)
 	return abs(a - b) <= (a + b) / 100 * err;
 }
 
-extern int cg_find_unified_root(char *root, size_t len);
+extern int cg_find_unified_root(char *root, size_t len, bool *nsdelegate);
 extern char *cg_name(const char *root, const char *name);
 extern char *cg_name_indexed(const char *root, const char *name, int index);
 extern char *cg_control(const char *cgroup, const char *control);
diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 80aa6b2373b96..a5672a91d273c 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -18,6 +18,8 @@
 #include "../kselftest.h"
 #include "cgroup_util.h"
 
+static bool nsdelegate;
+
 static int touch_anon(char *buf, size_t size)
 {
 	int fd;
@@ -775,6 +777,9 @@ static int test_cgcore_lesser_ns_open(const char *root)
 	pid_t pid;
 	int status;
 
+	if (!nsdelegate)
+		return KSFT_SKIP;
+
 	cg_test_a = cg_name(root, "cg_test_a");
 	cg_test_b = cg_name(root, "cg_test_b");
 
@@ -862,7 +867,7 @@ int main(int argc, char *argv[])
 	char root[PATH_MAX];
 	int i, ret = EXIT_SUCCESS;
 
-	if (cg_find_unified_root(root, sizeof(root)))
+	if (cg_find_unified_root(root, sizeof(root), &nsdelegate))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
 	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 24020a2c68dcd..186bf96f6a284 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -700,7 +700,7 @@ int main(int argc, char *argv[])
 	char root[PATH_MAX];
 	int i, ret = EXIT_SUCCESS;
 
-	if (cg_find_unified_root(root, sizeof(root)))
+	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
 	if (cg_read_strstr(root, "cgroup.subtree_control", "cpu"))
diff --git a/tools/testing/selftests/cgroup/test_cpuset.c b/tools/testing/selftests/cgroup/test_cpuset.c
index b061ed1e05b4d..4034d14ba69ac 100644
--- a/tools/testing/selftests/cgroup/test_cpuset.c
+++ b/tools/testing/selftests/cgroup/test_cpuset.c
@@ -249,7 +249,7 @@ int main(int argc, char *argv[])
 	char root[PATH_MAX];
 	int i, ret = EXIT_SUCCESS;
 
-	if (cg_find_unified_root(root, sizeof(root)))
+	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
 	if (cg_read_strstr(root, "cgroup.subtree_control", "cpuset"))
diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
index 8845353aca53b..8730645d363a7 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -827,7 +827,7 @@ int main(int argc, char *argv[])
 	char root[PATH_MAX];
 	int i, ret = EXIT_SUCCESS;
 
-	if (cg_find_unified_root(root, sizeof(root)))
+	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
index f0fefeb4cc24c..856f9508ea562 100644
--- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
@@ -214,7 +214,7 @@ int main(int argc, char **argv)
 		return ret;
 	}
 
-	if (cg_find_unified_root(root, sizeof(root)))
+	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
 	switch (test_hugetlb_memcg(root)) {
diff --git a/tools/testing/selftests/cgroup/test_kill.c b/tools/testing/selftests/cgroup/test_kill.c
index 6153690319c9c..0e5bb6c7307a5 100644
--- a/tools/testing/selftests/cgroup/test_kill.c
+++ b/tools/testing/selftests/cgroup/test_kill.c
@@ -276,7 +276,7 @@ int main(int argc, char *argv[])
 	char root[PATH_MAX];
 	int i, ret = EXIT_SUCCESS;
 
-	if (cg_find_unified_root(root, sizeof(root)))
+	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index c82f974b85c94..137506db03127 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -420,7 +420,7 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i, ret = EXIT_SUCCESS;
 
-	if (cg_find_unified_root(root, sizeof(root)))
+	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
 	/*
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index c7c9572003a8c..b462416b38061 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1314,7 +1314,7 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i, proc_status, ret = EXIT_SUCCESS;
 
-	if (cg_find_unified_root(root, sizeof(root)))
+	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
 	/*
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index f0e488ed90d89..ef7f395453173 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -440,7 +440,7 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i, ret = EXIT_SUCCESS;
 
-	if (cg_find_unified_root(root, sizeof(root)))
+	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
 	if (!zswap_configured())
-- 
2.43.0



