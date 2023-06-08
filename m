Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F597947B
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=26X3eXQKS7NeIHOPgSnnyuKz8M8nhouJgb1HCFlt9gU=; b=oxnl+ytCH/AYLiO8lGsaGTSgAL
	YKAhmz3KWLG52xTtZ3vVlzOoXhqLAE+TSDLYtiUMLgMfWgpBomxV6NcPL6FCI9kZwk5bogGjZOPLI
	8QnbaKMgK9r0pLr5cxZR/iblydbJMDtaB1NxFguDycK5q8EbVJhgUczSAh/3xz4/50h2hd6QRO2Vb
	AJKily0ob+IT+C7Jr0UjGjkAuljbZavKlpTolZdO19kaSy3qPAuDfQRNQkFvlbYQt17NVlmUv2c/e
	feloqZah/8iJ6KrYviLmgJmxmK61OEwauO0fphZdNmbYWghbE9QuD17HBUBrSKATOW5r70soVneqm
	A6ckZIHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q7G1n-009W7J-1c;
	Thu, 08 Jun 2023 13:50:15 +0000
Date: Thu, 8 Jun 2023 06:50:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, hch@infradead.org,
	djwong@kernel.org, dchinner@redhat.com, kbusch@kernel.org,
	hare@suse.de, ritesh.list@gmail.com, rgoldwyn@suse.com,
	jack@suse.cz, patches@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	p.raghav@samsung.com, da.gomez@samsung.com, rohan.puri@samsung.com,
	rpuri.linux@gmail.com, corbet@lwn.net, jake@lwn.net
Subject: Re: [RFC 4/4] bdev: extend bdev inode with it's own super_block
Message-ID: <ZIHcl8epO0h3z1TO@infradead.org>
References: <20230608032404.1887046-1-mcgrof@kernel.org>
 <20230608032404.1887046-5-mcgrof@kernel.org>
 <ZIHZngefNAtYtg7L@casper.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIHZngefNAtYtg7L@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 08, 2023 at 02:37:34PM +0100, Matthew Wilcox wrote:
> On Wed, Jun 07, 2023 at 08:24:04PM -0700, Luis Chamberlain wrote:
> > We currently share a single super_block for the block device cache,
> > each block device corresponds to one inode on that super_block. This
> > implicates sharing one aops operation though, and in the near future
> > we want to be able to instead support using iomap on the super_block
> > for different block devices.
> 
> > -struct super_block *blockdev_superblock __read_mostly;
> 
> Did we consider adding
> 
> +struct super_block *blockdev_sb_iomap __read_mostly;
> 
> and then considering only two superblocks instead of having a list of
> all bdevs?

Or why the heck we would even do this to start with?  iomap has
absolutely nothing to do with superblocks.

Now maybe it might make sense to have a superblock per gendisk just
to remove all the weird special casing for the bdev inode in the
writeback code.  But that's something entirely different than this
patch.
