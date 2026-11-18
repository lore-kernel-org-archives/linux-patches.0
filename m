Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031193;
	b=JPmZ2ogGPXfLXrJj1HkjXC/mbJSWMv5sQHBvrMwkWtBuobbprsvAPxVRuxAO7eDMNhKo
	 PrW7o+BjWd5/xvlMLMVz7xkI7XIyMc3lvXQ6LkWPQMuWk8qKYvtFc4OtO7QT5yLZ9iiyS
	 47yOaCHmKwIE6dIgTapxSSRucdlqxL/2kH1qws9jTnBEJLavUgRYAUd7FEsBhQDIvm6XC
	 p6Bw+QFvz7kGpy/FcNwJ8ONCweSOMGLzpi970msf1583XM0UdlB0ZJvcMwdCUtgwiBciQ
	 8RjXJRWFFyWa8lFIktlEa/V8/UQEtFCVzID4BJohTA0WhYl41MEglZ0qNBmMVsfb1Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dvchromslR3dGAJf0HA1lrsp7tJbut6nX8ek1ezKmJk=;
	b=LXN9HPZiHf420LNTbZZVjTxzzsDHoDlK7Dsz/hUy8VINv0iGzsXxyVhFZJLvIni++2N7
	 ibsHpSF7hB66sDIo4Hhiye1HlsKfqsJH547DMfzLg4chB6snejF/3I3t5yiunvQCuSo8R
	 q6KngMTY5GqTaon0vJNJ/Gxshfcx6ElpjjT9zAVmNjwtwN9NcavfLLlYGebS5b5+BHq0n
	 e0CADOydEsYWpfKebCb4q2rDAxUfOjb8QfqFsA0CQCBAa/jj+zBwYwh2QILmb+1eyewcj
	 8eBO63k5RYukAG9QkgIGfgGnKAlU4ubfvoyDgaN/FTz8q/y4O+Y4i67jRPC+gBzpcGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4hWfouJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A74606A31C;
	Wed, 18 Nov 2026 19:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4hWfouJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B7B1F000C5;
	Wed, 18 Nov 2026 19:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031193;
	bh=dvchromslR3dGAJf0HA1lrsp7tJbut6nX8ek1ezKmJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4hWfouJOZAvrjG62E4b+fJQAeZjGgbQT5FS6N+Whzi1GSZ4MezOu5SkjBDRi5yB8
	 +e5AIJ3Eb4zrYNphCZGLsijrHbWrR8Q8AVnu8c/h4E3xL0L+r9guX315ODcXuFzh9S
	 vA1+dDAqQGc2jMUfq+zzRemz20HlkZs2AMNVOb0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Sebastian Chlad <sebastian.chlad@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0930/1756] selftests/cgroup: conform test to KTAP format output
Date: Wed, 18 Nov 2026 15:50:57 +0100
Message-ID: <20261118150046.978962900@linuxfoundation.org>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

[ Upstream commit 1dc830ee4c155bff572a43a66b948e1c46483d6a ]

Conform the layout, informational and status messages to KTAP.  No
functional change is intended other than the layout of output messages.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Suggested-by: Sebastian Chlad <sebastian.chlad@suse.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 0567c7eaefd7 ("selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_core.c       | 7 ++++---
 tools/testing/selftests/cgroup/test_cpu.c        | 7 ++++---
 tools/testing/selftests/cgroup/test_cpuset.c     | 7 ++++---
 tools/testing/selftests/cgroup/test_freezer.c    | 7 ++++---
 tools/testing/selftests/cgroup/test_kill.c       | 7 ++++---
 tools/testing/selftests/cgroup/test_kmem.c       | 7 ++++---
 tools/testing/selftests/cgroup/test_memcontrol.c | 7 ++++---
 tools/testing/selftests/cgroup/test_zswap.c      | 7 ++++---
 8 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 3b982a3ef547a..61878a45740f7 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -899,8 +899,10 @@ struct corecg_test {
 int main(int argc, char *argv[])
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), &nsdelegate)) {
 		if (setup_named_v1_root(root, sizeof(root), CG_NAMED_NAME))
 			ksft_exit_skip("cgroup v2 isn't mounted and could not setup named v1 hierarchy\n");
@@ -922,12 +924,11 @@ int main(int argc, char *argv[])
 			ksft_test_result_skip("%s\n", tests[i].name);
 			break;
 		default:
-			ret = EXIT_FAILURE;
 			ksft_test_result_fail("%s\n", tests[i].name);
 			break;
 		}
 	}
 
 	cleanup_named_v1_root(root);
