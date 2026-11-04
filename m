Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829304;
	b=3Zm4sSp1zrXcm4XmLLG89ZIHXuukMCmxIGaQZh1xCj3RpFN6kmqcGdYCmaL8HCK2PCcT
	 kbD3c2ZzvFI287nTt/TleP+flf0LBwnBORXrIROK0g670FQXijN6UCbDUKHPlc1G1ikTx
	 B0eSCa4PrUHHTPViRZoy8AIEYENsF3ZeL3Lr6JUGIEGaeIWLZLbHWqT9m/8pxpoT1H5yh
	 0+WUq4vjjN3pzULYvpIaFKs9pIo7RWRmseMybxvFm4DcvfTKkeCzLm4PmzhJrvqT3IRq9
	 yUNSdeaKdh8qN2vq0B+i6nNaH9MXthPgiW6B9UNStO8tTWXgpNJN5v73dXrbtWfSCDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=F8pBa5XnzFYUc2phPP8VjBPE5SB5fsbCxXRG+1A5HXQ=;
	b=VL+gqkylbkAccjYcVUrMvahfRSBES0+9OIpkimIQCwFCHV6TQFG9H3R+hFe8mZOKWyjh
	 2GFbpk1WwOSLvewWtoESUqo8wS0kEPkmPyp9vbrsARbZPhtbu6GzrnkLoAzcpkR8c9Vgh
	 xzzsPKtTmfOJzXOLLHZ4ITv4VfNe9rMWHz7yKx1y9jSyApspC1+QHo9+WFGfHcNV7l1/M
	 VOG7f0amLIyVVwr5smeL/4vNTa8j99yC0bayR7GcitHBlnxwKcSGzOgRxyTimkCfxdYIf
	 1762BJux6jgHdgkHvSeAUg9tRHakfbty/Xw7GXzqVbU+qJtFzfBvgdtQdnGDHicjyyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AmNz5YcN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207A16074911;
	Wed,  4 Nov 2026 21:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AmNz5YcN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B851F00919;
	Wed,  4 Nov 2026 21:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829304;
	bh=F8pBa5XnzFYUc2phPP8VjBPE5SB5fsbCxXRG+1A5HXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmNz5YcN4kpkVexy/95R8j4nnGb5x4sv22lDKlQLT+jtrwr160FYdkbzJqmQACpkZ
	 mnc0VwcAeNh1OsyjyZUCzcIRj0xgyhUiQCJzMjdwmpYe/Kq3madygT4dOTVU/CPQUk
	 CkP2b5RsYmGp7LOgD5cFgI6B8a2s4yiMuzFJ9tZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Simmons-Talbott <joest@redhat.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0040/1005] selftests/cgroup: Adjust cpu test duration based on HZ
Date: Wed,  4 Nov 2026 15:56:13 -0500
Message-ID: <20261104211044.696180484@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Joe Simmons-Talbott <joest@redhat.com>

[ Upstream commit a2703c2980c0776e9be7d8f9e144afd054dddb12 ]

For lower HZ values a quota of 1000us is much lower than the amount
of microseconds per tick which makes the tests test_cpucg_max and
test_cpugc_max_nested fail. Increase the test duration to accommodate
for lower HZ values.

Link: https://lore.kernel.org/lkml/20260625203307.1114538-1-joest@redhat.com/
Signed-off-by: Joe Simmons-Talbott <joest@redhat.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../cgroup/lib/include/cgroup_util.h          |  1 +
 tools/testing/selftests/cgroup/test_cpu.c     | 43 ++++++++++++++++---
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 7ab2824ed7b54..b9cd00e0e8349 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -8,6 +8,7 @@
 
 #define MB(x) (x << 20)
 
+#define NSEC_PER_USEC	1000L
 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000L
 
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index d54e2317efff2..de60967279668 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -639,6 +639,31 @@ test_cpucg_nested_weight_underprovisioned(const char *root)
 	return run_cpucg_nested_weight_test(root, false);
 }
 
+/*
+ * Best effort attempt to get the kernel's HZ value from the config.
+ * Return the HZ value if found otherwise return 1000 (the default) to
+ * indicate failure.
+ */
+static long
+get_config_hz(void)
+{
+	long hz = 1000;
+	FILE *f;
+	char cmd[256] = "zcat /proc/config.gz 2>/dev/null | grep '^CONFIG_HZ='";
+
+	f = popen(cmd, "r");
+
+	if (!f)
+		return hz;
+
+	if (fscanf(f, "CONFIG_HZ=%ld", &hz) == EOF)
+		goto out;
+
+out:
+	pclose(f);
+	return hz;
+}
+
 /*
  * This test creates a cgroup with some maximum value within a period, and
  * verifies that a process in the cgroup is not overscheduled.
@@ -646,15 +671,18 @@ test_cpucg_nested_weight_underprovisioned(const char *root)
 static int test_cpucg_max(const char *root)
 {
 	int ret = KSFT_FAIL;
+	long hz = get_config_hz();
 	long quota_usec = 1000;
 	long default_period_usec = 100000; /* cpu.max's default period */
 	long duration_seconds = 1;
 
-	long duration_usec = duration_seconds * USEC_PER_SEC;
+	long duration_usec;
 	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
 	char *cpucg;
 	char quota_buf[32];
 
+	duration_usec = duration_seconds * USEC_PER_SEC * 1000 / hz;
+
 	snprintf(quota_buf, sizeof(quota_buf), "%ld", quota_usec);
 
 	cpucg = cg_name(root, "cpucg_test");
@@ -670,8 +698,8 @@ static int test_cpucg_max(const char *root)
 	struct cpu_hog_func_param param = {
 		.nprocs = 1,
 		.ts = {
-			.tv_sec = duration_seconds,
-			.tv_nsec = 0,
+			.tv_sec = duration_usec / USEC_PER_SEC,
+			.tv_nsec = duration_usec % USEC_PER_SEC * NSEC_PER_USEC,
 		},
 		.clock_type = CPU_HOG_CLOCK_WALL,
 	};
@@ -710,15 +738,18 @@ static int test_cpucg_max(const char *root)
 static int test_cpucg_max_nested(const char *root)
 {
 	int ret = KSFT_FAIL;
+	long hz = get_config_hz();
 	long quota_usec = 1000;
 	long default_period_usec = 100000; /* cpu.max's default period */
 	long duration_seconds = 1;
 
-	long duration_usec = duration_seconds * USEC_PER_SEC;
+	long duration_usec;
 	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
 	char *parent, *child;
 	char quota_buf[32];
 
+	duration_usec = duration_seconds * USEC_PER_SEC * 1000 / hz;
+
 	snprintf(quota_buf, sizeof(quota_buf), "%ld", quota_usec);
 
 	parent = cg_name(root, "cpucg_parent");
@@ -741,8 +772,8 @@ static int test_cpucg_max_nested(const char *root)
 	struct cpu_hog_func_param param = {
 		.nprocs = 1,
 		.ts = {
-			.tv_sec = duration_seconds,
-			.tv_nsec = 0,
+			.tv_sec = duration_usec / USEC_PER_SEC,
+			.tv_nsec = duration_usec % USEC_PER_SEC * NSEC_PER_USEC,
 		},
 		.clock_type = CPU_HOG_CLOCK_WALL,
 	};
-- 
2.53.0



