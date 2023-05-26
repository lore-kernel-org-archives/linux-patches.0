Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5049A93B
	for <patches@lists.linux.dev>; Fri, 26 May 2023 08:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0KbVHtLWzypQwk+AwZxRS0QdYzT+F7q/5Piz32xg/x8=; b=oRl19PBV9T5B9yEeGSQqipatMr
	PRxWWS4jGFgwZvrv2rWRlSzwLJe6REI6Iw0aokgq/vH/EAL6v9jQygHGuYq7IAnF5QH08o4NT968K
	2WA9NTHPmS0lkiCxEhYUlBxjFUW27zaMXt3/ooiriD0jmANXQzCRL/BsOujZeq4aKiOSQaOy+7lxa
	jfR8o0+4WFcujnWQe2iUrlHP5sbYbKQBGwHU7QU5YboV9aepiIdevTotLwapoePOafMrs17+7eYGn
	w7Sf9No/xGOC0HbZ6NCPNE4vV9O70l1asn9Tfmev+S2rMJKGCyyyyVAIKnLeQELhIup8qahAdq2Xn
	VMm3c4UQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2SgK-001aII-1S;
	Fri, 26 May 2023 08:20:16 +0000
Date: Fri, 26 May 2023 01:20:16 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com, djwong@kernel.org,
	minchan@kernel.org, senozhatsky@chromium.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
	willy@infradead.org, hare@suse.de, p.raghav@samsung.com,
	da.gomez@samsung.com, rohan.puri@samsung.com, rpuri.linux@gmail.com,
	kbusch@kernel.org
Subject: Re: [PATCH v2 1/5] block: annotate bdev_disk_changed() deprecation
 with a symbol namespace
Message-ID: <ZHBrwFk0d80IiOfV@bombadil.infradead.org>
References: <20230526073336.344543-1-mcgrof@kernel.org>
 <20230526073336.344543-2-mcgrof@kernel.org>
 <ZHBqGosY0tWkNdIR@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHBqGosY0tWkNdIR@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, May 26, 2023 at 01:13:14AM -0700, Christoph Hellwig wrote:
> On Fri, May 26, 2023 at 12:33:32AM -0700, Luis Chamberlain wrote:
> > This ensures no other users pop up by mistake easily and provides
> > us a with an easy vehicle to do the same with other routines should
> > we need it later.
> 
> I don't see how this is related to the rest of the seris.

Jessh, sorry it is too late here and that was a typo that the commit
went into the series. I'll go sleep now. This I just had queued
as a reminder for the new annotation for deprecated symbols to be
used in some situations.

Please ignore this patch.

  Luis
