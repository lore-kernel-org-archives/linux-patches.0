Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDB61843
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 22:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=HB77AFqGG2aBz+Earrmv/XakHzRKihV+YVKN5AMto9w=; b=4FAhsMmpd9R2NNkxWh/EOySpZr
	3xMTf/cJ0+PNnJ2jbCGrZ6Gm69S6q3oAJkQ5yxUgkzhcpqqnYZvVCHMRG8Q44ftomMGgGmtsv/8/X
	hLnbhCDJuUrYaDwBuiiHWOQXrGjbspvupGp/eN9bsdk3b24WwsY/XkPvVT5hwOMnBBpGjaVdxENjr
	JoSB/n2YtzxQjl7qJQXY3ceKtXXJY4bChFW37Up6awJh/gBfz/LWtS/CSRHQfrPbEyn5NMMZ8oBKk
	1goaCU9P4Fulz/XxFCHiY4WPfQQd0fy3A/4pu1F6QjPYE6VPjaXVeuxuTCdmZo1zkvy/1rmg6rqcb
	/nt47FEw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1ppzGj-00BxAj-0p;
	Fri, 21 Apr 2023 22:30:17 +0000
Date: Fri, 21 Apr 2023 15:30:17 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>, agk@redhat.com,
	snitzer@kernel.org, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
	hch@infradead.org, djwong@kernel.org, minchan@kernel.org,
	senozhatsky@chromium.org, patches@lists.linux.dev,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, drbd-dev@lists.linbit.com,
	linux-kernel@vger.kernel.org, hare@suse.de, p.raghav@samsung.com,
	da.gomez@samsung.com, kbusch@kernel.org
Subject: Re: [PATCH 3/5] iomap: simplify iomap_init() with PAGE_SECTORS
Message-ID: <ZEMOeb9Bt60jxV+d@bombadil.infradead.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-4-mcgrof@kernel.org>
 <ZELuiBNNHTk4EdxH@casper.infradead.org>
 <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
 <47688c1d-9cf1-3e08-1f1d-a051b25d010e@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47688c1d-9cf1-3e08-1f1d-a051b25d010e@kernel.dk>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Apr 21, 2023 at 04:24:57PM -0600, Jens Axboe wrote:
> On 4/21/23 4:02 PM, Luis Chamberlain wrote:
> > On Fri, Apr 21, 2023 at 09:14:00PM +0100, Matthew Wilcox wrote:
> >> On Fri, Apr 21, 2023 at 12:58:05PM -0700, Luis Chamberlain wrote:
> >>> Just use the PAGE_SECTORS generic define. This produces no functional
> >>> changes. While at it use left shift to simplify this even further.
> >>
> >> How is FOO << 2 simpler than FOO * 4?
> >>
> >>> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> >>> +	return bioset_init(&iomap_ioend_bioset, PAGE_SECTORS << 2,
> > 
> > We could just do:
> > 
> > 
> > -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> > +	return bioset_init(&iomap_ioend_bioset, 4 * PAGE_SECTORS,
> > 
> > The shift just seemed optimal if we're just going to change it.
> 
> It's going to generate the same code, but the multiplication is arguably
> easier to read (or harder to misread).

Then let's stick with the 4 * PAGE_SECTORS. Let me know if you need another
patch.

  Luis
