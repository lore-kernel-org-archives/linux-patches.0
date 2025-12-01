Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86BB302754;
	Mon,  1 Dec 2025 10:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764585418; cv=none; b=j3Jmrm5veVE713rK90vhBmJj9QYvAUYLWRXcnCybZyfKv2bkafg7CMACYS3mMdJsv7hFoHZIOgu2Jp5fK6RfrWvFRiOPx+Q3PnVLUMrT4Q3Su7e7FvqYxNUcY8vwWo2CZGmyxKdmP0EKQbiSosv6o+BxylMf1ii9R5VVsk1HMy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764585418; c=relaxed/simple;
	bh=lDOtC2DKo6+lBQLIM+J2AfS4RNUCCAd4Z3Bt/jf8vfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGvo0/EqHLeUxgfdZOdGIClEFrntlcFhhq78BnNfB/zsOaHn57PdgryTGEnUAw+swCjSi5jnRnAY/dKktJDz8JPBwuaW3+9EJcRSi3FmpxBHN818XROup/vxAFPllF7OqhZzkgLiCCMuNipI73laziHCaw6bF9MvVAZVaG0z9qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeYFmh+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeYFmh+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3E8C4CEF1;
	Mon,  1 Dec 2025 10:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764585417;
	bh=lDOtC2DKo6+lBQLIM+J2AfS4RNUCCAd4Z3Bt/jf8vfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HeYFmh+ZJtqaMD5xfZvsar4Tw2/UVHl1k/DUIqwuIdwX3M9T+La8map+kfqOotP8H
	 HQDwW/6L0iZeyZ03Ys8wcCzDS6d2FbUaHwFwqrZyoMvLJm6fb4bsPz7gGPw8v+W60Z
	 GbULR6cAfKGQBKpf/XHkQBMmLDzQrzBtdNQ0O0NI=
Date: Mon, 1 Dec 2025 11:36:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 6.17 026/175] MIPS: mm: Prevent a TLB shutdown on initial
 uniquification
Message-ID: <2025120146-prominent-thinning-d08b@gregkh>
References: <20251127144042.945669935@linuxfoundation.org>
 <20251127144043.919172913@linuxfoundation.org>
 <alpine.DEB.2.21.2511280601110.36486@angie.orcam.me.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2511280601110.36486@angie.orcam.me.uk>

On Fri, Nov 28, 2025 at 06:01:36AM +0000, Maciej W. Rozycki wrote:
> On Thu, 27 Nov 2025, Greg Kroah-Hartman wrote:
> 
> > 6.17-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Maciej W. Rozycki <macro@orcam.me.uk>
> > 
> > commit 9f048fa487409e364cf866c957cf0b0d782ca5a3 upstream.
> 
>  So this caused a regression for a subset of systems.  A fix is in review,
> so I think this will best be dropped at this point and then cherry-picked
> along the fix.  I've arranged for this to happen via patch prerequisites
> already.  Please let me know if there's an issue with this approach.

Now dropped from all stable queues, thanks!

greg k-h
