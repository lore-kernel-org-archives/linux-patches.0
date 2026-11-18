Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031079;
	b=ik/jrhgLb30dg5SwE/9xT68Th2opQxUTzNWRWJ9NFs9be/6i2p18AmcApRrYLGhmZejn
	 yOLvuNhqpiiiAS4M4E4aNvTyW4VWxgt8Xjvy4EHExyu3o3ZM9vLBonhNVF6CEDYD2IRbY
	 b+Y1BcXDtwsLmvox5cZD3q1LJSvs0blS853le+AwYFpo8K9eSaq9KslOUH1n4dDT6ZmnH
	 jeR2Qs/COFKh4SdEmva2H18VzNu4WhW7IEGgOpcnJnQrl2GzPhX/kk+R/XWjuNeeppx+U
	 o4uc7KqDBkZXs0x404haVJQ1F0SUA2eqWnBlG8pz3wPh3YNA5rmViOAnMDJ9Zzx1jFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aXU66Rl7L2bI2+++V/swlCEPE7nYkkfkbkbKwJ4ark4=;
	b=M22yXxV3u1r5Ti05AQ5CDZjcdkOV785k7G+wV4o/9Ls439ktznwXKF8JRBQVFORGqnFu
	 ibgh7piqPArVRlkqPy1RKkOQRI9NCSxJ9KyiWeHdILsp7lBUp1YTZbyTcmKsIWVEv56ks
	 32jIpxAkW1X2yPUJ9RwU+Wy74RMWZ7DfjN0x0/9f/2mJAKAWbP0O1A2/GWWtPKGABMTAh
	 h9ulRCLS5XMrWwFYbrRwyjNYgx9RhXCmxQXWSTw6uomhxVsFqyacrfzXauURqER6k7ZNT
	 kknMZ6MXjeDX4fpJsA5tGpSzJFnsuctQmkm827DioPoUTB0Cp5H4MiwtkbfuZF3UNHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofZgqyOL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C7C606A31C;
	Wed, 18 Nov 2026 19:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofZgqyOL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C498A1F000C4;
	Wed, 18 Nov 2026 19:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031079;
	bh=aXU66Rl7L2bI2+++V/swlCEPE7nYkkfkbkbKwJ4ark4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofZgqyOL+HF8rH+lSX4TW3ODzS4HvL+pKTbElFJG6wwdGKU0o0c1Dow+1s7Gs1+46
	 G4KSCkWCG4gNep6fcnX+GXU6ZlJnQtQtsi23pX3NnCltZXUYAjz6p8GVqHgLDqA6XQ
	 S0SxPagTndP5QbKX8mOIrATn0mcE7lHirNK6Fhrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Wang <li.wang@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0932/1756] selftests/cgroup: skip test_zswap if zswap is globally disabled
Date: Wed, 18 Nov 2026 15:50:59 +0100
Message-ID: <20261118150047.057701441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Wang <li.wang@linux.dev>

[ Upstream commit 9f40c3cdf0fa3011c3a15f8acc0b9ffb3ed11171 ]

Patch series "selftests/cgroup: improve zswap tests robustness and support
large page sizes", v7.

This patchset aims to fix various spurious failures and improve the
overall robustness of the cgroup zswap selftests.

The primary motivation is to make the tests compatible with architectures
that use non-4K page sizes (such as 64K on ppc64le and arm64).  Currently,
the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.
On 64K page size systems, these hardcoded values lead to sub-page
granularity accesses, incorrect page count calculations, and insufficient
memory pressure to trigger zswap writeback, ultimately causing the tests
to fail.

Additionally, this series addresses OOM kills occurring in
test_swapin_nozswap by dynamically scaling memory limits, and prevents
spurious test failures when zswap is built into the kernel but globally
disabled.

This patch (of 8):

test_zswap currently only checks whether zswap is present by testing
/sys/module/zswap.  This misses the runtime global state exposed in
/sys/module/zswap/parameters/enabled.

When zswap is built/loaded but globally disabled, the zswap cgroup
selftests run in an invalid environment and may fail spuriously.

Check the runtime enabled state before running the tests:
  - skip if zswap is not configured,
  - fail if the enabled knob cannot be read,
  - skip if zswap is globally disabled.

Also print a hint in the skip message on how to enable zswap.

Link: https://lore.kernel.org/20260424040059.12940-1-li.wang@linux.dev
Link: https://lore.kernel.org/20260424040059.12940-2-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 0567c7eaefd7 ("selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 3af3608bf578c..aed674269c269 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -15,6 +15,9 @@
 #include "../kselftest.h"
 #include "cgroup_util.h"
 
+#define PATH_ZSWAP "/sys/module/zswap"
+#define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+
 static int read_int(const char *path, size_t *value)
 {
 	FILE *file;
@@ -725,9 +728,18 @@ struct zswap_test {
 };
 #undef T
 
-static bool zswap_configured(void)
+static void check_zswap_enabled(void)
 {
-	return access("/sys/module/zswap", F_OK) == 0;
+	char value[2];
+
+	if (access(PATH_ZSWAP, F_OK))
+		ksft_exit_skip("zswap isn't configured\n");
+
+	if (read_text(PATH_ZSWAP_ENABLED, value, sizeof(value)) <= 0)
+		ksft_exit_fail_msg("Failed to read " PATH_ZSWAP_ENABLED "\n");
+
+	if (value[0] == 'N')
+		ksft_exit_skip("zswap is disabled (hint: echo 1 > " PATH_ZSWAP_ENABLED ")\n");
 }
 
 int main(int argc, char **argv)
@@ -740,8 +752,7 @@ int main(int argc, char **argv)
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
-	if (!zswap_configured())
-		ksft_exit_skip("zswap isn't configured\n");
+	check_zswap_enabled();
 
 	/*
 	 * Check that memory controller is available:
-- 
2.53.0



