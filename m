Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DAB2690EC;
	Tue,  8 Apr 2025 11:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111681; cv=none; b=LGTXKQD2t9yg2hL04ENH4B5nMsVlYqcj0WT6FKQo4sn/0QqDarcTg9JOFLSBdZT6N6Hf6sXvUeXJJJIfRgkE38jvSNL4yfwksOPVRgMXIxzCBYVozsTlr+U/YMu7FmKm3rcB+1oPYXnNFVMSnViVVhZYGcwwXBUgeCcC6jppH1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111681; c=relaxed/simple;
	bh=RfNKMR4Npiq2QSRSHkgSiXNAI44J+ILJDFIsWpT2taw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MByq0k4Wgu8QXhOR2CEn4JnKd7TuL/wcOkEnQGo8/Zp7VpLniI2MVeW6NmovN7O082MojvGMLLZnDpgbATyx4wF9HREXpuCs4YqMmkOFdKvJno0UwT6SsWlcut1FzhEttDUpCFeCeN/MhIRmnzNTkwrzhGzPTBEg4LCe9OzFMws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJkqDk3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJkqDk3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D65C4CEE5;
	Tue,  8 Apr 2025 11:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111681;
	bh=RfNKMR4Npiq2QSRSHkgSiXNAI44J+ILJDFIsWpT2taw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJkqDk3pW+0rk40oMix7Ok/Atwf16RQq0YCaaauc2giNaRHuDz+c+q7gf+lW5//vN
	 P88bqUveTrYfhpDYBEaFBiD/t4Cd7WgmCpPYoD6Lmy8XQeBiYLQnvwgA+THgkVfYZt
	 G12jCJ4XsJkW597KbJCrf68Ohz4bEEL4J7aZUITc=
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
Subject: [PATCH 6.14 521/731] selftests/mm/cow: fix the incorrect error handling
Date: Tue,  8 Apr 2025 12:46:58 +0200
Message-ID: <20250408104926.391648597@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 9446673645eba..f0cb14ea86084 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -876,7 +876,7 @@ static void do_run_with_thp(test_fn fn, enum thp_run thp_run, size_t thpsize)
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



