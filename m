Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B00F19AD5C;
	Thu,  6 Jun 2024 14:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683371; cv=none; b=sfUC18rgfGH1PESkWFnJtONY9f4XsvcIeFf4yVsLjZONPaVdbKfxxK3xtYveQ2kP0cxoqMjY0abSq/ImNQ0EQ/VWaxoTwOWnxF6Gjyi0zAFG1vWc+GHhxKwdou7RVa1LQslavjavjMoJBujYnOsN8W7rZ8GSRVmrYdpWZ4Jw3kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683371; c=relaxed/simple;
	bh=Lp1D48iSNuiv7cTLvETdEfTCe8Q6OeuRkR+hablHPkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIcktSZ/0sORtfuqeertL6jcU5MUiTPjSPvIsiky0IZh5dT6+hOrvjChf8Jj+WRnMKEHEhp3l3mGSSHp5b6vfjHCR0Zkv0Jly+tDj4wugvMx5GHg0skQ08WtAgQLpBd/183xxwMzEwnGAqdQjlIcah+BZhEfnA0PkVHnj3n47k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4Fm5Q3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4Fm5Q3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA24C2BD10;
	Thu,  6 Jun 2024 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683371;
	bh=Lp1D48iSNuiv7cTLvETdEfTCe8Q6OeuRkR+hablHPkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4Fm5Q3sQOjS6ekq/LyFRagAeJBkrUfZ0xCSF917OnIohJyodP7iCsPqhwbJ/CZnP
	 eF76ok+fq6stpraaU8S6lO24JbaE9nusafJd+m2f22jWPNpPO2qzenxZyxOvvyiuVA
	 TfEgcQBJmczaYUb9bKxxZid0kBPicqOZIDfP7lIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/744] selftests: cgroup: skip test_cgcore_lesser_ns_open when cgroup2 mounted without nsdelegate
Date: Thu,  6 Jun 2024 15:59:31 +0200
Message-ID: <20240606131741.979035892@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/cgroup/cgroup_util.c     | 8 +++++---
 tools/testing/selftests/cgroup/cgroup_util.h     | 2 +-
 tools/testing/selftests/cgroup/test_core.c       | 7 ++++++-
 tools/testing/selftests/cgroup/test_cpu.c        | 2 +-
 tools/testing/selftests/cgroup/test_cpuset.c     | 2 +-
 tools/testing/selftests/cgroup/test_freezer.c    | 2 +-
 tools/testing/selftests/cgroup/test_kill.c       | 2 +-
 tools/testing/selftests/cgroup/test_kmem.c       | 2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
 tools/testing/selftests/cgroup/test_zswap.c      | 2 +-
 10 files changed, 19 insertions(+), 12 deletions(-)

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
index ff519029f6f43..969e9f0f495c3 100644
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
index 49def87a909bd..6927b4a06dee6 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -250,7 +250,7 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i, ret = EXIT_SUCCESS;
 
-	if (cg_find_unified_root(root, sizeof(root)))
+	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
 	if (!zswap_configured())
-- 
2.43.0



