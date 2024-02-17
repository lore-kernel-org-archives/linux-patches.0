Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E307C0A4;
	Sat, 17 Feb 2024 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708186292; cv=none; b=p+fcXoGt2X2lb2nNV3XC5ID6vKl0Wz7SdCUA922DvYejs8X+ROH84QCiAiE744buf4AiDcszC48BpQ8H+qR20c61AXaCfEjRT23i+waDCccFU07ekvJZAESjhLNeeQZhddaCg6P/E0YXQg6GzNjfAGXh80WxZn76YZKamVv4X0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708186292; c=relaxed/simple;
	bh=oPlVlm9378zlUZ+wR2Hax7wbNZlVewkBYiguLyayWWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6zdBUZw0uG5xqdAvYiuzm2jW3H+UjM9PqnzXjpk+HtcoLYFXlkZYdWrJOJsR6GFfIZNqbkQat4MptZ8iE8ujlK4urI62Qbd+MaApTN+YSmzuhKPVRqZECtk5YrVapkXJJcAXo7dNUUJ4ocdPMhOlT+g51GPFV3sB99oBWrnRdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHfgw3WF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHfgw3WF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA28FC433F1;
	Sat, 17 Feb 2024 16:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708186291;
	bh=oPlVlm9378zlUZ+wR2Hax7wbNZlVewkBYiguLyayWWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IHfgw3WFqUQCeSVquZ5BOoomLPJWOwEz4X5+4e2ERNUPQWcWjKuyr2uHEQGYGlHp5
	 FPRad0qLNDq2t33lB/BsLmSInBVltwgmVoI4IJtu3Xs0tDw8gvXOo81NR3jAziVnoX
	 bT7WaL0GWTNOgZdSMhatjuAIpv/P1WJsIpGTR1zE=
Date: Sat, 17 Feb 2024 17:11:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, stable@vger.kernel.org,
	patches@lists.linux.dev, Frank Wang <frank.wang@rock-chips.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.7 093/124] Revert "usb: typec: tcpm: fix cc role at
 port reset"
Message-ID: <2024021752-shorty-unwarlike-671d@gregkh>
References: <20240213171853.722912593@linuxfoundation.org>
 <20240213171856.446249309@linuxfoundation.org>
 <571afc70-dd77-4678-bdd0-673e15cdd5ad@leemhuis.info>
 <2024021630-unfold-landmine-5999@gregkh>
 <ZdDS4drripFkFqJp@finisterre.sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdDS4drripFkFqJp@finisterre.sirena.org.uk>

On Sat, Feb 17, 2024 at 03:38:09PM +0000, Mark Brown wrote:
> On Fri, Feb 16, 2024 at 07:46:13PM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Feb 16, 2024 at 07:54:42AM +0100, Thorsten Leemhuis wrote:
> 
> > > TWIMC, that patch (which is also queued for the next 6.6.y-rc) afaics is
> > > causing boot issues on rk3399-roc-pc for Mark [now CCed] with mainline.
> > > For details see:
> 
> > > https://lore.kernel.org/lkml/ZcVPHtPt2Dppe_9q@finisterre.sirena.org.uk/https://lore.kernel.org/all/20240212-usb-fix-renegade-v1-1-22c43c88d635@kernel.org/
> 
> > Yeah, this is tough, this is a revert to fix a previous regression, so I
> > think we need to stay here, at the "we fixed a regression, but the
> > original problem is back" stage until people can figure it out and
> > provide a working change for everyone.
> 
> Given that nobody from the USB side seems to have shown much interest in
> fixing this since I reported the regression should we not just be
> reverting whatever it was that triggered the need for the original
> revert (it's really not clear from the changelog...)?  I got no response
> other than an "I said that would happen" to my initial report, then the
> revert triggered a half done patch which I can't really judge given my
> lack of familiarity with the code here but that's not been submitted as
> an actual patch.
> 
> The board has been working for years (at least three prior to the
> initial revert of "usb: typec: tcpm: fix cc role at port reset" which
> was only applied last June), presumably whatever the original revert was
> intended to fix has been there for a while?
> 
> This getting backported to older stables is breaking at least this board
> in those stables, and I would tend to rate a "remove all power from the
> system" bug at the very high end of the severity scale while the
> reverted patch was there for six months and several kernel releases.

Ok, that's different, I'll queue your revert for the revert up on Monday
and get this fixed up as that's not ok.

thanks,

greg k-h

