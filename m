Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7806D2063FD;
	Tue,  8 Apr 2025 12:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114966; cv=none; b=Nw/jEPMlNxl3Ta+h1ypKscCf+tPrJbSKlEUrNdnUOsI131w0rJa2bEo8NDd7Gf7w0tAx+lmpjZDaGo2y+lpd7j/Ni+XoeOsnXv2PWKV3oLILAV89H5KptrMLmFHTThMhmJj9pKuY0+TRNYA4ov+y33Jjp5I0h8d15FNBHBxUwiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114966; c=relaxed/simple;
	bh=eBs7kEOC8KflaI76iGZH1wa7ESreeVjpuf8BEfBmQkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwg3Ymt5sfHBxWz8uLi8D2pIeh6AEMrP41K0aDPUqoIJtIV9sw0nJpE1IDT2yBS4kpfvw9Mm++zTBU9MMWEy6QIVdjVX0b0A1OqqcfgvdoRtal6wcwpIm3iFXMG8bpc8m9/myKQ776s4nO1BvxHPcl31oG5M3Sbe9SHYN8NidcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFAlkRrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFAlkRrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C2FC4CEE5;
	Tue,  8 Apr 2025 12:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114966;
	bh=eBs7kEOC8KflaI76iGZH1wa7ESreeVjpuf8BEfBmQkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFAlkRrqZIMxV7PJDJo/jPG5fBa5Sa+kiq/H69BndRdOuLM3cLxTk3+5kH0hvPHm2
	 tuzPoXKJb8hYSwKn6zmUM7leNUpa2d0TRj4frBCJIAO69v3COxN82SfDbcC+8QHV7D
	 lhVOoNvgnKM/HsjSdbvBYmO9ZszzE+90HbpRItso=
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
Subject: [PATCH 6.13 251/499] selftests/mm/cow: fix the incorrect error handling
Date: Tue,  8 Apr 2025 12:47:43 +0200
Message-ID: <20250408104857.476328531@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



