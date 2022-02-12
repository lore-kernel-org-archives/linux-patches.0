Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A131B7F
	for <patches@lists.linux.dev>; Sat, 12 Feb 2022 00:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01571C340E9;
	Sat, 12 Feb 2022 00:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1644625677;
	bh=U02EXqB0acs/7+GSj9r6GCfbLswYmkOwVuP9SYslxXw=;
	h=Date:From:To:Cc:Subject:From;
	b=u1VkPY3myDbqMqb7Ag1AjEFEVzoBSx0pNJF1wSGEVNR+O8NzzuTucRqWnHs32Pqm/
	 LoFPOwfIcK90ud/J9Fe2wx+i5mNbcYiFmg0WccecZr/2gC+T/ODkre4Zc0OeUFrvRh
	 cFNVDtGG5Xu1024NA87Uu7RFwQcgtvbw4unrEh10=
Date: Fri, 11 Feb 2022 16:27:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, patches@lists.linux.dev
Subject: incoming
Message-Id: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

5 patches, based on f1baf68e1383f6ed93eb9cff2866d46562607a43.

Subsystems affected by this patch series:

  binfmt
  procfs
  mm/vmscan
  mm/memcg
  mm/kfence

Subsystem: binfmt

    Mike Rapoport <rppt@linux.ibm.com>:
      fs/binfmt_elf: fix PT_LOAD p_align values for loaders

Subsystem: procfs

    Yang Shi <shy828301@gmail.com>:
      fs/proc: task_mmu.c: don't read mapcount for migration entry

Subsystem: mm/vmscan

    Mel Gorman <mgorman@suse.de>:
      mm: vmscan: remove deadlock due to throttling failing to make progress

Subsystem: mm/memcg

    Roman Gushchin <guro@fb.com>:
      mm: memcg: synchronize objcg lists with a dedicated spinlock

Subsystem: mm/kfence

    Peng Liu <liupeng256@huawei.com>:
      kfence: make test case compatible with run time set sample interval

 fs/binfmt_elf.c            |    2 +-
 fs/proc/task_mmu.c         |   40 +++++++++++++++++++++++++++++++---------
 include/linux/kfence.h     |    2 ++
 include/linux/memcontrol.h |    5 +++--
 mm/kfence/core.c           |    3 ++-
 mm/kfence/kfence_test.c    |    8 ++++----
 mm/memcontrol.c            |   10 +++++-----
 mm/vmscan.c                |    4 +++-
 8 files changed, 51 insertions(+), 23 deletions(-)

