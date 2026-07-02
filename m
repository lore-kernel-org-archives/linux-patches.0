Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C67330B29;
	Thu,  2 Jul 2026 16:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009916; cv=none; b=f7sld1LfVeMcHPwGVE7Rbr0SQiTez8pHsZFfEr4LCCTzVTr3/wnhipTpQ1cKeyPqkVoiGkniV+nkGKHmqgSpgQVHdLNrUs2kFmaFCR8bFwHZjSvyFwRs8Z73VEL+K082DWjshWu0zfPuPwKTuTEHmg3KY6XqN7a1rEGyqHcmYzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009916; c=relaxed/simple;
	bh=wk848r46DIJ8YXjKTLfRixnoTpSAFGmQ3fJlyEKkUYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WC5VHU99gjgEwgp7x6NKs9I61plTLBCQH/JzBXrRSerUMLt80M5AHRenghXJ87hYdafDLbEgAVKYQOgzcMVWiFx19procwaIUu2023duazvY2dnR5Xpu2dxHnV0n+KzTIcjgQYJL8lCoGaBvpKOrY3p43d/ngeP1pkqJPqSfs4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsGMPqIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsGMPqIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F841F000E9;
	Thu,  2 Jul 2026 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009914;
	bh=YPPknz2Rd9jvtPtj3V3CZWUzv8nGsCV3A3Zxf/gR5UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsGMPqImGp2hEVYft54DIvmnUjxwxrl5ZQnEcU2G+PNSsKvV7xfVQV8IVcjfjpl6l
	 2r0JutWCm+PaNbkt+7JwGdwYtrChJO8Y25yEj0bSn+o91h+bHZG+x97iMkGAnI7IDv
	 GKOsnPvQLjXgTQrnj0opSLH841UtrmMB/Qc6LLXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/129] selftests/bpf: Move get_time_ns to testing_helpers.h
Date: Thu,  2 Jul 2026 18:18:52 +0200
Message-ID: <20260702155112.436376777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit 3830d04a7401f277185e4439eb259c1b13e76788 upstream.

We'd like to have single copy of get_time_ns used b bench and test_progs,
but we can't just include bench.h, because of conflicting 'struct env'
objects.

Moving get_time_ns to testing_helpers.h which is being included by both
bench and test_progs objects.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20230809083440.3209381-19-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: e6c209da7e0e ("selftests/bpf: Check for timeout in perf_link test")
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bench.h                    |  9 ---------
 .../selftests/bpf/prog_tests/kprobe_multi_test.c       |  8 --------
 tools/testing/selftests/bpf/testing_helpers.h          | 10 ++++++++++
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.h b/tools/testing/selftests/bpf/bench.h
index 66959387148375..2c94c57885af85 100644
--- a/tools/testing/selftests/bpf/bench.h
+++ b/tools/testing/selftests/bpf/bench.h
@@ -79,15 +79,6 @@ void grace_period_latency_basic_stats(struct bench_res res[], int res_cnt,
 void grace_period_ticks_basic_stats(struct bench_res res[], int res_cnt,
 				    struct basic_stats *gp_stat);
 
-static inline __u64 get_time_ns(void)
-{
-	struct timespec t;
-
-	clock_gettime(CLOCK_MONOTONIC, &t);
-
-	return (u64)t.tv_sec * 1000000000 + t.tv_nsec;
-}
-
 static inline void atomic_inc(long *value)
 {
 	(void)__atomic_add_fetch(value, 1, __ATOMIC_RELAXED);
diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index 0d82e28aed1ac0..8086e28346466f 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -304,14 +304,6 @@ static void test_attach_api_fails(void)
 	kprobe_multi__destroy(skel);
 }
 
-static inline __u64 get_time_ns(void)
-{
-	struct timespec t;
-
-	clock_gettime(CLOCK_MONOTONIC, &t);
-	return (__u64) t.tv_sec * 1000000000 + t.tv_nsec;
-}
-
 static size_t symbol_hash(const void *key, void *ctx __maybe_unused)
 {
 	return str_hash((const char *) key);
diff --git a/tools/testing/selftests/bpf/testing_helpers.h b/tools/testing/selftests/bpf/testing_helpers.h
index f72fb24f8e90fb..ba4f205e7bc757 100644
--- a/tools/testing/selftests/bpf/testing_helpers.h
+++ b/tools/testing/selftests/bpf/testing_helpers.h
@@ -7,6 +7,7 @@
 #include <stdbool.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include <time.h>
 
 int parse_num_list(const char *s, bool **set, int *set_len);
 __u32 link_info_prog_id(const struct bpf_link *link, struct bpf_link_info *info);
@@ -30,4 +31,13 @@ int load_bpf_testmod(bool verbose);
 void unload_bpf_testmod(bool verbose);
 int kern_sync_rcu(void);
 
+static inline __u64 get_time_ns(void)
+{
+	struct timespec t;
+
+	clock_gettime(CLOCK_MONOTONIC, &t);
+
+	return (u64)t.tv_sec * 1000000000 + t.tv_nsec;
+}
+
 #endif /* __TESTING_HELPERS_H */
-- 
2.53.0



