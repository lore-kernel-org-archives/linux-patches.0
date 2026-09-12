Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8171A44AB60;
	Sat, 12 Sep 2026 10:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209935; cv=none; b=XOndb+ttRjRznPyj3165BmhJafZGBsf0iW+C+mHRB9I8XE5UrFjec+PsYXXrlOlGqo961sE+2yu1ke7ZLHSrvmnQbx5to1SJ9eczbBZNtuD/9wVhZU/dXzcH0/N0T4LNyYJgqBPj4GbXUQW+TKuYaif+v7Y3ZqBQIbZxKQQMPpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209935; c=relaxed/simple;
	bh=N8ZlormQd5SCuZMp8saD5Is5JC+kxqesdJ89mDMzlOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WP9tjzvvU33yFP9dvpVaq5kPkuDSjN+YJq+5S+p3y/XFAO5MOiCk4Uh/WgxczVm/QpjpjYd3syZ/q/YTsW34pxJuLm5k/4RDIks8GY+Wo5JYeRljR1W+dMEt4Qf0BXSOrGIU3g7g4kAfx5ut3Yg0PSuA9QlQqEzYEVFwdv96Djk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzm9qRps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzm9qRps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8881F000FF;
	Sat, 12 Sep 2026 10:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209933;
	bh=bRJrmKqCxERPBvIrCFPTp98KfDwyEk1qVfDnnMVr2q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzm9qRpsgMKhLkrwM0ACkLFWNqjZvWDwdA1zWqNNkDc+DTsKll9kPTHgPghQLjj1J
	 DOMqZRNAY3M0Qyd/Fxlu6nePlTLQ828Gdq6XrcOLU3UhvTdnKhTEMISCEbX8DNiZkW
	 /Rt92sW28EEGYtMv7BBIsauxHD3DKQVe3OF/W1K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Donet Tom <donettom@linux.ibm.com>,
	Mark Brown <broonie@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Luiz Capitulino <luizcap@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Liam Howlett <liam@infradead.org>,
	Li Wang <li.wang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0881/1518] selftests/mm: ksm_tests: use kselftest framework
Date: Sat, 12 Sep 2026 08:50:50 +0200
Message-ID: <20260912065643.379735371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 4cc68d5f52de9614e2db70f43c52f012d1ebb5ad ]

Convert ksm_tests to use kselftest framework for reporting and tracking
successful and failing runs.

Link: https://lore.kernel.org/20260511162840.375890-16-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 15828a150c58 ("selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/ksm_tests.c | 180 +++++++++++--------------
 1 file changed, 81 insertions(+), 99 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index b77462b5c240b..fb62a36f9a786 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -175,12 +175,12 @@ static void  *allocate_memory(void *ptr, int prot, int mapping, char data, size_
 	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
 
 	if (!map_ptr) {
-		perror("mmap");
+		ksft_perror("mmap");
 		return NULL;
 	}
 	memset(map_ptr, data, map_size);
 	if (mprotect(map_ptr, map_size, prot)) {
-		perror("mprotect");
+		ksft_perror("mprotect");
 		munmap(map_ptr, map_size);
 		return NULL;
 	}
@@ -201,11 +201,11 @@ static int ksm_do_scan(int scan_count, struct timespec start_time, int timeout)
 		if (ksm_read_sysfs(KSM_FP("full_scans"), &cur_scan))
 			return 1;
 		if (clock_gettime(CLOCK_MONOTONIC_RAW, &cur_time)) {
-			perror("clock_gettime");
+			ksft_perror("clock_gettime");
 			return 1;
 		}
 		if ((cur_time.tv_sec - start_time.tv_sec) > timeout) {
-			printf("Scan time limit exceeded\n");
+			ksft_print_msg("Scan time limit exceeded\n");
 			return 1;
 		}
 	}
