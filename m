Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F30914AD2C;
	Mon,  2 Sep 2024 06:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725257008; cv=none; b=LVXNKHFES7HDle7G3iYfXOIuWzQUQkboRWwYIh+wVFNv9ySz429/P/94/l9Hk08WNbPMo89FVQdtU0t4EfVdupUNxYqfO0xbGyJRyZUdxPX/zsVYpEXLY7LF8UqENKA1UcgDjU32AcJvgWIAQELA+iHkEcNRke9PgP+2w6/Y/x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725257008; c=relaxed/simple;
	bh=WIKSdJ1VbN844gIw7Ur87DVvqmPZp7xgceKl5KUU6YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQN6GRgtxCx4tym7PfenUHpLKEY60nZ4AnnZ7RH+MnpamD9TI5RKLXcU3PZpjb3qCkyAtP4qxQYlG1slf04+1xUpI3BjYzrOtYKbr3/OrBB+XZqvOXQuyzCtBqpNyac2Kwi1qVvPLCfmpHuYFPEteX+i5k8JbXx5hmhSWxzLOag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+4A2oxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+4A2oxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C24C4CEC2;
	Mon,  2 Sep 2024 06:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725257008;
	bh=WIKSdJ1VbN844gIw7Ur87DVvqmPZp7xgceKl5KUU6YA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P+4A2oxxErRaAvaMnq5FlZfVOJ8pG927JOChtByeVQRZ1BY3iZAEL9Wo3LxWWnZ03
	 Mg7Swte3xgmLl/PKYiHBJrTn4Kzxu4VRas/x6nyQWrxMZeCxRqjeat27LxXpkd7EiP
	 WXd+bFwvRS6Kfk2LNcmKG/0LiUczmQUA+b8OErmI=
Date: Mon, 2 Sep 2024 08:03:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 130/151] Revert "Input: ioc3kbd - convert to
 platform remove callback returning void"
Message-ID: <2024090259-sultry-cartel-8e0e@gregkh>
References: <20240901160814.090297276@linuxfoundation.org>
 <20240901160818.998146019@linuxfoundation.org>
 <ZtURsofEb-WmU69f@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtURsofEb-WmU69f@codewreck.org>

On Mon, Sep 02, 2024 at 10:15:30AM +0900, Dominique Martinet wrote:
> Greg Kroah-Hartman wrote on Sun, Sep 01, 2024 at 06:18:10PM +0200:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This reverts commit 0096d223f78cb48db1ae8ae9fd56d702896ba8ae which is
> > commit 150e792dee9ca8416f3d375e48f2f4d7f701fc6b upstream.
> > 
> > It breaks the build and shouldn't be here, it was applied to make a
> > follow-up one apply easier.
> > 
> > Reported-by: Dominique Martinet <asmadeus@codewreck.org>
> 
> It's a detail but if you fix anything else in this branch I'd appreciate
> this mail being updated to my work address:
> Reported-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> 
> (Sorry for the annoyance, just trying to keep the boundary with stable
> kernel work I do for $job and 9p work on I do on my free time; if you're
> not updating the patches feel free to leave it that way - thanks for
> having taken the time to revert the commit in the first place!)

We can't really change things that are already in the tree, so we just
copy the commit directly from that, sorry.

thanks for the contribution!

greg k-h
