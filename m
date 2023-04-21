Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613E1612D
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=u68XQLIrnZKRacEesRmgMeebDfY2xepEp8VfzdXWDIU=; b=v2Yysw6qnZCKZGHYViYMSlL9PX
	OuzBIdMXAZi9a0Aylm9+m6X0SUR9QfSRQWt6BR+i2NRETsZ6Q+SXuK9lQy5WU4zsg8hL/d+3/HxHP
	7u16cxddAAH0Levxw7QkEhPJYgLzQoxh9mTY0sW8D3nWNOMD2kKhBNI1vNdffgVDXr/2T8c82Y5qU
	E9eADBnb7SD7yl0vil3K123jE0aHFhVSxq7uYbW8KiUJfJMdOCsVvAmqdVYeer9l8ep8otFOWRNnY
	KtLnYHU/vkUk7ZqjMNP+nGPPo4GBK2IqyC7H5LPrFjy8QpCc92ciVZUd47CkvDBUuKvVuqlD5AieX
	QRQ0Q9rQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1ppwtU-00BlaV-1S;
	Fri, 21 Apr 2023 19:58:08 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	hch@infradead.org,
	djwong@kernel.org,
	minchan@kernel.org,
	senozhatsky@chromium.org
Cc: patches@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com,
	drbd-dev@lists.linbit.com,
	linux-kernel@vger.kernel.org,
	willy@infradead.org,
	hare@suse.de,
	p.raghav@samsung.com,
	da.gomez@samsung.com,
	kbusch@kernel.org,
	mcgrof@kernel.org
Subject: [PATCH 0/5] block: simplify with PAGE_SECTORS_SHIFT
Date: Fri, 21 Apr 2023 12:58:02 -0700
Message-Id: <20230421195807.2804512-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

A bit of block drivers have their own incantations with
PAGE_SHIFT - SECTOR_SHIFT. Just simplfy and use PAGE_SECTORS_SHIFT
all over.

Based on linux-next next-20230421.

Luis Chamberlain (5):
  dm integrity: simplify by using PAGE_SECTORS_SHIFT
  drbd: use PAGE_SECTORS_SHIFT and PAGE_SECTORS
  iomap: simplify iomap_init() with PAGE_SECTORS
  dm bufio: simplify by using PAGE_SECTORS_SHIFT
  zram: use generic PAGE_SECTORS and PAGE_SECTORS_SHIFT

 drivers/block/drbd/drbd_bitmap.c |  4 ++--
 drivers/block/zram/zram_drv.c    | 12 ++++++------
 drivers/block/zram/zram_drv.h    |  2 --
 drivers/md/dm-bufio.c            |  4 ++--
 drivers/md/dm-integrity.c        | 10 +++++-----
 fs/iomap/buffered-io.c           |  2 +-
 6 files changed, 16 insertions(+), 18 deletions(-)

-- 
2.39.2

