Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7989A8BFA
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 19:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiezyqeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66523C433C8;
	Tue, 10 Oct 2023 19:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696965291;
	bh=BSDTkfSliDJh1hJamT6NIQqA2Lma9R7fwRMAxVbfk0I=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=GiezyqeSuZjo6EyGyMJamQOzYujg6/uBOdZ3JfLBV6ouX21r5FqDbkqqkdAXIK6YC
	 SP3axBtvGFCAqOFb+5sYr5efqXpmKXyoUnjBO+Q1rZMcYvCBlK1F/OLeowZm6C8DTG
	 yj4D7R8vEuEsWoIFuTvrFKzOKymPYHqjUoZQjBuM=
Date: Tue, 10 Oct 2023 21:14:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Pavel Machek <pavel@denx.de>, niklas.soderlund+renesas@ragnatech.se,
	yoshihiro.shimoda.uh@renesas.com, geert+renesas@glider.be,
	biju.das.jz@bp.renesas.com, Chris.Paterson2@renesas.com,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: renesas_sdhi problems in 5.10-stable was Re: [PATCH 5.10
 000/226] 5.10.198-rc1 review
Message-ID: <2023101057-runny-pellet-8952@gregkh>
References: <20231009130126.697995596@linuxfoundation.org>
 <ZSRVgj5AqJbDXqZU@duo.ucw.cz>
 <ZSRe78MAQwbBdyFP@duo.ucw.cz>
 <ZSUy+zA0+Chm6dFb@duo.ucw.cz>
 <ZSU+GHl1q7T/TBp5@duo.ucw.cz>
 <ZSWg1fv3gOyV5t+h@shikoro>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSWg1fv3gOyV5t+h@shikoro>

On Tue, Oct 10, 2023 at 09:07:01PM +0200, Wolfram Sang wrote:
> Hi Pavel,
> 
> > And testing failed. So
> > 
> > commit f5799b4e142884c2e7aa99f813113af4a3395ffb
> > Author: Wolfram Sang <wsa+renesas@sang-engineering.com>
> > Date:   Tue Nov 10 15:20:57 2020 +0100
> > 
> >     mmc: renesas_sdhi: populate SCC pointer at the proper place
> >     
> >     [ Upstream commit d14ac691bb6f6ebaa7eeec21ca04dd47300ff5b6 ]
> > 
> > seems to be the buggy commit that breaks renesas boards in 5.10.
> 
> This patch was part of a series. Did the other two patches come with it?
> 
> b161d87dfd3d ("mmc: renesas_sdhi: probe into TMIO after SCC parameters have been setup")

Yes.

> 45bffc371fef ("mmc: renesas_sdhi: only reset SCC when its pointer is populated")

No :(

> If not, I could imagine that could lead to a crash. No idea why only
> with 5.10, though.

The above commit is only in 5.11, so newer kernels should be fine.

I'll go queue up the one missing patch now, thanks.

greg k-h
