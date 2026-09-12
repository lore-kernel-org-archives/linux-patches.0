Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208E447D931;
	Sat, 12 Sep 2026 13:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219149; cv=none; b=qh0QB+6NHOzqJ2DAqxX2rm7xihnUP+2gRmUvG9Zzu3Tm6t/orUxhTJH7Yw5niG/koQBjm1mnGeW7vB4389K2DuuSYk0weM2Ev3CpuFPuJ7wljMNFxN//UOBxdSb1Rqp2HHR9WGhFqLthovq/Kgzl0+nIv2FiHHMxOgK5XteA0bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219149; c=relaxed/simple;
	bh=0g1Spdu4pAwJhPZAauIadNpEC2CaP5h7Zy349nxknxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbTvaWQIkg3DeCk1Xd6XHNAc6X7PW3lqYQ7QI3tnrG3Y+qPAEWjJ3RvkJ3ECaueTzp9GFg2e8iL5ilR+yQItXv9+oV9XIylyvqQ8qLnMaDzElRjR/0Do4cktgZnNg+nG9cZnA3TVfzYRihJeYQmTt4rya+re+nSJDFK6JPLAOig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLeFuULM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLeFuULM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBB71F00893;
	Sat, 12 Sep 2026 13:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219148;
	bh=dSPdrizsHt6vqtOB/+tlErdJQnUnqWg25eGDXWw0t58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLeFuULMVNcWzr18bLClgwQvLrR0mhHNkMD6RfQPtrdNrGwVA3okkPjqeUtD87vH3
	 ng317J70ZUUiHsBy6PBqpDDhr46AFmbnEa2l/arU+tN+pvM8I2WFp7yYuTbMXpsUAP
	 /RGRyuaVTUDdlcmGrTbuMF/zucHiwC3n2uRRbeVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <gehao@kylinos.cn>,
	SeongJae Park <sj@kernel.org>,
	"Shuah Khan (Samsung OSG)" <shuah@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1290/1376] selftests/mm/cow: modify the incorrect checking parameters
Date: Sat, 12 Sep 2026 09:01:56 +0200
Message-ID: <20260912065636.286839021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <gehao@kylinos.cn>

[ Upstream commit bf069012df19cf80b460a03c92bfe6320dc268b0 ]

In run_with_memfd_hugetlb(), some error handle have passed incorrect
parameters.  It should be "smem", but it was mistakenly written as "mem".

Let's fix it.

[gehao@kylinos.cn: fix other errant sites, per Anshuman]
  Link: https://lkml.kernel.org/r/20250113050908.93638-1-hao.ge@linux.dev
Link: https://lkml.kernel.org/r/20250113032858.63670-1-hao.ge@linux.dev
Fixes: f8664f3c4a08 ("selftests/vm: cow: basic COW tests for non-anonymous pages")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 4004c130c358 ("selftests/mm: skip COW tmpfile cases when fallocate() is unsupported")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index d87c5b1763ff1..f0cb14ea86084 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1482,7 +1482,7 @@ static void run_with_zeropage(non_anon_test_fn fn, const char *desc)
 	}
 
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANON, -1, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1583,7 +1583,7 @@ static void run_with_memfd(non_anon_test_fn fn, const char *desc)
 		goto close;
 	}
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1634,7 +1634,7 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 		goto close;
 	}
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1684,7 +1684,7 @@ static void run_with_memfd_hugetlb(non_anon_test_fn fn, const char *desc,
 		goto close;
 	}
 	smem = mmap(NULL, hugetlbsize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1696,7 +1696,7 @@ static void run_with_memfd_hugetlb(non_anon_test_fn fn, const char *desc,
 	fn(mem, smem, hugetlbsize);
 munmap:
 	munmap(mem, hugetlbsize);
-	if (mem != MAP_FAILED)
+	if (smem != MAP_FAILED)
 		munmap(smem, hugetlbsize);
 close:
 	close(fd);
-- 
2.53.0



