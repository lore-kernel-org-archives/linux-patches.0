Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ECE1F152D;
	Tue, 30 Sep 2025 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244706; cv=none; b=IyRQ999Z1WmSnb6SwSav0qiT6c5q1wzgyKlpwp0/6X6HFtp1Pyury9K9spK6ebIU+EtcDuYGCv/rSW9SVeS9YfnAoARO7YEDzky4YZCY0A2R9vUWmGTsX8Vw+i9MWEOInrV3rxuQ+b7gom9yHUObRQq+cG4mO6yuFqaTpvt0ww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244706; c=relaxed/simple;
	bh=9/ofTBLWazO7801LlFf+Gs07KU8DXEMFap6wgNok0xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVqyiACd0WlQk1cMYE7JipNvzyt0H5y+y+pC8nCxyzH3Nqzt7LdHg9hJiuBRZpQRHiuuqYMoPZsadYQQpL3qZg1CT02gvMZOG1KVDpzzTINS9zYulBBC52rkxcYgInvK9dpeQ4v71p4M8n4OFE66LQZ7z08yL4RyDHW7rCIFhxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMsPc27C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMsPc27C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41A6C4CEF0;
	Tue, 30 Sep 2025 15:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244706;
	bh=9/ofTBLWazO7801LlFf+Gs07KU8DXEMFap6wgNok0xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMsPc27CX9H+IHNbwRPn0QHU51bIvKIPktrsrNIfF5f/lMqFgYuxNi2xfizrTdwBm
	 lli9eJ5OFbUNauPf2BhlZYup643oUAerylIG02qP/6ax3vRNoTfnITwLyGdjtN+uqy
	 YZhKzISOVhE/jPjqmQeVDyblvqm/HGl+2WNjhdHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 057/143] selftests/bpf: Skip timer cases when bpf_timer is not supported
Date: Tue, 30 Sep 2025 16:46:21 +0200
Message-ID: <20250930143833.503095053@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit fbdd61c94bcb09b0c0eb0655917bf4193d07aac1 ]

When enable CONFIG_PREEMPT_RT, verifier will reject bpf_timer with
returning -EOPNOTSUPP.

Therefore, skip test cases when errno is EOPNOTSUPP.

cd tools/testing/selftests/bpf
./test_progs -t timer
125     free_timer:SKIP
456     timer:SKIP
457/1   timer_crash/array:SKIP
457/2   timer_crash/hash:SKIP
457     timer_crash:SKIP
458     timer_lockup:SKIP
459     timer_mim:SKIP
Summary: 5/0 PASSED, 6 SKIPPED, 0 FAILED

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20250910125740.52172-3-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/free_timer.c   | 4 ++++
 tools/testing/selftests/bpf/prog_tests/timer.c        | 4 ++++
 tools/testing/selftests/bpf/prog_tests/timer_crash.c  | 4 ++++
 tools/testing/selftests/bpf/prog_tests/timer_lockup.c | 4 ++++
 tools/testing/selftests/bpf/prog_tests/timer_mim.c    | 4 ++++
 5 files changed, 20 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/free_timer.c b/tools/testing/selftests/bpf/prog_tests/free_timer.c
index b7b77a6b29799..0de8facca4c5b 100644
--- a/tools/testing/selftests/bpf/prog_tests/free_timer.c
+++ b/tools/testing/selftests/bpf/prog_tests/free_timer.c
@@ -124,6 +124,10 @@ void test_free_timer(void)
 	int err;
 
 	skel = free_timer__open_and_load();
+	if (!skel && errno == EOPNOTSUPP) {
+		test__skip();
+		return;
+	}
 	if (!ASSERT_OK_PTR(skel, "open_load"))
 		return;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/timer.c b/tools/testing/selftests/bpf/prog_tests/timer.c
index d66687f1ee6a8..56f660ca567ba 100644
--- a/tools/testing/selftests/bpf/prog_tests/timer.c
+++ b/tools/testing/selftests/bpf/prog_tests/timer.c
@@ -86,6 +86,10 @@ void serial_test_timer(void)
 	int err;
 
 	timer_skel = timer__open_and_load();
+	if (!timer_skel && errno == EOPNOTSUPP) {
+		test__skip();
+		return;
+	}
 	if (!ASSERT_OK_PTR(timer_skel, "timer_skel_load"))
 		return;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/timer_crash.c b/tools/testing/selftests/bpf/prog_tests/timer_crash.c
index f74b82305da8c..b841597c8a3a3 100644
--- a/tools/testing/selftests/bpf/prog_tests/timer_crash.c
+++ b/tools/testing/selftests/bpf/prog_tests/timer_crash.c
@@ -12,6 +12,10 @@ static void test_timer_crash_mode(int mode)
 	struct timer_crash *skel;
 
 	skel = timer_crash__open_and_load();
+	if (!skel && errno == EOPNOTSUPP) {
+		test__skip();
+		return;
+	}
 	if (!ASSERT_OK_PTR(skel, "timer_crash__open_and_load"))
 		return;
 	skel->bss->pid = getpid();
diff --git a/tools/testing/selftests/bpf/prog_tests/timer_lockup.c b/tools/testing/selftests/bpf/prog_tests/timer_lockup.c
index 1a2f99596916f..eb303fa1e09af 100644
--- a/tools/testing/selftests/bpf/prog_tests/timer_lockup.c
+++ b/tools/testing/selftests/bpf/prog_tests/timer_lockup.c
@@ -59,6 +59,10 @@ void test_timer_lockup(void)
 	}
 
 	skel = timer_lockup__open_and_load();
+	if (!skel && errno == EOPNOTSUPP) {
+		test__skip();
+		return;
+	}
 	if (!ASSERT_OK_PTR(skel, "timer_lockup__open_and_load"))
 		return;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/timer_mim.c b/tools/testing/selftests/bpf/prog_tests/timer_mim.c
index 9ff7843909e7d..c930c7d7105b9 100644
--- a/tools/testing/selftests/bpf/prog_tests/timer_mim.c
+++ b/tools/testing/selftests/bpf/prog_tests/timer_mim.c
@@ -65,6 +65,10 @@ void serial_test_timer_mim(void)
 		goto cleanup;
 
 	timer_skel = timer_mim__open_and_load();
+	if (!timer_skel && errno == EOPNOTSUPP) {
+		test__skip();
+		return;
+	}
 	if (!ASSERT_OK_PTR(timer_skel, "timer_skel_load"))
 		goto cleanup;
 
-- 
2.51.0



