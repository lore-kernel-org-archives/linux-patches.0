Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BEF28E7
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 12:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38934C433EF;
	Tue,  7 Feb 2023 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774720;
	bh=+VjPjuVHt0t3VyhIg/tCTPkpCVqT1d1yEygWeh3VuCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbqsTmQ4IOO7ZxinNn52XD415FVOR3+XE6mPrh9OP+bjJLj/iHvzf+VHCavV6uqEd
	 M9uucP5o3CyESu+H9l0QWFFc4ePQgHvZJL3tcinBfKgzQrRiqvgm1uLImznBXO5dQe
	 IuZuKv4jnP0QDZsu8FWetlPcoAIDsz9Thn6uy+ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	kernel test robot <lkp@intel.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/208] selftests/vm: remove __USE_GNU in hugetlb-madvise.c
Date: Tue,  7 Feb 2023 13:54:26 +0100
Message-Id: <20230207125634.887107692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Xu <peterx@redhat.com>

[ Upstream commit 0ca2c535f5a07f01118a6a70bfab78576e02fcae ]

__USE_GNU should be an internal macro only used inside glibc.  Either
memfd_create() or fallocate() requires _GNU_SOURCE per man page, where
__USE_GNU will further be defined by glibc headers include/features.h:

  #ifdef _GNU_SOURCE
  # define __USE_GNU	1
  #endif

This fixes:

   >> hugetlb-madvise.c:20: warning: "__USE_GNU" redefined
      20 | #define __USE_GNU
         |
   In file included from /usr/include/x86_64-linux-gnu/bits/libc-header-start.h:33,
                    from /usr/include/stdlib.h:26,
                    from hugetlb-madvise.c:16:
   /usr/include/features.h:407: note: this is the location of the previous definition
     407 | # define __USE_GNU      1
         |

Link: https://lkml.kernel.org/r/Y8V9z+z6Tk7NetI3@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/hugetlb-madvise.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/vm/hugetlb-madvise.c b/tools/testing/selftests/vm/hugetlb-madvise.c
index 3c9943131881..b3f01f1f7a60 100644
--- a/tools/testing/selftests/vm/hugetlb-madvise.c
+++ b/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -16,7 +16,6 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/mman.h>
-#define __USE_GNU
 #include <fcntl.h>
 
 #define USAGE	"USAGE: %s <hugepagefile_name>\n"
-- 
2.39.0



