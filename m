Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181C813B790;
	Tue, 27 Feb 2024 13:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040964; cv=none; b=Byf6WlZOGuv2Pigv+mFXDVgUekbYnUYCVmI5+oLfRvg0kp0PED/HbAelitmyob+l+9bbWimKExY/TfSZK94YFD3koyovpb/aPSUvFHFsPVYTfYHhJt9VBavadXDWI1P8dm9nbHIKiFK1mdOlM/XKgR2xeD8s8FmOUTbiDlqijx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040964; c=relaxed/simple;
	bh=SJfQ90QDt2SBYz7YlCVmaVPoHi/+urx+GPUgo9bY5RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhJgQqeGvV1y7F1sWhgaL1C4IOobmJRIEzQjNyzc567xP4M31/XYzNknKt06LbqrAfxF2pe0R2IO3XQ0FQIlWGru2osK7qsy9nWHgL9XuJRQMSgJMRSRZQDVkMJOTDjyoaonxIbHvwg2tPsOpIfT3tK565p5j5jnMRr9LyNmJ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GH7rD8Zy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GH7rD8Zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956B1C433C7;
	Tue, 27 Feb 2024 13:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040964;
	bh=SJfQ90QDt2SBYz7YlCVmaVPoHi/+urx+GPUgo9bY5RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GH7rD8ZypLsWLXgxpInMWdQbZSDy8FCPAOIMcyhGWYF2iqCnXwgX09AhGaVL+aXBa
	 0jRQtW+SUeoJf5pEBtb8RM/MasEJgfPb9FGKYMOheutMiyiKV9VEFkZTK81LkjoSXP
	 ZPsPy1RbWnX3IvU3ak4zGiP4OCeUxQe04CQ6VQ5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 170/334] selftests/mm: uffd-unit-test check if huge page size is 0
Date: Tue, 27 Feb 2024 14:20:28 +0100
Message-ID: <20240227131636.014085964@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Terry Tritton <terry.tritton@linaro.org>

commit 7efa6f2c803366f84c3c362f01e822490669d72b upstream.

If HUGETLBFS is not enabled then the default_huge_page_size function will
return 0 and cause a divide by 0 error. Add a check to see if the huge page
size is 0 and skip the hugetlb tests if it is.

Link: https://lkml.kernel.org/r/20240205145055.3545806-2-terry.tritton@linaro.org
Fixes: 16a45b57cbf2 ("selftests/mm: add framework for uffd-unit-test")
Signed-off-by: Terry Tritton <terry.tritton@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1309,6 +1309,12 @@ int main(int argc, char *argv[])
 				continue;
 
 			uffd_test_start("%s on %s", test->name, mem_type->name);
+			if ((mem_type->mem_flag == MEM_HUGETLB ||
+			    mem_type->mem_flag == MEM_HUGETLB_PRIVATE) &&
+			    (default_huge_page_size() == 0)) {
+				uffd_test_skip("huge page size is 0, feature missing?");
+				continue;
+			}
 			if (!uffd_feature_supported(test)) {
 				uffd_test_skip("feature missing");
 				continue;


