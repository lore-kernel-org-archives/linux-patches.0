Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67948AD27
	for <patches@lists.linux.dev>; Fri, 26 May 2023 08:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LD/oWd/+mUj05u7ro37NQInoFL
	QzOw/tkYA8cVHDX+8VYtqDDKsM8OF05TnEUZx6NkzwaoN6OKUQAZJV8bkH41SMqO8dkQiogL53on9
	oGdLGmmKwtwfXwxOgpUBRjTOSi7VN2TtkHQI5QOFNgLJsKY70Td+PpxZPdYun+JdJPmInaFuVTou+
	cxx2GDaEkVUCw6GgAS+3fCiOb4NrG7orVCeA4t1x7IE24+c2eoYcddQeqDJmjo0iQjOcgFWaQCbqq
	6qSd+rSBRbQ8QJPvXdLtfoQC1oVaNYbInTaTaPEVhKwja5Gzbn10nhYW9T1C1gWHoZn5YHKTC+iiv
	bWNDgIlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2Sa5-001ZC5-2F;
	Fri, 26 May 2023 08:13:49 +0000
Date: Fri, 26 May 2023 01:13:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com, hch@infradead.org,
	djwong@kernel.org, minchan@kernel.org, senozhatsky@chromium.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
	willy@infradead.org, hare@suse.de, p.raghav@samsung.com,
	da.gomez@samsung.com, rohan.puri@samsung.com, rpuri.linux@gmail.com,
	kbusch@kernel.org
Subject: Re: [PATCH v2 3/5] iomap: simplify iomap_init() with PAGE_SECTORS
Message-ID: <ZHBqPbMCsNHVRvkt@infradead.org>
References: <20230526073336.344543-1-mcgrof@kernel.org>
 <20230526073336.344543-4-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526073336.344543-4-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
