Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34562221547;
	Tue,  8 Apr 2025 12:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116621; cv=none; b=UkLYLg9FmEipoiZFIL2F5hv5Rc/fK1hPKnbR4KTYIMrtlRLJ2C2uFekpXI+yPnC4E17yTFtKDkpfJ6t8kg29jhaJZ/qJjAAxF2QHNGDQHTbTcxPtnXvHzj0xCr7ISHpQ7ICsYEhhOFj5mKpVa4bZeMES/lZJ7aHFM4hKPl6s9TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116621; c=relaxed/simple;
	bh=nj8nh31SyM7RuTvN/FtnTg0YCAqQUWGiWc2VvTkCYwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcQaTIyjAqyV+y0nsJQDTphTgq8DJcWnpOJHAe8973C56u2JyI3XiVuo7P4zEizsbXfQysZo2C+zhz63nk0/e1bfdvBccdJYPqQj9NI9/8nOcq+Te7YnsRSIXCfYO6giwg9y7UAxszGo89Awpf3eERPAlVRrZe13q2VuYoOXtGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUnLWbmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUnLWbmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92689C4AF09;
	Tue,  8 Apr 2025 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116621;
	bh=nj8nh31SyM7RuTvN/FtnTg0YCAqQUWGiWc2VvTkCYwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUnLWbmtFzEclofDWMBYOsArXf19cr5VCGP/nnDLahpp7l3GSfishuKPZS1OO96Y1
	 hSKTO0iHCXo7BH+SGNk4MG5Fm3KaEBtqLUXhjkbmzAkmOJB67+eZx0WA/zOsULRP/z
	 8ZXyLxHbNNyjBGT+F8HXs2Mv8LoVZqDNrzsvUqOs=
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
Subject: [PATCH 6.12 206/423] selftests/mm/cow: fix the incorrect error handling
Date: Tue,  8 Apr 2025 12:48:52 +0200
Message-ID: <20250408104850.532796252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1238e1c5aae15..d87c5b1763ff1 100644
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



