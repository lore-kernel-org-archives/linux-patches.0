Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E709768FD
	for <patches@lists.linux.dev>; Sun, 30 Jun 2024 22:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719786914; cv=none; b=BP9D4yioBgcnp1yfkp7UGZgrJCrRE7zUxRtSUOkQ+rBnrIas4JO6A/4oRhjbM43qAMSpN2UoTm1ePZWNxeVAgfRQM6vdCiErBA6OzeUDNv2SExM5ChswPJ4CEtFZau9zE/OOK6Dt4kDjLLUDWOArSd6UykWQj+yqAtMbo0o8g/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719786914; c=relaxed/simple;
	bh=olHEF/CxcDtNg9YfRCOEZ+NCP26E1OcephsrWQxAZ5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7jDAFBMe4EeCC3oQsio495K5skKv0KsUs2iykbA1AhqDOnlZ850yWRvsdGIYDTym0F40SUjk/B8ejrbICqdDLX53Ns+LSgITO+hRa0uSJTiBQBv+Wsm7pVNPDQJSsH1vyUNYzHsR5ZoVlpwbBQyxQyjTyRyGwLhx47AeoqQHq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=d47qWeTJ; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="d47qWeTJ"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-707040e3018so1659386a12.1
        for <patches@lists.linux.dev>; Sun, 30 Jun 2024 15:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719786911; x=1720391711; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tFdvTA2jm9AOGMhPq5Jodplbz8dr8Q0emY1A+Sy4FJc=;
        b=d47qWeTJt/4RrUI/jZofw0Urc6/fSOB8RNcZQ+yrh2mbhB2qJAlccr8WfTw0EwibUl
         1ljWFaktyLMyYI+MWz5SsRJQ72LUr7WPMSIx0Pje9ADGspZVuzhoda8++0oEZW6h8xGi
         MIuOB38/vyJPlQQ6cibT1qxfuU1xDAc6ET5H3X2g/1KmU3StAi9AFcfnAB1RLlS7DEIS
         Qw7qpj64Hvb8ZBGkImi4IOwlRT+UmHt1PvgzBSrs0ZXrAVGV+p63TlSH5ybb4e1/CLFE
         2DQxcFoa6S3+28E+Sk5+jBIp81HNp6s7shOrzdrwNUeL6xPUsZgSmRO62S3oAgJIstcP
         E22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719786911; x=1720391711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tFdvTA2jm9AOGMhPq5Jodplbz8dr8Q0emY1A+Sy4FJc=;
        b=ajVew7lXPjcAmO+mkz6yhlvE27V+PNIkHmfyZdp23k7rjdR01WF71HudqE7GrGOqnq
         xphMIoNwXaCpxHzAjMi9tdFNlMrWDepzu7NhP3t7hYHEUOy+ZjfkYRs2OhUXac64SHfk
         Xf0WcfVLPLxnDrFOmoJ8ayde/ZYLQS+mdpXz9hpWmoPz29VU9kHQZJcQS5x6Lh6tuvj+
         /oRpf4ZEK+K2wF9wcuH4S15HUkp3IhvYL7UjprTkexgTdEYC1jWWG9EWnfBovHWLoshi
         RYwpBJOssGuoH/J2/kNXchVOoUQpF82vH7QtElpjvGaY+zuab8r0/JzfKOkfRn0M1VBJ
         S5sA==
X-Forwarded-Encrypted: i=1; AJvYcCWgmIWVfzcpZRuP+mhiZT0AYXZxXSOmJjfWLIEYw0Q+TeMI6G3U5NOKWR6VfHfCxgcos8wpyOh8u0b3W4bEIu990uIXdM7BIw==
X-Gm-Message-State: AOJu0Yzs9z0bTbpLG1hesar37qfq5a1LJ6sek/xdp9kcoHHhsT2aKcjO
	xquVAWRGNlkY1YppGawgAEcxdwdmvrjDnFo1a+ByRNvDLane0u3BiYeYdlKkwvk=
X-Google-Smtp-Source: AGHT+IFhV6inGmU7og/3AUkaqs9u1n6LF9SGxpoTNxGW+Hih2rv0JBQ0f/5vD+1wQ4Kj9hRINXUQNQ==
X-Received: by 2002:a05:6a20:9145:b0:1bd:2710:de5c with SMTP id adf61e73a8af0-1bef610a250mr8119019637.22.1719786911318;
        Sun, 30 Jun 2024 15:35:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-708043b710fsm5112841b3a.156.2024.06.30.15.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 15:35:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO38W-00HExi-0c;
	Mon, 01 Jul 2024 08:35:08 +1000
Date: Mon, 1 Jul 2024 08:35:08 +1000
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com,
	ebiggers@google.com, p.raghav@samsung.com, hare@suse.de,
	kbusch@kernel.org, neilb@suse.de, gost.dev@samsung.com,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	patches@lists.linux.dev
Subject: Re: [RFC] bdev: use bdev_io_min() for statx DIO min IO
Message-ID: <ZoHdnKjCfDgoTOTD@dread.disaster.area>
References: <20240628212350.3577766-1-mcgrof@kernel.org>
 <Zn-o3jQj4RkJobjS@infradead.org>
 <ZoDP0LgeLV3H1JbB@bombadil.infradead.org>
 <ZoDzC1qlEYTBkLPA@infradead.org>
 <ZoHDRfMomK8hnDXI@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoHDRfMomK8hnDXI@bombadil.infradead.org>

On Sun, Jun 30, 2024 at 01:42:45PM -0700, Luis Chamberlain wrote:
> On Sat, Jun 29, 2024 at 10:54:19PM -0700, Christoph Hellwig wrote:
> > On Sat, Jun 29, 2024 at 08:24:00PM -0700, Luis Chamberlain wrote:
> > > > The minimum_io_size clearly is the minimum I/O size, not the minimal
> > > > nice to have one. 
> > > 
> > > I may have misread the below documentation then, because it seems to
> > > suggest this is a performance parameter, not a real minimum. Do we need
> > > to update it?
> > 
> > queue_limits.min_io is corretly described and a performance hint.
> 
> OK, great!
> 
> > The statx dio_offset_align is actual minimum I/O size and alignment and
> > not in any way related to the performance hint in minimum_io_size.
> 
> Oh, darn, I just read again 825cf206ed510 ("statx: add direct I/O
> alignment information") and the block layer change through commit
> 2d985f8c6b91b ("vfs: support STATX_DIOALIGN on block devices") and
> no where do I see any mention of it being  a min. Should we clarify
> that?

dio_offset_align is an _alignment_ parameter, not a "size"
parameter. In no way does it define either the absolute or "best
performance" minimum IO size - it just defines the minimum valid
alignment for the file offset that the filesystem/device supports.

It is implied that an IO of dio_offset_align bytes in length will be
supported, because that is the minimum length IO that meets the
offset alignment requirements defined by dio_offset_align. 

> And should we add a respective value for performance?

We could, but we already have:

	__u32 stx_blksize;     /* Block size for filesystem I/O */

which is defined as:

	stx_blksize
	      The "preferred" block size for efficient filesystem
	      I/O.  (Writing to a file in smaller chunks may cause
	      an inefficient read-modify-rewrite.)

> I suspect
> userspace will want to work with optimal values, not ones which
> could for instance incur read-modify-write.

Yup, that's the very definition of what stx_blksize should contain.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
