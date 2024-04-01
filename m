Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5B043AD6;
	Mon,  1 Apr 2024 16:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987515; cv=none; b=G1pghV1VVYIqs7Y0CutlIM016RusacKDPXul+a+9GAM37HT5DySxPiIaHl1/V07bmTKUDo68yHPjiUIepMhDcbGdjtAK2k+iTnIycJaH/xHm7FkbBCbLI0d/4PbRdgKsHj/suNlJqvhEIB6r+aeAoVIKuEXqCAXfW1TZRerFO4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987515; c=relaxed/simple;
	bh=/1mbhlcuqyoP/bVqMiAq3hHCDPxY2XVDUvO3l9QOCY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCYI7q2e9cWe5RIom5CTdc3NpjSADhbgEsFjeXFNDj9fZnZqvU+7Fc0TXpM3lOLClMV/MFr/Lo0DnzpdpjTDmZA240jW1I80ksKNYHDEKD/yDqR0qqRxlfhLfGZHMkqVx+ULmeIRkYf3wc1ll++tlk2f/JQYX+p3lc4LoumILm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17DlP4GH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17DlP4GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DECC433C7;
	Mon,  1 Apr 2024 16:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987515;
	bh=/1mbhlcuqyoP/bVqMiAq3hHCDPxY2XVDUvO3l9QOCY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17DlP4GHrH4C4m/O1O8RNcoKfi21SX8eKegWtT9DrYcazKDbc8WwPQ/e/PVxwVxXb
	 pXFlTg8nyXkSja4xTtUAtDzbnLX1ARwtu7zhllzyW1iuHLiPtQHAEdvCwWcOiV8WNI
	 b6rqGE1abqjE1C11zGglO0GlkZDxScAbpBNG2/hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 310/399] selftests/mm: sigbus-wp test requires UFFD_FEATURE_WP_HUGETLBFS_SHMEM
Date: Mon,  1 Apr 2024 17:44:36 +0200
Message-ID: <20240401152558.441099793@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Liaw <edliaw@google.com>

commit 105840ebd76d8dbc1a7d734748ae320076f3201e upstream.

The sigbus-wp test requires the UFFD_FEATURE_WP_HUGETLBFS_SHMEM flag for
shmem and hugetlb targets.  Otherwise it is not backwards compatible with
kernels <5.19 and fails with EINVAL.

Link: https://lkml.kernel.org/r/20240321232023.2064975-1-edliaw@google.com
Fixes: 73c1ea939b65 ("selftests/mm: move uffd sig/events tests into uffd unit tests")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1427,7 +1427,8 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_fn = uffd_sigbus_wp_test,
 		.mem_targets = MEM_ALL,
 		.uffd_feature_required = UFFD_FEATURE_SIGBUS |
-		UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+		UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
 	},
 	{
 		.name = "events",


