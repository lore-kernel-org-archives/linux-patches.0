Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20B679CF
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 07:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B0FC433C8;
	Tue, 19 Sep 2023 07:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695110256;
	bh=fLeSnVOwCSP/qTkJ10w9VhO6v1axFiLn6qQ2n1WA6z4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PZEuIVToE7yJGyBKwrS2QRed5jbLqeMRpY+H5udWwEbb2UAJZ96zMpn2Ayem5b6n0
	 2XskIGygIR11xgP843UcpyHw0qNzIAjilbwjaOyHMZmaW6WDqSN1dauM9gPWj68D5c
	 2jF6BOtjqlDNarJYV5JjgPdwKgunNmUryNJJHrgc=
Date: Tue, 19 Sep 2023 09:57:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 261/406] leds: Fix BUG_ON check for
 LED_COLOR_ID_MULTI that is always false
Message-ID: <2023091901-vessel-giggling-55ee@gregkh>
References: <20230917191101.035638219@linuxfoundation.org>
 <20230917191108.094879104@linuxfoundation.org>
 <20230918160004.3511ae2e@dellmb>
 <2023091836-papaya-jackknife-2867@gregkh>
 <20230918181727.74a28f4a@dellmb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230918181727.74a28f4a@dellmb>

On Mon, Sep 18, 2023 at 06:17:27PM +0200, Marek Behún wrote:
> On Mon, 18 Sep 2023 17:22:59 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Mon, Sep 18, 2023 at 04:00:04PM +0200, Marek Behún wrote:
> > > Greg, please drop this patch from both 5.10 and 5.15.
> > > 
> > > Reference: 
> > >   https://lore.kernel.org/linux-leds/ZQLelWcNjjp2xndY@duo.ucw.cz/T/  
> > 
> > But this is already in released kernels:
> > 	6.1.53 6.4.16 6.5.3 6.6-rc1
> > 
> > > I am going to send a fix to drop the check altogether.  
> > 
> > We will be glad to queue up the fix as well when it hits Linus's tree,
> > please be sure to tag it for stable backporting so we can get it in all
> > locations.
> > 
> > But for now, being bug-compatible makes more sense, right?  Or is this
> > really critical and should not be in these kernels now?
> 
> According to that e-mail, the patch breaks booting for some systems, so
> if it would be possible to avoid it...
> 
> I've sent a fixup patch which removes the BUG_ON altogether, and
> referenced the patch that broke booting in the Fixes tag. But I don't
> know how long it will take to hit Linus' tree, it may take several
> weeks.

Ok, thanks, now dropped from these trees.  Please pester the maintainers
to get this merged into Linus's tree soon so that the other stable trees
can be fixed up as well.

greg k-h
