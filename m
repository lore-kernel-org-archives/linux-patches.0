Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E12342E42C;
	Sat, 12 Sep 2026 15:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226220; cv=none; b=b0uCMGIaJXOiGTGAHJitCs3FRonDzihrRbSS7Q2OiymTeyP3+UlMCgWbXK06gInb5pWoqYfJHR0mlQNegVt+SAr60jze+d/ByCCiD0erA0S69akHrWlvJweF5H0FPWkcUhjzA76I2ZSYOP5YUxZ2C4v4hr5y9KNAHgx15DjBDgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226220; c=relaxed/simple;
	bh=CJ/2G+9C+DkaqnSvfA4bsy+1v0lthCGn1bDkNHtLL3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmJDhyhnafmwmmvDK+sfYQ0vI+m+qoYYCkmHM2kfv/v7l8l+mSUWN6l8zNipUYDnqvD1MX/iyDfr+QTKHoYzr3SPc2DVCFL1xSJg0QvBwK9RYb/TEMmzZH5y6yWD0ZI+I0vjxgdrS7O9hqg48rz8WC6GavPKWNv6ft57dG5kIks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtDATcsh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtDATcsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C781F00893;
	Sat, 12 Sep 2026 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226214;
	bh=5xxQxazbvGrjrf7SJ6y6Dhp0/4UTn1LB6HeTUj77BWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtDATcsh+be17fR/ttBJ4zAxQfJtKvgiwRvXeQBI5j57YfYixRlfYuNAyRLzZOyno
	 11INgNMov+ud8P2zJ4GRLhO5b8OHr2OJJN/lv8XZq0YQRllNTrasEWtpgdSXCZlqZ+
	 U0HJzIQsbyUlsIXtBjZrxnVFrb+jyXpWdP5nmq3s=
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
Subject: [PATCH 6.6 1356/1424] selftests/mm/cow: modify the incorrect checking parameters
Date: Sat, 12 Sep 2026 09:03:08 +0200
Message-ID: <20260912065637.629952263@linuxfoundation.org>
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
index b5f174c520a30..91fe96f11adf8 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1435,7 +1435,7 @@ static void run_with_zeropage(non_anon_test_fn fn, const char *desc)
 	}
 
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANON, -1, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1536,7 +1536,7 @@ static void run_with_memfd(non_anon_test_fn fn, const char *desc)
 		goto close;
 	}
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1587,7 +1587,7 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 		goto close;
 	}
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1637,7 +1637,7 @@ static void run_with_memfd_hugetlb(non_anon_test_fn fn, const char *desc,
 		goto close;
 	}
 	smem = mmap(NULL, hugetlbsize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1649,7 +1649,7 @@ static void run_with_memfd_hugetlb(non_anon_test_fn fn, const char *desc,
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



