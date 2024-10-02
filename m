Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6520E1D2785;
	Wed,  2 Oct 2024 14:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879714; cv=none; b=jmXEC8t+sxugDT/iU+cjxorPngLlbQk5PBlRDCzJJ/L8HfKbFf05UXjCK/2+AvEloIeB+MyqyIoUb9/FIy5r0oy/y/ud7ji6Q3UBWTeMm0Kw7O4mjTY0N7AHlWu2Fg4VpTRnM9Trl6G8JTNbce8HOGeHjl2zBTEUINC2lYMyOxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879714; c=relaxed/simple;
	bh=dzWkA12PrFrNeVvfQ9tCL8iGRn4lPrxEmX6Dg85rL1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXh7p1SFvIa8S75wVtfMdhkKx+MsqNWxhpAIjxgQtGdq/IWAitIcE6xT7jMJCRJhQUzRNYBOct5XAbey6MfujlET+yrevwi171Cv75XYkPXWZysgbWjKEqU044GmSN8Tn+2MNLVdY5rYKTd6uZz9UfhhrGwSJemhVKbqK5AJZH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnCXOKZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnCXOKZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32BFC4CEC2;
	Wed,  2 Oct 2024 14:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879714;
	bh=dzWkA12PrFrNeVvfQ9tCL8iGRn4lPrxEmX6Dg85rL1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnCXOKZihJQQ7z7SsFdYZnJTm3juQkvFhloCqDlhpvgn20jJIp3XaMM4ahVQ2uqjb
	 Ty83Btjq94eeaXHl7UMIRmoeOtTJyihE6osNgCj+KNHqC5AWeK0+UpXuH16yDGjoub
	 Mf5mdfZDXAdqRAYIEmrNJ7I88brVaUfAZmvQ6b4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/538] selftests/bpf: Replace CHECK with ASSERT_* in ns_current_pid_tgid test
Date: Wed,  2 Oct 2024 14:57:15 +0200
Message-ID: <20241002125759.992864627@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 84239a24d10174fcfc7d6760cb120435a6ff69af ]

Replace CHECK in selftest ns_current_pid_tgid with recommended ASSERT_* style.
I also shortened subtest name as the prefix of subtest name is covered
by the test name already.

This patch does fix a testing issue. Currently even if bss->user_{pid,tgid}
is not correct, the test still passed since the clone func returns 0.
I fixed it to return a non-zero value if bss->user_{pid,tgid} is incorrect.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20240315184859.2975543-1-yonghong.song@linux.dev
Stable-dep-of: 21f0b0af9772 ("selftests/bpf: Fix include of <sys/fcntl.h>")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 36 ++++++++++---------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
index 24d493482ffc7..3a0664a86243e 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -20,19 +20,19 @@ static int test_current_pid_tgid(void *args)
 {
 	struct test_ns_current_pid_tgid__bss  *bss;
 	struct test_ns_current_pid_tgid *skel;
-	int err = -1, duration = 0;
+	int ret = -1, err;
 	pid_t tgid, pid;
 	struct stat st;
 
 	skel = test_ns_current_pid_tgid__open_and_load();
-	if (CHECK(!skel, "skel_open_load", "failed to load skeleton\n"))
-		goto cleanup;
+	if (!ASSERT_OK_PTR(skel, "test_ns_current_pid_tgid__open_and_load"))
+		goto out;
 
 	pid = syscall(SYS_gettid);
 	tgid = getpid();
 
 	err = stat("/proc/self/ns/pid", &st);
-	if (CHECK(err, "stat", "failed /proc/self/ns/pid: %d\n", err))
+	if (!ASSERT_OK(err, "stat /proc/self/ns/pid"))
 		goto cleanup;
 
 	bss = skel->bss;
@@ -42,24 +42,26 @@ static int test_current_pid_tgid(void *args)
 	bss->user_tgid = 0;
 
 	err = test_ns_current_pid_tgid__attach(skel);
-	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+	if (!ASSERT_OK(err, "test_ns_current_pid_tgid__attach"))
 		goto cleanup;
 
 	/* trigger tracepoint */
 	usleep(1);
-	ASSERT_EQ(bss->user_pid, pid, "pid");
-	ASSERT_EQ(bss->user_tgid, tgid, "tgid");
-	err = 0;
+	if (!ASSERT_EQ(bss->user_pid, pid, "pid"))
+		goto cleanup;
+	if (!ASSERT_EQ(bss->user_tgid, tgid, "tgid"))
+		goto cleanup;
+	ret = 0;
 
 cleanup:
-	 test_ns_current_pid_tgid__destroy(skel);
-
-	return err;
+	test_ns_current_pid_tgid__destroy(skel);
+out:
+	return ret;
 }
 
 static void test_ns_current_pid_tgid_new_ns(void)
 {
-	int wstatus, duration = 0;
+	int wstatus;
 	pid_t cpid;
 
 	/* Create a process in a new namespace, this process
@@ -68,21 +70,21 @@ static void test_ns_current_pid_tgid_new_ns(void)
 	cpid = clone(test_current_pid_tgid, child_stack + STACK_SIZE,
 		     CLONE_NEWPID | SIGCHLD, NULL);
 
-	if (CHECK(cpid == -1, "clone", "%s\n", strerror(errno)))
+	if (!ASSERT_NEQ(cpid, -1, "clone"))
 		return;
 
-	if (CHECK(waitpid(cpid, &wstatus, 0) == -1, "waitpid", "%s\n", strerror(errno)))
+	if (!ASSERT_NEQ(waitpid(cpid, &wstatus, 0), -1, "waitpid"))
 		return;
 
-	if (CHECK(WEXITSTATUS(wstatus) != 0, "newns_pidtgid", "failed"))
+	if (!ASSERT_OK(WEXITSTATUS(wstatus), "newns_pidtgid"))
 		return;
 }
 
 /* TODO: use a different tracepoint */
 void serial_test_ns_current_pid_tgid(void)
 {
-	if (test__start_subtest("ns_current_pid_tgid_root_ns"))
+	if (test__start_subtest("root_ns_tp"))
 		test_current_pid_tgid(NULL);
-	if (test__start_subtest("ns_current_pid_tgid_new_ns"))
+	if (test__start_subtest("new_ns_tp"))
 		test_ns_current_pid_tgid_new_ns();
 }
-- 
2.43.0



