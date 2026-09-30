Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8822F3E022B;
	Wed, 30 Sep 2026 19:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796625; cv=none; b=Fxhoh8h1gbhDcwvk3R9kuEEOAOl5ET40FWLLMCiQwT8I5KhTf/FBw/jTYnn2dm7cQxiLx+eLBXdopIMlpu6Vvwp3s0GpzgNI8wz5v3IOdAKRobrVdNMDXsz4FOYOjYc2TEkI2oqweMQdKQ7chcu61L6rkmmOUiLGYaufZvoE2JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796625; c=relaxed/simple;
	bh=5F7v856uObc6His9pgCJufZfaS/4nPJOyTCtdbJVKJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W31FkJUr74G7IX9j7K4k3fayN/OI9FFy771OqZ5F2tTvD9lGWgNxZAwZQ8aC1dG30bDemnQj3OqXNZZFVoeRvVX07a5Ko8NLnhotuJlzzJsrj9xu+M2izhoZUcU7JkA0h8e9g+fYlxVRP/Exx+Vg4QoZkBQIgdTwYJCvw13TtjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8rBQBq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8rBQBq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90061F000FF;
	Wed, 30 Sep 2026 19:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796624;
	bh=ezql4NiHGjGBUdFq/xYoBaWiP5D9Q2Tn90HAitk87hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8rBQBq51hn+heB2GPZU7MUBhbvgAN807e2JIrmshbysMoBBv58vYs8Ep0yqVnVaN
	 kjDMEh7mNke3XAk9Prll6CWhcm0M/cG9HRzTcdRgNERubWyqM/KQuXM2L7wcyWcxCU
	 qQUTNJ4JQ9oY6Nux6L3yCsLRCJSzTcL3kUl+IoWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Houghton <jthoughton@google.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0978/1193] cgroup: selftests: Move memcontrol specific helpers out of common cgroup_util.c
Date: Wed, 30 Sep 2026 17:27:42 +0200
Message-ID: <20260930152455.971022406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 3a7f9e518c6a83d54c84c101e23ffc8aa12df139 ]

Move a handful of helpers out of cgroup_util.c and into test_memcontrol.c
that have nothing to with cgroups in general, in anticipation of making
cgroup_util.c a generic library that can be used by other selftests.

Make read_text() and write_text() non-static so test_memcontrol.c can
use them.

Signed-off-by: James Houghton <jthoughton@google.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Link: https://lore.kernel.org/r/20250508184649.2576210-4-jthoughton@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: c774ec8f0a5d ("selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c  | 82 +------------------
 tools/testing/selftests/cgroup/cgroup_util.h  |  8 +-
 .../selftests/cgroup/test_memcontrol.c        | 78 ++++++++++++++++++
 3 files changed, 83 insertions(+), 85 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 432db923bced0..85a33f0d2e7d2 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -20,7 +20,7 @@
 #include "../clone3/clone3_selftests.h"
 
 /* Returns read len on success, or -errno on failure. */
-static ssize_t read_text(const char *path, char *buf, size_t max_len)
+ssize_t read_text(const char *path, char *buf, size_t max_len)
 {
 	ssize_t len;
 	int fd;
@@ -39,7 +39,7 @@ static ssize_t read_text(const char *path, char *buf, size_t max_len)
 }
 
 /* Returns written len on success, or -errno on failure. */
