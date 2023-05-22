Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73908174D7
	for <patches@lists.linux.dev>; Mon, 22 May 2023 21:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=lgwgkKphjKuNEo7Tr++pS92dVhSi4mt6dhb3zTnc5ZM=; b=Up1fJHA8qOJ/GynsDnyeXvX16c
	VjQg611vyFCCHXU5pA344acKSQz0Cj/XlM7gVdEbVxoQWatGRlUx78fbvdbO4ziKfxVIWG9Ny5rzS
	tQxe+HzlFLGrhUJnq70OqXkTUl/aDgYytw5ERk31yg7stNLYMOkeCOM0DfGboqm84MfOusDMFUi1/
	lyjJYKRMh5co0oNz//pawT6N4lgkylzcRPv804MzjC4NsTOXN4hpdV//CT1CBEPIxc02tSui+BI4Q
	mortKszM5LV455CnYuRJ1AEQQmgWHVuyrD2xsneSyhVpBf4Z+nhVVwU99wOhHOZQMTV5AOltPhn8W
	jay2W9Og==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q1D5z-00866Z-0j;
	Mon, 22 May 2023 21:29:35 +0000
Date: Mon, 22 May 2023 14:29:35 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: torvalds@linux-foundation.org, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: harshit.m.mogalapalli@oracle.com, song@kernel.org, mcgrof@kernel.org
Subject: [GIT PULL] Modules fixes for v6.4-rc4
Message-ID: <ZGvev3uX1SjH+7od@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

The following changes since commit 44c026a73be8038f03dbdeef028b642880cf1511:

  Linux 6.4-rc3 (2023-05-21 14:05:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.4-rc4

for you to fetch changes up to d36f6efbe0cb422fe1e4475717d75f3737088832:

  module: Fix use-after-free bug in read_file_mod_stats() (2023-05-22 14:13:13 -0700)

----------------------------------------------------------------
modules-6.4-rc4

Only one fix has tricked through by Harshit Mogalapalli found through
static analysis with smatch.

----------------------------------------------------------------
Harshit Mogalapalli (1):
      module: Fix use-after-free bug in read_file_mod_stats()

 kernel/module/stats.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
