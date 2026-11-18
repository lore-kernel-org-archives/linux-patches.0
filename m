Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031190;
	b=e49ZT5EAXyjkPA+XicBZ5l449/2F/pk57lXIxWq3a6LIw4zAWzFblS1EPFeQ9H++cFon
	 dooFs21+566EUzGuW+rjsqBiQQl6+RY1PPuC0ATP7qaz58/bFp7T1mjUCrkbUnFBza80G
	 mCHHSNWlf5TpmDQ6IoJyMoOTF2W3zS3ZJlW6c8C1f8Gzdqf6cBNBX0gHg2n1JDcElHUR3
	 wHPoCB411vA3ZtPcp5dTk4VLTi6Mk1KzG25BWBNRlHyrSspryEn823bc0UO0WyS6C8SbE
	 Bv0DsrD79E6Jmys7tpI5IybR6X3pjtviTO4Rqnn0CeSqq17l5KcVaLac6lttFHoef9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=q41KsbTLyjdErpm6IoVIuIQKMyOtTlhpSLVVY93wtZI=;
	b=DXYSUL9uCUpgam+FoqhTXDpu0hwi6pWoE7tuS/RrkesXAccdi7z3xvjXM9XCH7ftHO2F
	 GVdinOEJCIv2HoLQ2A0MPwx/EFjIFXJ2XllCs6A/qHt9+A4EOo1NpFMq+aIAx0rucLZT9
	 3JGuR3hQnH8l0TeunQLKrZmx3LL4G0MW17H+CDnNpeZe3KmgoV7BpB1kK2WNYEGMzF41t
	 nl2/1PsntDM0j+yiIaiavgTDaF3egNhTMi55TfbjuzD0RoVKD5K2iYGKgfO0njAlkucQn
	 qPmwGzIbE8DbLAuGcVqU9P+WAy18y/tdIXAIpeNXV4L6uKqtS4R5adlIObLs8+nsUHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vJCJnXIW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1289606A320;
	Wed, 18 Nov 2026 19:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vJCJnXIW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BED1F000C5;
	Wed, 18 Nov 2026 19:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031190;
	bh=q41KsbTLyjdErpm6IoVIuIQKMyOtTlhpSLVVY93wtZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJCJnXIWzhFv7K6/+Iiy4lzrqEZT3rWdVxgjviA69iKr6dLlvTp9xUp3/D6VyVJNQ
	 PMwfNnq8aAJHdCImFx09rXr9PfExxGx0N1GPrn9q2WLFZfiD1wrf6+vfXyxuXILe+T
	 Um6XPbzSDcvHvj2nRO21MCsPACGjMsqhU3J5ziNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0929/1756] selftests: cgroup: Optionally set up v1 environment
Date: Wed, 18 Nov 2026 15:50:56 +0100
Message-ID: <20261118150046.936904322@linuxfoundation.org>
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

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit d74cd7864ffa6913f1d70f80858bd3fd19101cdf ]

Use the missing mount of the unifier hierarchy as a hint of legacy
system and prepare our own named v1 hierarchy for tests.

The code is only in test_core.c and not cgroup_util.c because other
selftests are related to controllers which will be exposed on v2
hierarchy but named hierarchies are only v1 thing.

Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 0567c7eaefd7 ("selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_core.c | 44 +++++++++++++++++++++-
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index a5672a91d273c..3b982a3ef547a 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -5,6 +5,8 @@
 #include <linux/sched.h>
 #include <sys/types.h>
 #include <sys/mman.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
 #include <sys/wait.h>
 #include <unistd.h>
 #include <fcntl.h>
@@ -842,6 +844,38 @@ static int test_cgcore_lesser_ns_open(const char *root)
 	return ret;
 }
 
+static int setup_named_v1_root(char *root, size_t len, const char *name)
+{
+	char options[PATH_MAX];
+	int r;
+
+	r = snprintf(root, len, "/mnt/cg_selftest");
+	if (r < 0)
+		return r;
+
+	r = snprintf(options, sizeof(options), "none,name=%s", name);
+	if (r < 0)
+		return r;
+
+	r = mkdir(root, 0755);
+	if (r < 0 && errno != EEXIST)
+		return r;
+
+	r = mount("none", root, "cgroup", 0, options);
+	if (r < 0)
+		return r;
+
+	return 0;
+}
+
+static void cleanup_named_v1_root(char *root)
+{
+	if (!cg_test_v1_named)
+		return;
+	umount(root);
+	rmdir(root);
+}
+
 #define T(x) { x, #x }
 struct corecg_test {
 	int (*fn)(const char *root);
@@ -867,13 +901,18 @@ int main(int argc, char *argv[])
 	char root[PATH_MAX];
 	int i, ret = EXIT_SUCCESS;
 
-	if (cg_find_unified_root(root, sizeof(root), &nsdelegate))
-		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	if (cg_find_unified_root(root, sizeof(root), &nsdelegate)) {
+		if (setup_named_v1_root(root, sizeof(root), CG_NAMED_NAME))
+			ksft_exit_skip("cgroup v2 isn't mounted and could not setup named v1 hierarchy\n");
+		cg_test_v1_named = true;
+		goto post_v2_setup;
+	}
 
 	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
 		if (cg_write(root, "cgroup.subtree_control", "+memory"))
 			ksft_exit_skip("Failed to set memory controller\n");
 
+post_v2_setup:
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
@@ -889,5 +928,6 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	cleanup_named_v1_root(root);
 	return ret;
 }
-- 
2.53.0



