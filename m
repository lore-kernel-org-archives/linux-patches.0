Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B36A14B943;
	Thu, 23 May 2024 13:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470191; cv=none; b=Fej2C2XjC3v35UVtT1Jpa5qIBzUMuTVEBGfRnAZsu8m06+kcTKSeaOHDfZGHoXqgOJ4vmy1f98kh9bTVrajU6ZcLmruQWPOjPhfZWHYgm8yH6aO7rwGj1UObPBMwTmDIxHcSjraceEtATIBHN+eOj1mYuTHG4IAEuYetwRRNUNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470191; c=relaxed/simple;
	bh=0G+nFJ+XiMH6Q9DUBahGF8L0U52nSezlAJSjh3xmL7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTMldrm6fra0P+ojQBidlvkHQ0HwB8T7B/JQQRmvgQru/zHf57t5N6cHOusRZc5rlgD7OEaU0sJNNwCrsstnhkeHKcSkHZXjOUH4bbrje7rRCI/g7F10ryR9Sk7rCEbsBtPR753Yfp7eORSqT0gBiytH27MKzopi2udmbKaIc20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j33qogzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j33qogzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4A3C3277B;
	Thu, 23 May 2024 13:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470191;
	bh=0G+nFJ+XiMH6Q9DUBahGF8L0U52nSezlAJSjh3xmL7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j33qogzyPk83O+/EvjLjDgNodXAh0oA2W5YQVQYg5XdEwpbXfsaITUlKzhVMuTMKj
	 pFlg6kZFDEYd7EGc7i1Z5B8XzzEt+uLXUQFZCO9LrIOZaGMZ5QuEDctE4s47OXkAgF
	 pJZWRWNbJUzx/K9NOkqRa8oJrngAVlsLu/JpQxm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"sashal@kernel.org, vegard.nossum@oracle.com, darren.kenny@oracle.com, Harshit Mogalapalli" <harshit.m.mogalapalli@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.10 03/15] Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"
Date: Thu, 23 May 2024 15:12:45 +0200
Message-ID: <20240523130326.584185649@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
References: <20240523130326.451548488@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------


This reverts commit c9c3cc6a13bddc76bb533ad8147a5528cac5ba5a which is
commit 91b80cc5b39f00399e8e2d17527cad2c7fa535e2 upstream.

map_hugetlb.c:18:10: fatal error: vm_util.h: No such file or directory
   18 | #include "vm_util.h"
      |          ^~~~~~~~~~~
compilation terminated.

vm_util.h is not present in 5.10.y, as commit:642bc52aed9c ("selftests:
vm: bring common functions to a new file") is not present in stable
kernels <=6.1.y

Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
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