@@ -218,12 +218,12 @@ static int ksm_merge_pages(int merge_type, void *addr, size_t size,
 {
 	if (merge_type == KSM_MERGE_MADVISE) {
 		if (madvise(addr, size, MADV_MERGEABLE)) {
-			perror("madvise");
+			ksft_perror("madvise");
 			return 1;
 		}
 	} else if (merge_type == KSM_MERGE_PRCTL) {
 		if (prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0)) {
-			perror("prctl");
+			ksft_perror("prctl");
 			return 1;
 		}
 	}
@@ -242,7 +242,7 @@ static int ksm_unmerge_pages(void *addr, size_t size,
 			     struct timespec start_time, int timeout)
 {
 	if (madvise(addr, size, MADV_UNMERGEABLE)) {
-		perror("madvise");
+		ksft_perror("madvise");
 		return 1;
 	}
 	return 0;
@@ -324,7 +324,7 @@ static int check_ksm_merge(int merge_type, int mapping, int prot,
 	struct timespec start_time;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 
@@ -338,7 +338,6 @@ static int check_ksm_merge(int merge_type, int mapping, int prot,
 
 	/* verify that the right number of pages are merged */
 	if (assert_ksm_pages_count(page_count)) {
-		printf("OK\n");
 		munmap(map_ptr, page_size * page_count);
 		if (merge_type == KSM_MERGE_PRCTL)
 			prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
@@ -346,7 +345,6 @@ static int check_ksm_merge(int merge_type, int mapping, int prot,
 	}
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_FAIL;
 }
@@ -358,7 +356,7 @@ static int check_ksm_unmerge(int merge_type, int mapping, int prot, int timeout,
 	int page_count = 2;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 
@@ -380,13 +378,11 @@ static int check_ksm_unmerge(int merge_type, int mapping, int prot, int timeout,
 
 	/* check that unmerging was successful and 0 pages are currently merged */
 	if (assert_ksm_pages_count(0)) {
-		printf("OK\n");
 		munmap(map_ptr, page_size * page_count);
 		return KSFT_PASS;
 	}
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_FAIL;
 }
@@ -398,7 +394,7 @@ static int check_ksm_zero_page_merge(int merge_type, int mapping, int prot, long
 	struct timespec start_time;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 
@@ -425,12 +421,10 @@ static int check_ksm_zero_page_merge(int merge_type, int mapping, int prot, long
 	else if (!use_zero_pages && !assert_ksm_pages_count(page_count))
 		goto err_out;
 
-	printf("OK\n");
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_PASS;
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_FAIL;
 }
@@ -465,16 +459,16 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 	int first_node;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 
 	if (numa_available() < 0) {
-		perror("NUMA support not enabled");
+		ksft_print_msg("NUMA support not enabled\n");
 		return KSFT_SKIP;
 	}
 	if (numa_num_configured_nodes() <= 1) {
-		printf("At least 2 NUMA nodes must be available\n");
+		ksft_print_msg("At least 2 NUMA nodes must be available\n");
 		return KSFT_SKIP;
 	}
 	if (ksm_write_sysfs(KSM_FP("merge_across_nodes"), merge_across_nodes))
@@ -485,7 +479,7 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 	numa1_map_ptr = numa_alloc_onnode(page_size, first_node);
 	numa2_map_ptr = numa_alloc_onnode(page_size, get_next_mem_node(first_node));
 	if (!numa1_map_ptr || !numa2_map_ptr) {
-		perror("numa_alloc_onnode");
+		ksft_perror("numa_alloc_onnode");
 		return KSFT_FAIL;
 	}
 
@@ -510,13 +504,11 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 
 	numa_free(numa1_map_ptr, page_size);
 	numa_free(numa2_map_ptr, page_size);
-	printf("OK\n");
 	return KSFT_PASS;
 
 err_out:
 	numa_free(numa1_map_ptr, page_size);
 	numa_free(numa2_map_ptr, page_size);
-	printf("Not OK\n");
 	return KSFT_FAIL;
 }
 
@@ -529,7 +521,7 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 	int pagemap_fd, n_normal_pages, n_huge_pages;
 
 	if (!thp_is_enabled()) {
-		printf("Transparent Hugepages not available\n");
+		ksft_print_msg("Transparent Hugepages not available\n");
 		return KSFT_SKIP;
 	}
 
@@ -559,36 +551,35 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 		else
 			n_huge_pages++;
 	}
-	printf("Number of normal pages:    %d\n", n_normal_pages);
-	printf("Number of huge pages:    %d\n", n_huge_pages);
+	ksft_print_msg("Number of normal pages:    %d\n", n_normal_pages);
+	ksft_print_msg("Number of huge pages:    %d\n", n_huge_pages);
 
 	memset(map_ptr, '*', len);
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 	if (ksm_merge_pages(merge_type, map_ptr, map_size, start_time, timeout))
 		goto err_out;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 
 	scan_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
 		       (end_time.tv_nsec - start_time.tv_nsec);
 
-	printf("Total size:    %lu MiB\n", map_size / MB);
-	printf("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
+	ksft_print_msg("Total size:    %lu MiB\n", map_size / MB);
+	ksft_print_msg("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
 	       scan_time_ns % NSEC_PER_SEC);
-	printf("Average speed:  %.3f MiB/s\n", (map_size / MB) /
+	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
 					       ((double)scan_time_ns / NSEC_PER_SEC));
 
 	munmap(map_ptr_orig, len + HPAGE_SIZE);
 	return KSFT_PASS;
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr_orig, len + HPAGE_SIZE);
 	return KSFT_FAIL;
 }
@@ -606,30 +597,29 @@ static int ksm_merge_time(int merge_type, int mapping, int prot, int timeout, si
 		return KSFT_FAIL;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 	if (ksm_merge_pages(merge_type, map_ptr, map_size, start_time, timeout))
 		goto err_out;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 
 	scan_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
 		       (end_time.tv_nsec - start_time.tv_nsec);
 
-	printf("Total size:    %lu MiB\n", map_size / MB);
-	printf("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
+	ksft_print_msg("Total size:    %lu MiB\n", map_size / MB);
+	ksft_print_msg("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
 	       scan_time_ns % NSEC_PER_SEC);
-	printf("Average speed:  %.3f MiB/s\n", (map_size / MB) /
+	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
 					       ((double)scan_time_ns / NSEC_PER_SEC));
 
 	munmap(map_ptr, map_size);
 	return KSFT_PASS;
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, map_size);
 	return KSFT_FAIL;
 }
@@ -646,37 +636,36 @@ static int ksm_unmerge_time(int merge_type, int mapping, int prot, int timeout,
 	if (!map_ptr)
 		return KSFT_FAIL;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 	if (ksm_merge_pages(merge_type, map_ptr, map_size, start_time, timeout))
 		goto err_out;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 	if (ksm_unmerge_pages(map_ptr, map_size, start_time, timeout))
 		goto err_out;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 
 	scan_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
 		       (end_time.tv_nsec - start_time.tv_nsec);
 
-	printf("Total size:    %lu MiB\n", map_size / MB);
-	printf("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
+	ksft_print_msg("Total size:    %lu MiB\n", map_size / MB);
+	ksft_print_msg("Total time:    %ld.%09ld s\n", scan_time_ns / NSEC_PER_SEC,
 	       scan_time_ns % NSEC_PER_SEC);
-	printf("Average speed:  %.3f MiB/s\n", (map_size / MB) /
+	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
 					       ((double)scan_time_ns / NSEC_PER_SEC));
 
 	munmap(map_ptr, map_size);
 	return KSFT_PASS;
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, map_size);
 	return KSFT_FAIL;
 }
@@ -695,24 +684,24 @@ static int ksm_cow_time(int merge_type, int mapping, int prot, int timeout, size
 		return KSFT_FAIL;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 	for (size_t i = 0; i < page_count - 1; i = i + 2)
 		memset(map_ptr + page_size * i, '-', 1);
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		return KSFT_FAIL;
 	}
 
 	cow_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
 		       (end_time.tv_nsec - start_time.tv_nsec);
 
-	printf("Total size:    %lu MiB\n\n", (page_size * page_count) / MB);
-	printf("Not merged pages:\n");
-	printf("Total time:     %ld.%09ld s\n", cow_time_ns / NSEC_PER_SEC,
+	ksft_print_msg("Total size:    %lu MiB\n\n", (page_size * page_count) / MB);
+	ksft_print_msg("Not merged pages:\n");
+	ksft_print_msg("Total time:     %ld.%09ld s\n", cow_time_ns / NSEC_PER_SEC,
 	       cow_time_ns % NSEC_PER_SEC);
-	printf("Average speed:  %.3f MiB/s\n\n", ((page_size * (page_count / 2)) / MB) /
+	ksft_print_msg("Average speed:  %.3f MiB/s\n\n", ((page_size * (page_count / 2)) / MB) /
 					       ((double)cow_time_ns / NSEC_PER_SEC));
 
 	/* Create 2000 pairs of duplicate pages */
@@ -724,30 +713,29 @@ static int ksm_cow_time(int merge_type, int mapping, int prot, int timeout, size
 		goto err_out;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 	for (size_t i = 0; i < page_count - 1; i = i + 2)
 		memset(map_ptr + page_size * i, '-', 1);
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
-		perror("clock_gettime");
+		ksft_perror("clock_gettime");
 		goto err_out;
 	}
 
 	cow_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
 		       (end_time.tv_nsec - start_time.tv_nsec);
 
-	printf("Merged pages:\n");
-	printf("Total time:     %ld.%09ld s\n", cow_time_ns / NSEC_PER_SEC,
+	ksft_print_msg("Merged pages:\n");
+	ksft_print_msg("Total time:     %ld.%09ld s\n", cow_time_ns / NSEC_PER_SEC,
 	       cow_time_ns % NSEC_PER_SEC);
-	printf("Average speed:  %.3f MiB/s\n", ((page_size * (page_count / 2)) / MB) /
+	ksft_print_msg("Average speed:  %.3f MiB/s\n", ((page_size * (page_count / 2)) / MB) /
 					       ((double)cow_time_ns / NSEC_PER_SEC));
 
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_PASS;
 
 err_out:
-	printf("Not OK\n");
 	munmap(map_ptr, page_size * page_count);
 	return KSFT_FAIL;
 }
@@ -765,6 +753,10 @@ int main(int argc, char *argv[])
 	bool use_zero_pages = KSM_USE_ZERO_PAGES_DEFAULT;
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
 	long size_MB = 0;
+	const char *test_descr = "KSM merging";
+
+	ksft_print_header();
+	ksft_set_plan(1);
 
 	while ((opt = getopt(argc, argv, "dha:p:l:z:m:s:t:MUZNPCHD")) != -1) {
 		switch (opt) {
@@ -773,17 +765,13 @@ int main(int argc, char *argv[])
 			break;
 		case 'p':
 			page_count = atol(optarg);
-			if (page_count <= 0) {
-				printf("The number of pages must be greater than 0\n");
-				return KSFT_FAIL;
-			}
+			if (page_count <= 0)
+				ksft_exit_fail_msg("The number of pages must be greater than 0\n");
 			break;
 		case 'l':
 			ksm_scan_limit_sec = atoi(optarg);
-			if (ksm_scan_limit_sec <= 0) {
-				printf("Timeout value must be greater than 0\n");
-				return KSFT_FAIL;
-			}
+			if (ksm_scan_limit_sec <= 0)
+				ksft_exit_fail_msg("Timeout value must be greater than 0\n");
 			break;
 		case 'h':
 			print_help();
@@ -805,19 +793,15 @@ int main(int argc, char *argv[])
 			break;
 		case 's':
 			size_MB = atoi(optarg);
-			if (size_MB <= 0) {
-				printf("Size must be greater than 0\n");
-				return KSFT_FAIL;
-			}
+			if (size_MB <= 0)
+				ksft_exit_fail_msg("Size must be greater than 0\n");
 			break;
 		case 't':
 			{
 				int tmp = atoi(optarg);
 
-				if (tmp < 0 || tmp > KSM_MERGE_LAST) {
-					printf("Invalid merge type\n");
-					return KSFT_FAIL;
-				}
+				if (tmp < 0 || tmp > KSM_MERGE_LAST)
+					ksft_exit_fail_msg("Invalid merge type\n");
 				merge_type = tmp;
 			}
 			break;
@@ -845,82 +829,80 @@ int main(int argc, char *argv[])
 			test_name = KSM_COW_TIME;
 			break;
 		default:
-			return KSFT_FAIL;
+			ksft_exit_fail_msg("Unknown option\n");
 		}
 	}
 
 	if (prot == 0)
 		prot = str_to_prot(KSM_PROT_STR_DEFAULT);
 
-	if (access(KSM_SYSFS_PATH, F_OK)) {
-		printf("Config KSM not enabled\n");
-		return KSFT_SKIP;
-	}
+	if (access(KSM_SYSFS_PATH, F_OK))
+		ksft_exit_skip("Config KSM not enabled\n");
 
-	if (ksm_save_def(&ksm_sysfs_old)) {
-		printf("Cannot save default tunables\n");
-		return KSFT_FAIL;
-	}
+	if (ksm_save_def(&ksm_sysfs_old))
+		ksft_exit_fail_msg("Cannot save default tunables\n");
 
 	if (ksm_write_sysfs(KSM_FP("run"), 2) ||
 	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), 0) ||
 	    numa_available() ? 0 :
 		ksm_write_sysfs(KSM_FP("merge_across_nodes"), 1) ||
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), page_count))
-		return KSFT_FAIL;
+		ksft_exit_fail_msg("Cannot set up KSM tunables\n");
 
 	switch (test_name) {
 	case CHECK_KSM_MERGE:
+		test_descr = "KSM merging";
 		ret = check_ksm_merge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot, page_count,
 				      ksm_scan_limit_sec, page_size);
 		break;
 	case CHECK_KSM_UNMERGE:
+		test_descr = "KSM unmerging";
 		ret = check_ksm_unmerge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 					ksm_scan_limit_sec, page_size);
 		break;
 	case CHECK_KSM_ZERO_PAGE_MERGE:
+		test_descr = "KSM zero page merging";
 		ret = check_ksm_zero_page_merge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 						page_count, ksm_scan_limit_sec, use_zero_pages,
 						page_size);
 		break;
 	case CHECK_KSM_NUMA_MERGE:
