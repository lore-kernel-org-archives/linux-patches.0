Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0642D23BD06;
	Sat, 12 Sep 2026 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224731; cv=none; b=U9OoIl13l6M1A0w1EMGtUB8JBA2DXjBbhXyPxS33q1nmyLIWFAXvj7pwzbX2Fb/sFg8GQBiNNn4zv0q0fsWGvFh7Tr5HI73//W/wY1rB9xQspIAGcmVKHIb3avLLQr7otpOhA5I0BVUe9qEM612OsgP1Gy4UZfeijicKuvZIsmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224731; c=relaxed/simple;
	bh=F5IfreWPGcfFgkzOGTNMngGIzodPekMrptW7PdEzOdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdsDVeFYOFUl0wXQTEIiW+x1NRsIEQPGaoiS7C1cP98nXqxgXXCk9KbgG1HKBlJzCQKZZgDa5nv93BPqvJJM5cxoHSGA0l5TaheiMIxzfd4feaX5RrgsUFLa+/3kfs/W7HrmDQRwEnW0RHnL/xZ3+sZuSJfMVCnrbZKg14F87u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKtoL0zA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKtoL0zA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCBB1F000FF;
	Sat, 12 Sep 2026 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224729;
	bh=rXyHp68RNbTCDWaFNCxaX6kmdGfULOsgFXKMmZCzuU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKtoL0zAMKiIvUCLaIcQhMPxYlID3eGUM9+6AMasHiJgoBlHmTjamOv4iqxhceUGC
	 GkQh2A3cxuvdwiFAVVwJqDszSh1WLHJjgn3cJ3vluxNzDpWEG+xELn0B+IkyZINHAj
	 y5KrhzLTbVhzA2nwHA+cL/r/Ehckv+Rr9OTkc6Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <21cnbao@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1054/1424] selftests: mm: support shmem mTHP collapse testing
Date: Sat, 12 Sep 2026 08:58:06 +0200
Message-ID: <20260912065630.909508205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 2e6d88e9d455fae9c4ac95c893362258f9540dfa ]

Add shmem mTHP collpase testing.  Similar to the anonymous page, users can
use the '-s' parameter to specify the shmem mTHP size for testing.

Link: https://lkml.kernel.org/r/fa44bfa20ca5b9fd6f9163a048f3d3c1e53cd0a8.1724140601.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 15828a150c58 ("selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c   |  4 +-
 tools/testing/selftests/mm/thp_settings.c | 46 ++++++++++++++++++++---
 tools/testing/selftests/mm/thp_settings.h |  9 ++++-
 3 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 829320a519e72..56d4480e8d3cb 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1095,7 +1095,7 @@ static void usage(void)
 	fprintf(stderr,	"\n\tSupported Options:\n");
 	fprintf(stderr,	"\t\t-h: This help message.\n");
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
-	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon allocations.\n");
+	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	exit(1);
 }
 
@@ -1209,6 +1209,8 @@ int main(int argc, char **argv)
 	default_settings.khugepaged.pages_to_scan = hpage_pmd_nr * 8;
 	default_settings.hugepages[hpage_pmd_order].enabled = THP_INHERIT;
 	default_settings.hugepages[anon_order].enabled = THP_ALWAYS;
+	default_settings.shmem_hugepages[hpage_pmd_order].enabled = SHMEM_INHERIT;
+	default_settings.shmem_hugepages[anon_order].enabled = SHMEM_ALWAYS;
 
 	save_settings();
 	thp_push_settings(&default_settings);
diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/thp_settings.c
index a4163438108ec..577eaab6266fd 100644
--- a/tools/testing/selftests/mm/thp_settings.c
+++ b/tools/testing/selftests/mm/thp_settings.c
@@ -33,10 +33,11 @@ static const char * const thp_defrag_strings[] = {
 };
 
 static const char * const shmem_enabled_strings[] = {
+	"never",
 	"always",
 	"within_size",
 	"advise",
-	"never",
+	"inherit",
 	"deny",
 	"force",
 	NULL
@@ -200,6 +201,7 @@ void thp_write_num(const char *name, unsigned long num)
 void thp_read_settings(struct thp_settings *settings)
 {
 	unsigned long orders = thp_supported_orders();
+	unsigned long shmem_orders = thp_shmem_supported_orders();
 	char path[PATH_MAX];
 	int i;
 
@@ -234,12 +236,24 @@ void thp_read_settings(struct thp_settings *settings)
 		settings->hugepages[i].enabled =
 			thp_read_string(path, thp_enabled_strings);
 	}
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & shmem_orders)) {
+			settings->shmem_hugepages[i].enabled = SHMEM_NEVER;
+			continue;
+		}
+		snprintf(path, PATH_MAX, "hugepages-%ukB/shmem_enabled",
+			(getpagesize() >> 10) << i);
+		settings->shmem_hugepages[i].enabled =
+			thp_read_string(path, shmem_enabled_strings);
+	}
 }
 
 void thp_write_settings(struct thp_settings *settings)
 {
 	struct khugepaged_settings *khugepaged = &settings->khugepaged;
 	unsigned long orders = thp_supported_orders();
+	unsigned long shmem_orders = thp_shmem_supported_orders();
 	char path[PATH_MAX];
 	int enabled;
 	int i;
@@ -271,6 +285,15 @@ void thp_write_settings(struct thp_settings *settings)
 		enabled = settings->hugepages[i].enabled;
 		thp_write_string(path, thp_enabled_strings[enabled]);
 	}
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & shmem_orders))
+			continue;
+		snprintf(path, PATH_MAX, "hugepages-%ukB/shmem_enabled",
+			(getpagesize() >> 10) << i);
+		enabled = settings->shmem_hugepages[i].enabled;
+		thp_write_string(path, shmem_enabled_strings[enabled]);
+	}
 }
 
 struct thp_settings *thp_current_settings(void)
@@ -324,17 +347,18 @@ void thp_set_read_ahead_path(char *path)
 	dev_queue_read_ahead_path[sizeof(dev_queue_read_ahead_path) - 1] = '\0';
 }
 
-unsigned long thp_supported_orders(void)
+static unsigned long __thp_supported_orders(bool is_shmem)
 {
 	unsigned long orders = 0;
 	char path[PATH_MAX];
 	char buf[256];
-	int ret;
-	int i;
+	int ret, i;
+	char anon_dir[] = "enabled";
+	char shmem_dir[] = "shmem_enabled";
 
 	for (i = 0; i < NR_ORDERS; i++) {
-		ret = snprintf(path, PATH_MAX, THP_SYSFS "hugepages-%ukB/enabled",
-			(getpagesize() >> 10) << i);
+		ret = snprintf(path, PATH_MAX, THP_SYSFS "hugepages-%ukB/%s",
+			       (getpagesize() >> 10) << i, is_shmem ? shmem_dir : anon_dir);
 		if (ret >= PATH_MAX) {
 			printf("%s: Pathname is too long\n", __func__);
 			exit(EXIT_FAILURE);
@@ -347,3 +371,13 @@ unsigned long thp_supported_orders(void)
 
 	return orders;
 }
+
+unsigned long thp_supported_orders(void)
+{
+	return __thp_supported_orders(false);
+}
+
+unsigned long thp_shmem_supported_orders(void)
+{
+	return __thp_supported_orders(true);
+}
diff --git a/tools/testing/selftests/mm/thp_settings.h b/tools/testing/selftests/mm/thp_settings.h
index 71cbff05f4c7f..876235a23460c 100644
--- a/tools/testing/selftests/mm/thp_settings.h
+++ b/tools/testing/selftests/mm/thp_settings.h
@@ -22,10 +22,11 @@ enum thp_defrag {
 };
 
 enum shmem_enabled {
+	SHMEM_NEVER,
 	SHMEM_ALWAYS,
 	SHMEM_WITHIN_SIZE,
 	SHMEM_ADVISE,
-	SHMEM_NEVER,
+	SHMEM_INHERIT,
 	SHMEM_DENY,
 	SHMEM_FORCE,
 };
@@ -46,6 +47,10 @@ struct khugepaged_settings {
 	unsigned long pages_to_scan;
 };
 
+struct shmem_hugepages_settings {
+	enum shmem_enabled enabled;
+};
+
 struct thp_settings {
 	enum thp_enabled thp_enabled;
 	enum thp_defrag thp_defrag;
@@ -54,6 +59,7 @@ struct thp_settings {
 	struct khugepaged_settings khugepaged;
 	unsigned long read_ahead_kb;
 	struct hugepages_settings hugepages[NR_ORDERS];
+	struct shmem_hugepages_settings shmem_hugepages[NR_ORDERS];
 };
 
 int read_file(const char *path, char *buf, size_t buflen);
@@ -76,5 +82,6 @@ void thp_save_settings(void);
 
 void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
+unsigned long thp_shmem_supported_orders(void);
 
 #endif /* __THP_SETTINGS_H__ */
-- 
2.53.0



