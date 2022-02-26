Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A37A367F
	for <patches@lists.linux.dev>; Sat, 26 Feb 2022 03:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11E0C340E7;
	Sat, 26 Feb 2022 03:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1645845021;
	bh=X9K1RtKXnTPztiBiPSH1TdtbY3ruIsuPnQZPoa8WRx4=;
	h=Date:From:To:Cc:Subject:From;
	b=kkK13gk8ZAr5j4ZGnI+2juMqgXoJVmRcylApvpMIz8gf0Kc0mbKSevg7Gjm1jPWNb
	 QIw7Hlmdi5QmczRMN3+YZzVrfrvDjW2auMGLaU5Qt78JLXWo2gTUnY+R5o5EPX/14B
	 BOBtLxK7LoMunDtDwd2MM0WrU85RdP6uCZNXHfXc=
Date: Fri, 25 Feb 2022 19:10:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org, patches@lists.linux.dev
Subject: incoming
Message-Id: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

12 patches, based on c47658311d60be064b839f329c0e4d34f5f0735b.

Subsystems affected by this patch series:

  MAINTAINERS
  mm/hugetlb
  mm/kasan
  mm/hugetlbfs
  mm/pagemap
  mm/selftests
  mm/memcg
  m/slab
  mailmap
  memfd

Subsystem: MAINTAINERS

    Luis Chamberlain <mcgrof@kernel.org>:
      MAINTAINERS: add sysctl-next git tree

Subsystem: mm/hugetlb

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      mm/hugetlb: fix kernel crash with hugetlb mremap

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: test: prevent cache merging in kmem_cache_double_destroy

Subsystem: mm/hugetlbfs

    Liu Yuntao <liuyuntao10@huawei.com>:
      hugetlbfs: fix a truncation issue in hugepages parameter

Subsystem: mm/pagemap

    Suren Baghdasaryan <surenb@google.com>:
      mm: fix use-after-free bug when mm->mmap is reused after being freed

Subsystem: mm/selftests

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      selftest/vm: fix map_fixed_noreplace test failure

Subsystem: mm/memcg

    Roman Gushchin <roman.gushchin@linux.dev>:
      MAINTAINERS: add Roman as a memcg co-maintainer

    Vladimir Davydov <vdavydov.dev@gmail.com>:
      MAINTAINERS: remove Vladimir from memcg maintainers

    Shakeel Butt <shakeelb@google.com>:
      MAINTAINERS: add Shakeel as a memcg co-maintainer

Subsystem: m/slab

    Vlastimil Babka <vbabka@suse.cz>:
      MAINTAINERS, SLAB: add Roman as reviewer, git tree

Subsystem: mailmap

    Roman Gushchin <roman.gushchin@linux.dev>:
      mailmap: update Roman Gushchin's email

Subsystem: memfd

    Mike Kravetz <mike.kravetz@oracle.com>:
      selftests/memfd: clean up mapping in mfd_fail_write

 .mailmap                                         |    3 +
 MAINTAINERS                                      |    6 ++
 lib/test_kasan.c                                 |    5 +-
 mm/hugetlb.c                                     |   11 ++---
 mm/mmap.c                                        |    1 
 tools/testing/selftests/memfd/memfd_test.c       |    1 
 tools/testing/selftests/vm/map_fixed_noreplace.c |   49 +++++++++++++++++------
 7 files changed, 56 insertions(+), 20 deletions(-)

