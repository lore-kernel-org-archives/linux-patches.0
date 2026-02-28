Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E895333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301803; cv=none; b=lejZ1GTUOiYNGKDHONYmi7ScUpONNPmhfDlvOInNVF/gjwk2ECLbB+bWKk17qwZhkAPPR03yQ/ouVpBOlFrcRkryO3e+9cY73V6gwlmud9L6r560rXeOb9CeIWP6IB07hg7Dvxo/7akXg14mgDjVnfTnKVBkJrTvWHsxBC977Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301803; c=relaxed/simple;
	bh=OSzEXNpcSOoNCoYZSaKx0tEUDzrnkqB7rQk1+DfVUf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdtjaL4wSHQW8lvzdlMKvnd8uVt53g9F+oDpGVtzsqnAoVrCWaa3Vp383E0DzDjawCtqbh2baRk7YPH0BdYhR//S49vvqjsv1yNtbgImdmmNmLdB84kGqIGrOGL6LsIietksLSzZVHboZWDx9sc7hrexYVPDA2fc/wpBFWcS3TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7/CS+YC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7/CS+YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C738C19425;
	Sat, 28 Feb 2026 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301802;
	bh=OSzEXNpcSOoNCoYZSaKx0tEUDzrnkqB7rQk1+DfVUf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7/CS+YC98OcOpbXSBKE+5Wksg6Ncd+shnxy3d+upfNYhfTDlK0/JfgdqW9mEl99P
	 drjyYGRfn00E1raWR+gP+yfj9pXkQ66QwAJ9BJnv5/Y9huLqfUyP2C9v7XnBMWYKBY
	 Qx08FIErURY9atm29A+GGvSnErvDQRLAxmVvL56vfw5ZBj64JxX6QCZcWq/7vqg49l
	 Z5R2Yv9UNx/QWH/daBFRRh6SHdnoMDOvVnwzQJs0MxkgEUcw9hKzPL6tUMBAwVt0ov
	 JlVUFXpIwi2pGlggxBldrivtzvcJuYl6Tbk4vk1UWqVACJYPk0PG05QjyMzu3e0g8e
	 +GaZe6iqR1kfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Siddarth G <siddarthsgml@gmail.com>,
	David Binderman <dcb314@hotmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/385] selftests/mm: convert page_size to unsigned long
Date: Sat, 28 Feb 2026 12:57:17 -0500
Message-ID: <20260228180011.1568201-215-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Siddarth G <siddarthsgml@gmail.com>

[ Upstream commit 0bf19a357e0eaf03e757ac9482c45a797e40157a ]

Cppcheck warning:
int result is assigned to long long variable. If the variable is long long
to avoid loss of information, then you have loss of information.

This patch changes the type of page_size from 'unsigned int' to
'unsigned long' instead of using ULL suffixes. Changing hpage_size to
'unsigned long' was considered, but since gethugepage() expects an int,
this change was avoided.

Link: https://lkml.kernel.org/r/20250403101345.29226-1-siddarthsgml@gmail.com
Signed-off-by: Siddarth G <siddarthsgml@gmail.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Closes: https://lore.kernel.org/all/AS8PR02MB10217315060BBFDB21F19643E9CA62@AS8PR02MB10217.eurprd02.prod.outlook.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7e938f00b003 ("selftests/mm: fix faulting-in code in pagemap_ioctl test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index c3b0f6bf9d0b2..805017fd9bdbf 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -34,7 +34,7 @@
 #define PAGEMAP "/proc/self/pagemap"
 int pagemap_fd;
 int uffd;
-unsigned int page_size;
+unsigned long page_size;
 unsigned int hpage_size;
 const char *progname;
 
@@ -184,7 +184,7 @@ void *gethugetlb_mem(int size, int *shmid)
 
 int userfaultfd_tests(void)
 {
-	int mem_size, vec_size, written, num_pages = 16;
+	long mem_size, vec_size, written, num_pages = 16;
 	char *mem, *vec;
 
 	mem_size = num_pages * page_size;
@@ -213,7 +213,7 @@ int userfaultfd_tests(void)
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 				vec_size - 2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
 	if (written < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", written, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", written, errno, strerror(errno));
 
 	ksft_test_result(written == 0, "%s all new pages must not be written (dirty)\n", __func__);
 
@@ -995,7 +995,7 @@ int unmapped_region_tests(void)
 {
 	void *start = (void *)0x10000000;
 	int written, len = 0x00040000;
-	int vec_size = len / page_size;
+	long vec_size = len / page_size;
 	struct page_region *vec = malloc(sizeof(struct page_region) * vec_size);
 
 	/* 1. Get written pages */
@@ -1051,7 +1051,7 @@ static void test_simple(void)
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
-	int ret, fd, i, buf_size;
+	long ret, fd, i, buf_size;
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
@@ -1160,7 +1160,7 @@ int sanity_tests(void)
 
 	ret = stat(progname, &sbuf);
 	if (ret < 0)
-		ksft_exit_fail_msg("error %d %d %s\n", ret, errno, strerror(errno));
+		ksft_exit_fail_msg("error %ld %d %s\n", ret, errno, strerror(errno));
 
 	fmem = mmap(NULL, sbuf.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
 	if (fmem == MAP_FAILED)
-- 
2.51.0

