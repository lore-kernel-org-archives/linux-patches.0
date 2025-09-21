Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1EB2BB1D;
	Sun, 21 Sep 2025 17:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758475494; cv=none; b=RZo3mmyQo2ky0kPGrNQVZYvL6u3WieU47u2n4zswRKLNuBdxY9YdZRFFn9Q4sUMpsZXBW5A0NzvTy6aIjegfVLsm58Tp99BrTJyO92HaQ/Wkh6SxxEu5JQAEnrgKCj20jfZIs3aXugHVRQ/EaRD3MxcyerZRuTJd9dUwu2FzjGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758475494; c=relaxed/simple;
	bh=ziIw8zHZi1bTAvfiEfp/I6fPAbujvXqFx/tpiJJwPsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkIb5d7F/zQEZ80ykKIuKMwJ8YpUnaJxQKN+r1fVora4ROItAUiGU4B7cYOOAbXGSxPjsdzXMeWpvkTUadr1FiiMzNWHWyYkFuU3jAcR6DWbxAPDHYJ59ke4a+7Op8IsrKe/8rCqJr9+IUf0X6jnWd5YL4qVWMu42qP7PjnbbH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMmbKl1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMmbKl1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D650BC4CEE7;
	Sun, 21 Sep 2025 17:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758475494;
	bh=ziIw8zHZi1bTAvfiEfp/I6fPAbujvXqFx/tpiJJwPsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zMmbKl1y6pM+Y6DAcoYTfEFG0VWSMSQ2cCaURpAYOzFvMpYZ4aWRbqCt+5dE2axqt
	 oBdrkRI7CT0UN4IT/0NK+F8GZD7hBFVjpkIz6aNZrBEa9Oolyhl/obDn8ipZ0ctjdA
	 Z4TljxYhWjx9np4Bl8vkP9VGhh54zWHYoZjaCpRM=
Date: Sun, 21 Sep 2025 19:24:52 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jun Eeo <jeeo@janestreet.com>
Cc: hch@lst.de, martin.petersen@oracle.com, patches@lists.linux.dev,
	riel@surriel.com, sashal@kernel.org, stable@vger.kernel.org,
	tsi@tuyoix.net
Subject: Re: [PATCH 6.1 035/198] scsi: core: Use GFP_NOIO to avoid circular
 locking dependency
Message-ID: <2025092132-rentable-gleeful-855e@gregkh>
References: <2025091136-aside-tissue-59a7@gregkh>
 <20250911145412.537904-1-jeeo@janestreet.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911145412.537904-1-jeeo@janestreet.com>

On Thu, Sep 11, 2025 at 03:54:12PM +0100, Jun Eeo wrote:
> > Is this also a problem for you in newer kernels, like 6.16.y?
> 
> We haven't tried 6.16.y -- but we couldn't reproduce it on the 6.12
> branch (even with this commit) after leaving a couple of them to
> reboot repeatedly over ~5 days.
> 
> For reference on a 6.1 kernel with this patch, this happens after a
> couple of hours of auto rebooting.
> 

Odd.  If this is breaking stuff for you, then can you send a revert for
it for just the 6.1.y branch?

thanks,

greg k-h
