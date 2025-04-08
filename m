Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E22267F68;
	Tue,  8 Apr 2025 11:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113356; cv=none; b=u5DtKxx1tM68UBcockggT/2XO3SKtIQEOFYaQnR1r3RAvadaWlIEgDYIfG/gA/lY/Cz5n1g7Requz7IgjmS2HfPlacylruvwM5q/pfEXI5M+PISMB1SXOFT04UE7Nvmymk+/FUTIGuvHLYx9gBiYhhPup+fHB8H8D6mrKQxSp3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113356; c=relaxed/simple;
	bh=SMUl3jO8L24J1lJnGgn4MEios2PeqYOSvETTy2eFWMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTF9awfL36KPWuDcHCrIfbfzXWfaMPhZoLPQYSvt8KEvRpKFXpA1J0ZUR3DeWcg2v14EXV7Jpc8SaKceXsxw5Z+8N/Is7QHD2o5VJlp0AdAmtzhWQlrBofTj68iz2iX3nDacGhvGWLYUIJGYhY5zrB9JKhjTWUw3z6U0OEujxtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNt8W8ik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNt8W8ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6B0C4CEE5;
	Tue,  8 Apr 2025 11:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113356;
	bh=SMUl3jO8L24J1lJnGgn4MEios2PeqYOSvETTy2eFWMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNt8W8ik7PWG9YtaaCNR6Q2EhYx5sWuONdmkmr8UraRUS7VAbZwHzMB1zeDpBmX+C
	 mJSy4mbkhjw/kHWUkETgCz/V8szkGxumQ1sGBivab98N4KCTdaqOo8q0SeAmwvCbUK
	 klkdFWkgGfqae01Jp8RzDYivi2UVUtruYDddIJPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyan Yang <cyan.yang@sifive.com>,
	Dev Jain <dev.jain@arm.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	David Hildenbrand <david@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/268] selftests/mm/cow: fix the incorrect error handling
Date: Tue,  8 Apr 2025 12:49:00 +0200
Message-ID: <20250408104831.985814995@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyan Yang <cyan.yang@sifive.com>

[ Upstream commit f841ad9ca5007167c02de143980c9dc703f90b3d ]

Error handling doesn't check the correct return value.  This patch will
fix it.

Link: https://lkml.kernel.org/r/20250312043840.71799-1-cyan.yang@sifive.com
Fixes: f4b5fd6946e2 ("selftests/vm: anon_cow: THP tests")
Signed-off-by: Cyan Yang <cyan.yang@sifive.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 6f2f839904416..76d37904172db 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -812,7 +812,7 @@ static void do_run_with_thp(test_fn fn, enum thp_run thp_run)
 		mremap_size = thpsize / 2;
 		mremap_mem = mmap(NULL, mremap_size, PROT_NONE,
 				  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-		if (mem == MAP_FAILED) {
+		if (mremap_mem == MAP_FAILED) {
 			ksft_test_result_fail("mmap() failed\n");
 			goto munmap;
 		}
-- 
2.39.5



