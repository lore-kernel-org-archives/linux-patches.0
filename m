Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFF718E2F
	for <patches@lists.linux.dev>; Fri, 15 Sep 2023 22:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7Au7GQlleAmj5M8e5CX+OM2MfEjyMcPNx8bLn2lT0zk=; b=i0rFTNFIrhpMybyhkJGOmDs4xP
	oBHzLbvVUXzpm9ZTd/EcCT2Iw9SuWQ79s/UnmZ4WPBsOAOwEYHTSyLdvf6kcvui4XpKnR82hw/5XY
	t67KZYZUm1S0b104aYYCMFlC5dSPvzaBnDgKSKHBb9OmFUFlBRRTFM1OnoT+BjuYEqFWJzEYaGIKF
	XiejQ/wmAcDv5FV8u7wNAlc1idUDBYvGEDs4c+Y8af5dUGeSRk0jMFCkWjGP+dXMaBm4U9gV+y0W9
	UFnqi+X2sRQRqRrJxB6k88JcyoS1qMrCd/M4F8O96+1kXBnPhSWFunceDmRB7FW4H/UWEZi7sFiCF
	XhmBZLQA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qhHXM-00BUtK-2O;
	Fri, 15 Sep 2023 22:43:44 +0000
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
	rohan.puri@samsung.com,
	rpuri.linux@gmail.com,
	kbusch@kernel.org,
	mcgrof@kernel.org
Subject: [PATCH v3 0/4] block: simplify with PAGE_SECTORS_SHIFT
Date: Fri, 15 Sep 2023 15:43:39 -0700
Message-Id: <20230915224343.2740317-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Just spinning these low hanging fruit patches I forgot about.

Changes on v3:

 o Add tags for Reviews/acks
 o rebase onto next-20230914
 o Fixes as suggested by Johannes Thumshirn:
   - drop not-needed parens on dm bufio
   - use SECTOR_MASK instead of PAGE_SECTORS - 1 for the zram driver
 o Drop shmem patches as they are already merged / modified

Changes on v2:
                                                                                                                                                                                              
 o keep iomap math visibly simple                                                                                                                                                             
 o Add tags for Reviews/acks                                                                                                                                                                  
 o rebase onto next-20230525 

Luis Chamberlain (4):
  drbd: use PAGE_SECTORS_SHIFT and PAGE_SECTORS
  iomap: simplify iomap_init() with PAGE_SECTORS
  dm bufio: simplify by using PAGE_SECTORS_SHIFT
  zram: use generic PAGE_SECTORS and PAGE_SECTORS_SHIFT

 drivers/block/drbd/drbd_bitmap.c |  4 ++--
 drivers/block/zram/zram_drv.c    | 15 ++++++---------
 drivers/block/zram/zram_drv.h    |  2 --
 drivers/md/dm-bufio.c            |  4 ++--
 fs/iomap/buffered-io.c           |  2 +-
 5 files changed, 11 insertions(+), 16 deletions(-)

-- 
2.39.2

