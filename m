Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466EA13D2BD;
	Thu, 23 May 2024 13:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470064; cv=none; b=eswbnia8EOU0j9TW1Tapbf8STi7YsPVdeKjGzknyK6KvBeqa8Kc2+KvsHSF5uMXSMpbWTPZRMq0ID70qqFJ7wRnzL5Hd5yKzPLxhbjGxbRZRAfWgiCaIxGnborVjrPW0/Bfwte3ziM1HsqKJR6zXRKIEbTW+e/4rrCasnzeswio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470064; c=relaxed/simple;
	bh=pijBhMmQfByK8w1z3lTYVAEdh1azwlVD/12pwWefrgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecAfrLzaVjKEUto3+HpIgWrFt28+xjXEdyY1Mzk1ZNHQg3aK5rjmRPnYNp++nq689TrlTa1lwB/TZ9qTG+mtj+z19aHx4D52GYWvyNBy4GMgTKcJf8SqBHtcqmC3k6eUiR1UicVYBmJs0SENUco5aC9YS6sZ31aWdAe44pjHvuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atTwlxG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atTwlxG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4E8C2BD10;
	Thu, 23 May 2024 13:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470063;
	bh=pijBhMmQfByK8w1z3lTYVAEdh1azwlVD/12pwWefrgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atTwlxG07ShOfBEjfTl9QZUsQWiE628/IYnaw17bLNRmXEuVaXBVPBnJYJNsRjfIn
	 +VIz0BjBuCxEgx6mPJ0rH5veUJGZ6nqJfR1047YODDOgH/pu2JMYaJa0CLplpW/edr
	 hIvTyO6bWRr92LRjcd2bMQ+4aMoYUAnavXVmdnzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"shuah@kernel.org, sashal@kernel.org, vegard.nossum@oracle.com, darren.kenny@oracle.com, Harshit Mogalapalli" <harshit.m.mogalapalli@oracle.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 4.19 01/18] Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"
Date: Thu, 23 May 2024 15:12:24 +0200
Message-ID: <20240523130325.786232978@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
References: <20240523130325.727602650@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------


This reverts commit abdbd5f3e8c504d864fdc032dd5a4eb481cb12bf which is commit
91b80cc5b39f00399e8e2d17527cad2c7fa535e2 upstream.

map_hugetlb.c:18:10: fatal error: vm_util.h: No such file or directory
   18 | #include "vm_util.h"
      |          ^~~~~~~~~~~
compilation terminated.

vm_util.h is not present in 4.19.y, as commit:642bc52aed9c ("selftests:
vm: bring common functions to a new file") is not present in stable
kernels <=6.1.y

Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
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


