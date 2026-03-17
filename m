Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44D21922F5;
	Tue, 17 Mar 2026 04:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773722554; cv=none; b=WJqeojJ0Lbc7pA1gOUSfyNCYSz5e+SvwZZhfe9nSpK7rGQqnwBHxf2/QWSYgg41hhqbPbwHDAa1GpamiQ1L1SuEa1lqeSnY4zXzhpIU2cM2hO3VGE5P+2S/kpayBzIO+jsEpk+ss4h5LnjxTNFtGN4OSCZ2ho6YerzS/lz5fHsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773722554; c=relaxed/simple;
	bh=gRznmthyaztYYX9C1fOAny2nKdQ5LS/ZDUatarmEMfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TmD02k4ANLxhiWWJNCPspIWHASe/0o169Q9w9eQEfb7w8UgTtTMBQSoyeDIS0uTvCT5YsTWbBo0wca3UGrTb2z2Hw5DECkDyN5JfwPXyhTRWCk4w/zW1E4MejaKnxXKwVW102BEpY+VCK7r49Hv6tqowKIvlbfw47jODxDVjALM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1kLCdEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1kLCdEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B95C4CEF7;
	Tue, 17 Mar 2026 04:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773722554;
	bh=gRznmthyaztYYX9C1fOAny2nKdQ5LS/ZDUatarmEMfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V1kLCdEpHVjyTfl+xUm/AFwXy02Abbcj1tCsztx6HfTNiLRN5zCZOUfQ+1EsQziAl
	 bhNr2VZfo4thhMV3ljC2tVJV31PVXtufIqGc74EIIjnK7p58EgCns/1wKXIbnR7H46
	 B8nU3AuHi3Dl56D9FDrbQD0gJpefkT+E8Cus/V+A=
Date: Tue, 17 Mar 2026 05:42:14 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
Message-ID: <2026031738-glade-glamorous-eacd@gregkh>
References: <20260302160955.2522727-1-sashal@kernel.org>
 <20260305220801.GA3148061@ax162>
 <20260316220533.GD1329928@ax162>
 <abiuxFzZNLKbhz6F@laps>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abiuxFzZNLKbhz6F@laps>

On Mon, Mar 16, 2026 at 09:30:44PM -0400, Sasha Levin wrote:
> On Mon, Mar 16, 2026 at 03:05:33PM -0700, Nathan Chancellor wrote:
> > On Thu, Mar 05, 2026 at 03:08:09PM -0700, Nathan Chancellor wrote:
> > > On Mon, Mar 02, 2026 at 11:09:55AM -0500, Sasha Levin wrote:
> > > > Jamie Iles (1):
> > > >   i3c: remove i2c board info from i2c_dev_desc
> > > 
> > > You missed commit 6cbf8b38dfe3 ("i3c: fix uninitialized variable use in
> > > i2c setup") as a fix for this one, as rightfully pointed out by clang:
> > > 
> > >   https://lore.kernel.org/177198114226.2577.15577566399399369654@d14e337afe00/
> > > 
> > >   $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper allmodconfig drivers/i3c/master.o
> > >   drivers/i3c/master.c:2203:3: error: variable 'i2cdev' is uninitialized when used here [-Werror,-Wuninitialized]
> > >    2203 |                 i2cdev->dev = i2c_new_client_device(adap, &i2cboardinfo->base);
> > >         |                 ^~~~~~
> > > 
> > > I guess that report was missed because it was not actually addressed to
> > > anyone?
> > > 
> > > FWIW, this patch appeared in a previous 5.15-rc release but Ben
> > > rightfully pointed out it really was not necessary and Greg said he
> > > would fix it up by hand:
> > > 
> > >   https://lore.kernel.org/2026011724-florist-brook-5f1f@gregkh/
> > > 
> > > Guess that never happened?
> > 
> > Ping? I don't see 6cbf8b38dfe3 queued up in 5.15 and this continues to
> > break our builds:
> > 
> >  https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/23093834605
> 
> Hm, I queued it up, but looks like Greg dropped it:
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=7c0d6910ad
> 
> I'm not sure why.

I am guessing that it broke some type of build, and so I figured it was
safer to just drop them all.  I'll try it again later today, sorry about
that...

greg k-h
