Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A0664A;
	Tue, 27 Aug 2024 16:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724774796; cv=none; b=AQNugwwhalE5bPSGe8dMq/bu1nyUFClHRagug+vexkarHbqU+ys3KMi92VAsmfjWjlC7Xf1YWwXX4vMTPyNh5c9Il+YbAf5mY/ZgEN/4r5TY2l8VXFZAwuYI6L7MpZqkfh1H5+ho+G1wVFkFEXNET/3pQw4kA7VhZa4tCTZzr4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724774796; c=relaxed/simple;
	bh=JW7JOo58wN9tCu7+RvlOCcsQ0sT32Uaxjwj6pWPrCv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qH4djPJYUiDQVltmMsHKn95O/ARXslE4/3SlJiy5q0RmnkhhoRXby1xSz5yxmu9SVOU0y+Bp0pcOc1iAATiq005iOhrZE0a2Yu72lLy2meXkAz8vDSuj1CtPAKlJjYiwnUmZHLZQ2yqrKZYirkziZ1kyuYwPNJM+vq8yfhEdKNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0NTtfa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0NTtfa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B701FC581B0;
	Tue, 27 Aug 2024 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724774796;
	bh=JW7JOo58wN9tCu7+RvlOCcsQ0sT32Uaxjwj6pWPrCv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N0NTtfa+WUEBc65GdCwsVj9wGCVJbF7WVi/aHECav0CN2oQk9fA6P8O0IP+R7fh2o
	 15Hbm8Ci3ZrjgU+WL9HQFZjXK6XBjaWlubYJIO8BXyYIIakKxSGMBybA5zPPdzaqej
	 3197hCHw1Fm1L+B5hVpcJiqwCZiNfFzHCzrjK9xw=
Date: Tue, 27 Aug 2024 18:06:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michael Grzeschik <mgr@pengutronix.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 110/341] usb: gadget: uvc: cleanup request when not
 in correct state
Message-ID: <2024082701-ivory-antibody-af9d@gregkh>
References: <20240827143843.399359062@linuxfoundation.org>
 <20240827143847.597379131@linuxfoundation.org>
 <Zs3q7KGX_i99-B4_@pengutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs3q7KGX_i99-B4_@pengutronix.de>

On Tue, Aug 27, 2024 at 05:04:12PM +0200, Michael Grzeschik wrote:
> On Tue, Aug 27, 2024 at 04:35:41PM +0200, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> Since this change is not actually in Mainline anymore as you reverted it
> immediatly afterwards, it probably make no sense to pick it up.
> 
> I saw this patch and its revert past me the last week while being
> applied on some other stable trees.

I took the revert as well.  That way our scripts don't try to pick it up
again in the future as they would go "hey, here's a patch you missed!"

thanks,

greg k-h