+		test_descr = "KSM NUMA merging";
 		ret = check_ksm_numa_merge(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 					ksm_scan_limit_sec, merge_across_nodes, page_size);
 		break;
 	case KSM_MERGE_TIME:
-		if (size_MB == 0) {
-			printf("Option '-s' is required.\n");
-			return KSFT_FAIL;
-		}
+		if (size_MB == 0)
+			ksft_exit_fail_msg("Option '-s' is required\n");
+		test_descr = "KSM merge time";
 		ret = ksm_merge_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 				ksm_scan_limit_sec, size_MB);
 		break;
 	case KSM_MERGE_TIME_HUGE_PAGES:
-		if (size_MB == 0) {
-			printf("Option '-s' is required.\n");
-			return KSFT_FAIL;
-		}
+		if (size_MB == 0)
+			ksft_exit_fail_msg("Option '-s' is required\n");
+		test_descr = "KSM merge time with huge pages";
 		ret = ksm_merge_hugepages_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 				ksm_scan_limit_sec, size_MB);
 		break;
 	case KSM_UNMERGE_TIME:
-		if (size_MB == 0) {
-			printf("Option '-s' is required.\n");
-			return KSFT_FAIL;
-		}
+		if (size_MB == 0)
+			ksft_exit_fail_msg("Option '-s' is required\n");
+		test_descr = "KSM unmerge time";
 		ret = ksm_unmerge_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 				       ksm_scan_limit_sec, size_MB);
 		break;
 	case KSM_COW_TIME:
+		test_descr = "KSM COW time";
 		ret = ksm_cow_time(merge_type, MAP_PRIVATE | MAP_ANONYMOUS, prot,
 				ksm_scan_limit_sec, page_size);
 		break;
 	}
 
-	if (ksm_restore(&ksm_sysfs_old)) {
-		printf("Cannot restore default tunables\n");
-		return KSFT_FAIL;
-	}
+	if (ksm_restore(&ksm_sysfs_old))
+		ksft_print_msg("Cannot restore default tunables\n");
+
+	ksft_test_result_report(ret, "%s\n", test_descr);
 
-	return ret;
+	ksft_finished();
 }
-- 
2.53.0