-static ssize_t write_text(const char *path, char *buf, ssize_t len)
+ssize_t write_text(const char *path, char *buf, ssize_t len)
 {
 	int fd;
 
@@ -466,84 +466,6 @@ int cg_run_nowait(const char *cgroup,
 	return pid;
 }
 
-int get_temp_fd(void)
-{
-	return open(".", O_TMPFILE | O_RDWR | O_EXCL);
-}
-
-int alloc_pagecache(int fd, size_t size)
-{
-	char buf[PAGE_SIZE];
-	struct stat st;
-	int i;
-
-	if (fstat(fd, &st))
-		goto cleanup;
-
-	size += st.st_size;
-
-	if (ftruncate(fd, size))
-		goto cleanup;
-
-	for (i = 0; i < size; i += sizeof(buf))
-		read(fd, buf, sizeof(buf));
-
-	return 0;
-
-cleanup:
-	return -1;
-}
-
-int alloc_anon(const char *cgroup, void *arg)
-{
-	size_t size = (unsigned long)arg;
-	char *buf, *ptr;
-
-	buf = malloc(size);
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
-		*ptr = 0;
-
-	free(buf);
-	return 0;
-}
-
-int is_swap_enabled(void)
-{
-	char buf[PAGE_SIZE];
-	const char delim[] = "\n";
-	int cnt = 0;
-	char *line;
-
-	if (read_text("/proc/swaps", buf, sizeof(buf)) <= 0)
-		return -1;
-
-	for (line = strtok(buf, delim); line; line = strtok(NULL, delim))
-		cnt++;
-
-	return cnt > 1;
-}
-
-int set_oom_adj_score(int pid, int score)
-{
-	char path[PATH_MAX];
-	int fd, len;
-
-	sprintf(path, "/proc/%d/oom_score_adj", pid);
-
-	fd = open(path, O_WRONLY | O_APPEND);
-	if (fd < 0)
-		return fd;
-
-	len = dprintf(fd, "%d", score);
-	if (len < 0) {
-		close(fd);
-		return len;
-	}
-
-	close(fd);
-	return 0;
-}
-
 int proc_mount_contains(const char *option)
 {
 	char buf[4 * PAGE_SIZE];
diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing/selftests/cgroup/cgroup_util.h
index 89e8519fb2719..d4107e2dfa74f 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/cgroup_util.h
@@ -21,6 +21,9 @@ static inline int values_close(long a, long b, int err)
 	return abs(a - b) <= (a + b) / 100 * err;
 }
 
+extern ssize_t read_text(const char *path, char *buf, size_t max_len);
+extern ssize_t write_text(const char *path, char *buf, ssize_t len);
+
 extern int cg_find_unified_root(char *root, size_t len, bool *nsdelegate);
 extern char *cg_name(const char *root, const char *name);
 extern char *cg_name_indexed(const char *root, const char *name, int index);
@@ -47,11 +50,6 @@ extern int cg_enter_current_thread(const char *cgroup);
 extern int cg_run_nowait(const char *cgroup,
 			 int (*fn)(const char *cgroup, void *arg),
 			 void *arg);
-extern int get_temp_fd(void);
-extern int alloc_pagecache(int fd, size_t size);
-extern int alloc_anon(const char *cgroup, void *arg);
-extern int is_swap_enabled(void);
-extern int set_oom_adj_score(int pid, int score);
 extern int cg_wait_for_proc_count(const char *cgroup, int count);
 extern int cg_killall(const char *cgroup);
 int proc_mount_contains(const char *option);
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 6efa26a8383e1..609ac5652a46c 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -24,6 +24,84 @@
 static bool has_localevents;
 static bool has_recursiveprot;
 
+int get_temp_fd(void)
+{
+	return open(".", O_TMPFILE | O_RDWR | O_EXCL);
+}
+
+int alloc_pagecache(int fd, size_t size)
+{
+	char buf[PAGE_SIZE];
+	struct stat st;
+	int i;
+
+	if (fstat(fd, &st))
+		goto cleanup;
+
+	size += st.st_size;
+
+	if (ftruncate(fd, size))
+		goto cleanup;
+
+	for (i = 0; i < size; i += sizeof(buf))
+		read(fd, buf, sizeof(buf));
+
+	return 0;
+
+cleanup:
+	return -1;
+}
+
+int alloc_anon(const char *cgroup, void *arg)
+{
+	size_t size = (unsigned long)arg;
+	char *buf, *ptr;
+
+	buf = malloc(size);
+	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+		*ptr = 0;
+
+	free(buf);
+	return 0;
+}
+
+int is_swap_enabled(void)
+{
+	char buf[PAGE_SIZE];
+	const char delim[] = "\n";
+	int cnt = 0;
+	char *line;
+
+	if (read_text("/proc/swaps", buf, sizeof(buf)) <= 0)
+		return -1;
+
+	for (line = strtok(buf, delim); line; line = strtok(NULL, delim))
+		cnt++;
+
+	return cnt > 1;
+}
+
+int set_oom_adj_score(int pid, int score)
+{
+	char path[PATH_MAX];
+	int fd, len;
+
+	sprintf(path, "/proc/%d/oom_score_adj", pid);
+
+	fd = open(path, O_WRONLY | O_APPEND);
+	if (fd < 0)
+		return fd;
+
+	len = dprintf(fd, "%d", score);
+	if (len < 0) {
+		close(fd);
+		return len;
+	}
+
+	close(fd);
+	return 0;
+}
+
 /*
  * This test creates two nested cgroups with and without enabling
  * the memory controller.
-- 
2.53.0



