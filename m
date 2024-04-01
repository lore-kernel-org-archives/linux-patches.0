Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706201C0DE7;
	Mon,  1 Apr 2024 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989110; cv=none; b=PCsZr//pgcRxBVX75fK3Pk9mWQLA/1CujpZUzf+coyqkjg2ODrs6+hnoAc+mIDrrjjKk98XLZ5EBp3XWAObIfBXGtBHEJXReWo5osU3wLbmlGQy7e0uJpTBhvpxAnVLuWiF7Fw1zDgm2I1yv2SBozkn2Jzsk9XFQCH1MKX01Ylg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989110; c=relaxed/simple;
	bh=yDAdTphUbZj/6lrTr6EF+oWf9jqvvzvk04L9Wipt9gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VL5b4szbV6268njr+01qRO/VJBiUFNYfaJcc12+Rs1sNCUQFfDSJ5xCZ6vcgi/t3Ce/jBc2x87tki/HzSgFgY18PVFa1x4k+7jI4vQ2+3eCmU53pvGgFfkYwPsuj3eqVYm2i8s7YbDGee7cGKGvo7u8NkwFJylPlaUfF3eqF8Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joeb4JSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joeb4JSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1F7C433F1;
	Mon,  1 Apr 2024 16:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989110;
	bh=yDAdTphUbZj/6lrTr6EF+oWf9jqvvzvk04L9Wipt9gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joeb4JSeJ+tamzyLBesmJoyAYK/VCQzqm3Ayk1feKk+rqU141U7nXSLKzT3/RkyE9
	 tBAbZCVZEbHvFTXfjWYoWAKYIoimRO1q0pajcWG0UpecszjGDTJkufs/IOSSV9w56d
	 YlpReeyczc9vCYyOw+H6xS55l55xd8ss73/6tzOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 355/432] selftests/mm: sigbus-wp test requires UFFD_FEATURE_WP_HUGETLBFS_SHMEM
Date: Mon,  1 Apr 2024 17:45:42 +0200
Message-ID: <20240401152603.839917737@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1219,7 +1219,8 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_fn = uffd_sigbus_wp_test,
 		.mem_targets = MEM_ALL,
 		.uffd_feature_required = UFFD_FEATURE_SIGBUS |
-		UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+		UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
 	},
 	{
 		.name = "events",


