Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025688;
	b=nwqlEmtikk5MTTOOnGNaV2B5YZva9DHwnyjoG72RwH+44cp+lfAc0q6nTZ4b0Kmjeoyq
	 8P5qe7BkROGpDQ6L6mn+323aJmTLmFTgdiabmcjNLCV3sLOCKP0wf70K0sl3N/rXQ2c3S
	 zAMdsX8KkPmfT2UXsg7I4vCHdJKjSpMDST+bYk4How+jLbgLOnt63YNF93OKNuJE2SbYx
	 lZupGUPo+CN+O4EhEuGuRcK1ToDFZ7f6nrfRk3WgiHDKIVGf+U2mtqzC4Y0NE7UHABAKJ
	 WTsr+4EFLNuvSw8UtNgEamoa5kHLPfZ7g7dfiW+xi48aPkU8CQ86t2O9qdYp2g4EgXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=exEoKoAmVN6m7lbgR20MRbabn9A7rwpXQZnVFpicezo=;
	b=1fqNOQiE6loEvfwEquiCKcMJXW+z05CJgisSsBSrALgiMc3OytKeaIErMR2cBqQ88bpX
	 CxaYrFFvIWiup30SwS6blHuB5320FNtkPi9McDIW4jeqP5bQyhmu5ZVYVMUFOMNwZl2Tl
	 Qfac9PhgilyTDAvpWFQplA77VMH6t6osI+JLlvCQD38GvCx7Yi4u4QxZsEpCokoqT9O5D
	 TaEJiOENgT7pVt5myWhUNUYaCD3VAJGb7ThKs2IaeMRci+MHbG5EziA5RjDhmLVGBf2V/
	 M/IJw6w088ZO7nVsM6vd0I9jTTnxiJo5UnGHnBxlsKuPKoFmJFNm6G+szqdc4jizB3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i/FP7+tV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40AE606A320;
	Wed, 18 Nov 2026 18:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i/FP7+tV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F8F1F000C4;
	Wed, 18 Nov 2026 18:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025688;
	bh=exEoKoAmVN6m7lbgR20MRbabn9A7rwpXQZnVFpicezo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/FP7+tVwjebW/mfCiG8YO70EMfgKjvQfrwsgIUMvIBvi9EY20MJXhj8nk1dhODKi
	 Zw5vTTa4DmoJYoFPdocFiFhEyNz1a+lY2wkGk9fg106o/9ND36QLYMutajXSKjyER8
	 sY20LHWQsGFVlEuVJzFmnLpSQo9xiD9vGPrqLlvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Sebastian Chlad <sebastian.chlad@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1169/2151] selftests/cgroup: conform test to KTAP format output
Date: Wed, 18 Nov 2026 15:48:24 +0100
Message-ID: <20261118150204.722034756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index a360e2eb2eefd..1d778c8b7764f 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -923,8 +923,10 @@ struct corecg_test {
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
@@ -946,12 +948,11 @@ int main(int argc, char *argv[])
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
index de60967279668..28f90fd30f2ca 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -827,8 +827,10 @@ struct cpucg_test {
 int main(int argc, char *argv[])
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -845,11 +847,10 @@ int main(int argc, char *argv[])
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
index dfb763819581f..465cdad2bfcaf 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -1488,8 +1488,10 @@ struct cgfreezer_test {
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
@@ -1501,11 +1503,10 @@ int main(int argc, char *argv[])
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
index b362eb9f18409..f17e414310d25 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -421,8 +421,10 @@ struct kmem_test {
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int i, ret = EXIT_SUCCESS;
+	int i;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -446,11 +448,10 @@ int main(int argc, char **argv)
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
index e383fad6e5bb3..a8d574f431312 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1659,8 +1659,10 @@ struct memcg_test {
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int i, proc_status, ret = EXIT_SUCCESS;
+	int i, proc_status;
 
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -1694,11 +1696,10 @@ int main(int argc, char **argv)
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
index e1f578ca28416..86a8930b47e3a 100644
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



