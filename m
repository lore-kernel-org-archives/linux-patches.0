Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E15136C
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 03:05:35 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6c0b727c1caso2711626a34.0
        for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695006334; x=1695611134; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YOlGLyQ8loARGbE2lHqjvejFsqqyE9jwiImy/tuZdcM=;
        b=dqFQFL07ZvY3E91Ogx54WxYsHQEzdH5adurWeZdnbcUJ4/nJemfRdfaF2o+lAy9Wr8
         n7BF97ErxqhuvzwQIvztf1f0SbrHrGYDKvXEtYgSxDQftD9VUflIbVvxABTL5L+mBoGh
         4jtXfVbuH9UGTUy5kAQm1zSWHup5D/zo+4Rxl89ifeg5NO9XwhTnN/eIjI8BBO+YLz1u
         x8KZYOkpnP22VQM+ODB+Aaz5IxN6F2Km1r/279QAIxli3ZnZJ7pCrf0r745Al0bqexDN
         EmD2bu7Rz7mwFz0r4a7RstsGsVW3WYLjGE9JyWrr/8q3pL7z7RxIM4uaagLn+bm8Xis8
         BySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695006334; x=1695611134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOlGLyQ8loARGbE2lHqjvejFsqqyE9jwiImy/tuZdcM=;
        b=D7babTVgAyX2qkm3/h5h2FgdshLk69lZMtcwsFccK5OvCmba5T04QigCVVmMnOWjrB
         /o7QgYzgNvN1IkIOyzdTEJRjs08IZ6SJomSKvO2tt8E+tGmoc2uBm2zODucW1pTiYVUe
         0rKZpdY7eFLUQSFNqZ9vcIAeDGry+Q6CvZQartVeHF1I3UiQzdWtE4GefrnsG0jUHhFu
         7tyRSq93IWEQuOFwg/J1H0Jpv7OH8txIqaWhmif7cpLBTfj/4jNW213Kqp/sANcLkD5f
         Y6c/6NyXwRklo1ciS+o+wPmf82XfTA+2kuxNTzRpxyzDqYd32tll/MPZUu8M3Stz2rjg
         O0Xg==
X-Gm-Message-State: AOJu0YwqaIQXoKQHPJUELO0e/OfzCUazyuh9m/m2eju8Pr8H6quGrAXp
	ZNSUmo8oNdxBM3BHkjV9zM7f1A==
X-Google-Smtp-Source: AGHT+IFVeZgktWHBryXzRPN4nSQq3uIjnqc0qYg+kBqmZljfpbksGqwWRWHu4LUdXyaAMF/Te5aYSw==
X-Received: by 2002:a05:6358:9219:b0:13a:4855:d885 with SMTP id d25-20020a056358921900b0013a4855d885mr8911262rwb.10.1695006334432;
        Sun, 17 Sep 2023 20:05:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id 8-20020aa79208000000b0064f76992905sm6246981pfo.202.2023.09.17.20.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Sep 2023 20:05:33 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1qi4KO-002AhX-0e;
	Mon, 18 Sep 2023 12:49:36 +1000
Date: Mon, 18 Sep 2023 12:49:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, hch@infradead.org,
	djwong@kernel.org, dchinner@redhat.com, kbusch@kernel.org,
	sagi@grimberg.me, axboe@fb.com, brauner@kernel.org, hare@suse.de,
	ritesh.list@gmail.com, rgoldwyn@suse.com, jack@suse.cz,
	ziy@nvidia.com, ryan.roberts@arm.com, patches@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, p.raghav@samsung.com,
	da.gomez@samsung.com, dan.helmick@samsung.com
Subject: Re: [RFC v2 00/10] bdev: LBS devices support to coexist with
 buffer-heads
Message-ID: <ZQe6wBxRFE7yY3eQ@dread.disaster.area>
References: <20230915213254.2724586-1-mcgrof@kernel.org>
 <ZQd/7RYfDZgvR0n2@dread.disaster.area>
 <ZQeIaN2WC+whc/OP@casper.infradead.org>
 <ZQeg2+0X6yzGL1Mx@dread.disaster.area>
 <ZQekRLRXpoGu7VQ+@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQekRLRXpoGu7VQ+@bombadil.infradead.org>

On Sun, Sep 17, 2023 at 06:13:40PM -0700, Luis Chamberlain wrote:
> On Mon, Sep 18, 2023 at 10:59:07AM +1000, Dave Chinner wrote:
> > On Mon, Sep 18, 2023 at 12:14:48AM +0100, Matthew Wilcox wrote:
> > > On Mon, Sep 18, 2023 at 08:38:37AM +1000, Dave Chinner wrote:
> > > > On Fri, Sep 15, 2023 at 02:32:44PM -0700, Luis Chamberlain wrote:
> > > > > LBS devices. This in turn allows filesystems which support bs > 4k to be
> > > > > enabled on a 4k PAGE_SIZE world on LBS block devices. This alows LBS
> > > > > device then to take advantage of the recenlty posted work today to enable
> > > > > LBS support for filesystems [0].
> > > > 
> > > > Why do we need LBS devices to support bs > ps in XFS?
> > > 
> > > It's the other way round -- we need the support in the page cache to
> > > reject sub-block-size folios (which is in the other patches) before we
> > > can sensibly talk about enabling any filesystems on top of LBS devices.
> > >
> > > Even XFS, or for that matter ext2 which support 16k block sizes on
> > > CONFIG_PAGE_SIZE_16K (or 64K) kernels need that support first.
> > 
> > Well, yes, I know that. But the statement above implies that we
> > can't use bs > ps filesytems without LBS support on 4kB PAGE_SIZE
> > systems. If it's meant to mean the exact opposite, then it is
> > extremely poorly worded....
> 
> Let's ignore the above statement of a second just to clarify the goal here.
> The patches posted by Pankaj enable bs > ps even on 4k sector drives.

