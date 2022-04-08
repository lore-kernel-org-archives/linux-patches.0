Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208A92C80
	for <patches@lists.linux.dev>; Fri,  8 Apr 2022 20:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CC8C385A3;
	Fri,  8 Apr 2022 20:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1649448500;
	bh=DzBefWW+pSyGiUWBaYQgKWvtcwfWsr9G5IY1YZcAVic=;
	h=Date:From:To:Cc:Subject:From;
	b=EFurYwW5mfCnviTTS+t+Ze5p934cWc9l26KfIiMfMdyvkW5KuJ4oydgP6UdKcBcLq
	 0Zd4231vC0PhJ1VxszuSbx4M9ZKhCzhE15y7E+pzaKdcb5W6VOZZurbxrmkai/GDBb
	 FWQRskjei4IDQjcJLTGUej409Uql9RexETR0bCpM=
Date: Fri, 8 Apr 2022 13:08:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, patches@lists.linux.dev
Subject: incoming
Message-Id: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

9 patches, based on d00c50b35101b862c3db270ffeba53a63a1063d9.

Subsystems affected by this patch series:

  mm/migration
  mm/highmem
  lz4
  mm/sparsemem
  mm/mremap
  mm/mempolicy
  mailmap
  mm/memcg
  MAINTAINERS

Subsystem: mm/migration

    Zi Yan <ziy@nvidia.com>:
      mm: migrate: use thp_order instead of HPAGE_PMD_ORDER for new page allocation.

Subsystem: mm/highmem

    Max Filippov <jcmvbkbc@gmail.com>:
      highmem: fix checks in __kmap_local_sched_{in,out}

Subsystem: lz4

    Guo Xuenan <guoxuenan@huawei.com>:
      lz4: fix LZ4_decompress_safe_partial read out of bound

Subsystem: mm/sparsemem

    Waiman Long <longman@redhat.com>:
      mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning

Subsystem: mm/mremap

    Paolo Bonzini <pbonzini@redhat.com>:
      mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)

Subsystem: mm/mempolicy

    Miaohe Lin <linmiaohe@huawei.com>:
      mm/mempolicy: fix mpol_new leak in shared_policy_replace

Subsystem: mailmap

    Vasily Averin <vasily.averin@linux.dev>:
      mailmap: update Vasily Averin's email address

Subsystem: mm/memcg

    Andrew Morton <akpm@linux-foundation.org>:
      mm/list_lru.c: revert "mm/list_lru: optimize memcg_reparent_list_lru_node()"

Subsystem: MAINTAINERS

    Tom Rix <trix@redhat.com>:
      MAINTAINERS: add Tom as clang reviewer

 .mailmap                 |    4 ++++
 MAINTAINERS              |    1 +
 include/linux/mmzone.h   |   11 +++++++----
 lib/lz4/lz4_decompress.c |    8 ++++++--
 mm/highmem.c             |    4 ++--
 mm/list_lru.c            |    6 ------
 mm/mempolicy.c           |    3 ++-
 mm/migrate.c             |    2 +-
 mm/mremap.c              |    3 +++
 9 files changed, 26 insertions(+), 16 deletions(-)

