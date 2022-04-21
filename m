Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6BB3D6D
	for <patches@lists.linux.dev>; Thu, 21 Apr 2022 23:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9CAC385A7;
	Thu, 21 Apr 2022 23:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1650584155;
	bh=0saNveK0MxhvPf4d1SYMocPo57hTU9uX4KMm4m3Ue5Q=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=mUUWIIE/WDFo1ABXAeSqZ/ITgxk8haRigHVnbxYyyEsxrwo6musD4bxr2KFwUIgMZ
	 3Nuk7fG5qJ+HaZq2spFaWHMBLY6PtMP1pVH5XfK1lzAoXRY8kDpNDZzqQxYNApoLxX
	 E4U2I1gA6vQJIwkJfHHACmXHsykPXWe6HeOOFs6E=
Date: Thu, 21 Apr 2022 16:35:55 -0700
To: skhan@linuxfoundation.org,sidhartha.kumar@oracle.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220421163508.66028a9ac2d9fb6ea05b1342@linux-foundation.org>
Subject: [patch 08/13] selftest/vm: support xfail in mremap_test
Message-Id: <20220421233555.CB9CAC385A7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: selftest/vm: support xfail in mremap_test

Use ksft_test_result_xfail for the tests which are expected to fail.

Link: https://lkml.kernel.org/r/20220420215721.4868-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/mremap_test.c~selftest-vm-support-xfail-in-mremap_test
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -268,7 +268,7 @@ static void run_mremap_test_case(struct
 
 	if (remap_time < 0) {
 		if (test_case.expect_failure)
-			ksft_test_result_pass("%s\n\tExpected mremap failure\n",
+			ksft_test_result_xfail("%s\n\tExpected mremap failure\n",
 					      test_case.name);
 		else {
 			ksft_test_result_fail("%s\n", test_case.name);
_
