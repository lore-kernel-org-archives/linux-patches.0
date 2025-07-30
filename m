Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8B3442C;
	Wed, 30 Jul 2025 09:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869261; cv=none; b=CY5r0gufOI3CkZg1hWB6nzE/32Ga4fzfVpv6+yEj837EBoTHz8lSGa7O0zbhtt2VFyhXztraIpnhDdAFs+xvhKkkWxdHiscdrZcZh1SeOAZVwwnNNwuTz3xq+BeljMEL7ITAer1kJAuJx0SyTbyX7qbnev0/VnEFg1euOT7WnpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869261; c=relaxed/simple;
	bh=4mCSbOo6ZMLOJ4zx5qgPJUF56ieFg8VNb5GhPEw678Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrCJzBZR/cCmvrK2u/V6otn4G5bG+8blZyqiGbRATTwg37fwwkzvspAtVFSkivgy9Y1avT7BY2e9vCQsyC5Mo9z0w/5n7cv9xUvSNjLlgdsrhLaS7ykdXgh6zYXt4S7vqDXbrlyKnl/9sI+jRCQcLVsmXtUM+QXEq9ROl75ZDbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I82Bk0Cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I82Bk0Cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9779C4CEF5;
	Wed, 30 Jul 2025 09:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869260;
	bh=4mCSbOo6ZMLOJ4zx5qgPJUF56ieFg8VNb5GhPEw678Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I82Bk0Cvlaxl7bczjHD5P7bU6fC8LC4CdFqaUitx4WgjJYUPEoUj071Ar/oMmf7kg
	 u8SahZHMemRDc4l3AOZevFiZizqCaEgiNEt7Vs/rSccQb7HK6P7J+EnOde2YNQw84d
	 FR9wDfsHq6NkHQRZayGaQzZfAnR2gAgD9FTmt1mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mariano Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 77/92] selftests/mm: fix split_huge_page_test for folio_split() tests
Date: Wed, 30 Jul 2025 11:36:25 +0200
Message-ID: <20250730093233.737855508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

commit 7563fcbfd484b347b776aeed4d7dac78b30884aa upstream.

PID_FMT does not have an offset field, so folio_split() tests are not
performed.  Add PID_FMT_OFFSET with an offset field and use it to perform
folio_split() tests.

Link: https://lkml.kernel.org/r/20250709012800.3225727-1-ziy@nvidia.com
Fixes: 80a5c494c89f ("selftests/mm: add tests for folio_split(), buddy allocator like split")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Tested-by : Donet Tom <donettom@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index aa7400ed0e99..f0d9c035641d 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -31,6 +31,7 @@ uint64_t pmd_pagesize;
 #define INPUT_MAX 80
 
 #define PID_FMT "%d,0x%lx,0x%lx,%d"
+#define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
 #define PATH_FMT "%s,0x%lx,0x%lx,%d"
 
 #define PFN_MASK     ((1UL<<55)-1)
@@ -483,7 +484,7 @@ void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
 		write_debugfs(PID_FMT, getpid(), (uint64_t)addr,
 			      (uint64_t)addr + fd_size, order);
 	else
-		write_debugfs(PID_FMT, getpid(), (uint64_t)addr,
+		write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)addr,
 			      (uint64_t)addr + fd_size, order, offset);
 
 	for (i = 0; i < fd_size; i++)
-- 
2.50.1



