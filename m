Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2353F155A2F;
	Mon,  2 Sep 2024 07:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725260838; cv=none; b=EB4aHSLMLiKZb9CeEwoRfo6UMqlxumBYdwvjQeMxGWBwLwJBqiH/lrm+8u8+BjJm6PL7Zkx6Fu4pVtUVBHDxLBaTsXwouvVenB0EZw3IcUMb1+f8e3oIlYFPn1QVaqUagaBSBECqLG0HZkwMNc4tNIZUsOl4wRlEhaEpPkVud2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725260838; c=relaxed/simple;
	bh=KG3FfFVr0J5N9JkhiRWMquhd15fD18BTlr/nqhCv00g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6mykFV3wJ6Dd5yqY/xPhBeesgv/ORK2P77oKVvI9IvXn2QCDkBUCQbIzLgD2IzJdBvyLBL+ZEhUDSX2hqvnosz4eyRGSPjEIGBmG5lR0mbyTC1f5qUQaiuvn86TvPAPzJV3xzor8JEUA2QzIsr50ITlWYX39FiQCczR9hZvN2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q13wcI0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q13wcI0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CF2C4CEC2;
	Mon,  2 Sep 2024 07:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725260837;
	bh=KG3FfFVr0J5N9JkhiRWMquhd15fD18BTlr/nqhCv00g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q13wcI0QY7rDrnreizvYuyB7KSYgkhCnNh6pXIHQZXhLJQLSJTfBpsVric1syZoLu
	 9KKQsFoQhyD/ZeaJcc03avUSegb+SqqcepOTkeMYpfY1vqKLcDahMH7+L9p/TtJXk/
	 3P8CDgZ6tQympg38BMsge63ZvggAK2zkwV5omncE=
Date: Mon, 2 Sep 2024 09:07:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 130/151] Revert "Input: ioc3kbd - convert to
 platform remove callback returning void"
Message-ID: <2024090238-icky-unselect-3134@gregkh>
References: <20240901160814.090297276@linuxfoundation.org>
 <20240901160818.998146019@linuxfoundation.org>
 <ZtURsofEb-WmU69f@codewreck.org>
 <2024090259-sultry-cartel-8e0e@gregkh>
 <ZtVeWUa4L3F-EDc2@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtVeWUa4L3F-EDc2@codewreck.org>

On Mon, Sep 02, 2024 at 03:42:33PM +0900, Dominique Martinet wrote:
> Greg Kroah-Hartman wrote on Mon, Sep 02, 2024 at 08:03:24AM +0200:
> > On Mon, Sep 02, 2024 at 10:15:30AM +0900, Dominique Martinet wrote:
> > > Greg Kroah-Hartman wrote on Sun, Sep 01, 2024 at 06:18:10PM +0200:
> > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > 
> > > > This reverts commit 0096d223f78cb48db1ae8ae9fd56d702896ba8ae which is
> > > > commit 150e792dee9ca8416f3d375e48f2f4d7f701fc6b upstream.
> > > > 
> > > > It breaks the build and shouldn't be here, it was applied to make a
> > > > follow-up one apply easier.
> > > > 
> > > > Reported-by: Dominique Martinet <asmadeus@codewreck.org>
> > > 
> > > It's a detail but if you fix anything else in this branch I'd appreciate
> > > this mail being updated to my work address:
> > > Reported-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> > > 
> > > (Sorry for the annoyance, just trying to keep the boundary with stable
> > > kernel work I do for $job and 9p work on I do on my free time; if you're
> > > not updating the patches feel free to leave it that way - thanks for
> > > having taken the time to revert the commit in the first place!)
> > 
> > We can't really change things that are already in the tree, so we just
> > copy the commit directly from that, sorry.
> 
> This commit isn't in tree yet -- it's a patch specific to the 5.10
> branch that doesn't exist anywhere else (not a backport), and 5.10.225
> hasn't been tagged yet.
> 
> With that said I'll reiterate it's probably not worth the trouble,
> just replying because I don't understand where that "already in the
> tree" came from.

Ah, you are right, sorry about that.  Dealing with thousands of patches
here...

I'll go fix it up right now, not a problem.

greg k-h
