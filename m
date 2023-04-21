Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5A46FBB
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hmvMFrifaP2CWzwzaleGenI7Qmq7A3BDCDXiJa7DZeY=; b=PPDW9v79Yn0Yj4ggnf7g8Mg9q5
	Xtl7diAuW97jY5PnrakPeKx7uEQritarSJ5Gy6GeiZKStBUOWkuqgoi2ruOuqQt8wRD8LH5r3jzFM
	1TqV+37Fs6Y24l1+JsPwzN5IYGgcCOdgYYejZpB1GtTwrlpp6Nu0hWrIsmytKQxPVb4kEobOD2hL6
	/l0IFzM7poLdy5jK5pZZWVKxfurtC0xwjMBvNGWDaEWzFOWcTBB/p7F+L2GKWhtaoYF96Qj3AALTI
	Oi6Otl6ldN6hH+qNoTIBLDC/qTCgXrQtH5ZgqPsm0RrQZj6/zPyrIWxvLeyNztXQS0FsjDsYZzZsT
	E44jXZfw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1ppwtU-00Blab-1s;
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
Subject: [PATCH 3/5] iomap: simplify iomap_init() with PAGE_SECTORS
Date: Fri, 21 Apr 2023 12:58:05 -0700
Message-Id: <20230421195807.2804512-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230421195807.2804512-1-mcgrof@kernel.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Just use the PAGE_SECTORS generic define. This produces no functional
changes. While at it use left shift to simplify this even further.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 063133ec77f4..ba2824f405df 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1819,7 +1819,7 @@ EXPORT_SYMBOL_GPL(iomap_writepages);
 
 static int __init iomap_init(void)
 {
-	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
+	return bioset_init(&iomap_ioend_bioset, PAGE_SECTORS << 2,
 			   offsetof(struct iomap_ioend, io_inline_bio),
 			   BIOSET_NEED_BVECS);
 }
-- 
2.39.2

