Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999502CA6
	for <patches@lists.linux.dev>; Fri, 26 May 2023 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V7pSq7PJnnV+17c0PLHAsV81o6PiUmwa5c8k+OK0j2c=; b=HKC5GqVxZdX8wRhS+hcBeYXxlV
	UI5ei/MYN07YXASmtoH6v/hoXh1Z8WEJPAFULInxGzMig6H2DvnQbp8R6exL/GuEEF9na0UaYo3mF
	feu8hcR1fY/coNq+BfeGDyrVIxdo+3Zr2xL1BkgKf4SGlbCiKxNzebiwgVD0ZIhF5OLWP6VVp1dTg
	i6lT2nciuafF13kv1/76VfXv8qQK1HKnByvMoN0YpS67HFjhUyV2wx1t8SLakmsRFiyTVOFo80sqU
	+6/TDGsJ463twtBFUdkp/BgnQrLfbuKgPP9CDetYozGKolTok9W2usghuCeSXCuz7iF5CZgfsLndp
	A8DElMFw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2bK5-003Jgz-38;
	Fri, 26 May 2023 17:33:53 +0000
Date: Fri, 26 May 2023 10:33:53 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: hughd@google.com, akpm@linux-foundation.org, brauner@kernel.org,
	djwong@kernel.org, p.raghav@samsung.com, da.gomez@samsung.com,
	rohan.puri@samsung.com, rpuri.linux@gmail.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/8] add support for blocksize > PAGE_SIZE
Message-ID: <ZHDtgdhauy0RZPeU@bombadil.infradead.org>
References: <20230526075552.363524-1-mcgrof@kernel.org>
 <ZHC6BM+ehSC5Atv8@casper.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHC6BM+ehSC5Atv8@casper.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, May 26, 2023 at 02:54:12PM +0100, Matthew Wilcox wrote:
> On Fri, May 26, 2023 at 12:55:44AM -0700, Luis Chamberlain wrote:
> > This is an initial attempt to add support for block size > PAGE_SIZE for tmpfs.
> > Why would you want this? It helps us experiment with higher order folio uses
> > with fs APIS and helps us test out corner cases which would likely need
> > to be accounted for sooner or later if and when filesystems enable support
> > for this. Better review early and burn early than continue on in the wrong
> > direction so looking for early feedback.
> 
> I think this is entirely the wrong direction to go in.

Any recommendations for alternative directions?

> You're coming at this from a block layer perspective, and we have two
> ways of doing large block devices -- qemu nvme and brd.  tmpfs should
> be like other filesystems and opportunistically use folios of whatever
> size makes sense.

I figured the backing block size would be a good reason to use high
order folios for filesystems, and this mimicks that through the super
block block size. Although usage of the block size would be moved to
the block device and tmpfs use an page order, what other alternatives
were you thinking?

  Luis
