Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F481D555;
	Thu, 23 May 2024 13:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470131; cv=none; b=bxKlbLNvHZb45F8dOpYSgeKOhCbeoBxq7DZUtcgIQkEcUIdFbpJ94Kd6uhi7I9j76ecuNI+N+3bGnHGmL2Nsjgea3NIhSVcsFrkRwKJX7EGZVuHe0HgFvM0kkVCizEFozsG4J4PSSJMUtcvc2dpYW+vqVBTJj/HGNyLq5Uckxxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470131; c=relaxed/simple;
	bh=F5tKArjgzWol1N7VvRwqGTHiszfWq39KMvtl3cn3r6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iryv1YxQWtrxuNlSjii3S8IpD88h0JUa2PPPPyVZcuBY+pb7icqcbqocTzRL+uxxA75mjhzz6haT7aoK7BbA85TNKKD2RH9z6IISzH+nbymsFmNIDLjzvvJs1woRVVSSvQWwNnhh5plnBUoiKgGiWPJb7pkFiXJ25ptEW6KC17Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cs5CrHxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cs5CrHxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02DDC3277B;
	Thu, 23 May 2024 13:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470131;
	bh=F5tKArjgzWol1N7VvRwqGTHiszfWq39KMvtl3cn3r6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cs5CrHxN/6jWnJjg+d0kT742/NBLt1woOfaFxzthYiGO4hz9S5EX8Z9m0O5jPBU/5
	 lfye6mf57eDq2mzFuRaSSj1AKk50O9ODfYVbzEVl0sJV80dZ6eaoe6KrmfM19q6/e9
	 5UphInYTneG4hCFXU/RgjN0aHqjOrXrbNeUVFDlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"sashal@kernel.org, vegard.nossum@oracle.com, darren.kenny@oracle.com, Harshit Mogalapalli" <harshit.m.mogalapalli@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.4 03/16] Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"
Date: Thu, 23 May 2024 15:12:36 +0200
Message-ID: <20240523130325.873879406@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------


This reverts commit 47c68edecca26f0e29b25d26500afd62279951b0 which is
commit 91b80cc5b39f00399e8e2d17527cad2c7fa535e2 upstream.

map_hugetlb.c:18:10: fatal error: vm_util.h: No such file or directory
   18 | #include "vm_util.h"
      |          ^~~~~~~~~~~
compilation terminated.

vm_util.h is not present in 5.4.y, as commit:642bc52aed9c ("selftests:
vm: bring common functions to a new file") is not present in stable
kernels <=6.1.y

Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
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


