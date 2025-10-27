Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A04C3016F9;
	Mon, 27 Oct 2025 19:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592547; cv=none; b=P6r85MC7P/6VYPgqWYM1zMU/ZMZ+81N9sVn7sQAZ0EoAHBTt4jA99yRwa1Q9I5AqQeQkgnkaejkXP4zOKEeXZ9bAqrXpZu6IGl4NutzZWsy9JbimP+tCjiROwHkLYkImjP51P/eWs5hmnzC0oWSPpuQXuuC22u4fGXN6vytvc4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592547; c=relaxed/simple;
	bh=hbtwNQ0B81OM5ckwGAyCBrrri9jxJlVs3znbQv08yVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vw6aaosywiikK8JuikCxyeeRoCovXJYbeIxWk5FUwpqRBXMoKPMpb0Ei1bxULrXCijM7cQXgSBE0kmWhk/XqBpgW58pHZ+eBbjoeBvTDKt5BCNPPOXbvEARLzKsnJfW9Uui541wQRgVtgeF96L3j5ijaguNOzDaDsYuXz9YkfM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8EJ3+ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8EJ3+ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1319BC4CEF1;
	Mon, 27 Oct 2025 19:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592547;
	bh=hbtwNQ0B81OM5ckwGAyCBrrri9jxJlVs3znbQv08yVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8EJ3+nsHDFCWqJU58aaySomW3YBekWGi0sRwvmSp+OelpfGkeBqtdK8VlsSThrqR
	 Bq/0qrwgppo+jhQWu/MpCx6VEMJjm42wUY7HyE9E9Nepxr1i8f+ir3taK9MjSyUtPy
	 kcmUeZNHk9xRaCmZ21E+04mNijt3iYTIuCyICcYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, lance.yang@linux.dev, shuah@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Leon Hwang" <leon.hwang@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>
Subject: [PATCH 6.1 155/157] Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"
Date: Mon, 27 Oct 2025 19:36:56 +0100
Message-ID: <20251027183505.453092948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

This reverts commit a584c7734a4dd050451fcdd65c66317e15660e81 which is
commit 91b80cc5b39f00399e8e2d17527cad2c7fa535e2 upstream.

This fixes the following build error:

map_hugetlb.c: In function 'main':
map_hugetlb.c:79:25: warning: implicit declaration of function 'default_huge_page_size' [-Wimplicit-function-declaration]
79 |         hugepage_size = default_huge_page_size();

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vm/map_hugetlb.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/tools/testing/selftests/vm/map_hugetlb.c
+++ b/tools/testing/selftests/vm/map_hugetlb.c
@@ -15,7 +15,6 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
-#include "vm_util.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
@@ -71,16 +70,10 @@ int main(int argc, char **argv)
 {
 	void *addr;
 	int ret;
-	size_t hugepage_size;
 	size_t length = LENGTH;
 	int flags = FLAGS;
 	int shift = 0;
 
-	hugepage_size = default_huge_page_size();
-	/* munmap with fail if the length is not page aligned */
-	if (hugepage_size > length)
-		length = hugepage_size;
-
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
 	if (argc > 2) {


