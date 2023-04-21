Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D016FD7
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 22:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zJtElQBBcdjQLKuTgcAUU6SVKeCB/u/2QO+HYPXJ5yM=; b=TZu/Zi5uyNmtM3AYC5F+uKMVsg
	hHiw+cqzzyEH5I7hS1byjWvZbtD93wTW5QBG4M2KWk+B9WNSSwm8v8mi/Pnh/wNHKblwtRlS/KMzQ
	Ay3jyrkfXj38Eh37M4Cv7VwmsBNNmqrv9OwKF8lm0f+wSW4Om7abWzDRmsfs9KuyHuU0Imx3Q0AER
	ZAbNWgHZn5tbTJvEdgqX6vx58Jc1AstSfU9BdUtC5U+O8zrXvOcpy1sMmYqObWFFEt0xJw9Ase7ZL
	24pyTndrtdkUUd3SbhFseygDv/Okmg+4zGC/X9a2KfIdvJud/46SLd6TpOspXAPAEoF1aQEjJW7ON
	WDwf8KDw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1ppypq-00Bv2r-1H;
	Fri, 21 Apr 2023 22:02:30 +0000
Date: Fri, 21 Apr 2023 15:02:30 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com, hch@infradead.org,
	djwong@kernel.org, minchan@kernel.org, senozhatsky@chromium.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
	hare@suse.de, p.raghav@samsung.com, da.gomez@samsung.com,
	kbusch@kernel.org
Subject: Re: [PATCH 3/5] iomap: simplify iomap_init() with PAGE_SECTORS
Message-ID: <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-4-mcgrof@kernel.org>
 <ZELuiBNNHTk4EdxH@casper.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZELuiBNNHTk4EdxH@casper.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Apr 21, 2023 at 09:14:00PM +0100, Matthew Wilcox wrote:
> On Fri, Apr 21, 2023 at 12:58:05PM -0700, Luis Chamberlain wrote:
> > Just use the PAGE_SECTORS generic define. This produces no functional
> > changes. While at it use left shift to simplify this even further.
> 
> How is FOO << 2 simpler than FOO * 4?
> 
> > -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> > +	return bioset_init(&iomap_ioend_bioset, PAGE_SECTORS << 2,

We could just do:


-	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
+	return bioset_init(&iomap_ioend_bioset, 4 * PAGE_SECTORS,

The shift just seemed optimal if we're just going to change it.

  Luis
