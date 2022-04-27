Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AE933E5
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 19:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E2BC385A7;
	Wed, 27 Apr 2022 19:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1651088494;
	bh=ZcPpqyn530SIcrlZgLZiGM3NvRYrXDeBHNR87NeFbVs=;
	h=Date:From:To:Cc:Subject:From;
	b=ic8oIYIvUzxWufIKh1/6dyEM+XbxPLA/I4TJF00gZTd02iO3XpDGD85R92cFlJ2jp
	 rRJ29vrcjsxdm1LrgdDbp1LCdixoCz1mAghV9HNSNZMDqK99kFbuCchx1SVXpUZd5s
	 WLRsE089k9+Hw4AYf5MHxtMAE8IWGO8iWwca0xy0=
Date: Wed, 27 Apr 2022 12:41:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, patches@lists.linux.dev
Subject: incoming
Message-Id: <20220427124133.cc115bc8acb8de3dda921836@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

2 patches, based on d615b5416f8a1afeb82d13b238f8152c572d59c0.

Subsystems affected by this patch series:

  mm/kasan
  mm/debug

Subsystem: mm/kasan

    Zqiang <qiang1.zhang@intel.com>:
      kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time

Subsystem: mm/debug

    Akira Yokosawa <akiyks@gmail.com>:
      docs: vm/page_owner: use literal blocks for param description

 Documentation/vm/page_owner.rst |    5 +++--
 mm/kasan/quarantine.c           |    7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

