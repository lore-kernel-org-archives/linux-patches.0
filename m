Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847197E
	for <patches@lists.linux.dev>; Sat,  5 Mar 2022 04:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E70C004E1;
	Sat,  5 Mar 2022 04:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1646454503;
	bh=JTkwSc0vpalOWHSBkyxtEKlj7jWpNhkQ9Jwfl5PY1AI=;
	h=Date:From:To:Cc:Subject:From;
	b=Gn6OCfVUPGyS4oAx96YxsTtj+cNxNEEvzwe2uyqoVHF3L3BVddAn3ohBmG5hiNmaZ
	 EAkx5dd0/ykasBO7YcRrvNLnXZka365AO8g2ybtBjS6894zyCWMdNjrBZSLGLQwNxT
	 uUUOhZ/aehFmPpH19XVgnH3xu79uV6tSGJrvNsLE=
Date: Fri, 4 Mar 2022 20:28:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org, patches@lists.linux.dev
Subject: incoming
Message-Id: <20220304202822.d47f8084928321c83070d7d7@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

8 patches, based on 07ebd38a0da24d2534da57b4841346379db9f354.

Subsystems affected by this patch series:

  mm/hugetlb
  mm/pagemap
  memfd
  selftests
  mm/userfaultfd
  kconfig

Subsystem: mm/hugetlb

    Mike Kravetz <mike.kravetz@oracle.com>:
      selftests/vm: cleanup hugetlb file after mremap test

Subsystem: mm/pagemap

    Suren Baghdasaryan <surenb@google.com>:
      mm: refactor vm_area_struct::anon_vma_name usage code
      mm: prevent vm_area_struct::anon_name refcount saturation
      mm: fix use-after-free when anon vma name is used after vma is freed

Subsystem: memfd

    Hugh Dickins <hughd@google.com>:
      memfd: fix F_SEAL_WRITE after shmem huge page allocated

Subsystem: selftests

    Chengming Zhou <zhouchengming@bytedance.com>:
      kselftest/vm: fix tests build with old libc

Subsystem: mm/userfaultfd

    Yun Zhou <yun.zhou@windriver.com>:
      proc: fix documentation and description of pagemap

Subsystem: kconfig

    Qian Cai <quic_qiancai@quicinc.com>:
      configs/debug: set CONFIG_DEBUG_INFO=y properly

 Documentation/admin-guide/mm/pagemap.rst     |    2 
 fs/proc/task_mmu.c                           |    9 +-
 fs/userfaultfd.c                             |    6 -
 include/linux/mm.h                           |    7 +
 include/linux/mm_inline.h                    |  105 ++++++++++++++++++---------
 include/linux/mm_types.h                     |    5 +
 kernel/configs/debug.config                  |    2 
 kernel/fork.c                                |    4 -
 kernel/sys.c                                 |   19 +++-
 mm/madvise.c                                 |   98 +++++++++----------------
 mm/memfd.c                                   |   40 +++++++---
 mm/mempolicy.c                               |    2 
 mm/mlock.c                                   |    2 
 mm/mmap.c                                    |   12 +--
 mm/mprotect.c                                |    2 
 tools/testing/selftests/vm/hugepage-mremap.c |   26 ++++--
 tools/testing/selftests/vm/run_vmtests.sh    |    3 
 tools/testing/selftests/vm/userfaultfd.c     |    1 
 18 files changed, 201 insertions(+), 144 deletions(-)

