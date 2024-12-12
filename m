Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA0421578A;
	Thu, 12 Dec 2024 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016426; cv=none; b=t/ONMnDokuGRmjgZdXko7jYwugvS3dC/4Tt0IPh4xK9aOUqJB3TKrjb6VTvHgiG+wQPMr2e8ygn+Q75r5k6JdEMGYMSy1X11pmciPcvlKV7riGn+gEShJnlzxVA/euxtLxcbjvY13DgiinsdFwb1bJ2XmBgh6fccyZmxHrVPZEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016426; c=relaxed/simple;
	bh=LseStpOer+cB7feGNVTlEPB0OtUlzKjDsQZTxbBMjPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYOl0kV8RD1a3XvGDjFvCIheDONKSEfALpXqD++AxjIAPvsuyC3pmqLGQL2xMYUUup7SLZWABBKw4+DCuYDkWYqCAgLHWu0dEo7X18riBCZSEoKCaljLraqFxoaKGbJHBJF3ON9u+Stxvah2JK6p/T8W/I++mRgWAfHjy5PBXs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTrbmyYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTrbmyYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08470C4CED0;
	Thu, 12 Dec 2024 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016425;
	bh=LseStpOer+cB7feGNVTlEPB0OtUlzKjDsQZTxbBMjPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTrbmyYTvwQoAFKNmx3w1QkYPJw6sQ3L8ojkVxrgtZVuS370IPyxl+q0onZ+vW0xO
	 rSCqDaiRNGxBuq55Z9Rs8If9MtRCyJ8xEJC6XvGKDEH7Od6r9qP0hacSRqbpHfOU9c
	 hNJrEXNXbDZqDI0S5VwJWyPz30ns6wIYVcsfGkus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Donet Tom <donettom@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 165/466] selftest: hugetlb_dio: fix test naming
Date: Thu, 12 Dec 2024 15:55:34 +0100
Message-ID: <20241212144313.322376604@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit 4ae132c693896b0713db572676c90ffd855a4246 upstream.

The string logged when a test passes or fails is used by the selftest
framework to identify which test is being reported.  The hugetlb_dio test
not only uses the same strings for every test that is run but it also uses
different strings for test passes and failures which means that test
automation is unable to follow what the test is doing at all.

Pull the existing duplicated logging of the number of free huge pages
before and after the test out of the conditional and replace that and the
logging of the result with a single ksft_print_result() which incorporates
the parameters passed into the test into the output.

Link: https://lkml.kernel.org/r/20241127-kselftest-mm-hugetlb-dio-names-v1-1-22aab01bf550@kernel.org
Fixes: fae1980347bf ("selftests: hugetlb_dio: fixup check for initial conditions to skip in the start")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/hugetlb_dio.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 432d5af15e66..db63abe5ee5e 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -76,19 +76,15 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 	/* Get the free huge pages after unmap*/
 	free_hpage_a = get_free_hugepages();
 
+	ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
+	ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
+
 	/*
 	 * If the no. of free hugepages before allocation and after unmap does
 	 * not match - that means there could still be a page which is pinned.
 	 */
-	if (free_hpage_a != free_hpage_b) {
-		ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
-		ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
-		ksft_test_result_fail(": Huge pages not freed!\n");
-	} else {
-		ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
-		ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
-		ksft_test_result_pass(": Huge pages freed successfully !\n");
-	}
+	ksft_test_result(free_hpage_a == free_hpage_b,
+			 "free huge pages from %u-%u\n", start_off, end_off);
 }
 
 int main(void)
-- 
2.47.1



