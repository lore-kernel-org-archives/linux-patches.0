Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ABE39FF0;
	Tue,  9 Jan 2024 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZQX2GDJ0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+xFq1Hzs6ZMEXR3IaJ3R5iqNT2e+lkxXYYSGqTZgKE8=; b=ZQX2GDJ0aLQdyf5gQCZAwBVDXa
	vgyTFsYlka1Sp7s7tyA5LbnAgBfLcYmyisdAfT9yb1zZkyFILPAfG2VlK5vJDUfXPZP9PecKeIvo5
	QbyPFgzHyPSYEF3MJR4zlPWJ9Qn9wyUbV+t7C+sXtCDflcAk1xA1pMNOAAWBh/g0LNmJhWiqe5Sn3
	WCpjC0lRO6AYJHMvdzbK/5YvI1dll9bYRzp1D5B9HAKc5OcK19xWmog4rKSGIuho9GciryCRTx8AA
	ogMt+sEDMHqtDfLc8xgyRxPWnmOA6SRvQ4TWtLgnOgsKjjw0NzaSa6fZJ/jKaTWcxEtYtzpjnaY1P
	tFqHpVYQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rNDNJ-008ZiT-1W;
	Tue, 09 Jan 2024 14:46:41 +0000
Date: Tue, 9 Jan 2024 06:46:41 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-modules@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Marco Pagani <marpagan@redhat.com>, Kevin Hao <haokexin@gmail.com>,
	mcgrof@kernel.org
Subject: [GIT PULL] Modules changes for v6.8-rc1
Message-ID: <ZZ1cUcINeJMJNyft@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

The following changes since commit ceb6a6f023fd3e8b07761ed900352ef574010bcb:

  Linux 6.7-rc6 (2023-12-17 15:19:28 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.8-rc1

for you to fetch changes up to 4515d08a742c76612b65d2f47a87d12860519842:

  kernel/module: improve documentation for try_module_get() (2023-12-21 10:26:14 -0800)

----------------------------------------------------------------
Modules changes for v6.8-rc1

Just one cleanup and one documentation improvement change. No functional
changes. However, this has been tested on linux-next for over 1 month.

----------------------------------------------------------------
Kevin Hao (1):
      module: Remove redundant TASK_UNINTERRUPTIBLE

Marco Pagani (1):
      kernel/module: improve documentation for try_module_get()

 include/linux/module.h | 2 +-
 kernel/module/dups.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
