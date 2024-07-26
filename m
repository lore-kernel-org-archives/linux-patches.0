Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6239522616;
	Fri, 26 Jul 2024 05:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721971294; cv=none; b=WVDoJIvwVLeIk8jQtVD7zQuhGvmUA+u5UPPYkoupD88HsPKNShFe3RPHZad3EBUvuQYzWLpM0Bj3NJdIKeliqzAnd+y/ON2iM/7UFawfvTBH96EBV2kCv5H1LhZtsaTSIequguUX/W8E1hZ72+Zi6vxfHVTM8XnQ2pWXOmGMLjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721971294; c=relaxed/simple;
	bh=cCkmTA6WrCb9XrS9ph2fBn7ImDGVbSaGCP7EGeMtqD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnqBzt8voc2hqom59S4l4ZbsbH6cYhDuSvchjZIv4MS7kWz9sqy1CT25vdC+DOORmB6nOSCiI2VNz6rnVY+T/Zr7PLaj3ANoayQMkUOyjnJ5Ph/ZUaKtIMAgQcQ9RMf0qrijM6YsJ7jYwP572fJq92lWIonoBQfny5wU35G7rlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DncAGBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DncAGBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808ECC32782;
	Fri, 26 Jul 2024 05:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721971293;
	bh=cCkmTA6WrCb9XrS9ph2fBn7ImDGVbSaGCP7EGeMtqD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1DncAGBBXd1UZriPVB0jTtSSA7OMvRZa565tsz9kEIss8UGfl8FZEXJ2bJC63f+aG
	 H3Xc0lRGxd9YjKZwIHTH2aGTXOcM+J6i45Gob0WV2P06gE0n3e4fZufcFX9naKaKES
	 NZIaZRfuJ5H42B7h8fn4fT/Ekr8qtFZ/z6R9ovh4=
Date: Fri, 26 Jul 2024 07:21:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 5.15 70/87] minmax: relax check to allow comparison
 between unsigned arguments and signed constants
Message-ID: <2024072659-edging-sloped-1a51@gregkh>
References: <20240725142738.422724252@linuxfoundation.org>
 <20240725142741.075359047@linuxfoundation.org>
 <CAHk-=whsVLP==D=VYGJUpuWaNbcB_nW-ZR5XBs_RddXgtLRiGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whsVLP==D=VYGJUpuWaNbcB_nW-ZR5XBs_RddXgtLRiGA@mail.gmail.com>

On Thu, Jul 25, 2024 at 09:58:51AM -0700, Linus Torvalds wrote:
> On Thu, 25 Jul 2024 at 07:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> I assume the min/max patches had some reason to be backported that is
> probably mentioned somewhere in the forest of patches, but I missed
> it.

It wasn't specifically called out here, but yes, they were needed for
the DAEMON fix.  And they will be needed in the future probably as well
because we have run into this problem many times when backporting
patches (i.e. the backport throws tons of warnings because the min/max
changes are not there.)

Same for 6.1.y, which is why they are there too.

> It's ok, but people are literally talking about this set of patches
> causing a big slowdown in building the kernel, with some files going
> from less than a second to build to being 15+ seconds because of the
> preprocessor expansion they can cause.

I saw that hopefully if that gets resolved in your tree we can backport
the needed changes here tool.

thanks,

greg k-h