-	return ret;
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index dad2ed82f3ef7..f60a5d8102a7c 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -698,8 +698,10 @@ struct cpucg_test {
 int main(int argc, char *argv[])
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -716,11 +718,10 @@ int main(int argc, char *argv[])
 			ksft_test_result_skip("%s\n", tests[i].name);
 			break;
 		default:
-			ret = EXIT_FAILURE;
 			ksft_test_result_fail("%s\n", tests[i].name);
 			break;
 		}
 	}
 
-	return ret;
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/cgroup/test_cpuset.c b/tools/testing/selftests/cgroup/test_cpuset.c
index 4034d14ba69ac..8086d2ea394f6 100644
--- a/tools/testing/selftests/cgroup/test_cpuset.c
+++ b/tools/testing/selftests/cgroup/test_cpuset.c
@@ -247,8 +247,10 @@ struct cpuset_test {
 int main(int argc, char *argv[])
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -265,11 +267,10 @@ int main(int argc, char *argv[])
 			ksft_test_result_skip("%s\n", tests[i].name);
 			break;
 		default:
-			ret = EXIT_FAILURE;
 			ksft_test_result_fail("%s\n", tests[i].name);
 			break;
 		}
 	}
 
-	return ret;
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
index 8730645d363a7..2d348b894bbf0 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -825,8 +825,10 @@ struct cgfreezer_test {
 int main(int argc, char *argv[])
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
@@ -838,11 +840,10 @@ int main(int argc, char *argv[])
 			ksft_test_result_skip("%s\n", tests[i].name);
 			break;
 		default:
-			ret = EXIT_FAILURE;
 			ksft_test_result_fail("%s\n", tests[i].name);
 			break;
 		}
 	}
 
-	return ret;
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/cgroup/test_kill.c b/tools/testing/selftests/cgroup/test_kill.c
index 0e5bb6c7307a5..ed590b150a17a 100644
--- a/tools/testing/selftests/cgroup/test_kill.c
+++ b/tools/testing/selftests/cgroup/test_kill.c
@@ -274,8 +274,10 @@ struct cgkill_test {
 int main(int argc, char *argv[])
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
@@ -287,11 +289,10 @@ int main(int argc, char *argv[])
 			ksft_test_result_skip("%s\n", tests[i].name);
 			break;
 		default:
-			ret = EXIT_FAILURE;
 			ksft_test_result_fail("%s\n", tests[i].name);
 			break;
 		}
 	}
 
-	return ret;
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 4f5dbedbce757..bc48b294cbe0f 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -418,8 +418,10 @@ struct kmem_test {
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -443,11 +445,10 @@ int main(int argc, char **argv)
 			ksft_test_result_skip("%s\n", tests[i].name);
 			break;
 		default:
-			ret = EXIT_FAILURE;
 			ksft_test_result_fail("%s\n", tests[i].name);
 			break;
 		}
 	}
 
-	return ret;
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index d817aec949fe4..4ca5c5fd7af5c 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1649,8 +1649,10 @@ struct memcg_test {
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int i, proc_status, ret = EXIT_SUCCESS;
+	int i, proc_status;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -1684,11 +1686,10 @@ int main(int argc, char **argv)
 			ksft_test_result_skip("%s\n", tests[i].name);
 			break;
 		default:
-			ret = EXIT_FAILURE;
 			ksft_test_result_fail("%s\n", tests[i].name);
 			break;
 		}
 	}
 
-	return ret;
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 40de679248b89..656125c5b4758 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -597,8 +597,10 @@ static bool zswap_configured(void)
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -625,11 +627,10 @@ int main(int argc, char **argv)
 			ksft_test_result_skip("%s\n", tests[i].name);
 			break;
 		default:
-			ret = EXIT_FAILURE;
 			ksft_test_result_fail("%s\n", tests[i].name);
 			break;
 		}
 	}
 
-	return ret;
+	ksft_finished();
 }
-- 
2.53.0