Yes. They also enable XFS to support bs > ps on devices up to 32kB
sector sizes, too. All the sector size does is define the minimum
filesystem block size that can be supported by the filesystem on
that device and apart from that we just don't care what the sector
size on the underlying device is.

> This patch series by definition is suggesting that an LBS device is one
> where the minimum sector size is > ps, in practice I'm talking about
> devices where the logical block size is > 4k, or where the physical
> block size can be > 4k.

Which XFS with bs > ps just doesn't care about. As long as the
logical sector size is a power of 2 between 512 bytes and 32kB, it
will just work.

> There are two situations in the NVMe world where
> this can happen. One is where the LBA format used is > 4k, the other is
> where the npwg & awupf | nawupf is > 4k. The first makes the logical

FWIW, I have no idea what these acronyms actually mean....

> block size > 4k, the later allows the physical block size to be > 4k.
> The first *needs* an aops which groks > ps on the block device cache.
> The second let's you remain backward compatible with 4k sector size, but
> if you want to use a larger sector size you can too, but that also
> requires a block device cache which groks > ps. When using > ps for
> logical block size of physical block size is what I am suggesting we
> should call LBS devices.

Sure. LBS means sector size > page size for the block device. That
much has always been clear.

But telling me that again doesn't explain what LBS support has to do
with the filesystem implementation. mkfs.xfs doesn't require LBS
support to make a new XFS filesystem with a 32kB sector size and
64kB filessytem block size.  For the mounted filesystem that
supports bs > ps, it also doesn't care about the device sector size
is smaller than what mkfs told it to us. e.g. this is how run 4kB
sector size filesystem testing on 512 byte sector devices today....

What I'm asking is why LBS support even mentions filesystems? It's
not necessary for filesystems to support bs > ps for LBS to be
implemented, and it's not necessary for LBS to be supported for
filesytsems to implement bs > ps. Conflating them seems a recipe
for confusion....

> > > > > There might be a better way to do this than do deal with the switching
> > > > > of the aops dynamically, ideas welcomed!
> > > > 
> > > > Is it even safe to switch aops dynamically? We know there are
> > > > inherent race conditions in doing this w.r.t. mmap and page faults,
> > > > as the write fault part of the processing is directly dependent
> > > > on the page being correctly initialised during the initial
> > > > population of the page data (the "read fault" side of the write
> > > > fault).
> > > > 
> > > > Hence it's not generally considered safe to change aops from one
> > > > mechanism to another dynamically. Block devices can be mmap()d, but
> > > > I don't see anything in this patch set that ensures there are no
> > > > other users of the block device when the swaps are done. What am I
> > > > missing?
> > > 
> > > We need to evict all pages from the page cache before switching aops to
> > > prevent misinterpretation of folio->private. 
> > 
> > Yes, but if the device is mapped, even after an invalidation, we can
> > still race with a new fault instantiating a page whilst the aops are
> > being swapped, right? That was the problem that sunk dynamic
> > swapping of the aops when turning DAX on and off on an inode, right?
> 
> I was not aware of that, thanks!
> 
> > > If switching aops is even
> > > the right thing to do.  I don't see the problem with allowing buffer heads
> > > on block devices, but I haven't been involved with the discussion here.
> > 
> > iomap supports bufferheads as a transitional thing (e.g. for gfs2).
> 
> But not for the block device cache.

That's why I'm suggesting that you implement support for bufferheads
through the existing iomap infrastructure instead of trying to
dynamically switch aops structures....

> > Hence I suspect that a better solution is to always use iomap and
> > the same aops, but just switch from iomap page state to buffer heads
> > in the bdev mapping 
> 
> Not sure this means, any chance I can trouble you to clarify a bit more?

bdev_use_buggerheads()
{
	/*
	 * set the bufferhead bit atomically with invalidation emptying the
	 * page cache to prevent repopulation races. 
	 */
	filemap_invalidate_lock()
	invalidate_bdev()
	if (turn_on_bufferheads)
		set_bit(bdev->state, BDEV_USE_BUFFERHEADS);
	else
		clear_bit(bdev->state, BDEV_USE_BUFFERHEADS);
	filemap_invalidate_unlock()
}

bdev_iomap_begin()
{
	.....
	if (test_bit(bdev->state, BDEV_USE_BUFFERHEADS))
		iomap->flags |= IOMAP_F_BUFFER_HEAD;
}

/*
 * If an indexing switch happened while processing the iomap, make
 * sure to get the iomap marked stale to force a new mapping to be
 * looked up.
 */
bdev_iomap_valid()
{
	bool need_bhs = iomap->flags & IOMAP_F_BUFFER_HEAD;
	bool use_bhs = test_bit(bdev->state, BDEV_USE_BUGGERHEADS);

	return need_bhs == use_bhs;
}

-Dave.
-- 
Dave Chinner
david@fromorbit.com
